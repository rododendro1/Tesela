import Elementos

// MARK: - El estilo de una escala

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
    /// mayor rumana, la menor húngara, las pentatónicas, las hexatónicas gaélicas. En los acordes
    /// (`AcordeConNombre.estilos`), también el pop y el rock: el power chord, el de Hendrix, el mu.
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

extension EstiloDeEscala: Nombrable {}

extension TipoDeEscala {
    /// Los estilos en que se usa la escala, en el orden de `EstiloDeEscala.allCases`: los occidentales en las de
    /// `todos` (`[.clasica, .jazz]` en el dórico), el carnático o el indostánico en las de la India… Vacío en las
    /// propias y en las de otras tradiciones sin uno claro. Se busca por su `identidad`, como `tradicion`: Kāfī tiene
    /// las notas del dórico, pero no sus estilos.
    ///
    ///     TipoDeEscala.mohanam.estilos   // [.carnatica]
    public var estilos: [EstiloDeEscala] { fichaDelCatalogo.estilos }
}
