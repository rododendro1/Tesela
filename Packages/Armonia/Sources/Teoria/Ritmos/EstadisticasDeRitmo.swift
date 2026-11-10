import Elementos
import Foundation

// MARK: - Lo que se mide de un ritmo

/// Lo que se mide de un ritmo, con las medidas de Toussaint (*The Geometry of Musical Rhythm*, 2013): sus
/// intervalos, su vector de distancias, si es euclídeo, profundo o simétrico, lo uniforme que es, su contratiempo y
/// su síncopa. Es el hermano de `EstadisticasDeEscala`: un ritmo de n pulsos es un polígono en un reloj de n horas.
///
///     let clave = RitmoConNombre.claveDeSon.estadisticas
///     clave.ataques                // 5
///     clave.vectorDeDistancias     // [0, 1, 2, 2, 0, 3, 2, 0]
///     clave.euclideo               // false
///     RitmoConNombre.tresillo.estadisticas.euclideo   // true
public struct EstadisticasDeRitmo: Hashable, Sendable {
    /// Los pulsos del ciclo.
    public let pulsos: Int
    /// Los golpes que suenan, fuertes y débiles. En los tāla, el compás flamenco o el vals suenan todos los pulsos
    /// (unos fuertes y otros débiles), y las medidas de forma ven un polígono regular.
    public let ataques: Int
    /// Los golpes fuertes.
    public let fuertes: Int
    /// Los pulsos que hay de cada golpe al siguiente, dando la vuelta.
    public let intervalos: [Int]
    /// Cuántas veces está cada distancia, de 1 a n/2 pulsos, entre dos golpes cualesquiera (por el camino más corto
    /// del círculo): el vector interválico del ritmo.
    public let vectorDeDistancias: [Int]
    /// Es, girado, el ritmo euclídeo E(k, n): los golpes, repartidos lo más uniformemente posible.
    public let euclideo: Bool
    /// Cada distancia está un número de veces distinto (Erdős; Toussaint, cap. 21), como en el shiko.
    public let profundo: Bool
    /// Las rotaciones que lo dejan igual, sin contar la de 0 pulsos: 0 si no tiene simetría.
    public let simetriasPorRotacion: Int
    /// Lo uniforme que es, de 0 a 1: el módulo del coeficiente de Fourier de orden k entre k (Amiot). 1 en los
    /// que reparten los golpes a distancias iguales.
    public let uniformidad: Double
    /// El contratiempo de Toussaint: los golpes en pulsos que no caen en ningún polígono regular del ciclo (los
    /// primos con n).
    public let contratiempo: Int
    /// La síncopa de Gómez, Melvin, Rappaport y Toussaint (WNBD, 2005): cuánto se apartan de media los golpes de
    /// los tiempos de su agrupación, más cuando la nota cruza el tiempo siguiente.
    public let sincopa: Double

    public init(_ ritmo: RitmoConNombre) {
        let n = ritmo.pulsos
        let ataques = ritmo.ataques
        pulsos = n
        self.ataques = ataques.count
        fuertes = ritmo.golpes.filter { $0 == .fuerte }.count
        intervalos = ritmo.intervalos
        var vector = [Int](repeating: 0, count: n / 2)
        for i in ataques.indices {
            for j in ataques.indices where j > i {
                let d = ataques[j] - ataques[i]
                let corta = min(d, n - d)
                if corta > 0 { vector[corta - 1] += 1 }
            }
        }
        vectorDeDistancias = vector
        let conjunto = Set(ataques)
        func girado(_ r: Int) -> Set<Int> { Set(ataques.map { ($0 + r) % max(n, 1) }) }
        let euclideo = Set(
            RitmoConNombre.euclideo(ataques: ataques.count, pulsos: n).enumerated().filter { $0.element == "x" }
                .map(\.offset))
        self.euclideo = n > 0 && (0..<n).contains { girado($0) == euclideo }
        let veces = vector.filter { $0 > 0 }
        profundo = !veces.isEmpty && Set(veces).count == veces.count
        simetriasPorRotacion = n == 0 ? 0 : (1..<n).filter { girado($0) == conjunto }.count
        let k = Double(ataques.count)
        if ataques.isEmpty || n == 0 {
            uniformidad = 0
        } else {
            var real = 0.0
            var imaginaria = 0.0
            for a in ataques {
                let angulo = 2 * Double.pi * k * Double(a) / Double(n)
                real += cos(angulo)
                imaginaria += sin(angulo)
            }
            uniformidad = MedidasDeConjunto.redondear((real * real + imaginaria * imaginaria).squareRoot() / k)
        }
        contratiempo = ataques.filter { Self.mcd($0, n) == 1 }.count
        sincopa = Self.sincopa(ataques, pulsos: n, tiempos: ritmo.tiempos)
    }

    static func mcd(_ a: Int, _ b: Int) -> Int { b == 0 ? a : mcd(b, a % b) }

    /// La distancia ponderada de las notas a los tiempos (WNBD): por cada golpe fuera de un tiempo, 1/T si acaba
    /// antes del siguiente tiempo, 2/T si cruza uno y 1/T si cruza más, siendo T su distancia al tiempo más cercano
    /// en tiempos; la media entre los golpes.
    static func sincopa(_ ataques: [Int], pulsos n: Int, tiempos: [Int]) -> Double {
        guard !ataques.isEmpty, !tiempos.isEmpty, n > 0 else { return 0 }
        let inicios = tiempos + [n]
        var total = 0.0
        for (i, ataque) in ataques.enumerated() {
            guard let tiempo = inicios.lastIndex(where: { $0 <= ataque }), inicios[tiempo] != ataque else { continue }
            let antes = inicios[tiempo]
            let despues = inicios[tiempo + 1]
            let longitud = Double(despues - antes)
            let distancia = Double(min(ataque - antes, despues - ataque)) / longitud
            let fin = i + 1 < ataques.count ? ataques[i + 1] : n + ataques[0]
            let cruzados = (tiempos + tiempos.map { $0 + n }).filter { $0 > ataque && $0 < fin }.count
            total += (cruzados == 1 ? 2 : 1) / distancia
        }
        return MedidasDeConjunto.redondear(total / Double(ataques.count))
    }
}

extension RitmoConNombre {
    /// Lo que se mide del ritmo (`EstadisticasDeRitmo`).
    public var estadisticas: EstadisticasDeRitmo { EstadisticasDeRitmo(self) }

    /// La distancia de Hamming a otro ritmo de los mismos pulsos: en cuántos pulsos uno suena y el otro no. `nil` si
    /// tienen distintos pulsos.
    ///
    ///     RitmoConNombre.claveDeSon.distanciaDeHamming(a: .claveDeRumba)   // 2
    public func distanciaDeHamming(a otro: RitmoConNombre) -> Int? {
        guard pulsos == otro.pulsos else { return nil }
        let suyos = Set(otro.ataques)
        return Set(ataques).symmetricDifference(suyos).count
    }

    /// La distancia de intercambio de Toussaint a otro ritmo de los mismos pulsos y golpes: cuántos intercambios de
    /// un golpe con un silencio vecino llevan de uno a otro (la suma de lo que se mueve cada golpe, en orden). `nil`
    /// si tienen distintos pulsos o golpes.
    ///
    ///     RitmoConNombre.claveDeSon.distanciaDeIntercambio(a: .claveDeRumba)   // 1
    public func distanciaDeIntercambio(a otro: RitmoConNombre) -> Int? {
        guard pulsos == otro.pulsos, ataques.count == otro.ataques.count else { return nil }
        return zip(ataques, otro.ataques).map { abs($0 - $1) }.reduce(0, +)
    }
}
