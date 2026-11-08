// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los nombres de los acordes del catálogo en portugués. Qué es cada campo, en `NombresDeAcordes.swift`.

extension NombresDeAcordes {
    static let portugues = NombresDeAcordes([
        .init(.mayor, "maior"),
        .init(.menor, "menor"),
        .init(.disminuido, "diminuto"),
        .init(.aumentado, "aumentado"),
        .init(.sus2, "suspenso de segunda"),
        .init(.sus4, "suspenso de quarta"),
        .init(.potencia, "quinta (power chord)"),
        .init(.dominanteSeptima, "sétima de dominante"),
        .init(.mayorSeptimaMayor, "sétima maior"),
        .init(.menorSeptima, "menor com sétima"),
        .init(.semidisminuido, "meio-diminuto"),
        .init(.disminuidoSeptima, "sétima diminuta"),
        .init(.menorSeptimaMayor, "menor com sétima maior"),
        .init(.aumentadoSeptima, "aumentado com sétima menor"),
        .init(.aumentadoSeptimaMayor, "aumentado com sétima maior"),
        .init(.sus4Septima, "sétima suspensa"),
        .init(.mayorSexta, "sexta"),
        .init(.menorSexta, "menor com sexta"),
        .init(.mayorSextaNovena, "sexta e nona"),
        .init(.dominanteNovena, "nona de dominante"),
        .init(.mayorSeptimaMayorNovena, "nona maior"),
        .init(.menorSeptimaNovena, "menor com nona"),
        .init(.mayorNovenaAnadida, "nona adicionada"),
        .init(.dominanteUndecima, "décima primeira"),
        .init(.menorSeptimaUndecima, "menor com décima primeira"),
        .init(.dominanteDecimotercera, "décima terceira"),
        .init(.menorSeptimaDecimotercera, "menor com décima terceira"),
        .init(.dominanteNovenaMenor, "sétima com nona menor"),
        .init(.sextaAumentadaItaliana, "sexta aumentada italiana"),
        .init(.sextaAumentadaFrancesa, "sexta aumentada francesa"),
        .init(.sextaAumentadaAlemana, "sexta aumentada alemã"),
    ])
}
