import Elementos

/// Error al leer un cifrado, un cifrado romano, un bajo cifrado, una escala, una tonalidad, los acordes de un coral, un
/// nombre (un patrón de arpegio, una aproximación, un ciclo neorriemanniano, un instrumento) o una digitación.
///
/// Como `ErrorDeLectura`, indica el texto, el carácter donde se detuvo la lectura y el motivo, en los quince
/// idiomas de los textos. Leer un acorde puede lanzar cualquiera de los dos: `ErrorDeLectura` si falla la
/// fundamental y `ErrorDeLecturaDeTeoria` si falla el cifrado. Para tratarlos juntos, `any ErrorAlLeer`:
///
///     do {
///         let acorde = try Acorde(leyendo: "Do7(b3)")
///     } catch let error as ErrorDeLecturaDeTeoria {
///         error.motivo   // .tensionNoValida("b3")
///         print(error)   // No se puede leer «Do7(b3)» (carácter 4): «b3» no es una tensión válida…
///     }
public struct ErrorDeLecturaDeTeoria: ErrorAlLeer {
    /// Por qué no se pudo leer, con lo que hace falta para explicarlo en cada idioma (`explicacion(en:)`).
    public enum Motivo: MotivoDeLectura {
        // Cifrados
        case simboloNoReconocido(String)
        case tensionNoValida(String)
        case numeroDeAcordeNoValido(Int)
        case numeroRepetido(Int)
        case calidadesIncompatibles(CalidadesIncompatibles)
        case gradoNoOmitible(Int)
        case acordeNoInterpretable(RechazoDeAcorde)
        case bajoNoValido(String)
        /// Un nombre de nota escrito en otro idioma que el resto ("Sol7/B" en lugar de "Sol7/Si").
        case idiomasMezclados(String)
        // Escalas y tonalidades
        case tipoDeEscalaNoReconocido(String)
        case modoNoReconocido(String)
        // Corales
        /// Los acordes de una conducción de voces no tienen todos el mismo número de voces (o tienen menos de dos).
        case vocesDistintas
        /// Las voces de un coral, dadas voz por voz, no tienen todas el mismo número de notas.
        case vocesDeDistintaLongitud
        // Nombres
        /// Un nombre que no es ninguno de los que se leen (un patrón de arpegio, una aproximación, un ciclo), con los
        /// que sí, por su nombre en el código.
        case nombreNoReconocido(String, opciones: [String])
        /// Algo que no es un número entre `desde` y `hasta` (un grado de arpegio: de 1 a 22).
        case numeroFueraDeRango(String, desde: Int, hasta: Int)
        // Digitaciones
        /// Un traste que no es `x` ni un número del mástil (de 0 a `ultimo`).
        case trasteNoValido(String, ultimo: Int)
        /// Una digitación sin un traste por cuerda.
        case cuerdasDistintas(esperadas: Int, leidas: Int)
        // Cifrado romano y bajo cifrado
        /// Algo que no es un cifrado romano: ni un numeral del I al VII (o «subV», «N», «It+6»…) con su calidad y
        /// sus cifras.
        case cifradoRomanoNoValido(String)
        /// Lo que va tras la barra de un cifrado romano («V7/vii°») no es una tríada mayor o menor en estado
        /// fundamental, así que no hay tonalidad hacia la que ir.
        case destinoNoTonicalizable(String)
        /// Unas cifras de bajo continuo con algo que no es una cifra ni una alteración, o con dos alteraciones
        /// seguidas.
        case cifrasNoValidas(String)
        /// Unas cifras que se leen, pero cuyas notas sobre el bajo no forman ningún acorde.
        case cifrasSinAcorde(String)
    }

    /// Símbolos de un cifrado que no pueden ir juntos.
    public enum CalidadesIncompatibles: Hashable, Sendable {
        /// ° y ø a la vez ("Dodimø").
        case disminuidoYSemidisminuido
        /// El acorde de quinta con m, °, ø o + ("Dom5").
        case quintaConCalidad
    }

    /// Por qué un conjunto de notas no es un acorde por terceras.
    public enum RechazoDeAcorde: Hashable, Sendable {
        case faltaLaFundamental
        /// Un intervalo que no es tercera, quinta, séptima ni tensión (la 1ª aumentada, por ejemplo).
        case intervaloSinPapel(Intervalo)
        case terceraMayorYMenor
        case variasSeptimas
        case septimaDisminuidaFueraDelDisminuido
        case noEsPorTerceras
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

extension Lector {
    /// Error de Teoría en la posición actual.
    package func error(_ motivo: ErrorDeLecturaDeTeoria.Motivo) -> ErrorDeLecturaDeTeoria {
        ErrorDeLecturaDeTeoria(texto: texto, posicion: posicion, motivo: motivo)
    }

