import ArmoniaNucleo

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension Mastil {
    /// Con sostenidos, o con bemoles si `preferirBemoles`.
    @available(*, deprecated, message: "usa alturaSiExiste(en:ventana:) con .bemoles o .sostenidos")
    public func alturaSiExiste(en posicion: PosicionEnElMastil, preferirBemoles: Bool) -> Altura? {
        alturaSiExiste(en: posicion, ventana: preferirBemoles ? .bemoles : .sostenidos)
    }

    /// Con sostenidos, o con bemoles si `preferirBemoles`.
    @available(*, deprecated, message: "usa altura(en:ventana:) con .bemoles o .sostenidos")
    public func altura(en posicion: PosicionEnElMastil, preferirBemoles: Bool) -> Altura {
        altura(en: posicion, ventana: preferirBemoles ? .bemoles : .sostenidos)
    }
}
