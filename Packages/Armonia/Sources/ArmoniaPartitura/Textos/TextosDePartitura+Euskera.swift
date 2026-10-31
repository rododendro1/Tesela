// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en euskera. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let euskera = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(\(n). konpasa)" },
        enLosCompases: { pasos in "(\(pasos) konpasak)" },
        ritmoDeLaEspecie: "Espeziez kanpoko erritmoa",
        comienzoImperfecto: "Hasiera kontsonantzia perfekturik gabe",
        finalImperfecto: "Amaiera unisonorik eta zortzidunik gabe",
        finalSinGradoConjunto: "Amaiera gradu jarraiturik gabe",
        disonanciaEnParteFuerte: "Disonantzia zati sendoan",
        disonanciaMalTratada: "Gaizki tratatutako disonantzia",
        retardoMalResuelto: "Gaizki ebatzitako atzerapena",
        unisono: "Unisonoa ariketaren erdian",
        saltoSinCompensar: "Konpentsatu gabeko jauzia",
        notaRepetida: "Nota errepikatua",
        especieConElContrapuntoEncima: { n in "\(n). espeziea, kontrapuntua cantus firmusaren gainean" },
        especieConElContrapuntoDebajo: { n in "\(n). espeziea, kontrapuntua cantus firmusaren azpian" },
        sinFaltas: "Akatsik gabe.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "akordeak",
        pistaDelBajo: "baxua",

        // Importacion.swift
        formatoDesconocido: "Fitxategia ez da MIDI ez MusicXML.",
        musicXMLComprimido: "MusicXML konprimitua (.mxl) hondatuta dago edo ezin da irakurri: esportatu konprimitu gabe (.musicxml).",
        midiDanado: "MIDI fitxategia hondatuta edo moztuta dago.",
        midiConTiempoSMPTE: "MIDI fitxategiak SMPTE fotogrametan neurtzen du denbora, ez beltz bakoitzeko pultsutan.",
        xmlDanado: { linea in "MusicXML fitxategia hondatuta dago (\(linea). lerroa)." },
        noEsMusicXMLPorPartes: "XMLa ez da zatikako MusicXML partitura bat (score-partwise).",
        sinNotas: "Fitxategiak ez du notarik.",
        sinAcordes: "Fitxategian ez da akorderik entzuten.",

        // Duracion.swift
        cuadrada: "karratua",
        redonda: "biribila",
        blanca: "zuria",
        negra: "beltza",
        corchea: "kortxea",
        semicorchea: "semikortxea",
        fusa: "fusa",
        semifusa: "semifusa",
        garrapatea: "garrapatea",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "biribilaren \(fraccion)" },
        conPuntillos: ["_ puntuduna", "_ puntu bikoitzarekin", "_ puntu hirukoitzarekin", "_ puntu laukoitzarekin"],

        // Pentagrama.swift
        claveDeSol: "sol giltza",
        claveDeSolOctavaBaja: "sol giltza zortzidun bat beherago",
        claveDeSolOctavaAlta: "sol giltza zortzidun bat gorago",
        claveDeFa: "fa giltza",
        claveDeFaEnTercera: "fa giltza hirugarren lerroan",
        claveDeDoEnPrimera: "do giltza lehen lerroan",
        claveDeDoEnSegunda: "do giltza bigarren lerroan",
        claveDeDoEnTercera: "do giltza hirugarren lerroan",
        claveDeDoEnCuarta: "do giltza laugarren lerroan",
        // Pentagrama.swift (InstrumentoDePartitura)
        instrumentoPiano: "pianoa",
        instrumentoFlauta: "flauta",
        instrumentoFlautin: "pikoloa",
        instrumentoFlautaEnSol: "sol flauta",
        instrumentoOboe: "oboea",
        instrumentoCornoIngles: "korno ingelesa",
        instrumentoClarineteEnSib: "si♭ klarinetea",
        instrumentoClarineteEnLa: "la klarinetea",
        instrumentoClarineteEnMib: "mi♭ klarinetea",
        instrumentoClarineteBajo: "klarinete baxua",
        instrumentoFagot: "fagota",
        instrumentoSaxofonSoprano: "saxofoi sopranoa",
        instrumentoSaxofonAlto: "saxofoi altua",
        instrumentoSaxofonTenor: "saxofoi tenorra",
        instrumentoSaxofonBaritono: "saxofoi baritonoa",
        instrumentoTrompetaEnSib: "si♭ tronpeta",
        instrumentoTrompetaEnDo: "do tronpeta",
        instrumentoFliscorno: "fliscornoa",
        instrumentoTrompaEnFa: "fa tronpa",
        instrumentoTrombon: "tronboia",
        instrumentoTuba: "tuba",
        instrumentoViolin: "biolina",
        instrumentoViola: "biola",
        instrumentoViolonchelo: "biolontxeloa",
        instrumentoContrabajo: "kontrabaxua",
        instrumentoGuitarra: "gitarra",
        instrumentoBajoElectrico: "baxu elektrikoa",
        instrumentoXilofono: "xilofonoa",
        instrumentoGlockenspiel: "glockenspiela",
        instrumentoCelesta: "zelesta"
    )
}
