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
        xmlDanado: { linea in "Die XML-Datei ist beschädigt (Zeile \(linea))." },
        noEsMusicXMLPorPartes: "Das XML ist weder eine stimmenweise MusicXML-Partitur (score-partwise) noch MEI.",
        sinNotas: "Die Datei enthält keine Noten.",
        sinAcordes: "In der Datei erklingt kein Akkord."
    )
}
