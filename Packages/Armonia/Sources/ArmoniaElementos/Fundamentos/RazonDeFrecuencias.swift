import Foundation

/// Razón de frecuencias como fracción (5/4, 3/2, 45/32…).
public struct RazonDeFrecuencias: Hashable, Sendable, Codable, CustomStringConvertible {
    public let numerador: Double
    public let denominador: Double

    /// La razón `numerador/denominador`: `RazonDeFrecuencias(3, 2)` es la quinta justa.
    public init(_ numerador: Double, _ denominador: Double) {
        self.numerador = numerador
        self.denominador = denominador
    }

    public var valor: Double { numerador / denominador }
    public var cents: Double { 1200 * log2(valor) }

    public var description: String {
        func entero(_ x: Double) -> String {
            x.rounded() == x && abs(x) < 1e15 ? String(Int64(x)) : String(x)
        }
        return "\(entero(numerador))/\(entero(denominador))"
    }

    /// Coma sintónica (81/80): la diferencia entre cuatro quintas puras y una tercera pura.
    public static let comaSintonica = RazonDeFrecuencias(81, 80)
    /// Coma pitagórica (531441/524288): doce quintas puras frente a siete octavas.
    public static let comaPitagorica = RazonDeFrecuencias(531_441, 524_288)
}
