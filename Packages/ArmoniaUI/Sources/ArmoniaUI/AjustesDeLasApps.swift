/// Claves de los ajustes que comparten las apps.
public enum AjustesDeLasApps {
    /// La notación elegida (la `clave` de una `Notacion`), para `@AppStorage`.
    public static let claveDeNotacion = "notacionElegida"
    /// Si la octava de las alturas se escribe como subíndice (La₄) en lugar de con cifras (La4), para
    /// `@AppStorage`. Va aparte de la notación para que la clave de esta siga siendo la misma.
    public static let claveDeOctavasEnSubindice = "octavasEnSubindice"
    /// El temperamento con que suena «Escuchar» (el `rawValue` de una `AfinacionHistorica`), para `@AppStorage`.
    public static let claveDeTemperamento = "temperamentoElegido"
}
