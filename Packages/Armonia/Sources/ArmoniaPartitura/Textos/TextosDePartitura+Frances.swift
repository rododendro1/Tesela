// Los textos de ArmoniaPartitura en francés. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let frances = TextosDePartitura(
        // Contrapunto+Idiomas.swift
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
        sinFaltas: "Aucune faute.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "accords",
        pistaDelBajo: "basse",

        // Duracion+Idiomas.swift
        cuadrada: "carrée",
        redonda: "ronde",
        blanca: "blanche",
        negra: "noire",
        corchea: "croche",
        semicorchea: "double croche",
        fusa: "triple croche",
        semifusa: "quadruple croche",
        garrapatea: "quintuple croche",
        cero: "zéro",
        fraccionDeRedonda: { fraccion in "\(fraccion) de ronde" },
        conPuntillos: ["_ pointée", "_ doublement pointée", "_ triplement pointée", "_ quadruplement pointée"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "clé de sol",
        claveDeSolOctavaBaja: "clé de sol octave basse",
        claveDeSolOctavaAlta: "clé de sol octave haute",
        claveDeFa: "clé de fa",
        claveDeFaEnTercera: "clé de fa troisième ligne",
        claveDeDoEnPrimera: "clé d'ut première ligne",
        claveDeDoEnSegunda: "clé d'ut deuxième ligne",
        claveDeDoEnTercera: "clé d'ut troisième ligne",
        claveDeDoEnCuarta: "clé d'ut quatrième ligne"
    )
}
