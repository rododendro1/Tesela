import ArmoniaNucleo

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension Voz {
    /// La forma de antes, con la notación española por omisión: ahora se da siempre, como en el resto de la API.
    @available(*, deprecated, message: "usa texto(en: .espanolCompacto)")
    public func texto() -> String { texto(en: .espanolCompacto) }
}

extension Contrapunto {
    /// La forma de antes, con la notación española por omisión: ahora se da siempre, como en el resto de la API.
    @available(*, deprecated, message: "usa informe(en: .espanolCompacto)")
    public func informe() -> String { informe(en: .espanolCompacto) }
}
