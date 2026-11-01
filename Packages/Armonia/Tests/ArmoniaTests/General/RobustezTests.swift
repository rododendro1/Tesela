import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Generador pseudoaleatorio con semilla fija (SplitMix64): las pruebas al azar fallan siempre
/// igual y se pueden repetir.
struct GeneradorConSemilla: RandomNumberGenerator {
    private var estado: UInt64
    init(semilla: UInt64) { estado = semilla }
    mutating func next() -> UInt64 {
        estado &+= 0x9E37_79B9_7F4A_7C15
        var z = estado
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}

/// Ida y vuelta al azar: cualquier valor se escribe en cualquier notación y se vuelve a leer igual.
@Suite struct IdaYVueltaAlAzarTests {
    private static let notaciones: [Notacion] = [.espanolCompacto, .espanolASCII, .inglesASCII, .inglesCompacto]
    private static let casos = 500

    private func comprobar<T: RepresentableComoTexto & Equatable>(
        _ generar: (inout GeneradorConSemilla) -> T, sourceLocation: SourceLocation = #_sourceLocation
    ) {
        var azar = GeneradorConSemilla(semilla: 2026)
        for _ in 0..<Self.casos {
            let valor = generar(&azar)
            for notacion in Self.notaciones {
                let texto = valor.texto(en: notacion)
                #expect(T(texto: texto) == valor, "«\(texto)» (\(notacion))", sourceLocation: sourceLocation)
            }
        }
    }

    private static func nota(_ azar: inout GeneradorConSemilla) -> Nota {
        Nota(pasosDeQuinta: Int.random(in: -14...14, using: &azar))
    }

    @Test func notasYAlturas() {
        comprobar { Self.nota(&$0) }
        comprobar { Altura(Self.nota(&$0), octava: Int.random(in: -1...9, using: &$0)) }
    }

    @Test func intervalos() {
        comprobar { azar in
            Intervalo(
                pasosDeQuinta: Int.random(in: -12...12, using: &azar),
                pasosDeOctava: Int.random(in: -3...3, using: &azar))
        }
    }

    @Test func acordes() {
        comprobar { azar in
            let tipo = TipoDeAcorde.todos.randomElement(using: &azar)!
            let raiz = Nota(pasosDeQuinta: Int.random(in: -7...7, using: &azar))
            if Bool.random(using: &azar) {
                return Acorde(raiz, tipo, inversion: Int.random(in: 0..<tipo.intervalos.count, using: &azar))
            }
            return Acorde(raiz, tipo, bajo: Nota(pasosDeQuinta: Int.random(in: -7...7, using: &azar)))
        }
    }

    @Test func escalasYTonalidades() {
        comprobar { azar in
            Escala(
                Nota(pasosDeQuinta: Int.random(in: -7...7, using: &azar)),
                (TipoDeEscala.todos + TipoDeEscala.tradicionales).randomElement(using: &azar)!)
        }
        comprobar { azar in
            Tonalidad(
                Nota(pasosDeQuinta: Int.random(in: -7...7, using: &azar)),
                Tonalidad.Modo.allCases.randomElement(using: &azar)!)
        }
    }

    /// Lo que se codifica con Codable se decodifica igual.
    @Test func codable() throws {
        var azar = GeneradorConSemilla(semilla: 7)
        let acordes = (0..<200).map { _ in
            Acorde(
                Nota(pasosDeQuinta: Int.random(in: -7...7, using: &azar)),
                TipoDeAcorde.todos.randomElement(using: &azar)!)
        }
        let datos = try JSONEncoder().encode(acordes)
        #expect(try (JSONDecoder().decode([Acorde].self, from: datos)) == acordes)
    }
}

/// Lo que no se debe aceptar: textos mal escritos, mezclas de idiomas y conjuntos que no son acordes.
@Suite struct CasosNegativosTests {
    private func rechaza<T: RepresentableComoTexto>(
        _ tipo: T.Type, _ textos: [String], sourceLocation: SourceLocation = #_sourceLocation
    ) {
        for texto in textos {
            #expect(
                T(texto: texto) == nil, "«\(texto)» no debería leerse como \(T.self)", sourceLocation: sourceLocation)
            #expect(throws: (any Error).self, "«\(texto)»", sourceLocation: sourceLocation) { try T(leyendo: texto) }
        }
    }

