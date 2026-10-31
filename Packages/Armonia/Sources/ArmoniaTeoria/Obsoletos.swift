import ArmoniaNucleo

// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología, para que el código que los usa siga compilando (con un
// aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

/// Ahora `CategoriaTradicional`: «clase» es la clase de altura.
@available(*, deprecated, renamed: "CategoriaTradicional")
public typealias ClaseDeEscala = CategoriaTradicional

extension TipoDeEscala {
    /// Ahora `categoria`.
    @available(*, deprecated, renamed: "categoria")
    public var clase: CategoriaTradicional? { categoria }

    /// Ahora `tradicionales(categoria:)`.
    @available(*, deprecated, renamed: "tradicionales(categoria:)")
    public static func tradicionales(clase: CategoriaTradicional) -> [TipoDeEscala] { tradicionales(categoria: clase) }
}
