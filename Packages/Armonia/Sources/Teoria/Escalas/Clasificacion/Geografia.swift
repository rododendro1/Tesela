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
            .indonesia, .tailandia, .camboya, .myanmar:
            .asia
        case .uganda, .mozambique, .zimbabue, .mali, .senegal, .gambia, .guinea, .etiopia: .africa
        case .brasil, .peru, .bolivia, .ecuador: .america
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
        }
    }
}

extension Pais: Nombrable {}

// MARK: Lugar

/// Un lugar de donde viene una escala, en uno de sus tres niveles: un continente, un país o una región (o un pueblo).
/// `contenidoEn` da los lugares que lo contienen: Andalucía está en España, que está en Europa.
public enum Lugar: Hashable, Sendable, Codable {
    case continente(Continente)
    case pais(Pais)
    case region(RegionDeEscala)

    /// Los lugares que lo contienen, del más cercano al más lejano: Andalucía → España, Europa. Una región en varios
    /// países (los Alpes, los mandinga) da todos sus países y sus continentes.
    public var contenidoEn: [Lugar] {
        switch self {
        case .continente: []
        case .pais(let pais): [.continente(pais.continente)]
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
        case .region(let region): region.nombre(en: notacion)
        }
    }

    /// Para ordenar: primero los continentes, luego los países y luego las regiones, cada uno en el orden de sus casos.
    var orden: Int {
        switch self {
        case .continente(let continente): Continente.allCases.firstIndex(of: continente)!
        case .pais(let pais): 100 + Pais.allCases.firstIndex(of: pais)!
        case .region(let region): 1000 + RegionDeEscala.allCases.firstIndex(of: region)!
        }
    }

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

    /// Los países de donde viene, en el orden de `Pais.allCases`: los de sus regiones (la flamenca, España por
    /// Andalucía) o, si no tiene, los de su tradición (Bayātī no tiene: el mundo árabe es de varios). Vacío en las
    /// occidentales sin región y en las propias.
    public var paisesDeOrigen: [Pais] {
        let suyos = regiones.isEmpty ? (tradicion?.paises ?? []) : regiones.flatMap(\.paises)
        return Pais.allCases.filter(suyos.contains)
    }

    /// Los continentes de donde viene: los de sus países o, si no tiene, los de su tradición (Europa en la mayor y en
    /// las occidentales, también en la persa, que es una etiqueta europea).
    public var continentesDeOrigen: [Continente] {
        let paises = paisesDeOrigen
        return paises.isEmpty ? (tradicion?.continentes ?? []) : Lugar.continentes(de: paises)
    }

    /// Los lugares de donde viene, los más concretos que se saben: sus regiones (la flamenca, Andalucía), si no sus
    /// países (Bilāval, India) y si no sus continentes (la mayor, Europa; Bayātī, Asia y África). Vacío en las propias.
    public var lugaresDeOrigen: [Lugar] {
        if !regiones.isEmpty { return regiones.map(Lugar.region) }
        let paises = paisesDeOrigen
        if !paises.isEmpty { return paises.map(Lugar.pais) }
        return continentesDeOrigen.map(Lugar.continente)
    }

    /// Los lugares donde también se tocan sus notas: los de origen de las otras escalas del catálogo con su mismo
    /// contenido, sin los que ya son de origen ni los que contienen a uno de origen, primero los continentes, luego los
    /// países y luego las regiones. El frigio dominante, de Europa, se toca también en el mundo árabe (Ḥijāz), en Turquía
    /// (Hicaz makamı) y en Grecia (el dromos Hitzáz). Vacío si ninguna otra escala tiene sus notas.
    public var lugaresDeUso: [Lugar] {
        let origen = Set(lugaresDeOrigen.flatMap(\.conLosQueLoContienen))
        var vistos = Set<Lugar>()
        return TipoDeEscala.catalogo.filter { $0 == self && !$0.esIdentico(a: self) }
            .flatMap(\.lugaresDeOrigen)
            .filter { !origen.contains($0) && vistos.insert($0).inserted }
            .sorted { $0.orden < $1.orden }
    }
}
