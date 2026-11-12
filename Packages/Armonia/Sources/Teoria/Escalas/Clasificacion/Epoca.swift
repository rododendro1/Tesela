import Elementos

// MARK: - La época de una escala

/// La época de la historia de la música occidental en que aparece o se usa una escala: la antigüedad, la Edad Media,
/// el Renacimiento, las tres de la época tonal (el Barroco, el Clasicismo y el Romanticismo, de 1600 a 1900, la que en
/// inglés se llama «common practice»), el siglo XX y el XXI.
///
/// No se escribe en las escalas: se calcula con lo que el catálogo ya sabe de ellas. La de origen
/// (`TipoDeEscala.epocaDeOrigen`), con la obra que la documenta, su fuente teórica, su tradición, las escalas
/// gregorianas y renacentistas con sus mismas notas, su escala madre o sus estilos; las de uso
/// (`TipoDeEscala.epocasDeUso`), con sus estilos.
///
///     TipoDeEscala.dorico.epocaDeOrigen      // .edadMedia (como el protus de los modos gregorianos)
///     TipoDeEscala.dorico.epocasDeUso        // [.barroco, .clasicismo, .romanticismo, .sigloXX, .sigloXXI]
///     TipoDeEscala.alterada.epocaDeOrigen    // .sigloXX
public enum Epoca: String, Sendable, Codable, CaseIterable, Comparable {
    /// Antes del año 500: la Grecia antigua, Mesopotamia, los teóricos griegos y chinos antiguos.
    case antiguedad
    /// De 500 a 1400: los modos gregorianos, Guido d'Arezzo, Ṣafī al-Dīn.
    case edadMedia
    /// De 1400 a 1600: Ramos de Pareja, Glareano, Vicentino, Zarlino, Salinas.
    case renacimiento
    /// De 1600 a 1750: el bajo continuo y la llegada de la mayor y la menor.
    case barroco
    /// De 1750 a 1820: Haydn, Mozart, Beethoven.
    case clasicismo
    /// De 1820 a 1900: Liszt, Chrysanthos, Glinka, Rimski-Kórsakov.
    case romanticismo
    /// De 1900 a 2000: el jazz, el blues y las escalas de compositor.
    case sigloXX
    /// Desde 2000.
    case sigloXXI

    /// Las tres de la época tonal, de 1600 a 1900.
    public static let tonales: [Epoca] = [.barroco, .clasicismo, .romanticismo]

    /// Es una de las de la época tonal: el Barroco, el Clasicismo o el Romanticismo.
    public var esTonal: Bool { Epoca.tonales.contains(self) }

    /// La de un año: antes de 500, la antigüedad; antes de 1400, la Edad Media; antes de 1600, el Renacimiento; antes
    /// de 1750, el Barroco; antes de 1820, el Clasicismo; antes de 1900, el Romanticismo; antes de 2000, el siglo XX;
    /// desde 2000, el XXI.
    ///
    ///     Epoca(anio: 1859)   // .romanticismo
    public init(anio: Int) {
        switch anio {
        case ..<500: self = .antiguedad
        case ..<1400: self = .edadMedia
        case ..<1600: self = .renacimiento
        case ..<1750: self = .barroco
        case ..<1820: self = .clasicismo
        case ..<1900: self = .romanticismo
        case ..<2000: self = .sigloXX
        default: self = .sigloXXI
        }
    }

    /// Por orden cronológico, el de `allCases`.
    public static func < (a: Epoca, b: Epoca) -> Bool {
        let orden = Epoca.allCases
        return orden.firstIndex(of: a)! < orden.firstIndex(of: b)!
    }

    /// El nombre en el idioma de los textos de la notación: «Edad Media», «Middle Ages», «Mittelalter». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre de las tres de la época tonal juntas: «época tonal», «tonal era».
    public static func nombreDeLaEpocaTonal(en notacion: Notacion) -> String {
        TextosDeTeoria.traduccion(\.epocaTonal).en(notacion)
    }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: una época nueva no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .antiguedad: TextosDeTeoria.traduccion(\.epocaAntiguedad)
        case .edadMedia: TextosDeTeoria.traduccion(\.epocaEdadMedia)
        case .renacimiento: TextosDeTeoria.traduccion(\.epocaRenacimiento)
        case .barroco: TextosDeTeoria.traduccion(\.epocaBarroco)
        case .clasicismo: TextosDeTeoria.traduccion(\.epocaClasicismo)
        case .romanticismo: TextosDeTeoria.traduccion(\.epocaRomanticismo)
        case .sigloXX: TextosDeTeoria.traduccion(\.epocaSigloXX)
        case .sigloXXI: TextosDeTeoria.traduccion(\.epocaSigloXXI)
        }
    }
}

