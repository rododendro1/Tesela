import Elementos

// MARK: - La geografía de una escala
//
// De dónde viene una escala, separado de qué música es (su `Tradicion`): un `Lugar` en tres niveles, el continente, el
// país y la región o el pueblo (`RegionDeEscala`), cada uno dentro del anterior. Las escalas no los escriben: los
// toman de sus regiones (las de su ficha) o, si no tienen, de su tradición. Y hay dos clases de lugares: los de origen
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

// MARK: Dónde están las regiones y las tradiciones

extension RegionDeEscala {
    /// Los países en que está: Java, en Indonesia; los Alpes, en Suiza y Austria; los mandinga, en Malí, Senegal, Gambia
    /// y Guinea. El `switch` no tiene `default`: una región nueva no compila sin los suyos.
    public var paises: [Pais] {
        switch self {
        case .java, .bali, .sunda: [.indonesia]
        case .tailandia: [.tailandia]
        case .camboya: [.camboya]
        case .birmania: [.myanmar]
        case .buganda: [.uganda]
        case .chopi: [.mozambique]
        case .mandinga: [.mali, .senegal, .gambia, .guinea]
        case .shona: [.zimbabue]
        case .ucrania: [.ucrania]
        case .polonia: [.polonia]
        case .hungria: [.hungria]
        case .alpes: [.suiza, .austria]
        case .escocia: [.reinoUnido]
        case .georgia: [.georgia]
        case .istria: [.croacia, .eslovenia]
        case .andalucia: [.espana]
        case .rumania: [.rumania]
        case .ryukyu: [.japon]
        }
    }
}

extension Tradicion {
    /// Los países de donde viene, si es de unos concretos: Japón, Irán (Persia), India; Grecia (la Grecia antigua, y
    /// con Turquía, Bizancio), Irak (Mesopotamia); Perú, Bolivia y Ecuador (los Andes). Vacío en las que son de una
    /// zona más amplia (el mundo árabe, la occidental, África, el sudeste asiático): esas dan solo sus continentes.
    /// El `switch` no tiene `default`: una tradición nueva no compila sin los suyos.
    public var paises: [Pais] {
        switch self {
        case .india: [.india]
        case .grecia, .greciaAntigua: [.grecia]
        case .persia: [.iran]
        case .turquia: [.turquia]
        case .azerbaiyan: [.azerbaiyan]
        case .china: [.china]
        case .japon: [.japon]
        case .corea: [.coreaDelSur, .coreaDelNorte]
        case .etiopia: [.etiopia]
        case .indonesia: [.indonesia]
        case .andes: [.peru, .bolivia, .ecuador]
        case .bizancio: [.grecia, .turquia]
        case .mesopotamia: [.irak]
        case .vietnam: [.vietnam]
        case .brasil: [.brasil]
        case .occidental, .mundoArabe, .klezmer, .africa, .sudesteAsiatico, .gregoriano, .europa, .renacimiento: []
        }
    }

    /// Los continentes de donde viene: los de sus países o, si no los tiene, los de su zona (el mundo árabe, en África
    /// y Asia; la occidental, el gregoriano, el Renacimiento, el klezmer y la europea, en Europa).
    public var continentes: [Continente] {
        let deSusPaises = Lugar.continentes(de: paises)
        if !deSusPaises.isEmpty { return deSusPaises }
        switch self {
        case .mundoArabe: return [.asia, .africa]
        case .occidental, .klezmer, .gregoriano, .europa, .renacimiento: return [.europa]
        case .africa: return [.africa]
        case .sudesteAsiatico: return [.asia]
        case .india, .grecia, .greciaAntigua, .persia, .turquia, .azerbaiyan, .china, .japon, .corea, .etiopia,
            .indonesia, .andes, .bizancio, .mesopotamia, .vietnam, .brasil:
            return []
        }
    }
}

extension Tradicion {
    /// Las zonas de las tradiciones que son de muchos países: el mundo árabe, del Levante, Egipto, Irak, el Golfo y el
    /// Magreb. Vacío en las demás.
    public var zonas: [ZonaMusical] { self == .mundoArabe ? ZonaMusical.allCases : [] }

    /// El lugar histórico de las tradiciones de un lugar que ya no existe: Bizancio, Mesopotamia y la Grecia antigua.
    public var lugarHistorico: LugarHistorico? { LugarHistorico.allCases.first { $0.tradicion == self } }

