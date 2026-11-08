import Elementos

// MARK: - Subtradiciones de una escala: su estilo y su región
//
// Una escala puede tener dos clases de subtradición dentro de su `Tradicion`: el estilo o repertorio en que se usa
// (la música carnática, el gagaku, el jazz) y la región o el pueblo de donde viene (Java, Escocia, los chopi). Son dos
// tipos, `EstiloDeEscala` y `RegionDeEscala`, y `Subtradicion` reúne los dos. Una escala puede tener varios de cada
// uno: el dórico es clásico y de jazz, y el sléndro se toca en Java y en Bali.

/// El estilo o repertorio en que se usa una escala, dentro de su tradición: en la occidental, la música clásica, el
/// jazz, el blues…; en la India, la música carnática, la indostánica o la del Nāṭyaśāstra; en Japón, el gagaku. Las
/// notas no lo dicen: la menor melódica de jazz es la «bachiana» de los conservatorios, y el lidio dominante es la
/// acústica de Bartók. Lo dice el repertorio.
///
/// Todas las escalas de `TipoDeEscala.todos` tienen al menos un estilo de la tradición occidental. A las de la India
/// se lo da su categoría (`EstiloDeEscala.de(_:)`); las demás lo llevan en su declaración, si lo tienen.
///
///     TipoDeEscala.alterada.estilos         // [.jazz]
///     EstiloDeEscala.blues.tipos            // pentatónica mayor, pentatónica menor, blues, blues mayor…
public enum EstiloDeEscala: String, Sendable, Codable, CaseIterable {
    /// Occidental: la teoría tonal y modal, en la que la escala da la tonalidad y de ella sale la armonía (la mayor,
    /// las menores, los modos, las napolitanas, la cromática, el hexacordo).
    case clasica
    /// Occidental: el jazz, donde la escala se elige acorde a acorde: los modos de la menor melódica (alterada, lidio
    /// dominante, locrio ♮2…), las bebop, las disminuidas, las pentatónicas del jazz y las de dos tríadas. Los siete
    /// modos de la mayor también, porque son los de los acordes diatónicos.
    case jazz
    /// Occidental: el blues, con las blue notes (♭3, ♭5 y ♭7 sobre un acorde mayor) y las pentatónicas de las que
    /// salen.
    case blues
    /// Occidental: las escalas simétricas y de compositor del siglo XX: tonos enteros, disminuidas, aumentada, los
    /// modos de Messiaen, Prometeo (Skriabin), Petrushka (Stravinski), la acústica (Bartók) y la cromática.
    case sigloXX
    /// Occidental: las que vienen de una música popular, como se conocen en los libros de teoría: la flamenca, la
    /// mayor rumana, la menor húngara, las pentatónicas, las hexatónicas gaélicas.
    case popular
    /// Occidental: las que salen de rotar o alterar otra escala, sin un repertorio propio: la mayoría de los modos de
    /// la menor armónica, de la mayor armónica, de la doble armónica y de las napolitanas.
    case sintetica
    /// India: la música carnática (del sur), la indostánica (del norte) y la del Nāṭyaśāstra (grāma y mūrchanā).
    case carnatica, indostanica, indiaAntigua
    /// Japón: la música cortesana.
    case gagaku

