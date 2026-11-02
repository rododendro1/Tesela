import Foundation

// Un lector de XML propio, para MusicXML y MEI, en lugar del `XMLParser` de Foundation: en Linux, `XMLParser` viene
// en FoundationXML (que trae libxml2 y engorda el binario estático), pierde memoria con cada documento mal formado y
// detenía el programa con un nombre de elemento que no es UTF-8.
//
// Lee el documento de una pasada y avisa de cada elemento que se abre, del texto y de cada elemento que se cierra.
// Comprueba lo que hace falta para que el documento esté bien formado (un solo elemento raíz, cada uno cerrado con su
// nombre, comillas en los atributos) y no lee nada de fuera: la declaración de tipo (`<!DOCTYPE …>`) se salta, así
// que sus entidades no se definen ni se expanden (ni las externas ni las que se multiplican unas en otras). De las
// entidades, entiende las cinco de XML y las de carácter (`&#233;`, `&#xE9;`); las demás se dejan tal cual.

/// Lo que hace quien lee un documento con `LectorXML`.
protocol LectorDeElementosXML: AnyObject {
    func abre(_ nombre: String, atributos: [String: String])
    func texto(_ texto: String)
    func cierra(_ nombre: String)
}

enum LectorXML {
    /// Recorre el documento. Lanza `ErrorDeImportacion.xmlDanado` con la línea del primer error.
    static func leer(_ datos: Data, con lector: LectorDeElementosXML) throws {
        let bytes = try utf8(datos)
        var analizador = Analizador(bytes: bytes, lector: lector)
        try analizador.documento()
    }

    /// El nombre del elemento raíz, sin leer el resto; `nil` si no se llega a él.
    static func raiz(de datos: Data) -> String? {
        final class Raiz: LectorDeElementosXML {
            var nombre: String?
            func abre(_ nombre: String, atributos: [String: String]) {
                if self.nombre == nil { self.nombre = nombre }
            }
            func texto(_ texto: String) {}
            func cierra(_ nombre: String) {}
        }
        guard let bytes = try? utf8(datos.prefix(64 * 1024)) else { return nil }
        let raiz = Raiz()
        var analizador = Analizador(bytes: bytes, lector: raiz, soloLaRaiz: true)
        try? analizador.documento()
        return raiz.nombre
    }

    /// Los bytes en UTF-8: los de un documento en UTF-16 (con su marca) o en una codificación de un byte por carácter
    /// que declare (ISO-8859-1, Windows-1252…), convertidos; los de uno en UTF-8, comprobados.
    private static func utf8(_ datos: Data) throws -> [UInt8] {
        var bytes = [UInt8](datos)
        if bytes.starts(with: [0xFE, 0xFF]) || bytes.starts(with: [0xFF, 0xFE]) {
            let codificacion: String.Encoding = bytes[0] == 0xFE ? .utf16BigEndian : .utf16LittleEndian
            guard let texto = String(data: Data(bytes.dropFirst(2)), encoding: codificacion) else {
                throw ErrorDeImportacion.xmlDanado(linea: 1)
            }
            return Array(texto.utf8)
        }
        if bytes.starts(with: [0xEF, 0xBB, 0xBF]) { bytes.removeFirst(3) }
        if let codificacion = codificacionDeUnByte(bytes) {
            // Windows-1252 es ISO-8859-1 con caracteres en 0x80…0x9F; las demás de un byte, como Latin-1.
            let texto =
                codificacion.hasPrefix("windows-1252") || codificacion.hasPrefix("cp1252")
                ? String(data: Data(bytes), encoding: .windowsCP1252)
                : nil
            return Array((texto ?? String(String.UnicodeScalarView(bytes.map { Unicode.Scalar($0) }))).utf8)
        }
        if let linea = PiezaImportada.lineaConUTF8NoValido(Data(bytes)) {
            throw ErrorDeImportacion.xmlDanado(linea: linea)
        }
        return bytes
    }

    /// La codificación de un byte por carácter que declara el documento, en minúsculas, o `nil`.
    static func codificacionDeUnByte(_ bytes: [UInt8]) -> String? {
        let cabecera = String(decoding: bytes.prefix(200), as: UTF8.self)
        guard cabecera.hasPrefix("<?xml"), let fin = cabecera.range(of: "?>") else { return nil }
        let declaracion = cabecera[..<fin.lowerBound].lowercased()
        let deUnByte = #"encoding\s*=\s*["'](iso-8859-[0-9]+|latin-?[0-9]|windows-125[0-8]|cp125[0-8])["']"#
        guard let rango = declaracion.range(of: deUnByte, options: .regularExpression) else { return nil }
        let valor = declaracion[rango].split(whereSeparator: { $0 == "\"" || $0 == "'" })
        return valor.count > 1 ? String(valor[1]) : nil
    }

