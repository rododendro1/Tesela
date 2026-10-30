// Los textos de ArmoniaPartitura en occitano. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let occitano = TextosDePartitura(
        // Contrapunto+Idiomas.swift
        enElCompas: { n in "(mesura \(n))" },
        enLosCompases: { pasos in "(mesuras \(pasos))" },
        ritmoDeLaEspecie: "Ritme estrangièr a l'espècia",
        comienzoImperfecto: "Començament sens consonància perfiecha",
        finalImperfecto: "Final sens unisson ni octava",
        finalSinGradoConjunto: "Final sens gra conjunt",
        disonanciaEnParteFuerte: "Dissonància en temps fòrt",
        disonanciaMalTratada: "Dissonància mal tractada",
        retardoMalResuelto: "Retard mal resolgut",
        unisono: "Unisson al mitan de l'exercici",
        saltoSinCompensar: "Saut sens compensar",
        notaRepetida: "Nòta repetida",
        especieConElContrapuntoEncima: { n in "Espècia \(n), amb lo contrapunt dessús lo cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espècia \(n), amb lo contrapunt dejós lo cantus firmus" },
        sinFaltas: "Sens fautas.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acòrds",
        pistaDelBajo: "bassa",

        // Duracion+Idiomas.swift
        cuadrada: "quadrada",
        redonda: "redonda",
        blanca: "blanca",
        negra: "negra",
        corchea: "crocha",
        semicorchea: "doble crocha",
        fusa: "tripla crocha",
        semifusa: "quadrupla crocha",
        garrapatea: "quintupla crocha",
        cero: "zèro",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ puntada", "_ doblament puntada", "_ triplament puntada", "_ quadruplament puntada"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "clau de sòl",
        claveDeSolOctavaBaja: "clau de sòl octava bassa",
        claveDeSolOctavaAlta: "clau de sòl octava nauta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tèrça",
        claveDeDoEnPrimera: "clau de do en primièra",
        claveDeDoEnSegunda: "clau de do en segonda",
        claveDeDoEnTercera: "clau de do en tèrça",
        claveDeDoEnCuarta: "clau de do en quarta"
    )
}
