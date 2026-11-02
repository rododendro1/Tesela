// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// MARK: - Textos de ArmoniaFormatos
//
// Un idioma por fichero: `TextosDeFormatos+Espanol.swift`, `TextosDeFormatos+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los quince y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaFormatos en un idioma.
struct TextosDeFormatos: TextosTraducidos {
    // MARK: ArchivoMIDI.swift
    let pistaDeAcordes: String
    let pistaDelBajo: String

    // MARK: Importacion.swift
    let formatoDesconocido: String
    let musicXMLComprimido: String
    let midiDanado: String
    let midiConTiempoSMPTE: String
    let xmlDanado: @Sendable (Int) -> String
    let noEsMusicXMLPorPartes: String
    let sinNotas: String
    let sinAcordes: String

    /// Los textos en los quince idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeFormatos>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro)
}
