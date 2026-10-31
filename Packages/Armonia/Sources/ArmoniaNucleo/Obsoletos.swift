// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología, para que el código que los usa siga compilando (con un
// aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

extension Altura {
    /// El La4: ahora `Altura.la4`.
    @available(*, deprecated, renamed: "la4")
    public static var la440: Altura { la4 }

    /// Ahora `frecuencia(frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "frecuencia(frecuenciaDelLa4:)")
    public func frecuencia(la4: Double) -> Double { frecuencia(frecuenciaDelLa4: la4) }
}
