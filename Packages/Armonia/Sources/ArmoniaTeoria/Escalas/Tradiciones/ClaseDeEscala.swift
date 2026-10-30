import ArmoniaNucleo

// MARK: - Tradición y clase de una escala

/// La tradición musical de que viene una escala de `TipoDeEscala.tradicionales`.
public enum Tradicion: String, Sendable, Codable, CaseIterable {
    case india, grecia, greciaAntigua, mundoArabe, persia, china, japon, corea, etiopia, indonesia, klezmer, andes
}

/// Qué es una escala dentro de su tradición: un raga, un melakarta («mela»), un dromos, un maqam…
///
/// Un melakarta es también un raga (`esRaga`): son los 72 ragas madre de la música carnática. Un thaat, en cambio, es
/// una escala madre de la música indostánica de la que se derivan ragas, pero no es un raga.
public enum ClaseDeEscala: String, Sendable, Codable, CaseIterable {
    /// Raga indostánico.
    case raga
    /// «Mela»: uno de los 72 ragas madre carnáticos.
    case melakarta
    /// Raga carnático derivado de un melakarta.
    case janya
    /// Escala madre indostánica.
    case thaat
    /// Camino (plural «dromoi») de la música popular y el rebético griegos.
    case dromos
    /// Los maqamat del mundo árabe.
    case maqam
    /// Los dastgāh de la música persa.
    case dastgah
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
    /// Escala sin un nombre propio para su clase (las japonesas y las andinas).
    case escala

    /// ¿Es un raga? Lo son los ragas indostánicos, los melakarta y los janya; el thaat no.
    public var esRaga: Bool { self == .raga || self == .melakarta || self == .janya }

    /// El nombre de la clase en español.
    public var nombre: String {
        switch self {
        case .raga: "raga"
        case .melakarta: "melakarta"
        case .janya: "janya"
        case .thaat: "thaat"
        case .dromos: "dromos"
        case .maqam: "maqam"
        case .dastgah: "dastgāh"
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

    /// El nombre de la clase en el idioma de la notación («escala» → gamme, Tonleiter, гамма…), de los ficheros de
    /// `Escalas/Nombres/` (las filas `.clase`). Casi todas son préstamos: solo se traducen «tetracordo», «harmonía» y
    /// «escala», y en ruso y griego se transcriben las demás.
    public func nombre(en notacion: Notacion) -> String {
        if notacion.textos == .espanol { return nombre }
        return NombresDeEscalas.de(notacion.textos).nombre(de: self) ?? nombre
    }
}

extension TipoDeEscala {
    /// La clase de la escala (raga, melakarta, dromos, maqam…); `nil` en las occidentales y en las propias. Se busca
    /// por el nombre, no por los intervalos: Āsāvarī (un thaat) tiene los de la escala menor natural.
    public var clase: ClaseDeEscala? { clasificada?.clase }

    /// La tradición de la escala; `nil` en las occidentales y en las propias.
    public var tradicion: Tradicion? { clasificada?.tradicion }

    /// La entrada de la tabla si el nombre es el de una escala tradicional *y* los intervalos coinciden: una escala
    /// propia que se llame «Kafi» pero suene distinto no es el thaat.
    private var clasificada: (tradicion: Tradicion, clase: ClaseDeEscala)? {
        guard let entrada = TipoDeEscala.clasificacion[nombre], entrada.tipo == self else { return nil }
        return (entrada.tradicion, entrada.clase)
    }

    /// El melakarta del que deriva un raga janya, por la tradición («Mohanam» → Harikāmbhojī); `nil` en las demás
    /// escalas y en los janya sin un padre claro (Revati). Siempre es uno de los `melakartasCompatibles`.
    public var padre: TipoDeEscala? {
        guard clase == .janya, let numero = TipoDeEscala.padresDeLosJanya[nombre] else { return nil }
        return TipoDeEscala.melakarta(numero)
    }

    /// ¿Es un raga (indostánico, melakarta o janya)?
    public var esRaga: Bool { clase?.esRaga ?? false }

    /// Las escalas de otras tradiciones de una clase: `tradicionales(clase: .melakarta)` da los 72 melakarta.
    public static func tradicionales(clase: ClaseDeEscala) -> [TipoDeEscala] {
        tradicionales.filter { $0.clase == clase }
    }

    /// Las escalas de una tradición.
    public static func tradicionales(tradicion: Tradicion) -> [TipoDeEscala] {
        tradicionales.filter { $0.tradicion == tradicion }
    }

    /// Nombre → tradición y clase, de las listas de cada tradición. Si un nombre estuviera en dos, vale la primera.
    private static let clasificacion: [String: (tipo: TipoDeEscala, tradicion: Tradicion, clase: ClaseDeEscala)] = {
        let grupos: [(Tradicion, ClaseDeEscala, [TipoDeEscala])] = [
            (.india, .thaat, thaats), (.grecia, .dromos, dromoi), (.india, .melakarta, melakartas),
            (.india, .janya, janyas), (.china, .diao, chinas), (.japon, .escala, japonesas),
            (.etiopia, .qenet, etiopes), (.mundoArabe, .maqam, maqamat), (.indonesia, .laras, indonesias),
            (.klezmer, .shteyger, klezmer), (.india, .raga, ragasIndostanicos), (.persia, .dastgah, dastgah),
            (.corea, .jo, coreanas), (.andes, .escala, andinas),
            (.greciaAntigua, .tetracordo, [.tetracordoDiatonico, .tetracordoCromatico]),
            (.greciaAntigua, .harmonia, [.harmoniaDoria, .harmoniaDoriaCromatica, .harmoniaFrigia, .harmoniaLidia]),
        ]
        var tabla: [String: (tipo: TipoDeEscala, tradicion: Tradicion, clase: ClaseDeEscala)] = [:]
        for (tradicion, clase, tipos) in grupos {
            for tipo in tipos where tabla[tipo.nombre] == nil { tabla[tipo.nombre] = (tipo, tradicion, clase) }
        }
        return tabla
    }()

    /// Número del melakarta padre de cada janya incluido (el de uso general; Revati no tiene uno único).
    private static let padresDeLosJanya: [String: Int] = [
        "Mohanam": 28, "Hindolam": 20, "Haṃsadhvani": 29, "Ābhogi": 22, "Madhyamāvatī": 22, "Bilahari": 29,
        "Kāmbhoji": 28, "Ārabhi": 29, "Kedāragauḷa": 28, "Amṛtavarṣiṇī": 65,
    ]
}
