// MARK: - Alfabeto

/// En qué alfabeto se escriben los textos de una notación: en el del idioma (сольный, σολ) o en el latino, con la
/// transliteración ISO 9 del cirílico (solʹ, bolʹšaâ terciâ) y la ELOT 743 del griego (sol, megáli tríti).
/// Solo cambia algo en ruso y en griego: los demás idiomas ya se escriben con letras latinas.
public enum Alfabeto: String, Hashable, Sendable, CaseIterable, Codable {
    /// El alfabeto del idioma: cirílico en ruso, griego en griego y latino en los demás.
    case propio
    /// El alfabeto latino: el ruso y el griego, transliterados.
    case latino
}

// MARK: - Transliteración

/// La transliteración al alfabeto latino del cirílico ruso (ISO 9:1995, una letra latina por letra, con signos
/// diacríticos: щ → ŝ, я → â, ь → ʹ) y del griego moderno (ELOT 743, como la ONU: θ → th, χ → ch, ου → ou, μπ → b
/// al principio de la palabra, αυ → av o af según lo que siga). El resto del texto no cambia, así que transliterar
/// dos veces da lo mismo que una.
public enum Transliteracion {
    /// El texto con las letras cirílicas y griegas en el alfabeto latino:
    /// `Transliteracion.latina("фа-диез мажор")` es «fa-diez mažor», y `latina("φα δίεση")`, «fa díesi».
    public static func latina(_ texto: String) -> String {
        guard texto.unicodeScalars.contains(where: { esCirilica($0) || esGriega($0) }) else { return texto }
        let letras = Array(texto)
        var salida = ""
        salida.reserveCapacity(texto.utf8.count)
        var i = 0
        while i < letras.count {
            let letra = letras[i]
            if let latina = cirilico[letra] {
                salida += latina
                i += 1
            } else if let griega = Griega(letra) {
                let (texto, consumidas) = griego(letras, desde: i, primera: griega)
                salida += texto
                i += consumidas
            } else {
                salida.append(letra)
                i += 1
            }
        }
        return salida
    }

    private static func esCirilica(_ escalar: Unicode.Scalar) -> Bool { (0x0400...0x04FF).contains(escalar.value) }
    private static func esGriega(_ escalar: Unicode.Scalar) -> Bool {
        (0x0370...0x03FF).contains(escalar.value) || (0x1F00...0x1FFF).contains(escalar.value)
    }

    // MARK: Cirílico (ISO 9)

    private static let minusculasCirilicas: [(Character, String)] = [
        ("а", "a"), ("б", "b"), ("в", "v"), ("г", "g"), ("д", "d"), ("е", "e"), ("ё", "ë"), ("ж", "ž"), ("з", "z"),
        ("и", "i"), ("й", "j"), ("к", "k"), ("л", "l"), ("м", "m"), ("н", "n"), ("о", "o"), ("п", "p"), ("р", "r"),
        ("с", "s"), ("т", "t"), ("у", "u"), ("ф", "f"), ("х", "h"), ("ц", "c"), ("ч", "č"), ("ш", "š"), ("щ", "ŝ"),
        ("ъ", "ʺ"), ("ы", "y"), ("ь", "ʹ"), ("э", "è"), ("ю", "û"), ("я", "â"),
    ]

    private static let cirilico: [Character: String] = {
        var tabla: [Character: String] = [:]
        for (letra, latina) in minusculasCirilicas {
            tabla[letra] = latina
            tabla[Character(letra.uppercased())] = latina.prefix(1).uppercased() + latina.dropFirst()
        }
        return tabla
    }()

    // MARK: Griego (ELOT 743)

    /// Una letra griega: su base sin tilde, si va en mayúscula y si lleva tilde o diéresis.
    private struct Griega {
        let base: Character
        let mayuscula: Bool
        let tilde: Bool
        let dieresis: Bool

        init?(_ letra: Character) {
            let texto = String(letra)
            let minuscula = texto.lowercased()
            guard let (base, tilde, dieresis) = Transliteracion.formasGriegas[Character(minuscula)] else { return nil }
            self.base = base
            self.mayuscula = minuscula != texto
            self.tilde = tilde
            self.dieresis = dieresis
        }

        var esVocal: Bool { "αεηιουω".contains(base) }
    }

