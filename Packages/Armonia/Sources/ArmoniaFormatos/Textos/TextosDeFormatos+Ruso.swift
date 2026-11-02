// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaFormatos en ruso. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let ruso = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "аккорды",
        pistaDelBajo: "бас",

        // Importacion.swift
        formatoDesconocido: "Файл не является ни MIDI, ни MusicXML, ни MEI, ни ABC.",
        musicXMLComprimido: "Сжатый MusicXML (.mxl) повреждён или не читается: экспортируйте его без сжатия (.musicxml).",
        midiDanado: "Файл MIDI повреждён или обрезан.",
        midiConTiempoSMPTE: "Файл MIDI считает время в кадрах SMPTE, а не в тиках на четверть.",
        xmlDanado: { linea in "Файл XML повреждён (строка \(linea))." },
        noEsMusicXMLPorPartes: "XML не является ни партитурой MusicXML по партиям (score-partwise), ни MEI.",
        sinNotas: "В файле нет ни одной ноты.",
        sinAcordes: "В файле не звучит ни одного аккорда."
    )
}
