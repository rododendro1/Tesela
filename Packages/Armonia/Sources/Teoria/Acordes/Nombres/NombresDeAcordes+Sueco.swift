// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los nombres de los acordes del catálogo en sueco. Qué es cada campo, en `NombresDeAcordes.swift`.

extension NombresDeAcordes {
    static let sueco = NombresDeAcordes([
        .init(.mayor, "durtreklang"),
        .init(.menor, "molltreklang"),
        .init(.disminuido, "förminskad treklang"),
        .init(.aumentado, "överstigande treklang"),
        .init(.sus2, "sus2-ackord"),
        .init(.sus4, "sus4-ackord"),
        .init(.potencia, "kvintklang (powerackord)"),
        .init(.dominanteSeptima, "dominantseptimackord"),
        .init(.mayorSeptimaMayor, "stort septimackord"),
        .init(.menorSeptima, "mollseptimackord"),
        .init(.semidisminuido, "halvförminskat septimackord"),
        .init(.disminuidoSeptima, "förminskat septimackord"),
        .init(.menorSeptimaMayor, "moll med stor septima"),
        .init(.aumentadoSeptima, "överstigande septimackord"),
        .init(.aumentadoSeptimaMayor, "överstigande stort septimackord"),
        .init(.sus4Septima, "dominantseptimackord med kvartförhållning"),
        .init(.mayorSexta, "dur med sext"),
        .init(.menorSexta, "moll med sext"),
        .init(.mayorSextaNovena, "sext-nonackord"),
        .init(.dominanteNovena, "dominantnonackord"),
        .init(.mayorSeptimaMayorNovena, "stort nonackord"),
        .init(.menorSeptimaNovena, "mollnonackord"),
        .init(.mayorNovenaAnadida, "dur med tillagd nona"),
        .init(.dominanteUndecima, "dominantundecimackord"),
        .init(.menorSeptimaUndecima, "mollundecimackord"),
        .init(.dominanteDecimotercera, "dominanttredecimackord"),
        .init(.menorSeptimaDecimotercera, "molltredecimackord"),
        .init(.dominanteNovenaMenor, "dominantseptimackord med liten nona"),
        .init(.sextaAumentadaItaliana, "italienskt överstigande sextackord"),
        .init(.sextaAumentadaFrancesa, "franskt överstigande sextackord"),
        .init(.sextaAumentadaAlemana, "tyskt överstigande sextackord"),
    ])
}