    /// Error de Teoría en una posición concreta (`nil` si el problema no está en un punto del texto).
    package func error(_ motivo: ErrorDeLecturaDeTeoria.Motivo, posicion: Int?) -> ErrorDeLecturaDeTeoria {
        ErrorDeLecturaDeTeoria(texto: texto, posicion: posicion, motivo: motivo)
    }
}

// MARK: - Idiomas
//
// Los mensajes en los quince idiomas de los textos, una función por motivo, para que un motivo nuevo no compile
// hasta que tiene su texto. Los textos están en `TextosDeTeoria`.

extension ErrorDeLecturaDeTeoria.Motivo {
    public func explicacion(en notacion: Notacion) -> String {
        explicacionTraducida(notacion).en(notacion)
    }

    /// La explicación en los quince idiomas de los textos. La notación solo hace falta para los
    /// nombres de los intervalos, que siguen su vocabulario.
    private func explicacionTraducida(_ notacion: Notacion) -> Traduccion {
        switch self {
        case .simboloNoReconocido(let simbolo): return TextosDeTeoria.traduccion { $0.simboloNoReconocido(simbolo) }
        case .tensionNoValida(let tension): return TextosDeTeoria.traduccion { $0.tensionNoValida(tension) }
        case .numeroDeAcordeNoValido(let numero):
            return TextosDeTeoria.traduccion { $0.numeroDeAcordeNoValido(numero) }
        case .numeroRepetido(let numero): return TextosDeTeoria.traduccion { $0.numeroRepetido(numero) }
        case .calidadesIncompatibles(.disminuidoYSemidisminuido):
            return TextosDeTeoria.traduccion(\.disminuidoYSemidisminuido)
        case .calidadesIncompatibles(.quintaConCalidad): return TextosDeTeoria.traduccion(\.quintaConCalidad)
        case .gradoNoOmitible(let grado):
            return grado == 1
                ? TextosDeTeoria.traduccion(\.fundamentalNoOmitible)
                : TextosDeTeoria.traduccion { $0.gradoNoOmitible(grado) }
        case .acordeNoInterpretable(let rechazo): return Self.rechazo(rechazo, en: notacion)
        case .bajoNoValido(let bajo): return TextosDeTeoria.traduccion { $0.bajoNoValido(bajo) }
        case .idiomasMezclados(let nombre): return TextosDeTeoria.traduccion { $0.idiomasMezclados(nombre) }
        case .tipoDeEscalaNoReconocido(let nombre):
            return nombre.isEmpty
                ? TextosDeTeoria.traduccion(\.faltaElTipoDeEscala)
                : TextosDeTeoria.traduccion { $0.tipoDeEscalaNoReconocido(nombre) }
        case .modoNoReconocido(let nombre): return TextosDeTeoria.traduccion { $0.modoNoReconocido(nombre) }
        case .vocesDistintas: return TextosDeTeoria.traduccion(\.vocesDistintas)
        case .vocesDeDistintaLongitud: return TextosDeTeoria.traduccion(\.vocesDeDistintaLongitud)
        case .nombreNoReconocido(let nombre, let opciones):
            return TextosDeTeoria.traduccion { $0.nombreNoReconocido(nombre, opciones.joined(separator: ", ")) }
        case .numeroFueraDeRango(let texto, let desde, let hasta):
            return TextosDeTeoria.traduccion { $0.numeroFueraDeRango(texto, desde, hasta) }
        case .trasteNoValido(let traste, let ultimo):
            return TextosDeTeoria.traduccion { $0.trasteNoValido(traste, ultimo) }
        case .cuerdasDistintas(let esperadas, let leidas):
            return TextosDeTeoria.traduccion { $0.cuerdasDistintas(esperadas, leidas) }
        case .cifradoRomanoNoValido(let cifrado):
            return TextosDeTeoria.traduccion { $0.cifradoRomanoNoValido(cifrado) }
        case .destinoNoTonicalizable(let destino):
            return TextosDeTeoria.traduccion { $0.destinoNoTonicalizable(destino) }
        case .cifrasNoValidas(let cifras): return TextosDeTeoria.traduccion { $0.cifrasNoValidas(cifras) }
        case .cifrasSinAcorde(let cifras): return TextosDeTeoria.traduccion { $0.cifrasSinAcorde(cifras) }
        }
    }

    private static func rechazo(_ rechazo: ErrorDeLecturaDeTeoria.RechazoDeAcorde, en notacion: Notacion)
        -> Traduccion
    {
        switch rechazo {
        case .faltaLaFundamental: return TextosDeTeoria.traduccion(\.faltaLaFundamental)
        case .intervaloSinPapel(let intervalo):
            return TextosDeTeoria.traduccion { $0.intervaloSinPapel(intervalo, notacion) }
        case .terceraMayorYMenor: return TextosDeTeoria.traduccion(\.terceraMayorYMenor)
        case .variasSeptimas: return TextosDeTeoria.traduccion(\.variasSeptimas)
        case .septimaDisminuidaFueraDelDisminuido:
            return TextosDeTeoria.traduccion(\.septimaDisminuidaFueraDelDisminuido)
        case .noEsPorTerceras: return TextosDeTeoria.traduccion(\.noEsPorTerceras)
        }
    }
}
