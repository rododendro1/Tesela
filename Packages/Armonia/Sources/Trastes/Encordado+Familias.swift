import Elementos

// MARK: - Las familias de instrumentos
//
// Los instrumentos de `Encordado.todos`, agrupados como en un selector: las guitarras (con la vihuela, su antecesora
// de seis órdenes), los bajos, los ukeleles y las guitarras pequeñas de América (charango, cuatro, tres), los laúdes y
// las mandolinas (con el ud, el buzuki, la pipa, la balalaica y la guitarra portuguesa, de mástil corto y órdenes
// dobles o caja redonda), los banjos y las cítaras, y la cuerda frotada.

/// La familia de un instrumento del catálogo, para agruparlos.
///
///     Encordado.charango.familia   // .guitarrasPequenas
public enum FamiliaDeEncordado: String, Hashable, Sendable, Codable, CaseIterable {
    case guitarras
    case bajos
    case guitarrasPequenas
    case laudes
    case banjosYCitaras
    case cuerdaFrotada

    /// «guitarras», «laúdes y mandolinas»… en el idioma de la notación.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .guitarras: TextosDeTrastes.traduccion(\.familiaGuitarras).en(notacion)
        case .bajos: TextosDeTrastes.traduccion(\.familiaBajos).en(notacion)
        case .guitarrasPequenas: TextosDeTrastes.traduccion(\.familiaGuitarrasPequenas).en(notacion)
        case .laudes: TextosDeTrastes.traduccion(\.familiaLaudes).en(notacion)
        case .banjosYCitaras: TextosDeTrastes.traduccion(\.familiaBanjosYCitaras).en(notacion)
        case .cuerdaFrotada: TextosDeTrastes.traduccion(\.familiaCuerdaFrotada).en(notacion)
        }
    }

    /// Los instrumentos de la familia, en el orden de `Encordado.todos`.
    public var encordados: [Encordado] { Encordado.todos.filter { $0.familia == self } }
}

extension Encordado {
    /// Los de cada familia. Que estén todos los de `todos` lo comprueban las pruebas.
    private static let familias: [FamiliaDeEncordado: [Encordado]] = [
        .guitarras: [
            .guitarra, .guitarraEnReGrave, .guitarraEnReAbierto, .guitarraEnSolAbierto, .guitarraDADGAD,
            .guitarraDeSieteCuerdas, .guitarraEnDoAbierto, .guitarraEnDoGrave, .guitarraEnMiAbierto,
            .guitarraNashville, .guitarraDeDoceCuerdas, .vihuela,
        ],
        .bajos: [.bajoElectrico, .bajoDeCincoCuerdas],
        .guitarrasPequenas: [.ukelele, .ukeleleBariton, .charango, .cuatroVenezolano, .tresCubano],
        .laudes: [
            .mandolina, .mandola, .bandurria, .laud, .laudRenacentista, .ud, .buzuki, .guitarraPortuguesa,
            .balalaica, .pipa,
        ],
        .banjosYCitaras: [.banjo, .dulcemele],
        .cuerdaFrotada: [.violin, .viola, .violonchelo, .contrabajo],
    ]

    /// Su familia; `nil` si no es del catálogo.
    public var familia: FamiliaDeEncordado? {
        Encordado.familias.first { $0.value.contains(self) }?.key
    }

    /// Las familias con sus instrumentos, en el orden de `FamiliaDeEncordado.allCases`: lo que lista un selector
    /// agrupado.
    public static var porFamilias: [(familia: FamiliaDeEncordado, encordados: [Encordado])] {
        FamiliaDeEncordado.allCases.map { ($0, $0.encordados) }
    }
}
