// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los nombres de los acordes del catálogo en inglés. Qué es cada campo, en `NombresDeAcordes.swift`.

extension NombresDeAcordes {
    static let ingles = NombresDeAcordes([
        .init(.mayor, "major"),
        .init(.menor, "minor"),
        .init(.disminuido, "diminished"),
        .init(.aumentado, "augmented"),
        .init(.sus2, "suspended second"),
        .init(.sus4, "suspended fourth"),
        .init(.potencia, "power chord"),
        .init(.dominanteSeptima, "dominant seventh"),
        .init(.mayorSeptimaMayor, "major seventh"),
        .init(.menorSeptima, "minor seventh"),
        .init(.semidisminuido, "half-diminished seventh"),
        .init(.disminuidoSeptima, "diminished seventh"),
        .init(.menorSeptimaMayor, "minor major seventh"),
        .init(.aumentadoSeptima, "augmented seventh"),
        .init(.aumentadoSeptimaMayor, "augmented major seventh"),
        .init(.sus4Septima, "dominant seventh suspended fourth"),
        .init(.mayorSexta, "major sixth"),
        .init(.menorSexta, "minor sixth"),
        .init(.mayorSextaNovena, "six-nine"),
        .init(.dominanteNovena, "dominant ninth"),
        .init(.mayorSeptimaMayorNovena, "major ninth"),
        .init(.menorSeptimaNovena, "minor ninth"),
        .init(.mayorNovenaAnadida, "added ninth"),
        .init(.dominanteUndecima, "dominant eleventh"),
        .init(.menorSeptimaUndecima, "minor eleventh"),
        .init(.dominanteDecimotercera, "dominant thirteenth"),
        .init(.menorSeptimaDecimotercera, "minor thirteenth"),
        .init(.dominanteNovenaMenor, "dominant seventh flat nine"),
        .init(.sextaAumentadaItaliana, "Italian augmented sixth"),
        .init(.sextaAumentadaFrancesa, "French augmented sixth"),
        .init(.sextaAumentadaAlemana, "German augmented sixth"),
    ])
}
