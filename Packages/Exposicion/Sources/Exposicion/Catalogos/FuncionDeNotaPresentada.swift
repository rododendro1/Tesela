import Armonia

// MARK: - Una función de nota del catálogo, escrita

/// Una función de nota del catálogo (`FuncionDeNota`), con los nombres de las claves del JSON.
///
///     let septima = FuncionDeNotaPresentada(.septimaBlue, en: .compacta(.espanol))
///     septima.intervalo   // "7m"
///     septima.desvio      // -31.17…
public struct FuncionDeNotaPresentada: Hashable, Sendable, Codable {
    /// El nombre en la notación: «dominante», «dominant»…
    public let nombre: String
    /// Los otros nombres en el idioma de la notación.
    public let alias: [String]
    public let familia: String
    /// El intervalo desde la tónica, escrito en la notación, si es siempre el mismo.
    public let intervalo: String?
    /// Los cents desde la tónica, si tiene intervalo.
    public let cents: Double?
    /// Lo que se aparta del intervalo temperado.
    public let desvio: Double
    /// Las citas de las obras donde se lee.
    public let referencias: [String]
    /// El año, la época y la obra que lo documenta (`OrigenPresentado`); `nil` si no se sabe ninguno.
    public let origen: OrigenPresentado?

    public init(_ funcion: FuncionDeNota, en notacion: Notacion) {
        nombre = funcion.nombre(en: notacion)
        alias = funcion.alias(en: notacion)
        familia = funcion.familia.nombre(en: notacion)
        intervalo = funcion.intervalo?.nombre(en: notacion)
        cents = funcion.cents
        desvio = funcion.desvio
        referencias = funcion.referencias.map(\.cita)
        origen = OrigenPresentado(funcion, en: notacion)
    }

    /// La ficha, un dato por fila: la familia, los otros nombres y la época (`datosDelCatalogo(en:)`), el intervalo,
    /// los cents y el desvío, los que tenga.
    public func ficha(en notacion: Notacion) -> [DatoPresentado] {
        var datos = [DatoPresentado(nombre: notacion.texto(\.familiaDeLaNota), valor: familia)]
        datos += datosDelCatalogo(en: notacion)
        if let intervalo {
            datos.append(DatoPresentado(nombre: notacion.texto(\.intervaloDeLaFuncion), valor: intervalo))
        }
        if let cents {
            datos.append(
                DatoPresentado(nombre: notacion.texto(\.centsDeLaFuncion), valor: TemperamentoPresentado.cents(cents)))
        }
        if desvio != 0 {
            datos.append(
                DatoPresentado(
                    nombre: notacion.texto(\.desvioDeLaNota), valor: TemperamentoPresentado.conSigno(desvio) + " ¢"))
        }
        return datos
    }
}
