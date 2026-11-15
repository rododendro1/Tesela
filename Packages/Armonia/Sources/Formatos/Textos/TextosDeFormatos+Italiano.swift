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
        xmlDanado: "Il file XML è danneggiato (riga {1}).",
        noEsMusicXMLPorPartes: "L'XML non è né una partitura MusicXML per parti (score-partwise) né MEI.",
        sinNotas: "Il file non contiene note.",
        sinAcordes: "Nel file non suona nessun accordo.",

        // ArchivoScala.swift
        sclVacio: "Il file di Scala è vuoto o contiene solo commenti.",
        sclSinCuenta: "Nel file di Scala manca il numero di passi, nella riga dopo la descrizione.",
        sclCuentaNoValida: "Riga {1} del file di Scala: «{2}» non è un numero di passi da 1 a 10000.",
        sclFaltanPasos: "Il file di Scala dichiara {1} passi ma ne ha solo {2}.",
        sclPasoNoValido: "Riga {1} del file di Scala: «{2}» non è un passo in cent (con il punto) né un rapporto positivo."
    )
}
