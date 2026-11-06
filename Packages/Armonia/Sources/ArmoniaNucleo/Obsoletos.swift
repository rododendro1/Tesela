// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension RepresentableComoTexto {
    /// Lo de antes de `try? T(leyendo:)`: el valor de un texto, o `nil` si no se puede leer.
    @available(*, deprecated, message: "usa try? T(leyendo:)")
    public init?(texto: String) {
        guard let valor = try? Self(leyendo: texto) else { return nil }
        self = valor
    }
}
