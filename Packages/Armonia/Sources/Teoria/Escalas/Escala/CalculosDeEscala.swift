import Elementos
import Foundation

// MARK: - Las medidas de la teoría de escalas

/// La propiedad de Rothenberg (1978, «A model for pattern perception with musical applications», *Mathematical
/// Systems Theory* 11): una escala es propia si ningún intervalo de un número de grados es mayor que uno de más grados,
/// y estrictamente propia si además ninguno es igual.
public enum PropiedadDeRothenberg: String, Hashable, Sendable, Codable, CaseIterable {
    /// Como la mayor y las pentatónicas: cada clase genérica de intervalo se distingue por su tamaño.
    case estrictamentePropia
    /// Como la menor armónica (o la cromática): algún tamaño se repite en dos clases (la segunda aumentada y la tercera
    /// menor), pero ninguno se contradice.
    case propia
    /// Algún intervalo de menos grados es mayor que otro de más.
    case impropia
}

/// Lo que dicen de una escala las teorías: Myhill, Rothenberg, Gamer, Hanson, Messiaen, Balzano…, a partir de sus
/// clases de altura desde la tónica (en semitonos) y de las quintas de su ortografía.
enum CalculosDeEscala {
    /// El tamaño, en semitonos, de los `k` pasos que siguen a la nota `i` (el intervalo genérico de k + 1).
    static func tamano(_ clases: [Int], desde i: Int, pasos k: Int) -> Int {
        let n = clases.count
        return clases[(i + k) % n] - clases[i] + 12 * ((i + k) / n)
    }

    /// Los tamaños distintos de cada intervalo genérico, de la segunda (k = 1) a la séptima de una heptatónica.
    static func espectros(_ clases: [Int]) -> [[Int]] {
        let n = clases.count
        guard n > 1 else { return [] }
        return (1..<n).map { k in Set((0..<n).map { tamano(clases, desde: $0, pasos: k) }).sorted() }
    }

    /// La propiedad de Myhill (Clough y Myerson, 1985): cada intervalo genérico tiene exactamente dos tamaños.
    static func propiedadDeMyhill(_ clases: [Int]) -> Bool {
        let espectros = espectros(clases)
        return !espectros.isEmpty && espectros.allSatisfy { $0.count == 2 }
    }

    /// El generador, de 1 a 6 semitonos: la escala es una cadena de ese intervalo, como la mayor de quintas (o de
    /// cuartas: 5) y la de tonos enteros de tonos. `nil` si no lo es.
    static func generador(_ clases: [Int]) -> Int? {
        let conjunto = Set(clases)
        let n = clases.count
        guard n > 1 else { return nil }
        return (1...6).first { g in
            conjunto.contains { inicio in Set((0..<n).map { modulo(inicio + g * $0, 12) }) == conjunto }
        }
    }

    /// Propia, estrictamente propia o impropia, con cuántos pares de intervalos de clases distintas tienen el mismo
    /// tamaño (ambigüedades) o el de menos grados mayor (contradicciones).
    static func rothenberg(_ clases: [Int]) -> (
        propiedad: PropiedadDeRothenberg, ambiguedades: Int, contradicciones: Int, estabilidad: Double
    ) {
        let n = clases.count
        guard n > 1 else { return (.estrictamentePropia, 0, 0, 1) }
        let tamanos = (1..<n).map { k in (0..<n).map { tamano(clases, desde: $0, pasos: k) } }
        var ambiguedades = 0
        var contradicciones = 0
        for a in tamanos.indices {
            for b in tamanos.indices where b > a {
                for x in tamanos[a] {
                    for y in tamanos[b] {
                        if x == y { ambiguedades += 1 }
                        if x > y { contradicciones += 1 }
                    }
                }
            }
        }
        // La estabilidad: la proporción de intervalos cuyo tamaño no tiene ninguna otra clase genérica.
        let instancias = tamanos.enumerated().flatMap { k, lista in lista.map { (k, $0) } }
        let estables = instancias.filter { k, tamano in
            !tamanos.enumerated().contains { otra, lista in otra != k && lista.contains(tamano) }
        }.count
        let propiedad: PropiedadDeRothenberg =
            contradicciones > 0 ? .impropia : ambiguedades > 0 ? .propia : .estrictamentePropia
        return (
            propiedad, ambiguedades, contradicciones,
            Double(estables) / Double(instancias.count)
        )
    }

    /// El cociente de igualdad, a la manera de Carey (2002, «Coherence and sameness in well-formed and pairwise
    /// well-formed scales», *Journal of Mathematics and Music*): 1 menos las ambigüedades entre el número de pares de
    /// intervalos de clases genéricas distintas. 1 si ningún tamaño se repite entre clases.
    static func cocienteDeIgualdad(_ clases: [Int], ambiguedades: Int) -> Double {
        let n = clases.count
        guard n > 2 else { return 1 }
        let clasesGenericas = n - 1
        let pares = clasesGenericas * (clasesGenericas - 1) / 2 * n * n
        return 1 - Double(ambiguedades) / Double(pares)
    }

