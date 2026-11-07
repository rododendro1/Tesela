// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en asturiano. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let asturiano = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmu ayenu a la especie",
        comienzoImperfecto: "Entamu ensin consonancia perfeuta",
        finalImperfecto: "Final ensin unísonu nin octava",
        finalSinGradoConjunto: "Final ensin grau conxuntu",
        disonanciaEnParteFuerte: "Disonancia en parte fuerte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardu mal resueltu",
        unisono: "Unísonu en metá del exerciciu",
        saltoSinCompensar: "Saltu ensin compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), col contrapuntu enriba del cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), col contrapuntu embaxo del cantus firmus" },
        sinFaltas: "Ensin faltes.",

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
        cero: "cero",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ con puntiellu", "_ con doble puntiellu", "_ con triple puntiellu", "_ con cuádruple puntiellu"],

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol octava baxa",
        claveDeSolOctavaAlta: "clave de sol octava alta",
        claveDeFa: "clave de fa",
        claveDeFaEnTercera: "clave de fa en tercera",
        claveDeDoEnPrimera: "clave de do en primera",
        claveDeDoEnSegunda: "clave de do en segunda",
        claveDeDoEnTercera: "clave de do en tercera",
        claveDeDoEnCuarta: "clave de do en cuarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "pianu",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "flautín",
        instrumentoFlautaEnSol: "flauta en sol",
        instrumentoOboe: "oboe",
        instrumentoCornoIngles: "cornu inglés",
        instrumentoClarineteEnSib: "clarinete en si♭",
        instrumentoClarineteEnLa: "clarinete en la",
        instrumentoClarineteEnMib: "clarinete en mi♭",
        instrumentoClarineteBajo: "clarinete baxu",
        instrumentoFagot: "fagot",
        instrumentoSaxofonSoprano: "saxofón soprano",
        instrumentoSaxofonAlto: "saxofón altu",
        instrumentoSaxofonTenor: "saxofón tenor",
        instrumentoSaxofonBaritono: "saxofón barítonu",
        instrumentoTrompetaEnSib: "trompeta en si♭",
        instrumentoTrompetaEnDo: "trompeta en do",
        instrumentoFliscorno: "fliscornu",
        instrumentoTrompaEnFa: "trompa en fa",
        instrumentoTrombon: "trombón",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violín",
        instrumentoViola: "viola",
        instrumentoViolonchelo: "violonchelu",
        instrumentoContrabajo: "contrabaxu",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "baxu llétricu",
        instrumentoXilofono: "xilófonu",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta",
        // ErrorDeLecturaDePartitura.swift
        duracionNoValida: { texto in "«\(texto)» nun ye una duración: esperábase una figura (1, 2, 4, 8, 16…, con puntiellos: 4.) o una fraición de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» nun ye un compás: esperábase numerador/denominador col denominador potencia de 2 (4/4, 6/8, 7/8), C o ¢" },
        contrapuntoDeOtraDuracion: { redondas in "el contrapuntu tien que durar lo mesmo que\'l cantus firmus: \(redondas) redondes, una por nota" }
    )
}
