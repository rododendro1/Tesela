import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas del índice de la ayuda, los códigos de las faltas, el JSON de la armonización, el idioma del entorno y
// la sesión.

extension LineaDeComandosTests {
    /// `armonia ayuda` es un índice corto, por grupos; `ayuda --todo`, la ayuda completa.
    @Test func indiceDeLaAyuda() {
        let indice = salida("ayuda")
        #expect(indice == salida(""))
        #expect(indice.hasPrefix("armonia: teoría musical"))
        #expect(indice.contains("\nConsultas:\n  acorde "))
        #expect(indice.contains("armonia ayuda --todo"))
        #expect(!indice.contains("--patron alberti"))
        #expect(
            indice.split(separator: "\n").count < LineaDeComandos.ayuda(en: .espanolCompacto).split(separator: "\n")
                .count / 2)
        for linea in indice.split(separator: "\n") where linea.hasPrefix("  ") {
            #expect(linea.count <= LineaDeComandos.anchoDelIndice, Comment(rawValue: String(linea)))
        }
        #expect(salida("ayuda --todo") == LineaDeComandos.ayuda(en: .espanolCompacto) + "\n")
        #expect(salida("help --all --ingles") == LineaDeComandos.ayuda(en: .inglesASCII) + "\n")
        // Una línea por orden, en todos los idiomas, y un título por grupo.
        for idioma in Idioma.allCases {
            let texto = LineaDeComandos.indiceDeAyuda(en: idioma)
            let titulos = TextosDeCLI.en(idioma: idioma, \.gruposDeLaAyuda)
            #expect(titulos.count == LineaDeComandos.gruposDeOrdenes.count)
            for titulo in titulos { #expect(texto.contains("\n" + titulo + ":\n"), Comment(rawValue: titulo)) }
        }
        #expect(salida("ayuda --ingles").contains("\n  chord "))
    }

