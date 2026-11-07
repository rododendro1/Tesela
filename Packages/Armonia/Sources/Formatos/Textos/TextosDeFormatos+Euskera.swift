// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en euskera. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let euskera = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "akordeak",
        pistaDelBajo: "baxua",

        // Importacion.swift
        formatoDesconocido: "Fitxategia ez da MIDI, MusicXML, MEI edo ABC.",
        musicXMLComprimido: "MusicXML konprimitua (.mxl) hondatuta dago edo ezin da irakurri: esportatu konprimitu gabe (.musicxml).",
        midiDanado: "MIDI fitxategia hondatuta edo moztuta dago.",
        midiConTiempoSMPTE: "MIDI fitxategiak SMPTE fotogrametan neurtzen du denbora, ez beltz bakoitzeko pultsutan.",
        xmlDanado: { linea in "XML fitxategia hondatuta dago (\(linea). lerroa)." },
        noEsMusicXMLPorPartes: "XMLa ez da zatikako MusicXML partitura bat (score-partwise) ezta MEI ere.",
        sinNotas: "Fitxategiak ez du notarik.",
        sinAcordes: "Fitxategian ez da akorderik entzuten."
    )
}
