// Series dodecafónicas: las doce clases de altura en un orden.
//
// Cada serie tiene 48 formas: las doce transposiciones de la original (P), de su inversión (I), de su retrógrado (R)
// y del retrógrado de la inversión (RI). Se nombran por la clase con la que empieza la original o la inversión,
// como en Straus: P₃ empieza en 3, I₃ también, R₃ es P₃ al revés (acaba en 3) y RI₃ es I₃ al revés.

/// Los cuatro tipos de forma de una serie.
public enum TipoDeFormaDeSerie: String, CaseIterable, Hashable, Sendable, Codable {
    /// P, la serie original (prime) y sus transposiciones.
    case original
    /// I, la inversión: cada intervalo, al revés.
    case inversion
    /// R, el retrógrado: la original de atrás adelante.
    case retrogrado
    /// RI, el retrógrado de la inversión.
    case retrogradoDeLaInversion

    /// La letra con que se escribe: P, I, R o RI.
    public var simbolo: String {
        switch self {
        case .original: return "P"
        case .inversion: return "I"
        case .retrogrado: return "R"
        case .retrogradoDeLaInversion: return "RI"
        }
    }
}

/// Una de las 48 formas de una serie: su tipo y la clase con que empieza la original o la inversión de la que sale.
public struct FormaDeSerie: Hashable, Sendable, CustomStringConvertible, Codable {
    public let tipo: TipoDeFormaDeSerie
    /// 0…11. En P e I, la primera clase; en R y RI, la última (la primera de la P o la I que se lee al revés).
    public let indice: Int

    public init(_ tipo: TipoDeFormaDeSerie, _ indice: Int) {
        self.tipo = tipo
        self.indice = modulo(indice, 12)
    }

    /// «P0», «I5», «R11», «RI7».
    public var description: String { tipo.simbolo + String(indice) }

    /// Las 48, en orden: P0…P11, I0…I11, R0…R11 y RI0…RI11.
    public static let todas: [FormaDeSerie] = TipoDeFormaDeSerie.allCases.flatMap { tipo in
        (0..<12).map { FormaDeSerie(tipo, $0) }
    }
}

/// Las doce clases de altura, cada una una vez, en un orden.
///
///     let serie = try SerieDodecafonica(leyendo: "0 e 7 4 2 9 3 8 t 1 5 6")   // la de la Suite lírica de Berg, en P0
///     serie.forma(.init(.inversion, 0))     // I0
///     serie.matriz                          // la matriz de 12 × 12
///     serie.esDeTodosLosIntervalos          // true
///     serie.identificar(serie.retrogrado(0))   // [R0]
public struct SerieDodecafonica: Hashable, Sendable, CustomStringConvertible {
    /// Las doce clases (0 = Do … 11 = Si) en su orden.
    public let clases: [Int]

    /// La serie con esas clases en ese orden (reducidas a 0…11), o `nil` si no están las doce una vez cada una.
    public init?<S: Sequence>(_ clases: S) where S.Element == Int {
        let reducidas = clases.map { modulo($0, 12) }
        guard SerieDodecafonica.faltanYRepetidas(reducidas) == nil else { return nil }
        self.clases = reducidas
    }

    /// La serie de las clases de altura de las notas, o `nil` si no son las doce una vez cada una.
    public init?(notas: [Nota]) { self.init(notas.map(\.claseDeAltura)) }

    /// Lee una serie escrita a mano, como los conjuntos (`ConjuntoDeClases/init(leyendo:)`) pero sin ordenar:
    /// «0 e 7 4 2 9 3 8 t 1 5 6», «[0, 11, 7, 4, …]», «0e742 938t156», «Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si».
    ///
    /// Lanza `ErrorDeLectura`; si las clases se leen pero no son las doce, con
    /// `ErrorDeLectura/Motivo/serieNoDodecafonica(faltan:repetidas:)`.
    public init(leyendo texto: String) throws {
        let leidas = try LecturaDeClases.leer(texto).map { modulo($0, 12) }
        if let (faltan, repetidas) = SerieDodecafonica.faltanYRepetidas(leidas) {
            throw ErrorDeLectura(
                texto: texto, posicion: nil, motivo: .serieNoDodecafonica(faltan: faltan, repetidas: repetidas))
        }
        self.clases = leidas
    }

    /// Las clases que faltan y las que se repiten, o `nil` si están las doce una vez cada una.
    private static func faltanYRepetidas(_ clases: [Int]) -> (faltan: [Int], repetidas: [Int])? {
        var veces = [Int](repeating: 0, count: 12)
        for clase in clases { veces[clase] += 1 }
        let faltan = (0..<12).filter { veces[$0] == 0 }
        let repetidas = (0..<12).filter { veces[$0] > 1 }
        return faltan.isEmpty && repetidas.isEmpty ? nil : (faltan, repetidas)
    }

    private init(sinComprobar clases: [Int]) { self.clases = clases }

    /// Las clases separadas por espacios, con t y e para 10 y 11: «0 e 7 4 2 9 3 8 t 1 5 6». Se puede volver a leer.
    public var description: String { clases.map(LecturaDeClases.cifra).joined(separator: " ") }

    // MARK: Formas

    /// Tn: suma `n` semitonos a cada clase.
    public func transponer(_ n: Int) -> SerieDodecafonica {
        SerieDodecafonica(sinComprobar: clases.map { modulo($0 + n, 12) })
    }