extension Epoca: Nombrable {}

// MARK: - La época de lo que ya hay en el catálogo

extension FuenteTeorica {
    /// El año de su obra, aproximado en las antiguas (los años antes de Cristo son negativos): Arquitas, hacia 380 a. C.;
    /// Glareano, 1547. El `switch` no tiene `default`: una fuente nueva no compila sin el suyo.
    public var anio: Int {
        switch self {
        case .arquitas: -380
        case .aristoxeno: -330
        case .guanzi: -350
        case .eratostenes: -240
        case .lushiChunqiu: -239
        case .didimo: -30
        case .ptolomeo: 150
        case .aristides: 300
        case .guido: 1026
        case .safiAlDin: 1252
        case .ramosDePareja: 1482
        case .glareano: 1547
        case .vicentino: 1555
        case .zarlino: 1558
        case .salinas: 1577
        case .zhuZaiyu: 1584
        case .chrysanthos: 1832
        case .arelEzgiUzdilek: 1933
        }
    }

    /// La época del teórico, la de su año.
    public var epoca: Epoca { Epoca(anio: anio) }
}

extension Tradicion {
    /// La época de las tradiciones que son una época: la Grecia antigua y Mesopotamia, el canto gregoriano y el
    /// Renacimiento. `nil` en las demás, que no son de una época sola. El `switch` no tiene `default`: una tradición
    /// nueva no compila sin decir si lo es.
    public var epoca: Epoca? {
        switch self {
        case .greciaAntigua, .mesopotamia: .antiguedad
        case .gregoriano: .edadMedia
        case .renacimiento: .renacimiento
        case .occidental, .india, .grecia, .mundoArabe, .persia, .turquia, .azerbaiyan, .china, .japon, .corea,
            .etiopia, .indonesia, .klezmer, .andes, .bizancio, .africa, .sudesteAsiatico, .europa, .vietnam, .brasil:
            nil
        }
    }
}

extension Estilo {
    /// Las épocas en que se usan las escalas de un estilo occidental, en orden: las tres de la época tonal en la
    /// música clásica; el siglo XX y el XXI en el jazz y el blues, que se siguen tocando; el siglo XX en las escalas
    /// de compositor. Vacío en las populares y las sintéticas, que no son de una época, y en los estilos de otras
    /// tradiciones. El `switch` no tiene `default`: un estilo nuevo no compila sin decir las suyas.
    public var epocasDeUso: [Epoca] {
        switch self {
        case .clasica: Epoca.tonales
        case .jazz, .blues: [.sigloXX, .sigloXXI]
        case .sigloXX: [.sigloXX]
        case .popular, .sintetica, .carnatica, .indostanica, .indiaAntigua, .gagaku: []
        }
    }
}

// MARK: - La época de una escala

extension TipoDeEscala {
    /// Las tradiciones cuyas escalas fechan a las occidentales de la música clásica con sus mismas notas: de ellas
    /// vienen los nombres de los modos y de la mayor y la menor. Las de jazz no se fechan así: la bebop dominante tiene
    /// las notas de una escala del Renacimiento, pero no viene de ella.
    static let tradicionesQueFechan: Set<Tradicion> = [.gregoriano, .renacimiento]

