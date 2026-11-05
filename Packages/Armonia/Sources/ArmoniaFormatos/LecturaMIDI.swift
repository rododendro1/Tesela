import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Lectura de ficheros MIDI estándar (SMF, formatos 0, 1 y 2): las notas de todas las pistas, menos
// las del canal 10 (percusión), y de la primera pista, el título, el tempo, el compás y la armadura.
//
// MIDI solo da números de nota: la ortografía (Fa♯ o Sol♭) sale de la armadura del fichero o, si no
// la tiene, de la tonalidad que mejor explica las notas. Una nota que empieza mientras la misma
// tecla ya suena en el mismo canal cierra la anterior; las que no se cierran, terminan con su pista.
//
// Los microtonos llegan como inflexiones de tono (pitch bend): cada nota se lleva, como `desvio`, la inflexión de
// su canal cuando empieza, en el ámbito que fije el RPN 0 (±2 semitonos si no lo fija).
//
// Cada pista de un fichero de formato 1 o 2 es una parte por instrumento: los canales de la misma pista con el mismo
// programa son una sola, como las notas que `ArchivoMIDI` reparte en varios canales para darles inflexiones
// distintas. En el formato 0, que lo lleva todo en una pista, cada canal es una parte.

extension PiezaImportada {
    /// Lee un fichero MIDI estándar.
    ///
    ///     let datos = coral.partitura().midi()
    ///     let pieza = try PiezaImportada(midi: datos)
    ///     pieza.notas.count   // las mismas notas que el coral
    public init(midi datos: Data) throws {
        var lector = LectorMIDI(bytes: [UInt8](datos))
        try lector.leer()
        guard !lector.notas.isEmpty else { throw ErrorDeLecturaDeFichero.sinNotas }
        let redonda = 4 * lector.divisiones
        let tonalidad =
            lector.tonalidad
            ?? Tonalidad.identificar(
                midi: lector.notas.map(\.clave),
                duraciones: lector.notas.map { Double($0.hasta - $0.desde) }
            ).first
        // Las partes, en el orden en que aparecen.
        var partes: [Int: Int] = [:]
        let notas = lector.notas.map { nota in
            let parte = partes[nota.parte] ?? partes.count
            partes[nota.parte] = parte
            let altura = tonalidad.map { Altura(midi: nota.clave, tonalidad: $0) } ?? Altura(midi: nota.clave)
            return NotaDeLaPieza(
                altura: altura, inicio: Duracion(nota.desde, redonda),
                duracion: Duracion(nota.hasta - nota.desde, redonda), parte: parte, desvio: nota.desvio)
        }
        self.init(
            titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas,
            tempo: lector.tempo, notas: notas)
    }
}

/// Lee los bytes de un fichero MIDI. Cualquier lectura fuera de los datos es `ErrorDeLecturaDeFichero.midiDanado`.
struct LectorMIDI {
    let bytes: [UInt8]
    var posicion = 0

    var divisiones = 480
    var titulo: String?
    var tonalidad: Tonalidad?
    var compas: Compas?
    var tempo: Tempo?
    /// El formato del fichero: 0 (una pista), 1 (pistas a la vez) o 2 (pistas una tras otra).
    var formato = 1
    /// Las notas en pulsos de reloj; `parte` distingue las partes (la pista y el canal en el formato 0; la pista y
    /// el programa en los demás), y `desvio`, los cents de la inflexión de tono con que empezó.
    var notas: [(clave: Int, desde: Int, hasta: Int, parte: Int, desvio: Double)] = []

    init(bytes: [UInt8]) { self.bytes = bytes }

    mutating func leer() throws {
        guard try etiqueta() == "MThd" else { throw ErrorDeLecturaDeFichero.midiDanado }
        let largo = try entero(4)
        guard largo >= 6 else { throw ErrorDeLecturaDeFichero.midiDanado }
        formato = try entero(2)
        let pistas = try entero(2)
        let division = try entero(2)
        guard division & 0x8000 == 0 else { throw ErrorDeLecturaDeFichero.midiConTiempoSMPTE }
        guard division > 0 else { throw ErrorDeLecturaDeFichero.midiDanado }
        divisiones = division
        posicion += largo - 6

        var pista = 0
        while pista < pistas, posicion < bytes.count {
            let tipo = try etiqueta()
            let largo = try entero(4)
            guard largo <= bytes.count - posicion else { throw ErrorDeLecturaDeFichero.midiDanado }
            if tipo == "MTrk" {
                try leerPista(hasta: posicion + largo, numero: pista)
                pista += 1
            } else {
                posicion += largo // los bloques desconocidos se saltan
            }
        }
    }

