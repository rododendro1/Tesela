import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct CoralTests {
    private func problemas(_ texto: String, sourceLocation: SourceLocation = #_sourceLocation)
        -> [FaltaDeConduccion.Tipo]
    {
        do {
            return try Coral(leyendo: texto).faltas.map(\.tipo)
        } catch {
            Issue.record("«\(texto)»: \(error)", sourceLocation: sourceLocation)
            return []
        }
    }

    @Test func cadenciaCorrecta() throws {
        let c = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        #expect(c.faltas == [])
        #expect(c.esCorrecta)
        #expect(c.numeroDeVoces == 4)
        #expect(c.voz(3).map(\.nombre) == ["Do₅", "Do₅", "Si₄", "Do₅"])
    }

    @Test func paralelas() throws {
        let c = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5")
        #expect(c.faltas.map(\.tipo) == [.quintasParalelas, .octavasParalelas])
        #expect(c.faltas.map(\.voces) == [[0, 1], [0, 3]])
        #expect(c.faltas.map(\.acorde) == [0, 0])
        #expect(
            c.faltas.map(\.description) == [
                "Quintas paralelas entre bajo y tenor (acordes 1 → 2)",
                "Octavas paralelas entre bajo y soprano (acordes 1 → 2)",
            ])
        #expect(c.faltas[0].descripcion(en: .inglesASCII) == "Parallel fifths between bass and tenor (chords 1 → 2)")
        #expect(c.faltas[0].descripcion(en: .gallego) == "Quintas paralelas entre baixo e tenor (acordes 1 → 2)")
        #expect(c.faltas[1].descripcion(en: .catalan) == "Octaves paral·leles entre baix i soprano (acords 1 → 2)")
        #expect(c.faltas[0].descripcion(en: .euskera) == "Bosgarren paraleloak baxua eta tenorra (1 → 2 akordeak)")
        // Por movimiento contrario también cuentan; el unísono es una octava.
        #expect(problemas("Do3 Sol3 Mi4 Do5 | Sol2 Re4 Sol4 Si4") == [.quintasParalelas])
        #expect(
            problemas("Do4 Do4 Sol4 | Re4 Re4 La4") == [
                .superposicion, .octavasParalelas, .quintasParalelas, .quintasParalelas,
            ])
        // Una quinta que se queda quieta no es paralela; una quinta disminuida tampoco cuenta.
        #expect(problemas("Do3 Sol3 Mi4 Do5 | Do3 Sol3 Fa4 La4") == [])
        #expect(problemas("Do4 Sol4 | Si3 Fa4") == [])
    }

    @Test func directas() {
        // Bajo y soprano suben a la vez y el soprano salta a la quinta o la octava.
        #expect(problemas("Mi3 Sol3 Do4 Sol4 | Fa3 La3 Do4 Do5") == [.quintasDirectas])
        #expect(problemas("Mi3 Sol3 Do4 Do5 | Fa3 Do4 La4 Fa5") == [.octavasDirectas])
        // Con el soprano por grado conjunto, no.
        #expect(problemas("La2 Mi4 La4 Si4 | Do3 Mi4 Sol4 Do5") == [])
    }

    @Test func crucesYSuperposicion() {
        #expect(problemas("Do3 Sol4 Mi4 Do5") == [.cruceDeVoces])
        #expect(problemas("Do3 Mi3 Sol3 Do4 | Fa3 Fa3 La3 Do4") == [.superposicion])
        #expect(problemas("Do3 Mi3 Sol3 Do4 | Fa2 La3 Do4 Fa4").first == .superposicion)
    }

    @Test func separacionYTesitura() throws {
        #expect(problemas("Do3 Do4 Mi4 Sol5") == [.separacionExcesiva])
        // Entre bajo y tenor sí puede haber más de una octava.
        #expect(problemas("Do2 Mi3 Sol3 Do4") == [.fueraDeTesitura])
        let c = try Coral(leyendo: "Do2 Mi3 Sol3 Do4")
        #expect(c.faltas[0].voces == [0])
        #expect(c.faltas[0].description == "Fuera de tesitura en bajo (acorde 1)")
        // Con otro número de voces no hay tesituras.
        #expect(problemas("Do2 Sol5 Do6") == [])
    }

    @Test func saltos() throws {
        #expect(problemas("Fa3 Do4 La4 Fa5 | Sol#3 Si3 Mi4 Si4") == [.saltoNoMelodico])
        #expect(problemas("Do4 Do5 | Fa#4 Do5") == [.saltoNoMelodico])
        #expect(problemas("Do3 Do4 | Do3 Re5") == [.saltoNoMelodico])
        // Una octava justa, o un semitono cromático, sí son melódicos.
        #expect(problemas("Do3 Do4 | Do3 Do5") == [])
        #expect(problemas("Do3 Do4 | Do3 Do#4") == [])
        let c = try Coral(leyendo: "Fa3 Do4 La4 Fa5 | Sol#3 Si3 Mi4 Si4")
        #expect(c.faltas[0].descripcion(en: .inglesASCII) == "Unmelodic leap in the bass (chords 1 → 2)")
    }

    @Test func construccion() throws {
        let acordes: [[Altura]] = [["Do3", "Mi4", "Sol4", "Do5"], ["Sol2", "Re4", "Sol4", "Si4"]]
        let porVoces: [[Altura]] = [["Do3", "Sol2"], ["Mi4", "Re4"], ["Sol4", "Sol4"], ["Do5", "Si4"]]
        #expect(Coral(acordes) == Coral(voces: porVoces))
        #expect(try (Coral(leyendo: "C3 E4 G4 C5, G2 D4 G4 B4")) == Coral(acordes))
        #expect(Coral([]) == nil)
        #expect(Coral([["Do4"]]) == nil)
        #expect(Coral([["Do4", "Mi4"], ["Do4"]]) == nil)
        #expect(Coral(voces: [["Do4", "Re4"], ["Mi4"]]) == nil)
    }

    @Test func errores() throws {
        do {
            _ = try Coral(leyendo: "Do3 Mi4 | Sol2 H4")
            Issue.record("Se esperaba un error")
        } catch {
            let error = error as? ErrorDeLectura
            #expect(error?.posicion == 15)
            #expect(error?.texto == "Do3 Mi4 | Sol2 H4")

        }
        do {
            _ = try Coral(leyendo: "Do3 Mi4 | Sol2")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .vocesDistintas? = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }

        }
        do {
            _ = try Coral(leyendo: " | ")
            Issue.record("Se esperaba un error")
        } catch {
            guard case .textoVacio? = (error as? ErrorDeLectura)?.motivo else {
                Issue.record("\(error)")
                return
            }

        }
    }
}
