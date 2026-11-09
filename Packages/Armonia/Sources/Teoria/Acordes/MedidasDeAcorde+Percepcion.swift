import Elementos
import Foundation

// MARK: - Más medidas: Fourier, Parncutt, Tymoczko, tríadas, Cook y Sethares

/// Una nota del acorde con su peso como fundamental en el modelo de Parncutt (1988).
public struct ProminenciaDeFundamental: Hashable, Sendable {
    /// La nota, como intervalo desde la nota de referencia del acorde.
    public let intervalo: Intervalo
    /// La suma de los pesos de Parncutt de las notas del acorde que la apoyan como fundamental.
    public let peso: Int
}

/// Cuántas tríadas de cada clase caben en las notas de un acorde, en cualquier transposición.
public struct TriadasContenidas: Hashable, Sendable, Codable {
    public let mayores: Int
    public let menores: Int
    public let disminuidas: Int
    public let aumentadas: Int

    public var total: Int { mayores + menores + disminuidas + aumentadas }
}

extension MedidasDeAcorde {
    /// Las magnitudes de los coeficientes de Fourier del conjunto de clases de altura, de |f1| a |f6| (Quinn 2006;
    /// Amiot 2016, *Music Through Fourier Space*), redondeadas a tres decimales. Cada una mide cuánto se parece el
    /// acorde al conjunto que la hace máxima: |f1| el cluster cromático, |f2| el tritono y los conjuntos que se repiten
    /// cada seis semitonos, |f3| el aumentado, |f4| la séptima disminuida, |f5| la escala diatónica (las quintas
    /// seguidas) y |f6| la escala de tonos enteros.
    static func magnitudesDeFourier(_ clases: [Int]) -> [Double] {
        (1...6).map { k in
            let angulos = clases.map { -2 * Double.pi * Double(k * $0) / 12 }
            let real = angulos.map(cos).reduce(0, +)
            let imaginaria = angulos.map(sin).reduce(0, +)
            return ((real * real + imaginaria * imaginaria).squareRoot() * 1000).rounded() / 1000
        }
    }

    /// Los pesos de Parncutt (1988, «Revision of Terhardt's psychoacoustical model of the root(s) of a musical
    /// chord», *Music Perception* 6: 65–94) de cada intervalo que apoya a una nota como fundamental, desde ella: el
    /// unísono 10, la quinta 5, la tercera mayor 3, la séptima menor 2 y la segunda mayor 1.
    static let pesosDeParncutt: [Int: Int] = [0: 10, 7: 5, 4: 3, 10: 2, 2: 1]

    /// Las notas del acorde de la más a la menos prominente como fundamental (a igualdad, en el orden de las voces).
    static func prominencias(_ voces: [VozMedida]) -> [ProminenciaDeFundamental] {
        var vistas = Set<Int>()
        let candidatas = voces.filter { vistas.insert(modulo($0.semitonos, 12)).inserted }
        let clases = Set(candidatas.map { modulo($0.semitonos, 12) })
        let pesos = candidatas.map { candidata in
            clases.map { pesosDeParncutt[modulo($0 - candidata.semitonos, 12)] ?? 0 }.reduce(0, +)
        }
        return candidatas.indices.sorted { (-pesos[$0], $0) < (-pesos[$1], $1) }.map {
            ProminenciaDeFundamental(
                intervalo: Intervalo.simpleAscendente(pasosDeQuinta: candidatas[$0].pasosDeQuinta), peso: pesos[$0])
        }
    }

    /// La distancia euclídea, en semitonos, del acorde al acorde perfectamente repartido de su mismo número de notas
    /// que le queda más cerca (Tymoczko 2011, *A Geometry of Music*): 0 el aumentado y la séptima disminuida, 0,816
    /// las tríadas mayor y menor. Cuanto más cerca, mejor se conduce hacia los de su clase.
    static func distanciaALaUniformidad(_ clases: [Int]) -> Double {
        let ordenadas = clases.sorted()
        let n = Double(ordenadas.count)
        guard ordenadas.count > 1 else { return 0 }
        let desvios = ordenadas.enumerated().map { Double($1) - 12 * Double($0) / n }
        let media = desvios.reduce(0, +) / n
        let suma = desvios.map { ($0 - media) * ($0 - media) }.reduce(0, +)
        return (suma.squareRoot() * 1000).rounded() / 1000
    }

