import Elementos

// MARK: - Dónde está cada escala
//
// Los lugares (Lugar.swift) de las regiones, las tradiciones, los estilos y las escalas: los de origen y los de uso.

// MARK: Dónde están las regiones y las tradiciones

extension RegionDeEscala {
    /// Los países en que está: Java, en Indonesia; los Alpes, en Suiza y Austria; los mandinga, en Malí, Senegal,
    /// Gambia y Guinea. El `switch` no tiene `default`: una región nueva no compila sin los suyos.
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
        case .flamenco: [.espana]
        case .clasica, .folclore, .popRock, .sintetica, .deCompositor: []
        }
    }
}

// MARK: Los lugares de una escala

extension TipoDeEscala {
    /// Las occidentales cuyo nombre es geográfico pero no dice de dónde vienen: la persa, la egipcia, la oriental y la
    /// argelina son etiquetas exóticas de los libros de escalas, sin nada que ver con la música de esos lugares (la
    /// argelina, la de los libros de los años ochenta, no es la de once notas que Ibert usó en «Escales»), y las
    /// napolitanas se llaman así por la sexta napolitana, no por Nápoles. Como las demás occidentales, son de Europa.
    public static let nombresGeograficosSinOrigen: [TipoDeEscala] = [
        .persa, .egipcia, .oriental, .argelina, .napolitanaMenor, .napolitanaMayor,
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
    /// Todas las de una familia tienen las mismas notas, al subir o al bajar (Hicaz makamı baja como el frigio
    /// dominante).
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
        let iguales = TipoDeEscala.delCatalogo(todasCon: contenido).filter { !$0.esIdentico(a: self) }
        return TipoDeEscala.sinRepetir(iguales.flatMap(\.lugaresDeOrigen), quitando: lugaresDeOrigen + lugaresDeUso)
    }

    /// Unos lugares sin repetir, sin los de `quitar` ni los que contienen a uno de ellos, ordenados.
    static func sinRepetir(_ lugares: [Lugar], quitando quitar: [Lugar]) -> [Lugar] {
        let fuera = Set(quitar.flatMap(\.conLosQueLoContienen))
        var vistos = Set<Lugar>()
        return lugares.filter { !fuera.contains($0) && vistos.insert($0).inserted }.sorted { $0.orden < $1.orden }
    }
}
