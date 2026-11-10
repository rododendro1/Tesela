import Foundation

// MARK: - Lo que se parecen dos conjuntos

/// Las relaciones de semejanza de Forte (*The Structure of Atonal Music*, 1973) entre dos conjuntos del mismo
/// tamaño, por sus vectores interválicos.
public enum RelacionDeForte: String, Hashable, Sendable, Codable, CaseIterable {
    /// Ninguna de las seis entradas del vector coincide: la máxima disimilitud.
    case r0 = "R0"
    /// Cuatro entradas coinciden y las otras dos están intercambiadas: la máxima semejanza.
    case r1 = "R1"
    /// Cuatro entradas coinciden y las otras dos no están intercambiadas.
    case r2 = "R2"
}

/// Lo que se parecen dos conjuntos de clases de altura según la teoría de conjuntos, sin mirar las notas que
/// comparten: la distancia entre sus coeficientes de Fourier (Quinn, Amiot), la de sus vectores interválicos
/// (Isaacson), la asimilitud de Morris, las relaciones R0, R1 y R2 de Forte y la Rp. Vale para acordes y escalas.
///
///     let mayor = ConjuntoDeClasesDeAltura([0, 4, 7])
///     let relacion = mayor.relacion(con: [0, 3, 7])
///     relacion.distanciaDeFourier       // 0: la mayor y la menor tienen el mismo contenido
///     relacion.relacionDeForte          // nil: los vectores son iguales
public struct RelacionEntreConjuntos: Hashable, Sendable {
    /// La distancia euclídea entre las magnitudes |f1|…|f6| de los dos (Quinn, 2006; Amiot, 2016): 0 si suenan con
    /// el mismo contenido, como la tríada mayor y la menor o dos conjuntos Z.
    public let distanciaDeFourier: Double
    /// La medida ICVSIM de Isaacson (1990): la desviación típica de las diferencias entre los dos vectores
    /// interválicos. 0 si son iguales.
    public let distanciaIntervalica: Double
    /// La asimilitud de Morris (ASIM, 1979): la suma de las diferencias entre los vectores interválicos dividida por
    /// la de sus entradas, de 0 (iguales) a 1 (nada en común).
    public let asimilitudDeMorris: Double
    /// La relación de Forte de sus vectores, si tienen el mismo tamaño y alguna se cumple.
    public let relacionDeForte: RelacionDeForte?
    /// La relación Rp de Forte: los dos son de clases distintas, tienen n notas y comparten, transpuesto o invertido,
    /// un subconjunto de n − 1.
    public let relacionRp: Bool

    public init(_ a: ConjuntoDeClasesDeAltura, _ b: ConjuntoDeClasesDeAltura) {
        let fa = MedidasDeConjunto.magnitudesDeFourier(a.clases)
        let fb = MedidasDeConjunto.magnitudesDeFourier(b.clases)
        var suma = 0.0
        for (x, y) in zip(fa, fb) { suma += (x - y) * (x - y) }
        distanciaDeFourier = MedidasDeConjunto.sinRuido(suma.squareRoot())
        let va = a.vectorIntervalico
        let vb = b.vectorIntervalico
        let diferencias = zip(va, vb).map { Double($0 - $1) }
        let media = diferencias.reduce(0, +) / 6
        var varianza = 0.0
        for d in diferencias { varianza += (d - media) * (d - media) }
        distanciaIntervalica = (varianza / 6).squareRoot()
        let total = (va + vb).reduce(0, +)
        let distinto = zip(va, vb).map { abs($0 - $1) }.reduce(0, +)
        asimilitudDeMorris = total == 0 ? 0 : Double(distinto) / Double(total)
        relacionDeForte = a.cardinalidad == b.cardinalidad ? Self.relacionDeForte(va, vb) : nil
        relacionRp = Self.relacionRp(a, b)
    }

    static func relacionDeForte(_ a: [Int], _ b: [Int]) -> RelacionDeForte? {
        let distintas = a.indices.filter { a[$0] != b[$0] }
        if distintas.count == 6 { return .r0 }
        guard distintas.count == 2 else { return nil }
        let (i, j) = (distintas[0], distintas[1])
        return a[i] == b[j] && a[j] == b[i] ? .r1 : .r2
    }

    static func relacionRp(_ a: ConjuntoDeClasesDeAltura, _ b: ConjuntoDeClasesDeAltura) -> Bool {
        let n = a.cardinalidad
        guard n >= 2, n == b.cardinalidad, a.formaPrima != b.formaPrima else { return false }
        func subconjuntos(_ c: ConjuntoDeClasesDeAltura) -> Set<[Int]> {
            Set(c.clases.map { quitada in ConjuntoDeClasesDeAltura(c.clases.filter { $0 != quitada }).formaPrima })
        }
        return !subconjuntos(a).isDisjoint(with: subconjuntos(b))
    }
}

extension ConjuntoDeClasesDeAltura {
    /// Lo que se parece a otro conjunto (`RelacionEntreConjuntos`).
    public func relacion(con otro: ConjuntoDeClasesDeAltura) -> RelacionEntreConjuntos {
        RelacionEntreConjuntos(self, otro)
    }
}
