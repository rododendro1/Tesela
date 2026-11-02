// Notas comunes al transponer y al invertir, y los ejes de simetría de un conjunto.
//
// TnI lleva cada clase x a n − x, así que deja en su sitio las parejas de clases que suman n: el vector de índice
// cuenta, para cada n, cuántas clases del conjunto caen sobre otra del conjunto. Las TnI que lo dejan igual son sus
// simetrías por inversión, y cada una tiene un eje: la recta que pasa por n/2 y n/2 + 6 en el círculo de las clases.

/// El eje de una inversión TnI: la recta del círculo de las clases que pasa por n/2 y n/2 + 6.
///
/// Con n par pasa por dos clases, que TnI deja fijas (T0I: Do y Fa♯); con n impar, entre clases (T1I: entre Do y
/// Do♯, y entre Fa♯ y Sol).
public struct EjeDeInversion: Hashable, Sendable, CustomStringConvertible, Comparable {
    /// La n de TnI, de 0 a 11.
    public let indice: Int

    public init(indice: Int) { self.indice = modulo(indice, 12) }

    /// Los dos puntos por donde pasa, en semitonos desde Do: 0 y 6 para T0I, 0.5 y 6.5 para T1I, 5.5 y 11.5 para T11I.
    public var extremos: (Double, Double) {
        let mitad = Double(indice) / 2
        return (mitad, mitad + 6)
    }

    /// Las clases que la inversión deja en su sitio: las dos por donde pasa el eje con n par, ninguna con n impar.
    public var clasesFijas: [Int] { indice % 2 == 0 ? [indice / 2, indice / 2 + 6] : [] }

    /// «0–6», «0½–6½», «5½–11½».
    public var description: String {
        let (a, b) = (indice / 2, indice / 2 + 6)
        return indice % 2 == 0 ? "\(a)–\(b)" : "\(a)½–\(b)½"
    }

    public static func < (a: EjeDeInversion, b: EjeDeInversion) -> Bool { a.indice < b.indice }
}

extension ConjuntoDeClases {
    /// Cuántas clases quedan en el conjunto al transponerlo `n` semitonos: 3 con n = 0 en una tríada, 1 con n = 5
    /// (Do–Mi–Sol y Fa–La–Do tienen el Do).
    public func notasComunes(transponiendo n: Int) -> Int { transponer(n).intersecar(con: self).cardinalidad }

    /// Cuántas clases quedan en el conjunto al aplicarle TnI: Do–Mi–Sol con T7I es Do–Mi♭–Sol, con dos comunes.
    public func notasComunes(invirtiendo n: Int) -> Int { invertir(n).intersecar(con: self).cardinalidad }

    /// Las notas comunes de cada Tn, de T0 a T11. El primero es la cardinalidad, y los demás salen del vector
    /// interválico: Tn y T(12 − n) dan las veces que está la clase interválica n (el tritono, el doble).
    public var vectorDeTransposicion: [Int] { (0..<12).map { notasComunes(transponiendo: $0) } }

    /// El vector de índice: las notas comunes de cada TnI, de T0I a T11I. Es, para cada n, cuántas parejas
    /// ordenadas de clases del conjunto suman n (una clase consigo misma también cuenta).
    ///
    ///     ConjuntoDeClases([0, 4, 7]).vectorDeIndice   // [1, 0, 1, 0, 2, 0, 0, 2, 1, 0, 0, 2]
    public var vectorDeIndice: [Int] {
        var vector = [Int](repeating: 0, count: 12)
        for a in clases {
            for b in clases { vector[modulo(a + b, 12)] += 1 }
        }
        return vector
    }

    /// Los ejes de las inversiones que dejan el conjunto igual, ordenados por su índice. Tantos como
    /// `simetriasPorInversion`: ninguno en la tríada mayor ni en la séptima de dominante, uno en la menor con séptima
    /// (T10I, el eje 5–11) y cuatro en la séptima disminuida.
    public var ejesDeSimetria: [EjeDeInversion] {
        (0..<12).filter { invertir($0) == self }.map(EjeDeInversion.init(indice:))
    }

    /// Las Tn que dejan el conjunto igual (siempre T0): [0, 4, 8] en la tríada aumentada.
    public var transposicionesQueLoDejanIgual: [Int] { (0..<12).filter { transponer($0) == self } }
}
