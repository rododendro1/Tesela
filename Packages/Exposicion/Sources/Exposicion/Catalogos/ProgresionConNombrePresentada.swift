import Armonia

// MARK: - Una progresión con nombre del catálogo, escrita

/// Una progresión con nombre del catálogo (`ProgresionConNombre`), sobre una tónica, con los nombres de las claves
/// del JSON.
///
///     let andaluza = ProgresionConNombrePresentada(.andaluza, sobre: .la, en: .compacta(.espanol))
///     andaluza.cifrado    // "i VII VI V"
///     andaluza.acordes    // ["Lam", "Sol", "Fa", "Mi"]
public struct ProgresionConNombrePresentada: Hashable, Sendable, Codable {
    /// El nombre en la notación: «cadencia andaluza», «Andalusian cadence»…
    public let nombre: String
    /// Los otros nombres en el idioma de la notación.
    public let alias: [String]
    /// El cifrado romano: «i VII VI V».
    public let cifrado: String
    /// El modo en que se lee, por su nombre.
    public let modo: String
    /// Sus acordes sobre la tónica, cifrados en la notación.
    public let acordes: [String]
    /// Sus estilos, de más a menos importante, y las épocas en que se usa, por su nombre.
    public let estilos: [String]
    public let epocasDeUso: [String]
    /// Las citas de las obras donde se lee.
    public let referencias: [String]
    /// El año, la época y la obra que la documenta (`OrigenPresentado`); `nil` si no se sabe ninguno.
    public let origen: OrigenPresentado?

    public init(_ progresion: ProgresionConNombre, sobre tonica: Nota = .do, en notacion: Notacion) {
        nombre = progresion.nombre(en: notacion)
        alias = progresion.alias(en: notacion)
        cifrado = progresion.cifrado
        modo = progresion.modo.nombre(en: notacion)
        acordes = progresion.acordes(sobre: tonica).map { $0.cifrado(en: notacion) }
        estilos = progresion.estilos.map { $0.nombre(en: notacion) }
        epocasDeUso = progresion.epocasDeUso.map { $0.nombre(en: notacion) }
        referencias = progresion.referencias.map(\.cita)
        origen = OrigenPresentado(progresion, en: notacion)
    }

    /// Sus estilos y su época con el año, en una línea: «clásica · Clasicismo (1790)».
    public var estilosYOrigen: String {
        (estilos + [origen?.texto].compactMap { $0 }).joined(separator: " · ")
    }
}
