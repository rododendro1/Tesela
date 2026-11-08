// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en sueco. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let sueco = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "Ackord",
        pistaDelBajo: "Bas",

        // Importacion.swift
        formatoDesconocido: "Filen är varken MIDI, MusicXML, MEI eller ABC.",
        musicXMLComprimido: "Den komprimerade MusicXML-filen (.mxl) är skadad eller kan inte läsas: exportera den okomprimerad (.musicxml).",
        midiDanado: "MIDI-filen är skadad eller avkortad.",
        midiConTiempoSMPTE: "MIDI-filen räknar tiden i SMPTE-rutor, inte i tick per fjärdedelsnot.",
        xmlDanado: "XML-filen är skadad (rad {1}).",
        noEsMusicXMLPorPartes: "XML-filen är varken ett stämvis MusicXML-partitur (score-partwise) eller MEI.",
        sinNotas: "Filen innehåller inga noter.",
        sinAcordes: "Inget ackord klingar i filen."
    )
}
