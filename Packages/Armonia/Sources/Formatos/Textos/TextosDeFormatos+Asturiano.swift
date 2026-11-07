// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let asturiano = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baxu",

        // Importacion.swift
        formatoDesconocido: "El ficheru nun ye MIDI, MusicXML, MEI nin ABC.",
        musicXMLComprimido: "El MusicXML comprimíu (.mxl) ta estropiáu o nun se pue lleer: espórtalu ensin comprimir (.musicxml).",
        midiDanado: "El ficheru MIDI ta estropiáu o cortáu.",
        midiConTiempoSMPTE: "El ficheru MIDI cuenta'l tiempu en fotogrames SMPTE, non en pulsos por negra.",
        xmlDanado: { linea in "El ficheru XML ta estropiáu (llinia \(linea))." },
        noEsMusicXMLPorPartes: "El XML nun ye una partitura MusicXML per partes (score-partwise) nin MEI.",
        sinNotas: "El ficheru nun tien nenguna nota.",
        sinAcordes: "Nel ficheru nun suena nengún acorde."
    )
}
