import Elementos

// MARK: - El estilo de una escala, un acorde o una progresión

/// El estilo o repertorio occidental en que se usa una escala, un acorde o una progresión del catálogo: la música
/// clásica, el jazz, el blues, las escalas de compositor, el folclore, el flamenco, el pop y el rock, o ninguno
/// (las sintéticas). Las notas no lo dicen: la menor melódica de jazz es la «bachiana» de los conservatorios, y el
/// lidio dominante es la acústica de Bartók. Lo dice el repertorio. Las escuelas de otras tradiciones (la música
/// carnática, el gagaku) son una ``Escuela``.
///
/// Todas las escalas de `TipoDeEscala.occidentales` tienen al menos un estilo; las de otras tradiciones, ninguno.
///
///     TipoDeEscala.alterada.estilos         // [.jazz]
///     Estilo.blues.tipos                    // pentatónica mayor, pentatónica menor, blues, blues mayor…
public enum Estilo: String, Sendable, Codable, CaseIterable {
    /// La teoría tonal y modal, en la que la escala da la tonalidad y de ella sale la armonía (la mayor, las menores,
    /// los modos, las napolitanas, la cromática, el hexacordo).
    case clasica
    /// El jazz, donde la escala se elige acorde a acorde: los modos de la menor melódica (alterada, lidio dominante,
    /// locrio ♮2…), las bebop, las disminuidas, las pentatónicas del jazz y las de dos tríadas. Los siete modos de la
    /// mayor también, porque son los de los acordes diatónicos.
    case jazz
    /// El blues, con las blue notes (♭3, ♭5 y ♭7 sobre un acorde mayor) y las pentatónicas de las que salen.
    case blues
    /// Las escalas simétricas y de compositor: tonos enteros, disminuidas, aumentada, los modos de Messiaen, Prometeo
    /// (Skriabin), Petrushka (Stravinski), la acústica (Bartók) y la cromática.
    case deCompositor
    /// Las que vienen de una música tradicional europea, como se conocen en los libros de teoría: la mayor rumana, las
    /// húngaras, las pentatónicas, las hexatónicas gaélicas, el dórico ♯4 de Ucrania y Rumanía.
    case folclore
    /// El flamenco: la flamenca y el frigio dominante.
    case flamenco
    /// El pop y el rock, también el metal: el frigio dominante y la doble armónica del metal y del surf, la
    /// pentatónica menor del rock; en los acordes, el power chord, el de Hendrix, el mu; en las progresiones, la de los
    /// cuatro acordes.
    case popRock
    /// Las que salen de rotar o alterar otra escala, sin un repertorio propio: la mayoría de los modos de la menor
    /// armónica, de la mayor armónica, de la doble armónica y de las napolitanas.
    case sintetica

    /// Los de las músicas populares: el folclore, el flamenco y el pop y el rock.
    public static let populares: [Estilo] = [.folclore, .flamenco, .popRock]

    /// Es de una música popular: el folclore, el flamenco o el pop y el rock.
    public var esPopular: Bool { Estilo.populares.contains(self) }

    /// Las escalas del catálogo de este estilo, en el orden de `TipoDeEscala.occidentales`.
    public var tipos: [TipoDeEscala] { TipoDeEscala.occidentales.filter { $0.estilos.contains(self) } }

    /// El nombre en el idioma de los textos de la notación: «de compositor», «composer scales». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre de los populares juntos: «popular».
    public static func nombreDeLosPopulares(en notacion: Notacion) -> String {
        TextosDeTeoria.traduccion(\.estiloPopular).en(notacion)
    }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .clasica: TextosDeTeoria.traduccion(\.estiloClasica)
        case .jazz: TextosDeTeoria.traduccion(\.estiloJazz)
        case .blues: TextosDeTeoria.traduccion(\.estiloBlues)
        case .deCompositor: TextosDeTeoria.traduccion(\.estiloDeCompositor)
        case .folclore: TextosDeTeoria.traduccion(\.estiloFolclore)
        case .flamenco: TextosDeTeoria.traduccion(\.estiloFlamenco)
        case .popRock: TextosDeTeoria.traduccion(\.estiloPopRock)
        case .sintetica: TextosDeTeoria.traduccion(\.estiloSintetica)
        }
    }
}

extension Estilo: Nombrable {}

extension Estilo {
    /// Los estilos de una declaración en su orden, que es el de importancia, sin repetir ninguno.
    static func sinRepetir(_ estilos: [Estilo]) -> [Estilo] {
        var vistos = Set<Estilo>()
        return estilos.filter { vistos.insert($0).inserted }
    }
}

extension TipoDeEscala {
    /// Los estilos occidentales en que se usa la escala, de más a menos importante: `[.jazz, .clasica]` en el dórico,
    /// central en el jazz modal y raro en la música clásica. Vacío en las propias y en las de otras tradiciones, que tienen sus escuelas (`escuelas`). Se busca por
    /// su `identidad`, como `tradicion`: Kāfī tiene las notas del dórico, pero no sus estilos.
    ///
    ///     TipoDeEscala.dorico.estilos   // [.jazz, .clasica]
    public var estilos: [Estilo] { datosDelCatalogo.estilos }

    /// El estilo en que más se usa la escala, el primero de `estilos`: el flamenco en el frigio dominante, aunque
    /// también se use en el jazz y en el rock. `nil` si no tiene estilos.
    ///
    ///     TipoDeEscala.frigioDominante.estiloPrincipal   // .flamenco
    public var estiloPrincipal: Estilo? { estilos.first }

    /// Las escuelas de su tradición en que se usa, en el orden de `Escuela.allCases`: la carnática en los mēḷa, el
    /// gagaku en las escalas japonesas de la corte. Vacío en las occidentales y en las de tradiciones sin escuelas.
    ///
    ///     TipoDeEscala.mohanam.escuelas   // [.carnatica]
    public var escuelas: [Escuela] { datosDelCatalogo.escuelas }
}
