// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en griego. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let griego = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "συγχορδίες",
        pistaDelBajo: "μπάσο",

        // Importacion.swift
        formatoDesconocido: "Το αρχείο δεν είναι ούτε MIDI ούτε MusicXML ούτε MEI ούτε ABC.",
        musicXMLComprimido: "Το συμπιεσμένο MusicXML (.mxl) είναι κατεστραμμένο ή δεν διαβάζεται: εξαγάγετέ το χωρίς συμπίεση (.musicxml).",
        midiDanado: "Το αρχείο MIDI είναι κατεστραμμένο ή κομμένο.",
        midiConTiempoSMPTE: "Το αρχείο MIDI μετρά τον χρόνο σε καρέ SMPTE, όχι σε παλμούς ανά τέταρτο.",
        xmlDanado: { linea in "Το αρχείο XML είναι κατεστραμμένο (γραμμή \(linea))." },
        noEsMusicXMLPorPartes: "Το XML δεν είναι ούτε παρτιτούρα MusicXML ανά μέρη (score-partwise) ούτε MEI.",
        sinNotas: "Το αρχείο δεν έχει καμία νότα.",
        sinAcordes: "Στο αρχείο δεν ακούγεται καμία συγχορδία."
    )
}
