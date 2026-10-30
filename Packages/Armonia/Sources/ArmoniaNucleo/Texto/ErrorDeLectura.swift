import Foundation

/// Error al leer un texto: una nota, un intervalo, un cifrado, una escala, una voz con su ritmo, unos
/// acordes a varias voces…
///
/// Indica el texto, el carácter donde se detuvo la lectura y el motivo, en los catorce idiomas de los
/// textos (`Traduccion`):
///
///     do {
///         let acorde = try Acorde(leyendo: "Do7(b3)")
///     } catch let error as ErrorDeLectura {
///         print(error)   // No se puede leer «Do7(b3)» (carácter 5): «b3» no es una tensión válida…
///         error.descripcion(en: .inglesASCII)   // Cannot read "Do7(b3)" (character 5): "b3" is not a valid tension…
///     }

public struct ErrorDeLectura: Error, Hashable, Sendable, CustomStringConvertible {
    public enum Motivo: Hashable, Sendable {
        case textoVacio
        case notaNoReconocida
        case caracteresSobrantes(String)
        case octavaNoValida(String)
        case numeroDeIntervaloNoValido(String)
        case calidadNoValida(String)
        case intervaloInexistente(numero: Int, calidad: CalidadDeIntervalo)
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
        case tipoDeEscalaNoReconocido(String)
        case modoNoReconocido(String)
        case alteracionNoReconocida(String)
        case duracionNoValida(String)
        case compasNoValido(String)
        /// Los acordes de una conducción de voces no tienen todos el mismo número de voces (o tienen menos de dos).
        case vocesDistintas
        /// El contrapunto no dura lo mismo que el cantus firmus: una redonda por cada nota.
        case contrapuntoDeOtraDuracion(redondas: Int)
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

    /// Texto completo que se intentaba leer.
    public let texto: String
    /// Carácter (contando desde 0) donde se detuvo la lectura; `nil` cuando el problema
    /// no está en un punto concreto sino en el conjunto (por ejemplo, ° y ø a la vez).
    public let posicion: Int?
    public let motivo: Motivo

    public init(texto: String, posicion: Int?, motivo: Motivo) {
        self.texto = texto
        self.posicion = posicion
        self.motivo = motivo
    }
}

extension ErrorDeLectura: LocalizedError {
    public var errorDescription: String? { description }
}
