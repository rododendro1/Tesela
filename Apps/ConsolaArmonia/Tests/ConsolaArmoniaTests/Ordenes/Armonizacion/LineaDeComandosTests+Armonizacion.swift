import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de la armonización, la realización, las voces y el contrapunto.

extension LineaDeComandosTests {
    @Test func armonizar() {
        #expect(
            salida("armonizar Mi4 Fa4 Re4 Do4") == """
                Do mayor
                  1. Do Fa Sol Do (I–IV–V–I)
                  2. Do Fa Sol7 Do (I–IV–V7–I)
                  3. Do Rem Sol Do (I–ii–V–I)
                A cuatro voces (bajo, tenor, contralto, soprano):
                  Do        I         Do₃ Sol₃ Do₄ Mi₄
                  Fa        IV        Fa₂ La₃ Do₄ Fa₄
                  Sol       V         Sol₂ Sol₃ Si₃ Re₄
                  Do        I         Do₃ Mi₃ Do₄ Do₄

                """)
        // Sin octavas, solo los acordes; con --propuestas, cuántos.
        #expect(salida("armonizar Mi Re Do --propuestas 1") == "Do mayor\n  1. Do Sol Do (I–V–I)\n")
        #expect(
            salida("armonizar Do Si La Sol# La --en La menor").hasPrefix("La menor\n  1. Lam Mi Lam Mi Lam (i–V–i–V–i)")
        )
        #expect(salida("harmonize E D C --ingles").hasPrefix("C major\n  1. C G C (I–V–I)"))
        // El coral lleva la melodía en el soprano y pasa la revisión.
        let lineas = salida("armonizar Do5 Si4 La4 Sol4 Fa4 Mi4 Re4 Do4").split(separator: "\n")
        let voces = lineas.drop { !$0.hasPrefix("A cuatro voces") }.dropFirst()
            .map { $0.split(separator: " ").suffix(4).joined(separator: " ") }
        #expect(voces.count == 8)
        #expect(
            voces.map { $0.split(separator: " ").last! } == ["Do₅", "Si₄", "La₄", "Sol₄", "Fa₄", "Mi₄", "Re₄", "Do₄"])
        #expect(salida("revisar " + voces.joined(separator: ", ")) == "Sin faltas de conducción.\n")
        // Fuera de la tesitura del soprano no hay coral.
        #expect(salida("armonizar Do6 Si5 Do6").hasSuffix("No hay ninguna realización sin faltas de conducción.\n"))
    }

    @Test func realizar() {
        #expect(
            salida("realizar Do Fa Sol7 Do") == """
                Do mayor
                  Do        I         Do₃ Mi₄ Sol₄ Do₅
                  Fa        IV        Fa₃ Fa₄ La₄ Do₅
                  Sol7      V7        Sol₃ Fa₄ Sol₄ Si₄
                  Do        I         Do₄ Mi₄ Sol₄ Do₅

                """)
        #expect(salida("realize C F G7 C --ingles").hasPrefix("C major\n  C         I         C3 E4 G4 C5"))
        #expect(salida("realizar Lam Rem Mi7 Lam --en La menor").contains("V7"))
        #expect(salida("realizar Do7(9,13)") == "No hay ninguna realización sin faltas de conducción.\n")
    }

    @Test func voces() {
        #expect(
            conFaltas("revisar Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5") == """
                Quintas paralelas entre bajo y tenor (acordes 1 → 2)
                Octavas paralelas entre bajo y soprano (acordes 1 → 2)

                """)
        #expect(salida("revisar Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4") == "Sin faltas de conducción.\n")
    }

    @Test func contrapunto() {
        let fux = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4 / La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5"
        #expect(salida("contrapunto " + fux) == "Especie 1, con el contrapunto encima del cantus firmus\nSin faltas.\n")
        #expect(
            salida("counterpoint " + fux + " --ingles")
                == "Species 1, counterpoint above the cantus firmus\nNo faults.\n")
        #expect(
            salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2")
                == salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --species 2"))
        #expect(
            salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2").hasSuffix(
                "Sin faltas.\n"))
        #expect(
            conFaltas("contrapunto Do4 Re4 Mi4 Do4 / Sol4 La4 Sol4 Do5").contains("Quintas paralelas (compases 1 → 2)"))
        // Lo que no dura lo mismo que el cantus es un error de lectura, no de uso.
        #expect(LineaDeComandos.ejecutar(["contrapunto", "Re4", "Fa4", "/", "La4"]).codigo == 1)
        #expect(salida("ayuda --todo").contains("contrapunto <cantus> / <contrapunto> [--especie 1]"))
    }

    @Test func revisarUnArchivo() throws {
        let escrito = "Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5"
        let coral = try Coral(leyendo: escrito)
        let xml = try fichero(Data(coral.partitura(duracion: .blanca).musicXML().utf8), extension: "musicxml")
        let midi = try fichero(coral.partitura().midi(), extension: "mid")
        #expect(conFaltas("revisar --archivo " + xml) == conFaltas("revisar " + escrito))
        #expect(conFaltas("check --file " + midi) == conFaltas("revisar " + escrito))
        #expect(resultado("revisar --archivo \(xml) --json").codigo == 3)
        // Un fichero que no se puede leer es un error de lectura; con acordes detrás, de uso.
        #expect(resultado("revisar --archivo /no/existe.musicxml").codigo == 1)
        #expect(resultado("revisar --archivo /no/existe.musicxml --json").codigo == 1)
        #expect(resultado("revisar --archivo \(xml) Do3 Mi4 Sol4 Do5").codigo == 2)
        #expect(resultado("revisar --archivo").codigo == 2)
    }

    @Test func proponerUnContrapunto() throws {
        let cantus = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4"
        let propuesta = salida("contrapunto \(cantus) --proponer")
        let lineas = propuesta.split(separator: "\n").map(String.init)
        #expect(lineas.count == 3)
        #expect(lineas.dropFirst() == ["Especie 1, con el contrapunto encima del cantus firmus", "Sin faltas."])
        // La propuesta pasa la revisión del contrapunto escrito.
        let notas = lineas[0].replacingOccurrences(of: "₄", with: "4").replacingOccurrences(of: "₅", with: "5")
        #expect(salida("contrapunto \(cantus) / \(notas)").hasSuffix("Sin faltas.\n"))
        #expect(salida("contrapunto \(cantus) --proponer --debajo").contains("debajo del cantus firmus"))
        #expect(salida("counterpoint \(cantus) --propose --proposals 3 --ingles").hasPrefix("1. "))
        #expect(salida("contrapunto \(cantus) --proponer --propuestas 3").contains("\n\n3. "))
        let json = resultado("contrapunto \(cantus) --proponer --propuestas 2 --json")
        #expect(json.codigo == 0)
        #expect(json.salida.contains("\"propuestas\""))
        #expect(json.salida.contains("\"contrapunto\""))
        #expect(!resultado("contrapunto \(cantus) / \(notas) --json").salida.contains("\"contrapunto\""))
        #expect(resultado("contrapunto --proponer").codigo == 2)
        #expect(resultado("contrapunto \(cantus) / \(notas) --proponer").codigo == 2)
        #expect(resultado("contrapunto \(cantus) --proponer --propuestas 0").codigo == 2)
        #expect(salida("ayuda contrapunto").contains("--proponer"))
    }
}

