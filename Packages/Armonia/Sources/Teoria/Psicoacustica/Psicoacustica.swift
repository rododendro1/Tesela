import Elementos
import Foundation

// MARK: - Psicoacústica: fundamentales percibidas, tensión, rugosidad, entropía y fusión

/// Una voz de una disposición: su nota en pasos de quinta desde la nota de referencia y su altura en semitonos.
struct VozMedida: Hashable, Sendable {
    let pasosDeQuinta: Int
    let semitonos: Int
}

/// Una nota del acorde con su peso como fundamental en el modelo de Parncutt (1988).
public struct ProminenciaDeFundamental: Hashable, Sendable {
    /// La nota, como intervalo desde la nota de referencia del acorde.
    public let intervalo: Intervalo
    /// La suma de los pesos de Parncutt de las notas del acorde que la apoyan como fundamental.
    public let peso: Int
}

/// Las medidas de la percepción de unas voces: Parncutt, Terhardt, Cook y Fujisawa, Sethares, Vassilakis, Hutchinson
/// y Knopoff, Erlich y Huron.
enum Psicoacustica {
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

    /// La rugosidad de Vassilakis (2001, *Perceptual and Physical Properties of Amplitude Fluctuation and their
    /// Musical Significance*): como la de Sethares, pero cada par de parciales pesa (a₁·a₂)^0,1 · ½ · (2·mín/(a₁ +
    /// a₂))^3,11, lo que da más peso a los pares de amplitud parecida.
    static func rugosidadDeVassilakis(_ voces: [VozMedida], desdeMidi grave: Int = 60) -> Double {
        let parciales = parciales(voces, desdeMidi: grave)
        var total = 0.0
        for i in parciales.indices {
            for j in parciales.indices where j > i {
                let (a, b) = (parciales[i], parciales[j])
                let s = 0.24 / (0.0207 * min(a.frecuencia, b.frecuencia) + 18.96)
                let diferencia = abs(a.frecuencia - b.frecuencia)
                let peso =
                    pow(a.amplitud * b.amplitud, 0.1) * 0.5
                    * pow(2 * min(a.amplitud, b.amplitud) / (a.amplitud + b.amplitud), 3.11)
                total += peso * (exp(-3.5 * s * diferencia) - exp(-5.75 * s * diferencia))
            }
        }
        return MedidasDeConjunto.redondear(total)
    }

    /// La disonancia de Hutchinson y Knopoff (1978, «The acoustic component of Western consonance», *Interface* 7:
    /// 1–29): Σ a_i·a_j·g(y) / Σ a_i², con y la distancia entre parciales en anchos de banda crítica (1,72·f̄^0,65) y
    /// g(y) = (e·4y·e^(−4y))², la curva de Plomp y Levelt con su máximo a un cuarto de banda. Entre 0 y 1.
    static func rugosidadDeHutchinsonKnopoff(_ voces: [VozMedida], desdeMidi grave: Int = 60) -> Double {
        let parciales = parciales(voces, desdeMidi: grave)
        let energia = parciales.map { $0.amplitud * $0.amplitud }.reduce(0, +)
        guard energia > 0 else { return 0 }
        var total = 0.0
        for i in parciales.indices {
            for j in parciales.indices where j > i {
                let (a, b) = (parciales[i], parciales[j])
                let banda = 1.72 * pow((a.frecuencia + b.frecuencia) / 2, 0.65)
                let y = abs(a.frecuencia - b.frecuencia) / banda
                guard y < 1.2 else { continue }
                let g = pow(exp(1.0) * 4 * y * exp(-4 * y), 2)
                total += a.amplitud * b.amplitud * g
            }
        }
        return MedidasDeConjunto.redondear(total / energia)
    }

    /// La fusión tonal (Huron 1991, «Tonal consonance versus tonal fusion in polyphonic sonorities», *Music
    /// Perception* 9: 135–154): la proporción de pares de voces a distancia de unísono, octava o quinta (también
    /// compuestas), los intervalos que más funden dos voces en una. 0 si ninguna se funde; 1 si todas.
    static func fusionTonal(_ voces: [VozMedida]) -> Double {
        var fundidos = 0
        var pares = 0
        for i in voces.indices {
            for j in voces.indices where j > i {
                if [0, 7].contains(modulo(voces[j].semitonos - voces[i].semitonos, 12)) { fundidos += 1 }
                pares += 1
            }
        }
        return pares == 0 ? 0 : MedidasDeConjunto.redondear(Double(fundidos) / Double(pares))
    }

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
        return pares == 0 ? 0 : MedidasDeConjunto.redondear(suma / Double(pares))
    }
}
