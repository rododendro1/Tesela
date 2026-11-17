// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en francés. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let frances = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "entre " + nombres.joined(separator: " et ") },
        enLaVoz: { primera in "(\(primera))" },
        enLosAcordes: "(accords {1})",
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
        vozNumero: "voix {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["note de passage", "broderie", "appoggiature", "retard", "anticipation", "échappée", "pédale", "note libre"],

        // Contrapunto.swift
        enElCompas: "(mesure {1})",
        enLosCompases: "(mesures {1})",
        ritmoDeLaEspecie: "Rythme étranger à l'espèce",
        comienzoImperfecto: "Début sans consonance parfaite",
        finalImperfecto: "Fin sans unisson ni octave",
        finalSinGradoConjunto: "Fin non atteinte par degré conjoint",
        disonanciaEnParteFuerte: "Dissonance sur le temps fort",
        disonanciaMalTratada: "Dissonance mal traitée",
        retardoMalResuelto: "Retard mal résolu",
        unisono: "Unisson au milieu de l'exercice",
        saltoSinCompensar: "Saut non compensé",
        notaRepetida: "Note répétée",
        especieConElContrapuntoEncima: "Espèce {1}, contrepoint au-dessus du cantus firmus",
        especieConElContrapuntoDebajo: "Espèce {1}, contrepoint au-dessous du cantus firmus",
        contrapuntoAVariasVoces: "Contrepoint à {1} voix",
        vozDelContrapunto: "voix {1}",
        sinFaltas: "Aucune faute.",
        realizacionSinNotas: "Il n’y a ni accords ni notes à écrire.",
        realizacionSopranoDeOtraLongitud: "Le soprano doit avoir une note par accord (notes : {1} ; accords : {2}).",
        realizacionNotaAjena: "La note du soprano n’appartient pas à l’accord {1}.",
        realizacionSopranoFueraDeTesitura: "La note du soprano de l’accord {1} est hors de sa tessiture.",
        realizacionDemasiadasNotas: "L’accord {1} a plus de quatre notes qui ne peuvent pas manquer.",
        realizacionSinDisposicion: "L’accord {1} ne peut pas s’écrire à quatre voix sans fautes.",
        realizacionNotaSinAcorde: "Aucun accord de la tonalité ne contient la note {1} de la mélodie.",
        realizacionSinEnlaceSinFaltas: "Les accords ne peuvent pas s’enchaîner à quatre voix sans fautes.",
        realizacionOtraMelodia: "Le soprano n’est pas la mélodie de l’harmonisation."
    )
}
