// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en griego. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let griego = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), με μπάσο το \(bajo)" },
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
        directa: " (άμεση)",
        // Arpegio.swift
        arpegioDe: { acorde in "Αρπέζ \(acorde)" },
        patronAscendente: "ανιούσα",
        patronDescendente: "κατιούσα",
        patronIdaYVuelta: "πάνω-κάτω",
        patronAlberti: "μπάσο Alberti",
        patronQuebrado: "σπαστό",
        patronBajaYSube: "κάτω-πάνω",
        // Rearmonizacion.swift
        sustitutoTritonal: "τριτονική υποκατάσταση",
        dominanteSecundaria: "δευτερεύουσα δεσπόζουσα",
        prestamoModal: "τροπικός δανεισμός",
        sustitutoDiatonico: "διατονική υποκατάσταση",
        // ErrorDeLecturaDeTeoria.swift (acordes)
        simboloNoReconocido: { simbolo in "το «\(simbolo)» δεν ανήκει σε κανένα γνωστό σύμβολο συγχορδίας" },
        tensionNoValida: { tension in "το «\(tension)» δεν είναι έγκυρη τάση (τα ♭/♯ μπαίνουν με 5, 9, 11 και 13, και το add με 2, 4, 6, 9, 11 και 13)" },
        numeroDeAcordeNoValido: { numero in "το «\(numero)» δεν είναι αριθμός συγχορδίας (5, 6, 7, 9, 11 ή 13)" },
        numeroRepetido: { numero in "το «\(numero)» έρχεται μετά από άλλον αριθμό· οι πρόσθετες τάσεις μπαίνουν σε παρένθεση, όπως στο 7(9)" },
        disminuidoYSemidisminuido: "το ελαττωμένο (°) και το ημιελαττωμένο (ø) δεν συνδυάζονται",
        quintaConCalidad: "η συγχορδία πέμπτης (5) δεν έχει τρίτη, οπότε δεν δέχεται m, °, ø ή +",
        fundamentalNoOmitible: "η θεμέλια δεν μπορεί να παραλειφθεί",
        gradoNoOmitible: { grado in "το «omit\(grado)» δεν είναι έγκυρο (παραλείπονται μόνο τα 3, 5, 7, 9, 11 και 13)" },
        faltaLaFundamental: "λείπει η θεμέλια",
        intervaloSinPapel: { intervalo, notacion in "η \(intervalo.nombre(en: .griegoPalabras)) δεν έχει ρόλο σε συγχορδία κατά τρίτες" },
        terceraMayorYMenor: "έχει ταυτόχρονα μεγάλη και μικρή τρίτη (η ♯9 γράφεται ως αυξημένη ένατη, όχι ως μικρή τρίτη)",
        variasSeptimas: "έχει περισσότερες από μία έβδομες",
        septimaDisminuidaFueraDelDisminuido: "η ελαττωμένη έβδομη εμφανίζεται μόνο στην ελαττωμένη συγχορδία (με μικρή τρίτη και ελαττωμένη πέμπτη)",
        noEsPorTerceras: "δεν είναι συγχορδία κατά τρίτες",
        bajoNoValido: { bajo in "το «\(bajo)» δεν είναι όνομα νότας για το μπάσο" },
        idiomasMezclados: { nombre in "το «\(nombre)» είναι γραμμένο σε άλλη γλώσσα από τη θεμέλια: γράψ' τα όλα με συλλαβές (Sol7/Si) ή όλα με γράμματα (G7/B)" },
        // ErrorDeLecturaDeTeoria.swift (escalas)
        modoNoReconocido: { nombre in "το «\(nombre)» δεν είναι τρόπος τονικότητας: μια τονικότητα είναι μείζονα ή ελάσσονα (για τους άλλους τρόπους, χρησιμοποίησε Escala)" },
        faltaElTipoDeEscala: "λείπει το είδος της κλίμακας (μείζονα, δώριος, αρμονική ελάσσονα…)",
        tipoDeEscalaNoReconocido: { nombre in "το «\(nombre)» δεν είναι γνωστό είδος κλίμακας" },
        // ErrorDeLecturaDeTeoria.swift (coral)
        vocesDistintas: "όλες οι συγχορδίες πρέπει να έχουν τον ίδιο αριθμό φωνών, και τουλάχιστον δύο",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(tipo) στο \(raiz)" },
        enLaTonalidad: { tonalidad in "σε " + tonalidad }
    )
}
