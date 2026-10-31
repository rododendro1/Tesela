import ArmoniaNucleo
import Foundation

// Lectura de MusicXML comprimido (.mxl, lo que exportan por omisión MuseScore y otros): un zip con la
// partitura y un `META-INF/container.xml` que dice cuál de sus ficheros es. Se leen los zips de siempre
// (sin cifrar, sin ZIP64) con sus ficheros guardados tal cual o comprimidos con DEFLATE (RFC 1951), que se
// descomprime aquí mismo para no depender de zlib en Linux ni de Compression en Apple.
//
// Cualquier cosa que no encaje (un zip cortado, otro método de compresión, un zip sin partitura) es
// `ErrorDeImportacion.comprimido`.

extension PiezaImportada {
    /// Lee una partitura MusicXML comprimida (.mxl).
    ///
    ///     let pieza = try PiezaImportada(mxl: Data(contentsOf: URL(fileURLWithPath: "coral.mxl")))
    public init(mxl datos: Data) throws {
        let zip = try ArchivoZip(bytes: [UInt8](datos))
        guard let partitura = try zip.partitura() else { throw ErrorDeImportacion.comprimido }
        try self.init(musicXML: Data(partitura))
    }
}

/// Los ficheros de un zip, leídos de su directorio central.
struct ArchivoZip {
    struct Entrada {
        let nombre: String
        let metodo: Int
        let comprimido: Int
        let descomprimido: Int
        let cabecera: Int
    }

    let bytes: [UInt8]
    let entradas: [Entrada]

    /// Lo más que se descomprime de un fichero: una partitura de verdad no llega ni de lejos, y así un zip
    /// malicioso que crece sin fin no agota la memoria.
    static let maximo = 64 << 20

    init(bytes: [UInt8]) throws {
        self.bytes = bytes
        // El final del directorio central: 22 bytes y un comentario de hasta 65 535 al final del fichero.
        guard bytes.count >= 22 else { throw ErrorDeImportacion.comprimido }
        var fin = bytes.count - 22
        let limite = max(0, bytes.count - 22 - 65_535)
        while fin >= limite, ArchivoZip.entero(bytes, fin, 4) != 0x0605_4B50 { fin -= 1 }
        guard fin >= limite else { throw ErrorDeImportacion.comprimido }
        let cuantas = ArchivoZip.entero(bytes, fin + 10, 2)
        var posicion = ArchivoZip.entero(bytes, fin + 16, 4)
        var entradas: [Entrada] = []
        for _ in 0..<cuantas {
            guard posicion + 46 <= bytes.count, ArchivoZip.entero(bytes, posicion, 4) == 0x0201_4B50 else {
                throw ErrorDeImportacion.comprimido
            }
            let largoDelNombre = ArchivoZip.entero(bytes, posicion + 28, 2)
            let largoExtra = ArchivoZip.entero(bytes, posicion + 30, 2)
            let largoDelComentario = ArchivoZip.entero(bytes, posicion + 32, 2)
            guard posicion + 46 + largoDelNombre <= bytes.count else { throw ErrorDeImportacion.comprimido }
            let nombre = String(decoding: bytes[(posicion + 46)..<(posicion + 46 + largoDelNombre)], as: UTF8.self)
            entradas.append(
                Entrada(
                    nombre: nombre, metodo: ArchivoZip.entero(bytes, posicion + 10, 2),
                    comprimido: ArchivoZip.entero(bytes, posicion + 20, 4),
                    descomprimido: ArchivoZip.entero(bytes, posicion + 24, 4),
                    cabecera: ArchivoZip.entero(bytes, posicion + 42, 4)))
            posicion += 46 + largoDelNombre + largoExtra + largoDelComentario
        }
        self.entradas = entradas
    }

    /// La partitura: la que nombra `META-INF/container.xml` o, si no lo hay, el primer .musicxml o .xml que no
    /// esté en `META-INF`. `nil` si no hay ninguna.
    func partitura() throws -> [UInt8]? {
        var ruta: String?
        if let contenedor = try contenido(de: "META-INF/container.xml") {
            ruta = ArchivoZip.rutaDeLaPartitura(String(decoding: contenedor, as: UTF8.self))
        }
        if ruta == nil {
            ruta = entradas.map(\.nombre).first { nombre in
                !nombre.hasPrefix("META-INF/") && (nombre.hasSuffix(".musicxml") || nombre.hasSuffix(".xml"))
            }
        }
        guard let elegida = ruta else { return nil }
        return try contenido(de: elegida)
    }

