import Elementos

// MARK: - Los acordes genéricos del catálogo
//
// Los tipos de acorde que tienen nombre (la tríada mayor, la séptima de dominante, las sextas aumentadas…), con las
// notas desde la fundamental. Los nombres en los otros idiomas están en `Acordes/Nombres/`.

extension AcordeConNombre {
    public static let mayor = AcordeConNombre(nombre: "mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta])
    public static let menor = AcordeConNombre(nombre: "menor", intervalos: [.unisono, .terceraMenor, .quintaJusta])
    public static let disminuido = AcordeConNombre(
        nombre: "disminuido", intervalos: [.unisono, .terceraMenor, .quintaDisminuida])
    public static let aumentado = AcordeConNombre(
        nombre: "aumentado", intervalos: [.unisono, .terceraMayor, .quintaAumentada])
    public static let sus2 = AcordeConNombre(
        nombre: "suspendido de segunda", intervalos: [.unisono, .segundaMayor, .quintaJusta])
    public static let sus4 = AcordeConNombre(
        nombre: "suspendido de cuarta", intervalos: [.unisono, .cuartaJusta, .quintaJusta])
    public static let potencia = AcordeConNombre(
        nombre: "quinta (acorde de potencia)", intervalos: [.unisono, .quintaJusta], estilos: [.popular])
    public static let dominanteSeptima = AcordeConNombre(
        nombre: "séptima de dominante", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor])
    public static let mayorSeptimaMayor = AcordeConNombre(
        nombre: "séptima mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor])
    public static let menorSeptima = AcordeConNombre(
        nombre: "menor séptima", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor])
    public static let semidisminuido = AcordeConNombre(
        nombre: "semidisminuido", intervalos: [.unisono, .terceraMenor, .quintaDisminuida, .septimaMenor])
    public static let disminuidoSeptima = AcordeConNombre(
        nombre: "séptima disminuida", intervalos: [.unisono, .terceraMenor, .quintaDisminuida, .septimaDisminuida])
    public static let menorSeptimaMayor = AcordeConNombre(
        nombre: "menor con séptima mayor", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMayor])
    public static let aumentadoSeptima = AcordeConNombre(
        nombre: "aumentado con séptima menor", intervalos: [.unisono, .terceraMayor, .quintaAumentada, .septimaMenor])
    public static let aumentadoSeptimaMayor = AcordeConNombre(
        nombre: "aumentado con séptima mayor", intervalos: [.unisono, .terceraMayor, .quintaAumentada, .septimaMayor])
    public static let sus4Septima = AcordeConNombre(
        nombre: "séptima suspendida", intervalos: [.unisono, .cuartaJusta, .quintaJusta, .septimaMenor])
    public static let mayorSexta = AcordeConNombre(
        nombre: "sexta", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor])
    public static let menorSexta = AcordeConNombre(
        nombre: "menor sexta", intervalos: [.unisono, .terceraMenor, .quintaJusta, .sextaMayor])
    public static let mayorSextaNovena = AcordeConNombre(
        nombre: "sexta y novena", intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaMayor, .novenaMayor])
    public static let dominanteNovena = AcordeConNombre(
        nombre: "novena de dominante", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor])
    public static let mayorSeptimaMayorNovena = AcordeConNombre(
        nombre: "novena mayor", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMayor, .novenaMayor])
    public static let menorSeptimaNovena = AcordeConNombre(
        nombre: "menor novena", intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor])
    public static let mayorNovenaAnadida = AcordeConNombre(
        nombre: "novena añadida", intervalos: [.unisono, .terceraMayor, .quintaJusta, .novenaMayor])
    public static let dominanteUndecima = AcordeConNombre(
        nombre: "undécima", intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima])
    public static let menorSeptimaUndecima = AcordeConNombre(
        nombre: "menor undécima",
        intervalos: [.unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima])
    public static let dominanteDecimotercera = AcordeConNombre(
        nombre: "decimotercera",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMayor, .decimoterceraMayor])
    public static let menorSeptimaDecimotercera = AcordeConNombre(
        nombre: "menor decimotercera",
        intervalos: [
            .unisono, .terceraMenor, .quintaJusta, .septimaMenor, .novenaMayor, .undecima, .decimoterceraMayor,
        ])
    public static let dominanteNovenaMenor = AcordeConNombre(
        nombre: "séptima con novena menor",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .septimaMenor, .novenaMenor])
    public static let sextaAumentadaItaliana = AcordeConNombre(
        nombre: "sexta aumentada italiana", intervalos: [.unisono, .terceraMayor, .sextaAumentada], estilos: [.clasica])
    public static let sextaAumentadaFrancesa = AcordeConNombre(
        nombre: "sexta aumentada francesa",
        intervalos: [.unisono, .terceraMayor, .cuartaAumentada, .sextaAumentada],
        estilos: [.clasica])
    public static let sextaAumentadaAlemana = AcordeConNombre(
        nombre: "sexta aumentada alemana",
        intervalos: [.unisono, .terceraMayor, .quintaJusta, .sextaAumentada],
        estilos: [.clasica])

    /// Los genéricos, los que dan nombre a los tipos de acorde (`TipoDeAcorde.acordeConNombre`), en el orden en que
    /// tienen prioridad: si dos tuvieran las mismas notas, el primero daría nombre al tipo.
    public static let genericos: [AcordeConNombre] = [
        .mayor, .menor, .disminuido, .aumentado, .sus2, .sus4, .potencia, .dominanteSeptima, .mayorSeptimaMayor,
        .menorSeptima, .semidisminuido, .disminuidoSeptima, .menorSeptimaMayor, .aumentadoSeptima,
        .aumentadoSeptimaMayor, .sus4Septima, .mayorSexta, .menorSexta, .mayorSextaNovena, .dominanteNovena,
        .mayorSeptimaMayorNovena, .menorSeptimaNovena, .mayorNovenaAnadida, .dominanteUndecima, .menorSeptimaUndecima,
        .dominanteDecimotercera, .menorSeptimaDecimotercera, .dominanteNovenaMenor, .sextaAumentadaItaliana,
        .sextaAumentadaFrancesa, .sextaAumentadaAlemana,
    ]
}
