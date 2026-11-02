// MARK: - Nombres obsoletos
//
// Los nombres de antes, para que el código que los usa siga compilando (con un aviso que dice el nombre nuevo).
// Se quitarán en la próxima versión 0.x.

extension Tipografia {
    /// 𝄪 y 𝄫 para cada pareja de signos: ahora `Tipografia.conDobles`, para no confundirla con las notaciones
    /// compactas, que usan `.unicode`.
    @available(*, deprecated, renamed: "conDobles")
    public static var compacta: Tipografia { .conDobles }
}

extension Alteracion {
    /// Los signos con 𝄪 y 𝄫: ahora `simboloConDobles`.
    @available(*, deprecated, renamed: "simboloConDobles")
    public var simboloCompacto: String { simboloConDobles }
}
