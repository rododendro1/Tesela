extension LineaDeComandos {
    /// La versión de `armonia` (`armonia --version`), la de las releases. La cambia
    /// `Scripts/comprobaciones/notas_de_version.py --publicar` a la vez que `MARKETING_VERSION` de `project.yml`, y
    /// `--comprobar` (en el CI) falla si no coinciden.
    public static let version = "0.3.6"
}
