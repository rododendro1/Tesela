import ArmoniaNucleo

// MARK: - Tradición y categoría de una escala

/// La tradición musical de que viene una escala de `TipoDeEscala.tradicionales`.
public enum Tradicion: String, Sendable, Codable, CaseIterable {
    case india, grecia, greciaAntigua, mundoArabe, persia, turquia, azerbaiyan
    case china, japon, corea, etiopia, indonesia, klezmer, andes
}

/// Qué es una escala dentro de su tradición: un rāga, un mēḷakarta («mēḷa»), un dromos, un maqam, un makam,
/// un mugam…
///
/// Un mēḷakarta es también un rāga (`esRaga`): son los 72 rāgas madre de la música carnática. Un thāṭ, en cambio, es
/// una escala madre de la música indostánica de la que se derivan rāgas, pero no es un rāga.
public enum CategoriaTradicional: String, Sendable, Codable, CaseIterable {
    /// Rāga indostánico.
    case raga
    /// «Mēḷa»: uno de los 72 rāgas madre carnáticos.
    case melakarta
    /// Rāga carnático derivado de un mēḷakarta.
    case janya
    /// Escala madre indostánica.
    case thaat
    /// Camino (plural «dromoi») de la música popular y el rebético griegos.
    case dromos
    /// Los maqamat del mundo árabe.
    case maqam
    /// Los dastgāh de la música persa.
    case dastgah
    /// Los makam (plural «makamlar») de la música clásica turca.
    case makam
    /// Los mugam de la música azerbaiyana.
    case mugam
    /// Modos (shteyger) del klezmer.
    case shteyger
    /// Modos (qenet) de la música etíope.
    case qenet
    /// Sistemas de afinación (laras) del gamelan.
    case laras
    /// Modos (diào) de la música china.
    case diao
    /// Modos (jo) de la música coreana.
    case jo
    /// Tetracordos de la Grecia antigua.
    case tetracordo
    /// Harmoniai de la Grecia antigua.
    case harmonia
    /// Escala sin un nombre propio para su categoría (las japonesas y las andinas).
    case escala

    /// ¿Es un rāga? Lo son los rāgas indostánicos, los mēḷakarta y los janya; el thāṭ no.
    public var esRaga: Bool { self == .raga || self == .melakarta || self == .janya }

    /// El nombre de la categoría en español.
    public var nombre: String {
        switch self {
        case .raga: "rāga"
        case .melakarta: "mēḷakarta"
        case .janya: "janya"
        case .thaat: "thāṭ"
        case .dromos: "dromos"
        case .maqam: "maqam"
        case .dastgah: "dastgāh"
        case .makam: "makam"
        case .mugam: "mugam"
        case .shteyger: "shteyger"
        case .qenet: "qenet"
        case .laras: "laras"
        case .diao: "diào"
        case .jo: "jo"
        case .tetracordo: "tetracordo"
        case .harmonia: "harmonía"
        case .escala: "escala"
        }
    }

    /// El nombre de la categoría en el idioma de la notación («escala» → gamme, Tonleiter, гамма…), de los ficheros de
    /// `Escalas/Nombres/` (las filas `.categoria`). Casi todas son préstamos: solo se traducen «tetracordo», «harmonía» y
    /// «escala», y en ruso y griego se transcriben las demás.
    public func nombre(en notacion: Notacion) -> String {
        if notacion.textos == .espanol { return nombre }
        return NombresDeEscalas.de(notacion.textos).nombre(de: self) ?? nombre
    }
}

extension TipoDeEscala {
    /// La categoría de la escala en su tradición (rāga, mēḷakarta, dromos, maqam…); `nil` en las occidentales y en
    /// las propias. Se busca por el nombre, no por los intervalos: Āsāvarī (un thāṭ) tiene los de la escala menor
    /// natural.
    public var categoria: CategoriaTradicional? { clasificada?.categoria }

    /// La tradición de la escala; `nil` en las occidentales y en las propias.
    public var tradicion: Tradicion? { clasificada?.tradicion }

    /// La entrada de la tabla si el nombre es el de una escala tradicional *y* los intervalos coinciden: una escala
    /// propia que se llame «Kafi» pero suene distinto no es el thāṭ.
    private var clasificada: (tradicion: Tradicion, categoria: CategoriaTradicional)? {
        guard let entrada = TipoDeEscala.clasificacion[nombre], entrada.tipo == self else { return nil }
        return (entrada.tradicion, entrada.categoria)
    }

    /// El mēḷakarta del que deriva un rāga janya, por la tradición («Mohanam» → Harikāmbhojī); `nil` en las demás
    /// escalas y en los janya sin un padre claro (Revati). Siempre es uno de los `melakartasCompatibles`.
    public var padre: TipoDeEscala? {
        guard categoria == .janya, let numero = TipoDeEscala.padresDeLosJanya[nombre] else { return nil }
        return TipoDeEscala.melakarta(numero)
    }

    /// ¿Es un rāga (indostánico, mēḷakarta o janya)?
    public var esRaga: Bool { categoria?.esRaga ?? false }

    /// Las escalas de otras tradiciones de una categoría: `tradicionales(categoria: .melakarta)` da los 72 mēḷakarta.
    public static func tradicionales(categoria: CategoriaTradicional) -> [TipoDeEscala] {
        tradicionales.filter { $0.categoria == categoria }
    }

    /// Las escalas de una tradición.
    public static func tradicionales(tradicion: Tradicion) -> [TipoDeEscala] {
        tradicionales.filter { $0.tradicion == tradicion }
    }

    private typealias Clasificada = (tipo: TipoDeEscala, tradicion: Tradicion, categoria: CategoriaTradicional)

    /// Nombre → tradición y categoría, de las listas de cada tradición. Si un nombre estuviera en dos, vale la primera.
    private static let clasificacion: [String: Clasificada] = {
        let grupos: [(Tradicion, CategoriaTradicional, [TipoDeEscala])] = [
            (.india, .thaat, thaats), (.grecia, .dromos, dromoi), (.india, .melakarta, melakartas),
            (.india, .janya, janyas), (.china, .diao, chinas), (.japon, .escala, japonesas),
            (.etiopia, .qenet, etiopes), (.mundoArabe, .maqam, maqamat), (.indonesia, .laras, indonesias),
            (.klezmer, .shteyger, klezmer), (.india, .raga, ragasIndostanicos), (.persia, .dastgah, dastgah),
            (.corea, .jo, coreanas), (.andes, .escala, andinas),
            (.turquia, .makam, makamlar), (.azerbaiyan, .mugam, mugamlar),
            (.greciaAntigua, .tetracordo, [.tetracordoDiatonico, .tetracordoCromatico]),
            (.greciaAntigua, .harmonia, [.harmoniaDoria, .harmoniaDoriaCromatica, .harmoniaFrigia, .harmoniaLidia]),
        ]
        var tabla: [String: Clasificada] = [:]
        for (tradicion, categoria, tipos) in grupos {
            for tipo in tipos where tabla[tipo.nombre] == nil { tabla[tipo.nombre] = (tipo, tradicion, categoria) }
        }
        return tabla
    }()

    /// Número del mēḷakarta padre de cada janya incluido (el de uso general; Revati no tiene uno único).
    private static let padresDeLosJanya: [String: Int] = [
        "Mohanam": 28, "Hindolam": 20, "Haṃsadhvani": 29, "Ābhogi": 22, "Madhyamāvatī": 22, "Bilahari": 29,
        "Kāmbhoji": 28, "Ārabhi": 29, "Kedāragauḷa": 28, "Amṛtavarṣiṇī": 65,
    ]
}