extension LineaDeComandosTests {
    @Test func armonizarYRealizarUnArchivo() throws {
        let melodia = try Voz(leyendo: "Mi4:4 Fa4:4 Re4:4 Do4:4")
        let xml = try fichero(Data(melodia.partitura().musicXML().utf8), extension: "musicxml")
        #expect(salida("armonizar --archivo " + xml) == salida("armonizar Mi4:4 Fa4:4 Re4:4 Do4:4"))
        #expect(salida("harmonize --file \(xml) --proposals 1 --ingles").hasPrefix("C major\n  1. "))
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let midi = try fichero(analisis.partitura().midi(), extension: "mid")
        #expect(salida("realizar --archivo " + midi) == salida("realizar Do Fa Sol7 Do"))
        #expect(salida("realize --file \(midi) --in C major --ingles").hasPrefix("C major\n"))
        #expect(resultado("armonizar --archivo \(xml) Mi4").codigo == 2)
        #expect(resultado("realizar Do Fa --ventana 2").codigo == 2)
        #expect(resultado("realizar --archivo /no/existe.mid").codigo == 1)
        #expect(resultado("armonizar --archivo /no/existe.mid --json").codigo == 1)
    }

    @Test func transponerUnArchivo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        let midi = try fichero(analisis.partitura().midi(), extension: "mid")
        // En el formato del fichero (aquí, MIDI) o en el de --formato.
        let transportado = LineaDeComandos.ejecutar(["transponer", "2M", "--archivo", midi])
        #expect(transportado.codigo == 0)
        let datos = try #require(transportado.datos)
        #expect(try PiezaImportada(leyendo: datos).acordes().map(\.cifrado) == ["Re", "Sol", "La7", "Re"])
        let abc = salida("transponer Re --archivo \(midi) --formato abc")
        #expect(abc.contains("K:D"))
        #expect(salida("transpose D --file \(midi) --format musicxml").hasPrefix("<?xml"))
        #expect(resultado("transponer 2M --archivo \(midi) --formato pdf").codigo == 2)
        #expect(resultado("transponer 2M --archivo \(midi) --json").codigo == 2)
        #expect(resultado("transponer --archivo \(midi)").codigo == 2)
        #expect(resultado("transponer 2M --archivo /no/existe.mid").codigo == 1)
    }
}

