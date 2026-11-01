import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de los dibujos: el Tonnetz y la tabla armónica.

extension LineaDeComandosTests {
    func testTonnetz() {
        for orden in [
            "tonnetz Do Mi Sol", "tonnetz --acorde Sol7", "tonnetz --escala Re dórico", "tonnetz --clases 0 4 7",
            "tonnetz --clases 0,3,6,9 --margen 2", "tonnetz C E G --ingles",
        ] {
            let svg = salida(orden)
            XCTAssertTrue(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), orden)
        }
        XCTAssertTrue(salida("tonnetz --acorde Do").contains(">Mi</text>"))
        XCTAssertTrue(salida("tonnetz C E G --ingles").contains(">E</text>"))
        for orden in [
            "tonnetz", "tonnetz --clases 0 12", "tonnetz --clases", "tonnetz --acorde", "tonnetz --escala",
            "tonnetz --color Do", "tonnetz Do --margen 9",
        ] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
        XCTAssertEqual(LineaDeComandos.ejecutar(["tonnetz", "Do", "Hm"]).codigo, 1)
        XCTAssertTrue(salida("tonnetz --recorrido Do Lam Fa Rem").contains("Do –R→ Lam –L→ Fa –R→ Rem"))
        XCTAssertTrue(salida("tonnetz --camino Do Mibm").contains("Do –P→ Dom –R→ Mi♭ –P→ Mi♭m"))
        for orden in [
            "tonnetz --recorrido", "tonnetz --recorrido Do Sol7", "tonnetz --camino Do", "tonnetz --camino Do Sol7",
        ] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
    }

    func testTablaArmonica() {
        for orden in [
            "tabla Do Mi Sol", "tabla Do3 Sol3 Mi4", "tabla --acorde Domaj7", "tabla --escala Re dórico",
            "tabla --clases 0,4,7 --margen 3", "tabla C E G --ingles",
        ] {
            let svg = salida(orden)
            XCTAssertTrue(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), orden)
        }
        XCTAssertTrue(salida("tabla Do3 Sol3 Mi4").contains(">Sol3</text>"))
        for orden in ["tabla", "tabla --acorde", "tabla --clases 13", "tabla --foo", "tabla Do --margen 7"] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
        XCTAssertEqual(LineaDeComandos.ejecutar(["tabla", "Do4", "Hm4"]).codigo, 1)
        XCTAssertTrue(salida("tabla --recorrido Do Lam Fa Rem").contains("<title>Do –R→ Lam –L→ Fa –R→ Rem</title>"))
        XCTAssertTrue(salida("tabla --camino Do Mibm").contains("<title>Do –P→ Dom –R→ Mi♭ –P→ Mi♭m</title>"))
        for orden in ["tabla --recorrido", "tabla --recorrido Do Sol7", "tabla --camino Do", "tabla --camino Do Sol7"] {
            XCTAssertEqual(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo, 2, orden)
        }
    }
}
