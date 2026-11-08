// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en francés. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let frances = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "accords",
        pistaDelBajo: "basse",

        // Importacion.swift
        formatoDesconocido: "Le fichier n'est ni MIDI, ni MusicXML, ni MEI, ni ABC.",
        musicXMLComprimido: "Le MusicXML compressé (.mxl) est endommagé ou illisible : exportez-le sans compression (.musicxml).",
        midiDanado: "Le fichier MIDI est endommagé ou tronqué.",
        midiConTiempoSMPTE: "Le fichier MIDI compte le temps en images SMPTE, et non en tics par noire.",
        xmlDanado: "Le fichier XML est endommagé (ligne {1}).",
        noEsMusicXMLPorPartes: "Le XML n'est ni une partition MusicXML par parties (score-partwise) ni du MEI.",
        sinNotas: "Le fichier ne contient aucune note.",
        sinAcordes: "Aucun accord ne sonne dans le fichier."
    )
}
