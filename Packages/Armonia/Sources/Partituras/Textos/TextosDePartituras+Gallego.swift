// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en gallego. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let gallego = TextosDePartituras(
        // Duracion.swift
        cuadrada: "cadrada",
        redonda: "redonda",
        blanca: "branca",
        negra: "negra",
        corchea: "corchea",
        semicorchea: "semicorchea",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "cero",
        fraccionDeRedonda: "{1} de redonda",
        conPuntillos: ["{1} con puntiño", "{1} con dobre puntiño", "{1} con triplo puntiño", "{1} con cuádruplo puntiño"],

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol oitava baixa",
        claveDeSolOctavaAlta: "clave de sol oitava alta",
        claveDeFa: "clave de fa",
        claveDeFaEnTercera: "clave de fa en terceira",
        claveDeDoEnPrimera: "clave de do en primeira",
        claveDeDoEnSegunda: "clave de do en segunda",
        claveDeDoEnTercera: "clave de do en terceira",
        claveDeDoEnCuarta: "clave de do en cuarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "frauta",
        instrumentoFlautin: "frautín",
        instrumentoFlautaEnSol: "frauta en sol",
        instrumentoOboe: "óboe",
        instrumentoCornoIngles: "corno inglés",
        instrumentoClarineteEnSib: "clarinete en si♭",
        instrumentoClarineteEnLa: "clarinete en la",
        instrumentoClarineteEnMib: "clarinete en mi♭",
        instrumentoClarineteBajo: "clarinete baixo",
        instrumentoFagot: "fagot",
        instrumentoSaxofonSoprano: "saxofón soprano",
        instrumentoSaxofonAlto: "saxofón alto",
        instrumentoSaxofonTenor: "saxofón tenor",
        instrumentoSaxofonBaritono: "saxofón barítono",
        instrumentoTrompetaEnSib: "trompeta en si♭",
        instrumentoTrompetaEnDo: "trompeta en do",
        instrumentoFliscorno: "fliscorno",
        instrumentoTrompaEnFa: "trompa en fa",
        instrumentoTrombon: "trombón",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violín",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "violonchelo",
        instrumentoContrabajo: "contrabaixo",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "baixo eléctrico",
        instrumentoXilofono: "xilófono",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "«{1}» non é unha duración: agardábase unha figura (1, 2, 4, 8, 16…, con puntiños: 4.) ou unha fracción de redonda (3/8, 1/12)",
        compasNoValido: "«{1}» non é un compás: agardábase numerador/denominador co denominador potencia de 2 (4/4, 6/8, 7/8), C ou ¢",
        contrapuntoDeOtraDuracion: "o contrapunto ten que durar o mesmo que o cantus firmus: {1} redondas, unha por nota"
    )
}
