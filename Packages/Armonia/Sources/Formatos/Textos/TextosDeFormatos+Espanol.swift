// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en español. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let espanol = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "bajo",

        // Importacion.swift
        formatoDesconocido: "El fichero no es MIDI, MusicXML, MEI ni ABC.",
        musicXMLComprimido: "El MusicXML comprimido (.mxl) está dañado o no se puede leer: expórtalo sin comprimir (.musicxml).",
        midiDanado: "El fichero MIDI está dañado o cortado.",
        midiConTiempoSMPTE: "El fichero MIDI cuenta el tiempo en fotogramas SMPTE, no en pulsos por negra.",
        xmlDanado: "El fichero XML está dañado (línea {1}).",
        noEsMusicXMLPorPartes: "El XML no es una partitura MusicXML por partes (score-partwise) ni MEI.",
        sinNotas: "El fichero no tiene ninguna nota.",
        sinAcordes: "En el fichero no suena ningún acorde."
    )
}
