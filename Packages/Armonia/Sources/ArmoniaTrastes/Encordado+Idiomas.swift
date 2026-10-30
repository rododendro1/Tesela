import ArmoniaNucleo
// Los nombres de los instrumentos en los catorce idiomas de los textos. Los textos están en
// `Textos/TextosDeTrastes+Espanol.swift`, `…+Ingles.swift`…, un fichero por idioma.

extension Encordado: Nombrable {
    /// El nombre del instrumento en el idioma de los textos, en minúscula para ir dentro de una frase:
    /// «guitarra de siete cuerdas», «seven-string guitar». Un encordado que no es de los de `todos` conserva
    /// su nombre.
    public func nombre(en notacion: Notacion) -> String {
        traduccion?.en(notacion) ?? nombre
    }

    /// El nombre para un menú, con mayúscula: «Guitarra de siete cuerdas».
    public func titulo(en notacion: Notacion) -> String {
        let nombre = nombre(en: notacion)
        return nombre.prefix(1).uppercased() + nombre.dropFirst()
    }

    /// El nombre en los catorce idiomas; `nil` si el encordado no es de los de `todos`.
    package var traduccion: Traduccion? {
        switch self {
        case .guitarra:
            return TextosDeTrastes.traducidos.map(\.guitarra)
        case .guitarraEnReGrave:
            return TextosDeTrastes.traducidos.map(\.guitarraEnReGrave)
        case .guitarraDeSieteCuerdas:
            return TextosDeTrastes.traducidos.map(\.guitarraDeSieteCuerdas)
        case .bajo:
            return TextosDeTrastes.traducidos.map(\.bajo)
        case .bajoDeCincoCuerdas:
            return TextosDeTrastes.traducidos.map(\.bajoDeCincoCuerdas)
        case .ukelele:
            return TextosDeTrastes.traducidos.map(\.ukelele)
        case .mandolina:
            return TextosDeTrastes.traducidos.map(\.mandolina)
        default:
            return nil
        }
    }
}
