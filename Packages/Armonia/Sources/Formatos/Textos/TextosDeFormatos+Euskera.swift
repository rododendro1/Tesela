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
        xmlDanado: "XML fitxategia hondatuta dago ({1}. lerroa).",
        noEsMusicXMLPorPartes: "XMLa ez da zatikako MusicXML partitura bat (score-partwise) ezta MEI ere.",
        sinNotas: "Fitxategiak ez du notarik.",
        sinAcordes: "Fitxategian ez da akorderik entzuten.",

        // ArchivoScala.swift
        sclVacio: "Scala fitxategia hutsik dago edo iruzkinak baino ez ditu.",
        sclSinCuenta: "Scala fitxategiak ez du urrats kopurua, deskribapenaren ondorengo lerroan.",
        sclCuentaNoValida: "Scala fitxategiko {1}. lerroa: «{2}» ez da 1etik 10000rako urrats kopuru bat.",
        sclFaltanPasos: "Scala fitxategiak {1} urrats dituela dio, baina {2} baino ez ditu.",
        sclPasoNoValido: "Scala fitxategiko {1}. lerroa: «{2}» ez da zentimotako urrats bat (puntuarekin) ez arrazoi positibo bat."
    )
}
