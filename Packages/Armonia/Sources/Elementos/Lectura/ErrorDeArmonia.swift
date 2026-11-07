import Foundation

/// Un error del motor con su mensaje en los quince idiomas de los textos.
///
/// Lo cumplen los errores de lectura de cada capa (`ErrorDeLectura`, `ErrorDeLecturaDeTeoria`,
/// `ErrorDeLecturaDePartitura`), el de importar una partitura (`ErrorDeLecturaDeFichero`) y el de las disposiciones de
/// teclado (`ErrorDeLecturaDeUIL`). Para mostrar cualquiera de ellos basta un solo `catch`:
///
///     do {
///         let acorde = try Acorde(leyendo: entrada)
///     } catch let error as any ErrorDeArmonia {
///         print(error.descripcion(en: notacion))
///     }
public protocol ErrorDeArmonia: LocalizedError, CustomStringConvertible, Sendable {
    /// El mensaje completo en el idioma de los textos de la notación (`notacion.textos`).
    func descripcion(en notacion: Notacion) -> String
}

extension ErrorDeArmonia {
    /// El mensaje completo, en español.
    public var description: String { descripcion(en: .espanolCompacto) }

    /// El mensaje completo, en español (el de `localizedDescription`).
    public var errorDescription: String? { description }
}

/// El motivo de un error de lectura, con su explicación en los quince idiomas de los textos.
public protocol MotivoDeLectura: Hashable, Sendable {
    /// Por qué no se pudo leer, en el idioma de los textos de la notación: «"b3" no es una tensión válida…».
    func explicacion(en notacion: Notacion) -> String
}

/// Un error al leer un texto: el texto, el carácter donde se detuvo la lectura y el motivo.
///
/// Cada capa tiene el suyo, con sus motivos: `ErrorDeLectura` (notas, alturas e intervalos),
/// `ErrorDeLecturaDeTeoria` (cifrados, escalas, tonalidades y corales) y `ErrorDeLecturaDePartitura` (duraciones,
/// compases y contrapunto). Leer un acorde puede lanzar los dos primeros: el de Elementos si falla la nota y el de
/// Teoría si falla el cifrado.
public protocol ErrorAlLeer: ErrorDeArmonia, Hashable {
    associatedtype Motivo: MotivoDeLectura
    /// Texto completo que se intentaba leer.
    var texto: String { get }
    /// Carácter (contando desde 0) donde se detuvo la lectura; `nil` cuando el problema no está en un punto
    /// concreto sino en el conjunto (por ejemplo, ° y ø a la vez).
    var posicion: Int? { get }
    var motivo: Motivo { get }

    init(texto: String, posicion: Int?, motivo: Motivo)
}

extension ErrorAlLeer {
    /// Explicación del motivo, en español.
    public var explicacion: String { explicacion(en: .espanolCompacto) }

    /// Explicación del motivo en el idioma de los textos de la notación (`notacion.textos`).
    public func explicacion(en notacion: Notacion) -> String { motivo.explicacion(en: notacion) }

    /// Mensaje completo en el idioma de los textos de la notación: «No se puede leer «Do7(b3)» (carácter 5): …».
    public func descripcion(en notacion: Notacion) -> String {
        var inicio =
            texto.isEmpty
            ? TextosDeElementos.en(notacion, \.valorNoValido)
            : TextosDeElementos.en(notacion) { $0.noSePuedeLeer(texto) }
        if let p = posicion {
            inicio += TextosDeElementos.en(notacion) { $0.caracter(p) }
        }
        // En francés, los dos puntos llevan espacio delante.
        return inicio + TextosDeElementos.en(notacion, \.dosPuntos) + explicacion(en: notacion)
    }

    /// El mismo motivo en otro texto y otra posición: el error de un trozo («Re7»), situado en el texto entero
    /// del que salió («Do Re7 Sol»).
    public func situado(en texto: String, posicion: Int?) -> Self {
        Self(texto: texto, posicion: posicion, motivo: motivo)
    }
}
