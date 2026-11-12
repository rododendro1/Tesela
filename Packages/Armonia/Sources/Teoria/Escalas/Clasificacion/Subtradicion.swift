import Elementos

// MARK: - Subtradiciones de una escala (obsoleto)
//
// `Subtradicion` juntaba en un tipo tres cosas que ya tienen el suyo: el estilo occidental en que se usa una escala
// (`Estilo`: la clásica, el jazz), la escuela de otra tradición (`Escuela`: la música carnática, el gagaku) y la región
// o el pueblo de donde viene (`RegionDeEscala`: Java, Escocia, los chopi). La región es un lugar: está en `Lugar`, con
// los países y los continentes que la contienen, y una escala la da en `lugaresDeOrigen`. Se usan `estilos`,
// `escuelas` y `lugaresDeOrigen` (o `regiones`); `Subtradicion` y `subtradiciones` se van en la 0.6.0.

/// Una subtradición: un estilo (`Estilo`), una escuela (`Escuela`) o una región (`RegionDeEscala`) dentro de una
/// tradición. Obsoleto: se usan `TipoDeEscala.estilos`, `escuelas` y `lugaresDeOrigen`.
///
///     TipoDeEscala.slendro.subtradiciones   // [.region(.java), .region(.bali)]
///     TipoDeEscala.dorico.subtradiciones    // [.estilo(.clasica), .estilo(.jazz)]
@available(*, deprecated, message: "usa Estilo, Escuela y Lugar: TipoDeEscala.estilos, escuelas y lugaresDeOrigen")
public enum Subtradicion: Hashable, Sendable, Codable {
    case estilo(Estilo)
    case escuela(Escuela)
    case region(RegionDeEscala)

    /// Todas: primero los estilos, después las escuelas y por último las regiones, en el orden de sus casos.
    public static let todas: [Subtradicion] =
        Estilo.allCases.map(Subtradicion.estilo) + Escuela.allCases.map(Subtradicion.escuela)
        + RegionDeEscala.allCases.map(Subtradicion.region)

    /// La tradición a la que pertenece.
    public var tradicion: Tradicion {
        switch self {
        case .estilo: .occidental
        case .escuela(let escuela): escuela.tradicion
        case .region(let region): region.tradicion
        }
    }

    /// Las escalas del catálogo de esta subtradición (`Estilo.tipos` o `RegionDeEscala.tipos`), solo las de su
    /// tradición: `.region(.hungria)` da la pentatónica húngara, y no las occidentales populares que vienen de Hungría.
    public var tipos: [TipoDeEscala] {
        switch self {
        case .estilo(let estilo): estilo.tipos
        case .escuela(let escuela): escuela.tipos
        case .region(let region): region.tipos.filter { $0.tradicion == region.tradicion }
        }
    }

    /// El nombre del estilo o de la región en el idioma de los textos de la notación.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .estilo(let estilo): estilo.nombre(en: notacion)
        case .escuela(let escuela): escuela.nombre(en: notacion)
        case .region(let region): region.nombre(en: notacion)
        }
    }
}

@available(*, deprecated)
extension Subtradicion: Nombrable {}

extension TipoDeEscala {
    /// Los estilos, las escuelas y las regiones de su tradición, por ese orden: la menor húngara, occidental, no tiene
    /// la región de Hungría, que es de la tradición europea. Obsoleto: `estilos`, `escuelas` y `lugaresDeOrigen`.
    @available(*, deprecated, message: "usa estilos, escuelas y lugaresDeOrigen")
    public var subtradiciones: [Subtradicion] {
        estilos.map(Subtradicion.estilo) + escuelas.map(Subtradicion.escuela)
            + regiones.filter { $0.tradicion == tradicion }.map(Subtradicion.region)
    }
}
