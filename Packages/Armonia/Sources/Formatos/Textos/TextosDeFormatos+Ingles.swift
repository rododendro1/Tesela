// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en inglés. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let ingles = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "chords",
        pistaDelBajo: "bass",

        // Importacion.swift
        formatoDesconocido: "The file is not MIDI, MusicXML, MEI or ABC.",
        musicXMLComprimido: "The compressed MusicXML (.mxl) is damaged or cannot be read: export it uncompressed (.musicxml).",
        midiDanado: "The MIDI file is damaged or truncated.",
        midiConTiempoSMPTE: "The MIDI file counts time in SMPTE frames, not in ticks per quarter note.",
        xmlDanado: "The XML file is damaged (line {1}).",
        noEsMusicXMLPorPartes: "The XML is neither a partwise MusicXML score (score-partwise) nor MEI.",
        sinNotas: "The file has no notes.",
        sinAcordes: "No chords sound in the file."
    )
}
