import ArmoniaNucleo
import ArmoniaTeoria
// Lectura de ficheros MIDI estándar (SMF, formatos 0, 1 y 2): las notas de todas las pistas, menos
// las del canal 10 (percusión), y de la primera pista, el título, el tempo, el compás y la armadura.
//
// MIDI solo da números de nota: la ortografía (Fa♯ o Sol♭) sale de la armadura del fichero o, si no
// la tiene, de la tonalidad que mejor explica las notas. Una nota que empieza mientras la misma
// tecla ya suena en el mismo canal cierra la anterior; las que no se cierran, terminan con su pista.

import Foundation

extension PiezaImportada {
    /// Lee un fichero MIDI estándar.
    ///
    ///     let datos = coral.midi()
    ///     let pieza = try PiezaImportada(midi: datos)
    ///     pieza.notas.count   // las mismas notas que el coral
    public init(midi datos: Data) throws {
        var lector = LectorMIDI(bytes: [UInt8](datos))
        try lector.leer()
        guard !lector.notas.isEmpty else { throw ErrorDeImportacion.sinNotas }
        let redonda = 4 * lector.divisiones
        let tonalidad = lector.tonalidad
            ?? Tonalidad.identificar(midi: lector.notas.map(\.clave),
                                     duraciones: lector.notas.map { Double($0.hasta - $0.desde) }).first
        // Las partes, en el orden en que aparecen.
        var partes: [Int: Int] = [:]
        let notas = lector.notas.map { nota in
            let parte = partes[nota.parte] ?? partes.count
            partes[nota.parte] = parte
            let altura = tonalidad.map { Altura(midi: nota.clave, tonalidad: $0) } ?? Altura(midi: nota.clave)
            return NotaDeLaPieza(altura: altura, inicio: Duracion(nota.desde, redonda),
                                 duracion: Duracion(nota.hasta - nota.desde, redonda), parte: parte)
        }
        self.init(titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas,
                  tempo: lector.tempo, notas: notas)
    }
}

/// Lee los bytes de un fichero MIDI. Cualquier lectura fuera de los datos es `ErrorDeImportacion.midiDanado`.
struct LectorMIDI {
    let bytes: [UInt8]
    var posicion = 0

    var divisiones = 480
    var titulo: String?
    var tonalidad: Tonalidad?
    var compas: Compas?
    var tempo: Tempo?
    /// Las notas en pulsos de reloj; `parte` es la pista por 16 más el canal.
    var notas: [(clave: Int, desde: Int, hasta: Int, parte: Int)] = []

    init(bytes: [UInt8]) { self.bytes = bytes }

    mutating func leer() throws {
        guard try etiqueta() == "MThd" else { throw ErrorDeImportacion.midiDanado }
        let largo = try entero(4)
        guard largo >= 6 else { throw ErrorDeImportacion.midiDanado }
        _ = try entero(2)   // formato: 0, 1 o 2 se leen igual
        let pistas = try entero(2)
        let division = try entero(2)
        guard division & 0x8000 == 0 else { throw ErrorDeImportacion.midiConTiempoSMPTE }
        guard division > 0 else { throw ErrorDeImportacion.midiDanado }
        divisiones = division
        posicion += largo - 6

        var pista = 0
        while pista < pistas, posicion < bytes.count {
            let tipo = try etiqueta()
            let largo = try entero(4)
            guard largo <= bytes.count - posicion else { throw ErrorDeImportacion.midiDanado }
            if tipo == "MTrk" {
                try leerPista(hasta: posicion + largo, numero: pista)
                pista += 1
            } else {
                posicion += largo   // los bloques desconocidos se saltan
            }
        }
    }

    private mutating func leerPista(hasta fin: Int, numero: Int) throws {
        var ahora = 0
        var estado: UInt8 = 0   // el estado en curso (running status)
        var sonando: [Int: [Int]] = [:]   // canal * 128 + tecla → cuándo empezó cada nota abierta
        var leidas: [(clave: Int, desde: Int, hasta: Int, parte: Int)] = []
        func cerrar(_ clave: Int, canal: Int, en tiempo: Int) {
            let indice = canal * 128 + clave
            guard var abiertas = sonando[indice], !abiertas.isEmpty else { return }
            let desde = abiertas.removeFirst()
            sonando[indice] = abiertas
            if tiempo > desde { leidas.append((clave, desde, tiempo, numero * 16 + canal)) }
        }
        while posicion < fin {
            ahora += try cantidadVariable()
            guard ahora < 1 << 36 else { throw ErrorDeImportacion.midiDanado }   // años de música: está dañado
            var primero = try byte()
            if primero & 0x80 != 0 {
                estado = primero
                if primero < 0xF0 { primero = try byte() }
            } else {
                guard estado & 0x80 != 0, estado < 0xF0 else { throw ErrorDeImportacion.midiDanado }
            }
            switch estado {
            case 0xFF:
                let tipo = try byte()
                let datos = try trozo(try cantidadVariable())
                leerMeta(tipo, datos, pista: numero)
                estado = 0
                if tipo == 0x2F { posicion = fin }
            case 0xF0, 0xF7:
                _ = try trozo(try cantidadVariable())   // sistema exclusivo: no interesa
                estado = 0
            default:
                let canal = Int(estado & 0x0F)
                switch estado & 0xF0 {
                case 0x90, 0x80:
                    let clave = Int(primero & 0x7F)
                    let velocidad = try byte()
                    guard canal != 9 else { break }   // percusión
                    cerrar(clave, canal: canal, en: ahora)
                    if estado & 0xF0 == 0x90 && velocidad > 0 {
                        sonando[canal * 128 + clave, default: []].append(ahora)
                    }
                case 0xA0, 0xB0, 0xE0:
                    _ = try byte()
                case 0xC0, 0xD0:
                    break   // un solo byte de datos, ya leído
                default:
                    throw ErrorDeImportacion.midiDanado
                }
            }
        }
        posicion = fin
        // Las que no se cerraron terminan con la pista.
        for (indice, abiertas) in sonando {
            for desde in abiertas where ahora > desde {
                leidas.append((indice % 128, desde, ahora, numero * 16 + indice / 128))
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
            titulo = String(bytes: datos, encoding: .utf8)
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
        guard posicion < bytes.count else { throw ErrorDeImportacion.midiDanado }
        defer { posicion += 1 }
        return bytes[posicion]
    }

    private mutating func trozo(_ largo: Int) throws -> [UInt8] {
        guard largo >= 0, largo <= bytes.count - posicion else { throw ErrorDeImportacion.midiDanado }
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
        throw ErrorDeImportacion.midiDanado
    }
}