    /// Una de las 48 formas.
    public func forma(_ forma: FormaDeSerie) -> SerieDodecafonica {
        let inicio = clases[0]
        switch forma.tipo {
        case .original:
            return transponer(forma.indice - inicio)
        case .inversion:
            return SerieDodecafonica(sinComprobar: clases.map { modulo(forma.indice + inicio - $0, 12) })
        case .retrogrado:
            return SerieDodecafonica(sinComprobar: self.forma(FormaDeSerie(.original, forma.indice)).clases.reversed())
        case .retrogradoDeLaInversion:
            return SerieDodecafonica(sinComprobar: self.forma(FormaDeSerie(.inversion, forma.indice)).clases.reversed())
        }
    }

    /// Pₙ: la original, empezando en `n`.
    public func original(_ n: Int) -> SerieDodecafonica { forma(FormaDeSerie(.original, n)) }
    /// Iₙ: la inversión, empezando en `n`.
    public func inversion(_ n: Int) -> SerieDodecafonica { forma(FormaDeSerie(.inversion, n)) }
    /// Rₙ: Pₙ al revés (acaba en `n`).
    public func retrogrado(_ n: Int) -> SerieDodecafonica { forma(FormaDeSerie(.retrogrado, n)) }
    /// RIₙ: Iₙ al revés (acaba en `n`).
    public func retrogradoDeLaInversion(_ n: Int) -> SerieDodecafonica {
        forma(FormaDeSerie(.retrogradoDeLaInversion, n))
    }

    /// Las 48 formas, en el orden de `FormaDeSerie/todas`.
    public var formas: [(forma: FormaDeSerie, serie: SerieDodecafonica)] {
        FormaDeSerie.todas.map { ($0, forma($0)) }
    }

    /// Las formas de esta serie que son `otra`: [P0] para la propia serie, [] si `otra` no es ninguna de sus 48
    /// formas. Puede haber más de una si la serie es simétrica (su retrógrado es una transposición o una
    /// inversión de ella).
    public func identificar(_ otra: SerieDodecafonica) -> [FormaDeSerie] {
        FormaDeSerie.todas.filter { forma($0) == otra }
    }

    /// Cuántas de las 48 formas son distintas: 48, o 24 en las series simétricas.
    public var numeroDeFormasDistintas: Int { Set(formas.map(\.serie)).count }

    // MARK: Matriz

    /// La matriz de 12 × 12: la primera fila es la serie y la primera columna, su inversión desde la misma clase.
    /// Cada fila, de izquierda a derecha, es una P (`matriz[i][0]` es su índice) y, de derecha a izquierda, la R del
    /// mismo índice; cada columna, de arriba abajo, es una I (`matriz[0][j]`) y, de abajo arriba, su RI.
    public var matriz: [[Int]] {
        inversion(clases[0]).clases.map { original($0).clases }
    }

    // MARK: Intervalos

    /// Los once intervalos de una clase a la siguiente, en semitonos hacia arriba (1…11).
    public var intervalos: [Int] {
        zip(clases, clases.dropFirst()).map { modulo($1 - $0, 12) }
    }

    /// Si sus once intervalos son todos distintos (del 1 al 11): una serie de todos los intervalos, como la de la
    /// Suite lírica de Berg.
    public var esDeTodosLosIntervalos: Bool { Set(intervalos).count == 11 }

    // MARK: Hexacordos y combinatoriedad

    /// Las seis primeras clases y las seis últimas, como conjuntos.
    public var hexacordos: (primero: ConjuntoDeClases, segundo: ConjuntoDeClases) {
        (ConjuntoDeClases(clases[..<6]), ConjuntoDeClases(clases[6...]))
    }

    /// Las formas cuyo primer hexacordo es el segundo de esta serie: tocadas a la vez que ella, cada mitad completa
    /// el total cromático con la mitad de la otra (combinatoriedad hexacordal de Babbitt).
    public var formasCombinatorias: [FormaDeSerie] {
        let segundo = hexacordos.segundo
        return FormaDeSerie.todas.filter { forma($0).hexacordos.primero == segundo }
    }

    /// Los tipos de forma con que la serie es combinatoria: con alguna transposición de la original (P), de la
    /// inversión (I), del retrógrado (R) o del retrógrado de la inversión (RI). R está siempre, por su propio
    /// retrógrado.
    public var tiposDeCombinatoriedad: Set<TipoDeFormaDeSerie> { Set(formasCombinatorias.map(\.tipo)) }

    /// Combinatoria con los cuatro tipos (P, I, R y RI): la de los seis hexacordos de Babbitt que lo permiten,
    /// como el cromático [0, 1, 2, 3, 4, 5] o el de tonos enteros.
    public var esTotalmenteCombinatoria: Bool { tiposDeCombinatoriedad.count == TipoDeFormaDeSerie.allCases.count }
}

extension SerieDodecafonica: Transponible {
    /// Transpone por los semitonos del intervalo (la ortografía no cuenta en una serie).
    public func transponer(_ intervalo: Intervalo) -> SerieDodecafonica { transponer(intervalo.semitonosConSigno) }
}

extension SerieDodecafonica: Codable {
    /// Como la lista de sus doce clases, `[0, 11, 7, …]`.
    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.singleValueContainer()
        let clases = try contenedor.decode([Int].self)
        guard let serie = SerieDodecafonica(clases) else {
            throw DecodingError.dataCorruptedError(
                in: contenedor, debugDescription: "No son las doce clases de altura una vez cada una: \(clases)")
        }
        self = serie
    }

    public func encode(to encoder: Encoder) throws {
        var contenedor = encoder.singleValueContainer()
        try contenedor.encode(clases)
    }
}
