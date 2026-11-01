// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología y de las notaciones compactas, para que el código que
// los usa siga compilando (con un aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

extension Altura {
    /// El La4: ahora `Altura.la4`.
    @available(*, deprecated, renamed: "la4")
    public static var la440: Altura { la4 }

    /// Ahora `frecuencia(frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "frecuencia(frecuenciaDelLa4:)")
    public func frecuencia(la4: Double) -> Double { frecuencia(frecuenciaDelLa4: la4) }
}

extension Notacion {
    /// Ahora `Notacion.espanolCompacto`, que escribe la octava como subíndice (La₄).
    @available(*, deprecated, renamed: "espanolCompacto")
    public static var espanolUnicode: Notacion { espanolCompacto }

    /// Ahora `Notacion.inglesCompacto`, que escribe la octava como subíndice (A₄).
    @available(*, deprecated, renamed: "inglesCompacto")
    public static var inglesUnicode: Notacion { inglesCompacto }
}

extension EscrituraDeNotas {
    /// Ahora `EscrituraDeNotas.espanolCompacto`.
    @available(*, deprecated, renamed: "espanolCompacto")
    public static var espanolUnicode: EscrituraDeNotas { espanolCompacto }

    /// Ahora `EscrituraDeNotas.inglesCompacto`.
    @available(*, deprecated, renamed: "inglesCompacto")
    public static var inglesUnicode: EscrituraDeNotas { inglesCompacto }
}

extension EstiloDeCifrado {
    /// Ahora `EstiloDeCifrado.inglesCompacto`.
    @available(*, deprecated, renamed: "inglesCompacto")
    public static var inglesUnicode: EstiloDeCifrado { inglesCompacto }
}
