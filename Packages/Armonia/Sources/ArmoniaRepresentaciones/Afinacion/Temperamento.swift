import ArmoniaNucleo

/// Las afinaciones históricas más conocidas, para elegir con cuál suenan las notas (en las apps,
/// el botón «Escuchar»). Cada una da su `Afinacion`; la justa se construye sobre una tónica.
///
///     Temperamento.mesotonico.afinacion().frecuencia(de: "Sol#4") < Temperamento.mesotonico.afinacion().frecuencia(de: "Lab4")   // true
///     Temperamento.justa.afinacion(tonica: .re).desviacion(de: "Fa#4")   // −13,69: la tercera pura sobre Re
///     Temperamento.werckmeisterIII.nombre(en: .inglesASCII)             // "Werckmeister III"
public enum Temperamento: String, Hashable, Sendable, CaseIterable, CustomStringConvertible, Nombrable {
    /// Doce semitonos iguales: lo que suena si no se elige otro.
    case igual
    /// Quintas puras (`TemperamentoRegular.pitagorico`).
    case pitagorico
    /// Mesotónico de ¼ de coma, con las terceras mayores puras (`TemperamentoRegular.mesotonicoCuartoDeComa`).
    case mesotonico
    case werckmeisterIII
    case kirnbergerIII
    case vallotti
    case young
    /// Afinación justa de 5 límites sobre la tónica (`EntonacionJusta`).
    case justa

    public var description: String { nombre }

    /// La afinación, con el La4 dado. Solo la justa usa la tónica; las demás no dependen de ella.
    public func afinacion(tonica: Nota = .do, la4: Double = 440) -> any Afinacion {
        switch self {
        case .igual: return TemperamentoRegular.igual.afinar(la4: la4)
        case .pitagorico: return TemperamentoRegular.pitagorico.afinar(la4: la4)
        case .mesotonico: return TemperamentoRegular.mesotonicoCuartoDeComa.afinar(la4: la4)
        case .werckmeisterIII: return TemperamentoCircular.werckmeisterIII.afinar(la4: la4)
        case .kirnbergerIII: return TemperamentoCircular.kirnbergerIII.afinar(la4: la4)
        case .vallotti: return TemperamentoCircular.vallotti.afinar(la4: la4)
        case .young: return TemperamentoCircular.young.afinar(la4: la4)
        case .justa: return EntonacionJusta(tonica: tonica, la4: la4)
        }
    }

    /// `true` si distingue las notas enarmónicas (Sol♯ de La♭): las regulares, salvo la igual, y la justa.
    public var distingueEnarmonicas: Bool {
        switch self {
        case .pitagorico, .mesotonico, .justa: return true
        case .igual, .werckmeisterIII, .kirnbergerIII, .vallotti, .young: return false
        }
    }
}
