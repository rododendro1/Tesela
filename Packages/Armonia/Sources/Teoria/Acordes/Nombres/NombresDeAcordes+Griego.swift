// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los nombres de los acordes del catálogo en griego. Qué es cada campo, en `NombresDeAcordes.swift`.

extension NombresDeAcordes {
    static let griego = NombresDeAcordes([
        .init(.mayor, "μείζονα συγχορδία"),
        .init(.menor, "ελάσσονα συγχορδία"),
        .init(.disminuido, "ελαττωμένη συγχορδία"),
        .init(.aumentado, "αυξημένη συγχορδία"),
        .init(.sus2, "συγχορδία sus2"),
        .init(.sus4, "συγχορδία sus4"),
        .init(.potencia, "συγχορδία πέμπτης"),
        .init(.dominanteSeptima, "συγχορδία έβδομης δεσπόζουσας"),
        .init(.mayorSeptimaMayor, "μείζονα συγχορδία μεγάλης έβδομης"),
        .init(.menorSeptima, "ελάσσονα συγχορδία μικρής έβδομης"),
        .init(.semidisminuido, "ημιελαττωμένη συγχορδία έβδομης"),
        .init(.disminuidoSeptima, "ελαττωμένη συγχορδία έβδομης"),
        .init(.menorSeptimaMayor, "ελάσσονα συγχορδία μεγάλης έβδομης"),
        .init(.aumentadoSeptima, "αυξημένη συγχορδία μικρής έβδομης"),
        .init(.aumentadoSeptimaMayor, "αυξημένη συγχορδία μεγάλης έβδομης"),
        .init(.sus4Septima, "συγχορδία έβδομης δεσπόζουσας με καθυστέρηση τέταρτης"),
        .init(.mayorSexta, "μείζονα συγχορδία με έκτη"),
        .init(.menorSexta, "ελάσσονα συγχορδία με έκτη"),
        .init(.mayorSextaNovena, "συγχορδία έκτης και ένατης"),
        .init(.dominanteNovena, "συγχορδία ένατης δεσπόζουσας"),
        .init(.mayorSeptimaMayorNovena, "μείζονα συγχορδία μεγάλης ένατης"),
        .init(.menorSeptimaNovena, "ελάσσονα συγχορδία ένατης"),
        .init(.mayorNovenaAnadida, "μείζονα συγχορδία με προστιθέμενη ένατη"),
        .init(.dominanteUndecima, "συγχορδία ενδέκατης δεσπόζουσας"),
        .init(.menorSeptimaUndecima, "ελάσσονα συγχορδία ενδέκατης"),
        .init(.dominanteDecimotercera, "συγχορδία δέκατης τρίτης δεσπόζουσας"),
        .init(.menorSeptimaDecimotercera, "ελάσσονα συγχορδία δέκατης τρίτης"),
        .init(.dominanteNovenaMenor, "συγχορδία έβδομης δεσπόζουσας με μικρή ένατη"),
        .init(.sextaAumentadaItaliana, "ιταλική συγχορδία αυξημένης έκτης"),
        .init(.sextaAumentadaFrancesa, "γαλλική συγχορδία αυξημένης έκτης"),
        .init(.sextaAumentadaAlemana, "γερμανική συγχορδία αυξημένης έκτης"),
    ])
}
