import Elementos

// MARK: - La geografía de una escala
//
// De dónde viene una escala, separado de qué música es (su `Tradicion`): un `Lugar` en tres niveles, el continente, el
// país y la región o el pueblo (`RegionDeEscala`), cada uno dentro del anterior. Las escalas no los escriben: los
// toman de sus regiones (las de sus datos) o, si no tienen, de su tradición. Y hay dos clases de lugares: los de origen
// (de donde viene) y los de uso (donde también se tocan sus notas, con otro nombre). Algunos nombres parecen decir de
// dónde viene la escala y no lo dicen: la persa no es persa.

// MARK: Continente

/// El continente de un país, una región o una tradición.
public enum Continente: String, Sendable, Codable, CaseIterable {
    case europa, asia, africa, america, oceania

    /// El nombre en el idioma de los textos de la notación: «Europa», «Europe», «Европа». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un continente nuevo no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .europa: TextosDeTeoria.traduccion(\.continenteEuropa)
        case .asia: TextosDeTeoria.traduccion(\.continenteAsia)
        case .africa: TextosDeTeoria.traduccion(\.continenteAfrica)
        case .america: TextosDeTeoria.traduccion(\.continenteAmerica)
        case .oceania: TextosDeTeoria.traduccion(\.continenteOceania)
        }
    }
}

extension Continente: Nombrable {}

// MARK: País

/// Un país de hoy de donde viene una escala, o una de sus regiones: Indonesia (Java, Bali, Sunda), España (Andalucía),
/// Irán (Persia). Los de las tradiciones antiguas son los de su territorio: Grecia para la Grecia antigua, Irak para
/// Mesopotamia.
public enum Pais: String, Sendable, Codable, CaseIterable {
    case espana
    case reinoUnido
    case suiza
    case austria
    case croacia
    case eslovenia
    case ucrania
    case polonia
    case hungria
    case rumania
    case georgia
    case grecia
    case turquia
    case azerbaiyan
    case iran
    case irak
    case india
    case china
    case japon
    case coreaDelSur
    case coreaDelNorte
    case vietnam
    case indonesia
    case tailandia
    case camboya
    case myanmar
    case uganda
    case mozambique
    case zimbabue
    case mali
    case senegal
    case gambia
    case guinea
    case etiopia
    case brasil
    case peru
    case bolivia
    case ecuador
    case estadosUnidos
    case siria
    case libano
    case palestina
    case jordania
    case egipto
    case arabiaSaudi
    case kuwait
    case barein
    case catar
    case emiratos
    case oman
    case yemen
    case marruecos
    case argelia
    case tunez
    case libia

    /// Su código ISO 3166-1 de dos letras: «ES», «ID», «IR».
    public var codigoISO: String {
        switch self {
        case .espana: "ES"
        case .reinoUnido: "GB"
        case .suiza: "CH"
        case .austria: "AT"
        case .croacia: "HR"
        case .eslovenia: "SI"
        case .ucrania: "UA"
        case .polonia: "PL"
        case .hungria: "HU"
        case .rumania: "RO"
        case .georgia: "GE"
        case .grecia: "GR"
        case .turquia: "TR"
        case .azerbaiyan: "AZ"
        case .iran: "IR"
        case .irak: "IQ"
        case .india: "IN"
        case .china: "CN"
        case .japon: "JP"
        case .coreaDelSur: "KR"
        case .coreaDelNorte: "KP"
        case .vietnam: "VN"
        case .indonesia: "ID"
        case .tailandia: "TH"
        case .camboya: "KH"
        case .myanmar: "MM"
        case .uganda: "UG"
        case .mozambique: "MZ"
        case .zimbabue: "ZW"
        case .mali: "ML"
        case .senegal: "SN"
        case .gambia: "GM"
        case .guinea: "GN"
        case .etiopia: "ET"
        case .brasil: "BR"
        case .peru: "PE"
        case .bolivia: "BO"
        case .ecuador: "EC"
        case .estadosUnidos: "US"
        case .siria: "SY"
        case .libano: "LB"
        case .palestina: "PS"
        case .jordania: "JO"
        case .egipto: "EG"
        case .arabiaSaudi: "SA"
        case .kuwait: "KW"
        case .barein: "BH"
        case .catar: "QA"
        case .emiratos: "AE"
        case .oman: "OM"
        case .yemen: "YE"
        case .marruecos: "MA"
        case .argelia: "DZ"
        case .tunez: "TN"
        case .libia: "LY"
        }
    }

