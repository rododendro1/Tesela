import Elementos

// MARK: - Los grupos de acordes de Hindemith

/// El grupo de un acorde en la clasificación de Hindemith (*Unterweisung im Tonsatz*, 1937, cap. IV), que vale para
/// cualquier acorde, se lea o no por terceras. La serie A (I, III y V) no tiene tritono; la B (II, IV y VI), sí. Los
/// grupos I y II no tienen segundas menores ni séptimas mayores; III y IV, sí; V y VI son los indeterminados (el
/// aumentado y los acordes por cuartas; el disminuido y la séptima disminuida), sin fundamental clara. El número dice
/// si la fundamental está en el bajo (1) o encima (2).
///
///     TipoDeAcorde.mayor.estadisticas.grupoDeHindemith              // .i1
///     TipoDeAcorde.dominanteSeptima.estadisticas.grupoDeHindemith   // .iia
///     TipoDeAcorde.dominanteNovena.estadisticas.grupoDeHindemith    // .iib1
///     TipoDeAcorde.disminuidoSeptima.estadisticas.grupoDeHindemith  // .vi
public enum GrupoDeHindemith: String, Sendable, Codable, CaseIterable, Comparable {
    /// Sin tritono ni segundas o séptimas, con la fundamental en el bajo: la tríada mayor o menor.
    case i1 = "I1"
    /// Lo mismo, con la fundamental encima del bajo: sus inversiones.
    case i2 = "I2"
    /// Con un tritono y una séptima menor, sin segundas mayores ni menores, y la fundamental en el bajo: la séptima de
    /// dominante.
    case iia = "IIa"
    /// Con un tritono y segundas mayores o séptimas menores (sin segundas menores), con la fundamental en el bajo:
    /// la novena de dominante.
    case iib1 = "IIb1"
    /// Lo mismo, con la fundamental encima del bajo.
    case iib2 = "IIb2"
    /// Con más de un tritono, sin segundas menores.
    case iib3 = "IIb3"
    /// Sin tritono y con segundas o séptimas, con la fundamental en el bajo: la séptima mayor, el add9.
    case iii1 = "III1"
    /// Lo mismo, con la fundamental encima del bajo.
    case iii2 = "III2"
    /// Con tritono y con segundas menores o séptimas mayores, con la fundamental en el bajo.
    case iv1 = "IV1"
    /// Lo mismo, con la fundamental encima del bajo.
    case iv2 = "IV2"
    /// Indeterminados sin tritono: el aumentado y los acordes por cuartas.
    case v = "V"
    /// Indeterminados con tritono: el disminuido y la séptima disminuida.
    case vi = "VI"

    /// Es de la serie B, la de los acordes con tritono.
    public var conTritono: Bool { [.iia, .iib1, .iib2, .iib3, .iv1, .iv2, .vi].contains(self) }

    /// En los grupos V y VI la fundamental no se determina.
    public var indeterminado: Bool { self == .v || self == .vi }

    public static func < (a: GrupoDeHindemith, b: GrupoDeHindemith) -> Bool {
        allCases.firstIndex(of: a)! < allCases.firstIndex(of: b)!
    }
}

extension GrupoDeHindemith: CustomStringConvertible {
    /// Como lo escribe Hindemith: «I 1», «II a», «II b 1», «V».
    public var description: String {
        switch self {
        case .i1: "I 1"
        case .i2: "I 2"
        case .iia: "II a"
        case .iib1: "II b 1"
        case .iib2: "II b 2"
        case .iib3: "II b 3"
        case .iii1: "III 1"
        case .iii2: "III 2"
        case .iv1: "IV 1"
        case .iv2: "IV 2"
        case .v: "V"
        case .vi: "VI"
        }
    }
}

// MARK: - La clasificación de Hindemith

/// Las cuentas de Hindemith (*Unterweisung im Tonsatz*, 1937): la fundamental por la serie 2 y el grupo.
enum Hindemith {
    /// Para cada intervalo reducido a la octava (en semitonos), su lugar en la serie de Hindemith (de más a menos
    /// fuerza de fundamental: quinta, cuarta, tercera mayor, sexta menor, tercera menor, sexta mayor, segunda mayor,
    /// séptima menor, segunda menor, séptima mayor) y si su fundamental es la nota de arriba. El tritono no tiene.
    static let serieDeHindemith: [Int: (lugar: Int, arriba: Bool)] = [
        7: (0, false), 5: (1, true), 4: (2, false), 8: (3, true), 3: (4, false), 9: (5, true), 2: (6, true),
        10: (7, false), 1: (8, true), 11: (9, false),
    ]

    /// La fundamental de Hindemith, en pasos de quinta: la del mejor intervalo de la disposición y, si está más de
    /// una vez, la del más grave. `nil` si solo hay tritonos (o una nota).
    static func fundamentalDeHindemith(_ voces: [VozMedida]) -> Int? {
        var mejor: (lugar: Int, grave: Int, fundamental: Int)?
        for i in voces.indices {
            for j in voces.indices where j > i {
                let (abajo, arriba) = (voces[i], voces[j])
                guard let intervalo = serieDeHindemith[modulo(arriba.semitonos - abajo.semitonos, 12)] else { continue }
                let candidato = (
                    intervalo.lugar, abajo.semitonos, intervalo.arriba ? arriba.pasosDeQuinta : abajo.pasosDeQuinta
                )
                if mejor.map({ (candidato.0, candidato.1) < ($0.lugar, $0.grave) }) ?? true { mejor = candidato }
            }
        }
        return mejor?.fundamental
    }

    /// El grupo de Hindemith de unas notas (en pasos de quinta), con su fundamental y su bajo.
    static func grupoDeHindemith(pasosDeQuinta: Set<Int>, fundamental: Int?, bajo: Int?) -> GrupoDeHindemith {
        let clases = Set(pasosDeQuinta.map { modulo($0 * 7, 12) })
        let vector = ConjuntoDeClasesDeAltura(clases).vectorIntervalico
        let enElBajo = fundamental != nil && fundamental == bajo
        let sinSegundas = vector[0] == 0 && vector[1] == 0
        guard vector[5] > 0 else {
            if esIndeterminadoSinTritono(clases) { return .v }
            if sinSegundas { return enElBajo ? .i1 : .i2 }
            return enElBajo ? .iii1 : .iii2
        }
        if sinSegundas { return .vi }
        if vector[0] > 0 { return enElBajo ? .iv1 : .iv2 }
        if vector[5] > 1 { return .iib3 }
        if enElBajo, let fundamental, vector[1] == 1, clases.contains(modulo(fundamental * 7 + 10, 12)) {
            return .iia
        }
        return enElBajo ? .iib1 : .iib2
    }

    /// El aumentado (tres terceras mayores) o un acorde de tres o más cuartas justas seguidas.
    static func esIndeterminadoSinTritono(_ clases: Set<Int>) -> Bool {
        let n = clases.count
        guard n >= 3 else { return false }
        if ConjuntoDeClasesDeAltura(clases).formaPrima == [0, 4, 8] { return true }
        return clases.contains { inicio in Set((0..<n).map { modulo(inicio + 5 * $0, 12) }) == clases }
    }
}
