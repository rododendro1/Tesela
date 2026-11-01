import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de lo que se instala en la terminal: el completado y la página de manual.

extension LineaDeComandosTests {
    @Test func completado() {
        let bash = salida("completado bash")
        #expect(bash.contains("_armonia()"))
        #expect(bash.contains("complete -o default -F _armonia armonia"))
        // Las órdenes, los tipos de partitura, las opciones y sus valores.
        for palabra in ["acorde", "musicxml", "melodia", "--clave", "--idioma", "--patron"] {
            #expect(bash.contains(palabra), Comment(rawValue: palabra))
        }
        let zsh = salida("completion zsh")
        #expect(zsh.hasPrefix("#compdef armonia"))
        #expect(zsh.contains("bashcompinit"))
        let fish = salida("completado fish")
        #expect(fish.contains("complete -c armonia"))
        #expect(fish.contains("acorde"))
        // Sin distinguir mayúsculas, como las órdenes.
        #expect(salida("completado BASH") == bash)
        #expect(resultado("completado", "tcsh").codigo == 2)
    }

    @Test func lasOpcionesDelCompletado() throws {
        let midi = try #require(LineaDeComandos.ordenes.first { $0.nombres.contains("midi") })
        let musicXML = try #require(LineaDeComandos.ordenes.first { $0.nombres.contains("musicxml") })
        #expect(LineaDeComandos.opciones(de: midi).contains("--programa"))
        #expect(!LineaDeComandos.opciones(de: midi).contains("--clave"))
        #expect(LineaDeComandos.opciones(de: musicXML).contains("--clave"))
        #expect(LineaDeComandos.tipos(de: musicXML).contains("coral"))
    }

    @Test func manual() {
        let roff = salida("manual")
        #expect(roff.hasPrefix(".TH ARMONIA 1"))
        #expect(roff.contains(".SH NOMBRE\narmonia \\- "))
        #expect(roff.contains(".B acorde"))
        #expect(roff.contains(".EX\narmonia acorde"))
        // Ninguna línea de texto empieza por un punto que roff tomaría por una petición desconocida.
        let peticiones: Set = [".TH", ".SH", ".TP", ".B", ".br", ".sp", ".RS", ".EX", ".EE", ".RE", ".PP"]
        for linea in roff.split(separator: "\n") where linea.hasPrefix(".") {
            #expect(peticiones.contains(String(linea.prefix { $0 != " " })), Comment(rawValue: String(linea)))
        }
        let ingles = salida("man --ingles")
        #expect(ingles.contains(".SH NAME"))
        #expect(!ingles.contains("acorde Do"))
        #expect(resultado("manual", "extra").codigo == 2)
    }

    @Test func escaparEnRoff() {
        #expect(LineaDeComandos.escapar("a-b \\c") == "a\\-b \\ec")
        #expect(LineaDeComandos.escapar(".foo") == "\\&.foo")
        #expect(LineaDeComandos.escapar("'foo") == "\\&'foo")
    }
}
