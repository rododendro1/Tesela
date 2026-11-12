import Elementos

// MARK: - Subtradiciones de una escala: su estilo y su región
//
// Una escala puede tener dos clases de subtradición dentro de su `Tradicion`: el estilo o repertorio en que se usa
// (la música carnática, el gagaku, el jazz) y la región o el pueblo de donde viene (Java, Escocia, los chopi). Son dos
// tipos, `Estilo` y `RegionDeEscala`, y `Subtradicion` reúne los dos. Una escala puede tener varios de cada
// uno: el dórico es clásico y de jazz, y el sléndro se toca en Java y en Bali.

/// Una subtradición: un estilo (`Estilo`) o una región (`RegionDeEscala`) dentro de una tradición.
///
///     TipoDeEscala.slendro.subtradiciones   // [.region(.java), .region(.bali)]
///     TipoDeEscala.dorico.subtradiciones    // [.estilo(.clasica), .estilo(.jazz)]
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

extension Subtradicion: Nombrable {}

extension TipoDeEscala {
    /// Los estilos, las escuelas y las regiones de su tradición, por ese orden: la menor húngara, occidental, no tiene
    /// la región de Hungría, que es de la tradición europea.
    public var subtradiciones: [Subtradicion] {
        estilos.map(Subtradicion.estilo) + escuelas.map(Subtradicion.escuela)
            + regiones.filter { $0.tradicion == tradicion }.map(Subtradicion.region)
    }
}
