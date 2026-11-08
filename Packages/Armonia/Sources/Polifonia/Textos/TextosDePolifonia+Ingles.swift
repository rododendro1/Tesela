// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en inglés. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let ingles = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "between " + nombres.joined(separator: " and ") },
        enLaVoz: { primera in "in the \(primera)" },
        enLosAcordes: "(chords {1})",
        enElAcorde: { acorde in "(chord \(acorde + 1))" },
        quintasParalelas: "Parallel fifths",
        octavasParalelas: "Parallel octaves",
        quintasDirectas: "Direct fifths",
        octavasDirectas: "Direct octaves",
        cruceDeVoces: "Voice crossing",
        superposicion: "Voice overlap",
        separacionExcesiva: "More than an octave",
        saltoNoMelodico: "Unmelodic leap",
        fueraDeTesitura: "Out of range",
        vozBajo: "bass",
        vozTenor: "tenor",
        vozContralto: "alto",
        vozSoprano: "soprano",
        vozNumero: "voice {1}",

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["passing tone", "neighbor tone", "appoggiatura", "suspension", "anticipation", "escape tone", "pedal tone", "free tone"],

        // Contrapunto.swift
        enElCompas: "(bar {1})",
        enLosCompases: "(bars {1})",
        ritmoDeLaEspecie: "Rhythm outside the species",
        comienzoImperfecto: "Opening without a perfect consonance",
        finalImperfecto: "Ending without unison or octave",
        finalSinGradoConjunto: "Ending not approached by step",
        disonanciaEnParteFuerte: "Dissonance on the downbeat",
        disonanciaMalTratada: "Mishandled dissonance",
        retardoMalResuelto: "Badly resolved suspension",
        unisono: "Unison in the middle",
        saltoSinCompensar: "Uncompensated leap",
        notaRepetida: "Repeated note",
        especieConElContrapuntoEncima: "Species {1}, counterpoint above the cantus firmus",
        especieConElContrapuntoDebajo: "Species {1}, counterpoint below the cantus firmus",
        contrapuntoAVariasVoces: "Counterpoint in {1} parts",
        vozDelContrapunto: "voice {1}",
        sinFaltas: "No faults."
    )
}
