import Foundation
import Testing

@testable import Armonia

/// Propiedades que se cumplen para cualquier entrada, comprobadas con muchas al azar (con semilla fija, así que
/// fallan siempre igual). Cada fallo dice el caso, para convertirlo en una prueba normal.
@Suite struct PropiedadesTests {
    static let casos = 300

    // MARK: Generadores

    static func nota(_ azar: inout GeneradorConSemilla, quintas: ClosedRange<Int> = -12...12) -> Nota {
        Nota(pasosDeQuinta: Int.random(in: quintas, using: &azar))
    }

    static func altura(_ azar: inout GeneradorConSemilla) -> Altura {
        Altura(nota(&azar), octava: Int.random(in: 1...7, using: &azar))
    }

    /// Un intervalo de menos de dos octavas, hacia arriba o hacia abajo, con hasta seis quintas (de la 5ª
    /// disminuida a la 4ª aumentada, sus inversiones y sus compuestos).
    static func intervalo(_ azar: inout GeneradorConSemilla) -> Intervalo {
        let quintas = Int.random(in: -6...6, using: &azar)
        // Las octavas justas para que quede entre 0 y 11 semitonos, y quizá una más.
        let octavas = Int((Double(-7 * quintas) / 12).rounded(.up)) + Int.random(in: 0...1, using: &azar)
        let intervalo = Intervalo(pasosDeQuinta: quintas, pasosDeOctava: octavas)
        return Bool.random(using: &azar) ? intervalo : -intervalo
    }

    static func acorde(_ azar: inout GeneradorConSemilla) -> Acorde {
        let tipo = TipoDeAcorde.todos.randomElement(using: &azar)!
        return Acorde(
            nota(&azar, quintas: -7...7), tipo, inversion: Int.random(in: 0..<tipo.intervalos.count, using: &azar))
    }

    static func tonalidad(_ azar: inout GeneradorConSemilla) -> Tonalidad {
        Tonalidad(nota(&azar, quintas: -5...5), Tonalidad.Modo.allCases.randomElement(using: &azar)!)
    }

    /// Un coral de cuatro voces sin cruces, con notas de hasta seis alteraciones (Si♯3 sería un Do4).
    static func coral(_ azar: inout GeneradorConSemilla) -> Coral {
        let acordes = (0..<Int.random(in: 1...8, using: &azar)).map { _ in
            (2...5).map { Altura(nota(&azar, quintas: -5...6), octava: $0) }
        }
        return Coral(acordes)!
    }

    static func repetir(semilla: UInt64, _ comprobar: (inout GeneradorConSemilla) throws -> Void) rethrows {
        var azar = GeneradorConSemilla(semilla: semilla)
        for _ in 0..<casos { try comprobar(&azar) }
    }

    // MARK: Transposición

    @Test func transponerIdaYVuelta() {
        Self.repetir(semilla: 1) { azar in
            let i = Self.intervalo(&azar)
            let nota = Self.nota(&azar)
            let altura = Self.altura(&azar)
            let acorde = Self.acorde(&azar)
            let tonalidad = Self.tonalidad(&azar)
            #expect(nota.transponer(i).transponer(-i) == nota, "\(nota) y \(i)")
            #expect(altura.transponer(i).transponer(-i) == altura, "\(altura) y \(i)")
            #expect(acorde.transponer(i).transponer(-i) == acorde, "\(acorde) y \(i)")
            #expect(tonalidad.transponer(i).transponer(-i) == tonalidad, "\(tonalidad) y \(i)")
        }
    }

    /// Transponer una altura mueve su número MIDI tantos semitonos como el intervalo, y la distancia entre dos
    /// alturas es el intervalo que lleva de una a otra.
    @Test func alturasEIntervalos() {
        Self.repetir(semilla: 2) { azar in
            let a = Self.altura(&azar)
            let b = Self.altura(&azar)
            let i = Self.intervalo(&azar)
            #expect(a.transponer(i).midi == a.midi + i.semitonosConSigno, "\(a) y \(i)")
            #expect(a.transponer(b - a) == b, "\(a) y \(b)")
            #expect((b - a).semitonosConSigno == b.midi - a.midi, "\(a) y \(b)")
        }
    }

    @Test func sumaDeIntervalos() {
        Self.repetir(semilla: 3) { azar in
            let a = Self.intervalo(&azar)
            let b = Self.intervalo(&azar)
            let c = Self.intervalo(&azar)
            #expect(a + b == b + a, "\(a) y \(b)")
            #expect((a + b) + c == a + (b + c), "\(a), \(b) y \(c)")
            #expect((a + b) - b == a, "\(a) y \(b)")
        }
    }