    @Test func textosMalEscritos() {
        rechaza(Nota.self, ["", " ", "H", "Fa#4", "Doo", "Do!", "#", "Sol#?"])
        rechaza(Altura.self, ["", "Do", "La", "4", "Do4.5", "Do 4 4", "H4"])
        rechaza(Intervalo.self, ["", "3J", "5M", "4m", "1m", "3X", "X3", "M"])
        rechaza(Acorde.self, ["", "Do7(b3)", "Hm", "Do/", "/Mi", "Do7(", "Do7(b9", "Do7)", "Do7((b9))", "Do 7 7"])
        rechaza(TipoDeAcorde.self, ["xyz", "7(", "m(b3)"])
        rechaza(Escala.self, ["", "Do", "Do mayorr", "mayor", "H mayor"])
        rechaza(Tonalidad.self, ["", "La menorr", "menor", "H mayor"])
    }

    /// La tónica en español va con el tipo en español; con letra se acepta el inglés.
    @Test func noSeMezclanIdiomas() throws {
        rechaza(Escala.self, ["Re dorian", "La harmonic minor", "Fa# lydian"])
        // «Do major» sí vale, como en las tonalidades: es catalán.
        #expect(Escala(texto: "Do major") == Escala(.do, .mayor))
        #expect(Escala(texto: "D dorian") == Escala(.re, .dorico))
        #expect(Escala(texto: "Re dórico") == Escala(.re, .dorico))
        #expect(Escala(texto: "F# lydian") == Escala(Nota(.fa, .sostenido), .lidio))

        // Las tonalidades se leen a través de las escalas: la misma regla.
        rechaza(Tonalidad.self, ["Re minor", "Sib minor", "La harmonic minor"]) // «Do major» sí vale: es catalán
        #expect(Tonalidad(texto: "D minor") == Tonalidad(.re, .menor))
        #expect(Tonalidad(texto: "Re menor") == Tonalidad(.re, .menor))

        // El bajo de un acorde se escribe como su fundamental.
        rechaza(Acorde.self, ["Sol7/B", "G7/Si", "Re/E", "C/Mi", "Sib7(b9)/D"]) // «Do/E» sí vale: D°/E
        #expect(Acorde(texto: "G7/B") == Acorde(texto: "Sol7/Si"))
        #expect(Acorde(texto: "Faug/A") == Acorde(.fa, .aumentado, inversion: 1))
        do {
            _ = try Acorde(leyendo: "Sol7/B")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .idiomasMezclados("B")? = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }
            #expect((error as? ErrorDeLectura)?.posicion == 5)

        }
    }

    /// El init opcional lleva etiqueta: con una variable devuelve `nil`, nunca se detiene.
    @Test func textoDelUsuarioNoDetieneLaEjecucion() {
        let entradas = ["Sol7", "Sol77", "", "🎵", String(repeating: "#", count: 50)]
        let leidos = entradas.map { Acorde(texto: $0) }
        #expect(leidos.compactMap { $0 } == [Acorde("Sol7")])
    }

    @Test func codableRechazaTextoNoValido() throws {
        let json = Data(#"["Sol7", "Do7(b3)"]"#.utf8)
        do {
            _ = try JSONDecoder().decode([Acorde].self, from: json)
            Issue.record("Se esperaba un error")
        } catch {
            guard case DecodingError.dataCorrupted = error else {
                Issue.record("\(error)")
                return
            }

        }
    }

    @Test func conjuntosQueNoSonAcordes() {
        #expect(Acorde.identificar([Nota]()).isEmpty)
        #expect(Acorde.identificar([Nota.do]).isEmpty)
        #expect(Acorde.identificar([Nota.do, .do]).isEmpty)
        #expect(Acorde.identificar([Nota.do, Nota(.re, .bemol)]).isEmpty)
        #expect(Acorde.identificar(midi: []).isEmpty)
        #expect(Acorde.identificar(midi: [60, 72, 84]).isEmpty)
        #expect(Acorde.identificar(midi: [60, 61]).isEmpty)
        #expect(Acorde.identificar(midi: [60, 71]).isEmpty)
        // Dos notas sí forman acorde cuando son la quinta (acorde de potencia).
        #expect(Acorde.identificar(midi: [60, 67]).first == Acorde(.do, .potencia))
    }

    @Test func escalasQueNoEncajan() {
        #expect(TipoDeEscala.mohanam.numeroDeMelakarta == nil)
        #expect(!TipoDeEscala.mohanam.melakartasCompatibles.contains(25))
        #expect(!(Escala(.do).contiene(Nota(.fa, .sostenido))))
        #expect(!(Escala(.do).contiene(Nota(.si, .sostenido))))
    }
}
