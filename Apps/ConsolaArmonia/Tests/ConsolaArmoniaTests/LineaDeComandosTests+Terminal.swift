import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

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

    /// Los valores se proponen según la orden: `--formato` da los de cada una, y `--momento`, solo en `escalas`.
    @Test func losValoresSegunLaOrden() throws {
        func orden(_ nombre: String) throws -> LineaDeComandos.Orden {
            try #require(LineaDeComandos.ordenes.first { $0.nombres.contains(nombre) })
        }
        let (escalas, musicXML) = (try orden("escalas"), try orden("musicxml"))
        let (escala, digitaciones) = (try orden("escala"), try orden("digitaciones"))
        #expect(LineaDeComandos.valores(de: .momento, en: escalas)?.contains("anochecer") == true)
        #expect(LineaDeComandos.valores(de: .momento, en: musicXML) == nil)
        #expect(LineaDeComandos.valores(de: .compas, en: musicXML) == nil)
        #expect(LineaDeComandos.valores(de: .dedos, en: escala)?.contains("guitarra") == true)
        #expect(LineaDeComandos.valores(de: .maximoDeDedos, en: digitaciones) == nil)
        #expect(LineaDeComandos.valores(de: .idioma, en: nil)?.contains("eu") == true)
        // `--formato` propone los formatos de cada orden.
        #expect(LineaDeComandos.valores(de: .formato, en: digitaciones) == ["musicxml", "json"])
        #expect(LineaDeComandos.valores(de: .formato, en: escala) == ["bibtex", "json"])
        #expect(LineaDeComandos.valores(de: .formato, en: try orden("hoja")) == ["html", "json"])
        #expect(LineaDeComandos.valores(de: .formato, en: try orden("transponer"))?.contains("mei") == true)
        #expect(LineaDeComandos.valores(de: .formato, en: try orden("grabar")) == ["pdf", "svg", "png"])
        // Con guiones, como los demás valores, y sin repetir.
        for (_, valores) in LineaDeComandos.opcionesConValores(en: escalas) {
            for valor in valores { #expect(valor == valor.lowercased(), Comment(rawValue: valor)) }
        }
        #expect(LineaDeComandos.valores(de: .lugar, en: escalas)?.contains("reino-unido") == true)
        #expect(LineaDeComandos.conGuiones("safiAlDin") == "safi-al-din")
        #expect(!OpcionDeOrden.momento.seEscribe("--time") && OpcionDeOrden.compas.seEscribe("--time"))
        #expect(!salida("completado bash").contains("--clave|--clef|--clave|--clef"))
    }

    /// El completado de bash, en bash: lo que propone tras unas palabras.
    @Test(.enabled(if: FileManager.default.isExecutableFile(atPath: "/bin/bash")))
    func elCompletadoEnBash() throws {
        let guion = FileManager.default.temporaryDirectory.appendingPathComponent("armonia-completado-\(UUID()).sh")
        defer { try? FileManager.default.removeItem(at: guion) }
        try salida("completado bash").write(to: guion, atomically: true, encoding: .utf8)
        func propuestas(_ palabras: String) throws -> String {
            let proceso = Process()
            proceso.executableURL = URL(fileURLWithPath: "/bin/bash")
            proceso.arguments = [
                "-c",
                "source \"$0\"; COMP_WORDS=(armonia \(palabras) ''); COMP_CWORD=$((${#COMP_WORDS[@]}-1)); _armonia; "
                    + "echo \"${COMPREPLY[*]}\"",
                guion.path,
            ]
            let tuberia = Pipe()
            proceso.standardOutput = tuberia
            try proceso.run()
            proceso.waitUntilExit()
            return String(decoding: tuberia.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        }
        let (hora, compas) = (try propuestas("escalas --momento"), try propuestas("musicxml melodia Do --time"))
        #expect(hora.contains("anochecer"))
        #expect(compas == "\n")
        let (dedos, idioma) = (try propuestas("escala Do mayor --dedos"), try propuestas("--idioma"))
        #expect(dedos.contains("guitarra"))
        #expect(idioma.contains("eu"))
        let lugar = try propuestas("escalas --lugar")
        #expect(lugar.contains("reino-unido"))
    }

    /// `--opcion=valor`, en una orden y en las opciones generales.
    @Test func opcionesConIgual() {
        #expect(salida("digitaciones Do --limite=2") == salida("digitaciones Do --limite 2"))
        #expect(salida("acorde Sol7 --idioma=en") == salida("acorde Sol7 --idioma en"))
        #expect(resultado("acorde Sol7 --json=1").codigo == 2)
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
