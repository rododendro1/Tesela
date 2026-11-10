import Elementos
import Foundation

// MARK: - Lo que se mide de un temperamento

/// Lo que se aparta de una razón justa el paso de un temperamento que más se le acerca, contado desde el primero.
public struct AproximacionJusta: Hashable, Sendable {
    /// La razón justa: 3/2, 5/4…
    public let razon: RazonDeFrecuencias
    /// Los cents del paso más cercano.
    public let cents: Double
    /// Cuánto se aparta del justo, en cents: negativo si es más estrecho.
    public let error: Double
}

/// Lo que se mide de un temperamento (`TemperamentoConNombre`): sus pasos, lo que se aparta de las razones justas
/// y, en los de doce notas, sus quintas, sus terceras mayores y lo que se aparta del temperamento igual. Las medidas
/// no se redondean: se redondean al escribirlas.
///
///     let meso = TemperamentoConNombre.mesotonicoCuartoDeComa.estadisticas
///     meso.pasosPorOctava              // 12
///     meso.quintaDelLobo! > 735        // true: Sol♯–Mi♭, la quinta del lobo
///     TemperamentoConNombre.temperamentoIgual.estadisticas.uniforme   // true
public struct EstadisticasDeTemperamento: Hashable, Sendable {
    /// Los pasos de la octava.
    public let pasosPorOctava: Int
    /// Si todos los pasos miden lo mismo.
    public let uniforme: Bool
    /// El paso más pequeño y el más grande, en cents.
    public let pasoMenor: Double
    public let pasoMayor: Double
    /// Lo que se acercan sus pasos a la quinta (3/2), a las terceras mayor y menor (5/4, 6/5), a la séptima armónica
    /// (7/4) y al undécimo armónico (11/8), desde el primero.
    public let aproximaciones: [AproximacionJusta]
    /// En los de doce notas, las doce quintas desde cada tecla, de Do a Si (Do–Sol, Do♯–Sol♯…), en cents.
    public let quintas: [Double]?
    /// En los de doce notas, las doce terceras mayores desde cada tecla (Do–Mi, Do♯–Fa…), en cents.
    public let tercerasMayores: [Double]?
    /// En los de doce notas, lo que se aparta cada tecla del temperamento igual, en cents.
    public let desviacionesDelIgual: [Double]?

    public init(_ temperamento: TemperamentoConNombre) {
        let pasos = temperamento.pasos
        let n = pasos.count
        pasosPorOctava = n
        let tamanos = pasos.indices.map { i in (i + 1 < n ? pasos[i + 1] : 1200 + pasos[0]) - pasos[i] }
        pasoMenor = tamanos.min() ?? 0
        pasoMayor = tamanos.max() ?? 0
        uniforme = pasoMayor - pasoMenor < 1e-6
        aproximaciones = [
            RazonDeFrecuencias(3, 2), RazonDeFrecuencias(5, 4), RazonDeFrecuencias(6, 5), RazonDeFrecuencias(7, 4),
            RazonDeFrecuencias(11, 8),
        ].map { razon in
            let justo = razon.cents
            let cercano = (pasos + [1200]).min { abs($0 - justo) < abs($1 - justo) } ?? 0
            return AproximacionJusta(razon: razon, cents: cercano, error: cercano - justo)
        }
        guard n == 12 else {
            quintas = nil
            tercerasMayores = nil
            desviacionesDelIgual = nil
            return
        }
        func intervalo(_ i: Int, _ semitonos: Int) -> Double {
            let j = i + semitonos
            return j < 12 ? pasos[j] - pasos[i] : pasos[j - 12] + 1200 - pasos[i]
        }
        quintas = (0..<12).map { intervalo($0, 7) }
        tercerasMayores = (0..<12).map { intervalo($0, 4) }
        desviacionesDelIgual = pasos.indices.map { pasos[$0] - 100 * Double($0) }
    }

    /// La quinta que más se aparta de la pura, en los de doce notas: la del lobo en los mesotónicos.
    public var quintaDelLobo: Double? {
        let pura = RazonDeFrecuencias(3, 2).cents
        return quintas?.max { abs($0 - pura) < abs($1 - pura) }
    }

    /// La tercera mayor más cercana a la pura (5/4) y la más lejana, en los de doce notas.
    public var terceraMasPura: Double? { tercerasMayores?.min(by: Self.porLaTerceraPura) }
    public var terceraMasLejana: Double? { tercerasMayores?.max(by: Self.porLaTerceraPura) }

    private static func porLaTerceraPura(_ a: Double, _ b: Double) -> Bool {
        let pura = RazonDeFrecuencias(5, 4).cents
        return abs(a - pura) < abs(b - pura)
    }
}

extension TemperamentoConNombre {
    /// Lo que se mide del temperamento (`EstadisticasDeTemperamento`).
    public var estadisticas: EstadisticasDeTemperamento { EstadisticasDeTemperamento(self) }
}
