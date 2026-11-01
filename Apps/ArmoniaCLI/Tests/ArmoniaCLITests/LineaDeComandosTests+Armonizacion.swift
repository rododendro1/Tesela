import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de la armonización, la realización, las voces y el contrapunto.

extension LineaDeComandosTests {
    func testArmonizar() {
        XCTAssertEqual(
            salida("armonizar Mi4 Fa4 Re4 Do4"),
            """
            Do mayor
              1. Do Fa Sol Do (I–IV–V–I)
              2. Do Fa Sol7 Do (I–IV–V7–I)
              3. Do Rem Sol Do (I–ii–V–I)
            A cuatro voces (bajo, tenor, contralto, soprano):
              Do        I         Do3 Sol3 Do4 Mi4
              Fa        IV        Fa2 La3 Do4 Fa4
              Sol       V         Sol2 Sol3 Si3 Re4
              Do        I         Do3 Mi3 Do4 Do4

            """)
        // Sin octavas, solo los acordes; con --propuestas, cuántos.
        XCTAssertEqual(salida("armonizar Mi Re Do --propuestas 1"), "Do mayor\n  1. Do Sol Do (I–V–I)\n")
        XCTAssertTrue(
            salida("armonizar Do Si La Sol# La --en La menor").hasPrefix("La menor\n  1. Lam Mi Lam Mi Lam (i–V–i–V–i)")
        )
        XCTAssertTrue(salida("harmonize E D C --ingles").hasPrefix("C major\n  1. C G C (I–V–I)"))
        // El coral lleva la melodía en el soprano y pasa la revisión.
        let lineas = salida("armonizar Do5 Si4 La4 Sol4 Fa4 Mi4 Re4 Do4").split(separator: "\n")
        let voces = lineas.drop { !$0.hasPrefix("A cuatro voces") }.dropFirst()
            .map { $0.split(separator: " ").suffix(4).joined(separator: " ") }
        XCTAssertEqual(voces.count, 8)
        XCTAssertEqual(
            voces.map { $0.split(separator: " ").last! }, ["Do5", "Si4", "La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4"])
        XCTAssertEqual(salida("revisar " + voces.joined(separator: ", ")), "Sin faltas de conducción.\n")
        // Fuera de la tesitura del soprano no hay coral.
        XCTAssertTrue(
            salida("armonizar Do6 Si5 Do6").hasSuffix("No hay ninguna realización sin faltas de conducción.\n"))
    }

    func testRealizar() {
        XCTAssertEqual(
            salida("realizar Do Fa Sol7 Do"),
            """
            Do mayor
              Do        I         Do3 Mi4 Sol4 Do5
              Fa        IV        Fa3 Fa4 La4 Do5
              Sol7      V7        Sol3 Fa4 Sol4 Si4
              Do        I         Do4 Mi4 Sol4 Do5

            """)
        XCTAssertTrue(salida("realize C F G7 C --ingles").hasPrefix("C major\n  C         I         C3 E4 G4 C5"))
        XCTAssertTrue(salida("realizar Lam Rem Mi7 Lam --en La menor").contains("V7"))
        XCTAssertEqual(salida("realizar Do7(9,13)"), "No hay ninguna realización sin faltas de conducción.\n")
    }

    func testVoces() {
        XCTAssertEqual(
            salida("revisar Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5"),
            """
            Quintas paralelas entre bajo y tenor (acordes 1 → 2)
            Octavas paralelas entre bajo y soprano (acordes 1 → 2)

            """)
        XCTAssertEqual(salida("revisar Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4"), "Sin faltas de conducción.\n")
    }

    func testContrapunto() {
        let fux = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4 / La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5"
        XCTAssertEqual(
            salida("contrapunto " + fux), "Especie 1, con el contrapunto encima del cantus firmus\nSin faltas.\n")
        XCTAssertEqual(
            salida("counterpoint " + fux + " --ingles"), "Species 1, counterpoint above the cantus firmus\nNo faults.\n"
        )
        XCTAssertEqual(
            salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2"),
            salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --species 2"))
        XCTAssertTrue(
            salida("contrapunto Re4 Fa4 Mi4 Re4 / -:2 La4 Re5 La4 Si4 Do#5 Re5:1 --especie 2").hasSuffix(
                "Sin faltas.\n"))
        XCTAssertTrue(
            salida("contrapunto Do4 Re4 Mi4 Do4 / Sol4 La4 Sol4 Do5").contains("Quintas paralelas (compases 1 → 2)"))
        // Lo que no dura lo mismo que el cantus es un error de lectura, no de uso.
        XCTAssertEqual(LineaDeComandos.ejecutar(["contrapunto", "Re4", "Fa4", "/", "La4"]).codigo, 1)
        XCTAssertTrue(salida("ayuda").contains("contrapunto <cantus> / <contrapunto> [--especie 1]"))
    }
}