    /// La tradición a la que pertenece. El `switch` no tiene `default`: un estilo nuevo no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .clasica, .jazz, .blues, .sigloXX, .popular, .sintetica: .occidental
        case .carnatica, .indostanica, .indiaAntigua: .india
        case .gagaku: .japon
        }
    }

    /// El que da una categoría por sí sola: los mēḷa y los janya son carnáticos, los thāṭ y los rāgas indostánicos, y
    /// los grāma y las mūrchanā, del Nāṭyaśāstra. `nil` en las demás categorías.
    public static func de(_ categoria: CategoriaTradicional) -> EstiloDeEscala? {
        switch categoria {
        case .melakarta, .janya: .carnatica
        case .thaat, .raga: .indostanica
        case .grama, .murchana: .indiaAntigua
        default: nil
        }
    }

    /// Las escalas del catálogo de este estilo, en su orden: las occidentales de `TipoDeEscala.todos` y las de otras
    /// tradiciones de `TipoDeEscala.tradicionales`.
    public var tipos: [TipoDeEscala] {
        let lista = tradicion == .occidental ? TipoDeEscala.occidentales : TipoDeEscala.tradicionales
        return lista.filter { $0.estilos.contains(self) }
    }

    /// El nombre en el idioma de los textos de la notación: «siglo XX», «20th century», «Carnática», «Καρνατική». En
    /// español, también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .clasica: TextosDeTeoria.traduccion(\.usoClasica)
        case .jazz: TextosDeTeoria.traduccion(\.usoJazz)
        case .blues: TextosDeTeoria.traduccion(\.usoBlues)
        case .sigloXX: TextosDeTeoria.traduccion(\.usoSigloXX)
        case .popular: TextosDeTeoria.traduccion(\.usoPopular)
        case .sintetica: TextosDeTeoria.traduccion(\.usoSintetica)
        case .carnatica: TextosDeTeoria.traduccion(\.subtradicionCarnatica)
        case .indostanica: TextosDeTeoria.traduccion(\.subtradicionIndostanica)
        case .indiaAntigua: TextosDeTeoria.traduccion(\.subtradicionIndiaAntigua)
        case .gagaku: TextosDeTeoria.traduccion(\.subtradicionGagaku)
        }
    }
}

/// La región, el país o el pueblo de donde viene una escala, dentro de su tradición: Java o Bali en Indonesia, el país
/// de una escala popular de Europa, el pueblo de una afinación de África, Okinawa (las islas Ryūkyū) en Japón.
///
/// Las escalas la llevan en su declaración (`regiones: [.bali]`), y pueden llevar varias (el sléndro, `[.java,
/// .bali]`). Las que no tienen una clara (las escalas chinas) no llevan ninguna, y los teóricos (Aristóxeno, Ptolomeo,
/// Glareano) no son regiones: son la `fuente` de la escala (`FuenteTeorica`).
public enum RegionDeEscala: String, Sendable, Codable, CaseIterable {
    /// Indonesia: los gamelan de Java, de Bali y de Sunda (el oeste de Java).
    case java, bali, sunda
    /// Sudeste asiático: los conjuntos piphat de Tailandia y pinpeat de Camboya, y el arpa de Birmania.
    case tailandia, camboya, birmania
    /// África: el amadinda de Buganda (Uganda), el timbila de los chopi (Mozambique), la kora mandinga y la mbira de
    /// los shona (Zimbabue).
    case buganda, chopi, mandinga, shona
    /// Europa: el país o la región de cada escala popular.
    case ucrania, polonia, hungria, alpes, escocia, georgia, istria
    /// Japón: la música de Okinawa (Ryūkyū).
    case ryukyu

    /// La tradición a la que pertenece. El `switch` no tiene `default`: una región nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .java, .bali, .sunda: .indonesia
        case .tailandia, .camboya, .birmania: .sudesteAsiatico
        case .buganda, .chopi, .mandinga, .shona: .africa
        case .ucrania, .polonia, .hungria, .alpes, .escocia, .georgia, .istria: .europa
        case .ryukyu: .japon
        }
    }

    /// Las escalas de otras tradiciones de esta región, en el orden de `TipoDeEscala.tradicionales`:
    /// `RegionDeEscala.java.tipos` da los pathet de Java y el sléndro.
    public var tipos: [TipoDeEscala] { TipoDeEscala.tradicionales.filter { $0.regiones.contains(self) } }

    /// El nombre en el idioma de los textos de la notación: «Java», «Escocia», «Scotland», «Σκωτία». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .java: TextosDeTeoria.traduccion(\.subtradicionJava)
        case .bali: TextosDeTeoria.traduccion(\.subtradicionBali)
        case .sunda: TextosDeTeoria.traduccion(\.subtradicionSunda)
        case .tailandia: TextosDeTeoria.traduccion(\.subtradicionTailandia)
        case .camboya: TextosDeTeoria.traduccion(\.subtradicionCamboya)
        case .birmania: TextosDeTeoria.traduccion(\.subtradicionBirmania)
        case .buganda: TextosDeTeoria.traduccion(\.subtradicionBuganda)
        case .chopi: TextosDeTeoria.traduccion(\.subtradicionChopi)
        case .mandinga: TextosDeTeoria.traduccion(\.subtradicionMandinga)
        case .shona: TextosDeTeoria.traduccion(\.subtradicionShona)
        case .ucrania: TextosDeTeoria.traduccion(\.subtradicionUcrania)
        case .polonia: TextosDeTeoria.traduccion(\.subtradicionPolonia)
        case .hungria: TextosDeTeoria.traduccion(\.subtradicionHungria)
        case .alpes: TextosDeTeoria.traduccion(\.subtradicionAlpes)
        case .escocia: TextosDeTeoria.traduccion(\.subtradicionEscocia)
        case .georgia: TextosDeTeoria.traduccion(\.subtradicionGeorgia)
        case .istria: TextosDeTeoria.traduccion(\.subtradicionIstria)
        case .ryukyu: TextosDeTeoria.traduccion(\.subtradicionRyukyu)
        }
    }
}

