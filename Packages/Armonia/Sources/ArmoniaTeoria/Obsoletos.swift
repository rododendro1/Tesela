// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension ModoDeEscala {
    /// El nombre de antes de `grado`.
    @available(*, deprecated, renamed: "grado")
    public var modo: Int { grado }
}