    private struct Fallo: Error {
        let posicion: Int
    }

    private struct Analizador {
        let bytes: [UInt8]
        let lector: LectorDeElementosXML
        var soloLaRaiz = false
        var i = 0
        var abiertos: [ArraySlice<UInt8>] = []
        var hayRaiz = false

        init(bytes: [UInt8], lector: LectorDeElementosXML, soloLaRaiz: Bool = false) {
            self.bytes = bytes
            self.lector = lector
            self.soloLaRaiz = soloLaRaiz
        }

        mutating func documento() throws {
            do {
                try recorrer()
            } catch let fallo as Fallo {
                let hasta = min(fallo.posicion, bytes.count)
                throw ErrorDeImportacion.xmlDanado(linea: 1 + bytes[..<hasta].lazy.filter { $0 == 0x0A }.count)
            }
        }

        private mutating func recorrer() throws {
            while i < bytes.count {
                if bytes[i] == UInt8(ascii: "<") {
                    if empieza("<?") {
                        try saltar(hasta: "?>")
                    } else if empieza("<!--") {
                        try saltar(hasta: "-->")
                    } else if empieza("<![CDATA[") {
                        guard !abiertos.isEmpty else { throw Fallo(posicion: i) }
                        let desde = i + 9
                        try saltar(hasta: "]]>")
                        lector.texto(String(decoding: bytes[desde..<(i - 3)], as: UTF8.self))
                    } else if empieza("<!") {
                        try declaracionDeTipo()
                    } else if empieza("</") {
                        try cierre()
                    } else {
                        try apertura()
                        if soloLaRaiz { return }
                    }
                } else {
                    let desde = i
                    while i < bytes.count, bytes[i] != UInt8(ascii: "<") { i += 1 }
                    let trozo = bytes[desde..<i]
                    if abiertos.isEmpty {
                        // Fuera de la raíz solo puede haber espacios.
                        guard trozo.allSatisfy(Analizador.esEspacio) else { throw Fallo(posicion: desde) }
                    } else {
                        lector.texto(try Analizador.sinEntidades(trozo, desde: desde))
                    }
                }
            }
            guard hayRaiz, abiertos.isEmpty else { throw Fallo(posicion: bytes.count) }
        }

        private func empieza(_ prefijo: StaticString) -> Bool {
            let p = UnsafeBufferPointer(start: prefijo.utf8Start, count: prefijo.utf8CodeUnitCount)
            guard i + p.count <= bytes.count else { return false }
            for k in 0..<p.count where bytes[i + k] != p[k] { return false }
            return true
        }

        /// Avanza hasta justo después de `fin`.
        private mutating func saltar(hasta fin: StaticString) throws {
            let desde = i
            while i < bytes.count {
                if empieza(fin) {
                    i += fin.utf8CodeUnitCount
                    return
                }
                i += 1
            }
            throw Fallo(posicion: desde)
        }

        /// `<!DOCTYPE raiz SYSTEM "…" [ … ]>`: se salta, con su subconjunto interno, sin definir nada.
        private mutating func declaracionDeTipo() throws {
            guard !hayRaiz else { throw Fallo(posicion: i) }
            let desde = i
            var corchetes = 0
            var comilla: UInt8?
            i += 2
            while i < bytes.count {
                if comilla == nil, empieza("<!--") {
                    try saltar(hasta: "-->")
                    continue
                }
                let b = bytes[i]
                i += 1
                if let c = comilla {
                    if b == c { comilla = nil }
                } else if b == UInt8(ascii: "\"") || b == UInt8(ascii: "'") {
                    comilla = b
                } else if b == UInt8(ascii: "[") {
                    corchetes += 1
                } else if b == UInt8(ascii: "]") {
                    corchetes -= 1
                } else if b == UInt8(ascii: ">"), corchetes <= 0 {
                    return
                }
            }
            throw Fallo(posicion: desde)
        }