    /// Transponer un acorde no cambia de qué tipo es ni su inversión, y transpone su bajo.
    @Test func transponerConservaElAcorde() {
        Self.repetir(semilla: 4) { azar in
            let acorde = Self.acorde(&azar)
            let i = Self.intervalo(&azar)
            let transpuesto = acorde.transponer(i)
            #expect(transpuesto.tipo == acorde.tipo, "\(acorde) y \(i)")
            #expect(transpuesto.bajo == acorde.bajo.transponer(i), "\(acorde) y \(i)")
            #expect(transpuesto.notas == acorde.notas.map { $0.transponer(i) }, "\(acorde) y \(i)")
        }
    }

    // MARK: Conjuntos de clases

    /// La forma prima, el número de Forte y el vector interválico son los mismos para un conjunto, sus
    /// transposiciones y sus inversiones: es para lo que sirven.
    @Test func invariantesPostonales() {
        Self.repetir(semilla: 5) { azar in
            let clases = (0..<Int.random(in: 1...9, using: &azar)).map { _ in Int.random(in: 0...11, using: &azar) }
            let conjunto = ConjuntoDeClases(clases)
            let n = Int.random(in: 0...11, using: &azar)
            for otro in [conjunto.transponer(n), conjunto.invertir(n)] {
                #expect(otro.formaPrima == conjunto.formaPrima, "\(clases), n = \(n)")
                #expect(otro.numeroDeForte == conjunto.numeroDeForte, "\(clases), n = \(n)")
                #expect(otro.vectorIntervalico == conjunto.vectorIntervalico, "\(clases), n = \(n)")
            }
        }
    }

    // MARK: Análisis

    /// Una progresión de acordes de una tonalidad, transpuesta, se analiza en la tonalidad transpuesta y con los
    /// mismos grados.
    @Test func analizarLoTranspuesto() throws {
        try Self.repetir(semilla: 6) { azar in
            let tonalidad = Self.tonalidad(&azar)
            let grados =
                [1] + (0..<Int.random(in: 2...6, using: &azar)).map { _ in Int.random(in: 1...7, using: &azar) }
                + [5, 1]
            let acordes = grados.map { tonalidad.acorde(grado: $0) }
            let i = Intervalo(pasosDeQuinta: Int.random(in: -3...3, using: &azar), pasosDeOctava: 0)
            let analisis = try #require(AnalisisArmonico.analizar(acordes))
            let transpuesto = try #require(AnalisisArmonico.analizar(acordes.map { $0.transponer(i) }))
            #expect(transpuesto.tonalidad == analisis.tonalidad.transponer(i), "\(acordes) y \(i)")
            #expect(transpuesto.cifrados == analisis.cifrados, "\(acordes) y \(i)")
        }
    }

    // MARK: Ficheros

    /// Un coral escrito en MusicXML se vuelve a leer con las mismas alturas, con su ortografía.
    @Test func musicXMLIdaYVuelta() throws {
        try Self.repetir(semilla: 7) { azar in
            let coral = Self.coral(&azar)
            let pieza = try PiezaImportada(musicXML: Data(coral.musicXML().utf8))
            #expect(Self.porAcorde(pieza) == coral.acordes.map { $0.sorted(by: Self.orden) }, "\(coral)")
        }
    }

    /// Un coral escrito en MIDI se vuelve a leer con las mismas notas (MIDI no guarda la ortografía).
    @Test func midiIdaYVuelta() throws {
        try Self.repetir(semilla: 8) { azar in
            let coral = Self.coral(&azar)
            let pieza = try PiezaImportada(midi: coral.midi())
            #expect(
                Self.porAcorde(pieza).map { $0.map(\.midi) } == coral.acordes.map { $0.map(\.midi).sorted() },
                "\(coral)")
        }
    }

    static func orden(_ a: Altura, _ b: Altura) -> Bool {
        (a.midi, a.description) < (b.midi, b.description)
    }

    /// Las notas de la pieza agrupadas por el momento en que empiezan, cada grupo de grave a agudo.
    static func porAcorde(_ pieza: PiezaImportada) -> [[Altura]] {
        Dictionary(grouping: pieza.notas, by: \.inicio)
            .sorted { $0.key < $1.key }
            .map { $0.value.map(\.altura).sorted(by: orden) }
    }
}
