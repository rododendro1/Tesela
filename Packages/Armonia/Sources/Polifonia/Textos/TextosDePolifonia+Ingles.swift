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
        disonanciaEnParteFuerte: "Dissonance on a strong beat",
        disonanciaMalTratada: "Mishandled dissonance",
        retardoMalResuelto: "Badly resolved suspension",
        unisono: "Unison in the middle",
        saltoSinCompensar: "Uncompensated leap",
        notaRepetida: "Repeated note",
        especieConElContrapuntoEncima: "Species {1}, counterpoint above the cantus firmus",
        especieConElContrapuntoDebajo: "Species {1}, counterpoint below the cantus firmus",
        contrapuntoAVariasVoces: "Counterpoint in {1} parts",
        vozDelContrapunto: "voice {1}",
        sinFaltas: "No faults.",
        realizacionSinNotas: "There are no chords or notes to write.",
        realizacionSopranoDeOtraLongitud: "The soprano must have one note per chord (notes: {1}; chords: {2}).",
        realizacionNotaAjena: "The soprano note is not in chord {1}.",
        realizacionSopranoFueraDeTesitura: "The soprano note of chord {1} is out of its range.",
        realizacionDemasiadasNotas: "Chord {1} has more than four notes that cannot be left out.",
        realizacionSinDisposicion: "Chord {1} cannot be written in four parts without errors.",
        realizacionNotaSinAcorde: "No chord in the key contains note {1} of the melody.",
        realizacionSinEnlaceSinFaltas: "The chords cannot be connected in four parts without errors.",
        realizacionOtraMelodia: "The soprano is not the melody of the harmonization."
    )
}
