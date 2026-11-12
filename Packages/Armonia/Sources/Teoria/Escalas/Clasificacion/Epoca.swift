import Elementos

// MARK: - La época de una escala

/// La época de la historia de la música occidental en que aparece o se usa una escala: la antigüedad, la Edad Media,
/// el Renacimiento, la época tonal (la de la mayor y la menor, de 1600 a 1900, la que en inglés se llama «common
/// practice») y el siglo XX.
///
/// No se escribe en las escalas: se calcula con lo que el catálogo ya sabe de ellas. La de origen
/// (`TipoDeEscala.epocaDeOrigen`), con su fuente teórica, su tradición, las escalas gregorianas y renacentistas con sus
/// mismas notas, su escala madre o sus estilos; las de uso (`TipoDeEscala.epocasDeUso`), con sus estilos.
///
///     TipoDeEscala.dorico.epocaDeOrigen      // .edadMedia (como el protus de los modos gregorianos)
///     TipoDeEscala.dorico.epocasDeUso        // [.tonal, .sigloXX] (la música clásica y el jazz)
///     TipoDeEscala.alterada.epocaDeOrigen    // .sigloXX
public enum Epoca: String, Sendable, Codable, CaseIterable, Comparable {
    /// Antes del año 500: la Grecia antigua, Mesopotamia, los teóricos griegos y chinos antiguos.
    case antiguedad
    /// De 500 a 1400: los modos gregorianos, Guido d'Arezzo, Ṣafī al-Dīn.
    case edadMedia
    /// De 1400 a 1600: Ramos de Pareja, Glareano, Vicentino, Zarlino, Salinas.
    case renacimiento
    /// De 1600 a 1900, la época tonal: la mayor y las menores de la música clásica.
    case tonal
    /// Desde 1900: el jazz, el blues y las escalas de compositor.
    case sigloXX

    /// La de un año: antes de 500, la antigüedad; antes de 1400, la Edad Media; antes de 1600, el Renacimiento; antes
    /// de 1900, la época tonal; desde 1900, el siglo XX.
    ///
    ///     Epoca(anio: 1859)   // .tonal
    public init(anio: Int) {
        switch anio {
        case ..<500: self = .antiguedad
        case ..<1400: self = .edadMedia
        case ..<1600: self = .renacimiento
        case ..<1900: self = .tonal
        default: self = .sigloXX
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

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`. El `switch` no tiene `default`: una época nueva no
    /// compila sin el suyo.
    private var traduccion: Traduccion {
        switch self {
        case .antiguedad: TextosDeTeoria.traduccion(\.epocaAntiguedad)
        case .edadMedia: TextosDeTeoria.traduccion(\.epocaEdadMedia)
        case .renacimiento: TextosDeTeoria.traduccion(\.epocaRenacimiento)
        case .tonal: TextosDeTeoria.traduccion(\.epocaTonal)
        case .sigloXX: TextosDeTeoria.traduccion(\.epocaSigloXX)
        }
    }
}

extension Epoca: Nombrable {}

// MARK: - La época de lo que ya hay en el catálogo

extension FuenteTeorica {
    /// La época del teórico. El `switch` no tiene `default`: una fuente nueva no compila sin la suya.
    public var epoca: Epoca {
        switch self {
        case .arquitas, .aristoxeno, .eratostenes, .didimo, .ptolomeo, .aristides, .guanzi, .lushiChunqiu:
            .antiguedad
        case .guido, .safiAlDin: .edadMedia
        case .ramosDePareja, .glareano, .vicentino, .zarlino, .salinas, .zhuZaiyu: .renacimiento
        case .chrysanthos: .tonal
        case .arelEzgiUzdilek: .sigloXX
        }
    }
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
    /// La época en que se usan las escalas de un estilo occidental: la tonal en la música clásica y el siglo XX en
    /// el jazz, el blues y las escalas de compositor. `nil` en las populares y las sintéticas, que no son de una
    /// época, y en los estilos de otras tradiciones. El `switch` no tiene `default`: un estilo nuevo no compila sin
    /// decir la suya.
    public var epocaDeUso: Epoca? {
        switch self {
        case .clasica: .tonal
        case .jazz, .blues, .sigloXX: .sigloXX
        case .popular, .sintetica, .carnatica, .indostanica, .indiaAntigua, .gagaku: nil
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
    /// 0. la del año de la obra más antigua que la da (`documentada`): la menor húngara, la época tonal por Liszt
    ///    (1859); Rast makamı, por Cantemir (hacia 1700);
    /// 1. la de su fuente teórica (`fuente`): los géneros de Ptolomeo son de la antigüedad, los modos de Glareano del
    ///    Renacimiento;
    /// 2. la de su tradición, si es una época (`Tradicion.epoca`): las harmoniai son de la antigüedad, los modos
    ///    gregorianos de la Edad Media;
    /// 3. en las occidentales de la música clásica (las de estilo `.clasica`, cuyos nombres vienen de los modos), la
    ///    más antigua de las escalas gregorianas y renacentistas con sus mismas notas: el dórico sale medieval por el
    ///    protus, y la mayor, renacentista por el jónico de Glareano;
    /// 4. en las occidentales sintéticas, la de la escala de la que son modo (`Escala.escalaMadre`): el locrio ♮6, la
    ///    de la menor armónica;
    /// 5. en las occidentales sintéticas y populares, la más antigua de las escalas de las que son un modo
    ///    (`occidentalesQueFechanSusModos`; en las populares, solo las documentadas): el ultrafrigio y la doble
    ///    armónica, la época tonal por la menor húngara; la mayor locria, por la napolitana mayor;
    /// 6. la más antigua de las de uso de sus estilos (`Estilo.epocaDeUso`): la alterada, el siglo XX por el jazz.
    ///
    /// `nil` si ninguna da nada: las populares (la flamenca, la mayor rumana), las de otras tradiciones que no son de
    /// una época y las propias.
    public var epocaDeOrigen: Epoca? {
        if let anio = documentada?.anio { return Epoca(anio: anio) }
        if let epoca = fuente?.epoca ?? tradicion?.epoca { return epoca }
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
        return estilos.compactMap(\.epocaDeUso).min()
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

    /// Las épocas en que se usa la escala, por sus estilos (`Estilo.epocaDeUso`), en orden y sin la de origen: el
    /// dórico, la tonal y el siglo XX (es clásica y de jazz). Vacío si sus estilos no dan ninguna.
    public var epocasDeUso: [Epoca] {
        let origen = epocaDeOrigen
        return Epoca.allCases.filter { epoca in epoca != origen && estilos.contains { $0.epocaDeUso == epoca } }
    }

    /// La de origen y las de uso, en orden: el dórico, la Edad Media, la tonal y el siglo XX.
    public var epocas: [Epoca] {
        let origen = epocaDeOrigen
        let uso = epocasDeUso
        return Epoca.allCases.filter { $0 == origen || uso.contains($0) }
    }
}
