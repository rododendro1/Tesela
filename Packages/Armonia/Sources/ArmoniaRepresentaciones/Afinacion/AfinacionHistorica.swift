import ArmoniaNucleo

/// Las afinaciones históricas más conocidas, para elegir con cuál suenan las notas (en las apps,
/// el botón «Escuchar»). Cada una da su `Afinacion`; la justa se construye sobre una tónica.
///
///     AfinacionHistorica.mesotonico.afinacion().frecuencia(de: "Sol#4") < AfinacionHistorica.mesotonico.afinacion().frecuencia(de: "Lab4")   // true
///     AfinacionHistorica.justa.afinacion(tonica: .re).desviacion(de: "Fa#4")   // −13,69: la tercera pura sobre Re
///     AfinacionHistorica.werckmeisterIII.nombre(en: .inglesASCII)             // "Werckmeister III"
public enum AfinacionHistorica: String, Hashable, Sendable, CaseIterable, CustomStringConvertible, Nombrable {
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
    /// Afinación justa de 5 límites sobre la tónica (`AfinacionJusta`).
    case justa

    public var description: String { nombre }

    /// La afinación, con el La4 dado. Solo la justa usa la tónica; las demás no dependen de ella.
    public func afinacion(tonica: Nota = .do, frecuenciaDelLa4: Double = 440) -> any Afinacion {
        switch self {
        case .igual: return TemperamentoRegular.igual.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .pitagorico: return TemperamentoRegular.pitagorico.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .mesotonico: return TemperamentoRegular.mesotonicoCuartoDeComa.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .werckmeisterIII: return TemperamentoCircular.werckmeisterIII.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .kirnbergerIII: return TemperamentoCircular.kirnbergerIII.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .vallotti: return TemperamentoCircular.vallotti.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .young: return TemperamentoCircular.young.afinar(frecuenciaDelLa4: frecuenciaDelLa4)
        case .justa: return AfinacionJusta(tonica: tonica, frecuenciaDelLa4: frecuenciaDelLa4)
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

// MARK: - Idiomas
//
// Nombres de los temperamentos en los catorce idiomas de los textos (`Traduccion`).

extension AfinacionHistorica {
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .igual:
            return TextosDeRepresentaciones.traducidos.map(\.temperamentoIgual).en(notacion)
        case .pitagorico:
            return TextosDeRepresentaciones.traducidos.map(\.pitagorico).en(notacion)
        case .mesotonico:
            return TextosDeRepresentaciones.traducidos.map(\.mesotonico).en(notacion)
        case .werckmeisterIII:
            return TextosDeRepresentaciones.traducidos.map(\.werckmeisterIII).en(notacion)
        case .kirnbergerIII:
            return TextosDeRepresentaciones.traducidos.map(\.kirnbergerIII).en(notacion)
        case .vallotti:
            return TextosDeRepresentaciones.traducidos.map(\.vallotti).en(notacion)
        case .young:
            return TextosDeRepresentaciones.traducidos.map(\.young).en(notacion)
        case .justa:
            return TextosDeRepresentaciones.traducidos.map(\.afinacionJusta).en(notacion)
        }
    }
}
