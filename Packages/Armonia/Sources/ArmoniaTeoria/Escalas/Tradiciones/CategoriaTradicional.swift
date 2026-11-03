import ArmoniaNucleo

// MARK: - Tradición y categoría de una escala

/// La tradición musical de que viene una escala de `TipoDeEscala.tradicionales`.
public enum Tradicion: String, Sendable, Codable, CaseIterable {
    case india, grecia, greciaAntigua, mundoArabe, persia, turquia, azerbaiyan
    case china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia
}

/// Qué es una escala dentro de su tradición: un rāga, un mēḷa (o mēḷakarta), un dromos, un maqam, un makam,
/// un mugam…
///
/// Un mēḷa es también un rāga (`esRaga`): son los 72 rāgas madre de la música carnática. Un thāṭ, en cambio, es
/// una escala madre de la música indostánica de la que se derivan rāgas, pero no es un rāga.
public enum CategoriaTradicional: String, Sendable, Codable, CaseIterable {
    /// Rāga indostánico.
    case raga
    /// Mēḷa (o mēḷakarta): uno de los 72 rāgas madre carnáticos.
    case melakarta
    /// Rāga carnático derivado de un mēḷa.
    case janya
    /// Escala madre indostánica.
    case thaat
    /// Las dos escalas madre del Nāṭyaśāstra: el ṣaḍja-grāma y el madhyama-grāma.
    case grama
    /// Las siete escalas de cada grāma, una desde cada una de sus notas.
    case murchana
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
    /// Los modos (echoi) de la salmodia bizantina.
    case echos
    /// Modos (shteyger) del klezmer.
    case shteyger
    /// Modos (qenet) de la música etíope.
    case qenet
    /// Sistemas de afinación (laras) del gamelan.
    case laras
    /// Modos de un laras: los pathet de Java y los de Bali (tembung, sunaren).
    case pathet
    /// Modos (diào) de la música china.
    case diao
    /// Modos (jo) de la música coreana.
    case jo
    /// Tetracordos de la Grecia antigua.
    case tetracordo
    /// Harmoniai de la Grecia antigua.
    case harmonia
    /// Las siete afinaciones de la lira y el arpa babilónicas (išartu, kitmu…), de los textos cuneiformes.
    case afinacion
    /// Escala sin un nombre propio para su categoría (las japonesas y las andinas).
    case escala

    /// La clase de la categoría: modo, escala madre, fragmento o afinación. Un mēḷa es a la vez un rāga y una escala
    /// madre (la de sus janya): aquí cuenta como escala madre.
    public var clase: ClaseDeEscala {
        switch self {
        case .melakarta, .thaat, .grama, .laras: .escalaMadre
        case .tetracordo: .fragmento
        case .afinacion: .afinacion
        case .raga, .janya, .murchana, .dromos, .maqam, .dastgah, .makam, .mugam, .echos, .shteyger, .qenet, .pathet,
            .diao, .jo, .harmonia, .escala:
            .modo
        }
    }

    /// ¿Es un rāga? Lo son los rāgas indostánicos, los mēḷa y los janya; el thāṭ no.
    public var esRaga: Bool { self == .raga || self == .melakarta || self == .janya }

    /// El nombre de la categoría en español.
    public var nombre: String {
        switch self {
        case .raga: "rāga"
        case .melakarta: "mēḷa"
        case .janya: "janya"
        case .thaat: "thāṭ"
        case .grama: "grāma"
        case .murchana: "mūrchanā"
        case .dromos: "dromos"
        case .maqam: "maqam"
        case .dastgah: "dastgāh"
        case .makam: "makam"
        case .mugam: "mugam"
        case .echos: "echos"
        case .shteyger: "shteyger"
        case .qenet: "qenet"
        case .laras: "laras"
        case .pathet: "pathet"
        case .diao: "diào"
        case .jo: "jo"
        case .tetracordo: "tetracordo"
        case .harmonia: "harmonía"
        case .afinacion: "afinación"
        case .escala: "escala"
        }
    }

    /// El nombre de la categoría en el idioma de la notación («escala» → gamme, Tonleiter, гамма…), de los ficheros de
    /// `Escalas/Nombres/` (las filas `.categoria`). Casi todas son préstamos: solo se traducen «tetracordo», «harmonía»,
    /// «afinación» y «escala», y en ruso y griego se transcriben las demás.
    public func nombre(en notacion: Notacion) -> String {
        if notacion.textos == .espanol { return nombre }
        return NombresDeEscalas.de(notacion.textos).nombre(de: self) ?? nombre
    }
}

extension TipoDeEscala {
    /// La categoría de la escala en su tradición (rāga, mēḷa, dromos, maqam…); `nil` en las occidentales y en
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

    /// El mēḷa del que deriva un rāga janya, por la tradición («Mohanam» → Harikāmbhojī); `nil` en las demás
    /// escalas y en los janya sin un padre claro (Revati). Siempre es uno de los `melakartasCompatibles`.
    public var padre: TipoDeEscala? {
        guard categoria == .janya, let numero = TipoDeEscala.padresDeLosJanya[nombre] else { return nil }
        return TipoDeEscala.melakarta(numero)
    }

    /// ¿Es un rāga (indostánico, mēḷa o janya)?
    public var esRaga: Bool { categoria?.esRaga ?? false }

    /// La clase de la escala (modo, escala madre, fragmento o afinación), la de su categoría; `nil` en las
    /// occidentales y en las propias.
    public var clase: ClaseDeEscala? { categoria?.clase }

    /// Las escalas de otras tradiciones de una categoría: `tradicionales(categoria: .melakarta)` da los 72 mēḷa.
    public static func tradicionales(categoria: CategoriaTradicional) -> [TipoDeEscala] {
        tradicionales.filter { $0.categoria == categoria }
    }

    /// Las escalas de otras tradiciones de una clase: `tradicionales(clase: .fragmento)` da los tetracordos y los
    /// géneros griegos.
    public static func tradicionales(clase: ClaseDeEscala) -> [TipoDeEscala] {
        tradicionales.filter { $0.clase == clase }
    }

    /// Las escalas de una tradición.
    public static func tradicionales(tradicion: Tradicion) -> [TipoDeEscala] {
        tradicionales.filter { $0.tradicion == tradicion }
    }

    private typealias Clasificada = (tipo: TipoDeEscala, tradicion: Tradicion, categoria: CategoriaTradicional)

    /// Nombre → tradición y categoría, de las fichas de cada tradición. Si un nombre estuviera en dos, vale la primera.
    private static let clasificacion: [String: Clasificada] = {
        var tabla: [String: Clasificada] = [:]
        for ficha in FichaDeTradicion.todas {
            for lista in ficha.listas {
                for tipo in lista.tipos where tabla[tipo.nombre] == nil {
                    tabla[tipo.nombre] = (tipo, ficha.tradicion, lista.categoria)
                }
            }
        }
        return tabla
    }()

    /// Nombre de cada janya incluido → el número de su mēḷa padre (el de uso general; Revati no tiene uno único).
    private static let padresDeLosJanya: [String: Int] = Dictionary(
        FichaDeTradicion.todas.flatMap(\.padres).map { ($0.janya.nombre, $0.mela) },
        uniquingKeysWith: { primero, _ in primero })
}
