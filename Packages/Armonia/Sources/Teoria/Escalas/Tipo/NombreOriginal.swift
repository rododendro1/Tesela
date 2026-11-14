import Elementos

// MARK: - El nombre de una escala en su escritura original

/// Un nombre de la escala en el idioma y la escritura de su tradición: «حجاز» para Ḥijāz, «宮» para Gōng, «बिलावल»
/// para Bilāval. `nombre`, `alias` y `variantes` están en escritura latina; esto es lo que escribe la propia tradición.
///
///     TipoDeEscala.hiyaz.nombreOriginal?.texto            // "حجاز"
///     TipoDeEscala.hiyaz.nombreOriginal?.idioma.codigo    // "ar"
///     TipoDeEscala.yo.nombresOriginales.map(\.texto)      // ["陽", "陽音階"]
///     TipoDeEscala.yo.nombresOriginales[1].lectura        // "Yō onkai"
public struct NombreOriginal: Sendable, Hashable {
    /// El texto, en NFC: «حجاز», «陽音階», «سه\u{200C}گاه» (con su ZWNJ).
    public let texto: String
    public let idioma: IdiomaOriginal
    /// Cómo se lee, si no es el `nombre` de la escala: «Yō onkai» para 陽音階, «Liùlǜ» para 六律. `nil` si es el
    /// `nombre`.
    public let lectura: String?

    package init(_ texto: String, _ idioma: IdiomaOriginal, lectura: String? = nil) {
        self.texto = texto
        self.idioma = idioma
        self.lectura = lectura
    }
}

// MARK: - Idioma

/// El idioma de un nombre original. Su valor es su etiqueta BCP 47 («ar», «zh-Hant»), la que piden el `lang` del HTML
/// y el `languageIdentifier` de un `AttributedString`: con ella se escogen los glifos (宮 se dibuja distinto en chino
/// y en japonés), la dirección del texto y la voz que lo lee.
public enum IdiomaOriginal: String, Sendable, CaseIterable, Codable {
    case arabe = "ar"
    case persa = "fa"
    case sanscrito = "sa"
    case hindi = "hi"
    /// Los caracteres que se escriben igual en chino simplificado y tradicional: 商, 羽, 十二律.
    case chino = "zh"
    case chinoSimplificado = "zh-Hans"
    case chinoTradicional = "zh-Hant"
    case japones = "ja"
    case coreano = "ko"
    case amarico = "am"
    case griego = "el"
    /// El politónico de los teóricos antiguos: δωριστί, χρῶμα μαλακόν.
    case griegoAntiguo = "grc"
    case hebreo = "he"
    case yidis = "yi"
    case birmano = "my"
    case tailandes = "th"
    case jemer = "km"

    /// La etiqueta BCP 47: «ar», «zh-Hant».
    public var codigo: String { rawValue }

    public var escritura: Escritura {
        switch self {
        case .arabe, .persa: .arabe
        case .sanscrito, .hindi: .devanagari
        case .chino, .chinoSimplificado, .chinoTradicional: .han
        case .japones: .japonesa
        case .coreano: .hangul
        case .amarico: .etiope
        case .griego, .griegoAntiguo: .griega
        case .hebreo, .yidis: .hebrea
        case .birmano: .birmana
        case .tailandes: .tailandesa
        case .jemer: .jemer
        }
    }

    /// ¿Se escribe de derecha a izquierda? El árabe, el persa, el hebreo y el yidis.
    public var deDerechaAIzquierda: Bool { escritura.deDerechaAIzquierda }

    /// El nombre del idioma en el idioma de los textos de la notación: «árabe», «Arabic», «arabiera».
    ///
    ///     IdiomaOriginal.chinoTradicional.nombre(en: .compacta(.ingles))   // "traditional Chinese"
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El `switch` no tiene `default`: un idioma nuevo no compila sin su nombre en los trece idiomas.
    private var traduccion: Traduccion {
        switch self {
        case .arabe: TextosDeTeoria.traduccion(\.idiomaArabe)
        case .persa: TextosDeTeoria.traduccion(\.idiomaPersa)
        case .sanscrito: TextosDeTeoria.traduccion(\.idiomaSanscrito)
        case .hindi: TextosDeTeoria.traduccion(\.idiomaHindi)
        case .chino: TextosDeTeoria.traduccion(\.idiomaChino)
        case .chinoSimplificado: TextosDeTeoria.traduccion(\.idiomaChinoSimplificado)
        case .chinoTradicional: TextosDeTeoria.traduccion(\.idiomaChinoTradicional)
        case .japones: TextosDeTeoria.traduccion(\.idiomaJapones)
        case .coreano: TextosDeTeoria.traduccion(\.idiomaCoreano)
        case .amarico: TextosDeTeoria.traduccion(\.idiomaAmarico)
        case .griego: TextosDeTeoria.traduccion(\.idiomaGriego)
        case .griegoAntiguo: TextosDeTeoria.traduccion(\.idiomaGriegoAntiguo)
        case .hebreo: TextosDeTeoria.traduccion(\.idiomaHebreo)
        case .yidis: TextosDeTeoria.traduccion(\.idiomaYidis)
        case .birmano: TextosDeTeoria.traduccion(\.idiomaBirmano)
        case .tailandes: TextosDeTeoria.traduccion(\.idiomaTailandes)
        case .jemer: TextosDeTeoria.traduccion(\.idiomaJemer)
        }
    }
}

