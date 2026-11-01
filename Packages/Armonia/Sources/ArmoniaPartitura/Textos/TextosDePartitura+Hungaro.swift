// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en húngaro. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let hungaro = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(\(n). ütem)" },
        enLosCompases: { pasos in "(ütemek: \(pasos))" },
        ritmoDeLaEspecie: "A fajtától eltérő ritmus",
        comienzoImperfecto: "Kezdés tökéletes konszonancia nélkül",
        finalImperfecto: "Befejezés prím vagy oktáv nélkül",
        finalSinGradoConjunto: "A befejezést nem lépés vezeti be",
        disonanciaEnParteFuerte: "Disszonancia súlyos ütemrészen",
        disonanciaMalTratada: "Helytelenül kezelt disszonancia",
        retardoMalResuelto: "Rosszul feloldott késleltetés",
        unisono: "Prím a darab közepén",
        saltoSinCompensar: "Kiegyenlítetlen ugrás",
        notaRepetida: "Ismételt hang",
        especieConElContrapuntoEncima: { n in "\(n). fajta, ellenpont a cantus firmus fölött" },
        especieConElContrapuntoDebajo: { n in "\(n). fajta, ellenpont a cantus firmus alatt" },
        sinFaltas: "Nincs hiba.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "akkordok",
        pistaDelBajo: "basszus",

        // Importacion.swift
        formatoDesconocido: "A fájl nem MIDI és nem MusicXML.",
        musicXMLComprimido: "A tömörített MusicXML (.mxl) sérült vagy nem olvasható: exportáld tömörítetlenül (.musicxml).",
        midiDanado: "A MIDI-fájl sérült vagy csonka.",
        midiConTiempoSMPTE: "A MIDI-fájl SMPTE-képkockákban méri az időt, nem negyedhangonkénti tickekben.",
        xmlDanado: { linea in "A MusicXML-fájl sérült (\(linea). sor)." },
        noEsMusicXMLPorPartes: "Az XML nem szólamonkénti MusicXML-partitúra (score-partwise).",
        sinNotas: "A fájlban nincsenek hangok.",
        sinAcordes: "A fájlban nem szólnak akkordok.",

        // Duracion.swift
        cuadrada: "brevis",
        redonda: "egész hang",
        blanca: "fél hang",
        negra: "negyed hang",
        corchea: "nyolcad hang",
        semicorchea: "tizenhatod hang",
        fusa: "harmincketted hang",
        semifusa: "hatvannegyed hang",
        garrapatea: "százhuszonnyolcad hang",
        cero: "nulla",
        fraccionDeRedonda: { fraccion in "egész hang \(fraccion) része" },
        conPuntillos: ["pontozott _", "kétszer pontozott _", "háromszor pontozott _", "négyszer pontozott _"],

        // Pentagrama.swift
        claveDeSol: "violinkulcs",
        claveDeSolOctavaBaja: "violinkulcs 8vb",
        claveDeSolOctavaAlta: "violinkulcs 8va",
        claveDeFa: "basszuskulcs",
        claveDeFaEnTercera: "baritonkulcs",
        claveDeDoEnPrimera: "szopránkulcs",
        claveDeDoEnSegunda: "mezzoszopránkulcs",
        claveDeDoEnTercera: "altkulcs",
        claveDeDoEnCuarta: "tenorkulcs",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentosPropiosEnIngles: true,
        instrumentoPiano: "zongora",
        instrumentoFlauta: "fuvola",
        instrumentoFlautin: "piccolo",
        instrumentoFlautaEnSol: "altfuvola",
        instrumentoOboe: "oboa",
        instrumentoCornoIngles: "angolkürt",
        instrumentoClarineteEnSib: "B klarinét",
        instrumentoClarineteEnLa: "A klarinét",
        instrumentoClarineteEnMib: "Esz klarinét",
        instrumentoClarineteBajo: "basszusklarinét",
        instrumentoFagot: "fagott",
        instrumentoSaxofonSoprano: "szopránszaxofon",
        instrumentoSaxofonAlto: "altszaxofon",
        instrumentoSaxofonTenor: "tenorszaxofon",
        instrumentoSaxofonBaritono: "baritonszaxofon",
        instrumentoTrompetaEnSib: "B trombita",
        instrumentoTrompetaEnDo: "C trombita",
        instrumentoFliscorno: "szárnykürt",
        instrumentoTrompaEnFa: "F kürt",
        instrumentoTrombon: "harsona",
        instrumentoTuba: "tuba",
        instrumentoViolin: "hegedű",
        instrumentoViola: "brácsa",
        instrumentoViolonchelo: "cselló",
        instrumentoContrabajo: "nagybőgő",
        instrumentoGuitarra: "gitár",
        instrumentoBajoElectrico: "basszusgitár",
        instrumentoXilofono: "xilofon",
        instrumentoGlockenspiel: "harangjáték",
        instrumentoCelesta: "cseleszta"
    )
}
