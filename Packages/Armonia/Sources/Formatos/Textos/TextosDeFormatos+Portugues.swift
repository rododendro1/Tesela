// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Formatos en portugués. Los campos y lo que significa cada uno están en
// `TextosDeFormatos.swift`.

extension TextosDeFormatos {
    static let portugues = TextosDeFormatos(
        // ArchivoMIDI.swift
        pistaDeAcordes: "acordes",
        pistaDelBajo: "baixo",

        // Importacion.swift
        formatoDesconocido: "O ficheiro não é MIDI, MusicXML, MEI nem ABC.",
        musicXMLComprimido: "O MusicXML comprimido (.mxl) está danificado ou não se pode ler: exporte-o sem comprimir (.musicxml).",
        midiDanado: "O ficheiro MIDI está danificado ou cortado.",
        midiConTiempoSMPTE: "O ficheiro MIDI conta o tempo em fotogramas SMPTE, não em pulsos por semínima.",
        xmlDanado: "O ficheiro XML está danificado (linha {1}).",
        noEsMusicXMLPorPartes: "O XML não é uma partitura MusicXML por partes (score-partwise) nem MEI.",
        sinNotas: "O ficheiro não tem nenhuma nota.",
        sinAcordes: "No ficheiro não soa nenhum acorde.",

        // ArchivoScala.swift
        sclVacio: "O ficheiro do Scala está vazio ou só tem comentários.",
        sclSinCuenta: "Ao ficheiro do Scala falta o número de passos, na linha a seguir à descrição.",
        sclCuentaNoValida: "Linha {1} do ficheiro do Scala: «{2}» não é um número de passos de 1 a 10000.",
        sclFaltanPasos: "O ficheiro do Scala diz {1} passos e só tem {2}.",
        sclPasoNoValido: "Linha {1} do ficheiro do Scala: «{2}» não é um passo em cents (com ponto) nem uma razão positiva."
    )
}