    private mutating func leerPista(hasta fin: Int, numero: Int) throws {
        var ahora = 0
        var estado: UInt8 = 0 // el estado en curso (running status)
        // canal * 128 + tecla → cuándo empezó cada nota abierta, con qué inflexión y de qué parte es.
        var sonando: [Int: [(desde: Int, desvio: Double, parte: Int)]] = [:]
        var leidas: [(clave: Int, desde: Int, hasta: Int, parte: Int, desvio: Double)] = []
        // Por canal: la inflexión en curso (en cents), su ámbito en semitonos y el RPN elegido (101 y 100).
        var inflexion = [Double](repeating: 0, count: 16)
        var ambito = [Double](repeating: 2, count: 16)
        var rpn = [(Int, Int)](repeating: (127, 127), count: 16)
        var programa = [Int](repeating: 0, count: 16)
        let porCanal = formato == 0
        func parte(_ canal: Int) -> Int { porCanal ? numero * 16 + canal : numero * 128 + programa[canal] }
        func cerrar(_ clave: Int, canal: Int, en tiempo: Int) {
            let indice = canal * 128 + clave
            guard var abiertas = sonando[indice], !abiertas.isEmpty else { return }
            let nota = abiertas.removeFirst()
            sonando[indice] = abiertas
            if tiempo > nota.desde { leidas.append((clave, nota.desde, tiempo, nota.parte, nota.desvio)) }
        }
        while posicion < fin {
            ahora += try cantidadVariable()
            guard ahora < 1 << 36 else { throw ErrorDeLecturaDeFichero.midiDanado } // años de música: está dañado
            var primero = try byte()
            if primero & 0x80 != 0 {
                estado = primero
                if primero < 0xF0 { primero = try byte() }
            } else {
                guard estado & 0x80 != 0, estado < 0xF0 else { throw ErrorDeLecturaDeFichero.midiDanado }
            }
            switch estado {
            case 0xFF:
                let tipo = try byte()
                let datos = try trozo(try cantidadVariable())
                leerMeta(tipo, datos, pista: numero)
                estado = 0
                if tipo == 0x2F { posicion = fin }
            case 0xF0, 0xF7:
                _ = try trozo(try cantidadVariable()) // sistema exclusivo: no interesa
                estado = 0
            default:
                let canal = Int(estado & 0x0F)
                switch estado & 0xF0 {
                case 0x90, 0x80:
                    let clave = Int(primero & 0x7F)
                    let velocidad = try byte()
                    guard canal != 9 else { break } // percusión
                    cerrar(clave, canal: canal, en: ahora)
                    if estado & 0xF0 == 0x90 && velocidad > 0 {
                        sonando[canal * 128 + clave, default: []].append((ahora, inflexion[canal], parte(canal)))
                    }
                case 0xB0:
                    let control = Int(primero & 0x7F)
                    let valor = Int(try byte() & 0x7F)
                    switch control {
                    case 101: rpn[canal].0 = valor
                    case 100: rpn[canal].1 = valor
                    // El ámbito de la inflexión (RPN 0): semitonos y, en el byte bajo, cents.
                    case 6 where rpn[canal] == (0, 0): ambito[canal] = Double(valor)
                    case 38 where rpn[canal] == (0, 0):
                        ambito[canal] = ambito[canal].rounded(.down) + Double(valor) / 100
                    default: break
                    }
                case 0xE0:
                    let valor = Int(primero & 0x7F) | Int(try byte() & 0x7F) << 7
                    inflexion[canal] = Double(valor - 8192) / 8192 * ambito[canal] * 100
                case 0xA0:
                    _ = try byte()
                case 0xC0:
                    programa[canal] = Int(primero & 0x7F)
                case 0xD0:
                    break // un solo byte de datos, ya leído
                default:
                    throw ErrorDeLecturaDeFichero.midiDanado
                }
            }
        }
        posicion = fin
        // Las que no se cerraron terminan con la pista.
        for (indice, abiertas) in sonando {
            for nota in abiertas where ahora > nota.desde {
                leidas.append((indice % 128, nota.desde, ahora, nota.parte, nota.desvio))
            }
        }
        notas += leidas
    }

    /// Los metaeventos que interesan, la primera vez que salen: título (el nombre de la secuencia
    /// en la primera pista), tempo, compás y armadura.
    private mutating func leerMeta(_ tipo: UInt8, _ datos: [UInt8], pista: Int) {
        switch tipo {
        case 0x03 where pista == 0 && titulo == nil:
            // Latin-1, como lo escribe `ArchivoMIDI`; si es UTF-8 válido, se lee como UTF-8.
            titulo =
                String(bytes: datos, encoding: .utf8)
                ?? String(datos.map { Character(Unicode.Scalar($0)) })
        case 0x51 where tempo == nil && datos.count == 3:
            let microsegundos = datos.reduce(0) { $0 << 8 | Int($1) }
            if microsegundos > 0 { tempo = Tempo(comprobando: 60_000_000 / Double(microsegundos)) }
        case 0x58 where compas == nil && datos.count >= 2 && datos[1] < 8:
            compas = Compas(comprobando: Int(datos[0]), 1 << Int(datos[1]))
        case 0x59 where tonalidad == nil && datos.count == 2:
            let armadura = Int(Int8(bitPattern: datos[0]))
            if abs(armadura) <= 7 { tonalidad = Tonalidad(armadura: armadura, modo: datos[1] == 1 ? .menor : .mayor) }
        default:
            break
        }
    }

    // MARK: Bytes

    private mutating func byte() throws -> UInt8 {
        guard posicion < bytes.count else { throw ErrorDeLecturaDeFichero.midiDanado }
        defer { posicion += 1 }
        return bytes[posicion]
    }

    private mutating func trozo(_ largo: Int) throws -> [UInt8] {
        guard largo >= 0, largo <= bytes.count - posicion else { throw ErrorDeLecturaDeFichero.midiDanado }
        defer { posicion += largo }
        return Array(bytes[posicion..<posicion + largo])
    }

    private mutating func entero(_ n: Int) throws -> Int {
        try trozo(n).reduce(0) { $0 << 8 | Int($1) }
    }

    private mutating func etiqueta() throws -> String {
        String(decoding: try trozo(4), as: UTF8.self)
    }

    /// Cantidad de longitud variable: 7 bits por byte, como mucho 4 bytes.
    private mutating func cantidadVariable() throws -> Int {
        var valor = 0
        for _ in 0..<4 {
            let x = try byte()
            valor = valor << 7 | Int(x & 0x7F)
            if x & 0x80 == 0 { return valor }
        }
        throw ErrorDeLecturaDeFichero.midiDanado
    }
}
