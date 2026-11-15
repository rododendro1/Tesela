// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en catalán. Los campos y lo que significa cada uno están en
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
        xmlDanado: "El fitxer XML està malmès (línia {1}).",
        noEsMusicXMLPorPartes: "L'XML no és una partitura MusicXML per parts (score-partwise) ni MEI.",
        sinNotas: "El fitxer no té cap nota.",
        sinAcordes: "Al fitxer no sona cap acord.",

        // ArchivoScala.swift
        sclVacio: "El fitxer de Scala és buit o només té comentaris.",
        sclSinCuenta: "Al fitxer de Scala li falta el nombre de passos, a la línia que segueix la descripció.",
        sclCuentaNoValida: "Línia {1} del fitxer de Scala: «{2}» no és un nombre de passos de 1 a 10000.",
        sclFaltanPasos: "El fitxer de Scala diu {1} passos i només en té {2}.",
        sclPasoNoValido: "Línia {1} del fitxer de Scala: «{2}» no és un pas en cents (amb punt) ni una raó positiva."
    )
}