extension IdiomaOriginal: Nombrable {}

// MARK: - Escritura

/// La escritura de un nombre original. Su valor es su código ISO 15924.
public enum Escritura: String, Sendable, CaseIterable, Codable {
    case arabe = "Arab"
    case devanagari = "Deva"
    case han = "Hani"
    /// Los kanji y los kana.
    case japonesa = "Jpan"
    case hangul = "Hang"
    case etiope = "Ethi"
    case griega = "Grek"
    case hebrea = "Hebr"
    case birmana = "Mymr"
    case tailandesa = "Thai"
    case jemer = "Khmr"

    /// El código ISO 15924: «Arab», «Deva».
    public var codigo: String { rawValue }

    /// ¿Se escribe de derecha a izquierda?
    public var deDerechaAIzquierda: Bool {
        switch self {
        case .arabe, .hebrea: true
        case .devanagari, .han, .japonesa, .hangul, .etiope, .griega, .tailandesa, .jemer, .birmana: false
        }
    }

    /// Los bloques Unicode de sus letras y sus signos. Además de ellos, un nombre puede llevar espacios y, en las
    /// escrituras que los usan, ZWNJ y ZWJ (`admiteUnionesDeAnchoCero`).
    package var bloques: [ClosedRange<UInt32>] {
        switch self {
        case .arabe: [0x0600...0x06FF, 0x0750...0x077F, 0x08A0...0x08FF, 0xFB50...0xFDFF, 0xFE70...0xFEFF]
        case .devanagari: [0x0900...0x097F, 0xA8E0...0xA8FF]
        case .han: [0x3400...0x4DBF, 0x4E00...0x9FFF, 0xF900...0xFAFF, 0x20000...0x2FA1F]
        case .japonesa: [0x3040...0x30FF, 0x3400...0x4DBF, 0x4E00...0x9FFF, 0xF900...0xFAFF]
        case .hangul: [0x1100...0x11FF, 0x3130...0x318F, 0xAC00...0xD7AF]
        case .etiope: [0x1200...0x139F, 0x2D80...0x2DDF, 0xAB00...0xAB2F]
        case .griega: [0x0370...0x03FF, 0x1F00...0x1FFF]
        case .tailandesa: [0x0E00...0x0E7F]
        case .jemer: [0x1780...0x17FF, 0x19E0...0x19FF]
        case .hebrea: [0x0590...0x05FF, 0xFB1D...0xFB4F]
        case .birmana: [0x1000...0x109F, 0xA9E0...0xA9FF, 0xAA60...0xAA7F]
        }
    }

    /// ¿Usa ZWNJ y ZWJ dentro de las palabras? El persa (سه\u{200C}گاه) y las escrituras índicas.
    package var admiteUnionesDeAnchoCero: Bool {
        switch self {
        case .arabe, .devanagari: true
        case .han, .japonesa, .hangul, .etiope, .griega, .tailandesa, .jemer, .hebrea, .birmana: false
        }
    }

    /// ¿Está todo el texto en esta escritura (con espacios y, si los admite, ZWNJ y ZWJ)?
    package func contiene(_ texto: String) -> Bool {
        texto.unicodeScalars.allSatisfy { letra in
            letra == " " || (admiteUnionesDeAnchoCero && (letra.value == 0x200C || letra.value == 0x200D))
                || bloques.contains { $0.contains(letra.value) }
        }
    }
}

// MARK: - Letra latina

extension TipoDeEscala {
    /// ¿Tiene alguna letra que no sea latina (con sus diacríticos y sus letras del AFI: ə, ʿ)? Lo que la tenga va en
    /// `nombresOriginales`, no en `alias` ni en `variantes`.
    package static func tieneEscrituraNoLatina(_ texto: String) -> Bool {
        let latinas: [ClosedRange<UInt32>] = [
            0x0000...0x036F, 0x1D00...0x1DFF, 0x1E00...0x1EFF, 0x2000...0x2BFF, 0x2C60...0x2C7F, 0xA720...0xA7FF,
            0xAB30...0xAB6F, 0x1D100...0x1D1FF,
        ]
        return texto.unicodeScalars.contains { letra in
            letra.properties.isAlphabetic && !latinas.contains { $0.contains(letra.value) }
        }
    }
}