    /// La anchura media del espectro (Rothenberg; Chalmers, *Divisions of the Tetrachord*, 1993): cuántos semitonos
    /// van del menor al mayor tamaño de cada intervalo genérico, de media. 1 en las máximamente regulares de siete
    /// notas.
    static func anchuraDelEspectro(_ clases: [Int]) -> Double {
        let espectros = espectros(clases)
        guard !espectros.isEmpty else { return 0 }
        let anchuras = espectros.map { ($0.last ?? 0) - ($0.first ?? 0) }
        return Double(anchuras.reduce(0, +)) / Double(anchuras.count)
    }

    /// Las tríadas y las cuatríadas por terceras sobre cada grado de una heptatónica, con los símbolos del cifrado
    /// («», «m», «°», «+»; «maj7», «7», «m7», «ø7», «°7»…), o «?» si no tiene nombre. `nil` si no tiene siete notas.
    /// Los acordes de ``armonizacion(_:)``, como tipos: `nil` en un grado sin tríada o sin cuatríada conocida.
    static func acordesPorGrados(_ clases: [Int]) -> (triadas: [TipoDeAcorde?], cuatriadas: [TipoDeAcorde?])? {
        guard let armonizacion = armonizacion(clases) else { return nil }
        func tipo(_ cifrado: String) -> TipoDeAcorde? {
            cifrado == "?" ? nil : cifrado.isEmpty ? .mayor : try? TipoDeAcorde(leyendo: cifrado)
        }
        return (armonizacion.triadas.map(tipo), armonizacion.cuatriadas.map(tipo))
    }

    static func armonizacion(_ clases: [Int]) -> (triadas: [String], cuatriadas: [String])? {
        guard clases.count == 7 else { return nil }
        let triadas: [[Int]: String] = [[4, 3]: "", [3, 4]: "m", [3, 3]: "°", [4, 4]: "+"]
        let cuatriadas: [[Int]: String] = [
            [4, 3, 4]: "maj7", [4, 3, 3]: "7", [3, 4, 3]: "m7", [3, 3, 4]: "ø7", [3, 3, 3]: "°7",
            [3, 4, 4]: "m(maj7)", [4, 4, 3]: "+maj7", [4, 4, 2]: "+7", [4, 2, 4]: "7♭5",
        ]
        func terceras(_ i: Int, _ cuantas: Int) -> [Int] {
            (0..<cuantas).map { j in tamano(clases, desde: (i + 2 * j) % 7, pasos: 2) }
        }
        return (
            (0..<7).map { triadas[terceras($0, 2)] ?? "?" }, (0..<7).map { cuatriadas[terceras($0, 3)] ?? "?" }
        )
    }

    /// La rugosidad de Sethares media de los intervalos entre cada par de sus notas, como díadas desde el Do central.
    static func rugosidadMedia(_ clases: [Int]) -> Double {
        var suma = 0.0
        var pares = 0
        for i in clases.indices {
            for j in clases.indices where j > i {
                let voces = [
                    VozMedida(pasosDeQuinta: 0, semitonos: 0),
                    VozMedida(pasosDeQuinta: 0, semitonos: clases[j] - clases[i]),
                ]
                suma += Psicoacustica.rugosidad(voces)
                pares += 1
            }
        }
        return pares == 0 ? 0 : suma / Double(pares)
    }

    /// La entropía armónica de Erlich media de los intervalos entre cada par de sus notas.
    static func entropiaArmonica(_ clases: [Int]) -> Double {
        Psicoacustica.entropiaArmonica(clases.map { VozMedida(pasosDeQuinta: 0, semitonos: $0) })
    }

    /// Los perfiles de Krumhansl y Kessler (1982) de la tonalidad mayor y menor, de la tónica al séptimo semitono.
    static let perfilMayor = [6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88]

    static let perfilMenor = [6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17]

    /// La correlación de Pearson entre las notas de la escala (1 las que tiene, 0 las demás, desde la tónica) y un
    /// perfil tonal: cuanto más cerca de 1, más suena a esa tonalidad.
    static func correlacion(_ clases: [Int], con perfil: [Double]) -> Double {
        let notas = (0..<12).map { clases.contains($0) ? 1.0 : 0.0 }
        let mediaDeNotas = notas.reduce(0, +) / 12
        let mediaDelPerfil = perfil.reduce(0, +) / 12
        var producto = 0.0
        var cuadradosDeNotas = 0.0
        var cuadradosDelPerfil = 0.0
        for i in 0..<12 {
            let (a, b) = (notas[i] - mediaDeNotas, perfil[i] - mediaDelPerfil)
            producto += a * b
            cuadradosDeNotas += a * a
            cuadradosDelPerfil += b * b
        }
        guard cuadradosDeNotas > 0 else { return 0 }
        return producto / (cuadradosDeNotas * cuadradosDelPerfil).squareRoot()
    }

    /// Se parte en dos tetracordos iguales separados por un tono: los mismos pasos de la tónica a la cuarta y de la
    /// quinta a la octava, como la mayor y la dórica.
    static func tetracordosIguales(_ clases: [Int]) -> Bool {
        let conjunto = Set(clases)
        guard conjunto.contains(0), conjunto.contains(5), conjunto.contains(7) else { return false }
        let grave = Set(clases.filter { $0 <= 5 })
        let aguda = Set(clases.filter { $0 >= 7 }.map { $0 - 7 } + [5])
        return grave == aguda
    }
}
