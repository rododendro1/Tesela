import ArmoniaNucleo

// MARK: - Nombres obsoletos
//
// Los nombres de antes de la revisión de la terminología, para que el código que los usa siga compilando (con un
// aviso que dice el nombre nuevo). Se quitarán en la próxima versión 0.x.

/// Ahora `AfinacionHistorica`: incluye la afinación justa, que no es un temperamento.
@available(*, deprecated, renamed: "AfinacionHistorica")
public typealias Temperamento = AfinacionHistorica

/// Ahora `AfinacionJusta`.
@available(*, deprecated, renamed: "AfinacionJusta")
public typealias EntonacionJusta = AfinacionJusta

extension AfinacionHistorica {
    /// Ahora `afinacion(tonica:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "afinacion(tonica:frecuenciaDelLa4:)")
    public func afinacion(tonica: Nota, la4: Double) -> any Afinacion {
        afinacion(tonica: tonica, frecuenciaDelLa4: la4)
    }
}

extension TemperamentoRegular {
    /// Ahora `frecuenciaDelLa4`.
    @available(*, deprecated, renamed: "frecuenciaDelLa4")
    public var la4: Double { frecuenciaDelLa4 }

    /// Ahora `init(nombre:quinta:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "init(nombre:quinta:frecuenciaDelLa4:)")
    public init(nombre: String, quinta: Double, la4: Double) {
        self.init(nombre: nombre, quinta: quinta, frecuenciaDelLa4: la4)
    }

    /// Ahora `afinar(frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "afinar(frecuenciaDelLa4:)")
    public func afinar(la4 frecuencia: Double) -> TemperamentoRegular { afinar(frecuenciaDelLa4: frecuencia) }

    /// Ahora `igual(divisiones:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "igual(divisiones:frecuenciaDelLa4:)")
    public static func igual(divisiones: Int, la4: Double) -> TemperamentoRegular {
        igual(divisiones: divisiones, frecuenciaDelLa4: la4)
    }

    /// Ahora `mesotonico(fraccionDeComa:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "mesotonico(fraccionDeComa:frecuenciaDelLa4:)")
    public static func mesotonico(fraccionDeComa fraccion: Double, la4: Double) -> TemperamentoRegular {
        mesotonico(fraccionDeComa: fraccion, frecuenciaDelLa4: la4)
    }
}

extension TemperamentoCircular {
    /// Ahora `frecuenciaDelLa4`.
    @available(*, deprecated, renamed: "frecuenciaDelLa4")
    public var la4: Double { frecuenciaDelLa4 }

    /// Ahora `init(nombre:quintas:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "init(nombre:quintas:frecuenciaDelLa4:)")
    public init?(nombre: String, quintas: [Double], la4: Double) {
        self.init(nombre: nombre, quintas: quintas, frecuenciaDelLa4: la4)
    }

    /// Ahora `afinar(frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "afinar(frecuenciaDelLa4:)")
    public func afinar(la4 frecuencia: Double) -> TemperamentoCircular { afinar(frecuenciaDelLa4: frecuencia) }
}

extension AfinacionJusta {
    /// Ahora `frecuenciaDeLaTonica`.
    @available(*, deprecated, renamed: "frecuenciaDeLaTonica")
    public var frecuenciaTonica: Double { frecuenciaDeLaTonica }

    /// Ahora `init(tonica:frecuenciaDelLa4:)`.
    @available(*, deprecated, renamed: "init(tonica:frecuenciaDelLa4:)")
    public init(tonica: Nota, la4: Double) { self.init(tonica: tonica, frecuenciaDelLa4: la4) }

    /// Ahora `init(tonica:frecuenciaDeLaTonica:)`.
    @available(*, deprecated, renamed: "init(tonica:frecuenciaDeLaTonica:)")
    public init(tonica: Nota, frecuenciaTonica: Double) {
        self.init(tonica: tonica, frecuenciaDeLaTonica: frecuenciaTonica)
    }
}

extension TecladoIsomorfico {
    /// Ahora `rotado(doceavos:nombre:)`: un paso es un doceavo de vuelta (30°).
    @available(*, deprecated, renamed: "rotado(doceavos:nombre:)")
    public func rotado(pasos: Int, nombre: String? = nil) -> TecladoIsomorfico {
        rotado(doceavos: pasos, nombre: nombre)
    }
}
