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
    /// Sudeste asiático: los conjuntos piphat de Tailandia y pinpeat de Camboya, el arpa de Birmania y el khaen de los
    /// lao (Laos y el Isán, el nordeste de Tailandia).
    case tailandia, camboya, birmania, laos
    /// África: el amadinda de Buganda (Uganda), el timbila de los chopi (Mozambique), la kora mandinga y la mbira de
    /// los shona (Zimbabue).
    case buganda, chopi, mandinga, shona
    /// Europa: el país o la región de cada escala popular.
    case ucrania, polonia, hungria, alpes, escocia, georgia, istria
    /// Occidental: las regiones de las escalas occidentales que vienen de una música popular, y que no tienen ninguna
    /// de otra tradición: la flamenca, de Andalucía; la mayor rumana, de Rumanía.
    case andalucia, rumania
    /// Japón: la música de Okinawa (Ryūkyū).
    case ryukyu

    /// La tradición de cuya música es la región: Java en Indonesia, Hungría en la
    /// europea. Es música, no geografía: dónde está la da `paises`. Una escala de otra tradición puede venir de ella
    /// (la menor húngara, occidental, es de Hungría), pero no es de su tradición. El `switch` no tiene
    /// `default`: una región nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .java, .bali, .sunda: .indonesia
        case .tailandia, .camboya, .birmania, .laos: .sudesteAsiatico
        case .buganda, .chopi, .mandinga, .shona: .africa
        case .ucrania, .polonia, .hungria, .alpes, .escocia, .georgia, .istria: .europa
        case .andalucia, .rumania: .occidental
        case .ryukyu: .japon
        }
    }

    /// Las escalas del catálogo que vienen de esta región (las que la tienen en `TipoDeEscala.regiones`), en el orden
    /// de `TipoDeEscala.catalogo`: primero las occidentales populares que vienen de ella y luego las de otras
    /// tradiciones.
    /// `RegionDeEscala.java.tipos` da los pathet de Java y el sléndro; `RegionDeEscala.hungria.tipos`, las húngaras
    /// occidentales y la pentatónica húngara, y `RegionDeEscala.andalucia.tipos`, la flamenca.
    public var tipos: [TipoDeEscala] { RegionDeEscala.tiposPorRegion[self] ?? [] }

    /// Región → las escalas del catálogo que vienen de ella, en su orden.
    private static let tiposPorRegion: [RegionDeEscala: [TipoDeEscala]] = {
        var tabla: [RegionDeEscala: [TipoDeEscala]] = [:]
        for tipo in TipoDeEscala.catalogo {
            for region in tipo.regiones { tabla[region, default: []].append(tipo) }
        }
        return tabla
    }()

    /// El nombre en el idioma de los textos de la notación: «Java», «Escocia», «Scotland», «Σκωτία». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .java: TextosDeTeoria.traduccion(\.regionJava)
        case .bali: TextosDeTeoria.traduccion(\.regionBali)
        case .sunda: TextosDeTeoria.traduccion(\.regionSunda)
        case .tailandia: TextosDeTeoria.traduccion(\.regionTailandia)
        case .camboya: TextosDeTeoria.traduccion(\.regionCamboya)
        case .birmania: TextosDeTeoria.traduccion(\.regionBirmania)
        case .laos: TextosDeTeoria.traduccion(\.regionLaos)
        case .buganda: TextosDeTeoria.traduccion(\.regionBuganda)
        case .chopi: TextosDeTeoria.traduccion(\.regionChopi)
        case .mandinga: TextosDeTeoria.traduccion(\.regionMandinga)
        case .shona: TextosDeTeoria.traduccion(\.regionShona)
        case .ucrania: TextosDeTeoria.traduccion(\.regionUcrania)
        case .polonia: TextosDeTeoria.traduccion(\.regionPolonia)
        case .hungria: TextosDeTeoria.traduccion(\.regionHungria)
        case .alpes: TextosDeTeoria.traduccion(\.regionAlpes)
        case .escocia: TextosDeTeoria.traduccion(\.regionEscocia)
        case .georgia: TextosDeTeoria.traduccion(\.regionGeorgia)
        case .istria: TextosDeTeoria.traduccion(\.regionIstria)
        case .andalucia: TextosDeTeoria.traduccion(\.regionAndalucia)
        case .rumania: TextosDeTeoria.traduccion(\.regionRumania)
        case .ryukyu: TextosDeTeoria.traduccion(\.regionRyukyu)
        }
    }
}

extension RegionDeEscala: Nombrable {}

extension TipoDeEscala {
    /// Las regiones de donde viene, en el orden de `RegionDeEscala.allCases`: las de otras tradiciones con una clara y
    /// las occidentales populares (la flamenca, de Andalucía). Vacío en las demás occidentales, en las propias y en las
    /// de otras tradiciones sin una clara. Como `estilos`, por su identidad.
    ///
    ///     TipoDeEscala.pelogTembung.regiones   // [.bali]
    ///     TipoDeEscala.slendro.regiones        // [.java, .bali]
    public var regiones: [RegionDeEscala] { datosDelCatalogo.regiones }
}
