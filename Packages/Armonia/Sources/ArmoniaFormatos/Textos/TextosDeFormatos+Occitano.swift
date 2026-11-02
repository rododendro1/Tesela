// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaFormatos en occitano. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let occitano = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acòrds",
        pistaDelBajo: "bassa",

        // Importacion.swift
        formatoDesconocido: "Lo fichièr es pas ni MIDI, ni MusicXML, ni MEI, ni ABC.",
        musicXMLComprimido: "Lo MusicXML compressat (.mxl) es damatjat o se pòt pas legir : exportatz-lo sens compression (.musicxml).",
        midiDanado: "Lo fichièr MIDI es damatjat o copat.",
        midiConTiempoSMPTE: "Lo fichièr MIDI compta lo temps en imatges SMPTE, e non en tics per negra.",
        xmlDanado: { linea in "Lo fichièr XML es damatjat (linha \(linea))." },
        noEsMusicXMLPorPartes: "Lo XML es pas ni una particion MusicXML per partidas (score-partwise) ni de MEI.",
        sinNotas: "Lo fichièr a pas cap de nòta.",
        sinAcordes: "Dins lo fichièr sona pas cap d'acòrd."
    )
}
