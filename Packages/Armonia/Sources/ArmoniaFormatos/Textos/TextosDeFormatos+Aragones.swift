// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaFormatos en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let aragones = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O fichero no ye MIDI, MusicXML, MEI ni ABC.",
        musicXMLComprimido: "O MusicXML comprimiu (.mxl) ye malmeso u no se puede leyer: exporta-lo sin comprimir (.musicxml).",
        midiDanado: "O fichero MIDI ye malmeso u cortau.",
        midiConTiempoSMPTE: "O fichero MIDI cuenta o tiempo en fotogramas SMPTE, no en pulsos per negra.",
        xmlDanado: { linea in "O fichero XML ye malmeso (linia \(linea))." },
        noEsMusicXMLPorPartes: "O XML no ye una partitura MusicXML per partes (score-partwise) ni MEI.",
        sinNotas: "O fichero no tiene garra nota.",
        sinAcordes: "En o fichero no suena garra acorde."
    )
}
