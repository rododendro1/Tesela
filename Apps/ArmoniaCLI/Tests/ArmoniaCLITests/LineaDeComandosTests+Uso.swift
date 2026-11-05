import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de lo que ayuda a usar la herramienta: la versión, la ayuda de cada orden, lo que se quiso escribir
// ante una errata, la entrada estándar y la salida binaria en la terminal.

extension LineaDeComandosTests {
    @Test func version() {
        for orden in ["--version", "version", "versión", "--version --ingles"] {
            #expect(salida(orden) == "armonia \(LineaDeComandos.version)\n", Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.version.split(separator: ".").count == 3)
        #expect(salida("ayuda").contains("--version"))
    }

    /// `ayuda <orden>` y `<orden> --help` dan solo las entradas de esa orden, en el idioma de los textos.
    @Test func ayudaDeUnaOrden() {
        let acorde = salida("ayuda acorde")
        #expect(acorde.hasPrefix("  acorde <cifrado>…"))
        #expect(acorde.contains("armonia acorde Sol7/Si"))
        #expect(!acorde.contains("identificar"))
        for orden in ["acorde --help", "acorde -h", "acorde Do --ayuda", "help chord", "--help acorde", "AYUDA Acorde"]
        {
            #expect(salida(orden) == acorde, Comment(rawValue: orden))
        }
        #expect(salida("ayuda chord --ingles").hasPrefix("  chord <symbol>…"))
        // Una orden con varias entradas las da todas.
        #expect(salida("ayuda tonnetz").contains("tonnetz --acorde"))
        // La ayuda de la ayuda y la de la versión.
        #expect(salida("ayuda ayuda").hasPrefix("  ayuda [<orden>]"))
        #expect(salida("ayuda --version").contains("la versión de armonia"))
        // Cada entrada de la ayuda completa está en la de su orden.
        let completa = salida("ayuda")
        for orden in LineaDeComandos.ordenes {
            #expect(completa.contains(salida("ayuda " + orden.nombres[0])), Comment(rawValue: orden.nombres[0]))
        }
        let desconocida = resultado("ayuda", "acrode")
        #expect(desconocida.codigo == 2)
        #expect(
            desconocida.error
                == "armonia: orden desconocida: «acrode»\n¿Querías decir «acorde»?\nPrueba «armonia ayuda».\n")
    }