    /// Lo que contiene un fichero del zip, descomprimido; `nil` si no está.
    func contenido(de nombre: String) throws -> [UInt8]? {
        guard let entrada = entradas.first(where: { $0.nombre == nombre }) else { return nil }
        // Los tamaños de 32 bits llenos son de ZIP64, que no se lee.
        guard entrada.comprimido != 0xFFFF_FFFF, entrada.descomprimido <= ArchivoZip.maximo,
            entrada.cabecera + 30 <= bytes.count,
            ArchivoZip.entero(bytes, entrada.cabecera, 4) == 0x0403_4B50
        else { throw ErrorDeImportacion.comprimido }
        let inicio = entrada.cabecera + 30 + ArchivoZip.entero(bytes, entrada.cabecera + 26, 2)
            + ArchivoZip.entero(bytes, entrada.cabecera + 28, 2)
        guard inicio + entrada.comprimido <= bytes.count else { throw ErrorDeImportacion.comprimido }
        let datos = Array(bytes[inicio..<(inicio + entrada.comprimido)])
        switch entrada.metodo {
        case 0:
            return datos
        case 8:
            var inflado = Inflado(datos, maximo: ArchivoZip.maximo)
            try inflado.descomprimir()
            guard inflado.salida.count == entrada.descomprimido else { throw ErrorDeImportacion.comprimido }
            return inflado.salida
        default:
            throw ErrorDeImportacion.comprimido
        }
    }

    /// El `full-path` del primer `<rootfile>` de `container.xml`.
    static func rutaDeLaPartitura(_ contenedor: String) -> String? {
        guard let rootfile = contenedor.range(of: "<rootfile") else { return nil }
        let resto = contenedor[rootfile.upperBound...]
        guard let atributo = resto.range(of: "full-path=") else { return nil }
        let valor = resto[atributo.upperBound...]
        guard let comilla = valor.first, comilla == "\"" || comilla == "'" else { return nil }
        let dentro = valor.dropFirst()
        guard let cierre = dentro.firstIndex(of: comilla) else { return nil }
        let ruta = String(dentro[..<cierre])
        return ruta.isEmpty ? nil : ruta
    }

    /// Un entero sin signo de `n` bytes, el menos significativo primero; 0 si se sale de los datos.
    static func entero(_ bytes: [UInt8], _ posicion: Int, _ n: Int) -> Int {
        guard posicion >= 0, posicion + n <= bytes.count else { return 0 }
        var valor = 0
        for i in (0..<n).reversed() { valor = valor << 8 | Int(bytes[posicion + i]) }
        return valor
    }
}

// MARK: - DEFLATE

/// Descompresión DEFLATE (RFC 1951), como la de `puff.c` de zlib: bloques guardados, con los códigos de
/// Huffman fijos y con los dinámicos.
struct Inflado {
    private let entrada: [UInt8]
    private let maximo: Int
    private var posicion = 0
    /// Los bits leídos y aún sin usar, el primero en el bit más bajo.
    private var bits = 0
    private var cuantos = 0
    private(set) var salida: [UInt8] = []

    init(_ entrada: [UInt8], maximo: Int) {
        self.entrada = entrada
        self.maximo = maximo
    }

    /// Un código de Huffman canónico: cuántos símbolos hay de cada longitud y los símbolos ordenados.
    struct Huffman {
        var cuentas = [Int](repeating: 0, count: 16)
        var simbolos: [Int]

        init(longitudes: [Int]) {
            for longitud in longitudes { cuentas[longitud] += 1 }
            var desplazamientos = [Int](repeating: 0, count: 16)
            for longitud in 1..<15 { desplazamientos[longitud + 1] = desplazamientos[longitud] + cuentas[longitud] }
            simbolos = [Int](repeating: 0, count: longitudes.count)
            for (simbolo, longitud) in longitudes.enumerated() where longitud != 0 {
                simbolos[desplazamientos[longitud]] = simbolo
                desplazamientos[longitud] += 1
            }
        }
    }