    /// Los pueblos de las tradiciones que son de un pueblo: el klezmer, de los judíos asquenazíes.
    public var pueblos: [Pueblo] { self == .klezmer ? [.asquenazi] : [] }
}

extension Estilo {
    /// Los países de donde vienen los estilos de un solo lugar: el jazz y el blues, de Estados Unidos. Vacío en los
    /// demás (la música clásica, que es de Europa como su tradición, y los de otras tradiciones). El `switch` no tiene
    /// `default`: un estilo nuevo no compila sin decir los suyos.
    public var paises: [Pais] {
        switch self {
        case .jazz, .blues: [.estadosUnidos]
        case .clasica, .popular, .sintetica, .sigloXX, .carnatica, .indostanica, .indiaAntigua, .gagaku: []
        }
    }
}

// MARK: Los lugares de una escala

extension TipoDeEscala {
    /// Las occidentales cuyo nombre es geográfico pero no dice de dónde vienen: la persa, la egipcia y la oriental son
    /// etiquetas exóticas de los libros de escalas, sin nada que ver con la música de esos lugares, y las napolitanas
    /// se llaman así por la sexta napolitana, no por Nápoles. Como las demás occidentales, son de Europa.
    public static let nombresGeograficosSinOrigen: [TipoDeEscala] = [
        .persa, .egipcia, .oriental, .napolitanaMenor, .napolitanaMayor,
    ]

    /// Su nombre es de un lugar del que no viene (`nombresGeograficosSinOrigen`): la persa, la egipcia, la oriental y
    /// las napolitanas. Por su identidad, como `estilos`.
    public var nombreGeograficoSinOrigen: Bool {
        TipoDeEscala.nombresGeograficosSinOrigen.contains { $0.esIdentico(a: self) }
    }

    /// Las escalas que vienen de un pueblo además de su región: la menor húngara, la «escala gitana» de Liszt.
    package static let pueblosDeLasEscalas: [(tipo: TipoDeEscala, pueblos: [Pueblo])] = [(.menorHungara, [.romani])]

    /// Los pueblos de donde viene: los de `pueblosDeLasEscalas` o los de su tradición (el klezmer, asquenazí).
    public var pueblos: [Pueblo] {
        TipoDeEscala.pueblosDeLasEscalas.first { $0.tipo.esIdentico(a: self) }?.pueblos ?? tradicion?.pueblos ?? []
    }

    /// Las familias de escalas de varias tradiciones que son la misma, con nombres que vienen unos de otros: el frigio
    /// dominante, Ḥijāz, Hicaz makamı, el dromos Hitzáz y el Freygish del klezmer. De ellas salen los lugares de uso
    /// (`lugaresDeUso`), que no se deducen de las notas: la mayor tiene las de Bilāval, pero no se usa en la India.
    /// Todas las de una familia tienen las mismas notas, al subir o al bajar (Hicaz makamı baja como el frigio dominante).
    package static let familias: [[TipoDeEscala]] = [
        [.frigioDominante, .hiyaz, .hicazMakami, .hitzaz, .freygish],
        [.dobleArmonica, .hiyazkar, .hicazkarMakami, .hitzazkiar],
        [.doricoCuartaAumentada, .maqamNikriz, .nikrizMakami, .nikriz, .misheberakh, .doricoUcraniano],
        [.frigio, .kurd, .kurdiMakami],
    ]

    /// Las otras escalas de su familia (`familias`), en el orden de la familia.
    public var parientes: [TipoDeEscala] {
        guard let familia = TipoDeEscala.familias.first(where: { $0.contains { $0.esIdentico(a: self) } }) else {
            return []
        }
        return familia.filter { !$0.esIdentico(a: self) }
    }

    /// Si todos sus estilos son de un lugar, sus países: la alterada y la blues, de Estados Unidos por el jazz y el
    /// blues. Vacío si alguno no lo es (el dórico, clásico y de jazz, es de Europa).
    var paisesDeSusEstilos: [Pais] {
        guard !estilos.isEmpty, estilos.allSatisfy({ !$0.paises.isEmpty }) else { return [] }
        return Pais.allCases.filter { pais in estilos.contains { $0.paises.contains(pais) } }
    }

