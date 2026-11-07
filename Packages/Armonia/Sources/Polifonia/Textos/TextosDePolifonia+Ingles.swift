// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Polifonia en inglés. Los campos y lo que significa cada uno están en
// `TextosDePolifonia.swift`.

extension TextosDePolifonia {
    static let ingles = TextosDePolifonia(
        // Coral.swift
        entreLasVoces: { nombres in "between " + nombres.joined(separator: " and ") },
        enLaVoz: { primera in "in the \(primera)" },
        enLosAcordes: { pasos in "(chords \(pasos))" },
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
        vozNumero: { numero in "voice \(numero)" },

        // NotaExtrana.swift
        nombresDeNotasExtranas: ["passing tone", "neighbor tone", "appoggiatura", "suspension", "anticipation", "escape tone", "pedal tone", "free tone"],

        // Contrapunto.swift
        enElCompas: { n in "(bar \(n))" },
        enLosCompases: { pasos in "(bars \(pasos))" },
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
        especieConElContrapuntoEncima: { n in "Species \(n), counterpoint above the cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Species \(n), counterpoint below the cantus firmus" },
        contrapuntoAVariasVoces: { n in "Counterpoint in \(n) parts" },
        vozDelContrapunto: { n in "voice \(n)" },
        sinFaltas: "No faults."
    )
}
