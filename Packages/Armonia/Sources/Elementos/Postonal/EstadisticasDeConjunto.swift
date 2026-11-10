import Foundation

// MARK: - Lo que dice la teoría de conjuntos de un conjunto de clases de altura

/// Cuántas tríadas de cada clase caben en las notas de un conjunto, en cualquier transposición.
public struct TriadasContenidas: Hashable, Sendable, Codable {
    public let mayores: Int
    public let menores: Int
    public let disminuidas: Int
    public let aumentadas: Int

    public var total: Int { mayores + menores + disminuidas + aumentadas }
}

/// Si un conjunto de seis notas se completa con una transposición o una inversión suya (Babbitt): las doce notas sin
/// repetir ninguna, como en las series combinatorias.
public struct CombinatoriedadHexacordal: Hashable, Sendable, Codable {
    /// Las transposiciones (en semitonos) que dan las seis notas que le faltan.
    public let transposiciones: [Int]
    /// Los índices de las inversiones (I_n: x ↦ n − x) que dan las seis notas que le faltan.
    public let inversiones: [Int]
    /// La letra de Babbitt, de la A a la F, si es de las seis «totalmente combinatorias».
    public let tipo: String?
}

/// Lo que dicen de un conjunto de clases de altura la teoría de conjuntos y las medidas que salen solo de sus clases
/// (no de su ortografía ni de su disposición): Huron, Fourier, Tymoczko, Hanson, Forte, Messiaen, Zeitler, Balzano y
/// Babbitt. Lo comparten `EstadisticasDeAcorde.conjunto` y `EstadisticasDeEscala.conjunto`.
///
///     let mayor = ConjuntoDeClasesDeAltura([0, 2, 4, 5, 7, 9, 11]).estadisticas
///     mayor.analisisDeHanson   // "p⁶m³n⁴s⁵d²t"
///     mayor.parsimonia         // 2
public struct EstadisticasDeConjunto: Hashable, Sendable {
    /// La consonancia diádica de Huron (1994): la suma de los pesos de consonancia de cada clase interválica de su
    /// vector. Cuanto más alta, más consonante: 2,22 la tríada mayor.
    public let consonanciaDiadica: Double
    /// Las magnitudes de los coeficientes de Fourier |f1|…|f6| (Quinn 2006; Amiot 2016), exactas: cuánto se
    /// parece al cluster cromático (f1), al tritono (f2), al aumentado (f3), a la séptima disminuida (f4), a la escala
    /// diatónica (f5) y a la de tonos enteros (f6).
    public let magnitudesDeFourier: [Double]
    /// Equilibrado (Milne y otros, 2017): |f1| = 0, sus notas como vectores en el círculo se anulan.
    public let equilibrado: Bool
    /// La distancia euclídea, en semitonos, al conjunto perfectamente repartido de su mismo número de notas más
    /// cercano (Tymoczko 2011): 0 el aumentado, 0,816 las tríadas mayor y menor.
    public let distanciaALaUniformidad: Double
    /// Cuántas tríadas mayores, menores, disminuidas y aumentadas caben en sus notas.
    public let triadasContenidas: TriadasContenidas
    /// El análisis de Hanson (1960) de su vector: p las quintas, m las terceras mayores, n las menores, s las segundas
    /// mayores, d las menores y t los tritonos, con su número como exponente: «p⁶m³n⁴s⁵d²t» la mayor.
    public let analisisDeHanson: String
    /// La entropía de Shannon, en bits, de cómo se reparten sus intervalos entre las seis clases interválicas.
    public let entropiaIntervalica: Double
    /// Profundo (Gamer, 1967): cada clase interválica aparece un número de veces distinto, como en la mayor.
    public let profundo: Bool
    /// Coincide con alguna de sus inversiones (en vez de tener una pareja especular, quiral).
    public let simetricoPorInversion: Bool
    /// El número de Forte del conjunto en relación Z con el suyo (el mismo vector interválico sin ser la misma
    /// clase), si lo tiene: 4-Z29 para 4-Z15.
    public let parejaZ: String?
    /// El número de Forte de las notas que le faltan para las doce.
    public let complemento: String?
    /// El modo de transposición limitada de Messiaen (1944) que es, del 1 (tonos enteros) al 7.
    public let modoDeMessiaen: Int?
    /// Si es de seis notas y se completa con una transposición o una inversión suya (Babbitt).
    public let combinatoriedad: CombinatoriedadHexacordal?
    /// La parsimonia (Tymoczko 2011): cuántos conjuntos de su misma clase (por transposición o inversión) salen de
    /// mover una sola nota un semitono. 2 la mayor.
    public let parsimonia: Int
    /// Las imperfecciones (Zeitler): las notas sin quinta justa encima en el conjunto. 1 la mayor (Si).
    public let imperfecciones: Int
    /// La unicidad de Balzano (1980): ninguna transposición lo deja igual, así que todos sus modos son distintos.
    public let unicidad: Bool
    /// La simplicidad de Balzano: sus notas forman una sola región en la red de terceras (cada nota unida a las que
    /// están a ±3 y ±4 semitonos).
    public let simplicidad: Bool

