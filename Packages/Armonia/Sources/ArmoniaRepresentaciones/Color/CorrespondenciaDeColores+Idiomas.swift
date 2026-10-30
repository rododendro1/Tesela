import ArmoniaNucleo
import ArmoniaTeoria
// Nombres de las correspondencias de colores en los catorce idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota+Idiomas.swift` y `Fundamentos/Intervalo+Idiomas.swift`.

// MARK: - CorrespondenciaDeColores

extension CorrespondenciaDeColores {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .newton: return "Newton (1704)"
        case .castel: return "Castel (1734)"
        case .scriabin: return "Scriabin (1911)"
        case .circuloDeQuintas:
            return TextosDeRepresentaciones.traducidos.map(\.circuloDeQuintas).en(notacion)
        }
    }
}
