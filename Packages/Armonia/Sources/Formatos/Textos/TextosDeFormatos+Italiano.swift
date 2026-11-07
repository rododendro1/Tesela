// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en italiano. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let italiano = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "accordi",
        pistaDelBajo: "basso",

        // Importacion.swift
        formatoDesconocido: "Il file non è né MIDI né MusicXML né MEI né ABC.",
        musicXMLComprimido: "Il MusicXML compresso (.mxl) è danneggiato o non si può leggere: esportalo non compresso (.musicxml).",
        midiDanado: "Il file MIDI è danneggiato o troncato.",
        midiConTiempoSMPTE: "Il file MIDI conta il tempo in fotogrammi SMPTE, non in tick per semiminima.",
        xmlDanado: { linea in "Il file XML è danneggiato (riga \(linea))." },
        noEsMusicXMLPorPartes: "L'XML non è né una partitura MusicXML per parti (score-partwise) né MEI.",
        sinNotas: "Il file non contiene note.",
        sinAcordes: "Nel file non suona nessun accordo."
    )
}
