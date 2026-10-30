import ArmoniaNucleo
// Los nombres de las transformaciones neorriemannianas en los catorce idiomas de los textos (`Traduccion`).

extension TransformacionNeorriemanniana: Nombrable {
    /// El nombre de la transformación en el idioma de los textos: «relativa», «relative».
    public func nombre(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .p:
            traduccion = TextosDeRepresentaciones.traducidos.map(\.homonima)
        case .l:
            traduccion = TextosDeRepresentaciones.traducidos.map(\.cambioDeSensible)
        case .r:
            traduccion = TextosDeRepresentaciones.traducidos.map(\.relativa)
        }
        return traduccion.en(notacion)
    }
}
