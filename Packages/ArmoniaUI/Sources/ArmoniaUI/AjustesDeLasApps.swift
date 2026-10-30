/// Claves de los ajustes que comparten las apps.
public enum AjustesDeLasApps {
    /// La notación elegida (la `clave` de una `Notacion`), para `@AppStorage`.
    public static let claveDeNotacion = "notacionElegida"
    /// El temperamento con que suena «Escuchar» (el `rawValue` de un `Temperamento`), para `@AppStorage`.
    public static let claveDeTemperamento = "temperamentoElegido"
}
