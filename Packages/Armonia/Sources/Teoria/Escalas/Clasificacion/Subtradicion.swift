import Elementos

// MARK: - Subtradiciones de una escala: su estilo y su región
//
// Una escala puede tener dos clases de subtradición dentro de su `Tradicion`: el estilo o repertorio en que se usa
// (la música carnática, el gagaku, el jazz) y la región o el pueblo de donde viene (Java, Escocia, los chopi). Son dos
// tipos, `EstiloDeEscala` y `RegionDeEscala`, y `Subtradicion` reúne los dos. Una escala puede tener varios de cada
// uno: el dórico es clásico y de jazz, y el sléndro se toca en Java y en Bali.

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

extension Subtradicion: Nombrable {}

extension TipoDeEscala {
    /// Los estilos y las regiones, por ese orden.
    public var subtradiciones: [Subtradicion] { estilos.map(Subtradicion.estilo) + regiones.map(Subtradicion.region) }
}
