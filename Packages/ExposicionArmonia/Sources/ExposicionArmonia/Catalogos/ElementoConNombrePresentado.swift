import Armonia

// MARK: - Lo que tienen en común los catálogos presentados

/// Un elemento de uno de los catálogos con nombre (`ElementoConNombre`), escrito: `AcordeConNombrePresentado`,
/// `ProgresionConNombrePresentada`, `RitmoPresentado`, `TemperamentoPresentado`, `NotaPresentada`,
/// `FuncionDeNotaPresentada`, `OrnamentoPresentado` y `EncordadoPresentado` (que no es de un catálogo con nombre).
/// Todos llevan su nombre y sus alias en la notación, las citas de sus obras y su origen, para que la consola, la app y
/// las hojas los escriban igual.
///
///     func titulo(_ elemento: some ElementoConNombrePresentado) -> String {
///         ([elemento.nombre] + elemento.alias).joined(separator: " · ")
///     }
public protocol ElementoConNombrePresentado: Hashable, Sendable, Encodable {
    /// El nombre en la notación.
    var nombre: String { get }
    /// Los otros nombres en el idioma de la notación (`alias(en:)`).
    var alias: [String] { get }
    /// Las citas de las obras donde se lee.
    var referencias: [String] { get }
    /// El año, la época y la obra que lo documenta; `nil` si no se sabe ninguno.
    var origen: OrigenPresentado? { get }
}

extension ElementoConNombrePresentado {
    /// Las filas de la ficha que tienen todos, las que tenga: sus otros nombres y su época con el año.
    ///
    ///     TemperamentoPresentado(.werckmeisterIII, en: notacion).datosDelCatalogo(en: notacion)
    ///     // [Otros nombres: …, Época: Barroco (1691)]
    public func datosDelCatalogo(en notacion: Notacion) -> [DatoPresentado] {
        var datos: [DatoPresentado] = []
        if !alias.isEmpty {
            datos.append(DatoPresentado(nombre: notacion.texto(\.otrosNombres), valor: alias.joined(separator: " · ")))
        }
        return datos + (origen?.datos(en: notacion) ?? [])
    }

    /// La fila de los lugares de origen, si tiene alguno: «Lugares de origen: Andalucía».
    public func datosDelLugar(_ lugares: [String], en notacion: Notacion) -> [DatoPresentado] {
        guard !lugares.isEmpty else { return [] }
        return [DatoPresentado(nombre: notacion.texto(\.lugaresDeOrigen), valor: lugares.joined(separator: " · "))]
    }
}

extension TemperamentoPresentado: ElementoConNombrePresentado {}
extension NotaPresentada: ElementoConNombrePresentado {}
extension FuncionDeNotaPresentada: ElementoConNombrePresentado {}
extension RitmoPresentado: ElementoConNombrePresentado {}
extension AcordeConNombrePresentado: ElementoConNombrePresentado {}
extension ProgresionConNombrePresentada: ElementoConNombrePresentado {}
extension EncordadoPresentado: ElementoConNombrePresentado {}
extension OrnamentoPresentado: ElementoConNombrePresentado {}
