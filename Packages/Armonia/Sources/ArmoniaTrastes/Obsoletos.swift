// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología, para que el código que los usa siga compilando (con un
// aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

extension Encordado {
    /// Ahora `Encordado.bajoElectrico`: `bajo` es también la nota más grave de un acorde.
    @available(*, deprecated, renamed: "bajoElectrico")
    public static var bajo: Encordado { bajoElectrico }
}