    /// El continente en que está. Georgia y Turquía, entre dos, van con el de su tradición en el catálogo: Georgia
    /// con Europa (como el canto georgiano, en la tradición europea) y Turquía con Asia.
    public var continente: Continente {
        switch self {
        case .espana, .reinoUnido, .suiza, .austria, .croacia, .eslovenia, .ucrania, .polonia, .hungria, .rumania,
            .georgia, .grecia:
            .europa
        case .turquia, .azerbaiyan, .iran, .irak, .india, .china, .japon, .coreaDelSur, .coreaDelNorte, .vietnam,
            .indonesia, .tailandia, .camboya, .myanmar, .siria, .libano, .palestina, .jordania, .arabiaSaudi, .kuwait,
            .barein, .catar, .emiratos, .oman, .yemen:
            .asia
        case .uganda, .mozambique, .zimbabue, .mali, .senegal, .gambia, .guinea, .etiopia, .egipto, .marruecos,
            .argelia, .tunez, .libia:
            .africa
        case .brasil, .peru, .bolivia, .ecuador, .estadosUnidos: .america
        }
    }

    /// El nombre en el idioma de los textos de la notación: «España», «Spain», «Испания». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: un país nuevo no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .espana: TextosDeTeoria.traduccion(\.paisEspana)
        case .reinoUnido: TextosDeTeoria.traduccion(\.paisReinoUnido)
        case .suiza: TextosDeTeoria.traduccion(\.paisSuiza)
        case .austria: TextosDeTeoria.traduccion(\.paisAustria)
        case .croacia: TextosDeTeoria.traduccion(\.paisCroacia)
        case .eslovenia: TextosDeTeoria.traduccion(\.paisEslovenia)
        case .ucrania: TextosDeTeoria.traduccion(\.paisUcrania)
        case .polonia: TextosDeTeoria.traduccion(\.paisPolonia)
        case .hungria: TextosDeTeoria.traduccion(\.paisHungria)
        case .rumania: TextosDeTeoria.traduccion(\.paisRumania)
        case .georgia: TextosDeTeoria.traduccion(\.paisGeorgia)
        case .grecia: TextosDeTeoria.traduccion(\.paisGrecia)
        case .turquia: TextosDeTeoria.traduccion(\.paisTurquia)
        case .azerbaiyan: TextosDeTeoria.traduccion(\.paisAzerbaiyan)
        case .iran: TextosDeTeoria.traduccion(\.paisIran)
        case .irak: TextosDeTeoria.traduccion(\.paisIrak)
        case .india: TextosDeTeoria.traduccion(\.paisIndia)
        case .china: TextosDeTeoria.traduccion(\.paisChina)
        case .japon: TextosDeTeoria.traduccion(\.paisJapon)
        case .coreaDelSur: TextosDeTeoria.traduccion(\.paisCoreaDelSur)
        case .coreaDelNorte: TextosDeTeoria.traduccion(\.paisCoreaDelNorte)
        case .vietnam: TextosDeTeoria.traduccion(\.paisVietnam)
        case .indonesia: TextosDeTeoria.traduccion(\.paisIndonesia)
        case .tailandia: TextosDeTeoria.traduccion(\.paisTailandia)
        case .camboya: TextosDeTeoria.traduccion(\.paisCamboya)
        case .myanmar: TextosDeTeoria.traduccion(\.paisMyanmar)
        case .uganda: TextosDeTeoria.traduccion(\.paisUganda)
        case .mozambique: TextosDeTeoria.traduccion(\.paisMozambique)
        case .zimbabue: TextosDeTeoria.traduccion(\.paisZimbabue)
        case .mali: TextosDeTeoria.traduccion(\.paisMali)
        case .senegal: TextosDeTeoria.traduccion(\.paisSenegal)
        case .gambia: TextosDeTeoria.traduccion(\.paisGambia)
        case .guinea: TextosDeTeoria.traduccion(\.paisGuinea)
        case .etiopia: TextosDeTeoria.traduccion(\.paisEtiopia)
        case .brasil: TextosDeTeoria.traduccion(\.paisBrasil)
        case .peru: TextosDeTeoria.traduccion(\.paisPeru)
        case .bolivia: TextosDeTeoria.traduccion(\.paisBolivia)
        case .ecuador: TextosDeTeoria.traduccion(\.paisEcuador)
        case .estadosUnidos: TextosDeTeoria.traduccion(\.paisEstadosUnidos)
        case .siria: TextosDeTeoria.traduccion(\.paisSiria)
        case .libano: TextosDeTeoria.traduccion(\.paisLibano)
        case .palestina: TextosDeTeoria.traduccion(\.paisPalestina)
        case .jordania: TextosDeTeoria.traduccion(\.paisJordania)
        case .egipto: TextosDeTeoria.traduccion(\.paisEgipto)
        case .arabiaSaudi: TextosDeTeoria.traduccion(\.paisArabiaSaudi)
        case .kuwait: TextosDeTeoria.traduccion(\.paisKuwait)
        case .barein: TextosDeTeoria.traduccion(\.paisBarein)
        case .catar: TextosDeTeoria.traduccion(\.paisCatar)
        case .emiratos: TextosDeTeoria.traduccion(\.paisEmiratos)
        case .oman: TextosDeTeoria.traduccion(\.paisOman)
        case .yemen: TextosDeTeoria.traduccion(\.paisYemen)
        case .marruecos: TextosDeTeoria.traduccion(\.paisMarruecos)
        case .argelia: TextosDeTeoria.traduccion(\.paisArgelia)
        case .tunez: TextosDeTeoria.traduccion(\.paisTunez)
        case .libia: TextosDeTeoria.traduccion(\.paisLibia)
        }
    }
}

