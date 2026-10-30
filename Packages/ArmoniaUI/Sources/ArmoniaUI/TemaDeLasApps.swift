#if canImport(SwiftUI)
import SwiftUI

/// Colores y medidas comunes de las apps del ecosistema.
public enum TemaDeLasApps {
    /// El color de énfasis: el mismo azul con que los dibujos SVG del Tonnetz marcan las notas (#1f4e9c).
    public static let acento = Color(red: 31 / 255, green: 78 / 255, blue: 156 / 255)
    /// Madera clara del mástil.
    public static let madera = Color(red: 0.86, green: 0.74, blue: 0.56)
    /// Madera oscura de la cejilla y de los trastes pisados.
    public static let maderaOscura = Color(red: 0.36, green: 0.24, blue: 0.14)

    public static let radioDeEsquina: CGFloat = 12
    public static let margen: CGFloat = 16
}
#endif