    /// Las tríadas mayores, menores, disminuidas y aumentadas que forman las notas.
    static func triadasContenidas(_ clases: Set<Int>) -> TriadasContenidas {
        func cuantas(_ forma: [Int]) -> Int {
            Set(
                (0..<12).compactMap { r -> Set<Int>? in
                    let triada = Set(forma.map { modulo(r + $0, 12) })
                    return triada.isSubset(of: clases) ? triada : nil
                }
            ).count
        }
        return TriadasContenidas(
            mayores: cuantas([0, 4, 7]), menores: cuantas([0, 3, 7]), disminuidas: cuantas([0, 3, 6]),
            aumentadas: cuantas([0, 4, 8]))
    }

    /// La tensión y la modalidad de Cook y Fujisawa (2006, «The psychophysics of harmony perception: Harmony is a
    /// three-tone phenomenon», *Empirical Musicology Review* 1: 106–126), con tonos puros: para cada tres voces, de
    /// grave a agudo, con los intervalos x (de la grave a la media) e y (de la media a la aguda) en semitonos, la
    /// tensión es exp(−((y − x)/0,6)²), y la modalidad, −2(y − x)·exp(−(y − x)⁴/4). La tensión es 1 con dos
    /// intervalos iguales (el aumentado) y casi 0 con dos distintos; la modalidad es positiva en las mayores y
    /// negativa en las menores.
    static func tensionYModalidad(_ voces: [VozMedida]) -> (tension: Double, modalidad: Double) {
        var tension = 0.0
        var modalidad = 0.0
        let alturas = voces.map(\.semitonos)
        for i in alturas.indices {
            for j in alturas.indices where j > i {
                for k in alturas.indices where k > j {
                    let diferencia = Double((alturas[k] - alturas[j]) - (alturas[j] - alturas[i]))
                    tension += exp(-pow(diferencia / 0.6, 2))
                    modalidad += -2 * diferencia * exp(-pow(diferencia, 4) / 4)
                }
            }
        }
        return ((tension * 1000).rounded() / 1000, (modalidad * 1000).rounded() / 1000)
    }

    /// Los seis primeros armónicos de cada voz, de amplitud 0,88ⁿ⁻¹, con la voz más grave en `grave` (MIDI).
    static func parciales(_ voces: [VozMedida], desdeMidi grave: Int) -> [(frecuencia: Double, amplitud: Double)] {
        voces.flatMap { voz in
            let fundamental = 440 * pow(2, Double(grave + voz.semitonos - 69) / 12)
            return (1...6).map { n in (fundamental * Double(n), pow(0.88, Double(n - 1))) }
        }
    }

    /// La rugosidad sensorial de Sethares (1993, «Local consonance and the relationship between timbre and scale»,
    /// *JASA* 94: 1218–1228), su ajuste de las curvas de Plomp y Levelt (1965): la suma, sobre cada par de parciales,
    /// de mín(a₁, a₂)·(e^(−3,5·s·Δf) − e^(−5,75·s·Δf)), con s = 0,24/(0,0207·f_mín + 18,96). Cada voz tiene seis
    /// armónicos de amplitud 0,88ⁿ, y la disposición suena desde el Do central (o desde su altura, en un `Acorde`).
    static func rugosidad(_ voces: [VozMedida], desdeMidi grave: Int = 60) -> Double {
        let parciales = parciales(voces, desdeMidi: grave)
        var total = 0.0
        for i in parciales.indices {
            for j in parciales.indices where j > i {
                let (a, b) = (parciales[i], parciales[j])
                let minima = min(a.frecuencia, b.frecuencia)
                let s = 0.24 / (0.0207 * minima + 18.96)
                let diferencia = abs(a.frecuencia - b.frecuencia)
                total += min(a.amplitud, b.amplitud) * (exp(-3.5 * s * diferencia) - exp(-5.75 * s * diferencia))
            }
        }
        return (total * 1000).rounded() / 1000
    }
}
