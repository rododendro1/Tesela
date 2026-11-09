import Elementos
import Foundation

// MARK: - Medidas de las voces: fusión, rugosidad de Vassilakis y de Hutchinson y Knopoff, disposición

extension MedidasDeAcorde {
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
        return pares == 0 ? 0 : redondear(Double(fundidos) / Double(pares))
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
        return redondear(total)
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
        return redondear(total / energia)
    }

    /// La disposición de las voces, en semitonos desde la grave: cerrada si caben en una octava; drop 2, drop 3 o drop
    /// 2 + 4 si lo son de una cerrada (subiendo una octava la voz o las dos voces graves, quedan cerradas y en el
    /// segundo, tercero o segundo y cuarto lugar desde arriba); `nil` en cualquier otra abierta.
    static func disposicion(_ semitonos: [Int]) -> DisposicionDeAcorde? {
        let voces = semitonos.sorted()
        func cerrada(_ alturas: [Int]) -> Bool { (alturas.max() ?? 0) - (alturas.min() ?? 0) < 12 }
        guard voces.count >= 2 else { return .cerrada }
        if cerrada(voces) { return .cerrada }
        guard voces.count >= 4 else { return nil }
        // El lugar desde arriba (1 la más aguda) de cada voz subida, si queda cerrada.
        func lugares(subiendo cuantas: Int) -> [Int]? {
            let subidas = voces.prefix(cuantas).map { $0 + 12 }
            let todas = (subidas + voces.dropFirst(cuantas)).sorted(by: >)
            guard cerrada(todas), Set(todas).count == todas.count else { return nil }
            return subidas.compactMap { todas.firstIndex(of: $0).map { $0 + 1 } }.sorted()
        }
        if let lugar = lugares(subiendo: 1) {
            if lugar == [2] { return .drop2 }
            if lugar == [3] { return .drop3 }
        }
        if lugares(subiendo: 2) == [2, 4] { return .drop24 }
        return nil
    }
}