extension LineaDeComandosTests {
    @Test func contrapuntoAVariasVoces() {
        let ejercicio = "Do4 Re4 Mi4 Do4 / Sol4 La4 Sol4 Do5 / Do3 Re3 Mi3 Do3"
        let informe = conFaltas("contrapunto " + ejercicio)
        #expect(informe.hasPrefix("Contrapunto a 3 voces\n"))
        #expect(informe.contains("Quintas paralelas (compases 1 → 2): voz 1 / voz 2\n"))
        #expect(conFaltas("contrapunto \(ejercicio) --especie 1,1") == informe)
        #expect(
            conFaltas("counterpoint C4 D4 E4 C4 / G4 A4 G4 C5 / C3 D3 E3 C3 --ingles").hasPrefix("Counterpoint in 3"))
        let json = resultado("contrapunto \(ejercicio) --json")
        #expect(json.codigo == 3)
        #expect(json.salida.contains("\"voces\":[1,2]"))
        #expect(resultado("contrapunto \(ejercicio) --especie 1,2,3").codigo == 2)
        #expect(resultado("contrapunto \(ejercicio) --especie 9").codigo == 2)
        #expect(resultado("contrapunto Do4 Re4 / / Do3 Re3").codigo == 2)
    }

    @Test func realizarUnBajoCifrado() {
        let coral = salida("realizar Do La:6 Sol:7 Do --bajo-cifrado")
        let lineas = coral.split(separator: "\n").map(String.init)
        #expect(lineas.first == "Do mayor")
        #expect(lineas.dropFirst().map { $0.split(separator: " ")[2] } == ["Do₃", "La₂", "Sol₂", "Do₃"])
        #expect(coral.contains("Fa/La"))
        #expect(salida("realize C A:6 G:7 C --figured-bass --in C major --ingles").hasPrefix("C major\n"))
        #expect(salida("realizar La Re:6 Mi:# La --bajo-cifrado --en La menor").hasPrefix("La menor\n"))
        #expect(LineaDeComandos.ejecutar(["realizar", "--bajo-cifrado"]).codigo == 2)
    }
}
