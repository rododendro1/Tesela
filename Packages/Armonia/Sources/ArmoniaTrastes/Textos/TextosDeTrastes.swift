// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import ArmoniaNucleo
// MARK: - Textos de ArmoniaTrastes
//
// Un idioma por fichero: `TextosDeTrastes+Espanol.swift`, `TextosDeTrastes+Ingles.swift`… Cada uno da todos los
// campos, sin valores por omisión, así que un texto nuevo no compila hasta que está en los catorce y
// un idioma nuevo es un fichero más (y su fila en `traducidos`).

/// Los textos de ArmoniaTrastes en un idioma.
struct TextosDeTrastes: Sendable {
    // MARK: Encordado.swift
    let guitarra: String
    let guitarraEnReGrave: String
    let guitarraDeSieteCuerdas: String
    let bajo: String
    let bajoDeCincoCuerdas: String
    let ukelele: String
    let mandolina: String

    /// Los textos en los catorce idiomas: `traducidos.map(\.campo)` es la `Traduccion` de un campo.
    static let traducidos = Traducido<TextosDeTrastes>(
        espanol, ingles, ca: catalan, gl: gallego, ast: asturiano, an: aragones, eu: euskera, pt: portugues,
        fr: frances, oc: occitano, it: italiano, de: aleman, el: griego, ru: ruso)
}
