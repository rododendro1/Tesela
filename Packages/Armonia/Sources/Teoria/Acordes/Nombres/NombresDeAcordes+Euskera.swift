// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los nombres de los acordes del catálogo en euskera. Qué es cada campo, en `NombresDeAcordes.swift`.

extension NombresDeAcordes {
    static let euskera = NombresDeAcordes([
        .init(.mayor, "maiorra"),
        .init(.menor, "minorra"),
        .init(.disminuido, "gutxitua"),
        .init(.aumentado, "gehitua"),
        .init(.sus2, "bigarrenera esekia"),
        .init(.sus4, "laugarrenera esekia"),
        .init(.potencia, "bosgarrena (potentzia-akordea)"),
        .init(.dominanteSeptima, "dominanteko zazpigarrena"),
        .init(.mayorSeptimaMayor, "zazpigarren handia"),
        .init(.menorSeptima, "minor zazpigarrena"),
        .init(.semidisminuido, "erdi-gutxitua"),
        .init(.disminuidoSeptima, "zazpigarren gutxitua"),
        .init(.menorSeptimaMayor, "minorra zazpigarren handiarekin"),
        .init(.aumentadoSeptima, "gehitua zazpigarren txikiarekin"),
        .init(.aumentadoSeptimaMayor, "gehitua zazpigarren handiarekin"),
        .init(.sus4Septima, "zazpigarren esekia"),
        .init(.mayorSexta, "seigarrena"),
        .init(.menorSexta, "minor seigarrena"),
        .init(.mayorSextaNovena, "seigarrena eta bederatzigarrena"),
        .init(.dominanteNovena, "dominanteko bederatzigarrena"),
        .init(.mayorSeptimaMayorNovena, "bederatzigarren handia"),
        .init(.menorSeptimaNovena, "minor bederatzigarrena"),
        .init(.mayorNovenaAnadida, "bederatzigarren gehigarria"),
        .init(.dominanteUndecima, "hamaikagarrena"),
        .init(.menorSeptimaUndecima, "minor hamaikagarrena"),
        .init(.dominanteDecimotercera, "hamahirugarrena"),
        .init(.menorSeptimaDecimotercera, "minor hamahirugarrena"),
        .init(.dominanteNovenaMenor, "zazpigarrena bederatzigarren txikiarekin"),
        .init(.sextaAumentadaItaliana, "seigarren gehitu italiarra"),
        .init(.sextaAumentadaFrancesa, "seigarren gehitu frantsesa"),
        .init(.sextaAumentadaAlemana, "seigarren gehitu alemana"),
    ])
}