    private static let basesDeLongitud = [
        3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31, 35, 43, 51, 59, 67, 83,
        99, 115, 131, 163, 195, 227, 258,
    ]
    private static let extrasDeLongitud = [
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5,
        5, 5, 0,
    ]
    private static let basesDeDistancia = [
        1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193, 257, 385, 513, 769,
        1025, 1537, 2049, 3073, 4097, 6145, 8193, 12_289, 16_385, 24_577,
    ]
    private static let extrasDeDistancia = [
        0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11,
        11, 12, 12, 13, 13,
    ]
    /// El orden en que vienen las longitudes del código de las longitudes.
    private static let orden = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15]
    private static let literalesFijos = Huffman(
        longitudes: [Int](repeating: 8, count: 144) + [Int](repeating: 9, count: 112)
            + [Int](repeating: 7, count: 24) + [Int](repeating: 8, count: 8))
    private static let distanciasFijas = Huffman(longitudes: [Int](repeating: 5, count: 30))

    mutating func descomprimir() throws {
        var final = 0
        repeat {
            final = try leer(1)
            switch try leer(2) {
            case 0: try guardado()
            case 1: try codigos(Inflado.literalesFijos, Inflado.distanciasFijas)
            case 2: try dinamico()
            default: throw ErrorDeImportacion.comprimido
            }
        } while final == 0
    }

    private mutating func leer(_ n: Int) throws -> Int {
        while cuantos < n {
            guard posicion < entrada.count else { throw ErrorDeImportacion.comprimido }
            bits |= Int(entrada[posicion]) << cuantos
            posicion += 1
            cuantos += 8
        }
        let valor = bits & ((1 << n) - 1)
        bits >>= n
        cuantos -= n
        return valor
    }

    private mutating func simbolo(_ codigo: Huffman) throws -> Int {
        var valor = 0
        var primero = 0
        var indice = 0
        for longitud in 1...15 {
            valor |= try leer(1)
            let cuenta = codigo.cuentas[longitud]
            if valor - cuenta < primero { return codigo.simbolos[indice + valor - primero] }
            indice += cuenta
            primero = (primero + cuenta) << 1
            valor <<= 1
        }
        throw ErrorDeImportacion.comprimido
    }

    /// Un bloque sin comprimir: empieza en el byte siguiente, con su largo y su complemento.
    private mutating func guardado() throws {
        bits = 0
        cuantos = 0
        guard posicion + 4 <= entrada.count else { throw ErrorDeImportacion.comprimido }
        let largo = Int(entrada[posicion]) | Int(entrada[posicion + 1]) << 8
        let complemento = Int(entrada[posicion + 2]) | Int(entrada[posicion + 3]) << 8
        posicion += 4
        guard largo == ~complemento & 0xFFFF, posicion + largo <= entrada.count, salida.count + largo <= maximo
        else { throw ErrorDeImportacion.comprimido }
        salida += entrada[posicion..<(posicion + largo)]
        posicion += largo
    }

    /// Un bloque con sus propios códigos, que vienen al principio, comprimidos a su vez.
    private mutating func dinamico() throws {
        let literales = try leer(5) + 257
        let distancias = try leer(5) + 1
        let delCodigo = try leer(4) + 4
        guard literales <= 286, distancias <= 30 else { throw ErrorDeImportacion.comprimido }
        var longitudes = [Int](repeating: 0, count: 19)
        for i in 0..<delCodigo { longitudes[Inflado.orden[i]] = try leer(3) }
        let codigoDeLongitudes = Huffman(longitudes: longitudes)
        var todas: [Int] = []
        while todas.count < literales + distancias {
            let s = try simbolo(codigoDeLongitudes)
            switch s {
            case 0..<16:
                todas.append(s)
            case 16:
                guard let anterior = todas.last else { throw ErrorDeImportacion.comprimido }
                let veces = try leer(2) + 3
                todas += [Int](repeating: anterior, count: veces)
            case 17:
                let veces = try leer(3) + 3
                todas += [Int](repeating: 0, count: veces)
            default:
                let veces = try leer(7) + 11
                todas += [Int](repeating: 0, count: veces)
            }
        }
        guard todas.count == literales + distancias else { throw ErrorDeImportacion.comprimido }
        try codigos(Huffman(longitudes: Array(todas[..<literales])), Huffman(longitudes: Array(todas[literales...])))
    }

    /// Los símbolos de un bloque comprimido: literales y copias de lo ya escrito, hasta el fin de bloque (256).
    private mutating func codigos(_ literales: Huffman, _ distancias: Huffman) throws {
        while true {
            var s = try simbolo(literales)
            if s < 256 {
                guard salida.count < maximo else { throw ErrorDeImportacion.comprimido }
                salida.append(UInt8(s))
            } else if s == 256 {
                return
            } else {
                s -= 257
                guard s < 29 else { throw ErrorDeImportacion.comprimido }
                let largo = try leer(Inflado.extrasDeLongitud[s]) + Inflado.basesDeLongitud[s]
                let d = try simbolo(distancias)
                guard d < 30 else { throw ErrorDeImportacion.comprimido }
                let distancia = try leer(Inflado.extrasDeDistancia[d]) + Inflado.basesDeDistancia[d]
                guard distancia <= salida.count, salida.count + largo <= maximo else {
                    throw ErrorDeImportacion.comprimido
                }
                for _ in 0..<largo { salida.append(salida[salida.count - distancia]) }
            }
        }
    }
}
