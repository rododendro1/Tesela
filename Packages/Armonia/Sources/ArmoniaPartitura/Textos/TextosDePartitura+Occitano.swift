// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en occitano. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let occitano = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(mesura \(n))" },
        enLosCompases: { pasos in "(mesuras \(pasos))" },
        ritmoDeLaEspecie: "Ritme estrangièr a l'espècia",
        comienzoImperfecto: "Començament sens consonància perfiecha",
        finalImperfecto: "Final sens unisson ni octava",
        finalSinGradoConjunto: "Final sens gra conjunt",
        disonanciaEnParteFuerte: "Dissonància en temps fòrt",
        disonanciaMalTratada: "Dissonància mal tractada",
        retardoMalResuelto: "Retard mal resolgut",
        unisono: "Unisson al mitan de l'exercici",
        saltoSinCompensar: "Saut sens compensar",
        notaRepetida: "Nòta repetida",
        especieConElContrapuntoEncima: { n in "Espècia \(n), amb lo contrapunt dessús lo cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Espècia \(n), amb lo contrapunt dejós lo cantus firmus" },
        sinFaltas: "Sens fautas.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "acòrds",
        pistaDelBajo: "bassa",

        // Importacion.swift
        formatoDesconocido: "Lo fichièr es pas ni MIDI ni MusicXML.",
        musicXMLComprimido: "Lo MusicXML compressat (.mxl) es damatjat o se pòt pas legir : exportatz-lo sens compression (.musicxml).",
        midiDanado: "Lo fichièr MIDI es damatjat o copat.",
        midiConTiempoSMPTE: "Lo fichièr MIDI compta lo temps en imatges SMPTE, e non en tics per negra.",
        xmlDanado: { linea in "Lo fichièr MusicXML es damatjat (linha \(linea))." },
        noEsMusicXMLPorPartes: "Lo XML es pas una particion MusicXML per partidas (score-partwise).",
        sinNotas: "Lo fichièr a pas cap de nòta.",
        sinAcordes: "Dins lo fichièr sona pas cap d'acòrd.",

        // Duracion.swift
        cuadrada: "quadrada",
        redonda: "redonda",
        blanca: "blanca",
        negra: "negra",
        corchea: "crocha",
        semicorchea: "doble crocha",
        fusa: "tripla crocha",
        semifusa: "quadrupla crocha",
        garrapatea: "quintupla crocha",
        cero: "zèro",
        fraccionDeRedonda: { fraccion in "\(fraccion) de redonda" },
        conPuntillos: ["_ puntada", "_ doblament puntada", "_ triplament puntada", "_ quadruplament puntada"],

        // Pentagrama.swift
        claveDeSol: "clau de sòl",
        claveDeSolOctavaBaja: "clau de sòl octava bassa",
        claveDeSolOctavaAlta: "clau de sòl octava nauta",
        claveDeFa: "clau de fa",
        claveDeFaEnTercera: "clau de fa en tèrça",
        claveDeDoEnPrimera: "clau de do en primièra",
        claveDeDoEnSegunda: "clau de do en segonda",
        claveDeDoEnTercera: "clau de do en tèrça",
        claveDeDoEnCuarta: "clau de do en quarta",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "piano",
        instrumentoFlauta: "flaüta",
        instrumentoFlautin: "flautin",
        instrumentoFlautaEnSol: "flaüta en sòl",
        instrumentoOboe: "oboè",
        instrumentoCornoIngles: "còrn anglés",
        instrumentoClarineteEnSib: "clarinet en si♭",
        instrumentoClarineteEnLa: "clarinet en la",
        instrumentoClarineteEnMib: "clarinet en mi♭",
        instrumentoClarineteBajo: "clarinet bas",
        instrumentoFagot: "fagòt",
        instrumentoSaxofonSoprano: "saxofòn soprano",
        instrumentoSaxofonAlto: "saxofòn alt",
        instrumentoSaxofonTenor: "saxofòn tenor",
        instrumentoSaxofonBaritono: "saxofòn bariton",
        instrumentoTrompetaEnSib: "trompeta en si♭",
        instrumentoTrompetaEnDo: "trompeta en do",
        instrumentoFliscorno: "flicòrn",
        instrumentoTrompaEnFa: "còrn en fa",
        instrumentoTrombon: "trombòn",
        instrumentoTuba: "tuba",
        instrumentoViolin: "violon",
        instrumentoViola: "viòla",
        instrumentoViolonchelo: "violoncèl",
        instrumentoContrabajo: "contrabassa",
        instrumentoGuitarra: "guitarra",
        instrumentoBajoElectrico: "bassa electrica",
        instrumentoXilofono: "xilofòn",
        instrumentoGlockenspiel: "glockenspiel",
        instrumentoCelesta: "celèsta"
    )
}