    /// El resumen de una descripción, sin paréntesis ni opciones.
    @Test func resumenDeUnaOrden() {
        #expect(
            LineaDeComandos.resumen("notas del arpegio y escalas del\nacorde (--patron ascendente)")
                == "notas del arpegio y escalas del acorde")
        #expect(LineaDeComandos.resumen("la escala en un reloj (SVG): el círculo") == "la escala en un reloj")
        #expect(LineaDeComandos.resumen("formas de tocar\nopciones: --instrumento") == "formas de tocar")
        #expect(LineaDeComandos.resumen("en GUIDO (.gmn), para verlo") == "en GUIDO, para verlo")
        #expect(LineaDeComandos.lineasDelIndice("conduccion-parsimoniosa", "de un acorde a otro").count == 1)
        #expect(
            LineaDeComandos.lineasDelIndice("una-orden-con-un-nombre-largo", "algo") == [
                "  una-orden-con-un-nombre-largo", String(repeating: " ", count: 27) + "algo",
            ])
    }

    /// `revisar` y `contrapunto` salen con 3 si hay faltas, y con 0 si no.
    @Test func codigoDeLasFaltas() {
        let mal = resultado("revisar", "Do3", "Mi4", "Sol4", "Do5,", "Re3", "Fa4", "La4", "Re5")
        #expect(mal.codigo == 3)
        #expect(mal.salida.contains("Quintas paralelas"))
        #expect(mal.error.isEmpty)
        #expect(resultado("revisar", "Do3", "Mi4", "Sol4", "Do5,", "Sol2", "Re4", "Sol4", "Si4").codigo == 0)
        let contrapunto = resultado("contrapunto", "Re4", "Fa4", "Mi4", "Re4", "/", "Re5", "Fa5", "Mi5", "Re5")
        #expect(contrapunto.codigo == 3)
        #expect(contrapunto.salida.contains("Octavas paralelas"))
        let bueno = "Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4 / La4 La4 Sol4 La4 Si4 Do5 Do5 Si4 Re5 Do#5 Re5"
        #expect(LineaDeComandos.ejecutar(["contrapunto"] + bueno.split(separator: " ").map(String.init)).codigo == 0)
    }

    @Test func revisarYContrapuntoEnJSON() throws {
        let mal = LineaDeComandos.ejecutar(
            "revisar Do3 Mi4 Sol4 Do5, Re3 Fa4 La4 Re5 --json".split(separator: " ").map(String.init))
        #expect(mal.codigo == 3)
        let revision = try #require(try JSONSerialization.jsonObject(with: Data(mal.salida.utf8)) as? [String: Any])
        let faltas = try #require(revision["faltas"] as? [[String: Any]])
        #expect(faltas.first?["tipo"] as? String == "quintasParalelas")
        #expect(faltas.first?["acorde"] as? Int == 1)
        #expect(faltas.first?["voces"] as? [Int] == [1, 3])
        #expect((revision["acordes"] as? [[String: Any]])?.count == 2)
        // Las claves no cambian con el idioma; el texto, sí.
        let ingles = LineaDeComandos.ejecutar(
            "revisar C3 E4 G4 C5, D3 F4 A4 D5 --json --ingles".split(separator: " ").map(String.init))
        let enIngles = try #require(try JSONSerialization.jsonObject(with: Data(ingles.salida.utf8)) as? [String: Any])
        let primera = try #require((enIngles["faltas"] as? [[String: Any]])?.first)
        #expect(primera["tipo"] as? String == "quintasParalelas")
        #expect(primera["texto"] as? String != faltas.first?["texto"] as? String)

        let contrapunto = LineaDeComandos.ejecutar(
            "contrapunto Re4 Fa4 Mi4 Re4 / Re5 Fa5 Mi5 Re5 --json".split(separator: " ").map(String.init))
        #expect(contrapunto.codigo == 3)
        let ejercicio = try #require(
            try JSONSerialization.jsonObject(with: Data(contrapunto.salida.utf8)) as? [String: Any])
        #expect(ejercicio["especie"] as? Int == 1)
        #expect(ejercicio["encima"] as? Bool == true)
        let suyas = try #require(ejercicio["faltas"] as? [[String: Any]])
        #expect(suyas.first?["tipo"] as? String == "octavasParalelas")
        #expect(suyas.first?["compases"] as? [Int] == [1, 2])
        #expect(LineaDeComandos.ejecutar(["contrapunto", "Re4", "--json"]).codigo == 2)
    }

    @Test func armonizacionEnJSON() throws {
        let armonizado = try #require(try json("armonizar Mi4 Re4 Do4") as? [String: Any])
        #expect(armonizado["titulo"] as? String == "Do mayor")
        #expect((armonizado["propuestas"] as? [String])?.count == 3)
        let coral = try #require(armonizado["coral"] as? [[String: Any]])
        #expect(coral.count == 3)
        #expect((coral.first?["voces"] as? [String])?.count == 4)
        let sinOctavas = try #require(try json("armonizar Mi Re Do") as? [String: Any])
        #expect(sinOctavas["coral"] == nil)

        let realizado = try #require(try json("realizar Do Fa Sol7 Do") as? [String: Any])
        let filas = try #require(realizado["coral"] as? [[String: Any]])
        #expect(filas.map { $0["cifrado"] as? String } == ["Do", "Fa", "Sol7", "Do"])
        #expect(filas.map { $0["grado"] as? String } == ["I", "IV", "V7", "I"])

        let transportado = try #require(try json("transponer 2M Do Fa Sol7") as? [String: Any])
        #expect(transportado["texto"] as? String == "Re Sol La7")
        #expect(transportado["contenido"] as? String == "acordes")
        #expect((transportado["intervalo"] as? [String: Any])?["semitonos"] as? Int == 2)
        let melodia = try #require(try json("transponer Re Do4 Mi4 Sol4") as? [String: Any])
        #expect(melodia["contenido"] as? String == "notas")
        #expect(LineaDeComandos.ejecutar(["transponer", "2M", "--json"]).codigo == 2)
    }

    /// En la terminal, el JSON va con sangría; fuera, en una sola línea.
    @Test func jsonEnUnaLinea() {
        let fuera = LineaDeComandos.ejecutar(["acorde", "Sol7", "--json"])
        #expect(fuera.salida.split(separator: "\n").count == 1)
        let enLaTerminal = LineaDeComandos.ejecutar(["acorde", "Sol7", "--json"], salidaEsTerminal: true)
        #expect(enLaTerminal.salida.split(separator: "\n").count > 1)
        #expect(
            (try? JSONSerialization.jsonObject(with: Data(fuera.salida.utf8))) as? NSArray
                == (try? JSONSerialization.jsonObject(with: Data(enLaTerminal.salida.utf8))) as? NSArray)
    }

    /// `ARMONIA_IDIOMA` da el idioma; `--idioma` y `--ingles` la anulan; `sistema` toma el de `LANG`.
    @Test func idiomaDelEntorno() {
        func acorde(_ entorno: [String: String], _ mas: [String] = []) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(["acorde", "Sol7"] + mas, entorno: entorno)
        }
        #expect(acorde(["ARMONIA_IDIOMA": "eu"]).salida.contains("dominanteko"))
        #expect(acorde(["ARMONIA_IDIOMA": "euskara"]).salida.contains("dominanteko"))
        #expect(acorde(["ARMONIA_IDIOMA": "eu"], ["--idioma", "fr"]).salida.contains("septième"))
        #expect(acorde(["ARMONIA_IDIOMA": "eu"], ["--ingles"]).salida.hasPrefix("G7"))
        #expect(acorde(["ARMONIA_IDIOMA": "sistema", "LANG": "fr_FR.UTF-8"]).salida.contains("septième"))
        // LC_ALL va antes que LANG.
        let aleman = acorde(["ARMONIA_IDIOMA": "system", "LC_ALL": "de_DE.UTF-8", "LANG": "fr_FR"]).salida
        #expect(aleman == acorde(["ARMONIA_IDIOMA": "de"]).salida)
        #expect(acorde(["ARMONIA_IDIOMA": "sistema", "LANG": "C"]).salida == acorde([:]).salida)
        #expect(acorde(["ARMONIA_IDIOMA": ""]).salida == acorde([:]).salida)
        // Sin `sistema`, LANG no cuenta.
        #expect(acorde(["LANG": "fr_FR.UTF-8"]).salida == acorde([:]).salida)
        let mal = acorde(["ARMONIA_IDIOMA": "xx"])
        #expect(mal.codigo == 2)
        #expect(mal.error.contains("ARMONIA_IDIOMA=xx"))
        #expect(LineaDeComandos.ejecutar([], entorno: ["ARMONIA_IDIOMA": "en"]).salida.contains("Lookups:"))
    }

    /// La sesión: una orden por línea, hasta `salir` o el final de la entrada.
    @Test func sesion() {
        var lineas = [
            "acorde Sol7", "", "  armonia intervalo Do Mi", "escala \"Re dórico\"", "midi melodia Do4:4",
            "acorde Xyz", "salir", "acorde Re",
        ][...]
        var escritos: [ResultadoDeOrden] = []
        LineaDeComandos.sesion(leerLinea: { lineas.popFirst() }, escribir: { escritos.append($0) })
        #expect(escritos.count == 6)
        #expect(escritos[0].salida.hasPrefix("armonia \(LineaDeComandos.version)."))
        #expect(escritos[1].salida.hasPrefix("Sol7: séptima de dominante"))
        #expect(escritos[2].salida.hasPrefix("3ª mayor"))
        #expect(escritos[3].salida.hasPrefix("Re dórico"))
        // Un fichero binario no se escribe en la terminal.
        #expect(escritos[4].codigo == 2 && escritos[4].datos == nil)
        #expect(escritos[5].codigo == 1)
        #expect(lineas.first == "acorde Re")

        var enIngles = ["chord G7"][...]
        var suyos: [ResultadoDeOrden] = []
        LineaDeComandos.sesion(
            entorno: ["ARMONIA_IDIOMA": "en"], leerLinea: { enIngles.popFirst() }, escribir: { suyos.append($0) })
        #expect(suyos.count == 2)
        #expect(suyos[0].salida.contains("Type one command per line"))
        #expect(suyos[1].salida.hasPrefix("G7"))

        var ninguna = ["acorde Do"][...]
        var error: [ResultadoDeOrden] = []
        LineaDeComandos.sesion(
            entorno: ["ARMONIA_IDIOMA": "xx"], leerLinea: { ninguna.popFirst() }, escribir: { error.append($0) })
        #expect(error.count == 1 && error[0].codigo == 2)
    }

    @Test func palabrasDeUnaLinea() {
        #expect(LineaDeComandos.palabras(deLaLinea: "  escala  Re   dórico ") == ["escala", "Re", "dórico"])
        #expect(
            LineaDeComandos.palabras(deLaLinea: "escala \"Re dórico\" --acordes") == [
                "escala", "Re dórico", "--acordes",
            ])
        #expect(LineaDeComandos.palabras(deLaLinea: "a 'b c'd \"\"") == ["a", "b cd", ""])
        #expect(LineaDeComandos.palabras(deLaLinea: "") == [])
    }
}
