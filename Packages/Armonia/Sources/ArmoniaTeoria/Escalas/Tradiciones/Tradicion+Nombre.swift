import ArmoniaNucleo

// MARK: - El nombre de cada tradición

extension Tradicion {
    /// El nombre de la tradición en el idioma de los textos de la notación: «Japón», «Japan», «Japonia», «Ιαπωνία».
    /// En español, también `nombre` (de `Nombrable`).
    ///
    ///     Tradicion.japon.nombre(en: .delIdioma(.euskera))   // "Japonia"
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los quince idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: una tradición nueva
    /// no compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .india: TextosDeTeoria.traduccion(\.tradicionIndia)
        case .grecia: TextosDeTeoria.traduccion(\.tradicionGrecia)
        case .greciaAntigua: TextosDeTeoria.traduccion(\.tradicionGreciaAntigua)
        case .mundoArabe: TextosDeTeoria.traduccion(\.tradicionMundoArabe)
        case .persia: TextosDeTeoria.traduccion(\.tradicionPersia)
        case .turquia: TextosDeTeoria.traduccion(\.tradicionTurquia)
        case .azerbaiyan: TextosDeTeoria.traduccion(\.tradicionAzerbaiyan)
        case .china: TextosDeTeoria.traduccion(\.tradicionChina)
        case .japon: TextosDeTeoria.traduccion(\.tradicionJapon)
        case .corea: TextosDeTeoria.traduccion(\.tradicionCorea)
        case .etiopia: TextosDeTeoria.traduccion(\.tradicionEtiopia)
        case .indonesia: TextosDeTeoria.traduccion(\.tradicionIndonesia)
        case .klezmer: TextosDeTeoria.traduccion(\.tradicionKlezmer)
        case .andes: TextosDeTeoria.traduccion(\.tradicionAndes)
        case .bizancio: TextosDeTeoria.traduccion(\.tradicionBizancio)
        case .mesopotamia: TextosDeTeoria.traduccion(\.tradicionMesopotamia)
        case .africa: TextosDeTeoria.traduccion(\.tradicionAfrica)
        case .sudesteAsiatico: TextosDeTeoria.traduccion(\.tradicionSudesteAsiatico)
        case .gregoriano: TextosDeTeoria.traduccion(\.tradicionGregoriano)
        case .europa: TextosDeTeoria.traduccion(\.tradicionEuropa)
        }
    }
}

extension Tradicion: Nombrable {}
