import Elementos

// MARK: - La sonoridad calculada
//
// Las escalas occidentales modernas no tienen un carácter con fuente (`TipoDeEscala.caracter`): lo que circula («el
// lidio, onírico») es lenguaje de manual. En su lugar tienen una sonoridad que Tesela calcula con el brillo, con otro
// nombre para que no se confunda con lo que dice una fuente. Es el criterio con que Persichetti (1961) ordena los modos
// de la mayor del más claro al más oscuro: lidio, jónico, mixolidio, dórico, eólico, frigio y locrio.

/// Lo clara u oscura que suena una escala occidental, calculado con su brillo por quintas
/// (`EstadisticasDeEscala.brilloPorQuintas`): clara desde 1 (el mixolidio, el jónico, el lidio, la pentatónica mayor),
/// oscura desde −1 hacia abajo (el eólico, el frigio, el locrio, la pentatónica menor), e intermedia entre medias (el
/// dórico). No es un carácter: no lo dice ninguna fuente, y por eso va aparte de ``Caracter``.
public enum Sonoridad: String, Sendable, Codable, CaseIterable, Comparable, Nombrable {
    case clara, intermedia, oscura

    /// La de un brillo por quintas: clara desde 1, oscura hasta −1, intermedia entre medias.
    public init(brilloPorQuintas brillo: Double) {
        self = brillo >= 1 ? .clara : brillo <= -1 ? .oscura : .intermedia
    }

    /// De la más clara a la más oscura.
    public static func < (a: Sonoridad, b: Sonoridad) -> Bool {
        allCases.firstIndex(of: a)! < allCases.firstIndex(of: b)!
    }

    /// «clara», «bright», «hell».
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .clara: TextosDeTeoria.traduccion(\.sonoridadClara)
        case .intermedia: TextosDeTeoria.traduccion(\.sonoridadIntermedia)
        case .oscura: TextosDeTeoria.traduccion(\.sonoridadOscura)
        }
    }
}

extension TipoDeEscala {
    /// Las escalas de ``occidentales``, por su identidad: las que tienen sonoridad.
    private static let identidadesOccidentales = Set(occidentales.map(\.identidad))

    /// La sonoridad calculada de una escala occidental (``Sonoridad``): el lidio y la mayor, clara; el dórico,
    /// intermedia; el frigio, oscura. `nil` en las de otras tradiciones, que tienen su carácter de fuente (o ninguno),
    /// y en las escalas propias.
    ///
    ///     TipoDeEscala.lidio.sonoridad     // .clara
    ///     TipoDeEscala.dorico.sonoridad    // .intermedia
    ///     TipoDeEscala.bayati.sonoridad    // nil
    public var sonoridad: Sonoridad? {
        guard TipoDeEscala.identidadesOccidentales.contains(identidad) else { return nil }
        return Sonoridad(brilloPorQuintas: EstadisticasDeEscala(Escala(.do, self)).brilloPorQuintas)
    }
}