extension Pais: Nombrable {}

// MARK: Zona, pueblo y lugar histórico

/// Una zona de una tradición que va por encima de los países: las del mundo árabe, que es de muchos. Cada una tiene
/// sus países: el Levante, Siria, el Líbano, Palestina y Jordania.
public enum ZonaMusical: String, Sendable, Codable, CaseIterable {
    /// Siria, el Líbano, Palestina y Jordania: la práctica de Maqam World y de casi todo el catálogo.
    case levante
    /// Egipto.
    case egipto
    /// Irak, con su maqam iraquí.
    case irak
    /// La península arábiga y el Golfo Pérsico.
    case golfo
    /// Marruecos, Argelia, Túnez y Libia, con su música andalusí.
    case magreb

    /// Sus países. El `switch` no tiene `default`: una zona nueva no compila sin los suyos.
    public var paises: [Pais] {
        switch self {
        case .levante: [.siria, .libano, .palestina, .jordania]
        case .egipto: [.egipto]
        case .irak: [.irak]
        case .golfo: [.arabiaSaudi, .kuwait, .barein, .catar, .emiratos, .oman, .yemen]
        case .magreb: [.marruecos, .argelia, .tunez, .libia]
        }
    }

    /// El nombre en el idioma de los textos de la notación: «Levante», «Levant», «Магриб».
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas: el de su país en Egipto y en Irak.
    private var traduccion: Traduccion {
        switch self {
        case .levante: TextosDeTeoria.traduccion(\.zonaLevante)
        case .egipto: TextosDeTeoria.traduccion(\.paisEgipto)
        case .irak: TextosDeTeoria.traduccion(\.paisIrak)
        case .golfo: TextosDeTeoria.traduccion(\.zonaGolfo)
        case .magreb: TextosDeTeoria.traduccion(\.zonaMagreb)
        }
    }
}

extension ZonaMusical: Nombrable {}

/// Un pueblo que vive en varios países y lleva consigo su música: el gitano (la menor húngara es la «escala gitana»
/// de Liszt) y los judíos asquenazíes (el klezmer).
public enum Pueblo: String, Sendable, Codable, CaseIterable {
    case romani
    case asquenazi

    /// Los países de Europa donde su música es más conocida. Un pueblo no está dentro de ellos como una región: por eso
    /// `Lugar.contenidoEn` solo da su continente.
    public var paises: [Pais] {
        switch self {
        case .romani: [.espana, .hungria, .rumania, .grecia]
        case .asquenazi: [.polonia, .ucrania, .rumania, .hungria]
        }
    }

    /// El nombre en el idioma de los textos de la notación: «pueblo gitano», «Ashkenazi Jews».
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    private var traduccion: Traduccion {
        switch self {
        case .romani: TextosDeTeoria.traduccion(\.puebloRomani)
        case .asquenazi: TextosDeTeoria.traduccion(\.puebloAsquenazi)
        }
    }
}

extension Pueblo: Nombrable {}

/// Un lugar que ya no existe, con los países de hoy que ocupan su territorio: Bizancio (Grecia y Turquía), Mesopotamia
/// (Irak) y la Grecia antigua (Grecia). Su nombre es el de su tradición.
public enum LugarHistorico: String, Sendable, Codable, CaseIterable {
    case bizancio
    case mesopotamia
    case greciaAntigua

    /// Los países de hoy en su territorio.
    public var paises: [Pais] {
        switch self {
        case .bizancio: [.grecia, .turquia]
        case .mesopotamia: [.irak]
        case .greciaAntigua: [.grecia]
        }
    }

