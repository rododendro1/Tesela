import Armonia

/// Las notas tocadas vistas como un conjunto de clases de altura: su forma prima, su número de Forte y su vector
/// interválico, escritos para mostrarlos.
///
///     let postonal = PresentacionPostonal(clases: [0, 4, 7])
///     postonal.formaPrima          // "(0, 3, 7)"
///     postonal.numeroDeForte       // "3-11"
///     postonal.vectorIntervalico   // "⟨0, 0, 1, 1, 1, 0⟩"
public struct PresentacionPostonal: Hashable, Sendable {
    public let formaPrima: String
    /// `nil` si el conjunto no está en la tabla de Forte (el vacío).
    public let numeroDeForte: String?
    public let vectorIntervalico: String

    /// - Parameter clases: números MIDI o clases de altura; las octavas y las repeticiones no cuentan.
    public init(clases: [Int]) {
        let conjunto = ConjuntoDeClases(clases)
        formaPrima = "(" + conjunto.formaPrima.map(String.init).joined(separator: ", ") + ")"
        numeroDeForte = conjunto.numeroDeForte
        vectorIntervalico = "⟨" + conjunto.vectorIntervalico.map(String.init).joined(separator: ", ") + "⟩"
    }
}
