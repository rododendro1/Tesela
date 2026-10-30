// Los textos de ArmoniaPartitura en inglés. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let ingles = TextosDePartitura(
        // Contrapunto+Idiomas.swift
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
        sinFaltas: "No faults.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "chords",
        pistaDelBajo: "bass",

        // Duracion+Idiomas.swift
        cuadrada: "double whole note",
        redonda: "whole note",
        blanca: "half note",
        negra: "quarter note",
        corchea: "eighth note",
        semicorchea: "sixteenth note",
        fusa: "thirty-second note",
        semifusa: "sixty-fourth note",
        garrapatea: "hundred twenty-eighth note",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) of a whole note" },
        conPuntillos: ["dotted _", "double-dotted _", "triple-dotted _", "quadruple-dotted _"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "treble clef",
        claveDeSolOctavaBaja: "treble clef 8vb",
        claveDeSolOctavaAlta: "treble clef 8va",
        claveDeFa: "bass clef",
        claveDeFaEnTercera: "baritone clef",
        claveDeDoEnPrimera: "soprano clef",
        claveDeDoEnSegunda: "mezzo-soprano clef",
        claveDeDoEnTercera: "alto clef",
        claveDeDoEnCuarta: "tenor clef"
    )
}
