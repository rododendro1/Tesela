import Armonia

/// Las notas tocadas vistas como un conjunto de clases de altura: su forma prima, su número de Forte y su vector
/// interválico, escritos para mostrarlos.
///
///     let postonal = AnalisisPostonalPresentado(clases: [0, 4, 7])
///     postonal.formaPrima          // "(0, 3, 7)"
///     postonal.numeroDeForte       // "3-11"
///     postonal.vectorIntervalico   // "⟨0, 0, 1, 1, 1, 0⟩"
public struct AnalisisPostonalPresentado: Hashable, Sendable {
    public let formaPrima: String
    /// `nil` si el conjunto no está en la tabla de Forte (el vacío).
    public let numeroDeForte: String?
    public let vectorIntervalico: String

    /// - Parameter clases: números MIDI o clases de altura; las octavas y las repeticiones no cuentan.
    public init(clases: [Int]) {
        // Los mismos datos que da `armonia conjunto` (y su `--json`); los nombres de las notas no se enseñan aquí.
        self.init(DatosDeConjunto(ConjuntoDeClases(clases), notacion: .espanolCompacto))
    }

    /// Los datos de un conjunto, escritos para mostrarlos.
    public init(_ datos: DatosDeConjunto) {
        formaPrima = "(" + datos.formaPrima.map(String.init).joined(separator: ", ") + ")"
        numeroDeForte = datos.forte
        vectorIntervalico = "⟨" + datos.vectorIntervalico.map(String.init).joined(separator: ", ") + "⟩"
    }
}
