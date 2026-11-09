import Elementos

// MARK: - Cuántas notas tiene un acorde

/// El nombre de un acorde por sus notas distintas: díada (2), tríada (3), tétrada (4), péntada (5), héxada (6),
/// héptada (7), que es lo más que da una lectura por terceras sin alteraciones dobles (la decimotercera), y óctada
/// (8), como la séptima alterada o el acorde alfa. Fuera de ahí no tiene nombre: un cluster de diez notas se cuenta,
/// pero no se nombra. Es el hermano de `CardinalDeEscala`, con otros nombres.
///
///     TipoDeAcorde.dominanteSeptima.cardinal          // .tetrada
///     TipoDeAcorde.potencia.cardinal?.nombre          // "díada"
///     AcordeConNombre.petrushka.cardinal              // .hexada
///     TipoDeAcorde.todos(numeroDeNotas: 3)            // mayor, menor, disminuido, aumentado, sus2, sus4
public enum CardinalDeAcorde: Int, Sendable, Codable, CaseIterable, Comparable {
    case diada = 2
    case triada = 3
    case tetrada = 4
    case pentada = 5
    case hexada = 6
    case heptada = 7
    case octada = 8

    /// El cardinal de un acorde de `numeroDeNotas` notas distintas, o `nil` si no tiene nombre (menos de dos o más
    /// de ocho).
    public init?(numeroDeNotas: Int) { self.init(rawValue: numeroDeNotas) }

    public var numeroDeNotas: Int { rawValue }

    public static func < (a: CardinalDeAcorde, b: CardinalDeAcorde) -> Bool { a.rawValue < b.rawValue }

    /// El nombre en el idioma de los textos de la notación: «tétrada», «tetrad», «Vierklang». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un cardinal nuevo
    /// no compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .diada: TextosDeTeoria.traduccion(\.cardinalDiada)
        case .triada: TextosDeTeoria.traduccion(\.cardinalTriada)
        case .tetrada: TextosDeTeoria.traduccion(\.cardinalTetrada)
        case .pentada: TextosDeTeoria.traduccion(\.cardinalPentada)
        case .hexada: TextosDeTeoria.traduccion(\.cardinalHexada)
        case .heptada: TextosDeTeoria.traduccion(\.cardinalHeptada)
        case .octada: TextosDeTeoria.traduccion(\.cardinalOctada)
        }
    }
}

extension CardinalDeAcorde: Nombrable {}

extension TipoDeAcorde {
    /// Las notas distintas del tipo, por su ortografía: 3 en las tríadas, 4 en las cuatríadas, 7 en la decimotercera.
    public var numeroDeNotas: Int { pasosDeQuinta.count }

    /// Su nombre por el número de notas (`CardinalDeAcorde`), si lo tiene.
    public var cardinal: CardinalDeAcorde? { CardinalDeAcorde(numeroDeNotas: numeroDeNotas) }

    /// Los tipos de `todos` con ese número de notas, en su orden.
    public static func todos(numeroDeNotas: Int) -> [TipoDeAcorde] {
        todos.filter { $0.numeroDeNotas == numeroDeNotas }
    }
}

extension AcordeConNombre {
    /// Las notas distintas de su disposición, por su ortografía (las octavas no cuentan): 4 en el de Tristán, 6 en
    /// el de Petrushka.
    public var numeroDeNotas: Int { pasosDeQuinta.count }

    /// Su nombre por el número de notas (`CardinalDeAcorde`), si lo tiene.
    public var cardinal: CardinalDeAcorde? { CardinalDeAcorde(numeroDeNotas: numeroDeNotas) }

    /// Los del catálogo con ese número de notas, en su orden.
    public static func todos(numeroDeNotas: Int) -> [AcordeConNombre] {
        catalogo.filter { $0.numeroDeNotas == numeroDeNotas }
    }
}

extension Acorde {
    /// Las notas distintas del acorde, con el bajo si no es una de ellas: 3 en Do, 4 en Do7 y en Do/Re.
    public var numeroDeNotas: Int { tipo.numeroDeNotas + (tieneBajoAjeno ? 1 : 0) }

    /// Su nombre por el número de notas (`CardinalDeAcorde`), si lo tiene.
    public var cardinal: CardinalDeAcorde? { CardinalDeAcorde(numeroDeNotas: numeroDeNotas) }
}
