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
    /// La secuencia no se puede leer: el error de ``TransformacionNeorriemanniana/secuencia(leyendo:)``, que es un
    /// `ErrorDeLectura` si está vacía o un `ErrorDeLecturaDeTeoria` si tiene algo que no es una transformación.
    case secuenciaIlegible(any ErrorAlLeer)
    /// El acorde no es una tríada mayor ni menor, las únicas a las que se aplican.
    case sinTriada

    public func descripcion(en notacion: Notacion) -> String {
        switch self {
        case .secuenciaIlegible(let error): return error.descripcion(en: notacion)
        case .sinTriada: return TextosDeTeoria.en(notacion, \.transformacionSinTriada)
        }
    }

    // El error de la lectura no es `Hashable` por sí mismo (`any ErrorAlLeer`): se compara con `AnyHashable`.

    public static func == (a: Self, b: Self) -> Bool { a.clave == b.clave }

    public func hash(into hasher: inout Hasher) { hasher.combine(clave) }

    private var clave: [AnyHashable] {
        switch self {
        case .secuenciaIlegible(let error): return ["secuenciaIlegible", AnyHashable(error)]
        case .sinTriada: return ["sinTriada"]
        }
    }
}
