// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en griego. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let griego = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { bajo in "με μπάσο το \(bajo)" },
        nombresDeLasInversiones: ["θεμελιώδης κατάσταση", "πρώτη αναστροφή", "δεύτερη αναστροφή", "τρίτη αναστροφή",
                                  "τέταρτη αναστροφή", "πέμπτη αναστροφή", "έκτη αναστροφή"],
        inversionConNumero: "αναστροφή _",

        // EstructuraDeAcorde.swift
        papelFundamental: "θεμέλια",
        papelTercera: "τρίτη",
        papelSuspension: "καθυστέρηση",
        papelQuinta: "πέμπτη",
        papelSexta: "έκτη",
        papelSeptima: "έβδομη",
        papelNovena: "ένατη",
        papelUndecima: "ενδέκατη",
        papelDecimotercera: "δέκατη τρίτη",
        papelTension: { n in "τάση \(n)" },
        triadaMayor: "μείζονα",
        triadaMenor: "ελάσσονα",
        triadaDisminuida: "ελαττωμένη",
        triadaAumentada: "αυξημένη",
        triadaSuspendida: "αναρτημένη",
        triadaDeQuinta: "πέμπτης",
        triadaSinTercera: "χωρίς τρίτη",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in vacio ? "μείζονα συγχορδία" : "συγχορδία \(propio)" },
        tipoMayor: "μείζονα συγχορδία",
        tipoMenor: "ελάσσονα συγχορδία",
        tipoDisminuido: "ελαττωμένη συγχορδία",
        tipoAumentado: "αυξημένη συγχορδία",
        tipoSuspendidoDeSegunda: "συγχορδία sus2",
        tipoSuspendidoDeCuarta: "συγχορδία sus4",
        tipoQuintaAcordeDePotencia: "συγχορδία πέμπτης",
        tipoSeptimaDeDominante: "συγχορδία έβδομης δεσπόζουσας",
        tipoSeptimaMayor: "μείζονα συγχορδία μεγάλης έβδομης",
        tipoMenorSeptima: "ελάσσονα συγχορδία μικρής έβδομης",
        tipoSemidisminuido: "ημιελαττωμένη συγχορδία έβδομης",
        tipoSeptimaDisminuida: "ελαττωμένη συγχορδία έβδομης",
        tipoMenorConSeptimaMayor: "ελάσσονα συγχορδία μεγάλης έβδομης",
        tipoAumentadoConSeptimaMenor: "αυξημένη συγχορδία μικρής έβδομης",
        tipoAumentadoConSeptimaMayor: "αυξημένη συγχορδία μεγάλης έβδομης",
        tipoSeptimaSuspendida: "συγχορδία έβδομης δεσπόζουσας με καθυστέρηση τέταρτης",
        tipoSexta: "μείζονα συγχορδία με έκτη",
        tipoMenorSexta: "ελάσσονα συγχορδία με έκτη",
        tipoSextaYNovena: "συγχορδία έκτης και ένατης",
        tipoNovenaDeDominante: "συγχορδία ένατης δεσπόζουσας",
        tipoNovenaMayor: "μείζονα συγχορδία μεγάλης ένατης",
        tipoMenorNovena: "ελάσσονα συγχορδία ένατης",
        tipoNovenaAnadida: "μείζονα συγχορδία με προστιθέμενη ένατη",
        tipoUndecima: "συγχορδία ενδέκατης δεσπόζουσας",
        tipoMenorUndecima: "ελάσσονα συγχορδία ενδέκατης",
        tipoDecimotercera: "συγχορδία δέκατης τρίτης δεσπόζουσας",
        tipoMenorDecimotercera: "ελάσσονα συγχορδία δέκατης τρίτης",
        tipoSeptimaConNovenaMenor: "συγχορδία έβδομης δεσπόζουσας με μικρή ένατη",
        tipoSextaAumentadaItaliana: "ιταλική συγχορδία αυξημένης έκτης",
        tipoSextaAumentadaFrancesa: "γαλλική συγχορδία αυξημένης έκτης",
        tipoSextaAumentadaAlemana: "γερμανική συγχορδία αυξημένης έκτης",

        // Coral.swift
        entreLasVoces: { nombres in "— " + nombres.joined(separator: " και ") },
        enLaVoz: { primera in "— \(primera)" },
        enLosAcordes: { pasos in "(συγχορδίες \(pasos))" },
        enElAcorde: { acorde in "(συγχορδία \(acorde + 1))" },
        quintasParalelas: "Παράλληλες πέμπτες",
        octavasParalelas: "Παράλληλες οκτάβες",
        quintasDirectas: "Κρυφές πέμπτες",
        octavasDirectas: "Κρυφές οκτάβες",
        cruceDeVoces: "Διασταύρωση φωνών",
        superposicion: "Επικάλυψη φωνών",
        separacionExcesiva: "Πάνω από μία οκτάβα",
        saltoNoMelodico: "Μη μελωδικό πήδημα",
        fueraDeTesitura: "Εκτός έκτασης",
        vozBajo: "μπάσο",
        vozTenor: "τενόρος",
        vozContralto: "άλτο",
        vozSoprano: "σοπράνο",
        vozNumero: { numero in "φωνή \(numero)" },

        // Escala.swift
        gradoTonica: "τονική",
        gradoSupertonica: "υπερτονική",
        gradoMediante: "μέση",
        gradoSubdominante: "υποδεσπόζουσα",
        gradoDominante: "δεσπόζουσα",
        gradoSuperdominante: "υπερδεσπόζουσα",
        gradoSensible: "προσαγωγέας",
        gradoSubtonica: "υποτονική",

        // AnalisisArmonico.swift
        funcionTonica: "τονική",
        funcionSubdominante: "υποδεσπόζουσα",
        funcionDominante: "δεσπόζουσα",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "συγχορδίες \(pasos)" },
        cadenciaAutentica: "αυθεντική πτώση",
        cadenciaPlagal: "πλάγια πτώση",
        cadenciaRota: "απατηλή πτώση",
        semicadencia: "ατελής πτώση",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "Από \(de) σε \(a) στη συγχορδία \(n)" },
        pivote: "κοινή συγχορδία",
        directa: " (άμεση)"
    )
}
