import Elementos

// MARK: - La geografía de una escala
//
// De dónde viene una escala: su tradición (`TipoDeEscala.tradicion`: Japón, Persia, el mundo árabe…) y, más en
// concreto, sus regiones (`regionesDeOrigen`: Java, Escocia, Andalucía…). En las de otras tradiciones son las de su
// ficha (`regiones`). En las occidentales solo las tienen las populares que vienen de un lugar: unas lo dicen en
// `regionesDeLasPopulares`, y las demás lo toman de las escalas populares europeas con sus mismas notas. Y hay nombres
// que parecen decir de dónde viene la escala y no lo dicen: la persa no es persa.

extension TipoDeEscala {
    /// Las occidentales cuyo nombre es geográfico pero no dice de dónde vienen: la persa, la egipcia y la oriental son
    /// etiquetas exóticas de los libros de escalas, sin nada que ver con la música de esos lugares, y las napolitanas
    /// se llaman así por la sexta napolitana, no por Nápoles.
    public static let nombresGeograficosSinOrigen: [TipoDeEscala] = [
        .persa, .egipcia, .oriental, .napolitanaMenor, .napolitanaMayor,
    ]

    /// Las occidentales populares que vienen de un lugar, con sus regiones. No van en su ficha (`regiones`), que en
    /// las occidentales está vacía: una región es de una tradición (Andalucía, de la europea), y estas escalas son de la
    /// occidental.
    static let regionesDeLasPopulares: [(tipo: TipoDeEscala, regiones: [RegionDeEscala])] = [
        (.flamenca, [.andalucia]),
        (.mayorRumana, [.rumania]),
        (.doricoCuartaAumentada, [.rumania]),
        (.menorHungara, [.hungria]),
        (.mayorHungara, [.hungria]),
        (.pentatonicaEscocesa, [.escocia]),
    ]

    /// Su nombre es de un lugar del que no viene (`nombresGeograficosSinOrigen`): la persa, la egipcia, la oriental y
    /// las napolitanas. Por su identidad, como `estilos`.
    public var nombreGeograficoSinOrigen: Bool {
        TipoDeEscala.nombresGeograficosSinOrigen.contains { $0.esIdentico(a: self) }
    }

    /// Las regiones de donde viene, en el orden de `RegionDeEscala.allCases`. En las de otras tradiciones, las de su
    /// ficha (`regiones`: el sléndro, de Java y de Bali). En las occidentales populares (solo de estilo popular), las
    /// suyas y las de las escalas populares europeas con sus mismas notas: el dórico ♯4, la «menor rumana», es de
    /// Rumanía y, por el dórico ucraniano, de Ucrania. Vacío en las demás occidentales (la mayor, el dórico), en las
    /// que tienen un nombre geográfico sin origen (`nombreGeograficoSinOrigen`) y en las propias.
    public var regionesDeOrigen: [RegionDeEscala] {
        guard tradicion == .occidental else { return regiones }
        guard estilos == [.popular], !nombreGeograficoSinOrigen else { return [] }
        var suyas = Set(TipoDeEscala.regionesDeLasPopulares.first { $0.tipo.esIdentico(a: self) }?.regiones ?? [])
        for europea in TipoDeEscala.tradicionales where europea.tradicion == .europa && europea == self {
            suyas.formUnion(europea.regiones)
        }
        return RegionDeEscala.allCases.filter(suyas.contains)
    }
}
