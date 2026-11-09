import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

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
        #expect(sol7["estadisticas"] == nil)
        // Con `--estadisticas`, las mismas claves y además `estadisticas`.
        let conMedidas = try #require(try json("acorde Sol7/Si --estadisticas") as? [[String: Any]])
        #expect(Set(conMedidas[0].keys) == Set(sol7.keys).union(["estadisticas"]))
        let medidas = try #require(conMedidas[0]["estadisticas"] as? [String: Any])
        #expect(medidas["numeroDeForte"] as? String == "4-27")
        #expect(medidas["brilloPorQuintas"] as? Double == 0.75)
        #expect(medidas["ambito"] == nil)
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
        // Sin opciones, solo esas claves (y sus referencias, Powers y Levine).
        #expect(Set(dorico.keys) == ["nombre", "notas", "clases", "modo", "acordes", "referencias"])
    }

    /// Una escala de otra tradición lleva sus referencias, con su clave, su cita y la referencia completa.
    @Test func referenciasEnJSON() throws {
        let bayati = try #require(try json("escala Re bayati") as? [String: Any])
        let referencias = try #require(bayati["referencias"] as? [[String: String]])
        #expect(referencias.map { $0["clave"] } == ["maqamWorld", "touma1996", "farraj2019", "rechberger2008"])
        #expect(referencias[1]["cita"] == "Touma 1996")
        #expect(referencias[1]["descripcion"]?.hasPrefix("Touma, Habib Hassan (1996). The Music of the Arabs.") == true)
        #expect(referencias[0]["url"] == "https://www.maqamworld.com")
        #expect(resultado("escala", "Re", "bayati", "--bibtex", "--json").error.contains("--bibtex"))
    }

    /// Las opciones del texto valen también con `--json`, y cada una añade su clave.
    @Test func escalaConOpcionesEnJSON() throws {
        let orden =
            "escala Do mayor --acordes --secuencia terceras --dedos --modos --simetria --tetracordos --vecinas"
            + " --comparar Do lidio"
        let mayor = try #require(try json(orden) as? [String: Any])
        #expect(mayor["notas"] as? [String] == ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"])
        #expect((mayor["acordesQueCaben"] as? [[String: Any]])?.count == 7)
        let secuencia = try #require(mayor["secuencia"] as? [String: Any])
        #expect((secuencia["midi"] as? [Int])?.prefix(2) == [60, 64])
        let piano = try #require(mayor["piano"] as? [[String: Any]])
        #expect(piano.count == 2)
        #expect((piano[0]["dedos"] as? [Int])?.count == (piano[0]["notas"] as? [String])?.count)
        #expect((mayor["modosParalelos"] as? [[String: String]])?.count == 7)
        #expect((mayor["modosRelativos"] as? [String])?.isEmpty == false)
        #expect((mayor["simetria"] as? [String: Any])?["resumen"] is String)
        let tetracordos = try #require(mayor["tetracordos"] as? [[[String: Any]]])
        #expect(tetracordos.count == 2)
        #expect(tetracordos[0][0]["notas"] as? [String] == ["Do", "Re", "Mi", "Fa"])
        #expect(tetracordos[0][1]["separacion"] as? String == "2ª mayor")
        #expect(mayor["ajnas"] == nil)
        #expect(mayor["mela"] == nil)
        let mecakalyani = try #require(try json("escala Do mecakalyani") as? [String: Any])
        #expect(mecakalyani["mela"] as? Int == 65)
        #expect(mecakalyani["cakra"] as? String == "Rudra")
        #expect(mecakalyani["mnemonico"] as? String == "Rudra-mā")
        #expect(mecakalyani["solfa"] as? [String] == ["sa", "ri", "gu", "mi", "pa", "dhi", "nu"])
        let bayati = try #require(try json("escala Re bayati --tetracordos") as? [String: Any])
        let ajnas = try #require(bayati["ajnas"] as? [[String: Any]])
        #expect(ajnas.map { $0["nombre"] as? String } == ["jins Bayātī", "jins Nahāwand"])
        #expect(ajnas[1]["notas"] as? [String] == ["Sol", "La", "Si♭", "Do", "Re"])
        #expect(mayor["vecinas"] is [[String: String]])
        #expect((mayor["comparacion"] as? [String: Any])?["comunes"] is String)
        let doce = try #require(try json("escala Do mayor --doce --acordes") as? [String: Any])
        #expect((doce["doceTonalidades"] as? [[String: String]])?.count == 12)
        #expect(doce["acordesEnLasDoceTonalidades"] is [String: Any])
        let pentatonica = try #require(try json("escala La pentatónica menor --estadisticas") as? [String: Any])
        let medidas = try #require(pentatonica["estadisticas"] as? [String: Any])
        #expect(medidas["numeroDeNotas"] as? Int == 5)
        #expect(medidas["cardinal"] as? String == "pentatónica")
        #expect(medidas["brilloPorQuintas"] as? Double == -1)
        #expect(medidas["pasos"] as? [Int] == [3, 2, 2, 3, 2])
        #expect(medidas["anhemitonica"] as? Bool == true)
        #expect(medidas["numeroDeForte"] as? String == "5-35")
        #expect(medidas["brillo"] == nil)
        let teoria = try #require(medidas["teoria"] as? [String: Any])
        #expect(teoria["propiedadDeMyhill"] as? Bool == true)
        #expect(teoria["generador"] as? Int == 5)
        #expect(teoria["propiedadDeRothenberg"] as? String == "estrictamente propia")
        #expect(teoria["analisisDeHanson"] as? String == "p⁴mn²s³")
        #expect(teoria["triadasPorGrados"] == nil)
        let escalera = try #require(
            (try json("escala Do mayor --escalera") as? [String: Any])?["escaleraDeBrillo"] as? [[String: Any]])
        let dePartida = try #require(escalera.firstIndex { $0["dePartida"] as? Bool == true })
        #expect(escalera[dePartida]["nombre"] as? String == "Do mayor")
        #expect(escalera[dePartida]["brilloPorQuintas"] as? Double == 2)
        #expect(escalera.first?["cambio"] == nil)
        // Lo mal escrito sigue siendo un error de uso.
        #expect(LineaDeComandos.ejecutar(["escala", "Do", "mayor", "--secuencia", "foo", "--json"]).codigo == 2)
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

    @Test func catalogosConNombreEnJSON() throws {
        let andaluza = try #require(try json("progresiones andaluza --en La") as? [[String: Any]])
        #expect(andaluza.count == 1)
        #expect(andaluza.first?["cifrado"] as? String == "i VII VI V")
        #expect(andaluza.first?["modo"] as? String == "menor")
        #expect(andaluza.first?["acordes"] as? [String] == ["Lam", "Sol", "Fa", "Mi"])

        let tristan = try #require(try json("acordes tristan --sobre Fa") as? [[String: Any]])
        #expect(tristan.first?["notas"] as? [String] == ["Fa", "Si", "Re♯", "Sol♯"])
        #expect(tristan.first?["cifrado"] == nil)
        let septima = try #require(try json("acordes séptima de dominante") as? [[String: Any]])
        #expect(septima.first?["cifrado"] as? String == "Do7")
        #expect(septima.first?["estadisticas"] == nil)
        let conMedidas = try #require(try json("acordes tristan --estadisticas") as? [[String: Any]])
        let medidas = try #require(conMedidas.first?["estadisticas"] as? [String: Any])
        #expect(medidas["cardinal"] as? String == "tétrada")
        #expect(medidas["ambito"] as? Int == 15)
        let resumen = try #require(try json("acordes --resumen") as? [String: Any])
        #expect(resumen["total"] as? Int == AcordeConNombre.catalogo.count)
        #expect((resumen["porNumeroDeNotas"] as? [[String: Any]])?.first?["nombre"] as? String == "2 (díada)")
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

extension LineaDeComandosTests {
    @Test func elCatalogoEnJSON() throws {
        let grupos = try #require(try json("escalas --tradicion japon") as? [[String: Any]])
        #expect(grupos.count == 1 && grupos[0]["titulo"] as? String == "Japón · escala")
        let escalas = try #require(grupos[0]["escalas"] as? [[String: Any]])
        #expect(escalas.count == 13)
        let hirajoshi = try #require(escalas.first { $0["nombre"] as? String == "Hirajōshi" })
        #expect(hirajoshi["clases"] as? [Int] == [0, 2, 3, 7, 8])
        #expect(hirajoshi["tradicion"] as? String == "japon" && hirajoshi["categoria"] as? String == "escala")
        #expect(hirajoshi["microtonal"] as? Bool == false && hirajoshi["fuente"] == nil)
        let ptolomeo = try #require(try json("escalas --fuente ptolomeo") as? [[String: Any]])
        let generos = try #require(ptolomeo.first?["escalas"] as? [[String: Any]])
        #expect(generos.allSatisfy { $0["fuente"] as? String == "ptolomeo" && $0["microtonal"] as? Bool == true })
        // Las habituales son de la tradición occidental; con --orden brillo, de la más brillante a la más oscura.
        let habituales = try #require(try json("escalas --uso jazz --orden brillo") as? [[String: Any]])
        let deJazz = try #require(habituales.first?["escalas"] as? [[String: Any]])
        #expect(deJazz.allSatisfy { $0["tradicion"] as? String == "occidental" })
        let brillos = deJazz.compactMap { $0["brilloPorQuintas"] as? Double }
        #expect(brillos == brillos.sorted(by: >))
        #expect(salida("escalas inventadísima --json") == "[]\n")
        for opcion in ["--mapa", "--comparar Do mayor, Do lidio", "--vecinas Re dórico"] {
            let mal = LineaDeComandos.ejecutar(("escalas " + opcion + " --json").split(separator: " ").map(String.init))
            #expect(mal.codigo == 2 && mal.error.contains("no da salida en JSON"), Comment(rawValue: opcion))
        }
    }

    @Test func laRearmonizacionEnJSON() throws {
        let datos = try #require(try json("rearmonizar Do Lam Rem7 Sol7 Do") as? [String: Any])
        #expect(datos["tonalidad"] as? String == "Do mayor")
        let propuestas = try #require(datos["propuestas"] as? [[String: Any]])
        let tritonal = try #require(propuestas.first { $0["recurso"] as? String == "sustitutoTritonal" })
        #expect(tritonal["posicion"] as? Int == 4 && tritonal["original"] as? String == "Sol7")
        #expect(tritonal["acordes"] as? [String] == ["Re♭7"])
        #expect((tritonal["descripcion"] as? String)?.contains("sustituto tritonal") == true)
        #expect(LineaDeComandos.ejecutar(["rearmonizar", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["rearmonizar", "Do", "--foo", "--json"]).codigo == 2)
    }

    @Test func laNeorriemannianaEnJSON() throws {
        let vecinos = try #require(try json("vecinos Sol7") as? [[String: Any]])
        #expect(vecinos.map { $0["acorde"] as? String } == ["Sol♯°7", "Solm7", "Mim7"])
        let movimiento = try #require((vecinos[0]["movimientos"] as? [[String: Any]])?.first)
        #expect(movimiento["desde"] as? String == "Sol" && movimiento["hasta"] as? String == "Sol♯")
        #expect(movimiento["semitonos"] as? Int == 1)
        #expect(try #require(try json("vecinos Domaj7 --ampliada") as? [[String: Any]]).count > 0)
        #expect(LineaDeComandos.ejecutar(["vecinos", "Do", "Fa", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["vecinos", "Do", "--voces", "5", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["vecinos", "Do", "--foo", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["vecinos", "Do7sus4", "--json"]).codigo == 2)

        let camino = try #require(try json("camino-parsimonioso Sol7 Rem7") as? [String: Any])
        #expect(camino["desde"] as? String == "Sol7")
        let pasos = try #require(camino["pasos"] as? [[String: Any]])
        #expect(pasos.last?["acorde"] as? String == "Rem7")
        #expect(LineaDeComandos.ejecutar(["camino-parsimonioso", "Sol7", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["camino-parsimonioso", "Sol7", "Do", "--json"]).codigo != 0)

        let minima = try #require(try json("conduccion-minima Sol7 Do") as? [String: Any])
        #expect(minima["semitonos"] as? Int == 4)
        #expect((minima["movimientos"] as? [[String: Any]])?.count == 4)
        #expect(LineaDeComandos.ejecutar(["conduccion-minima", "Sol7", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["conduccion-minima", "--json"]).codigo == 2)

        let secuencia = try #require(try json("plr Do PLR") as? [String: Any])
        #expect(secuencia["desde"] as? String == "Do" && secuencia["ciclo"] == nil)
        let transformaciones = try #require(secuencia["pasos"] as? [[String: Any]])
        #expect(transformaciones.map { $0["transformacion"] as? String } == ["P", "L", "R"])
        let ciclo = try #require(try json("plr ciclo hexatonico Do") as? [String: Any])
        #expect(ciclo["ciclo"] as? String == "hexatonico")
        #expect((ciclo["pasos"] as? [[String: Any]])?.count == 6)
        let corto = try #require(try json("plr camino Do Mibm") as? [String: Any])
        #expect((corto["pasos"] as? [[String: Any]])?.last?["acorde"] as? String == "Mi♭m")
        #expect(LineaDeComandos.ejecutar(["plr", "Do", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["plr", "Do7", "P", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["plr", "camino", "Do", "Do7", "--json"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["plr", "Do", "P", "--foo", "--json"]).codigo == 2)
    }

    @Test func lasPosicionesEnJSON() throws {
        let datos = try #require(try json("posiciones Sol mayor --caged") as? [String: Any])
        #expect(datos["escala"] as? String == "Sol mayor" && datos["instrumento"] as? String == "guitarra")
        let posiciones = try #require(datos["posiciones"] as? [[String: Any]])
        #expect(posiciones.map { $0["forma"] as? String } == ["G", "E", "D", "C", "A"])
        let primera = try #require((posiciones[0]["notas"] as? [[String: Any]])?.first)
        #expect(primera["cuerda"] as? Int == 6 && primera["traste"] as? Int == 0 && primera["nota"] as? String == "Mi₂")
        let conCapo = try #require(try json("posiciones La menor --instrumento bajo --capo 2") as? [String: Any])
        #expect(conCapo["capo"] as? Int == 2 && conCapo["instrumento"] as? String != "guitarra")
        #expect((conCapo["posiciones"] as? [[String: Any]])?.first?["forma"] == nil)
        for opcion in ["--arpegio", "--formas", "--secuencia terceras", "--bajando"] {
            let mal = LineaDeComandos.ejecutar(
                ("posiciones Sol mayor " + opcion + " --json").split(separator: " ").map(String.init))
            #expect(mal.codigo == 2 && mal.error.contains("no da salida en JSON"), Comment(rawValue: opcion))
        }
        #expect(LineaDeComandos.ejecutar(["posiciones", "--json"]).codigo == 2)
    }
}
