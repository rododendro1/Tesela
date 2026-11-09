import Elementos

// MARK: - Los acordes genéricos del catálogo
//
// Los tipos de acorde que tienen nombre (la tríada mayor, la séptima de dominante, las sextas aumentadas…), con las
// notas desde la fundamental. Los nombres en los otros idiomas están en `Acordes/Nombres/`.

extension AcordeConNombre {
    public static let mayor = AcordeConNombre(
        nombre: "mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta], referencias: [.aldwell2011])
    public static let menor = AcordeConNombre(
        nombre: "menor", intervalos: [.unisono, .terceraMenor, .quintaJusta], referencias: [.aldwell2011])
    public static let disminuido = AcordeConNombre(
        nombre: "disminuido", intervalos: [.unisono, .terceraMenor, .quintaDisminuida], referencias: [.aldwell2011])
    public static let aumentado = AcordeConNombre(
        nombre: "aumentado", intervalos: [.unisono, .terceraMayor, .quintaAumentada], referencias: [.aldwell2011])
    public static let sus2 = AcordeConNombre(
        nombre: "suspendido de segunda", intervalos: [.unisono, .segundaMayor, .quintaJusta], referencias: [.levine1995]
    )
    public static let sus4 = AcordeConNombre(
        nombre: "suspendido de cuarta", intervalos: [.unisono, .cuartaJusta, .quintaJusta], referencias: [.levine1995])
    public static let potencia = AcordeConNombre(
        nombre: "quinta (acorde de potencia)", intervalos: [.unisono, .quintaJusta], estilos: [.popular],
        referencias: [.walser1993])
    public static let dominanteSeptima = AcordeConNombre(
        nombre: "séptima de dominante", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor],
        referencias: [.aldwell2011, .levine1995])
    public static let mayorSeptimaMayor = AcordeConNombre(
        nombre: "séptima mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor],
        referencias: [.aldwell2011, .levine1995])
    public static let menorSeptima = AcordeConNombre(
        nombre: "menor séptima", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor],
        referencias: [.aldwell2011, .levine1995])
    public static let semidisminuido = AcordeConNombre(
        nombre: "semidisminuido", intervalos: [.unisono, .terceraMenor, .quintaDisminuida, .septimaMenor],
        referencias: [.aldwell2011, .levine1995])
    public static let disminuidoSeptima = AcordeConNombre(
        nombre: "séptima disminuida", intervalos: [.unisono, .terceraMenor, .quintaDisminuida, .septimaDisminuida],
        referencias: [.aldwell2011, .levine1995])
    public static let menorSeptimaMayor = AcordeConNombre(
        nombre: "menor con séptima mayor", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMayor],
        referencias: [.levine1995])
    public static let aumentadoSeptima = AcordeConNombre(
        nombre: "aumentado con séptima menor", intervalos: [.unisono, .terceraMayor, .quintaAumentada, .septimaMenor],
        referencias: [.levine1995])
    public static let aumentadoSeptimaMayor = AcordeConNombre(
        nombre: "aumentado con séptima mayor", intervalos: [.unisono, .terceraMayor, .quintaAumentada, .septimaMayor],
        referencias: [.levine1995])
    public static let sus4Septima = AcordeConNombre(
        nombre: "séptima suspendida", intervalos: [.unisono, .cuartaJusta, .quintaJusta, .septimaMenor],
        referencias: [.levine1995])
    public static let mayorSexta = AcordeConNombre(
        nombre: "sexta", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor], referencias: [.levine1995])
    public static let menorSexta = AcordeConNombre(
        nombre: "menor sexta", intervalos: [.unisono, .terceraMenor, .quintaJusta, .sextaMayor],
        referencias: [.levine1995])
    public static let mayorSextaNovena = AcordeConNombre(
        nombre: "sexta y novena", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor, .novenaMayor],
        referencias: [.levine1995])
    public static let dominanteNovena = AcordeConNombre(
        nombre: "novena de dominante",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor],
        referencias: [.aldwell2011, .levine1995])
    public static let mayorSeptimaMayorNovena = AcordeConNombre(
        nombre: "novena mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor, .novenaMayor],
        referencias: [.levine1995])
    public static let menorSeptimaNovena = AcordeConNombre(
        nombre: "menor novena", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor],
        referencias: [.levine1995])
    public static let mayorNovenaAnadida = AcordeConNombre(
        nombre: "novena añadida", intervalos: [.unisono, .terceraMayor, .quintaJusta, .novenaMayor],
        referencias: [.levine1995])
    public static let dominanteUndecima = AcordeConNombre(
        nombre: "undécima",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima],
        referencias: [.levine1995])
    public static let menorSeptimaUndecima = AcordeConNombre(
        nombre: "menor undécima",
        intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima],
        referencias: [.levine1995])
    public static let dominanteDecimotercera = AcordeConNombre(
        nombre: "decimotercera",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor, .decimoterceraMayor],
        referencias: [.levine1995])
    public static let menorSeptimaDecimotercera = AcordeConNombre(
        nombre: "menor decimotercera",
        intervalos: [
            .unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima, .decimoterceraMayor,
        ], referencias: [.levine1995])
    public static let dominanteNovenaMenor = AcordeConNombre(
        nombre: "séptima con novena menor",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMenor],
        referencias: [.aldwell2011, .levine1995])
    public static let dominanteQuintaDisminuida = AcordeConNombre(
        nombre: "séptima con quinta disminuida",
        intervalos: [.unisono, .terceraMayor, .quintaDisminuida, .septimaMenor], referencias: [.levine1995])
    public static let dominanteNovenaAumentada = AcordeConNombre(
        nombre: "séptima con novena aumentada",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaAumentada],
        referencias: [.levine1995])
    public static let dominanteUndecimaAumentada = AcordeConNombre(
        nombre: "séptima con undécima aumentada",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .undecimaAumentada],
        referencias: [.levine1995])
    public static let mayorSeptimaMayorUndecimaAumentada = AcordeConNombre(
        nombre: "séptima mayor con undécima aumentada",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor, .undecimaAumentada],
        referencias: [.levine1995])
    public static let sus4Novena = AcordeConNombre(
        nombre: "novena suspendida",
        intervalos: [.unisono, .cuartaJusta, .quintaJusta, .septimaMenor, .novenaMayor], referencias: [.levine1995])
    public static let sus4Decimotercera = AcordeConNombre(
        nombre: "decimotercera suspendida",
        intervalos: [.unisono, .cuartaJusta, .quintaJusta, .septimaMenor, .novenaMayor, .decimoterceraMayor],
        referencias: [.levine1995])
    /// La de `7alt`: la séptima de dominante con la novena menor y la aumentada, la undécima aumentada y la
    /// decimotercera menor (las cuatro tensiones alteradas).
    public static let dominanteAlterado = AcordeConNombre(
        nombre: "séptima alterada",
        intervalos: [
            .unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMenor, .novenaAumentada, .undecimaAumentada,
            .decimoterceraMenor,
        ], alias: ["acorde alterado"], referencias: [.levine1995])
    public static let menorSeptimaMayorNovena = AcordeConNombre(
        nombre: "menor con séptima mayor y novena",
        intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMayor, .novenaMayor], referencias: [.levine1995])
    public static let mayorSeptimaMayorDecimotercera = AcordeConNombre(
        nombre: "decimotercera mayor",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor, .novenaMayor, .decimoterceraMayor],
        referencias: [.levine1995])
    public static let menorSextaNovena = AcordeConNombre(
        nombre: "menor sexta y novena",
        intervalos: [.unisono, .terceraMenor, .quintaJusta, .sextaMayor, .novenaMayor], referencias: [.levine1995])
    public static let sextaAumentadaItaliana = AcordeConNombre(
        nombre: "sexta aumentada italiana", intervalos: [.unisono, .terceraMayor, .sextaAumentada], estilos: [.clasica],
        referencias: [.aldwell2011])
    public static let sextaAumentadaFrancesa = AcordeConNombre(
        nombre: "sexta aumentada francesa",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaAumentada],
        estilos: [.clasica], referencias: [.aldwell2011])
    public static let sextaAumentadaAlemana = AcordeConNombre(
        nombre: "sexta aumentada alemana",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaAumentada],
        estilos: [.clasica], referencias: [.aldwell2011])

    /// Los genéricos, los que dan nombre a los tipos de acorde (`TipoDeAcorde.acordeConNombre`), en el orden en que
    /// tienen prioridad: si dos tuvieran las mismas notas, el primero daría nombre al tipo.
    public static let genericos: [AcordeConNombre] = [
        .mayor, .menor, .disminuido, .aumentado, .sus2, .sus4, .potencia, .dominanteSeptima, .mayorSeptimaMayor,
        .menorSeptima, .semidisminuido, .disminuidoSeptima, .menorSeptimaMayor, .aumentadoSeptima,
        .aumentadoSeptimaMayor, .sus4Septima, .mayorSexta, .menorSexta, .mayorSextaNovena, .dominanteNovena,
        .mayorSeptimaMayorNovena, .menorSeptimaNovena, .mayorNovenaAnadida, .dominanteUndecima, .menorSeptimaUndecima,
        .dominanteDecimotercera, .menorSeptimaDecimotercera, .dominanteNovenaMenor, .dominanteQuintaDisminuida,
        .dominanteNovenaAumentada, .dominanteUndecimaAumentada, .mayorSeptimaMayorUndecimaAumentada, .sus4Novena,
        .sus4Decimotercera, .dominanteAlterado, .menorSeptimaMayorNovena, .mayorSeptimaMayorDecimotercera,
        .menorSextaNovena, .sextaAumentadaItaliana,
        .sextaAumentadaFrancesa, .sextaAumentadaAlemana,
    ]
}
