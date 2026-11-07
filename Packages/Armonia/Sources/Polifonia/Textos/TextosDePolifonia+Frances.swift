// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en francés. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let frances = TextosDePolifonia(
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

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["note de passage", "broderie", "appoggiature", "retard", "anticipation", "échappée", "pédale", "note libre"],

        // Contrapunto.swift
        enElCompas: { n in "(mesure \(n))" },
        enLosCompases: { pasos in "(mesures \(pasos))" },
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
        especieConElContrapuntoEncima: { n in "Espèce \(n), contrepoint au-dessus du cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espèce \(n), contrepoint au-dessous du cantus firmus" },
        contrapuntoAVariasVoces: { n in "Contrepoint à \(n) voix" },
        vozDelContrapunto: { n in "voix \(n)" },
        sinFaltas: "Aucune faute."
    )
}
