// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaFormatos en catalán. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let catalan = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acords",
        pistaDelBajo: "baix",

        // Importacion.swift
        formatoDesconocido: "El fitxer no és MIDI, MusicXML, MEI ni ABC.",
        musicXMLComprimido: "El MusicXML comprimit (.mxl) està malmès o no es pot llegir: exporta'l sense comprimir (.musicxml).",
        midiDanado: "El fitxer MIDI està malmès o tallat.",
        midiConTiempoSMPTE: "El fitxer MIDI compta el temps en fotogrames SMPTE, no en polsos per negra.",
        xmlDanado: { linea in "El fitxer XML està malmès (línia \(linea))." },
        noEsMusicXMLPorPartes: "L'XML no és una partitura MusicXML per parts (score-partwise) ni MEI.",
        sinNotas: "El fitxer no té cap nota.",
        sinAcordes: "Al fitxer no sona cap acord."
    )
}