    /// Una orden o una opción desconocida propone la que más se le parece, y los errores de uso de una orden remiten
    /// a su ayuda.
    @Test func loQueSeQuisoEscribir() {
        #expect(resultado("acordee", "Do").error.contains("¿Querías decir «acorde»?\n"))
        #expect(resultado("identifcar", "Do", "Mi").error.contains("«identificar»"))
        #expect(resultado("tonal", "Do", "mayor").error.contains("«tonalidad»"))
        #expect(
            resultado("chrod", "G7", "--ingles").error
                == "armonia: unknown command: \"chrod\"\nDid you mean \"chord\"?\nTry \"armonia help\".\n")
        #expect(resultado("acordee", "--idioma", "eu").error.contains("«acorde» esan nahi zenuen?"))
        // Lejos de todas, no se propone nada.
        #expect(resultado("foo").error == "armonia: orden desconocida: «foo»\nPrueba «armonia ayuda».\n")
        // Las opciones, entre las de la orden.
        #expect(
            resultado("digitaciones", "Sol7", "--limte", "3").error
                == "armonia: opción desconocida: «--limte»\n¿Querías decir «--limite»?\nPrueba «armonia ayuda digitaciones».\n"
        )
        #expect(resultado("arpegio", "Do7", "--patorn", "alberti").error.contains("«--patron»"))
        #expect(resultado("acorde", "Do", "--jsno").error.contains("«--json»"))
        #expect(LineaDeComandos.propuesta(para: "acorde", entre: ["acorde", "arpegio"]) == nil)
        #expect(LineaDeComandos.distancia("acrode", "acorde") == 1)
        #expect(LineaDeComandos.distancia("", "abc") == 3)
        // Con el nombre que se escribió: «chord», no «acorde».
        #expect(resultado("chord", "--ingles").error.hasSuffix("Try \"armonia help chord\".\n"))
    }

    /// Los errores de lectura empiezan por «armonia:» como los de uso; un guion con una letra es una opción, salvo
    /// que sea un intervalo descendente.
    @Test func mensajesComoLosDemas() {
        let lectura = resultado("acorde", "Xx")
        #expect(lectura.codigo == 1)
        #expect(lectura.error.hasPrefix("armonia: No se puede leer «Xx»"))
        let corta = resultado("acorde", "Do", "-o", "x")
        #expect(corta.codigo == 2)
        #expect(corta.error.hasPrefix("armonia: opción desconocida: «-o»\n"))
        #expect(resultado("tonalidad", "Do", "mayor", "--foo").error.hasPrefix("armonia: opción desconocida: «--foo»"))
        #expect(resultado("intervalo", "Do", "-x").codigo == 2)
        #expect(salida("transponer -m3 Do Fa") == "La Re\n")
        #expect(Argumentos.pareceUnaOpcion("-o"))
        #expect(Argumentos.pareceUnaOpcion("--limite"))
        #expect(!Argumentos.pareceUnaOpcion("-P5"))
        #expect(!Argumentos.pareceUnaOpcion("-2M"))
        #expect(!Argumentos.pareceUnaOpcion("-"))
    }

    /// Una orden que da un fichero binario no lo escribe en la terminal: lo dice, en el idioma de los textos.
    @Test func salidaBinariaEnLaTerminal() {
        let enLaTerminal = LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4"], salidaEsTerminal: true)
        #expect(enLaTerminal.codigo == 2)
        #expect(enLaTerminal.datos == nil)
        #expect(
            enLaTerminal.error
                == "armonia: la salida es un fichero binario (MIDI, PDF o PNG); guárdala con > fichero\n")
        let ingles = LineaDeComandos.ejecutar(["midi", "melodia", "C4:4", "--ingles"], salidaEsTerminal: true)
        #expect(ingles.error.hasPrefix("armonia: the output is a binary file"))
        #expect(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4"]).datos != nil)
        // El texto sí sale.
        #expect(LineaDeComandos.ejecutar(["acorde", "Do"], salidaEsTerminal: true).codigo == 0)
    }

    /// `-` toma las palabras de la entrada estándar; sin argumentos y sin la terminal, también.
    @Test func entradaEstandar() {
        func con(_ entrada: String, _ argumentos: [String], terminal: Bool = false) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(argumentos, entrada: { entrada }, entradaEsTerminal: terminal)
        }
        let identificar = salida("identificar Do Mi Sol")
        #expect(con("Do Mi Sol\n", ["identificar"]).salida == identificar)
        #expect(con("Do\nMi\n  Sol", ["identificar", "-"]).salida == identificar)
        #expect(con("Do Mi Sol", ["identificar", "-"], terminal: true).salida == identificar)
        // En lugar de `-`, antes de las opciones como --en, que se lleva todo lo que lo sigue.
        // Con opciones detrás hace falta `-`: no se sabe si una palabra es un argumento o el valor de una opción.
        #expect(con("Do Lam", ["analizar", "--en", "Do", "mayor"]).codigo == 2)
        #expect(
            con("Do Lam", ["analizar", "-", "--en", "Do", "mayor"]).salida == salida("analizar Do Lam --en Do mayor"))
        #expect(con("Do Mi Sol", ["identificar", "--json"]).salida == salida("identificar Do Mi Sol --json"))
        // Con la terminal, o con argumentos, no se lee nada.
        #expect(con("Do Mi Sol", ["identificar"], terminal: true).codigo == 2)
        #expect(con("Fa La Do", ["identificar", "Do", "Mi", "Sol"]).salida == identificar)
        // Las órdenes que no leen nada no esperan a la entrada.
        let leida = LockIsolatedFlag()
        let entrada = {
            leida.marcar()
            return ""
        }
        _ = LineaDeComandos.ejecutar(["motores"], entrada: entrada, entradaEsTerminal: false)
        #expect(!leida.marcada)
        // Una entrada vacía es como no escribir nada.
        #expect(con("", ["identificar"]).codigo == 2)
    }

    @Test func arpegioEnJSON() throws {
        let arpegios = try #require(try json("arpegio Do7 Lam --patron alberti") as? [[String: Any]])
        #expect(arpegios.count == 2)
        let do7 = arpegios[0]
        #expect(do7["acorde"] as? String == "Do7")
        #expect(do7["recorrido"] as? String == "bajo de Alberti")
        #expect(do7["midi"] as? [Int] == [60, 70, 64, 70])
        #expect((do7["notas"] as? [String])?.first == "Do₄")
        #expect((do7["escalas"] as? [String])?.contains("Do mixolidio") == true)
        let grados = try #require(try json("arpegio Do --grados 1-5-3-8") as? [[String: Any]])
        #expect(grados[0]["recorrido"] as? String == "1-5-3-8")
        #expect(LineaDeComandos.ejecutar(["arpegio", "Do7", "--patron", "foo", "--json"]).codigo == 2)
    }

    @Test func intervaloEnJSON() throws {
        let decima = try #require(try json("intervalo Do4 Mi5") as? [String: Any])
        #expect(decima["semitonos"] as? Int == 16)
        #expect(decima["numero"] as? Int == 10)
        #expect(decima["abreviatura"] as? String == "10M")
        #expect(decima["descendente"] as? Bool == false)
        #expect(LineaDeComandos.ejecutar(["intervalo", "Do", "--json"]).codigo == 2)
    }

    @Test func tonalidadEnJSON() throws {
        let mib = try #require(try json("tonalidad Mib mayor") as? [String: Any])
        #expect(mib["nombre"] as? String == "Mi♭ mayor")
        #expect(mib["modo"] as? String == "mayor")
        #expect(mib["armadura"] as? Int == -3)
        #expect(mib["alteraciones"] as? [String] == ["Si♭", "Mi♭", "La♭"])
        #expect(mib["relativa"] as? String == "Do menor")
        #expect((mib["clases"] as? [Int])?.first == 3)
        let acordes = try #require(mib["acordes"] as? [[String: String]])
        #expect(acordes.count == 7)
        #expect(acordes[4] == ["grado": "V7", "cifrado": "Si♭7"])
        // El modo no se traduce.
        let menor = try #require(try json("tonalidad A minor --ingles") as? [String: Any])
        #expect(menor["modo"] as? String == "menor")
        #expect(menor["nombre"] as? String == "A minor")
    }

    @Test func digitacionesEnJSON() throws {
        let acordes = try #require(try json("digitaciones Do Sol7 --limite 2") as? [[String: Any]])
        #expect(acordes.count == 2)
        #expect(acordes[0]["instrumento"] as? String == "guitarra")
        #expect(acordes[0]["capo"] as? Int == 0)
        let formas = try #require(acordes[0]["formas"] as? [[String: Any]])
        #expect(formas.count == 2)
        #expect(formas[0]["tablatura"] as? String == "x32010")
        #expect(formas[0]["trastes"] as? [Any?] != nil)
        let trastes = try #require(formas[0]["trastes"] as? [Any])
        #expect(trastes.first is NSNull)
        #expect(trastes.dropFirst().compactMap { $0 as? Int } == [3, 2, 0, 1, 0])
        #expect(formas[0]["notas"] as? [String] == ["Do", "Mi", "Sol", "Do", "Mi"])
        // Las mismas formas que el texto.
        #expect(salida("digitaciones Do --limite 2").contains("x32010"))
        let ukelele = try #require(
            try json("digitaciones C --instrument ukulele --capo 2 --ingles") as? [[String: Any]])
        #expect(ukelele[0]["capo"] as? Int == 2)
        #expect(ukelele[0]["instrumento"] as? String == "ukulele")
        #expect(LineaDeComandos.ejecutar(["digitaciones", "Do", "--limite", "0", "--json"]).codigo == 2)
    }
}

/// Una marca que se puede poner desde un cierre que no es `Sendable`.
private final class LockIsolatedFlag: @unchecked Sendable {
    private(set) var marcada = false
    func marcar() { marcada = true }
}
