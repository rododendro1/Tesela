// MARK: - Sistemas de nombres
//
// Los nombres de nota de otras tradiciones, que no son un idioma: el bizantino (Ni Pa Vou Ga Di Ke Zo) y el sargam
// indio (Sā Re Ga ma Pa Dha Ni). Un `Idioma` decide a la vez los nombres de nota y la lengua de los textos; un sistema
// de nombres solo decide los nombres, y los textos siguen en el idioma que se elija.
//
// Hay dos familias. En los sistemas fijos cada nota tiene su nombre, como en un idioma: en el bizantino, Ni es Do,
// como en los echoi de `TipoDeEscala+Bizancio`. En los móviles el nombre es el de un grado respecto a una tónica: en
// el sargam, Sā es la tónica, y «Pa» es Sol solo si Sā es Do. Por eso los nombres se piden con la tónica
// (`nombre(de:tonica:grafia:)`), que los fijos no usan.
//
// Cada sistema se escribe de tres formas (`Grafia`): con su escritura original (griego, devanagari), transliterado (con
// IAST en el sargam: Sā) y en ASCII (Sa).

/// Un sistema de nombres de nota de otra tradición: `SistemaDeNombres.sargam.nombre(de: Nota("Mib"))` es «ga».
public enum SistemaDeNombres: String, Hashable, Sendable, CaseIterable, Codable {
    /// Los nombres de la salmodia bizantina, de Do a Si: Ni Pa Vou Ga Di Ke Zo (Νη Πα Βου Γα Δι Κε Ζω). Es fijo: Ni
    /// es siempre Do, como en la teoría de la Comisión Patriarcal (1881) y en los echoi del catálogo. Las alteraciones
    /// se escriben con los signos de siempre: Fa♯ es Ga♯.
    case bizantino
    /// El sargam de la música indostaní, del primer grado al séptimo: Sā Re Ga ma Pa Dha Ni (सा रे ग म प ध नि). Es
    /// móvil: Sā es la tónica. Re, Ga, Dha y Ni komal (un semitono más bajos) van en minúscula (re, ga, dha, ni), y
    /// el Ma tivra (un semitono más alto) en mayúscula; el ma natural (shuddha), en minúscula. Es la convención de las
    /// escalas indias del catálogo (Kāfī: Sā Re ga ma Pa Dha ni). En devanagari, el komal lleva una raya debajo (रे॒)
    /// y el tivra un trazo encima (म॑).
    case sargam

    /// Si cada nota tiene su nombre (`.fija`) o el nombre depende de la tónica (`.movil`).
    public var familia: FamiliaDeNombres {
        switch self {
        case .bizantino: return .fija
        case .sargam: return .movil
        }
    }

    /// Los nombres del sistema en minúsculas y sin tildes, para leerlo en la línea de comandos o en los ajustes:
    /// «bizantino», «byzantine»; «sargam», «sargama».
    public var nombres: [String] {
        switch self {
        case .bizantino: return ["bizantino", "byzantine", "bizantziarra"]
        case .sargam: return ["sargam", "sargama", "swara", "svara"]
        }
    }

    /// El sistema de uno de sus `nombres` o de su `rawValue`, sin importar las mayúsculas ni las tildes; `nil` si no
    /// es ninguno.
    public init?(nombre: String) {
        let clave = nombre.claveDeBusqueda
        guard
            let sistema = SistemaDeNombres.allCases.first(where: { $0.rawValue == clave || $0.nombres.contains(clave) })
        else {
            return nil
        }
        self = sistema
    }

    /// Los siete nombres de los grados naturales (de Do a Si, o del primer grado al séptimo) en una grafía: en el
    /// sargam, los de los grados shuddha (con el ma en minúscula).
    public func naturales(en grafia: Grafia) -> [String] {
        switch (self, grafia) {
        case (.bizantino, .original): return ["Νη", "Πα", "Βου", "Γα", "Δι", "Κε", "Ζω"]
        case (.bizantino, .transliterada), (.bizantino, .ascii): return ["Ni", "Pa", "Vou", "Ga", "Di", "Ke", "Zo"]
        case (.sargam, .original): return ["सा", "रे", "ग", "म", "प", "ध", "नि"]
        case (.sargam, .transliterada): return ["Sā", "Re", "Ga", "ma", "Pa", "Dha", "Ni"]
        case (.sargam, .ascii): return ["Sa", "Re", "Ga", "ma", "Pa", "Dha", "Ni"]
        }
    }
}

