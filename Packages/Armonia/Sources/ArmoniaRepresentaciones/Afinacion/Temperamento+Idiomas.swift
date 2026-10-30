import ArmoniaNucleo
// Nombres de los temperamentos en los catorce idiomas de los textos (`Traduccion`).

extension Temperamento {
    public var nombre: String { nombre(en: .espanolUnicode) }

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
