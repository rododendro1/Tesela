// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Formatos
//
// Un idioma por fichero: `TextosDeFormatos+Espanol.swift`, `TextosDeFormatos+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Formatos en un idioma.
struct TextosDeFormatos: TextosTraducidos {
    // MARK: ArchivoMIDI.swift
    let pistaDeAcordes: String
    let pistaDelBajo: String

    // MARK: Importacion.swift
    let formatoDesconocido: String
    let musicXMLComprimido: String
    let midiDanado: String
    let midiConTiempoSMPTE: String
    let xmlDanado: Plantilla  // {1} linea
    let noEsMusicXMLPorPartes: String
    let sinNotas: String
    let sinAcordes: String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeFormatos>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
