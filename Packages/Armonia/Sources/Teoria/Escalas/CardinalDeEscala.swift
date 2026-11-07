import Elementos

// MARK: - Cuántas notas tiene una escala

/// El nombre de una escala por sus notas por octava: monotónica (1), ditónica (2), tritónica (3), tetratónica (4),
/// pentatónica (5), hexatónica (6), heptatónica (7), octatónica (8)… hasta dodecatónica (12). Fuera de ahí no tiene
/// nombre: las de microtonos de 17, 22 o 24 notas se cuentan, pero no se nombran.
///
///     TipoDeEscala.pentatonicaMayor.cardinal              // .pentatonica
///     TipoDeEscala.disminuida.cardinal?.nombre            // "octatónica"
///     TipoDeEscala.todos(numeroDeNotas: 6)                // tonos enteros, hexacordo, aumentada…
public enum CardinalDeEscala: Int, Sendable, Codable, CaseIterable, Comparable {
    case monotonica = 1
    case ditonica = 2
    case tritonica = 3
    case tetratonica = 4
    case pentatonica = 5
    case hexatonica = 6
    case heptatonica = 7
    case octatonica = 8
    case nonatonica = 9
    case decatonica = 10
    case endecatonica = 11
    case dodecatonica = 12

    /// El cardinal de una escala de `numeroDeNotas` notas por octava, o `nil` si no tiene nombre (ninguna o más de
    /// doce).
    public init?(numeroDeNotas: Int) { self.init(rawValue: numeroDeNotas) }

    public var numeroDeNotas: Int { rawValue }

    public static func < (a: CardinalDeEscala, b: CardinalDeEscala) -> Bool { a.rawValue < b.rawValue }

    /// El nombre en el idioma de los textos de la notación: «pentatónica», «pentatonic», «Pentatonik». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los doce idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un cardinal nuevo
    /// no compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .monotonica: TextosDeTeoria.traduccion(\.cardinalMonotonica)
        case .ditonica: TextosDeTeoria.traduccion(\.cardinalDitonica)
        case .tritonica: TextosDeTeoria.traduccion(\.cardinalTritonica)
        case .tetratonica: TextosDeTeoria.traduccion(\.cardinalTetratonica)
        case .pentatonica: TextosDeTeoria.traduccion(\.cardinalPentatonica)
        case .hexatonica: TextosDeTeoria.traduccion(\.cardinalHexatonica)
        case .heptatonica: TextosDeTeoria.traduccion(\.cardinalHeptatonica)
        case .octatonica: TextosDeTeoria.traduccion(\.cardinalOctatonica)
        case .nonatonica: TextosDeTeoria.traduccion(\.cardinalNonatonica)
        case .decatonica: TextosDeTeoria.traduccion(\.cardinalDecatonica)
        case .endecatonica: TextosDeTeoria.traduccion(\.cardinalEndecatonica)
        case .dodecatonica: TextosDeTeoria.traduccion(\.cardinalDodecatonica)
        }
    }
}

extension CardinalDeEscala: Nombrable {}

extension TipoDeEscala {
    /// Las notas por octava, en la forma ascendente: 7 en la mayor, 5 en las pentatónicas, 8 en la disminuida.
    public var numeroDeNotas: Int { intervalos.count }

    /// Su nombre por el número de notas (`CardinalDeEscala`), si lo tiene.
    public var cardinal: CardinalDeEscala? { CardinalDeEscala(numeroDeNotas: numeroDeNotas) }

    /// Las escalas de `todos` con ese número de notas, en su orden.
    public static func todos(numeroDeNotas: Int) -> [TipoDeEscala] {
        occidentales.filter { $0.numeroDeNotas == numeroDeNotas }
    }
}