    /// Los lugares de donde viene, los más concretos que se saben:
    ///
    /// 1. sus regiones y sus pueblos (la flamenca, Andalucía; la menor húngara, Hungría y el pueblo gitano; el
    ///    klezmer, los judíos asquenazíes);
    /// 2. el lugar histórico de su tradición (los echoi, Bizancio);
    /// 3. las zonas de su tradición (Bayātī, el Levante, Egipto, Irak, el Golfo y el Magreb);
    /// 4. los países de sus estilos (la alterada, Estados Unidos) o de su tradición (Bilāval, la India);
    /// 5. los continentes de su tradición (la mayor, Europa).
    ///
    /// Vacío en las propias.
    public var lugaresDeOrigen: [Lugar] {
        let suyos = (regiones.map(Lugar.region) + pueblos.map(Lugar.pueblo)).sorted { $0.orden < $1.orden }
        if !suyos.isEmpty { return suyos }
        if let historico = tradicion?.lugarHistorico { return [.historico(historico)] }
        if let zonas = tradicion?.zonas, !zonas.isEmpty { return zonas.map(Lugar.zona) }
        let paises = paisesDeSusEstilos.isEmpty ? (tradicion?.paises ?? []) : paisesDeSusEstilos
        if !paises.isEmpty { return Pais.allCases.filter(paises.contains).map(Lugar.pais) }
        return (tradicion?.continentes ?? []).map(Lugar.continente)
    }

    /// Los países de donde viene, en el orden de `Pais.allCases`: los de sus lugares de origen y los que los contienen
    /// (la flamenca, España por Andalucía; los echoi, Grecia y Turquía por Bizancio). Vacío en las occidentales que
    /// son de Europa, en las propias y en las de un pueblo sin región (el klezmer).
    public var paisesDeOrigen: [Pais] {
        let lugares = Set(lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
        return Pais.allCases.filter { lugares.contains(.pais($0)) }
    }

    /// Los continentes de donde viene, en el orden de `Continente.allCases`: los de sus lugares de origen (Europa en
    /// la mayor y en las occidentales, también en la persa, que es una etiqueta europea; América en la blues).
    public var continentesDeOrigen: [Continente] {
        let lugares = Set(lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
        return Continente.allCases.filter { lugares.contains(.continente($0)) }
    }

    /// Los lugares donde también se usa: los países de sus estilos que no son de origen (el dórico, de Europa, también
    /// en Estados Unidos por el jazz) y los de origen de sus parientes (`parientes`: el frigio dominante, en el
    /// Levante, Egipto, Irak, el Golfo y el Magreb por Ḥijāz, en Turquía por Hicaz makamı, en Grecia
    /// por el dromos Hitzáz y entre los judíos asquenazíes por el Freygish). Sin los de origen ni los que contienen a
    /// uno de origen; primero los continentes, luego las zonas, los países, los lugares históricos, los pueblos y las
    /// regiones.
    public var lugaresDeUso: [Lugar] {
        let deSusEstilos = Pais.allCases.filter { pais in estilos.contains { $0.paises.contains(pais) } }.map(
            Lugar.pais)
        return TipoDeEscala.sinRepetir(deSusEstilos + parientes.flatMap(\.lugaresDeOrigen), quitando: lugaresDeOrigen)
    }

    /// Los lugares de origen de las otras escalas del catálogo con sus mismas notas que no son de uso: coincidencias,
    /// no parentescos. La mayor coincide con Bilāval (la India), con ʿAjam (el mundo árabe) y con más.
    public var lugaresQueCoinciden: [Lugar] {
        let iguales = TipoDeEscala.catalogo.filter { $0 == self && !$0.esIdentico(a: self) }
        return TipoDeEscala.sinRepetir(iguales.flatMap(\.lugaresDeOrigen), quitando: lugaresDeOrigen + lugaresDeUso)
    }

    /// Unos lugares sin repetir, sin los de `quitar` ni los que contienen a uno de ellos, ordenados.
    static func sinRepetir(_ lugares: [Lugar], quitando quitar: [Lugar]) -> [Lugar] {
        let fuera = Set(quitar.flatMap(\.conLosQueLoContienen))
        var vistos = Set<Lugar>()
        return lugares.filter { !fuera.contains($0) && vistos.insert($0).inserted }.sorted { $0.orden < $1.orden }
    }
}
