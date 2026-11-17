import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las formas cortas: una tonalidad con solo su tónica, los catálogos tras `catalogo` y lo que se quiso escribir en un
// valor mal escrito.

extension LineaDeComandosTests {
    @Test func laTonalidadConSoloLaTonica() throws {
        #expect(try LineaDeComandos.tonalidad("Do", en: .compacta(.espanol)) == Tonalidad(.do, .mayor))
        #expect(try LineaDeComandos.tonalidad("C", en: .compacta(.espanol)) == Tonalidad(.do, .mayor))
        #expect(try LineaDeComandos.tonalidad("Lam", en: .compacta(.espanol)) == Tonalidad(.la, .menor))
        #expect(try LineaDeComandos.tonalidad("Am", en: .compacta(.espanol)) == Tonalidad(.la, .menor))
        #expect(try LineaDeComandos.tonalidad("Re menor", en: .compacta(.espanol)) == Tonalidad(.re, .menor))
        // Lo que no es una tríada mayor o menor en estado fundamental sigue siendo un error de la tonalidad.
        for texto in ["Do7", "Do/Mi", "Do°", "Do mayr"] {
            #expect(throws: ErrorDeLecturaDeTeoria.self) {
                try LineaDeComandos.tonalidad(texto, en: .compacta(.espanol))
            }
        }
        #expect(salida("analizar Do Fa Sol7 Do --en Do").hasPrefix("I–IV–V7–I en Do mayor"))
        #expect(salida("analizar Lam Rem Mi Lam --en Lam").hasPrefix("i–iv–V–i en La menor"))
        #expect(salida("tonalidad C").hasPrefix("Do mayor"))
        // Donde `--en` es una escala (`ornamentos`), la tónica sola es la escala de la tonalidad.
        #expect(salida("ornamentos --sobre Mi4 --en Do") == salida("ornamentos --sobre Mi4 --en Do mayor"))
        #expect(salida("ornamentos --sobre Mi4 --en Lam") == salida("ornamentos --sobre Mi4 --en La menor"))
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try LineaDeComandos.escala("Do7", en: .compacta(.espanol)) }
    }

    @Test func losCatalogosTrasCatalogo() {
        #expect(salida("catalogo ornamentos") == salida("ornamentos"))
        #expect(salida("catalog rhythms --ingles") == salida("rhythms --ingles"))
        #expect(salida("catálogo ritmos") == salida("ritmos"))
        #expect(salida("catalogo ornamentos --json") == salida("ornamentos --json"))
        #expect(salida("catalogo ritmos --help") == salida("ritmos --help"))
        // Sin catálogo, la ayuda de catalogo; con uno que no existe, lo que se quiso escribir.
        #expect(salida("catalogo").contains("catalogo <catálogo> [<opciones>]"))
        let mal = LineaDeComandos.ejecutar(["catalogo", "ritmo"])
        #expect(mal.codigo == 2)
        #expect(mal.error.contains("«ritmos»"))
        // En la ayuda, los catálogos tienen su grupo.
        #expect(salida("").contains("Catálogos (también armonia catalogo <catálogo>):\n  catalogo"))
        #expect(LineaDeComandos.tipos(de: LineaDeComandos.ordenDeCatalogo).contains("ornaments"))
    }

    @Test func loQueSeQuisoEscribirEnUnValor() {
        let mayor = LineaDeComandos.ejecutar(["escala", "do", "mayr"])
        #expect(mayor.codigo == 1)
        #expect(mayor.error.hasSuffix("¿Querías decir «mayor»?\n"))
        #expect(LineaDeComandos.ejecutar(["escala", "Re", "menor", "armonca"]).error.contains("«menor armónica»"))
        #expect(LineaDeComandos.ejecutar(["scale", "C", "dorain", "--ingles"]).error.hasSuffix("\"dorian\"?\n"))
        // Lo que no se parece a nada, o no es un tipo de escala, no propone nada.
        #expect(!LineaDeComandos.ejecutar(["escala", "Do", "zzzzzz"]).error.contains("¿"))
        #expect(!LineaDeComandos.ejecutar(["acorde", "Xx"]).error.contains("¿"))
    }
}
