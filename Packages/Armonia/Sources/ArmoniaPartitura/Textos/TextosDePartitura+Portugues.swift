// Los textos de ArmoniaPartitura en portugués. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let portugues = TextosDePartitura(
        // Contrapunto+Idiomas.swift
        enElCompas: { n in "(compasso \(n))" },
        enLosCompases: { pasos in "(compassos \(pasos))" },
        ritmoDeLaEspecie: "Ritmo alheio à espécie",
        comienzoImperfecto: "Início sem consonância perfeita",
        finalImperfecto: "Final sem uníssono nem oitava",
        finalSinGradoConjunto: "Final sem grau conjunto",
        disonanciaEnParteFuerte: "Dissonância em tempo forte",
        disonanciaMalTratada: "Dissonância mal tratada",
        retardoMalResuelto: "Retardo mal resolvido",
        unisono: "Uníssono no meio do exercício",
        saltoSinCompensar: "Salto sem compensação",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Espécie \(n), com o contraponto acima do cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espécie \(n), com o contraponto abaixo do cantus firmus" },
        sinFaltas: "Sem erros.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Duracion+Idiomas.swift
        cuadrada: "breve",
        redonda: "semibreve",
        blanca: "mínima",
        negra: "semínima",
        corchea: "colcheia",
        semicorchea: "semicolcheia",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "quartifusa",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de semibreve" },
        conPuntillos: ["_ pontuada", "_ duplamente pontuada", "_ triplamente pontuada", "_ quadruplamente pontuada"],

        // Pentagrama+Idiomas.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol oitava abaixo",
        claveDeSolOctavaAlta: "clave de sol oitava acima",
        claveDeFa: "clave de fá",
        claveDeFaEnTercera: "clave de fá na terceira linha",
        claveDeDoEnPrimera: "clave de dó na primeira linha",
        claveDeDoEnSegunda: "clave de dó na segunda linha",
        claveDeDoEnTercera: "clave de dó na terceira linha",
        claveDeDoEnCuarta: "clave de dó na quarta linha"
    )
}
