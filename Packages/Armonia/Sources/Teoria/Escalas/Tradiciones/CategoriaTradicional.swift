import Elementos

// MARK: - Tradición y categoría de una escala

/// La tradición musical de que viene una escala: la occidental, la de las escalas de `TipoDeEscala.todos` (la tonal
/// y modal, el jazz, el blues…), o una de las de `TipoDeEscala.tradicionales`. El canto gregoriano, el Renacimiento,
/// la Grecia antigua y el folklore europeo, que también son de Occidente, son tradiciones aparte, con sus propias
/// escalas.
public enum Tradicion: String, Sendable, Codable, CaseIterable {
    case occidental, india, grecia, greciaAntigua, mundoArabe, persia, turquia, azerbaiyan
    case china, japon, corea, etiopia, indonesia, klezmer, andes, bizancio, mesopotamia
    case africa, sudesteAsiatico, gregoriano, europa, vietnam, brasil, renacimiento
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
    /// Los ajnas (singular «jins»), los fragmentos de tres a cinco notas de los que se hacen los maqamat.
    case jins
    /// Los çeşni turcos: los dörtlü y beşli (tetracordos y pentacordos) de los que se hacen los makamlar.
    case cesni
    /// Harmoniai de la Grecia antigua.
    case harmonia
    /// Afinaciones de un instrumento: las siete de la lira y el arpa babilónicas (išartu, kitmu…), de los textos
    /// cuneiformes, y las equidistantes de los xilófonos africanos y los conjuntos de Tailandia y Camboya.
    case afinacion
    /// Los ocho modos del canto gregoriano.
    case modoGregoriano
    /// Los tres hexacordos de Guido de Arezzo (natural, duro y blando).
    case hexacordo
    /// Escala sin un nombre propio para su categoría (las japonesas y las andinas).
    case escala

    /// La clase de la categoría: modo, escala madre, fragmento o afinación. Un mēḷa es a la vez un rāga y una escala
    /// madre (la de sus janya): aquí cuenta como escala madre.
    public var clase: ClaseDeEscala {
        switch self {
        case .melakarta, .thaat, .grama, .laras: .escalaMadre
        case .tetracordo, .jins, .cesni, .hexacordo: .fragmento
        case .afinacion: .afinacion
        case .raga, .janya, .murchana, .dromos, .maqam, .dastgah, .makam, .mugam, .echos, .shteyger, .qenet, .pathet,
            .diao, .jo, .harmonia, .modoGregoriano, .escala:
            .modo
        }
    }

    /// La palabra que va delante del nombre en `nombreCompleto`: la de la categoría, salvo en los janya, que son
    /// rāgas, y `nil` en las que se traducen (tetracordo, hexacordo, harmonía, modo gregoriano, afinación y escala).
    /// El `switch` no tiene `default`: una categoría nueva no compila sin decidir la suya.
    var palabraDelNombre: CategoriaTradicional? {
        switch self {
        case .janya: .raga
        case .tetracordo, .hexacordo, .harmonia, .modoGregoriano, .afinacion, .escala: nil
        case .raga, .melakarta, .thaat, .grama, .murchana, .dromos, .maqam, .dastgah, .makam, .mugam, .echos,
            .shteyger, .qenet, .laras, .pathet, .diao, .jo, .jins, .cesni:
            self
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
        case .dromos: "drómos"
        case .maqam: "maqām"
        case .dastgah: "dastgāh"
        case .makam: "makam"
        case .mugam: "muğam"
        case .echos: "échos"
        case .shteyger: "shteyger"
        case .qenet: "qenet"
        case .laras: "laras"
        case .pathet: "pathet"
        case .diao: "diào"
        case .jo: "jo"
        case .tetracordo: "tetracordo"
        case .jins: "jins"
        case .cesni: "çeşni"
        case .harmonia: "harmonía"
        case .afinacion: "afinación"
        case .modoGregoriano: "modo gregoriano"
        case .hexacordo: "hexacordo"
        case .escala: "escala"
        }
    }

    /// El nombre de la categoría en el idioma de la notación («escala» → gamme, Tonleiter, гамма…), de los ficheros de
    /// `Escalas/Nombres/` (las filas `.categoria`). Casi todas son préstamos: solo se traducen «tetracordo»,
    /// «hexacordo», «harmonía», «modo gregoriano», «afinación» y «escala», y en ruso y griego se transcriben las demás.
    public func nombre(en notacion: Notacion) -> String {
        if notacion.textos == .espanol { return nombre }
        return NombresDeEscalas.de(notacion).nombre(de: self) ?? nombre
    }
}

extension TipoDeEscala {
    /// La categoría de la escala en su tradición (rāga, mēḷa, dromos, maqam…); `nil` en las occidentales y en
    /// las propias. Se busca por el nombre, no por los intervalos: Āsāvarī (un thāṭ) tiene los de la escala menor
    /// natural.
    public var categoria: CategoriaTradicional? { fichaDelCatalogo.categoria }

    /// La tradición de la escala (la de su lista en `listasTradicionales`); `nil` en las occidentales y en
    /// las propias. Como `categoria`, por su identidad: una escala propia que se llame «Kafi» pero suene distinto no
    /// es el thāṭ.
    public var tradicion: Tradicion? { TipoDeEscala.delCatalogo[identidad]?.tradicion }

