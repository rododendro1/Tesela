import Armonia

/// Claves de los ajustes que comparten las apps.
public enum AjustesDeLasApps {
    /// La notación elegida (la `clave` de una `Notacion`), para `@AppStorage`.
    public static let claveDeNotacion = "notacionElegida"
    /// Si la octava de las alturas se escribe como subíndice (La₄) en lugar de con cifras (La4), para
    /// `@AppStorage`. Va aparte de la notación para que la clave de esta siga siendo la misma. Mientras no se
    /// toque, no se guarda nada y la octava va como la escriba la notación (en subíndice en las compactas).
    public static let claveDeOctavasEnSubindice = "octavasEnSubindice"
    /// El temperamento con que suena «Escuchar» (su ``claveDeTemperamento(_:)``), para `@AppStorage`.
    public static let claveDeTemperamento = "temperamentoElegido"

    /// Lo que se guarda de cada temperamento de `TemperamentoQueAfina.paraEscuchar`. Son las claves de siempre, así
    /// que lo que ya estaba guardado se sigue leyendo.
    private static let clavesDeTemperamentos: [(clave: String, temperamento: TemperamentoQueAfina)] = [
        ("igual", .temperamentoIgual), ("pitagorico", .pitagorico), ("mesotonico", .mesotonicoCuartoDeComa),
        ("werckmeisterIII", .werckmeisterIII), ("kirnbergerIII", .kirnbergerIII), ("vallotti", .vallotti),
        ("young", .young), ("justa", .afinacionJusta),
    ]

    /// La clave con que se guarda un temperamento: «mesotonico»; su nombre si no es de los de escuchar.
    public static func claveDeTemperamento(_ temperamento: TemperamentoQueAfina) -> String {
        clavesDeTemperamentos.first { $0.temperamento == temperamento }?.clave ?? temperamento.nombre
    }

    /// El temperamento guardado con esa clave, o `nil` si no es ninguno o no afina las notas.
    public static func temperamento(deClave clave: String) -> TemperamentoQueAfina? {
        clavesDeTemperamentos.first { $0.clave == clave }?.temperamento
            ?? TemperamentoConNombre.buscar(nombre: clave).flatMap(TemperamentoQueAfina.init)
    }
}
