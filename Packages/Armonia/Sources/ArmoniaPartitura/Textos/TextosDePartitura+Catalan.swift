// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en catalán. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let catalan = TextosDePartitura(
        // Contrapunto.swift
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
        fraccionDeRedonda: { fraccion in "\(fraccion) de rodona" },
        conPuntillos: ["_ amb punt", "_ amb doble punt", "_ amb triple punt", "_ amb quàdruple punt"],

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
        duracionNoValida: { texto in "«\(texto)» no és una durada: s'esperava una figura (1, 2, 4, 8, 16…, amb punts: 4.) o una fracció de rodona (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» no és un compàs: s'esperava numerador/denominador amb el denominador potència de 2 (4/4, 6/8, 7/8), C o ¢" },
        contrapuntoDeOtraDuracion: { redondas in "el contrapunt ha de durar el mateix que el cantus firmus: \(redondas) rodones, una per nota" },
        figuraSinDuracion: "la figura d'un arpegi ha de durar alguna cosa",
        duracionesPorAcorde: { acordes, duraciones in "cal una durada per acord: hi ha \(acordes) acords i \(duraciones) durades" },
        duracionNoPositiva: { n in "la durada de l'acord \(n) ha de ser positiva" }
    )
}
