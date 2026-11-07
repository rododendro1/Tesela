// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en portugués. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let portugues = TextosDePartituras(
        // Contrapunto.swift
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

        // Duracion.swift
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

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol oitava abaixo",
        claveDeSolOctavaAlta: "clave de sol oitava acima",
        claveDeFa: "clave de fá",
        claveDeFaEnTercera: "clave de fá na terceira linha",
        claveDeDoEnPrimera: "clave de dó na primeira linha",
        claveDeDoEnSegunda: "clave de dó na segunda linha",
        claveDeDoEnTercera: "clave de dó na terceira linha",
        claveDeDoEnCuarta: "clave de dó na quarta linha",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "flautim",
        instrumentoFlautaEnSol: "flauta em sol",
        instrumentoOboe: "oboé",
        instrumentoCornoIngles: "corne-inglês",
        instrumentoClarineteEnSib: "clarinete em si♭",
        instrumentoClarineteEnLa: "clarinete em lá",
        instrumentoClarineteEnMib: "clarinete em mi♭",
        instrumentoClarineteBajo: "clarinete baixo",
        instrumentoFagot: "fagote",
        instrumentoSaxofonSoprano: "saxofone soprano",
        instrumentoSaxofonAlto: "saxofone alto",
        instrumentoSaxofonTenor: "saxofone tenor",
        instrumentoSaxofonBaritono: "saxofone barítono",
        instrumentoTrompetaEnSib: "trompete em si♭",
        instrumentoTrompetaEnDo: "trompete em dó",
        instrumentoFliscorno: "fliscórnio",
        instrumentoTrompaEnFa: "trompa em fá",
        instrumentoTrombon: "trombone",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violino",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "violoncelo",
        instrumentoContrabajo: "contrabaixo",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "baixo elétrico",
        instrumentoXilofono: "xilofone",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» não é uma duração: esperava-se uma figura (1, 2, 4, 8, 16…, pontuada: 4.) ou uma fração de semibreve (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» não é um compasso: esperava-se numerador/denominador com o denominador potência de 2 (4/4, 6/8, 7/8), C ou ¢" },
        contrapuntoDeOtraDuracion: { redondas in "o contraponto tem de durar o mesmo que o cantus firmus: \(redondas) semibreves, uma por nota" }
    )
}
