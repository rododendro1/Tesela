// Lectura de clases de altura escritas a mano, para los conjuntos y las series.
//
// Se aceptan las formas habituales de los manuales y del análisis:
//
//     [0, 4, 7]   {0 4 7}   (0,4,7)   0 4 7        números separados por comas o espacios
//     047   01t   0e3487956 12t                    una cifra por clase, con t = 10 y e = 11
//     10 11                                        un número de 0 a 11 sin ceros delante es esa clase
//     Do Mi Sol   C E G   Sib Re Fa               nombres de nota
//
// Los corchetes, las llaves y los paréntesis son opcionales; si se abren, se cierran. Un texto se lee entero
// como clases o entero como notas, sin mezclar: así «C E G» son Do, Mi y Sol, y «0 4 E» son 0, 4 y 11.

package enum LecturaDeClases {
    /// Las clases de altura escritas en `texto`, en su orden y con sus repeticiones.
    package static func leer(_ texto: String) throws -> [Int] {
        var lector = Lector(texto)
        try lector.exigirContenido()
        let aperturas: [Character: Character] = ["[": "]", "{": "}", "(": ")"]
        var cierre: Character?
        if let primero = lector.siguiente, let pareja = aperturas[primero] {
            cierre = pareja
            lector.resto = lector.resto.dropFirst()
        }
        let delimitadores: Set<Character> = ["[", "]", "{", "}", "(", ")"]
        var fichas: [(texto: String, posicion: Int)] = []
        var cerrado = false
        while true {
            _ = lector.leer(mientras: { $0 == " " || $0 == "," })
            guard let caracter = lector.siguiente else { break }
            if caracter == cierre {
                lector.resto = lector.resto.dropFirst()
                cerrado = true
                break
            }
            let posicion = lector.posicion
            let ficha = lector.leer(mientras: { $0 != " " && $0 != "," && !delimitadores.contains($0) })
            guard !ficha.isEmpty else { throw lector.error(.caracteresSobrantes(lector.restoSinEspacios)) }
            fichas.append((ficha, posicion))
        }
        if let cierre, !cerrado {
            throw lector.error(.faltaElCierre(String(cierre)), posicion: texto.count)
        }
        lector.saltarEspacios()
        guard lector.haTerminado else { throw lector.error(.caracteresSobrantes(lector.restoSinEspacios)) }
        guard !fichas.isEmpty else {
            if cierre != nil { return [] }
            throw lector.error(.claseDeAlturaNoValida(texto.trimmingEspacios()), posicion: 0)
        }

        let comoClases = fichas.map { clases(en: $0.texto) }
        if comoClases.allSatisfy({ $0 != nil }) { return comoClases.flatMap { $0 ?? [] } }
        let comoNotas = fichas.map { try? Nota(leyendo: $0.texto) }
        if comoNotas.allSatisfy({ $0 != nil }) { return comoNotas.compactMap { $0?.claseDeAltura } }

        // La primera que no es ni lo uno ni lo otro; si todas son algo, están mezcladas: la primera que no es clase.
        let fallida =
            fichas.indices.first { comoClases[$0] == nil && comoNotas[$0] == nil }
            ?? fichas.indices.first { comoClases[$0] == nil } ?? 0
        let ficha = fichas[fallida]
        throw lector.error(.claseDeAlturaNoValida(ficha.texto), posicion: ficha.posicion)
    }

    /// Las clases de una ficha: un número de 0 a 11 escrito sin ceros delante («7», «11»), o una cifra por clase
    /// («047», «t», «0e»). `nil` si no es ninguna de las dos cosas.
    package static func clases(en ficha: String) -> [Int]? {
        if let numero = Int(ficha), ficha.allSatisfy({ $0.isASCII && $0.isNumber }), (0...11).contains(numero),
            ficha == String(numero)
        {
            return [numero]
        }
        var resultado: [Int] = []
        for caracter in ficha {
            switch caracter {
            case "t", "T": resultado.append(10)
            case "e", "E": resultado.append(11)
            case let c where c.isASCII && c.isNumber: resultado.append(Int(String(c)) ?? 0)
            default: return nil
            }
        }
        return resultado.isEmpty ? nil : resultado
    }

    /// Una clase con una sola cifra o letra: 10 → «t», 11 → «e». Es como se escriben las series.
    package static func cifra(_ clase: Int) -> String {
        switch clase {
        case 10: return "t"
        case 11: return "e"
        default: return String(clase)
        }
    }
}

extension ConjuntoDeClases {
    /// Lee un conjunto escrito a mano: «[0, 4, 7]», «{0 4 7}», «047», «01t», «Do Mi Sol», «C E G», o su número de
    /// Forte («3-11», «4-Z15»; la Z puede faltar), que da la forma prima.
    ///
    /// En las cifras seguidas, `t` es 10 y `e` es 11; un número de 0 a 11 sin ceros delante es esa clase («10 11»).
    /// Las repeticiones no cuentan: «0 4 7 0» es [0, 4, 7]. «[]» es el conjunto vacío.
    ///
    ///     try ConjuntoDeClases(leyendo: "[0, 4, 7]")   // [0, 4, 7]
    ///     try ConjuntoDeClases(leyendo: "01t")         // [0, 1, 10]
    ///     try ConjuntoDeClases(leyendo: "Re Fa La")    // [2, 5, 9]
    ///     try ConjuntoDeClases(leyendo: "4-Z15")       // [0, 1, 4, 6]
    ///
    /// Lanza `ErrorDeLectura` con el carácter donde no se pudo seguir.
    public init(leyendo texto: String) throws {
        let limpio = texto.trimmingEspacios()
        if let forte = ConjuntoDeClases.numeroConFormaDeForte(limpio) {
            guard let prima = ConjuntoDeClases.primasPorNumeroDeForte[forte] else {
                throw ErrorDeLectura(
                    texto: texto, posicion: texto.count - texto.drop(while: { $0 == " " }).count,
                    motivo: .numeroDeForteDesconocido(limpio))
            }
            self.init(prima)
            return
        }
        self.init(try LecturaDeClases.leer(texto))
    }

    /// «4-z15» → «4-15», si el texto tiene la forma de un número de Forte; si no, `nil`.
    private static func numeroConFormaDeForte(_ texto: String) -> String? {
        let partes = texto.split(separator: "-", omittingEmptySubsequences: false)
        guard partes.count == 2, let cardinal = partes.first, let orden = partes.last else { return nil }
        let sinZ = orden.first == "Z" || orden.first == "z" ? orden.dropFirst() : orden
        let soloCifras = { (s: Substring) in !s.isEmpty && s.count <= 2 && s.allSatisfy { $0.isASCII && $0.isNumber } }
        guard soloCifras(cardinal), soloCifras(sinZ) else { return nil }
        return "\(Int(cardinal) ?? 0)-\(Int(sinZ) ?? 0)"
    }

    /// La forma prima de cada número de Forte, sin la Z: «4-15» → [0, 1, 4, 6].
    private static let primasPorNumeroDeForte: [String: [Int]] = Dictionary(
        uniqueKeysWithValues: tablaForte.map { prima, numero in (numero.replacingOccurrences(of: "Z", with: ""), prima)
        }
    )
}