/// Las dos familias de ``SistemaDeNombres``.
public enum FamiliaDeNombres: String, Hashable, Sendable, CaseIterable, Codable {
    /// Cada nota tiene su nombre, como en un idioma: en el bizantino, Ni es Do.
    case fija
    /// El nombre es el de un grado respecto a una tónica: en el sargam, Sā es la tónica.
    case movil
}

/// Cómo se escriben los nombres de un ``SistemaDeNombres``.
public enum Grafia: String, Hashable, Sendable, CaseIterable, Codable {
    /// Con la escritura de la tradición: Νη Πα Βου; सा रे ग. Las alteraciones que el sistema no nombra, con ♯ y ♭.
    case original
    /// Transliterado al alfabeto latino, con diacríticos: Ni Pa Vou; Sā Re Ga (IAST). Con ♯ y ♭.
    case transliterada
    /// Transliterado sin diacríticos y con # y b: Ni Pa Vou; Sa Re Ga.
    case ascii
}

// MARK: - Escritura

extension SistemaDeNombres {
    /// El nombre de una nota en el sistema. En los fijos no se usa la tónica: Fa♯ es siempre Ga♯ en bizantino. En
    /// los móviles, el nombre es el del grado desde `tonica` (Do si no se da): con la tónica en Re, Fa es «ga» (el
    /// Ga komal) y Fa♯, «Ga».
    ///
    ///     SistemaDeNombres.bizantino.nombre(de: Nota("Fa#"))                       // "Ga♯"
    ///     SistemaDeNombres.bizantino.nombre(de: Nota("Re"), grafia: .original)     // "Πα"
    ///     SistemaDeNombres.sargam.nombre(de: Nota("Fa"), tonica: Nota("Re"))       // "ga"
    ///     SistemaDeNombres.sargam.nombre(de: Nota("Fa#"), grafia: .original)       // "म॑"
    ///
    /// Una alteración que el sistema no nombra se escribe con signos tras el nombre: en sargam, el Sā sostenido es
    /// «Sā♯» y el Re doble bemol, «re♭» (el komal, un semitono más bajo).
    public func nombre(de nota: Nota, tonica: Nota = Nota(.do), grafia: Grafia = .transliterada) -> String {
        let grado = familia == .fija ? nota : Nota(pasosDeQuinta: nota.pasosDeQuinta - tonica.pasosDeQuinta)
        let indice = grado.natural.rawValue
        var alteracion = grado.alteracion.semitonos
        var base = naturales(en: grafia)[indice]
        if self == .sargam, let propia = SistemaDeNombres.alteracionPropiaDelSargam(indice, alteracion) {
            // El komal o el tivra, que tienen nombre propio: ga, Ma.
            base = SistemaDeNombres.nombreDelSargam(indice, propia, grafia: grafia)
            alteracion -= propia
        }
        let signos = Alteracion(alteracion).simbolo(en: grafia == .ascii ? .ascii : .conSimples)
        return base + signos
    }

    /// Los nombres de varias notas, como ``nombre(de:tonica:grafia:)``.
    public func nombres(de notas: [Nota], tonica: Nota = Nota(.do), grafia: Grafia = .transliterada) -> [String] {
        notas.map { nombre(de: $0, tonica: tonica, grafia: grafia) }
    }

    /// La alteración que el sargam nombra en el grado `indice` (de 0, Sā, a 6, Ni), si `alteracion` la incluye: −1
    /// (komal) en Re, Ga, Dha y Ni, y +1 (tivra) en Ma; `nil` en los demás casos.
    private static func alteracionPropiaDelSargam(_ indice: Int, _ alteracion: Int) -> Int? {
        switch indice {
        case 1, 2, 5, 6: return alteracion < 0 ? -1 : nil
        case 3: return alteracion > 0 ? 1 : nil
        default: return nil
        }
    }

    /// El nombre del komal o del tivra del grado `indice`: re, ga, dha, ni; Ma. En devanagari, con la raya de debajo
    /// (U+0952) o el trazo de encima (U+0951).
    private static func nombreDelSargam(_ indice: Int, _ alteracion: Int, grafia: Grafia) -> String {
        let natural = SistemaDeNombres.sargam.naturales(en: grafia)[indice]
        switch grafia {
        case .original: return natural + (alteracion < 0 ? "\u{0952}" : "\u{0951}")
        case .transliterada, .ascii: return alteracion < 0 ? natural.lowercased() : natural.conMayusculaInicial
        }
    }
}

// MARK: - Lectura

