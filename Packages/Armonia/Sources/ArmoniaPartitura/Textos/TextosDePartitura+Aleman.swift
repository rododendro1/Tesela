// Los textos de ArmoniaPartitura en alemán. Los campos y lo que significa cada uno están en
// `TextosDePartitura.swift`.

extension TextosDePartitura {
    static let aleman = TextosDePartitura(
        // Contrapunto.swift
        enElCompas: { n in "(Takt \(n))" },
        enLosCompases: { pasos in "(Takte \(pasos))" },
        ritmoDeLaEspecie: "Rhythmus passt nicht zur Gattung",
        comienzoImperfecto: "Beginn ohne vollkommene Konsonanz",
        finalImperfecto: "Schluss ohne Einklang oder Oktave",
        finalSinGradoConjunto: "Schluss nicht schrittweise erreicht",
        disonanciaEnParteFuerte: "Dissonanz auf schwerer Zeit",
        disonanciaMalTratada: "Falsch behandelte Dissonanz",
        retardoMalResuelto: "Falsch aufgelöster Vorhalt",
        unisono: "Einklang mitten im Satz",
        saltoSinCompensar: "Nicht ausgeglichener Sprung",
        notaRepetida: "Tonwiederholung",
        especieConElContrapuntoEncima: { n in "Gattung \(n), Kontrapunkt über dem Cantus firmus" },
        especieConElContrapuntoDebajo: { n in "Gattung \(n), Kontrapunkt unter dem Cantus firmus" },
        sinFaltas: "Keine Fehler.",

        // ArchivoMIDI.swift
        pistaDeAcordes: "Akkorde",
        pistaDelBajo: "Bass",

        // Importacion.swift
        formatoDesconocido: "Die Datei ist weder MIDI noch MusicXML.",
        musicXMLComprimido: "Es ist komprimiertes MusicXML (.mxl), das noch nicht gelesen wird: unkomprimiert exportieren (.musicxml).",
        midiDanado: "Die MIDI-Datei ist beschädigt oder abgeschnitten.",
        midiConTiempoSMPTE: "Die MIDI-Datei zählt die Zeit in SMPTE-Frames, nicht in Ticks pro Viertelnote.",
        xmlDanado: { linea in "Die MusicXML-Datei ist beschädigt (Zeile \(linea))." },
        noEsMusicXMLPorPartes: "Das XML ist keine stimmenweise MusicXML-Partitur (score-partwise).",
        sinNotas: "Die Datei enthält keine Noten.",
        sinAcordes: "In der Datei erklingt kein Akkord.",

        // Duracion.swift
        cuadrada: "Doppelganze",
        redonda: "Ganze",
        blanca: "Halbe",
        negra: "Viertel",
        corchea: "Achtel",
        semicorchea: "Sechzehntel",
        fusa: "Zweiunddreißigstel",
        semifusa: "Vierundsechzigstel",
        garrapatea: "Hundertachtundzwanzigstel",
        cero: "null",
        fraccionDeRedonda: { fraccion in "\(fraccion) einer Ganzen" },
        conPuntillos: ["punktierte _", "doppelt punktierte _", "dreifach punktierte _", "vierfach punktierte _"],

        // Pentagrama.swift
        claveDeSol: "Violinschlüssel",
        claveDeSolOctavaBaja: "Violinschlüssel eine Oktave tiefer",
        claveDeSolOctavaAlta: "Violinschlüssel eine Oktave höher",
        claveDeFa: "Bassschlüssel",
        claveDeFaEnTercera: "Baritonschlüssel",
        claveDeDoEnPrimera: "Sopranschlüssel",
        claveDeDoEnSegunda: "Mezzosopranschlüssel",
        claveDeDoEnTercera: "Altschlüssel",
        claveDeDoEnCuarta: "Tenorschlüssel"
    )
}
