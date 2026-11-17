import Elementos

/// Por qué no se puede analizar una sucesión de acordes buscando su tonalidad: lo que lanza
/// ``AnalisisArmonico/analizar(_:)``.
///
///     try AnalisisArmonico.analizar([])   // lanza .sinAcordes: «No hay acordes que analizar.»
public enum ErrorDeAnalisis: ErrorDeArmonia, Hashable {
    /// No hay acordes: sin ellos no hay tonalidad que buscar.
    case sinAcordes

    public func descripcion(en notacion: Notacion) -> String {
        switch self {
        case .sinAcordes: return TextosDeTeoria.en(notacion, \.analisisSinAcordes)
        }
    }
}
