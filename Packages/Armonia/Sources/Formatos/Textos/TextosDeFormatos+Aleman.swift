// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en alemán. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let aleman = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "Akkorde",
        pistaDelBajo: "Bass",

        // Importacion.swift
        formatoDesconocido: "Die Datei ist weder MIDI noch MusicXML, MEI oder ABC.",
        musicXMLComprimido: "Das komprimierte MusicXML (.mxl) ist beschädigt oder lässt sich nicht lesen: unkomprimiert exportieren (.musicxml).",
        midiDanado: "Die MIDI-Datei ist beschädigt oder abgeschnitten.",
        midiConTiempoSMPTE: "Die MIDI-Datei zählt die Zeit in SMPTE-Frames, nicht in Ticks pro Viertelnote.",
        xmlDanado: "Die XML-Datei ist beschädigt (Zeile {1}).",
        noEsMusicXMLPorPartes: "Das XML ist weder eine stimmenweise MusicXML-Partitur (score-partwise) noch MEI.",
        sinNotas: "Die Datei enthält keine Noten.",
        sinAcordes: "In der Datei erklingt kein Akkord.",

        // ArchivoScala.swift
        sclVacio: "Die Scala-Datei ist leer oder enthält nur Kommentare.",
        sclSinCuenta: "In der Scala-Datei fehlt die Zahl der Stufen in der Zeile nach der Beschreibung.",
        sclCuentaNoValida: "Zeile {1} der Scala-Datei: „{2}“ ist keine Stufenzahl von 1 bis 10000.",
        sclFaltanPasos: "Die Scala-Datei nennt {1} Stufen, hat aber nur {2}.",
        sclPasoNoValido: "Zeile {1} der Scala-Datei: „{2}“ ist weder eine Stufe in Cent (mit Punkt) noch ein positives Verhältnis."
    )
}