        private mutating func apertura() throws {
            let desde = i
            i += 1
            let nombre = try leerNombre()
            if abiertos.isEmpty && hayRaiz { throw Fallo(posicion: desde) } // una segunda raíz
            var atributos: [String: String] = [:]
            while true {
                let hayEspacio = saltarEspacios()
                guard i < bytes.count else { throw Fallo(posicion: desde) }
                if bytes[i] == UInt8(ascii: ">") {
                    i += 1
                    hayRaiz = true
                    abiertos.append(nombre)
                    lector.abre(String(decoding: nombre, as: UTF8.self), atributos: atributos)
                    return
                }
                if empieza("/>") {
                    i += 2
                    hayRaiz = true
                    let texto = String(decoding: nombre, as: UTF8.self)
                    lector.abre(texto, atributos: atributos)
                    lector.cierra(texto)
                    return
                }
                guard hayEspacio else { throw Fallo(posicion: i) }
                let atributo = String(decoding: try leerNombre(), as: UTF8.self)
                saltarEspacios()
                guard i < bytes.count, bytes[i] == UInt8(ascii: "=") else { throw Fallo(posicion: i) }
                i += 1
                saltarEspacios()
                guard i < bytes.count, bytes[i] == UInt8(ascii: "\"") || bytes[i] == UInt8(ascii: "'") else {
                    throw Fallo(posicion: i)
                }
                let comilla = bytes[i]
                i += 1
                let inicio = i
                while i < bytes.count, bytes[i] != comilla {
                    guard bytes[i] != UInt8(ascii: "<") else { throw Fallo(posicion: i) }
                    i += 1
                }
                guard i < bytes.count else { throw Fallo(posicion: inicio) }
                let valor = try Analizador.sinEntidades(bytes[inicio..<i], desde: inicio)
                i += 1
                guard atributos.updateValue(valor, forKey: atributo) == nil else { throw Fallo(posicion: inicio) }
            }
        }

        private mutating func cierre() throws {
            let desde = i
            i += 2
            let nombre = try leerNombre()
            saltarEspacios()
            guard i < bytes.count, bytes[i] == UInt8(ascii: ">"), let ultimo = abiertos.last,
                ultimo.elementsEqual(nombre)
            else { throw Fallo(posicion: desde) }
            i += 1
            abiertos.removeLast()
            lector.cierra(String(decoding: nombre, as: UTF8.self))
        }

        /// Un nombre de elemento o de atributo: hasta un espacio, `=`, `/` o `>`.
        private mutating func leerNombre() throws -> ArraySlice<UInt8> {
            let desde = i
            while i < bytes.count {
                let b = bytes[i]
                if Analizador.esEspacio(b) || b == UInt8(ascii: "=") || b == UInt8(ascii: "/") || b == UInt8(ascii: ">")
                {
                    break
                }
                guard b != UInt8(ascii: "<"), b != UInt8(ascii: "\""), b != UInt8(ascii: "'"), b != UInt8(ascii: "&")
                else { throw Fallo(posicion: i) }
                i += 1
            }
            guard i > desde else { throw Fallo(posicion: desde) }
            let primero = bytes[desde]
            // No empieza por una cifra, un guion o un punto.
            guard !(UInt8(ascii: "0")...UInt8(ascii: "9")).contains(primero), primero != UInt8(ascii: "-"),
                primero != UInt8(ascii: ".")
            else { throw Fallo(posicion: desde) }
            return bytes[desde..<i]
        }

        @discardableResult
        private mutating func saltarEspacios() -> Bool {
            let desde = i
            while i < bytes.count, Analizador.esEspacio(bytes[i]) { i += 1 }
            return i > desde
        }

        static func esEspacio(_ b: UInt8) -> Bool {
            b == 0x20 || b == 0x09 || b == 0x0A || b == 0x0D
        }

        /// El texto con las entidades sustituidas: las cinco de XML y las de carácter. Las demás quedan tal cual.
        static func sinEntidades(_ trozo: ArraySlice<UInt8>, desde: Int) throws -> String {
            guard trozo.contains(UInt8(ascii: "&")) else { return String(decoding: trozo, as: UTF8.self) }
            var salida: [UInt8] = []
            salida.reserveCapacity(trozo.count)
            var k = trozo.startIndex
            while k < trozo.endIndex {
                let b = trozo[k]
                guard b == UInt8(ascii: "&"),
                    let fin = trozo[k...].prefix(12).firstIndex(of: UInt8(ascii: ";"))
                else {
                    salida.append(b)
                    k += 1
                    continue
                }
                let nombre = String(decoding: trozo[(k + 1)..<fin], as: UTF8.self)
                let sustituto: String?
                switch nombre {
                case "lt": sustituto = "<"
                case "gt": sustituto = ">"
                case "amp": sustituto = "&"
                case "quot": sustituto = "\""
                case "apos": sustituto = "'"
                default:
                    if nombre.hasPrefix("#") {
                        let cifras = nombre.dropFirst()
                        let valor =
                            cifras.first == "x" || cifras.first == "X"
                            ? UInt32(cifras.dropFirst(), radix: 16) : UInt32(cifras, radix: 10)
                        guard let valor, let escalar = Unicode.Scalar(valor), valor != 0 else {
                            throw Fallo(posicion: desde + (k - trozo.startIndex))
                        }
                        sustituto = String(Character(escalar))
                    } else {
                        sustituto = nil
                    }
                }
                if let sustituto {
                    salida += Array(sustituto.utf8)
                    k = fin + 1
                } else {
                    salida.append(b)
                    k += 1
                }
            }
            return String(decoding: salida, as: UTF8.self)
        }
    }
}
