// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en español. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let espanol = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(compás \(n))" },
        enLosCompases: { pasos in "(compases \(pasos))" },
        ritmoDeLaEspecie: "Ritmo ajeno a la especie",
        comienzoImperfecto: "Comienzo sin consonancia perfecta",
        finalImperfecto: "Final sin unísono ni octava",
        finalSinGradoConjunto: "Final sin grado conjunto",
        disonanciaEnParteFuerte: "Disonancia en parte fuerte",
        disonanciaMalTratada: "Disonancia mal tratada",
        retardoMalResuelto: "Retardo mal resuelto",
        unisono: "Unísono en mitad del ejercicio",
        saltoSinCompensar: "Salto sin compensar",
        notaRepetida: "Nota repetida",
        especieConElContrapuntoEncima: { n in "Especie \(n), con el contrapunto encima del cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Especie \(n), con el contrapunto debajo del cantus firmus" },
        sinFaltas: "Sin faltas.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "bajo",

        // Importacion.swift
        formatoDesconocido: "El fichero no es MIDI ni MusicXML.",
        musicXMLComprimido: "El MusicXML comprimido (.mxl) está dañado o no se puede leer: expórtalo sin comprimir (.musicxml).",
        midiDanado: "El fichero MIDI está dañado o cortado.",
        midiConTiempoSMPTE: "El fichero MIDI cuenta el tiempo en fotogramas SMPTE, no en pulsos por negra.",
        xmlDanado: { linea in "El fichero MusicXML está dañado (línea \(linea))." },
        noEsMusicXMLPorPartes: "El XML no es una partitura MusicXML por partes (score-partwise).",
        sinNotas: "El fichero no tiene ninguna nota.",
        sinAcordes: "En el fichero no suena ningún acorde.",

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
        conPuntillos: ["_ con puntillo", "_ con doble puntillo", "_ con triple puntillo", "_ con cuádruple puntillo"],

        // Pentagrama.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol octava baja",
        claveDeSolOctavaAlta: "clave de sol octava alta",
        claveDeFa: "clave de fa",
        claveDeFaEnTercera: "clave de fa en tercera",
        claveDeDoEnPrimera: "clave de do en primera",
        claveDeDoEnSegunda: "clave de do en segunda",
        claveDeDoEnTercera: "clave de do en tercera",
        claveDeDoEnCuarta: "clave de do en cuarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: false,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "flautín",
        instrumentoFlautaEnSol: "flauta en sol",
        instrumentoOboe: "oboe",
        instrumentoCornoIngles: "corno inglés",
        instrumentoClarineteEnSib: "clarinete en si♭",
        instrumentoClarineteEnLa: "clarinete en la",
        instrumentoClarineteEnMib: "clarinete en mi♭",
        instrumentoClarineteBajo: "clarinete bajo",
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
        instrumentoContrabajo: "contrabajo",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "bajo eléctrico",
        instrumentoXilofono: "xilófono",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celesta"
    )
}
