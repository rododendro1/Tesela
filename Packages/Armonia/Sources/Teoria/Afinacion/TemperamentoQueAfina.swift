import Elementos

/// Un temperamento del catálogo que afina las doce notas: todos menos los sistemas de otras tradiciones, que afinan
/// los grados de sus escalas (`AfinacionPropia`). Su ``afinacion(tonica:frecuenciaDelLa4:)`` no es opcional.
///
///     TemperamentoQueAfina.paraEscuchar.count                                    // 8
///     TemperamentoQueAfina.afinacionJusta.afinacion(tonica: .re).desviacion(de: "Fa#4")   // −13,69
///     TemperamentoQueAfina(.comas53)                                             // nil
public struct TemperamentoQueAfina: Hashable, Sendable, Identifiable, Nombrable, CustomStringConvertible {
    /// El temperamento del catálogo.
    public let temperamento: TemperamentoConNombre

    /// `nil` si `temperamento` no afina las notas.
    public init?(_ temperamento: TemperamentoConNombre) {
        guard temperamento.afinacion() != nil else { return nil }
        self.temperamento = temperamento
    }

    /// La afinación de las notas, con el La4 dado y, en la justa, sobre la tónica.
    public func afinacion(tonica: Nota = .do, frecuenciaDelLa4: Double = 440) -> any SistemaDeAfinacion {
        // `init?` ya comprobó que afina.
        temperamento.afinacion(tonica: tonica, frecuenciaDelLa4: frecuenciaDelLa4)!
    }

    /// `true` si distingue las notas enarmónicas (Sol♯ de La♭).
    public var distingueEnarmonicas: Bool { temperamento.distingueEnarmonicas }

    public var id: String { temperamento.id }
    public var description: String { temperamento.description }
    public func nombre(en notacion: Notacion) -> String { temperamento.nombre(en: notacion) }
}

// MARK: - Para escuchar

extension TemperamentoQueAfina {
    /// Uno del catálogo que se sabe que afina.
    private static func delCatalogo(_ temperamento: TemperamentoConNombre) -> TemperamentoQueAfina {
        guard let queAfina = TemperamentoQueAfina(temperamento) else {
            preconditionFailure("«\(temperamento.nombre)» no afina las notas")
        }
        return queAfina
    }

    public static let temperamentoIgual = delCatalogo(.temperamentoIgual)
    public static let pitagorico = delCatalogo(.pitagorico)
    public static let mesotonicoCuartoDeComa = delCatalogo(.mesotonicoCuartoDeComa)
    public static let werckmeisterIII = delCatalogo(.werckmeisterIII)
    public static let kirnbergerIII = delCatalogo(.kirnbergerIII)
    public static let vallotti = delCatalogo(.vallotti)
    public static let young = delCatalogo(.young)
    public static let afinacionJusta = delCatalogo(.afinacionJusta)

    /// Los que las apps ofrecen para oír las notas (el botón «Escuchar»): el igual, el pitagórico, el mesotónico de
    /// ¼ de coma, Werckmeister III, Kirnberger III, Vallotti, Young y la justa, que se construye sobre la tónica.
    public static let paraEscuchar: [TemperamentoQueAfina] = [
        .temperamentoIgual, .pitagorico, .mesotonicoCuartoDeComa, .werckmeisterIII, .kirnbergerIII, .vallotti,
        .young, .afinacionJusta,
    ]

    /// Todos los del catálogo que afinan las notas, en su orden.
    public static var todos: [TemperamentoQueAfina] {
        TemperamentoConNombre.catalogo.compactMap(TemperamentoQueAfina.init)
    }
}
