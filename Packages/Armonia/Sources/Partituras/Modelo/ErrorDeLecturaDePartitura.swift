import Elementos

/// Error al leer una duración, un compás o un contrapunto.
///
/// Como `ErrorDeLectura`, indica el texto, el carácter donde se detuvo la lectura y el motivo, en los trece
/// idiomas de los textos. Leer una melodía puede lanzar los dos: `ErrorDeLectura` si falla una nota y
/// `ErrorDeLecturaDePartitura` si falla una duración. Para tratarlos juntos, `any ErrorAlLeer`:
///
///     do {
///         let duracion = try Duracion(leyendo: "3")
///     } catch let error as ErrorDeLecturaDePartitura {
///         error.motivo   // .duracionNoValida("3")
///     }
public struct ErrorDeLecturaDePartitura: ErrorAlLeer {
    /// Por qué no se pudo leer, con lo que hace falta para explicarlo en cada idioma (`explicacion(en:)`).
    public enum Motivo: MotivoDeLectura {
        case duracionNoValida(String)
        case compasNoValido(String)
        /// El contrapunto no dura lo mismo que el cantus firmus: una redonda por cada nota.
        case contrapuntoDeOtraDuracion(redondas: Int)
    }

    public let texto: String
    public let posicion: Int?
    public let motivo: Motivo

    /// El error de leer `texto`, detenido en el carácter `posicion` (desde 0; `nil` si no es en un punto).
    public init(texto: String, posicion: Int?, motivo: Motivo) {
        self.texto = texto
        self.posicion = posicion
        self.motivo = motivo
    }
}

// MARK: - Idiomas
//
// Los mensajes en los trece idiomas de los textos, que están en `TextosDePartituras`.

extension ErrorDeLecturaDePartitura.Motivo {
    public func explicacion(en notacion: Notacion) -> String {
        switch self {
        case .duracionNoValida(let texto): return TextosDePartituras.en(notacion) { $0.duracionNoValida(texto) }
        case .compasNoValido(let texto): return TextosDePartituras.en(notacion) { $0.compasNoValido(texto) }
        case .contrapuntoDeOtraDuracion(let redondas):
            return TextosDePartituras.en(notacion) { $0.contrapuntoDeOtraDuracion(redondas) }
        }
    }
}
