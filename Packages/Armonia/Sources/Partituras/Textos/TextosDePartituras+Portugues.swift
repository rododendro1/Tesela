// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en portugués. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let portugues = TextosDePartituras(
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
        fraccionDeRedonda: "{1} de semibreve",
        conPuntillos: ["{1} pontuada", "{1} duplamente pontuada", "{1} triplamente pontuada", "{1} quadruplamente pontuada"],

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
        duracionNoValida: "«{1}» não é uma duração: esperava-se uma figura (1, 2, 4, 8, 16…, pontuada: 4.) ou uma fração de semibreve (3/8, 1/12)",
        compasNoValido: "«{1}» não é um compasso: esperava-se numerador/denominador com o denominador potência de 2 (4/4, 6/8, 7/8), C ou ¢",
        contrapuntoDeOtraDuracion: "o contraponto tem de durar o mesmo que o cantus firmus: {1} semibreves, uma por nota"
    )
}
