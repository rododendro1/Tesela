// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaTeoria en francés. Los campos y lo que significa cada uno están en
// `TextosDeTeoria.swift`.

extension TextosDeTeoria {
    static let frances = TextosDeTeoria(
        // Acorde.swift
        conBajoEn: { acorde, bajo in "\(acorde), avec la basse en \(bajo)" },
        nombresDeLasInversiones: ["état fondamental", "premier renversement", "deuxième renversement", "troisième renversement",
                                  "quatrième renversement", "cinquième renversement", "sixième renversement"],
        inversionConNumero: "renversement _",

        // EstructuraDeAcorde.swift
        papelFundamental: "fondamentale",
        papelTercera: "tierce",
        papelSuspension: "suspension",
        papelQuinta: "quinte",
        papelSexta: "sixte",
        papelSeptima: "septième",
        papelNovena: "neuvième",
        papelUndecima: "onzième",
        papelDecimotercera: "treizième",
        papelTension: { n in "tension \(n)e" },
        triadaMayor: "majeure",
        triadaMenor: "mineure",
        triadaDisminuida: "diminuée",
        triadaAumentada: "augmentée",
        triadaSuspendida: "suspendue",
        triadaDeQuinta: "de quinte",
        triadaSinTercera: "sans tierce",

        // TipoDeAcorde.swift
        acordeDesconocido: { vacio, latino, propio in "accord \(vacio ? "majeur" : latino)" },
        tipoMayor: "majeur",
        tipoMenor: "mineur",
        tipoDisminuido: "diminué",
        tipoAumentado: "augmenté",
        tipoSuspendidoDeSegunda: "suspendu de seconde",
        tipoSuspendidoDeCuarta: "suspendu de quarte",
        tipoQuintaAcordeDePotencia: "quinte (accord de puissance)",
        tipoSeptimaDeDominante: "septième de dominante",
        tipoSeptimaMayor: "septième majeure",
        tipoMenorSeptima: "mineur septième",
        tipoSemidisminuido: "semi-diminué",
        tipoSeptimaDisminuida: "septième diminuée",
        tipoMenorConSeptimaMayor: "mineur septième majeure",
        tipoAumentadoConSeptimaMenor: "augmenté septième mineure",
        tipoAumentadoConSeptimaMayor: "augmenté septième majeure",
        tipoSeptimaSuspendida: "septième suspendue",
        tipoSexta: "sixte ajoutée",
        tipoMenorSexta: "mineur sixte",
        tipoSextaYNovena: "sixte et neuvième",
        tipoNovenaDeDominante: "neuvième de dominante",
        tipoNovenaMayor: "neuvième majeure",
        tipoMenorNovena: "mineur neuvième",
        tipoNovenaAnadida: "neuvième ajoutée",
        tipoUndecima: "onzième",
        tipoMenorUndecima: "mineur onzième",
        tipoDecimotercera: "treizième",
        tipoMenorDecimotercera: "mineur treizième",
        tipoSeptimaConNovenaMenor: "septième avec neuvième mineure",
        tipoSextaAumentadaItaliana: "sixte augmentée italienne",
        tipoSextaAumentadaFrancesa: "sixte augmentée française",
        tipoSextaAumentadaAlemana: "sixte augmentée allemande",

        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " et ") },
        enLaVoz: { primera in "(\(primera))" },
        enLosAcordes: { pasos in "(accords \(pasos))" },
        enElAcorde: { acorde in "(accord \(acorde + 1))" },
        quintasParalelas: "Quintes parallèles",
        octavasParalelas: "Octaves parallèles",
        quintasDirectas: "Quintes directes",
        octavasDirectas: "Octaves directes",
        cruceDeVoces: "Croisement de voix",
        superposicion: "Chevauchement",
        separacionExcesiva: "Plus d'une octave",
        saltoNoMelodico: "Saut non mélodique",
        fueraDeTesitura: "Hors tessiture",
        vozBajo: "basse",
        vozTenor: "ténor",
        vozContralto: "alto",
        vozSoprano: "soprano",
        vozNumero: { numero in "voix \(numero)" },

        // Escala.swift
        gradoTonica: "tonique",
        gradoSupertonica: "sus-tonique",
        gradoMediante: "médiante",
        gradoSubdominante: "sous-dominante",
        gradoDominante: "dominante",
        gradoSuperdominante: "sus-dominante",
        gradoSensible: "sensible",
        gradoSubtonica: "sous-tonique",

        // AnalisisArmonico.swift
        funcionTonica: "tonique",
        funcionSubdominante: "sous-dominante",
        funcionDominante: "dominante",

        // Cadencia.swift
        cadenciaEnLosAcordes: { pasos in "accords \(pasos)" },
        cadenciaAutentica: "cadence parfaite",
        cadenciaPlagal: "cadence plagale",
        cadenciaRota: "cadence rompue",
        semicadencia: "demi-cadence",

        // RecorridoTonal.swift
        deUnaTonalidadAOtra: { de, a, n in "De \(de) à \(a) à l'accord \(n)" },
        pivote: "pivot",
        directa: " (directe)",
        // Arpegio.swift
        arpegioDe: { acorde in "Arpège de \(acorde)" },
        patronAscendente: "ascendant",
        patronDescendente: "descendant",
        patronIdaYVuelta: "aller-retour",
        patronAlberti: "basse d'Alberti",
        patronQuebrado: "brisé",
        patronBajaYSube: "descente-montée",
        // Rearmonizacion.swift
        sustitutoTritonal: "substitution tritonique",
        dominanteSecundaria: "dominante secondaire",
        prestamoModal: "emprunt modal",
        sustitutoDiatonico: "substitution diatonique",
        // Gramática (Acorde.swift, Tonalidad.swift)
        acordeSobre: { tipo, raiz in "\(raiz) \(tipo)" },
        enLaTonalidad: { tonalidad in "en " + tonalidad }
    )
}
