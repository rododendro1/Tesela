import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de la salida en JSON (`--json`): que se lee como JSON, que las claves no cambian con el idioma y que
// los errores siguen yendo en texto.

extension LineaDeComandosTests {
    /// La salida de una orden con `--json`, leída como JSON.
    func json(_ orden: String, sourceLocation: SourceLocation = #_sourceLocation) throws -> Any {
        let texto = salida(orden + " --json", sourceLocation: sourceLocation)
        return try JSONSerialization.jsonObject(with: Data(texto.utf8))
    }

    @Test func acordeEnJSON() throws {
        let acordes = try #require(try json("acorde Sol7/Si Do") as? [[String: Any]])
        #expect(acordes.count == 2)
        let sol7 = acordes[0]
        #expect(sol7["cifrado"] as? String == "Sol7/Si")
        #expect(sol7["nombre"] as? String == "séptima de dominante")
        #expect(sol7["fundamental"] as? String == "Sol")
        #expect(sol7["bajo"] as? String == "Si")
        #expect(sol7["inversion"] as? Int == 1)
        #expect(sol7["notas"] as? [String] == ["Sol", "Si", "Re", "Fa"])
        #expect(sol7["clases"] as? [Int] == [7, 11, 2, 5])
        let componentes = try #require(sol7["componentes"] as? [[String: String]])
        #expect(componentes.first == ["nota": "Sol", "papel": "fundamental"])
        // Un bajo que no es del acorde no tiene inversión.
        let ajeno = try #require(try json("acorde Do/Re") as? [[String: Any]])
        #expect(ajeno[0]["inversion"] is NSNull || ajeno[0]["inversion"] == nil)
    }

    /// Las claves son las mismas en cualquier idioma; los nombres van en la notación elegida.
    @Test func lasClavesNoCambianConElIdioma() throws {
        let espanol = try #require(try json("acorde Sol7") as? [[String: Any]])
        let ingles = try #require(try json("acorde Sol7 --ingles") as? [[String: Any]])
        let aleman = try #require(try json("acorde Sol7 --idioma de") as? [[String: Any]])
        #expect(Set(espanol[0].keys) == Set(ingles[0].keys))
        #expect(Set(espanol[0].keys) == Set(aleman[0].keys))
        #expect(ingles[0]["cifrado"] as? String == "G7")
        #expect(ingles[0]["clases"] as? [Int] == espanol[0]["clases"] as? [Int])
    }

    @Test func identificarEnJSON() throws {
        let candidatos = try #require(try json("identificar Do Mi Sol Sib") as? [[String: Any]])
        #expect(candidatos.first?["cifrado"] as? String == "Do7")
        #expect(candidatos.count <= 5)
        #expect(candidatos.allSatisfy { $0["omitidas"] is [String] })
    }

    @Test func escalaEnJSON() throws {
        let dorico = try #require(try json("escala Re dórico") as? [String: Any])
        #expect(dorico["notas"] as? [String] == ["Re", "Mi", "Fa", "Sol", "La", "Si", "Do"])
        #expect(dorico["clases"] as? [Int] == [2, 4, 5, 7, 9, 11, 0])
        let acordes = try #require(dorico["acordes"] as? [[String: String]])
        #expect(acordes.count == 7)
        #expect(acordes.first?["cifrado"] == "Rem7")
    }

    @Test func analizarEnJSON() throws {
        let analisis = try #require(try json("analizar Do Fa Sol7 Do") as? [String: Any])
        #expect((analisis["titulo"] as? String)?.isEmpty == false)
        let tramos = try #require(analisis["tramos"] as? [[String: Any]])
        let filas = try #require(tramos.first?["acordes"] as? [[String: String]])
        #expect(filas.map { $0["cifrado"] } == ["Do", "Fa", "Sol7", "Do"])
        #expect(filas.allSatisfy { $0["grado"]?.isEmpty == false })
        #expect(analisis["cadencias"] is [String])
        // Con la tonalidad dada, también.
        #expect(try json("analizar Lam Rem Mi7 Lam --en La menor") is [String: Any])
    }

    @Test func conjuntoYSerieEnJSON() throws {
        let mayor = try #require(try json("conjunto 0 4 7") as? [String: Any])
        #expect(mayor["forte"] as? String == "3-11")
        #expect(mayor["formaPrima"] as? [Int] == [0, 3, 7])
        #expect(mayor["vectorIntervalico"] as? [Int] == [0, 0, 1, 1, 1, 0])

        let berg = try #require(try json("serie 5 4 0 9 7 2 8 1 3 6 t e") as? [String: Any])
        #expect(berg["clases"] as? [Int] == [5, 4, 0, 9, 7, 2, 8, 1, 3, 6, 10, 11])
        #expect(berg["deTodosLosIntervalos"] as? Bool == true)
        #expect(berg["hexacordos"] as? [String] == ["6-32", "6-32"])
        #expect(berg["formasDistintas"] as? Int == 24)
        let matriz = try #require(berg["matriz"] as? [[Int]])
        #expect(matriz.count == 12 && matriz.allSatisfy { $0.count == 12 })
    }

    /// Los errores siguen en texto, en la salida de errores, con su código.
    @Test func erroresConJSON() {
        let sinJSON = LineaDeComandos.ejecutar(["tonnetz", "Do", "Mi", "Sol", "--json"])
        #expect(sinJSON.codigo == 2)
        #expect(sinJSON.salida.isEmpty)
        #expect(sinJSON.error.contains("«tonnetz» no da salida en JSON"))
        #expect(LineaDeComandos.ejecutar(["acorde", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["acorde", "Sol7", "--disposiciones", "--json"]).codigo == 2)
        let ilegible = LineaDeComandos.ejecutar(["acorde", "Xyz", "--json"])
        #expect(ilegible.codigo == 1)
        #expect(ilegible.salida.isEmpty)
        #expect(LineaDeComandos.ejecutar(["serie", "0", "1", "2", "--json"]).codigo == 1)
        #expect(salida("ayuda").contains("--json"))
    }
}