/// Una subtradición: un estilo (`EstiloDeEscala`) o una región (`RegionDeEscala`) dentro de una tradición.
///
///     TipoDeEscala.slendro.subtradiciones   // [.region(.java), .region(.bali)]
///     TipoDeEscala.dorico.subtradiciones    // [.estilo(.clasica), .estilo(.jazz)]
public enum Subtradicion: Hashable, Sendable, Codable {
    case estilo(EstiloDeEscala)
    case region(RegionDeEscala)

    /// Todas: primero los estilos y después las regiones, en el orden de sus casos.
    public static let todas: [Subtradicion] =
        EstiloDeEscala.allCases.map(Subtradicion.estilo) + RegionDeEscala.allCases.map(Subtradicion.region)

    /// La tradición a la que pertenece.
    public var tradicion: Tradicion {
        switch self {
        case .estilo(let estilo): estilo.tradicion
        case .region(let region): region.tradicion
        }
    }

    /// Las escalas del catálogo de esta subtradición (`EstiloDeEscala.tipos` o `RegionDeEscala.tipos`).
    public var tipos: [TipoDeEscala] {
        switch self {
        case .estilo(let estilo): estilo.tipos
        case .region(let region): region.tipos
        }
    }

    /// El nombre del estilo o de la región en el idioma de los textos de la notación.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .estilo(let estilo): estilo.nombre(en: notacion)
        case .region(let region): region.nombre(en: notacion)
        }
    }
}

extension EstiloDeEscala: Nombrable {}
extension RegionDeEscala: Nombrable {}
extension Subtradicion: Nombrable {}

extension TipoDeEscala {
    /// Los estilos en que se usa la escala, en el orden de `EstiloDeEscala.allCases`: los occidentales en las de
    /// `todos` (`[.clasica, .jazz]` en el dórico), el carnático o el indostánico en las de la India… Vacío en las
    /// propias y en las de otras tradiciones sin uno claro. Se busca por su `identidad`, como `tradicion`: Kāfī tiene
    /// las notas del dórico, pero no sus estilos.
    ///
    ///     TipoDeEscala.mohanam.estilos   // [.carnatica]
    public var estilos: [EstiloDeEscala] { fichaDelCatalogo.estilos }

    /// Las regiones de donde viene, en el orden de `RegionDeEscala.allCases`; vacío en las occidentales, en las
    /// propias y en las de otras tradiciones sin una clara. Como `estilos`, por su identidad.
    ///
    ///     TipoDeEscala.pelogTembung.regiones   // [.bali]
    ///     TipoDeEscala.slendro.regiones        // [.java, .bali]
    public var regiones: [RegionDeEscala] { fichaDelCatalogo.regiones }

    /// Los estilos y las regiones, por ese orden.
    public var subtradiciones: [Subtradicion] { estilos.map(Subtradicion.estilo) + regiones.map(Subtradicion.region) }
}