    /// La época en que aparece la escala. Es la primera de estas que da algo:
    ///
    /// 1. la de su año (`anioDeOrigen`): el de la obra más antigua que la da (`documentada`: la menor húngara, la
    ///    el Romanticismo por Liszt en 1859; los tonos enteros, por Glinka en 1842), el de su fuente teórica (los géneros de Ptolomeo son de la antigüedad, los
    ///    modos de Glareano del Renacimiento) o el de su categoría (los mēḷa, de 1660);
    /// 2. la de su tradición, si es una época (`Tradicion.epoca`): las harmoniai son de la antigüedad, los modos
    ///    gregorianos de la Edad Media;
    /// 3. en las occidentales de la música clásica (las de estilo `.clasica`, cuyos nombres vienen de los modos), la
    ///    más antigua de las escalas gregorianas y renacentistas con sus mismas notas: el dórico sale medieval por el
    ///    protus, y la mayor, renacentista por el jónico de Glareano;
    /// 4. en las occidentales sintéticas, la de la escala de la que son modo (`Escala.escalaMadre`): el locrio ♮6, la
    ///    de la menor armónica;
    /// 5. en las occidentales sintéticas y populares, la más antigua de las escalas de las que son un modo
    ///    (`occidentalesQueFechanSusModos`; en las populares, solo las documentadas): el ultrafrigio y la doble
    ///    armónica, el Romanticismo por la menor húngara; la mayor locria, por la napolitana mayor;
    /// 6. la más antigua de las de uso de sus estilos (`Estilo.epocasDeUso`): la alterada, el siglo XX por el jazz.
    ///
    /// `nil` si ninguna da nada: las populares (la flamenca, la mayor rumana), las de otras tradiciones que no son de
    /// una época y las propias.
    public var epocaDeOrigen: Epoca? {
        if let anio = anioDeOrigen { return Epoca(anio: anio) }
        if let epoca = tradicion?.epoca { return epoca }
        guard tradicion == .occidental else { return nil }
        if estilos.contains(.clasica) {
            let equivalentes = TipoDeEscala.tradicionales.filter {
                $0 == self && $0.tradicion.map(TipoDeEscala.tradicionesQueFechan.contains) == true
            }
            if let epoca = equivalentes.compactMap(\.epocaDeOrigen).min() { return epoca }
        }
        if estilos.contains(.sintetica), let madre = Escala(.do, self).escalaMadre, madre.grado != 1,
            let epoca = madre.madre.tipo.epocaDeOrigen
        {
            return epoca
        }
        if estilos.contains(.sintetica) || estilos.contains(.popular),
            let epoca = TipoDeEscala.occidentalesQueFechanSusModos
                .filter({ esModo(de: $0) && ($0.documentada != nil || estilos.contains(.sintetica)) })
                .compactMap(\.epocaDeOrigen).min()
        {
            return epoca
        }
        return estilos.flatMap(\.epocasDeUso).min()
    }

    /// Las occidentales de cuyos modos toman la época las sintéticas y las populares: las que tienen una obra que las
    /// documenta (`documentada`: la menor húngara) y las que no son sintéticas ni populares (las napolitanas, de la
    /// música clásica). Las sintéticas y las populares sin obra no cuentan: su época sale de esta misma regla.
    /// Las populares solo la toman de las documentadas: la flamenca tiene las notas de un modo de una escala de jazz,
    /// pero no viene del jazz.
    static let occidentalesQueFechanSusModos = TipoDeEscala.occidentales.filter {
        $0.documentada != nil || !($0.estilos.contains(.sintetica) || $0.estilos.contains(.popular))
    }

    /// Es otro modo de esa escala: tiene sus mismos intervalos empezando en otro grado.
    func esModo(de otra: TipoDeEscala) -> Bool {
        !esIdentico(a: otra) && !esDireccional && !otra.esDireccional && intervalos.count == otra.intervalos.count
            && (1...otra.intervalos.count).contains { otra.modo(grado: $0) == self }
    }

    /// Las épocas en que se usa la escala, por sus estilos (`Estilo.epocasDeUso`), en orden y sin la de origen: el
    /// dórico, las tres tonales, el siglo XX y el XXI (es clásica y de jazz). Vacío si sus estilos no dan ninguna.
    public var epocasDeUso: [Epoca] {
        let origen = epocaDeOrigen
        return Epoca.allCases.filter { epoca in epoca != origen && estilos.contains { $0.epocasDeUso.contains(epoca) } }
    }

    /// La de origen y las de uso, en orden: el dórico, la Edad Media, las tres tonales, el siglo XX y el XXI.
    public var epocas: [Epoca] {
        let origen = epocaDeOrigen
        let uso = epocasDeUso
        return Epoca.allCases.filter { $0 == origen || uso.contains($0) }
    }
}

// MARK: - La época del nombre

extension TipoDeEscala {
    /// El año del nombre de las escalas cuyo nombre no es de la época de sus notas: los cuatro modos que la «Alia musica» (hacia 900) llama con los nombres griegos, y la mayor y la
    /// menor, que la teoría francesa de finales del siglo XVII (Jean Rousseau, Masson) deja como los dos únicos modos.
    static let aniosDeLosNombres: [(tipo: TipoDeEscala, anio: Int)] = [
        (.dorico, 900), (.frigio, 900), (.lidio, 900), (.mixolidio, 900), (.mayor, 1690), (.menorNatural, 1690),
    ]

    /// La época de su nombre: la de `aniosDeLosNombres` si está, y si no la de origen, que es la de sus notas. La
    /// mayor tiene las notas del jónico de Glareano (el Renacimiento), pero se llama «mayor» desde el Barroco.
    ///
    ///     TipoDeEscala.mayor.epocaDeOrigen    // .renacimiento
    ///     TipoDeEscala.mayor.epocaDelNombre   // .barroco
    public var epocaDelNombre: Epoca? {
        if let anio = TipoDeEscala.aniosDeLosNombres.first(where: { $0.tipo.esIdentico(a: self) })?.anio {
            return Epoca(anio: anio)
        }
        return epocaDeOrigen
    }
}
