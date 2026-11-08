// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en catalán. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let catalan = TextosDePartituras(
        // Duracion.swift
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
        fraccionDeRedonda: "{1} de rodona",
        conPuntillos: ["{1} amb punt", "{1} amb doble punt", "{1} amb triple punt", "{1} amb quàdruple punt"],

        // Pentagrama.swift
        claveDeSol: "clau de sol",
        claveDeSolOctavaBaja: "clau de sol octava baixa",
        claveDeSolOctavaAlta: "clau de sol octava alta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tercera",
        claveDeDoEnPrimera: "clau de do en primera",
        claveDeDoEnSegunda: "clau de do en segona",
        claveDeDoEnTercera: "clau de do en tercera",
        claveDeDoEnCuarta: "clau de do en quarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "flautí",
        instrumentoFlautaEnSol: "flauta en sol",
        instrumentoOboe: "oboè",
        instrumentoCornoIngles: "corn anglès",
        instrumentoClarineteEnSib: "clarinet en si♭",
        instrumentoClarineteEnLa: "clarinet en la",
        instrumentoClarineteEnMib: "clarinet en mi♭",
        instrumentoClarineteBajo: "clarinet baix",
        instrumentoFagot: "fagot",
        instrumentoSaxofonSoprano: "saxòfon soprano",
        instrumentoSaxofonAlto: "saxòfon alt",
        instrumentoSaxofonTenor: "saxòfon tenor",
        instrumentoSaxofonBaritono: "saxòfon baríton",
        instrumentoTrompetaEnSib: "trompeta en si♭",
        instrumentoTrompetaEnDo: "trompeta en do",
        instrumentoFliscorno: "fiscorn",
        instrumentoTrompaEnFa: "trompa en fa",
        instrumentoTrombon: "trombó",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violí",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "violoncel",
        instrumentoContrabajo: "contrabaix",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "baix elèctric",
        instrumentoXilofono: "xilòfon",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "«{1}» no és una durada: s'esperava una figura (1, 2, 4, 8, 16…, amb punts: 4.) o una fracció de rodona (3/8, 1/12)",
        compasNoValido: "«{1}» no és un compàs: s'esperava numerador/denominador amb el denominador potència de 2 (4/4, 6/8, 7/8), C o ¢",
        contrapuntoDeOtraDuracion: "el contrapunt ha de durar el mateix que el cantus firmus: {1} rodones, una per nota"
    )
}
