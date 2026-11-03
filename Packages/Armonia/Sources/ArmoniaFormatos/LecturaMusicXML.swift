import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Lectura de MusicXML por partes (`score-partwise`, lo que exportan MuseScore, Finale, Sibelius,
// Dorico y `musicXML()`), sin comprimir.
//
// Se leen las notas con su ortografía tal cual (un Sol♯ sigue siendo Sol♯), los acordes (`<chord/>`),
// las voces que vuelven atrás (`<backup>`) o avanzan (`<forward>`), las ligaduras (dos notas ligadas son
// una sola) y los instrumentos transpositores (`<transpose>`: se lee lo que suena, no lo que se escribe).
// Las notas guía (`<cue>`) no cuentan, ni la percusión (`<unpitched>`); las de adorno (`<grace>`) van aparte, sin
// duración. Las repeticiones (`<repeat>`, con sus `times`), las casillas (`<ending>`) y los saltos (`<sound>` con
// `dacapo`, `dalsegno`, `segno`, `coda`, `tocoda` y `fine`; `<segno/>` y `<coda/>`) se despliegan.
// Del primer compás que los tenga: la armadura, el compás y el tempo (`<sound tempo>`). De cada nota, sus
// articulaciones (`<articulations>`, `<fermata>`) y la dinámica (`<dynamics>`) que la precede, que vale también para
// las demás notas de su acorde.

extension PiezaImportada {
    /// Lee una partitura MusicXML por partes.
    ///
    ///     let xml = coral.musicXML(duracion: .blanca)
    ///     let pieza = try PiezaImportada(musicXML: Data(xml.utf8))
    public init(musicXML datos: Data) throws {
        let lector = LectorMusicXML()
        try LectorXML.leer(datos, con: lector)
        guard lector.raiz == "score-partwise" else { throw ErrorDeImportacion.noEsMusicXMLPorPartes }
        guard !lector.notas.isEmpty else { throw ErrorDeImportacion.sinNotas }
        let fin = lector.finDeLaPieza
        self.init(
            titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas, tempo: lector.tempo,
            notas: CompasLeido.desplegar(lector.notas, compases: lector.compases, fin: fin),
            notasDeAdorno: CompasLeido.desplegar(lector.adornos, compases: lector.compases, fin: fin))
    }

    /// La línea del primer byte que no es UTF-8 válido, o `nil` si todo es válido o el documento está en UTF-16 (con
    /// su marca) o declara una codificación de un byte por carácter (ISO-8859, Windows-125x).
    static func lineaConUTF8NoValido(_ datos: Data) -> Int? {
        let bytes = [UInt8](datos)
        if bytes.starts(with: [0xFE, 0xFF]) || bytes.starts(with: [0xFF, 0xFE]) { return nil }
        if LectorXML.codificacionDeUnByte(bytes) != nil { return nil }
        var posicion = 0
        var linea = 1
        while posicion < bytes.count {
            let primero = bytes[posicion]
            let largo: Int
            switch primero {
            case 0x00...0x7F: largo = 1
            case 0xC2...0xDF: largo = 2
            case 0xE0...0xEF: largo = 3
            case 0xF0...0xF4: largo = 4
            default: return linea
            }
            guard posicion + largo <= bytes.count else { return linea }
            let siguientes = bytes[(posicion + 1)..<(posicion + largo)]
            guard siguientes.allSatisfy({ $0 & 0xC0 == 0x80 }) else { return linea }
            // Formas demasiado largas, sustitutos de UTF-16 y valores por encima de U+10FFFF.
            if largo == 3, let segundo = siguientes.first {
                if primero == 0xE0 && segundo < 0xA0 || primero == 0xED && segundo >= 0xA0 { return linea }
            }
            if largo == 4, let segundo = siguientes.first {
                if primero == 0xF0 && segundo < 0x90 || primero == 0xF4 && segundo >= 0x90 { return linea }
            }
            if primero == 0x0A { linea += 1 }
            posicion += largo
        }
        return nil
    }
}

/// Recorre el documento elemento a elemento y va colocando las notas en el tiempo.
final class LectorMusicXML: LectorDeElementosXML {
    private(set) var raiz: String?
    private(set) var titulo: String?
    private(set) var tonalidad: Tonalidad?
    private(set) var compas: Compas?
    private(set) var tempo: Tempo?
    private(set) var notas: [NotaDeLaPieza] = []
    private(set) var adornos: [NotaDeLaPieza] = []
    /// Los compases, con sus repeticiones y sus saltos.
    private(set) var compases: [CompasLeido] = []
    /// Donde acaba el último compás de la primera parte.
    private(set) var finDeLaPieza = Duracion.cero

    /// Los elementos abiertos, del documento al actual, y el texto del actual.
    private var pila: [String] = []
    private var contenido = ""

    // La parte en curso.
    private var parte = -1
    private var divisiones = 1
    private var posicion = Duracion.cero
    private var inicioDelCompas = Duracion.cero
    /// Hasta dónde ha llegado alguna voz en el compás: ahí empieza el siguiente.
    private var finDelCompas = Duracion.cero
    private var inicioDeLaAnterior = Duracion.cero
    private var transposicion: (pasos: Int, semitonos: Int)?
    /// El compás en curso de la parte, contando desde 0.
    private var indiceDelCompas = -1
    /// Las casillas abiertas (`<ending type="start">`) y si se cierran al acabar el compás.
    private var casillas: (numeros: Set<Int>, seCierran: Bool)?
    /// Las notas con una ligadura que sigue, por parte y altura MIDI: su índice en `notas`.
    private var ligadas: [Int: Int] = [:]
    /// La dinámica leída que espera a la nota siguiente.
    private var dinamicaPendiente: Dinamica?
    /// La dinámica y las articulaciones de la primera nota del acorde en curso, para las demás.
    private var marcasDelAcorde: (dinamica: Dinamica?, articulaciones: [Articulacion]) = (nil, [])

    // Lo que se va leyendo dentro de un elemento.
    private var nota = NotaLeida()
    private var armadura: (quintas: Int?, menor: Bool) = (nil, false)
    private var tiempo: (pulsos: Int?, unidad: Int?) = (nil, nil)
    private var transporte: (pasos: Int, semitonos: Int, octavas: Int) = (0, 0, 0)

    private struct NotaLeida {
        var esDeAcorde = false
        var sinTiempo = false // de adorno
        var muda = false // silencio, nota guía o percusión
        var paso: NotaNatural?
        var alteracion = 0
        /// Lo que `<alter>` tiene de más sobre `alteracion`, en cents: 50 en Fa𝄲 (`<alter>0.5</alter>`).
        var desvio = 0.0
        var octava: Int?
        var pulsos: Int?
        var ligaduraQueEmpieza = false
        var ligaduraQueAcaba = false
        var articulaciones: [Articulacion] = []
    }

    /// Las articulaciones de MusicXML (dentro de `<articulations>`).
    private static let articulaciones: [String: Articulacion] = [
        "staccato": .staccato, "staccatissimo": .staccatissimo, "spiccato": .staccatissimo, "tenuto": .tenuto,
        "accent": .acento, "strong-accent": .marcato,
    ]

    func abre(_ nombre: String, atributos: [String: String]) {
        if raiz == nil { raiz = nombre }
        defer { pila.append(nombre) }
        contenido = ""
        // `padre` es todavía el elemento que contiene a este.
        if padre == "dynamics", let dinamica = Dinamica(rawValue: nombre) { dinamicaPendiente = dinamica }
        if padre == "articulations", let articulacion = LectorMusicXML.articulaciones[nombre] {
            nota.articulaciones.append(articulacion)
        }
        if nombre == "fermata", padre == "notations" { nota.articulaciones.append(.calderon) }
        switch nombre {
        case "part":
            parte += 1
            dinamicaPendiente = nil
            divisiones = 1
            posicion = .cero
            inicioDelCompas = .cero
            finDelCompas = .cero
            inicioDeLaAnterior = .cero
            transposicion = nil
            indiceDelCompas = -1
            casillas = nil
        case "measure":
            posicion = inicioDelCompas
            finDelCompas = inicioDelCompas
            indiceDelCompas += 1
            if parte == 0 { compases.append(CompasLeido(inicio: inicioDelCompas)) }
        case "repeat" where padre == "barline":
            if atributos["direction"] == "forward" {
                marcar { $0.abreRepeticion = true }
            } else {
                let veces = atributos["times"].flatMap { Int($0) }.map { min(max($0, 1), 100) } ?? 2
                marcar { $0.cierraRepeticion = veces }
            }
        case "ending" where padre == "barline":
            if atributos["type"] == "start" {
                casillas = (LectorMusicXML.numerosDeCasilla(atributos["number"] ?? "1"), false)
            } else if casillas != nil {
                casillas?.seCierran = true
            }
        case "segno" where padre == "direction-type":
            marcar { $0.segno = true }
        case "coda" where padre == "direction-type":
            marcar { $0.coda = true }
        case "note":
            nota = NotaLeida()
        case "chord" where padre == "note":
            nota.esDeAcorde = true
        case "grace" where padre == "note":
            nota.sinTiempo = true
        case "rest" where padre == "note", "cue" where padre == "note", "unpitched" where padre == "note":
            nota.muda = true
        case "tie" where padre == "note":
            if atributos["type"] == "start" { nota.ligaduraQueEmpieza = true }
            if atributos["type"] == "stop" { nota.ligaduraQueAcaba = true }
        case "key":
            armadura = (nil, false)
        case "time":
            tiempo = (nil, nil)
        case "transpose":
            transporte = (0, 0, 0)
        case "sound":
            marcar { compas in
                if atributos["dacapo"] == "yes" { compas.daCapo = true }
                if atributos["dalsegno"] != nil { compas.dalSegno = true }
                if atributos["segno"] != nil { compas.segno = true }
                if atributos["coda"] != nil { compas.coda = true }
                if atributos["tocoda"] != nil { compas.alCoda = true }
                if atributos["fine"] != nil { compas.fine = true }
            }
            if tempo == nil, let valor = atributos["tempo"].flatMap({ Double($0) }), valor > 0, valor < 10_000 {
                tempo = Tempo(comprobando: valor)
            }
        default:
            break
        }
    }

    func texto(_ cadena: String) {
        contenido += cadena
    }

    func cierra(_ nombre: String) {
        let valor = contenido.trimmingCharacters(in: .whitespacesAndNewlines)
        contenido = ""
        pila.removeLast()
        // Los números, redondeados; los que no son finitos o son desmesurados no se tienen en cuenta.
        let numero = Double(valor).flatMap { $0.isFinite && abs($0) < 10_000_000 ? Int($0.rounded()) : nil }
        switch nombre {
        case "words" where padre == "direction-type":
            marcar { $0.leer(indicacion: valor) }
        case "work-title", "movement-title":
            if titulo == nil || nombre == "work-title", !valor.isEmpty { titulo = valor }
        case "divisions":
            if let numero, numero > 0, numero <= 100_000 { divisiones = numero }
        case "step" where padre == "pitch":
            nota.paso = ["C", "D", "E", "F", "G", "A", "B"].firstIndex(of: valor).flatMap(NotaNatural.init(rawValue:))
        case "alter" where padre == "pitch":
            // Un microtono es un alter con decimales: −0.5 es Mi𝄳 sobre Mi, que se lee como Mi♭ y 50 cents. El
            // semitono es el más cercano y, a medio camino, el de abajo, como lo escribe la exportación.
            if let alter = Double(valor), alter.isFinite, abs(alter) <= 10 {
                let semitonos = (alter - 0.5).rounded(.up)
                nota.alteracion = Int(semitonos)
                nota.desvio = (alter - semitonos) * 100
            } else {
                nota.alteracion = 0
            }
        case "octave" where padre == "pitch":
            nota.octava = numero
        case "duration":
            switch padre {
            case "note": nota.pulsos = numero
            case "backup": avanzar(-(numero ?? 0))
            case "forward": avanzar(numero ?? 0)
            default: break
            }
        case "note":
            colocarLaNota()
        case "measure":
            inicioDelCompas = max(finDelCompas, posicion)
            if let abiertas = casillas {
                marcar { $0.casillas = abiertas.numeros }
                if abiertas.seCierran { casillas = nil }
            }
            if parte == 0 { finDeLaPieza = inicioDelCompas }
        case "fifths" where padre == "key":
            armadura.quintas = numero
        case "mode" where padre == "key":
            armadura.menor = valor == "minor"
        case "key":
            if tonalidad == nil, let quintas = armadura.quintas, abs(quintas) <= 7 {
                tonalidad = Tonalidad(armadura: quintas, modo: armadura.menor ? .menor : .mayor)
            }
        case "beats" where padre == "time":
            // "3+2" suma sus partes.
            let partes = valor.split(separator: "+").map { Int($0.trimmingCharacters(in: .whitespaces)) }
            tiempo.pulsos = partes.contains(nil) ? nil : partes.compactMap { $0 }.reduce(0, +)
        case "beat-type" where padre == "time":
            tiempo.unidad = numero
        case "time":
            if compas == nil, let pulsos = tiempo.pulsos, let unidad = tiempo.unidad {
                compas = Compas(comprobando: pulsos, unidad)
            }
        case "diatonic" where padre == "transpose":
            transporte.pasos = numero ?? 0
        case "chromatic" where padre == "transpose":
            transporte.semitonos = numero ?? 0
        case "octave-change" where padre == "transpose":
            transporte.octavas = numero ?? 0
        case "transpose":
            transposicion = (transporte.pasos + 7 * transporte.octavas, transporte.semitonos + 12 * transporte.octavas)
        default:
            break
        }
    }

    /// El elemento que contiene al actual.
    private var padre: String? { pila.last }

    /// Cambia lo que se sabe del compás en curso (el mismo en todas las partes).
    private func marcar(_ cambio: (inout CompasLeido) -> Void) {
        guard compases.indices.contains(indiceDelCompas) else { return }
        cambio(&compases[indiceDelCompas])
    }

    /// "1", "1, 2", "1 2" o "1-3": los números de las casillas.
    static func numerosDeCasilla(_ texto: String) -> Set<Int> {
        var numeros: Set<Int> = []
        for trozo in texto.split(whereSeparator: { $0 == "," || $0 == " " }) {
            let extremos = trozo.split(separator: "-").compactMap { Int($0) }
            if extremos.count == 2, extremos[0] <= extremos[1], extremos[1] - extremos[0] < 100 {
                numeros.formUnion(extremos[0]...extremos[1])
            } else if let numero = extremos.first {
                numeros.insert(numero)
            }
        }
        return numeros.isEmpty ? [1] : numeros
    }

    private func avanzar(_ pulsos: Int) {
        posicion = max(.cero, posicion + Duracion(pulsos, 4 * divisiones))
        finDelCompas = max(finDelCompas, posicion)
    }

    private func colocarLaNota() {
        if nota.sinTiempo {
            // Una nota de adorno: empieza donde empezará la nota a la que adorna.
            if !nota.muda, let altura = alturaQueSuena() {
                adornos.append(
                    NotaDeLaPieza(
                        altura: altura, inicio: posicion, duracion: .cero, parte: parte, desvio: nota.desvio,
                        articulaciones: nota.articulaciones))
            }
            return
        }
        guard let pulsos = nota.pulsos, pulsos > 0 else { return }
        let duracion = Duracion(pulsos, 4 * divisiones)
        let inicio = nota.esDeAcorde ? inicioDeLaAnterior : posicion
        if !nota.esDeAcorde {
            inicioDeLaAnterior = posicion
            avanzar(pulsos)
        }
        guard !nota.muda, let altura = alturaQueSuena() else { return }
        if nota.esDeAcorde {
            marcasDelAcorde.articulaciones += nota.articulaciones
        } else {
            marcasDelAcorde = (dinamicaPendiente, nota.articulaciones)
            dinamicaPendiente = nil
        }
        let clave = parte * 1024 + altura.midi + 512
        if nota.ligaduraQueAcaba, let i = ligadas[clave], notas[i].fin == inicio {
            notas[i] = notas[i].con(duracion: notas[i].duracion + duracion)
            if !nota.ligaduraQueEmpieza { ligadas[clave] = nil }
        } else {
            notas.append(
                NotaDeLaPieza(
                    altura: altura, inicio: inicio, duracion: duracion, parte: parte, desvio: nota.desvio,
                    dinamica: marcasDelAcorde.dinamica, articulaciones: marcasDelAcorde.articulaciones))
            if nota.ligaduraQueEmpieza { ligadas[clave] = notas.count - 1 }
        }
    }

    /// La altura de la nota leída, como suena (con la transposición del instrumento).
    private func alturaQueSuena() -> Altura? {
        guard let paso = nota.paso, let octava = nota.octava else { return nil }
        let altura = Altura(Nota(paso, Alteracion(nota.alteracion)), octava: octava)
        guard let transposicion else { return altura }
        return Altura(pasos: altura.pasos + transposicion.pasos, midi: altura.midi + transposicion.semitonos)
    }
}
