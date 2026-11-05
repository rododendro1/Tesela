import ArmoniaNucleo

// MARK: - Lo que se mide de una escala

/// Lo que se mide de una escala por sus notas: cuántas tiene, lo brillante que es, qué intervalos contiene, cómo se
/// reparten y cuánto se repite. Salvo el brillo por quintas, que usa la ortografía, todo sale de las clases de altura
/// (los doce semitonos): en una escala con microtonos es una aproximación, y `aproximada` lo dice.
///
///     let mayor = Escala(.do, .mayor).estadisticas
///     mayor.cardinal              // .heptatonica
///     mayor.brilloPorQuintas      // 2.0 (lidio 3, locrio −3)
///     mayor.vectorIntervalico     // [2, 5, 4, 3, 6, 1]
///     mayor.maximamenteRegular    // true
public struct EstadisticasDeEscala: Hashable, Sendable {
    /// Las notas por octava, en la forma ascendente.
    public let numeroDeNotas: Int
    public let cardinal: CardinalDeEscala?
    /// El de `Escala.brillo`: los semitonos que suben (+) o bajan (−) sus grados respecto a la mayor. Solo en las de
    /// siete notas.
    public let brillo: Int?
    /// La media de las quintas que hay de la tónica a cada nota (Sol +1, Fa −1, Fa♯ +6): cuanto más alta, más
    /// brillante. Vale para cualquier número de notas: la mayor y la pentatónica mayor 2, el lidio 3, el dórico 0, la
    /// pentatónica menor −1, el locrio −3. En las de siete notas, una por letra, es `brillo + 2`.
    public let brilloPorQuintas: Double
    /// Los semitonos de cada paso, de la tónica a la octava: 2 2 1 2 2 2 1 en la mayor.
    public let pasos: [Int]
    /// Cuántas veces aparece cada clase interválica, del semitono al tritono
    /// (`ConjuntoDeClasesDeAltura.vectorIntervalico`): 2 5 4 3 6 1 en la mayor.
    public let vectorIntervalico: [Int]
    /// Sin semitonos entre ninguna de sus notas, como las pentatónicas y la de tonos enteros.
    public let anhemitonica: Bool
    /// Con dos semitonos seguidos (Si–Do–Re♭), como la cromática y las bebop.
    public let cohemitonica: Bool
    /// Las transposiciones con notas distintas: 12 si no es simétrica, 3 la disminuida, 2 la de tonos enteros.
    public let transposicionesDistintas: Int
    /// El de su forma prima («7-35» la mayor), si lo tiene.
    public let numeroDeForte: String?
    /// Sus notas están repartidas tan por igual como se puede: cada intervalo genérico (de segunda, de tercera…)
    /// tiene a lo sumo dos tamaños seguidos, como en la mayor, las pentatónicas, la de tonos enteros y la disminuida.
    public let maximamenteRegular: Bool
    /// La escala tiene microtonos, y lo medido en semitonos es su aproximación a los doce.
    public let aproximada: Bool

    public init(_ escala: Escala) {
        let tipo = escala.tipo
        numeroDeNotas = tipo.numeroDeNotas
        cardinal = tipo.cardinal
        brillo = escala.brillo
        let quintas = escala.notas.map { $0.pasosDeQuinta - escala.tonica.pasosDeQuinta }
        brilloPorQuintas = quintas.isEmpty ? 0 : Double(quintas.reduce(0, +)) / Double(quintas.count)
        let conjunto = escala.conjuntoDeClasesDeAltura
        let desdeLaTonica = conjunto.clases.map { modulo($0 - escala.tonica.claseDeAltura, 12) }.sorted()
        let pasos = zip(desdeLaTonica, desdeLaTonica.dropFirst() + [12]).map { $1 - $0 }
        self.pasos = pasos
        vectorIntervalico = conjunto.vectorIntervalico
        anhemitonica = conjunto.vectorIntervalico.first == 0
        cohemitonica = pasos.indices.contains { pasos[$0] == 1 && pasos[($0 + 1) % pasos.count] == 1 }
        transposicionesDistintas = escala.transposicionesDistintas
        numeroDeForte = conjunto.numeroDeForte
        maximamenteRegular = Self.esMaximamenteRegular(desdeLaTonica)
        aproximada = escala.notasMicrotonales() != nil
    }

    /// Para cada intervalo genérico `k`, los tamaños de los `k` pasos seguidos, desde cada nota, se separan a lo
    /// sumo en un semitono (Clough y Douthett, 1991).
    static func esMaximamenteRegular(_ clases: [Int]) -> Bool {
        let n = clases.count
        guard n > 1 else { return true }
        return (1..<n).allSatisfy { k in
            let tamanos = (0..<n).map { i in modulo(clases[(i + k) % n] - clases[i], 12) }
            return (tamanos.max() ?? 0) - (tamanos.min() ?? 0) <= 1
        }
    }
}

extension Escala {
    /// Lo que se mide de la escala (`EstadisticasDeEscala`): su cardinal, su brillo, sus intervalos, su simetría.
    public var estadisticas: EstadisticasDeEscala { EstadisticasDeEscala(self) }
}