    public init(_ conjunto: ConjuntoDeClasesDeAltura) {
        let clases = conjunto.clases
        let vector = conjunto.vectorIntervalico
        consonanciaDiadica = zip(vector, Self.pesosDeHuron).map { Double($0) * $1 }.reduce(0, +)
        magnitudesDeFourier = Self.magnitudesDeFourier(clases)
        equilibrado = magnitudesDeFourier.first == 0
        distanciaALaUniformidad = Self.distanciaALaUniformidad(clases)
        triadasContenidas = Self.triadasContenidas(Set(clases))
        analisisDeHanson = Self.analisisDeHanson(vector)
        entropiaIntervalica = Self.entropia(vector)
        profundo = Set(vector).count == 6
        simetricoPorInversion = conjunto.simetriasPorInversion > 0
        parejaZ = Self.parejaZ(de: conjunto)
        complemento = conjunto.complemento.numeroDeForte
        modoDeMessiaen = Self.modoDeMessiaen(Set(clases))
        combinatoriedad = Self.combinatoriedad(conjunto)
        parsimonia = Self.parsimonia(conjunto)
        let notas = Set(clases)
        imperfecciones = clases.filter { !notas.contains(modulo($0 + 7, 12)) }.count
        unicidad = conjunto.simetriasPorTransposicion == 1
        simplicidad = Self.simplicidad(clases)
    }

    // MARK: Las medidas

    /// Los pesos de Huron (1994, «Interval-class content in equally tempered pitch-class sets», *Music Perception*
    /// 11: 289–305) para cada clase interválica, del semitono al tritono.
    static let pesosDeHuron: [Double] = [-1.428, -0.582, 0.594, 0.386, 1.240, -0.453]

    static func magnitudesDeFourier(_ clases: [Int]) -> [Double] {
        (1...6).map { k in
            let angulos = clases.map { -2 * Double.pi * Double(k * $0) / 12 }
            let real = angulos.map(cos).reduce(0, +)
            let imaginaria = angulos.map(sin).reduce(0, +)
            return sinRuido((real * real + imaginaria * imaginaria).squareRoot())
        }
    }

    /// 0 si es tan pequeño que solo es el error de redondeo de las sumas de senos y cosenos (|f1| del acorde aumentado
    /// sale 4·10⁻¹⁶): así los que valen 0 dan 0.
    package static func sinRuido(_ valor: Double) -> Double { abs(valor) < 1e-9 ? 0 : valor }

    static func distanciaALaUniformidad(_ clases: [Int]) -> Double {
        let ordenadas = clases.sorted()
        let n = Double(ordenadas.count)
        guard ordenadas.count > 1 else { return 0 }
        let desvios = ordenadas.enumerated().map { Double($1) - 12 * Double($0) / n }
        let media = desvios.reduce(0, +) / n
        let suma = desvios.map { ($0 - media) * ($0 - media) }.reduce(0, +)
        return sinRuido(suma.squareRoot())
    }

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

    static func analisisDeHanson(_ vector: [Int]) -> String {
        guard vector.count == 6 else { return "" }
        let superindices: [Character] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
        func exponente(_ numero: Int) -> String {
            numero == 1 ? "" : String(String(numero).compactMap { $0.wholeNumberValue.map { superindices[$0] } })
        }
        let orden = [("p", 4), ("m", 3), ("n", 2), ("s", 1), ("d", 0), ("t", 5)]
        return orden.filter { vector[$0.1] > 0 }.map { $0.0 + exponente(vector[$0.1]) }.joined()
    }

