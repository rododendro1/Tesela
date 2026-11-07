// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Elementos
// MARK: - Textos de Trastes
//
// Un idioma por fichero: `TextosDeTrastes+Espanol.swift`, `TextosDeTrastes+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los trece y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de Trastes en un idioma.
struct TextosDeTrastes: TextosTraducidos {
    // MARK: Encordado.swift
    let guitarra: String
    let guitarraEnReGrave: String
    let guitarraEnReAbierto: String
    let guitarraEnSolAbierto: String
    let guitarraDADGAD: String
    let guitarraDeSieteCuerdas: String
    let bajo: String
    let bajoDeCincoCuerdas: String
    let ukelele: String
    let mandolina: String

    /// Los textos en los trece idiomas: `en(notacion, \.campo)` es un texto en un idioma y `traduccion(\.campo)`, su
    /// `Traduccion`.
    static let traducidos = Traducido<TextosDeTrastes>(
        espanol, ingles, ca: catalan, gl: gallego, eu: euskera, pt: portugues,
        fr: frances, it: italiano, de: aleman, el: griego, ru: ruso, hu: hungaro, sv: sueco)
}
