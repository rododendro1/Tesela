import Armonia

// MARK: - El origen de un elemento del catálogo

/// De cuándo es un elemento de uno de los catálogos con nombre (`ElementoConNombre`), escrito: su año, su época y la
/// obra que lo documenta. Es lo mismo para las escalas, los acordes, las progresiones, los ritmos, los temperamentos,
/// las notas y las funciones, para que la consola, la app y las hojas lo escriban igual en todos.
///
///     let origen = OrigenPresentado(TemperamentoConNombre.werckmeisterIII, en: .compacta(.espanol))
///     origen?.texto      // "Barroco (1691)"
///     origen?.datos(en: .compacta(.espanol)).first   // Época: Barroco (1691)
public struct OrigenPresentado: Hashable, Sendable, Codable {
    /// El año en que aparece (`anioDeOrigen`), si se sabe. Los de antes de Cristo son negativos.
    public let anio: Int?
    /// La época en que aparece (`epocaDeOrigen`), por su nombre.
    public let epoca: String?
    /// La cita de la obra más antigua que lo documenta (`documentada`), si la tiene.
    public let documentada: String?

    /// El origen del elemento, o `nil` si no se sabe nada de él.
    public init?(_ elemento: some ElementoConNombre, en notacion: Notacion) {
        anio = elemento.anioDeOrigen
        epoca = elemento.epocaDeOrigen?.nombre(en: notacion)
        documentada = elemento.documentada?.cita
        if anio == nil, epoca == nil, documentada == nil { return nil }
    }

    /// La época con el año entre paréntesis, «Barroco (1691)»; solo el año, si no hay época; `nil` si no hay
    /// ninguno.
    public var texto: String? {
        guard let epoca else { return anio.map { "\($0)" } }
        return epoca + (anio.map { " (\($0))" } ?? "")
    }

    /// La época y el año, en una fila: «Época: Barroco (1691)»; ninguna si no se saben.
    public func datos(en notacion: Notacion) -> [DatoPresentado] {
        guard let texto else { return [] }
        return [DatoPresentado(nombre: notacion.texto(\.epocaDeOrigen), valor: texto)]
    }
}