    /// La escala madre de la que sale, por la tradición: el mēḷa de un rāga janya («Mohanam» → Harikāmbhojī,
    /// siempre uno de los `melakartasCompatibles`), el thāṭ de un rāga indostánico en la clasificación de Bhatkhande
    /// (Yaman → Kalyāṇ), el grāma de una mūrchanā (Uttaramandrā → ṣaḍja-grāma) y el laras de un pathet (Sléndro
    /// pathet nem → Sléndro). `nil` en las demás escalas y en las que no tienen un padre claro (Revati, Lalit).
    public var padre: TipoDeEscala? {
        fichaDelCatalogo.padre.flatMap { TipoDeEscala.delCatalogo[$0]?.tipo }
    }

    /// Las escalas del catálogo que salen de esta (las que la tienen de `padre`), en el orden del catálogo: los janya
    /// de un mēḷa, los rāgas de un thāṭ, las siete mūrchanā de un grāma.
    public var derivadas: [TipoDeEscala] { TipoDeEscala.derivadasPorPadre[identidad] ?? [] }

    /// Padre → sus derivadas, en el orden del catálogo.
    private static let derivadasPorPadre: [IdentidadDeEscala: [TipoDeEscala]] = Dictionary(
        grouping: catalogo.filter { $0.ficha.padre != nil }, by: { $0.ficha.padre! })

    /// El nombre con la palabra de su categoría delante: «thāṭ Kāfī», «mēḷa Māyāmālavagauḷa», «rāga Mohanam» (un
    /// janya es un rāga), «maqām Bayātī», «drómos Hitzáz». Es el nombre a secas si ya la lleva («jins Ḥijāz»,
    /// «Rast makamı», «échos prótos», «shadd Rāst»), si la categoría es una palabra que se traduce y no se antepone
    /// en todos los idiomas (tetracordo, harmonía, hexacordo, modo gregoriano, afinación, escala) o si la escala no
    /// es de otra tradición. Que el nombre ya la lleva se deduce de su nombre en español (`llevaLaCategoria`).
    public var nombreCompleto: String { nombreCompleto(en: .compacta(.espanol)) }

    /// `nombreCompleto` en el idioma de los textos de la notación, con la palabra de la categoría en ese idioma (en
    /// ruso y en griego, transcrita: «рага», «ράγκα»).
    public func nombreCompleto(en notacion: Notacion) -> String {
        let suyo = nombre(en: notacion)
        guard let palabra = fichaDelCatalogo.categoria?.palabraDelNombre, !llevaLaCategoria else { return suyo }
        return "\(palabra.nombre(en: notacion)) \(suyo)"
    }

    /// ¿Lleva ya el nombre de la escala del catálogo, en español, la palabra de su categoría, o una que la sustituye?
    /// Una palabra del nombre empieza por ella («Rast makamı», «jins Ḥijāz», «échos prótos», «ṣaḍja-grāma»), en los jo
    /// coreanos acaba en ella («P'yŏngjo»), y los shadd llevan «shadd» en lugar de «maqām». Entonces `nombreCompleto`
    /// no la antepone. Se calcula una vez, para todo el catálogo.
    package var llevaLaCategoria: Bool { TipoDeEscala.conLaCategoriaEnElNombre.contains(identidad) }

    /// Las escalas de `tradicionales` cuyo nombre lleva la palabra de su categoría (`llevaLaCategoria`).
    private static let conLaCategoriaEnElNombre: Set<IdentidadDeEscala> = Set(
        tradicionales.filter { tipo in
            guard let palabra = tipo.ficha.categoria?.palabraDelNombre else { return false }
            let clave = normalizar(palabra.nombre)
            let palabras = normalizar(tipo.nombre).split(separator: " ")
            return palabras.first == "shadd"
                || palabras.contains { $0.hasPrefix(clave) || (palabra == .jo && $0.hasSuffix(clave)) }
        }.map(\.identidad))

    /// ¿Es un rāga (indostánico, mēḷa o janya)?
    public var esRaga: Bool { categoria?.esRaga ?? false }

    /// La clase de la escala (modo, escala madre, fragmento o afinación), la de su categoría; `nil` en las
    /// occidentales y en las propias.
    public var clase: ClaseDeEscala? { categoria?.clase }

    /// Las escalas de otras tradiciones de una categoría: `tradicionales(categoria: .melakarta)` da los 72 mēḷa.
    public static func tradicionales(categoria: CategoriaTradicional) -> [TipoDeEscala] {
        tradicionales.filter { $0.categoria == categoria }
    }

    /// Las escalas de otras tradiciones de una clase: `tradicionales(clase: .fragmento)` da los tetracordos griegos,
    /// los ajnas árabes y los çeşni turcos.
    public static func tradicionales(clase: ClaseDeEscala) -> [TipoDeEscala] {
        tradicionales.filter { $0.clase == clase }
    }

    /// Las escalas de una tradición.
    public static func tradicionales(tradicion: Tradicion) -> [TipoDeEscala] {
        tradicionales.filter { $0.tradicion == tradicion }
    }
}