    /// Su tradición, que le da el nombre.
    public var tradicion: Tradicion {
        switch self {
        case .bizancio: .bizancio
        case .mesopotamia: .mesopotamia
        case .greciaAntigua: .greciaAntigua
        }
    }

    /// El nombre en el idioma de los textos de la notación: el de su tradición, «Bizancio», «Mesopotamia».
    public func nombre(en notacion: Notacion) -> String { tradicion.nombre(en: notacion) }
}

extension LugarHistorico: Nombrable {}

// MARK: Lugar

/// Un lugar de donde viene una escala: un continente, una zona (las del mundo árabe), un país, un lugar histórico
/// (Bizancio), un pueblo (el gitano) o una región (Andalucía, los mandinga). `contenidoEn` da los lugares que lo
/// contienen: Andalucía está en España, que está en Europa.
public enum Lugar: Hashable, Sendable, Codable {
    case continente(Continente)
    case zona(ZonaMusical)
    case pais(Pais)
    case historico(LugarHistorico)
    case pueblo(Pueblo)
    case region(RegionDeEscala)

    /// Los lugares que lo contienen, del más cercano al más lejano: Andalucía → España, Europa. Una región en varios
    /// países (los Alpes, los mandinga) da todos sus países y sus continentes.
    public var contenidoEn: [Lugar] {
        switch self {
        case .continente: []
        case .pais(let pais): [.continente(pais.continente)]
        case .zona(let zona): zona.paises.map(Lugar.pais) + Lugar.continentes(de: zona.paises).map(Lugar.continente)
        case .historico(let lugar):
            lugar.paises.map(Lugar.pais) + Lugar.continentes(de: lugar.paises).map(Lugar.continente)
        case .pueblo(let pueblo): Lugar.continentes(de: pueblo.paises).map(Lugar.continente)
        case .region(let region):
            region.paises.map(Lugar.pais) + Lugar.continentes(de: region.paises).map(Lugar.continente)
        }
    }

    /// Él y los que lo contienen.
    public var conLosQueLoContienen: [Lugar] { [self] + contenidoEn }

    /// El nombre del lugar: «Andalucía», «España», «Europa».
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .continente(let continente): continente.nombre(en: notacion)
        case .pais(let pais): pais.nombre(en: notacion)
        case .zona(let zona): zona.nombre(en: notacion)
        case .historico(let lugar): lugar.nombre(en: notacion)
        case .pueblo(let pueblo): pueblo.nombre(en: notacion)
        case .region(let region): region.nombre(en: notacion)
        }
    }

    /// La clave del lugar, la de su caso: «andalucia», «espana», «europa». La zona y el país de Egipto (o de Irak)
    /// tienen la misma.
    public var clave: String {
        switch self {
        case .continente(let continente): continente.rawValue
        case .pais(let pais): pais.rawValue
        case .zona(let zona): zona.rawValue
        case .historico(let lugar): lugar.rawValue
        case .pueblo(let pueblo): pueblo.rawValue
        case .region(let region): region.rawValue
        }
    }

    /// Para ordenar: primero los continentes, luego las zonas, los países, los lugares históricos, los pueblos y las
    /// regiones, cada uno en el orden de sus casos.
    var orden: Int {
        switch self {
        case .continente(let continente): Continente.allCases.firstIndex(of: continente)!
        case .zona(let zona): 50 + ZonaMusical.allCases.firstIndex(of: zona)!
        case .pais(let pais): 100 + Pais.allCases.firstIndex(of: pais)!
        case .historico(let lugar): 800 + LugarHistorico.allCases.firstIndex(of: lugar)!
        case .pueblo(let pueblo): 900 + Pueblo.allCases.firstIndex(of: pueblo)!
        case .region(let region): 1000 + RegionDeEscala.allCases.firstIndex(of: region)!
        }
    }

    /// Todos los lugares, en el orden de `orden`: para buscar uno por su nombre.
    public static let todos: [Lugar] =
        Continente.allCases.map(Lugar.continente) + ZonaMusical.allCases.map(Lugar.zona) + Pais.allCases.map(Lugar.pais)
        + LugarHistorico.allCases.map(Lugar.historico) + Pueblo.allCases.map(Lugar.pueblo)
        + RegionDeEscala.allCases.map(Lugar.region)

    /// Si este lugar es `otro` o está dentro de él: Andalucía está en España y en Europa.
    public func esta(en otro: Lugar) -> Bool { conLosQueLoContienen.contains(otro) }

    /// Los continentes de unos países, sin repetir, en el orden de `Continente.allCases`.
    static func continentes(de paises: [Pais]) -> [Continente] {
        Continente.allCases.filter { continente in paises.contains { $0.continente == continente } }
    }
}

extension Lugar: Nombrable {}
