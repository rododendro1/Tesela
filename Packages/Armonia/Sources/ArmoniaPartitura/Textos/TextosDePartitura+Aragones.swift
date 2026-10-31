// Los textos de ArmoniaPartitura en aragonés. Los campos y lo que significa cada uno están en
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

        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O fichero no ye MIDI ni MusicXML.",
        musicXMLComprimido: "O MusicXML comprimiu (.mxl) ye malmeso u no se puede leyer: exporta-lo sin comprimir (.musicxml).",
        midiDanado: "O fichero MIDI ye malmeso u cortau.",
        midiConTiempoSMPTE: "O fichero MIDI cuenta o tiempo en fotogramas SMPTE, no en pulsos per negra.",
        xmlDanado: { linea in "O fichero MusicXML ye malmeso (linia \(linea))." },
        noEsMusicXMLPorPartes: "O XML no ye una partitura MusicXML per partes (score-partwise).",
        sinNotas: "O fichero no tiene garra nota.",
        sinAcordes: "En o fichero no suena garra acorde.",

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
        claveDeDoEnCuarta: "clau de do en cuarta"
    )
}
