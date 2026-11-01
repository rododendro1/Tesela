import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de los dibujos: el Tonnetz y la tabla armónica.

extension LineaDeComandosTests {
    @Test func tonnetz() {
        for orden in [
            "tonnetz Do Mi Sol", "tonnetz --acorde Sol7", "tonnetz --escala Re dórico", "tonnetz --clases 0 4 7",
            "tonnetz --clases 0,3,6,9 --margen 2", "tonnetz C E G --ingles",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tonnetz --acorde Do").contains(">Mi</text>"))
        #expect(salida("tonnetz C E G --ingles").contains(">E</text>"))
        for orden in [
            "tonnetz", "tonnetz --clases 0 12", "tonnetz --clases", "tonnetz --acorde", "tonnetz --escala",
            "tonnetz --color Do", "tonnetz Do --margen 9",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tonnetz", "Do", "Hm"]).codigo == 1)
        #expect(salida("tonnetz --recorrido Do Lam Fa Rem").contains("Do –R→ Lam –L→ Fa –R→ Rem"))
        #expect(salida("tonnetz --camino Do Mibm").contains("Do –P→ Dom –R→ Mi♭ –P→ Mi♭m"))
        for orden in [
            "tonnetz --recorrido", "tonnetz --recorrido Do Sol7", "tonnetz --camino Do", "tonnetz --camino Do Sol7",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func tablaArmonica() {
        for orden in [
            "tabla Do Mi Sol", "tabla Do3 Sol3 Mi4", "tabla --acorde Domaj7", "tabla --escala Re dórico",
            "tabla --clases 0,4,7 --margen 3", "tabla C E G --ingles",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tabla Do3 Sol3 Mi4").contains(">Sol3</text>"))
        for orden in ["tabla", "tabla --acorde", "tabla --clases 13", "tabla --foo", "tabla Do --margen 7"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tabla", "Do4", "Hm4"]).codigo == 1)
        #expect(salida("tabla --recorrido Do Lam Fa Rem").contains("<title>Do –R→ Lam –L→ Fa –R→ Rem</title>"))
        #expect(salida("tabla --camino Do Mibm").contains("<title>Do –P→ Dom –R→ Mi♭ –P→ Mi♭m</title>"))
        for orden in ["tabla --recorrido", "tabla --recorrido Do Sol7", "tabla --camino Do", "tabla --camino Do Sol7"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
    }
}
