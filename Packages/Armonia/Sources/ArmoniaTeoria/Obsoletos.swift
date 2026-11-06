import ArmoniaNucleo

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension TipoDeEscala {
    /// El nombre de antes de `occidentales`: no son todas las escalas, sino las occidentales (todas están en
    /// `catalogo`).
    @available(*, deprecated, renamed: "occidentales")
    public static var todos: [TipoDeEscala] { occidentales }

    /// El nombre de antes de `occidentales(uso:)`.
    @available(*, deprecated, renamed: "occidentales(uso:)")
    public static func todos(uso: UsoDeEscala) -> [TipoDeEscala] { occidentales(uso: uso) }
}

extension Acorde {
    /// El nombre de antes de `cambiarInversion(_:)`, que se confundía con la inversión en espejo de las melodías y los
    /// conjuntos de clases de altura.
    @available(*, deprecated, renamed: "cambiarInversion(_:)")
    public func invertir(_ inversion: Int) -> Acorde { cambiarInversion(inversion) }
}

extension EscalaVecina {
    /// El nombre de antes de `desde`.
    @available(*, deprecated, renamed: "desde")
    public var de: Nota { desde }
    /// El nombre de antes de `hasta`.
    @available(*, deprecated, renamed: "hasta")
    public var a: Nota { hasta }

    /// El inicializador de antes, con `de` y `a` en lugar de `desde` y `hasta`.
    @available(*, deprecated, renamed: "init(escala:desde:hasta:)")
    public init(escala: Escala, de: Nota, a: Nota) { self.init(escala: escala, desde: de, hasta: a) }
}

extension MapaDeBrillo.Enlace {
    /// El nombre de antes de `desde`.
    @available(*, deprecated, renamed: "desde")
    public var de: Nota { desde }
    /// El nombre de antes de `hasta`.
    @available(*, deprecated, renamed: "hasta")
    public var a: Nota { hasta }
}