    /// Cada minúscula griega, con o sin tilde o diéresis: su base, si lleva tilde y si lleva diéresis.
    private static let formasGriegas: [Character: (Character, Bool, Bool)] = {
        var tabla: [Character: (Character, Bool, Bool)] = [:]
        for base in "αβγδεζηθικλμνξοπρστυφχψω" { tabla[base] = (base, false, false) }
        tabla["ς"] = ("σ", false, false)
        for (letra, base) in zip("άέήίόύώ", "αεηιουω") { tabla[letra] = (base, true, false) }
        for (letra, base) in zip("ϊϋ", "ιυ") { tabla[letra] = (base, false, true) }
        for (letra, base) in zip("ΐΰ", "ιυ") { tabla[letra] = (base, true, true) }
        return tabla
    }()

    private static let simples: [Character: String] = [
        "α": "a", "β": "v", "γ": "g", "δ": "d", "ε": "e", "ζ": "z", "η": "i", "θ": "th", "ι": "i", "κ": "k", "λ": "l",
        "μ": "m", "ν": "n", "ξ": "x", "ο": "o", "π": "p", "ρ": "r", "σ": "s", "τ": "t", "υ": "y", "φ": "f", "χ": "ch",
        "ψ": "ps", "ω": "o",
    ]

    private static let conTilde: [Character: String] = [
        "a": "á", "e": "é", "i": "í", "o": "ó", "y": "ý",
    ]

    private static let conDieresis: [Character: String] = ["i": "ï", "y": "ÿ"]

    /// Ante estas letras, αυ, ευ y ηυ son av, ev, iv; ante las demás (y al final), af, ef, if.
    private static let sonoras: Set<Character> = ["β", "γ", "δ", "ζ", "λ", "μ", "ν", "ρ"]

    /// La transliteración de la letra griega `primera`, en la posición `i`, y cuántas letras consume.
    private static func griego(_ letras: [Character], desde i: Int, primera: Griega) -> (String, Int) {
        let siguiente = i + 1 < letras.count ? Griega(letras[i + 1]) : nil
        let tras = i + 2 < letras.count ? Griega(letras[i + 2]) : nil
        let alPrincipio = i == 0 || (Griega(letras[i - 1]) == nil && !letras[i - 1].isLetter)
        var texto: String
        var consumidas = 2
        let diptongoConU = siguiente.map { $0.base == "υ" && !$0.dieresis } ?? false
        switch (primera.base, siguiente?.base) {
        case ("ο", "υ") where diptongoConU:
            texto = siguiente?.tilde == true || primera.tilde ? "oú" : "ou"
        case ("α", "υ") where diptongoConU, ("ε", "υ") where diptongoConU, ("η", "υ") where diptongoConU:
            let sonora = tras.map { $0.esVocal || sonoras.contains($0.base) } ?? false
            let vocal = simples[primera.base] ?? ""
            let acentuada = primera.tilde || siguiente?.tilde == true ? conTilde[Character(vocal)] ?? vocal : vocal
            texto = acentuada + (sonora ? "v" : "f")
        case ("γ", "γ"): texto = "ng"
        case ("γ", "κ"): texto = "gk"
        case ("γ", "ξ"): texto = "nx"
        case ("γ", "χ"): texto = "nch"
        case ("μ", "π") where alPrincipio: texto = "b"
        case ("ν", "τ") where alPrincipio: texto = "d"
        default:
            consumidas = 1
            texto = simples[primera.base] ?? String(primera.base)
            if primera.dieresis, let latina = texto.first.flatMap({ conDieresis[$0] }) {
                texto = latina
            } else if primera.tilde, let latina = texto.first.flatMap({ conTilde[$0] }) {
                texto = latina
            }
        }
        if primera.mayuscula {
            // En una palabra en mayúsculas (ΘΕΜΑ), todas: THEMA; si no, solo la primera: Θέμα → Théma.
            let delante = i + consumidas < letras.count ? Griega(letras[i + consumidas]) : nil
            let todas = (consumidas == 2 && siguiente?.mayuscula == true) || delante?.mayuscula == true
            texto = todas ? texto.uppercased() : texto.prefix(1).uppercased() + texto.dropFirst()
        }
        return (texto, consumidas)
    }
}
