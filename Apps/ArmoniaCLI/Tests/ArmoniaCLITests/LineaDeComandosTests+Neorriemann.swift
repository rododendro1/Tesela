import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de la teoría neorriemanniana: conducción parsimoniosa y PLR.

extension LineaDeComandosTests {
    func testConduccionParsimoniosa() {
        XCTAssertEqual(salida("vecinos Sol7"), "Sol♯°7 (Sol→Sol♯)\nSolm7 (Si→Si♭)\nMim7 (Fa→Mi)\n")
        XCTAssertTrue(salida("vecinos Sol7 --voces 2").contains("Re♭7 (Sol→La♭, Re→Re♭)"))
        XCTAssertEqual(salida("vecinos G7 --ingles"), "G#°7 (G→G#)\nGm7 (B→Bb)\nEm7 (F→E)\n")
        XCTAssertEqual(
            salida("conduccion-parsimoniosa Sol7 Rem7"),
            "Sol7 –Sol→Sol♯→ Sol♯°7 –Sol♯→La→ Sim7(♭5) –Si→Do→ Rem7\n3 pasos\n")
        XCTAssertEqual(salida("conduccion-parsimoniosa Sol7 Reb7 --voces 2"), "Sol7 –Sol→La♭, Re→Re♭→ Re♭7\n1 paso\n")
        XCTAssertEqual(
            salida("conduccion-minima Sol7 Do"), "Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos\n")
        XCTAssertEqual(salida("vecinos Domaj7"), "Do♯m7(♭5) (Do→Do♯)\nDo7 (Si→Si♭)\n")
        XCTAssertTrue(salida("vecinos Sol7 --ampliada").contains("Solmaj7 (Fa→Fa♯)"))
        XCTAssertEqual(salida("conduccion-parsimoniosa Do7 Domaj7"), "Do7 –Si♭→Si→ Domaj7\n1 paso\n")
        for orden in [
            "vecinos", "vecinos Do6", "vecinos Do --ampliada", "vecinos Sol7 --voces 3", "conduccion-parsimoniosa Sol7",
            "conduccion-parsimoniosa Do Sol7", "conduccion-minima Sol7",
        ] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
    }

    func testPLR() {
        XCTAssertEqual(salida("plr Do PLR"), "Do –P→ Dom –L→ La♭ –R→ Fam\nPLR, 3 pasos\n")
        XCTAssertEqual(salida("plr Do P L"), "Do –P→ Dom –L→ La♭\nPL, 2 pasos\n")
        XCTAssertEqual(salida("plr Do H"), "Do –L→ Mim –P→ Mi –L→ Sol♯m\nLPL, 3 pasos\n")
        XCTAssertEqual(salida("plr Do Mibm"), "Do –P→ Dom –R→ Mi♭ –P→ Mi♭m\nPRP, 3 pasos\n")
        XCTAssertEqual(salida("plr Do Lam"), "Do –R→ Lam\nR, 1 paso\n")
        XCTAssertEqual(salida("plr Do Do"), "Do\nningún paso\n")
        XCTAssertEqual(salida("plr C Am --ingles"), "C –R→ Am\nR, 1 step\n")
        XCTAssertEqual(
            salida("plr Do hexatonico"),
            "Do –P→ Dom –L→ La♭ –P→ La♭m –L→ Mi –P→ Mim –L→ Do\nciclo hexatónico, 6 tríadas\n")
        XCTAssertTrue(salida("plr Do ciclo LR").hasSuffix("–R→ Do\nciclo LR, 24 tríadas\n"))
        XCTAssertTrue(salida("plr C octatonic --ingles").hasSuffix("octatonic cycle, 8 triads\n"))
        XCTAssertTrue(salida("tonnetz --ciclo hexatonico Do").contains("La♭m –L→ Mi"))
        XCTAssertEqual(LineaDeComandos.ejecutar(["tonnetz", "--ciclo", "Do"]).codigo, 2)
        XCTAssertEqual(LineaDeComandos.ejecutar(["tonnetz", "--ciclo", "hexatonico", "Do7"]).codigo, 2)
        XCTAssertTrue(salida("tabla --ciclo octatonico Do").contains("Sol♭ –P→ Fa♯m"))
        XCTAssertEqual(LineaDeComandos.ejecutar(["tabla", "--ciclo", "LR", "Sol7"]).codigo, 2)
        for orden in ["plr", "plr Do", "plr Sol7 P", "plr Do Sol7"] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
        XCTAssertEqual(LineaDeComandos.ejecutar(["plr", "Do", "Xq"]).codigo, 1)
    }
}
