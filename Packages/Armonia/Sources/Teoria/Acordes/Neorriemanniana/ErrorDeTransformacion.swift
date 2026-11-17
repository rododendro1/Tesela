import Elementos

/// Por qué no se puede aplicar una secuencia escrita de transformaciones neorriemannianas a un acorde: lo que lanza
/// ``Acorde/transformar(leyendo:)``.
///
///     do {
///         let acorde = try Acorde("Sol7").transformar(leyendo: "P")
///     } catch {
///         error   // .sinTriada: «El acorde no es una tríada mayor ni menor…»
///     }
public enum ErrorDeTransformacion: ErrorDeArmonia, Hashable {
    /// La secuencia no se puede leer: el error de ``TransformacionNeorriemanniana/secuencia(leyendo:)``.
    case secuenciaIlegible(ErrorDeLecturaDeTeoria)
    /// El acorde no es una tríada mayor ni menor, las únicas a las que se aplican.
    case sinTriada

    public func descripcion(en notacion: Notacion) -> String {
        switch self {
        case .secuenciaIlegible(let error): return error.descripcion(en: notacion)
        case .sinTriada: return TextosDeTeoria.en(notacion, \.transformacionSinTriada)
        }
    }
}
