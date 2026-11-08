import Elementos

// MARK: - La región de una escala

/// La región, el país o el pueblo de donde viene una escala, dentro de su tradición: Java o Bali en Indonesia, el país
/// de una escala popular de Europa, el pueblo de una afinación de África, Okinawa (las islas Ryūkyū) en Japón.
///
/// Las escalas la llevan en su declaración (`regiones: [.bali]`), y pueden llevar varias (el sléndro, `[.java,
/// .bali]`). Las que no tienen una clara (las escalas chinas) no llevan ninguna, y los teóricos (Aristóxeno, Ptolomeo,
/// Glareano) no son regiones: son la `fuente` de la escala (`FuenteTeorica`).
public enum RegionDeEscala: String, Sendable, Codable, CaseIterable {
    /// Indonesia: los gamelan de Java, de Bali y de Sunda (el oeste de Java).
    case java, bali, sunda
    /// Sudeste asiático: los conjuntos piphat de Tailandia y pinpeat de Camboya, y el arpa de Birmania.
    case tailandia, camboya, birmania
    /// África: el amadinda de Buganda (Uganda), el timbila de los chopi (Mozambique), la kora mandinga y la mbira de
    /// los shona (Zimbabue).
    case buganda, chopi, mandinga, shona
    /// Europa: el país o la región de cada escala popular.
    case ucrania, polonia, hungria, alpes, escocia, georgia, istria
    /// Japón: la música de Okinawa (Ryūkyū).
    case ryukyu

    /// La tradición a la que pertenece. El `switch` no tiene `default`: una región nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .java, .bali, .sunda: .indonesia
        case .tailandia, .camboya, .birmania: .sudesteAsiatico
        case .buganda, .chopi, .mandinga, .shona: .africa
        case .ucrania, .polonia, .hungria, .alpes, .escocia, .georgia, .istria: .europa
        case .ryukyu: .japon
        }
    }

    /// Las escalas de otras tradiciones de esta región, en el orden de `TipoDeEscala.tradicionales`:
    /// `RegionDeEscala.java.tipos` da los pathet de Java y el sléndro.
    public var tipos: [TipoDeEscala] { TipoDeEscala.tradicionales.filter { $0.regiones.contains(self) } }

    /// El nombre en el idioma de los textos de la notación: «Java», «Escocia», «Scotland», «Σκωτία». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .java: TextosDeTeoria.traduccion(\.subtradicionJava)
        case .bali: TextosDeTeoria.traduccion(\.subtradicionBali)
        case .sunda: TextosDeTeoria.traduccion(\.subtradicionSunda)
        case .tailandia: TextosDeTeoria.traduccion(\.subtradicionTailandia)
        case .camboya: TextosDeTeoria.traduccion(\.subtradicionCamboya)
        case .birmania: TextosDeTeoria.traduccion(\.subtradicionBirmania)
        case .buganda: TextosDeTeoria.traduccion(\.subtradicionBuganda)
        case .chopi: TextosDeTeoria.traduccion(\.subtradicionChopi)
        case .mandinga: TextosDeTeoria.traduccion(\.subtradicionMandinga)
        case .shona: TextosDeTeoria.traduccion(\.subtradicionShona)
        case .ucrania: TextosDeTeoria.traduccion(\.subtradicionUcrania)
        case .polonia: TextosDeTeoria.traduccion(\.subtradicionPolonia)
        case .hungria: TextosDeTeoria.traduccion(\.subtradicionHungria)
        case .alpes: TextosDeTeoria.traduccion(\.subtradicionAlpes)
        case .escocia: TextosDeTeoria.traduccion(\.subtradicionEscocia)
        case .georgia: TextosDeTeoria.traduccion(\.subtradicionGeorgia)
        case .istria: TextosDeTeoria.traduccion(\.subtradicionIstria)
        case .ryukyu: TextosDeTeoria.traduccion(\.subtradicionRyukyu)
        }
    }
}

extension RegionDeEscala: Nombrable {}

extension TipoDeEscala {
    /// Las regiones de donde viene, en el orden de `RegionDeEscala.allCases`; vacío en las occidentales, en las
    /// propias y en las de otras tradiciones sin una clara. Como `estilos`, por su identidad.
    ///
    ///     TipoDeEscala.pelogTembung.regiones   // [.bali]
    ///     TipoDeEscala.slendro.regiones        // [.java, .bali]
    public var regiones: [RegionDeEscala] { fichaDelCatalogo.regiones }
}
