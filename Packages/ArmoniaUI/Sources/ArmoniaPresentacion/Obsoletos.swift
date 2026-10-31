import Armonia

// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología, para que el código que los usa siga compilando (con un
// aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

/// Ahora `PentagramaPresentado`.
@available(*, deprecated, renamed: "PentagramaPresentado")
public typealias PresentacionDePentagrama = PentagramaPresentado

/// Ahora `AnalisisPostonalPresentado`.
@available(*, deprecated, renamed: "AnalisisPostonalPresentado")
public typealias PresentacionPostonal = AnalisisPostonalPresentado

/// Ahora `Escucha`: «sonido» es también otro nombre de la altura.
@available(*, deprecated, renamed: "Escucha")
public typealias Sonido = Escucha

extension AnalisisPresentado {
    /// Ahora `rearmonizaciones(en:)`.
    @available(*, deprecated, renamed: "rearmonizaciones(en:)")
    public func rearmonizaciones(notacion: Notacion) -> [PropuestaDeRearmonizacion] { rearmonizaciones(en: notacion) }
}
