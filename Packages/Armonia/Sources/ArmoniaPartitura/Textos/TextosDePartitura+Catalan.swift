// Los textos de ArmoniaPartitura en catalán. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let catalan = TextosDePartitura(
        // Contrapunto+Idiomas.swift
        enElCompas: { n in "(compàs \(n))" },
        enLosCompases: { pasos in "(compassos \(pasos))" },
        ritmoDeLaEspecie: "Ritme aliè a l'espècie",
        comienzoImperfecto: "Inici sense consonància perfecta",
        finalImperfecto: "Final sense uníson ni octava",
        finalSinGradoConjunto: "Final sense grau conjunt",
        disonanciaEnParteFuerte: "Dissonància en part forta",
        disonanciaMalTratada: "Dissonància mal tractada",
        retardoMalResuelto: "Retard mal resolt",
        unisono: "Uníson al mig de l'exercici",
        saltoSinCompensar: "Salt sense compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Espècie \(n), amb el contrapunt damunt del cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espècie \(n), amb el contrapunt davall del cantus firmus" },
        sinFaltas: "Sense faltes.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acords",
        pistaDelBajo: "baix",

        // Duracion+Idiomas.swift
        cuadrada: "quadrada",
        redonda: "rodona",
        blanca: "blanca",
        negra: "negra",
        corchea: "corxera",
        semicorchea: "semicorxera",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de rodona" },
        conPuntillos: ["_ amb punt", "_ amb doble punt", "_ amb triple punt", "_ amb quàdruple punt"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "clau de sol",
        claveDeSolOctavaBaja: "clau de sol octava baixa",
        claveDeSolOctavaAlta: "clau de sol octava alta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tercera",
        claveDeDoEnPrimera: "clau de do en primera",
        claveDeDoEnSegunda: "clau de do en segona",
        claveDeDoEnTercera: "clau de do en tercera",
        claveDeDoEnCuarta: "clau de do en quarta"
    )
}
