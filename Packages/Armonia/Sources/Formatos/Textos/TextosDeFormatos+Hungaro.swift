// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let hungaro = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "akkordok",
        pistaDelBajo: "basszus",

        // Importacion.swift
        formatoDesconocido: "A fájl nem MIDI, MusicXML, MEI és nem is ABC.",
        musicXMLComprimido: "A tömörített MusicXML (.mxl) sérült vagy nem olvasható: exportáld tömörítetlenül (.musicxml).",
        midiDanado: "A MIDI-fájl sérült vagy csonka.",
        midiConTiempoSMPTE: "A MIDI-fájl SMPTE-képkockákban méri az időt, nem negyedhangonkénti tickekben.",
        xmlDanado: "Az XML-fájl sérült ({1}. sor).",
        noEsMusicXMLPorPartes: "Az XML nem szólamonkénti MusicXML-partitúra (score-partwise), és nem is MEI.",
        sinNotas: "A fájlban nincsenek hangok.",
        sinAcordes: "A fájlban nem szólnak akkordok."
    )
}
