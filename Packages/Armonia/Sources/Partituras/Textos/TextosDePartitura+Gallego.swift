// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Partituras en gallego. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let gallego = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmo alleo á especie",
        comienzoImperfecto: "Comezo sen consonancia perfecta",
        finalImperfecto: "Final sen unísono nin oitava",
        finalSinGradoConjunto: "Final sen grao conxunto",
        disonanciaEnParteFuerte: "Disonancia en parte forte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardo mal resolto",
        unisono: "Unísono no medio do exercicio",
        saltoSinCompensar: "Salto sen compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), co contrapunto enriba do cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), co contrapunto debaixo do cantus firmus" },
        sinFaltas: "Sen faltas.",

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
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ con puntiño", "_ con dobre puntiño", "_ con triplo puntiño", "_ con cuádruplo puntiño"],

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
        duracionNoValida: { texto in "«\(texto)» non é unha duración: agardábase unha figura (1, 2, 4, 8, 16…, con puntiños: 4.) ou unha fracción de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» non é un compás: agardábase numerador/denominador co denominador potencia de 2 (4/4, 6/8, 7/8), C ou ¢" },
        contrapuntoDeOtraDuracion: { redondas in "o contrapunto ten que durar o mesmo que o cantus firmus: \(redondas) redondas, unha por nota" }
    )
}
