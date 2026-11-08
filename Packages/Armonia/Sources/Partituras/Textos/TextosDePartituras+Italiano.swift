// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en italiano. Los campos y lo que significa cada uno están en
// `TextosDePartituras.swift`.

extension TextosDePartituras {
    static let italiano = TextosDePartituras(
        // Duracion.swift
        cuadrada: "breve",
        redonda: "semibreve",
        blanca: "minima",
        negra: "semiminima",
        corchea: "croma",
        semicorchea: "semicroma",
        fusa: "biscroma",
        semifusa: "semibiscroma",
        garrapatea: "fusa",
        cero: "zero",
        fraccionDeRedonda: "{1} di semibreve",
        conPuntillos: ["{1} puntata", "{1} doppiamente puntata", "{1} triplamente puntata", "{1} quadruplamente puntata"],

        // Pentagrama.swift
        claveDeSol: "chiave di violino",
        claveDeSolOctavaBaja: "chiave di violino ottava bassa",
        claveDeSolOctavaAlta: "chiave di violino ottava alta",
        claveDeFa: "chiave di basso",
        claveDeFaEnTercera: "chiave di baritono",
        claveDeDoEnPrimera: "chiave di soprano",
        claveDeDoEnSegunda: "chiave di mezzosoprano",
        claveDeDoEnTercera: "chiave di contralto",
        claveDeDoEnCuarta: "chiave di tenore",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "pianoforte",
        instrumentoFlauta: "flauto",
        instrumentoFlautin: "ottavino",
        instrumentoFlautaEnSol: "flauto contralto",
        instrumentoOboe: "oboe",
        instrumentoCornoIngles: "corno inglese",
        instrumentoClarineteEnSib: "clarinetto in si♭",
        instrumentoClarineteEnLa: "clarinetto in la",
        instrumentoClarineteEnMib: "clarinetto in mi♭",
        instrumentoClarineteBajo: "clarinetto basso",
        instrumentoFagot: "fagotto",
        instrumentoSaxofonSoprano: "sassofono soprano",
        instrumentoSaxofonAlto: "sassofono contralto",
        instrumentoSaxofonTenor: "sassofono tenore",
        instrumentoSaxofonBaritono: "sassofono baritono",
        instrumentoTrompetaEnSib: "tromba in si♭",
        instrumentoTrompetaEnDo: "tromba in do",
        instrumentoFliscorno: "flicorno",
        instrumentoTrompaEnFa: "corno in fa",
        instrumentoTrombon: "trombone",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violino",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "violoncello",
        instrumentoContrabajo: "contrabbasso",
        instrumentoGuitarra: "chitarra",
        instrumentoBajoElectrico: "basso elettrico",
        instrumentoXilofono: "xilofono",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: "«{1}» non è una durata: si aspettava una figura (1, 2, 4, 8, 16…, puntata: 4.) o una frazione di semibreve (3/8, 1/12)",
        compasNoValido: "«{1}» non è un tempo: si aspettava numeratore/denominatore con il denominatore potenza di 2 (4/4, 6/8, 7/8), C o ¢",
        contrapuntoDeOtraDuracion: "il contrappunto deve durare quanto il cantus firmus: {1} semibrevi, una per nota"
    )
}
