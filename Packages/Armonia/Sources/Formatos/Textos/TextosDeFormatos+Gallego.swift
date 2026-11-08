// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en gallego. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let gallego = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O ficheiro non é MIDI, MusicXML, MEI nin ABC.",
        musicXMLComprimido: "O MusicXML comprimido (.mxl) está danado ou non se pode ler: expórtao sen comprimir (.musicxml).",
        midiDanado: "O ficheiro MIDI está danado ou cortado.",
        midiConTiempoSMPTE: "O ficheiro MIDI conta o tempo en fotogramas SMPTE, non en pulsos por negra.",
        xmlDanado: "O ficheiro XML está danado (liña {1}).",
        noEsMusicXMLPorPartes: "O XML non é unha partitura MusicXML por partes (score-partwise) nin MEI.",
        sinNotas: "O ficheiro non ten ningunha nota.",
        sinAcordes: "No ficheiro non soa ningún acorde."
    )
}