extension SistemaDeNombres {
    /// Lee un nombre escrito en el sistema, en cualquiera de sus grafías, con las alteraciones que no tienen nombre
    /// propio en signos (#, b, ♯, ♭, x, 𝄪, 𝄫). En los móviles, el grado se cuenta desde `tonica` (Do si no se da).
    ///
    ///     try SistemaDeNombres.bizantino.leer("Γα♯")                       // Fa♯
    ///     try SistemaDeNombres.bizantino.leer("vou b")                     // Mi♭
    ///     try SistemaDeNombres.sargam.leer("ga", tonica: Nota("Re"))       // Fa
    ///     try SistemaDeNombres.sargam.leer("Ma")                           // Fa♯
    ///     try SistemaDeNombres.sargam.leer("रे॒")                            // Re♭
    ///
    /// En el bizantino no cuentan las mayúsculas ni las tildes («νή», «NI»). En el sargam sí cuentan las mayúsculas,
    /// porque separan el grado natural del komal (Re, re) y el ma del Ma tivra; no cuentan las tildes («Sa» y «Sā»).
    /// Si no se puede leer, lanza `ErrorDeLectura` (`.notaNoReconocida`).
    public func leer(_ texto: String, tonica: Nota = Nota(.do)) throws -> Nota {
        let escalares = Array(SistemaDeNombres.normalizar(texto, para: self).unicodeScalars)
        // El nombre más largo que empiece el texto: «Dha» antes que «D…», «नि» antes que «न».
        let candidatos = formasDeLectura.filter { escalares.starts(with: $0.escalares) }
        guard let forma = candidatos.max(by: { $0.escalares.count < $1.escalares.count }) else {
            throw ErrorDeLectura(texto: texto, posicion: 0, motivo: .notaNoReconocida)
        }
        var resto = String(String.UnicodeScalarView(escalares.dropFirst(forma.escalares.count)))
        var alteracion = forma.alteracion
        // En devanagari, la raya de debajo (komal) y el trazo de encima (tivra) van tras la sílaba.
        let marcas: [Unicode.Scalar] = ["\u{0951}", "\u{0952}"]
        if self == .sargam, let marca = resto.unicodeScalars.first, marcas.contains(marca) {
            alteracion += marca == "\u{0952}" ? -1 : 1
            resto = String(String.UnicodeScalarView(resto.unicodeScalars.dropFirst()))
        }
        let signos = try Alteracion(leyendo: resto)
        let grado = Nota(NotaNatural(rawValue: forma.indice) ?? .do, Alteracion(alteracion) + signos)
        guard familia == .movil else { return grado }
        return Nota(pasosDeQuinta: grado.pasosDeQuinta + tonica.pasosDeQuinta)
    }

    /// Una forma escrita de un grado, ya normalizada como el texto que se lee, con su grado (0…6) y la alteración
    /// que nombra.
    private struct FormaDeLectura {
        let escalares: [Unicode.Scalar]
        let indice: Int
        let alteracion: Int
    }

    /// Las formas que se leen: los naturales de las tres grafías y, en el sargam, el komal y el tivra
    /// transliterados (re, ga, dha, ni; Ma) y Sa y Pa en minúscula, que no se confunden con nada.
    private var formasDeLectura: [FormaDeLectura] {
        var formas: [(String, Int, Int)] = []
        for grafia in Grafia.allCases {
            for (indice, nombre) in naturales(en: grafia).enumerated() { formas.append((nombre, indice, 0)) }
        }
        if self == .bizantino {
            // La otra transliteración de Βου, la que sigue la letra: «Bou».
            formas.append(("Bou", 2, 0))
        }
        if self == .sargam {
            formas += [
                ("re", 1, -1), ("ga", 2, -1), ("dha", 5, -1), ("ni", 6, -1), ("Ma", 3, 1), ("sa", 0, 0), ("pa", 4, 0),
            ]
        }
        return formas.map { nombre, indice, alteracion in
            FormaDeLectura(
                escalares: Array(SistemaDeNombres.normalizar(nombre, para: self).unicodeScalars),
                indice: indice, alteracion: alteracion)
        }
    }

    /// El texto como se compara al leer: en el bizantino, sin mayúsculas, tildes ni espacios; en el sargam, sin
    /// espacios y con la ā como a, pero con las mayúsculas.
    private static func normalizar(_ texto: String, para sistema: SistemaDeNombres) -> String {
        switch sistema {
        case .bizantino:
            return texto.claveDeBusqueda.split(separator: " ").joined()
        case .sargam:
            // La ā, compuesta (U+0101) o con el macrón aparte (U+0304), se lee como a.
            var escalares = String.UnicodeScalarView()
            for escalar in texto.unicodeScalars where escalar != " " && escalar != "\u{0304}" {
                switch escalar {
                case "\u{0101}": escalares.append("a")
                case "\u{0100}": escalares.append("A")
                default: escalares.append(escalar)
                }
            }
            return String(escalares)
        }
    }
}
