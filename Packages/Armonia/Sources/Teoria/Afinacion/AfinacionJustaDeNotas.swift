import Elementos
import Foundation

// MARK: - Lo que dice la afinación justa de unas notas

/// Un intervalo de la afinación justa reducido a la octava: n/d con 1 ≤ n/d < 2.
struct RazonJusta: Hashable {
    let numerador: Int
    let denominador: Int

    /// El intervalo de 3^tres·5^cinco, reducido a la octava.
    init(tres: Int, cinco: Int) {
        func potencia(_ base: Int, _ exponente: Int) -> Int { (0..<exponente).reduce(1) { a, _ in a * base } }
        var n = potencia(3, max(tres, 0)) * potencia(5, max(cinco, 0))
        var d = potencia(3, max(-tres, 0)) * potencia(5, max(-cinco, 0))
        while n >= 2 * d { d *= 2 }
        while n < d { n *= 2 }
        numerador = n
        denominador = d
    }

    /// La mayor de las partes impares de n y d.
    var limiteImpar: Int {
        func impar(_ x: Int) -> Int { x % 2 == 0 ? impar(x / 2) : x }
        return max(impar(numerador), impar(denominador))
    }
}

/// Lo que dice de unas notas la afinación justa de cinco límites que pide su ortografía (Mi, la tercera mayor, es
/// 5/4; Si♭, la séptima menor, 16/9): el gradus de Euler, la altura de Tenney, los límites de Partch y la armonicidad
/// de Gill y Purves. Lo comparten `EstadisticasDeAcorde.afinacion` y `EstadisticasDeEscala.afinacion`.
public struct MedidasDeAfinacionJusta: Hashable, Sendable {
    /// El gradus suavitatis de Euler (1739): 1 una nota, 3 la quinta, 7 las tríadas mayor y menor, 11 la séptima de
    /// dominante.
    public let gradoDeSuavidad: Int
    /// La altura de Tenney media de los intervalos entre cada par de notas: log₂(n·d). Cuanto más baja, más sencillas
    /// sus razones.
    public let alturaDeTenney: Double
    /// El límite impar (Partch): la mayor parte impar de sus intervalos. 5 la tríada mayor, 45 la séptima de
    /// dominante, por su tritono (45/32).
    public let limiteImpar: Int
    /// El límite primo (Partch) de sus intervalos: 2, 3 o 5.
    public let limitePrimo: Int
    /// La armonicidad de Gill y Purves: el porcentaje medio de armónicos que comparten sus notas dos a dos.
    public let armonicidad: Double

    /// Las de unas notas, en pasos de quinta desde la referencia.
    init(pasosDeQuinta: Set<Int>) {
        let razones = CuentasDeAfinacionJusta.razonesJustas(pasosDeQuinta: pasosDeQuinta)
        gradoDeSuavidad = CuentasDeAfinacionJusta.gradoDeSuavidad(pasosDeQuinta: pasosDeQuinta)
        alturaDeTenney = CuentasDeAfinacionJusta.alturaDeTenney(razones)
        limiteImpar = razones.map(\.limiteImpar).max() ?? 1
        limitePrimo = CuentasDeAfinacionJusta.limitePrimo(pasosDeQuinta: pasosDeQuinta)
        armonicidad = CuentasDeAfinacionJusta.armonicidad(razones)
    }
}

/// Las cuentas de la afinación justa.
enum CuentasDeAfinacionJusta {
    /// Los exponentes de 3 y de 5 de una nota afinada en el sistema justo de cinco límites que pide su ortografía, a
    /// `q` quintas de la referencia: cada cuatro quintas, una coma sintónica, y la nota pasa de 3^q a 3^(q − 4k)·5^k.
    static func exponentesJustos(_ q: Int) -> (tres: Int, cinco: Int) {
        let k = (q >= 0 ? 1 : -1) * ((abs(q) + 1) / 4)
        return (q - 4 * k, k)
    }

    /// El gradus suavitatis de Euler (*Tentamen novae theoriae musicae*, 1739), sin contar las octavas: cada nota se
    /// afina en el sistema justo de cinco límites que pide su ortografía (Mi, la tercera mayor, es 5/4; Si♭, la séptima
    /// menor, 16/9), y el grado es 1 + Σ e·(p − 1) sobre los factores 3 y 5 del mínimo común múltiplo. Cuanto más bajo,
    /// más suave: 1 una nota, 3 la quinta, 7 las tríadas mayor y menor, 11 la séptima de dominante.
    static func gradoDeSuavidad(pasosDeQuinta: Set<Int>) -> Int {
        let exponentes = pasosDeQuinta.map(exponentesJustos)
        guard let primero = exponentes.first else { return 1 }
        let tres = exponentes.map(\.tres)
        let cinco = exponentes.map(\.cinco)
        let rangoDeTres = (tres.max() ?? primero.tres) - (tres.min() ?? primero.tres)
        let rangoDeCinco = (cinco.max() ?? primero.cinco) - (cinco.min() ?? primero.cinco)
        return 1 + 2 * rangoDeTres + 4 * rangoDeCinco
    }

    /// Los intervalos de afinación justa entre cada par de notas, en pasos de quinta desde la referencia.
    static func razonesJustas(pasosDeQuinta: Set<Int>) -> [RazonJusta] {
        let notas = pasosDeQuinta.sorted().map(exponentesJustos)
        var razones: [RazonJusta] = []
        for i in notas.indices {
            for j in notas.indices where j > i {
                razones.append(RazonJusta(tres: notas[j].tres - notas[i].tres, cinco: notas[j].cinco - notas[i].cinco))
            }
        }
        return razones
    }

    /// La altura de Tenney media (Tenney 1983, «John Cage and the theory of harmony»): log₂(n·d) de cada par de notas
    /// afinado en justa, de media. 1,585 la quinta (3/2); cuanto más baja, más sencillo el acorde.
    static func alturaDeTenney(_ razones: [RazonJusta]) -> Double {
        guard !razones.isEmpty else { return 0 }
        let suma = razones.map { log2(Double($0.numerador * $0.denominador)) }.reduce(0, +)
        return suma / Double(razones.count)
    }

    /// La armonicidad de Gill y Purves (2009, «A biological rationale for musical scales», *PLoS ONE* 4: e8144): el
    /// porcentaje de armónicos que comparten las dos notas de cada par, (n + d − 1)/(n·d), de media. 100 el unísono,
    /// 66,7 la quinta.
    static func armonicidad(_ razones: [RazonJusta]) -> Double {
        guard !razones.isEmpty else { return 100 }
        let suma = razones.map {
            Double($0.numerador + $0.denominador - 1) / Double($0.numerador * $0.denominador) * 100
        }.reduce(0, +)
        return suma / Double(razones.count)
    }

    /// El límite primo (Partch, *Genesis of a Music*, 1949): el mayor primo de sus intervalos justos, 2, 3 o 5 en la
    /// afinación de cinco límites.
    static func limitePrimo(pasosDeQuinta: Set<Int>) -> Int {
        let notas = pasosDeQuinta.map(exponentesJustos)
        if Set(notas.map(\.cinco)).count > 1 { return 5 }
        if Set(notas.map(\.tres)).count > 1 { return 3 }
        return 2
    }
}
