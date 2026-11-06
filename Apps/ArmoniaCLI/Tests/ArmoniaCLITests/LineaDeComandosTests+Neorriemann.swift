import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de la teoría neorriemanniana: conducción parsimoniosa y PLR.

extension LineaDeComandosTests {
    @Test func conduccionParsimoniosa() {
        #expect(salida("vecinos Sol7") == "Sol♯°7 (Sol→Sol♯)\nSolm7 (Si→Si♭)\nMim7 (Fa→Mi)\n")
        #expect(salida("vecinos Sol7 --voces 2").contains("Re♭7 (Sol→La♭, Re→Re♭)"))
        #expect(salida("vecinos G7 --ingles") == "G#°7 (G→G#)\nGm7 (B→Bb)\nEm7 (F→E)\n")
        #expect(
            salida("camino-parsimonioso Sol7 Rem7")
                == "Sol7 –Sol→Sol♯→ Sol♯°7 –Sol♯→La→ Sim7(♭5) –Si→Do→ Rem7\n3 pasos\n")
        #expect(salida("camino-parsimonioso Sol7 Reb7 --voces 2") == "Sol7 –Sol→La♭, Re→Re♭→ Re♭7\n1 paso\n")
        #expect(salida("conduccion-minima Sol7 Do") == "Sol→Sol, Si→Do (+1), Re→Do (−2), Fa→Mi (−1): 4 semitonos\n")
        #expect(salida("vecinos Domaj7") == "Do♯m7(♭5) (Do→Do♯)\nDo7 (Si→Si♭)\n")
        #expect(salida("vecinos Sol7 --ampliada").contains("Solmaj7 (Fa→Fa♯)"))
        #expect(salida("camino-parsimonioso Do7 Domaj7") == "Do7 –Si♭→Si→ Domaj7\n1 paso\n")
        for orden in [
            "vecinos", "vecinos Do6", "vecinos Do --ampliada", "vecinos Sol7 --voces 3", "camino-parsimonioso Sol7",
            "camino-parsimonioso Do Sol7", "conduccion-minima Sol7",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func pLR() {
        #expect(salida("plr Do PLR") == "Do –P→ Dom –L→ La♭ –R→ Fam\nPLR, 3 pasos\n")
        #expect(salida("plr Do P L") == "Do –P→ Dom –L→ La♭\nPL, 2 pasos\n")
        #expect(salida("plr Do H") == "Do –L→ Mim –P→ Mi –L→ Sol♯m\nLPL, 3 pasos\n")
        #expect(salida("plr camino Do Mibm") == "Do –P→ Dom –R→ Mi♭ –P→ Mi♭m\nPRP, 3 pasos\n")
        #expect(salida("plr camino Do Lam") == "Do –R→ Lam\nR, 1 paso\n")
        #expect(salida("plr camino Do Do") == "Do\nningún paso\n")
        #expect(salida("plr shortest C Am --ingles") == "C –R→ Am\nR, 1 step\n")
        #expect(
            salida("plr ciclo hexatonico Do")
                == "Do –P→ Dom –L→ La♭ –P→ La♭m –L→ Mi –P→ Mim –L→ Do\nciclo hexatónico, 6 tríadas\n")
        #expect(salida("plr ciclo ciclo LR Do").hasSuffix("–R→ Do\nciclo LR, 24 tríadas\n"))
        #expect(salida("plr cycle octatonic C --ingles").hasSuffix("octatonic cycle, 8 triads\n"))
        #expect(salida("tonnetz ciclo hexatonico Do").contains("La♭m –L→ Mi"))
        #expect(LineaDeComandos.ejecutar(["tonnetz", "--ciclo", "Do"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["tonnetz", "--ciclo", "hexatonico", "Do7"]).codigo == 2)
        #expect(salida("tabla ciclo octatonico Do").contains("Sol♭ –P→ Fa♯m"))
        #expect(LineaDeComandos.ejecutar(["tabla", "--ciclo", "LR", "Sol7"]).codigo == 2)
        for orden in ["plr", "plr Do", "plr Sol7 P", "plr camino Do Sol7"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["plr", "Do", "Xq"]).codigo == 1)
    }
}
