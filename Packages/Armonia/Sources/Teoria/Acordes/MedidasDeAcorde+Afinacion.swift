import Elementos
import Foundation

// MARK: - Medidas de la afinación justa y de la fundamental virtual

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

extension MedidasDeAcorde {
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
        return redondear(suma / Double(razones.count))
    }

    /// La armonicidad de Gill y Purves (2009, «A biological rationale for musical scales», *PLoS ONE* 4: e8144): el
    /// porcentaje de armónicos que comparten las dos notas de cada par, (n + d − 1)/(n·d), de media. 100 el unísono,
    /// 66,7 la quinta.
    static func armonicidad(_ razones: [RazonJusta]) -> Double {
        guard !razones.isEmpty else { return 100 }
        let suma = razones.map {
            Double($0.numerador + $0.denominador - 1) / Double($0.numerador * $0.denominador) * 100
        }.reduce(0, +)
        return (suma / Double(razones.count) * 10).rounded() / 10
    }

    /// El límite primo (Partch, *Genesis of a Music*, 1949): el mayor primo de sus intervalos justos, 2, 3 o 5 en la
    /// afinación de cinco límites.
    static func limitePrimo(pasosDeQuinta: Set<Int>) -> Int {
        let notas = pasosDeQuinta.map(exponentesJustos)
        if Set(notas.map(\.cinco)).count > 1 { return 5 }
        if Set(notas.map(\.tres)).count > 1 { return 3 }
        return 2
    }

    // MARK: Entropía armónica

    /// Las razones de la serie de Tenney n·d < 10 000 hasta cuatro octavas, con su tamaño en cents y su peso 1/√(n·d).
    static let serieDeEntropia: [(cents: Double, peso: Double)] = {
        var serie: [(Double, Double)] = []
        for d in 1..<100 {
            var n = d
            while n * d < 10_000 && n <= 16 * d {
                if mcd(n, d) == 1 {
                    serie.append((1200 * log2(Double(n) / Double(d)), 1 / Double(n * d).squareRoot()))
                }
                n += 1
            }
        }
        return serie
    }()

    private static func mcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : mcd(b, a % b) }

    /// La entropía armónica de Erlich de un intervalo en cents: la entropía (en bits) de la probabilidad de oírlo como
    /// cada razón de la serie, con una campana de 17 cents (el 1 %) y el peso 1/√(n·d) que aproxima la anchura de cada
    /// razón. Baja en las razones sencillas (la quinta, la octava) y alta entre ellas.
    static func entropiaArmonica(cents: Double) -> Double {
        var tamano = cents
        while tamano > 4800 { tamano -= 1200 }
        let s = 17.0
        let pesos = serieDeEntropia.compactMap { razon -> Double? in
            let distancia = tamano - razon.cents
            guard abs(distancia) < 6 * s else { return nil }
            return exp(-distancia * distancia / (2 * s * s)) * razon.peso
        }
        let total = pesos.reduce(0, +)
        guard total > 0 else { return 0 }
        var entropia = 0.0
        for peso in pesos where peso > 0 {
            let p = peso / total
            entropia -= p * log2(p)
        }
        return entropia
    }

    /// La entropía armónica media de los intervalos entre cada par de voces (Erlich, la versión diádica).
    static func entropiaArmonica(_ voces: [VozMedida]) -> Double {
        var suma = 0.0
        var pares = 0
        for i in voces.indices {
            for j in voces.indices where j > i {
                suma += entropiaArmonica(cents: Double(abs(voces[j].semitonos - voces[i].semitonos)) * 100)
                pares += 1
            }
        }
        return pares == 0 ? 0 : redondear(suma / Double(pares))
    }

    // MARK: Fundamental virtual

    /// Los pesos de Terhardt (1982, «Die psychoakustischen Grundlagen der musikalischen Akkordgrundtöne»): una nota
    /// apoya como fundamental virtual a la que tiene debajo como su armónico 1, 3, 5, 7 o 9 (la misma, la quinta, la
    /// tercera mayor, la séptima menor y la segunda mayor por encima de ella), con peso 1/n.
    static let pesosDeTerhardt: [Int: Double] = [0: 1, 1: 1.0 / 3, 4: 1.0 / 5, -2: 1.0 / 7, 2: 1.0 / 9]

    /// La fundamental virtual de Terhardt, que puede no ser una nota del acorde: la nota que más notas del acorde
    /// tienen como subarmónico. A igualdad, una del acorde, y después la más cercana a la referencia en quintas.
    static func fundamentalVirtual(pasosDeQuinta: Set<Int>) -> Int? {
        let candidatas = Set(pasosDeQuinta.flatMap { p in pesosDeTerhardt.keys.map { p - $0 } })
        func peso(_ r: Int) -> Double { pasosDeQuinta.map { pesosDeTerhardt[$0 - r] ?? 0 }.reduce(0, +) }
        return candidatas.min { a, b in
            let (pa, pb) = (peso(a), peso(b))
            if abs(pa - pb) > 1e-9 { return pa > pb }
            let (ea, eb) = (pasosDeQuinta.contains(a), pasosDeQuinta.contains(b))
            if ea != eb { return ea }
            return (abs(a), a) < (abs(b), b)
        }
    }

    /// Tres decimales.
    static func redondear(_ valor: Double) -> Double { (valor * 1000).rounded() / 1000 }
}
