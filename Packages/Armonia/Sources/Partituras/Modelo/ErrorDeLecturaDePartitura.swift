import Elementos
import Teoria

/// Error al leer una duración, un compás o un contrapunto.
///
/// Como `ErrorDeLectura`, indica el texto, el carácter donde se detuvo la lectura y el motivo, en los trece
/// idiomas de los textos. Es el único que lanzan las lecturas de Partituras: si falla una nota de una melodía, su
/// motivo es `.elementos` con el de `ErrorDeLectura`, y si falla un cifrado, `.teoria`.
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
        /// La melodía o la voz solo tiene silencios: no hay ninguna nota que armonizar.
        case melodiaSinNotas
        /// Lo que falla en una nota o una altura del texto: el motivo de `ErrorDeLectura`.
        case elementos(ErrorDeLectura.Motivo)
        /// Lo que falla en un cifrado del texto: el motivo de `ErrorDeLecturaDeTeoria`.
        case teoria(ErrorDeLecturaDeTeoria.Motivo)
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

extension ErrorDeLecturaDePartitura.Motivo {
    /// El de `.elementos` (o `.teoria`), el de la capa de debajo; `nil` en los demás.
    public var motivoDeDebajo: (any MotivoDeLectura)? {
        switch self {
        case .elementos(let motivo): return motivo
        case .teoria(let motivo): return motivo
        default: return nil
        }
    }
}

extension ErrorDeLecturaDePartitura.Motivo {
    /// El nombre del caso, que no cambia con el idioma ni con lo que lleva: `duracionNoValida`. Es el `tipo` de los
    /// errores en JSON de la consola.
    public var identificador: String {
        switch self {
        case .duracionNoValida: return "duracionNoValida"
        case .compasNoValido: return "compasNoValido"
        case .contrapuntoDeOtraDuracion: return "contrapuntoDeOtraDuracion"
        case .melodiaSinNotas: return "melodiaSinNotas"
        case .elementos: return "elementos"
        case .teoria: return "teoria"
        }
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
        case .melodiaSinNotas: return TextosDePartituras.en(notacion, \.melodiaSinNotas)
        case .elementos(let motivo): return motivo.explicacion(en: notacion)
        case .teoria(let motivo): return motivo.explicacion(en: notacion)
        }
    }
}

extension ErrorDeLecturaDePartitura {
    /// El error de una nota o una altura de lo que se leía, como error de Partituras: el mismo texto, la misma
    /// posición y el motivo dentro de `.elementos`.
    public init(_ error: ErrorDeLectura) {
        self.init(texto: error.texto, posicion: error.posicion, motivo: .elementos(error.motivo))
    }

    /// El error de un cifrado de lo que se leía, como error de Partituras (`.teoria`). Si era de una nota del
    /// cifrado (`.elementos` de Teoría), lo sigue siendo.
    public init(_ error: ErrorDeLecturaDeTeoria) {
        if case .elementos(let motivo) = error.motivo {
            self.init(texto: error.texto, posicion: error.posicion, motivo: .elementos(motivo))
        } else {
            self.init(texto: error.texto, posicion: error.posicion, motivo: .teoria(error.motivo))
        }
    }
}

/// Lee con una lectura de Elementos y, si falla, lanza su error como error de Partituras (`init(_:)`).
///
///     func nota(_ texto: String) throws(ErrorDeLecturaDePartitura) -> Nota {
///         try enPartituras(Nota(leyendo: texto))
///     }
public func enPartituras<Valor>(
    _ leer: @autoclosure () throws(ErrorDeLectura) -> Valor
) throws(ErrorDeLecturaDePartitura) -> Valor {
    do { return try leer() } catch { throw ErrorDeLecturaDePartitura(error) }
}

/// Lee con una lectura de Teoría (un acorde, una tonalidad) y, si falla, lanza su error como error de Partituras
/// (`init(_:)`).
///
///     func acorde(_ texto: String) throws(ErrorDeLecturaDePartitura) -> Acorde {
///         try enPartituras(deTeoria: Acorde(leyendo: texto))
///     }
public func enPartituras<Valor>(
    deTeoria leer: @autoclosure () throws(ErrorDeLecturaDeTeoria) -> Valor
) throws(ErrorDeLecturaDePartitura) -> Valor {
    do { return try leer() } catch { throw ErrorDeLecturaDePartitura(error) }
}
