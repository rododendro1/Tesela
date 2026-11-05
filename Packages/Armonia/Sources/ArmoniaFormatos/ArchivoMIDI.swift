import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Exportación a MIDI: ficheros MIDI estándar (SMF, formato 1), que se oyen en cualquier
// reproductor, secuenciador o editor de partituras.
//
// La primera pista lleva el título, el tempo, el compás y la armadura; cada una de las demás,
// una voz con su nombre. Las notas ligadas suenan como una sola. Las alturas fuera del rango
// MIDI (0…127) se omiten. Los textos van en Latin-1, que es lo que esperan casi todos los
// programas, con las alteraciones en ASCII (Mib, F#).
//
// Los microtonos (los desvíos de cada evento y, si se pide, los de una afinación) suenan como inflexiones de tono
// (pitch bend). Como la inflexión mueve todo un canal, las notas que suenan a la vez y se apartan distinto van cada
// una a su canal, con el mismo instrumento: los que no son de ninguna voz, sin el 10.

// MARK: - Escritor

/// Un fichero MIDI estándar de formato 1: una pista de control y una por voz.
package struct ArchivoMIDI {
    package let compas: Compas
    package let tonalidad: Tonalidad?
    package let tempo: Tempo?
    package let titulo: String?
    /// La afinación en que suenan las notas; si es `nil`, el temperamento igual (con los desvíos de cada evento).
    package let afinacion: (any Afinacion)?
    private var pistas: [(eventos: [Evento], nombre: String, instrumento: Int, marcadores: [String])] = []

    package init(
        compas: Compas, tonalidad: Tonalidad?, tempo: Tempo?, titulo: String?, afinacion: (any Afinacion)? = nil
    ) {
        self.compas = compas
        self.tonalidad = tonalidad
        self.tempo = tempo
        self.titulo = titulo
        self.afinacion = afinacion
    }

    /// Una pista con los eventos, en el canal siguiente (sin usar el 10, el de percusión; los que sobran, para las
    /// notas que se apartan distinto de las que suenan a la vez).
    /// `marcadores`, si se dan, uno por evento. Un instrumento fuera de los de General MIDI (0…127) se lleva al más
    /// cercano.
    package mutating func anadir(_ eventos: [Evento], nombre: String, instrumento: Int, marcadores: [String] = []) {
        pistas.append((eventos, nombre, min(max(instrumento, 0), 127), marcadores))
    }

    /// Pulsos de reloj por negra: 480 o 960, como es habitual, si con ellos todas las duraciones
    /// son enteras; si no, el primer múltiplo de los justos que llegue a 480.
    package var divisiones: Int {
        let base = Exportacion.divisiones(pistas.flatMap { $0.eventos.map(\.duracion) })
        if let habitual = [480, 960].first(where: { $0 % base == 0 }) { return habitual }
        guard base <= 32767 else { return 960 } // grupos muy raros: se redondea
        let multiplo = base * ((480 + base - 1) / base)
        return multiplo <= 32767 ? multiplo : base
    }

    package var datos: Data {
        let divisiones = self.divisiones
        func pulsos(_ duracion: Duracion) -> Int {
            Int(((duracion / .negra).enRedondas * Double(divisiones)).rounded())
        }
        var bytes: [UInt8] = []
        // Cabecera: formato 1, número de pistas, divisiones por negra.
        bytes += Array("MThd".utf8) + ArchivoMIDI.entero(6, bytes: 4)
        bytes += ArchivoMIDI.entero(1, bytes: 2) + ArchivoMIDI.entero(pistas.count + 1, bytes: 2)
        bytes += ArchivoMIDI.entero(divisiones, bytes: 2)

        // La pista de control.
        var control: [(Int, [UInt8])] = []
        if let titulo { control.append((0, ArchivoMIDI.meta(0x03, ArchivoMIDI.texto(titulo)))) }
        let microsegundos = tempo.map { Int((60_000_000 / $0.negrasPorMinuto).rounded()) } ?? 500_000
        control.append((0, ArchivoMIDI.meta(0x51, ArchivoMIDI.entero(microsegundos, bytes: 3))))
        // Compás: numerador, denominador como potencia de 2, relojes por pulso y fusas por negra.
        let reloj = compas.tipo == .compuesto ? 36 * 8 / compas.denominador : 24 * 4 / compas.denominador
        control.append(
            (
                0,
                ArchivoMIDI.meta(
                    0x58,
                    [
                        UInt8(compas.numerador),
                        UInt8(compas.denominador.trailingZeroBitCount),
                        UInt8(max(1, min(255, reloj))), 8,
                    ])
            ))
        if let tonalidad, abs(tonalidad.armadura) <= 7 {
            control.append(
                (
                    0,
                    ArchivoMIDI.meta(
                        0x59,
                        [
                            UInt8(bitPattern: Int8(tonalidad.armadura)),
                            tonalidad.modo == .menor ? 1 : 0,
                        ])
                ))
        }
        bytes += ArchivoMIDI.pista(control)

        var mensajesDeLasPistas: [[(Int, [UInt8])]] = []
        var notasDeLasPistas: [[NotaMIDI]] = []
        for (i, pista) in pistas.enumerated() {
            let canal = ArchivoMIDI.canal(dePista: i)
            var mensajes: [(Int, [UInt8])] = [
                (0, ArchivoMIDI.meta(0x03, ArchivoMIDI.texto(pista.nombre))),
                (0, [0xC0 | canal, UInt8(pista.instrumento)]),
            ]
            // Las notas: las ligadas siguen sonando mientras la siguiente nota las repita. Cada una suena con la
            // velocidad de la dinámica que vale (mf si no se marca ninguna), más fuerte si lleva acento, y el
            // staccato la acorta (`Articulacion.proporcionQueSuena`).
            var inicio = 0
            // Altura MIDI → cuándo empezó, sus cents, su velocidad y cuándo deja de sonar si se acorta.
            var sonando: [Int: (desde: Int, desvio: Double, velocidad: Int, corte: Int?)] = [:]
            var notas: [NotaMIDI] = []
            var ligadas: Set<Int> = []
            var dinamica = Dinamica.mf
            for (k, evento) in pista.eventos.enumerated() {
                // La tecla de cada nota y lo que se aparta de ella, en cents.
                var desvios: [Int: Double] = [:]
                for (i, altura) in evento.alturas.enumerated() {
                    let sonido = ArchivoMIDI.sonido(altura, desvio: evento.notas[i].desvio, afinacion: afinacion)
                    if (0...127).contains(sonido.clave), desvios[sonido.clave] == nil {
                        desvios[sonido.clave] = sonido.desvio
                    }
                }
                let claves = Set(desvios.keys)
                // Las que venían ligadas y no siguen, terminan aquí.
                let terminan = sonando.filter { !(ligadas.contains($0.key) && claves.contains($0.key)) }
                for (clave, nota) in terminan.sorted(by: { $0.key < $1.key }) {
                    notas.append((clave, nota.desde, min(inicio, nota.corte ?? inicio), nota.desvio, nota.velocidad))
                    sonando[clave] = nil
                }
                let marcada = evento.dinamica ?? dinamica
                if let nueva = evento.dinamica, !nueva.esDeUnaNota { dinamica = nueva }
                let velocidad = ArchivoMIDI.velocidad(marcada, evento.articulaciones)
                let proporcion = evento.articulaciones.map(\.proporcionQueSuena).min() ?? Duracion(1, 1)
                let acortada = !evento.ligada && proporcion < Duracion(1, 1)
                let corte = acortada ? inicio + pulsos(evento.duracion * proporcion) : nil
                for clave in claves where sonando[clave] == nil {
                    sonando[clave] = (inicio, desvios[clave] ?? 0, velocidad, corte)
                }
                if k < pista.marcadores.count, !pista.marcadores[k].isEmpty {
                    mensajes.append((inicio, ArchivoMIDI.meta(0x06, ArchivoMIDI.texto(pista.marcadores[k]))))
                }
                inicio += pulsos(evento.duracion)
                ligadas = evento.ligada ? claves : []
            }
            for (clave, nota) in sonando.sorted(by: { $0.key < $1.key }) {
                notas.append((clave, nota.desde, min(inicio, nota.corte ?? inicio), nota.desvio, nota.velocidad))
            }
            mensajesDeLasPistas.append(mensajes)
            notasDeLasPistas.append(notas)
        }
        let deLasNotas = ArchivoMIDI.mensajes(de: notasDeLasPistas, instrumentos: pistas.map(\.instrumento))
        for (mensajes, suyos) in zip(mensajesDeLasPistas, deLasNotas) { bytes += ArchivoMIDI.pista(mensajes + suyos) }
        return Data(bytes)
    }

    /// Una nota ya medida: su tecla, cuándo empieza y acaba (en pulsos), cuántos cents se aparta de la tecla y su
    /// velocidad.
    package typealias NotaMIDI = (clave: Int, desde: Int, hasta: Int, desvio: Double, velocidad: Int)

    /// El canal propio de la pista `i` (contando las de las voces desde 0): del 1 al 9 y del 11 en adelante.
    package static func canal(dePista i: Int) -> UInt8 { UInt8(i < 9 ? i : (i + 1) % 16) }

    /// La tecla en que suena una altura y lo que se aparta de ella, en cents: en temperamento igual, la suya y su
    /// desvío; en una afinación, la temperada más cercana sin pasar de un semitono, con lo que falte.
    package static func sonido(
        _ altura: Altura, desvio: Double, afinacion: (any Afinacion)?
    ) -> (clave: Int, desvio: Double) {
        guard let afinacion else { return (altura.midi, desvio) }
        let total = desvio + afinacion.desviacion(de: altura)
        let semitonos = Int((total / 100).rounded(.towardZero))
        return (altura.midi + semitonos, total - Double(semitonos * 100))
    }

    /// El valor de la inflexión de tono (pitch bend) que aparta una nota `desvio` cents, en el ámbito de ±2
    /// semitonos de General MIDI: 8192 es el centro.
    package static func inflexion(_ desvio: Double) -> Int {
        Int(max(0, min(16_383, 8192 + (desvio / 200 * 8192).rounded())))
    }

    /// Los mensajes de las notas de cada pista, con los microtonos como inflexiones de tono. La inflexión afecta a
    /// todo un canal, así que cada nota va al de su pista si lo que suena en él se aparta lo mismo que ella; si no, a
    /// uno de los que no son de ninguna pista (sin el 10), con el instrumento de la suya: uno en que suene ya algo de
    /// su pista que se aparte igual, si no, uno que ya tenga su inflexión y su instrumento, y si no, el que lleve
    /// más tiempo callado. Si no queda ninguno, va al de su pista con la inflexión que ya tenga. Cada canal que se
    /// inflexiona fija antes el ámbito (RPN 0 = 2 semitonos). Sin microtonos, todo va al canal de la pista, sin
    /// inflexiones.
    package static func mensajes(de pistas: [[NotaMIDI]], instrumentos: [Int]) -> [[(Int, [UInt8])]] {
        let propios = pistas.indices.map { canal(dePista: $0) }
        let libres = (0..<16).map { UInt8($0) }.filter { $0 != 9 && !propios.contains($0) }
        // Por canal: su inflexión, lo que suena en él (hasta cuándo, con qué inflexión y de qué pista), su
        // instrumento y cuándo calla.
        var inflexiones = [Int](repeating: 8192, count: 16)
        var sonando = [[(hasta: Int, inflexion: Int, pista: Int)]](repeating: [], count: 16)
        var instrumento = [Int?](repeating: nil, count: 16)
        var calla = [Int](repeating: 0, count: 16)
        for (p, c) in propios.enumerated() { instrumento[Int(c)] = instrumentos[p] }
        var mensajes = [[(Int, [UInt8])]](repeating: [], count: pistas.count)
        var conAmbito: Set<Int> = []
        let todas = pistas.enumerated().flatMap { p, notas in notas.map { (pista: p, nota: $0) } }.sorted {
            ($0.nota.desde, $0.pista, $0.nota.clave) < ($1.nota.desde, $1.pista, $1.nota.clave)
        }
        for (p, nota) in todas {
            let valor = inflexion(nota.desvio)
            for c in 0..<16 { sonando[c].removeAll { $0.hasta <= nota.desde } }
            func cabe(_ c: UInt8, deOtra: Bool) -> Bool {
                sonando[Int(c)].allSatisfy { $0.inflexion == valor && (!deOtra || $0.pista == p) }
            }
            var elegido = propios[p]
            if !cabe(elegido, deOtra: false) {
                let candidatos = libres.filter { cabe($0, deOtra: true) }
                let acompanado = candidatos.first { !sonando[Int($0)].isEmpty }
                let preparado = candidatos.first {
                    inflexiones[Int($0)] == valor && instrumento[Int($0)] == instrumentos[p]
                }
                let callado = candidatos.min { calla[Int($0)] < calla[Int($1)] }
                elegido = acompanado ?? preparado ?? callado ?? elegido
            }
            let c = Int(elegido)
            if instrumento[c] != instrumentos[p] {
                mensajes[p].append((nota.desde, [0xC0 | elegido, UInt8(instrumentos[p])]))
                instrumento[c] = instrumentos[p]
            }
            if sonando[c].isEmpty && inflexiones[c] != valor {
                if conAmbito.insert(p * 16 + c).inserted {
                    // RPN 0 (ámbito de la inflexión) = 2 semitonos.
                    let ambito: [(UInt8, UInt8)] = [(101, 0), (100, 0), (6, 2), (38, 0)]
                    mensajes[p] += ambito.map { (0, [0xB0 | elegido, $0.0, $0.1]) }
                }
                mensajes[p].append((nota.desde, [0xE0 | elegido, UInt8(valor & 0x7F), UInt8(valor >> 7)]))
                inflexiones[c] = valor
            }
            sonando[c].append((nota.hasta, inflexiones[c], p))
            calla[c] = max(calla[c], nota.hasta)
            mensajes[p].append((nota.desde, [0x90 | elegido, UInt8(nota.clave), UInt8(nota.velocidad)]))
            mensajes[p].append((nota.hasta, [0x80 | elegido, UInt8(nota.clave), 64]))
        }
        return mensajes
    }

    /// Una pista: los mensajes ordenados por tiempo (a igual tiempo, los finales de nota
    /// antes que los comienzos), con el tiempo delta delante de cada uno y el fin de pista.
    /// La velocidad de una nota: la de su dinámica, con 16 más si lleva acento y 24 si lleva marcato, hasta 127.
    package static func velocidad(_ dinamica: Dinamica, _ articulaciones: [Articulacion]) -> Int {
        let refuerzo = articulaciones.contains(.marcato) ? 24 : (articulaciones.contains(.acento) ? 16 : 0)
        return min(127, dinamica.velocidadMIDI + refuerzo)
    }

    package static func pista(_ mensajes: [(Int, [UInt8])]) -> [UInt8] {
        func orden(_ m: [UInt8]) -> Int {
            switch m[0] & 0xF0 {
            case 0x80: return 1
            case 0xE0: return 2 // la inflexión, tras los finales de nota y antes de la que empieza
            case 0x90: return 3
            default: return 0 // meta y cambio de programa, primero
            }
        }
        let ordenados = mensajes.enumerated().sorted {
            ($0.element.0, orden($0.element.1), $0.offset) < ($1.element.0, orden($1.element.1), $1.offset)
        }.map(\.element)
        var cuerpo: [UInt8] = []
        var ahora = 0
        for (tiempo, mensaje) in ordenados {
            cuerpo += cantidadVariable(tiempo - ahora) + mensaje
            ahora = tiempo
        }
        cuerpo += [0x00, 0xFF, 0x2F, 0x00]
        return Array("MTrk".utf8) + entero(cuerpo.count, bytes: 4) + cuerpo
    }

    /// Un texto en Latin-1, con las alteraciones en ASCII ("Mi♭ · ♭VI" → "Mib · bVI") y "?" en
    /// lo que no se puede escribir.
    package static func texto(_ texto: String) -> [UInt8] {
        let ascii: [Character: String] = [
            "♭": "b", "♯": "#", "𝄫": "bb", "𝄪": "x", "♮": "", "–": "-", "—": "-", "→": "->", "Δ": "maj",
        ]
        let limpio = texto.map { ascii[$0] ?? String($0) }.joined()
        return limpio.unicodeScalars.map { $0.value <= 0xFF ? UInt8($0.value) : UInt8(ascii: "?") }
    }

    /// Un metaevento: FF, tipo, longitud y datos.
    package static func meta(_ tipo: UInt8, _ datos: [UInt8]) -> [UInt8] {
        [0xFF, tipo] + cantidadVariable(datos.count) + datos
    }

    /// Un entero sin signo, de mayor a menor peso.
    package static func entero(_ valor: Int, bytes: Int) -> [UInt8] {
        (0..<bytes).reversed().map { UInt8(truncatingIfNeeded: valor >> (8 * $0)) }
    }

    /// Cantidad de longitud variable: 7 bits por byte, con el bit alto en todos menos el último.
    package static func cantidadVariable(_ valor: Int) -> [UInt8] {
        var resto = valor >> 7
        var resultado: [UInt8] = [UInt8(valor & 0x7F)]
        while resto > 0 {
            resultado.insert(UInt8(resto & 0x7F) | 0x80, at: 0)
            resto >>= 7
        }
        return resultado
    }
}
