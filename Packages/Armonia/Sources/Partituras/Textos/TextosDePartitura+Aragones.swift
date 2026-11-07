// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en aragonés. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let aragones = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmo difuera d\'a especie",
        comienzoImperfecto: "Empecipio sin consonancia perfecta",
        finalImperfecto: "Final sin unísono ni octava",
        finalSinGradoConjunto: "Final sin grau conchunto",
        disonanciaEnParteFuerte: "Disonancia en parte fuerte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardo mal resuelto",
        unisono: "Unísono en meyo d\'o exercicio",
        saltoSinCompensar: "Salto sin compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), con o contrapunto encima d\'o cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), con o contrapunto debaixo d\'o cantus firmus" },
        sinFaltas: "Sin faltas.",

        // Duracion.swift
        cuadrada: "cuadrada",
        redonda: "redonda",
        blanca: "blanca",
        negra: "negra",
        corchea: "corchea",
        semicorchea: "semicorchea",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ con puntet", "_ con doble puntet", "_ con triple puntet", "_ con cuadruple puntet"],

        // Pentagrama.swift
        claveDeSol: "clau de sol",
        claveDeSolOctavaBaja: "clau de sol octava baixa",
        claveDeSolOctavaAlta: "clau de sol octava alta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tercera",
        claveDeDoEnPrimera: "clau de do en primera",
        claveDeDoEnSegunda: "clau de do en segunda",
        claveDeDoEnTercera: "clau de do en tercera",
        claveDeDoEnCuarta: "clau de do en cuarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "flautín",
        instrumentoFlautaEnSol: "flauta en sol",
        instrumentoOboe: "oboe",
        instrumentoCornoIngles: "corno anglés",
        instrumentoClarineteEnSib: "clarinet en si♭",
        instrumentoClarineteEnLa: "clarinet en la",
        instrumentoClarineteEnMib: "clarinet en mi♭",
        instrumentoClarineteBajo: "clarinet baixo",
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
        instrumentoBajoElectrico: "baixo electrico",
        instrumentoXilofono: "xilófono",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» no ye una duración: s\'asperaba una figura (1, 2, 4, 8, 16…, con puntillos: 4.) u una fracción de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» no ye un compás: s\'asperaba numerador/denominador con o denominador potencia de 2 (4/4, 6/8, 7/8), C u ¢" },
        contrapuntoDeOtraDuracion: { redondas in "o contrapunto ha de durar o mesmo que o cantus firmus: \(redondas) redondas, una por nota" }
    )
}
