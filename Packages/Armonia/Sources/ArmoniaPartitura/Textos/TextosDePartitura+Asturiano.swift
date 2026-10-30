// Los textos de ArmoniaPartitura en asturiano. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let asturiano = TextosDePartitura(
        // Contrapunto+Idiomas.swift
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

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baxu",

        // Importacion.swift
        formatoDesconocido: "El ficheru nun ye MIDI nin MusicXML.",
        musicXMLComprimido: "Ye MusicXML comprimíu (.mxl), que entá nun se llee: espórtalu ensin comprimir (.musicxml).",
        midiDanado: "El ficheru MIDI ta estropiáu o cortáu.",
        midiConTiempoSMPTE: "El ficheru MIDI cuenta'l tiempu en fotogrames SMPTE, non en pulsos por negra.",
        xmlDanado: { linea in "El ficheru MusicXML ta estropiáu (llinia \(linea))." },
        noEsMusicXMLPorPartes: "El XML nun ye una partitura MusicXML per partes (score-partwise).",
        sinNotas: "El ficheru nun tien nenguna nota.",
        sinAcordes: "Nel ficheru nun suena nengún acorde.",

        // Duracion+Idiomas.swift
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

        // Pentagrama+Idiomas.swift
        claveDeSol: "clave de sol",
        claveDeSolOctavaBaja: "clave de sol octava baxa",
        claveDeSolOctavaAlta: "clave de sol octava alta",
        claveDeFa: "clave de fa",
        claveDeFaEnTercera: "clave de fa en tercera",
        claveDeDoEnPrimera: "clave de do en primera",
        claveDeDoEnSegunda: "clave de do en segunda",
        claveDeDoEnTercera: "clave de do en tercera",
        claveDeDoEnCuarta: "clave de do en cuarta"
    )
}