    static func entropia(_ vector: [Int]) -> Double {
        let total = Double(vector.reduce(0, +))
        guard total > 0 else { return 0 }
        var entropia = 0.0
        for cuenta in vector where cuenta > 0 {
            let p = Double(cuenta) / total
            entropia -= p * log2(p)
        }
        return entropia
    }

    static func parejaZ(de conjunto: ConjuntoDeClasesDeAltura) -> String? {
        guard conjunto.numeroDeForte?.contains("Z") == true else { return nil }
        let vector = conjunto.vectorIntervalico
        return ConjuntoDeClasesDeAltura.tablaForte.first { prima, _ in
            prima.count == conjunto.cardinalidad && prima != conjunto.formaPrima
                && ConjuntoDeClasesDeAltura(prima).vectorIntervalico == vector
        }?.value
    }

    /// Los modos de transposición limitada de Messiaen (*Technique de mon langage musical*, 1944), uno por clase de
    /// transposición.
    static let modosDeMessiaen: [Set<Int>] = [
        [0, 2, 4, 6, 8, 10], [0, 1, 3, 4, 6, 7, 9, 10], [0, 2, 3, 4, 6, 7, 8, 10, 11], [0, 1, 2, 5, 6, 7, 8, 11],
        [0, 1, 5, 6, 7, 11], [0, 2, 4, 5, 6, 8, 10, 11], [0, 1, 2, 3, 5, 6, 7, 8, 9, 11],
    ]

    static func modoDeMessiaen(_ conjunto: Set<Int>) -> Int? {
        modosDeMessiaen.firstIndex { modo in
            (0..<12).contains { t in Set(modo.map { modulo($0 + t, 12) }) == conjunto }
        }.map { $0 + 1 }
    }

    /// Las seis hexacordales totalmente combinatorias de Babbitt, por su forma prima.
    static let hexacordosDeBabbitt: [[Int]: String] = [
        [0, 1, 2, 3, 4, 5]: "A", [0, 2, 3, 4, 5, 7]: "B", [0, 2, 4, 5, 7, 9]: "C", [0, 1, 2, 6, 7, 8]: "D",
        [0, 1, 4, 5, 8, 9]: "E", [0, 2, 4, 6, 8, 10]: "F",
    ]

    static func combinatoriedad(_ conjunto: ConjuntoDeClasesDeAltura) -> CombinatoriedadHexacordal? {
        guard conjunto.cardinalidad == 6 else { return nil }
        let complemento = conjunto.complemento
        let transposiciones = (1..<12).filter { conjunto.transponer($0) == complemento }
        let inversiones = (0..<12).filter { conjunto.invertir($0) == complemento }
        guard !transposiciones.isEmpty || !inversiones.isEmpty else { return nil }
        let tipo = !transposiciones.isEmpty && !inversiones.isEmpty ? hexacordosDeBabbitt[conjunto.formaPrima] : nil
        return CombinatoriedadHexacordal(transposiciones: transposiciones, inversiones: inversiones, tipo: tipo)
    }

    static func parsimonia(_ conjunto: ConjuntoDeClasesDeAltura) -> Int {
        let prima = conjunto.formaPrima
        var vecinas = Set<ConjuntoDeClasesDeAltura>()
        for nota in conjunto.clases {
            for paso in [1, -1] where !conjunto.contiene(nota + paso) {
                let vecina = ConjuntoDeClasesDeAltura(conjunto.clases.filter { $0 != nota } + [nota + paso])
                if vecina.formaPrima == prima { vecinas.insert(vecina) }
            }
        }
        return vecinas.count
    }

    static func simplicidad(_ clases: [Int]) -> Bool {
        let conjunto = Set(clases)
        guard let primera = clases.first else { return true }
        var vistas: Set<Int> = [primera]
        var pendientes = [primera]
        while let nota = pendientes.popLast() {
            for paso in [3, -3, 4, -4] {
                let vecina = modulo(nota + paso, 12)
                if conjunto.contains(vecina), vistas.insert(vecina).inserted { pendientes.append(vecina) }
            }
        }
        return vistas.count == conjunto.count
    }
}

extension ConjuntoDeClasesDeAltura {
    /// Lo que dicen de él la teoría de conjuntos y las medidas que salen de sus clases (`EstadisticasDeConjunto`).
    public var estadisticas: EstadisticasDeConjunto { EstadisticasDeConjunto(self) }

}
