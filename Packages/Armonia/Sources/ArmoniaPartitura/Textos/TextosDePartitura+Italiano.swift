// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaPartitura en italiano. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let italiano = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(battuta \(n))" },
        enLosCompases: { pasos in "(battute \(pasos))" },
        ritmoDeLaEspecie: "Ritmo estraneo alla specie",
        comienzoImperfecto: "Inizio senza consonanza perfetta",
        finalImperfecto: "Finale senza unisono né ottava",
        finalSinGradoConjunto: "Finale non raggiunto per grado congiunto",
        disonanciaEnParteFuerte: "Dissonanza in battere",
        disonanciaMalTratada: "Dissonanza mal trattata",
        retardoMalResuelto: "Ritardo mal risolto",
        unisono: "Unisono a metà esercizio",
        saltoSinCompensar: "Salto non compensato",
        notaRepetida: "Nota ripetuta",
        especieConElContrapuntoEncima: { n in "Specie \(n), con il contrappunto sopra il cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Specie \(n), con il contrappunto sotto il cantus firmus" },
        sinFaltas: "Nessun errore.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "accordi",
        pistaDelBajo: "basso",

        // Importacion.swift
        formatoDesconocido: "Il file non è né MIDI né MusicXML.",
        musicXMLComprimido: "Il MusicXML compresso (.mxl) è danneggiato o non si può leggere: esportalo non compresso (.musicxml).",
        midiDanado: "Il file MIDI è danneggiato o troncato.",
        midiConTiempoSMPTE: "Il file MIDI conta il tempo in fotogrammi SMPTE, non in tick per semiminima.",
        xmlDanado: { linea in "Il file MusicXML è danneggiato (riga \(linea))." },
        noEsMusicXMLPorPartes: "L'XML non è una partitura MusicXML per parti (score-partwise).",
        sinNotas: "Il file non contiene note.",
        sinAcordes: "Nel file non suona nessun accordo.",

        // Duracion.swift
        cuadrada: "breve",
        redonda: "semibreve",
        blanca: "minima",
        negra: "semiminima",
        corchea: "croma",
        semicorchea: "semicroma",
        fusa: "biscroma",
        semifusa: "semibiscroma",
        garrapatea: "fusa",
        cero: "zero",
        fraccionDeRedonda: { fraccion in "\(fraccion) di semibreve" },
        conPuntillos: ["_ puntata", "_ doppiamente puntata", "_ triplamente puntata", "_ quadruplamente puntata"],

        // Pentagrama.swift
        claveDeSol: "chiave di violino",
        claveDeSolOctavaBaja: "chiave di violino ottava bassa",
        claveDeSolOctavaAlta: "chiave di violino ottava alta",
        claveDeFa: "chiave di basso",
        claveDeFaEnTercera: "chiave di baritono",
        claveDeDoEnPrimera: "chiave di soprano",
        claveDeDoEnSegunda: "chiave di mezzosoprano",
        claveDeDoEnTercera: "chiave di contralto",
        claveDeDoEnCuarta: "chiave di tenore"
    )
}
