import Armonia

// MARK: - Un acorde con nombre del catálogo, escrito

/// Un acorde con nombre del catálogo (`AcordeConNombre`), sobre una nota, con los nombres de las claves del JSON.
///
///     let tristan = AcordeConNombrePresentado(.tristan, sobre: .fa, en: .compacta(.espanol))
///     tristan.notas            // ["Fa", "Si", "Re♯", "Sol♯"]
///     tristan.origen?.texto    // "Romanticismo (1859)"
public struct AcordeConNombrePresentado: Hashable, Sendable, Encodable {
    /// El nombre en la notación: «acorde de Tristán», «Tristan chord»…
    public let nombre: String
    /// Los otros nombres en el idioma de la notación.
    public let alias: [String]
    /// El cifrado sobre la nota, en los genéricos (los que dan nombre a su tipo): «Do7» para la séptima de
    /// dominante. Los de nombre propio no lo llevan, aunque sus notas se lean por terceras.
    public let cifrado: String?
    /// Sus notas sobre la nota, en la notación.
    public let notas: [String]
    /// Sus estilos, de más a menos importante, y las épocas en que se usa, por su nombre.
    public let estilos: [String]
    public let epocasDeUso: [String]
    /// Las citas de las obras donde se lee.
    public let referencias: [String]
    /// El año, la época y la obra que lo documenta (`OrigenPresentado`); `nil` si no se sabe ninguno.
    public let origen: OrigenPresentado?
    /// Lo que se mide del acorde, si se pide (`conEstadisticas`).
    public let estadisticas: EstadisticasDeAcordePresentadas?

    public init(
        _ acorde: AcordeConNombre, sobre nota: Nota = .do, conEstadisticas: Bool = false, en notacion: Notacion
    ) {
        nombre = acorde.nombre(en: notacion)
        alias = acorde.alias(en: notacion)
        if let tipo = acorde.tipo, tipo.acordeConNombre == acorde {
            cifrado = Acorde(nota, tipo).cifrado(en: notacion)
        } else {
            cifrado = nil
        }
        notas = acorde.notas(sobre: nota).map { $0.nombre(en: notacion) }
        estilos = acorde.estilos.map { $0.nombre(en: notacion) }
        epocasDeUso = acorde.epocasDeUso.map { $0.nombre(en: notacion) }
        referencias = acorde.referencias.map(\.cita)
        origen = OrigenPresentado(acorde, en: notacion)
        estadisticas = conEstadisticas ? EstadisticasDeAcordePresentadas(acorde.estadisticas, en: notacion) : nil
    }

    /// Sus estilos y su época con el año, en una línea: «clásica · Romanticismo (1859)».
    public var estilosYOrigen: String {
        (estilos + [origen?.texto].compactMap { $0 }).joined(separator: " · ")
    }
}
