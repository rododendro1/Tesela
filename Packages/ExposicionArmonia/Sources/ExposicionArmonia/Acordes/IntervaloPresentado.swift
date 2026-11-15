import Armonia

// Lo que se consulta de un intervalo, sin darle forma: lo mismo para el texto de `armonia intervalo` y para su salida
// `--json`. Sus nombres son las claves del JSON: en español, sin tildes y siempre las mismas, sea cual sea el idioma.

/// Un intervalo: su nombre, su abreviatura, sus semitonos y su número.
///
///     let datos = IntervaloPresentado(Altura(.mi, octava: 5) - Altura(.do, octava: 4), en: .compacta(.espanol))
///     datos.numero      // 10
///     datos.semitonos   // 16
public struct IntervaloPresentado: Hashable, Sendable, Codable {
    public let nombre: String
    /// «3M», en la notación.
    public let abreviatura: String
    public let semitonos: Int
    /// 3 en una tercera, 10 en una décima.
    public let numero: Int
    public let descendente: Bool

    public init(_ intervalo: Intervalo, en notacion: Notacion) {
        nombre = intervalo.nombre(en: notacion)
        abreviatura = intervalo.texto(en: notacion)
        semitonos = intervalo.semitonos
        numero = intervalo.numero
        descendente = intervalo.sentido == .descendente
    }
}
