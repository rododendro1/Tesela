import XCTest
@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria
@testable import ArmoniaPartitura

final class MEITests: XCTestCase {
    private func leer(_ mei: String, file: StaticString = #filePath, line: UInt = #line) -> ElementoXML {
        guard let raiz = ElementoXML.leer(mei) else {
            XCTFail("MEI mal formado", file: file, line: line)
            return ElementoXML(nombre: "", atributos: [:])
        }
        XCTAssertEqual(raiz.nombre, "mei", file: file, line: line)
        XCTAssertEqual(raiz.atributos["meiversion"], "5.0", file: file, line: line)
        XCTAssertEqual(raiz.atributos["xmlns"], "http://www.music-encoding.org/ns/mei", file: file, line: line)
        return raiz
    }

    /// La altura que suena en un `<note>`: la alteración escrita o, si no hay, la que suena sin escribirse.
    private func altura(_ nota: ElementoXML) -> Altura? {
        guard let paso = nota.atributos["pname"], let octava = nota.atributos["oct"].flatMap({ Int($0) }),
              let indice = ["c", "d", "e", "f", "g", "a", "b"].firstIndex(of: paso) else { return nil }
        let valores = ["tf": -3, "ff": -2, "f": -1, "n": 0, "s": 1, "x": 2, "ts": 3]
        let alteracion = (nota.atributos["accid"] ?? nota.atributos["accid.ges"]).flatMap { valores[$0] } ?? 0
        return Altura(Nota(NotaNatural(rawValue: indice)!, Alteracion(alteracion)), octava: octava)
    }

    /// Lo que dura lo que hay dentro de un elemento, contando puntillos y grupos irregulares.
    private func duracion(_ elemento: ElementoXML, factor: Duracion = Duracion(1)) -> Duracion {
        elemento.hijos.reduce(Duracion.cero) { total, hijo in
            switch hijo.nombre {
            case "note", "chord", "rest":
                guard let dur = hijo.atributos["dur"] else { return total }
                let figura = dur == "breve" ? Duracion(2) : Duracion(1, Int(dur)!)
                let puntillos = Int(hijo.atributos["dots"] ?? "0")!
                let conPuntillos = figura * 2 - figura * Duracion(1, 1 << puntillos)
                return total + conPuntillos * factor
            case "tuplet":
                let reales = Int(hijo.atributos["num"]!)!
                let normales = Int(hijo.atributos["numbase"]!)!
                return total + duracion(hijo, factor: factor * Duracion(normales, reales))
            case "beam":
                return total + duracion(hijo, factor: factor)
            default:
                return total
            }
        }
    }

    /// Las notas que se oyen, en orden (las de un acorde, de grave a agudo como se escribieron).
    private func notas(_ raiz: ElementoXML) -> [ElementoXML] { raiz.buscar("note") }

    func testMelodia() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2. Sol4:4 -:2.", compas: "3/4")
        // Sin Si ni Si♭, Do mayor y Fa mayor empatan al estimar la tonalidad: se da.
        let raiz = leer(voz.mei(tonalidad: Tonalidad(.do), titulo: "Escala"))
        XCTAssertEqual(raiz.buscar("title").first?.texto, "Escala")
        let definicion = try XCTUnwrap(raiz.buscar("scoreDef").first)
        XCTAssertEqual(definicion.atributos["meter.count"], "3")
        XCTAssertEqual(definicion.atributos["meter.unit"], "4")
        XCTAssertEqual(definicion.atributos["keysig"], "0")
        XCTAssertEqual(raiz.buscar("staffDef").first?.atributos["clef.shape"], "G")
        XCTAssertEqual(raiz.buscar("label").first?.texto, "Voz")
        XCTAssertEqual(notas(raiz).compactMap(altura), ["Do4", "Re4", "Mi4", "Fa4", "Fa4", "Sol4"])
        XCTAssertEqual(notas(raiz).map { $0.atributos["dur"] }, ["4", "8", "8", "4", "2", "4"])
        XCTAssertEqual(raiz.buscar("staffDef").first?.atributos["ppq"], "2")
        XCTAssertEqual(notas(raiz).map { $0.atributos["dur.ppq"] }, ["2", "1", "1", "2", "4", "2"])
        // Las corcheas, unidas; el silencio de un compás entero es `<mRest>`.
        XCTAssertEqual(raiz.buscar("beam").first?.todos("note").count, 2)
        XCTAssertEqual(raiz.buscar("mRest").count, 1)
        let compases = raiz.buscar("measure")
        XCTAssertEqual(compases.map { $0.atributos["n"] }, ["1", "2", "3"])
        XCTAssertEqual(compases.last?.atributos["right"], "end")
        for compas in compases.dropLast() {
            XCTAssertEqual(duracion(try XCTUnwrap(compas.buscar("layer").first)), Duracion(3, 4))
        }
        // Los identificadores no se repiten.
        let ids = raiz.buscar("note").compactMap { $0.atributos["xml:id"] }
        XCTAssertEqual(Set(ids).count, ids.count)
    }

    func testAlteracionesComoEnUnaPartitura() throws {
        // En Do mayor: el sostenido vale hasta la barra, el becuadro se escribe y vuelve a hacer falta.
        let raiz = leer(try Voz(leyendo: "Fa#4:4 Fa#4:4 Fa4:4 Fa#4:4 Fa#4:4 Fa#5:4 Fa4:4 Sib3:4")
            .mei(tonalidad: Tonalidad(.do)))
        XCTAssertEqual(notas(raiz).map { $0.atributos["accid"] }, ["s", nil, "n", "s", "s", "s", "n", "f"])
        XCTAssertEqual(notas(raiz).map { $0.atributos["accid.ges"] }, [nil, "s", nil, nil, nil, nil, nil, nil])
        // En Sol mayor, el fa sostenido de la armadura no se escribe, pero suena.
        let sol = leer(try Voz(leyendo: "Fa#4:2 Fa4:2").mei(tonalidad: Tonalidad(.sol)))
        XCTAssertEqual(sol.buscar("scoreDef").first?.atributos["keysig"], "1s")
        XCTAssertEqual(notas(sol).map { $0.atributos["accid"] }, [nil, "n"])
        XCTAssertEqual(notas(sol).map { $0.atributos["accid.ges"] }, ["s", nil])
        XCTAssertEqual(leer(try Voz(leyendo: "Mib4:1").mei(tonalidad: Tonalidad(armadura: -3)))
            .buscar("scoreDef").first?.atributos["keysig"], "3f")
    }

    func testLasAlteracionesValenParaTodasLasVocesDelPentagrama() throws {
        // El contralto lleva Fa♯4 en el primer acorde. En el segundo, el Fa♯5 del soprano, en otra
        // octava, lo escribe; el Fa♯4 ya no, aunque esté en otra voz (y antes en el documento). El
        // segundo acorde dura hasta la barra, negra ligada a blanca: la blanca no cuenta.
        let raiz = leer(try Coral(leyendo: "Re3 La3 Fa#4 Re5, Re3 La3 Re4 Fa#5").mei(tonalidad: Tonalidad(.do)))
        let fas = notas(raiz).filter { $0.atributos["pname"] == "f" && $0.atributos["tie"] != "t" }
        XCTAssertEqual(fas.map { $0.atributos["oct"] }, ["5", "4"])   // el soprano va primero
        XCTAssertEqual(fas.map { $0.atributos["accid"] }, ["s", "s"])
        let mismaOctava = leer(try Coral(leyendo: "Re3 La3 Fa#4 Re5, Re3 La3 Re4 Fa#4").mei(tonalidad: Tonalidad(.do)))
        let fasEnCuatro = notas(mismaOctava).filter { $0.atributos["pname"] == "f" && $0.atributos["tie"] != "t" }
        XCTAssertEqual(fasEnCuatro.map { $0.atributos["accid"] }, [nil, "s"])
        XCTAssertEqual(fasEnCuatro.map { $0.atributos["accid.ges"] }, ["s", nil])
    }

    func testLigadurasYGruposIrregulares() throws {
        let cruzada = leer(try Voz(leyendo: "Do4:2 Re4:2 Mi4:2", compas: "3/4").mei())
        XCTAssertEqual(notas(cruzada).map { $0.atributos["tie"] }, [nil, "i", "t", nil])
        let raiz = leer(try Voz(leyendo: "Do4:8. Re4:16 Mi4:1/12 Fa4:1/12 Sol4:1/12 La4:1/6 Si4:1/12", compas: "3/4").mei())
        XCTAssertEqual(notas(raiz).map { $0.atributos["dots"] }, ["1", nil, nil, nil, nil, nil, nil])
        let grupos = raiz.buscar("tuplet")
        XCTAssertEqual(grupos.map { $0.atributos["num"] }, ["3", "3"])
        XCTAssertEqual(grupos.map { $0.atributos["numbase"] }, ["2", "2"])
        XCTAssertEqual(grupos.map { $0.buscar("note").count }, [3, 2])
        XCTAssertEqual(duracion(try XCTUnwrap(raiz.buscar("layer").first)), Duracion(3, 4))
    }

    func testAcordesAnacrusaYTempo() throws {
        let acordes = leer(try Voz(leyendo: "Do4+Mi4+Sol4:2 -:4 Re4+Fa4:4").mei(tonalidad: Tonalidad(.do)))
        XCTAssertEqual(acordes.buscar("chord").map { $0.todos("note").count }, [3, 2])
        XCTAssertEqual(acordes.buscar("rest").first?.atributos["dur"], "4")
        let anacrusa = leer(try Voz(leyendo: "Sol4:4 Do5:2 Re5:4 Mi5:2", compas: "3/4", anacrusa: .negra)
            .mei(tempo: Tempo(60, unidad: Duracion(.negra, puntillos: 1))))
        let primero = try XCTUnwrap(anacrusa.buscar("measure").first)
        XCTAssertEqual(primero.atributos["n"], "0")
        XCTAssertEqual(primero.atributos["metcon"], "false")
        let tempo = try XCTUnwrap(anacrusa.buscar("tempo").first)
        XCTAssertEqual(tempo.atributos["mm"], "60")
        XCTAssertEqual(tempo.atributos["mm.unit"], "4")
        XCTAssertEqual(tempo.atributos["mm.dots"], "1")
        XCTAssertEqual(tempo.atributos["midi.bpm"], "90")
        XCTAssertEqual(tempo.atributos["startid"], "#" + (anacrusa.buscar("note").first?.atributos["xml:id"] ?? ""))
        XCTAssertEqual(leer(try Voz(leyendo: "Do4:1").mei()).buscar("scoreDef").first?.atributos["meter.sym"], "common")
        XCTAssertEqual(leer(try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:4.", compas: "3+2+2/8").mei())
            .buscar("scoreDef").first?.atributos["meter.count"], "3+2+2")
        let escapado = leer(try Voz(leyendo: "Do4:1").mei(titulo: "Do & Re <\"1\">", parte: "Flauta & voz"))
        XCTAssertEqual(escapado.buscar("title").first?.texto, "Do & Re <\"1\">")
        XCTAssertEqual(escapado.buscar("label").first?.texto, "Flauta & voz")
    }

    func testCoral() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Fa3 Fa4 La4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let raiz = leer(coral.mei(duracion: .blanca, titulo: "Cadencia", cifrados: true, analisis: true))
        XCTAssertEqual(raiz.buscar("staffGrp").first?.atributos["symbol"], "brace")
        XCTAssertEqual(raiz.buscar("staffDef").map { $0.atributos["clef.shape"] }, ["G", "F"])
        let compases = raiz.buscar("measure")
        XCTAssertEqual(compases.count, 2)
        // Soprano y contralto arriba; tenor y bajo abajo; cada pareja con las plicas en contra.
        for (pentagrama, capas) in [("1", [3, 2]), ("2", [1, 0])] {
            for (capa, indice) in capas.enumerated() {
                let suyas = compases.flatMap { compas in
                    compas.todos("staff").filter { $0.atributos["n"] == pentagrama }
                        .flatMap { $0.todos("layer").filter { $0.atributos["n"] == "\(capa + 1)" } }
                }
                XCTAssertEqual(suyas.flatMap { $0.buscar("note") }.compactMap(altura), coral.voz(indice))
                XCTAssertEqual(Set(suyas.flatMap { $0.buscar("note") }.map { $0.atributos["stem.dir"] }),
                               [capa == 0 ? "up" : "down"])
                XCTAssertEqual(suyas.map { duracion($0) }, [Duracion(1), Duracion(1)])
            }
        }
        // Los cifrados, encima del soprano; el análisis, debajo del bajo.
        XCTAssertEqual(raiz.buscar("harm").map(\.texto), ["Do", "Fa", "Sol", "Do"])
        XCTAssertEqual(Set(raiz.buscar("harm").map { $0.atributos["staff"] }), ["1"])
        let soprano = Set(compases.flatMap { $0.todos("staff")[0].todos("layer")[0].buscar("note") }
            .compactMap { $0.atributos["xml:id"].map { "#" + $0 } })
        XCTAssertTrue(raiz.buscar("harm").allSatisfy { soprano.contains($0.atributos["startid"] ?? "") })
        XCTAssertEqual(raiz.buscar("verse").filter { $0.atributos["n"] == "1" }.map { $0["syl"]?.texto }, ["I", "IV", "V", "I"])
        XCTAssertEqual(raiz.buscar("dir").first?.texto, "Do mayor:")
        XCTAssertEqual(raiz.buscar("dir").first?.atributos["staff"], "2")
    }

    func testProgresion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7/Si Do")
        let raiz = leer(analisis.mei(titulo: "Progresión", notacion: .inglesASCII))
        XCTAssertEqual(raiz.buscar("harm").map(\.texto), ["C", "Am", "D7", "G7/B", "C"])
        XCTAssertEqual(raiz.buscar("dir").first?.texto, "C major:")
        XCTAssertEqual(raiz.buscar("chord").count, 5)
        XCTAssertEqual(raiz.buscar("verse").count, analisis.acordes.flatMap(Exportacion.letras).filter { !$0.isEmpty }.count)
        let sinAnotar = leer(analisis.mei(cifrados: false, analisis: false))
        XCTAssertTrue(sinAnotar.buscar("harm").isEmpty)
        XCTAssertTrue(sinAnotar.buscar("verse").isEmpty)
        XCTAssertTrue(sinAnotar.buscar("dir").isEmpty)
    }

    /// Voces al azar (con semilla fija): cada compás completo dura lo que el compás, y las alturas
    /// que suenan, con las alteraciones escritas o no, vuelven intactas.
    func testVocesAlAzar() throws {
        var azar = GeneradorConSemilla(semilla: 2027)
        let figuras: [Duracion] = [.redonda, .blanca, .negra, .corchea, .semicorchea, Duracion(3, 8), Duracion(3, 16),
                                      Duracion(5, 8), Duracion(1, 12), Duracion(1, 6), Duracion(1, 20)]
        let compases: [Compas] = ["4/4", "3/4", "2/4", "6/8", "9/8", "5/8", "7/8", "2/2", "3/8", "12/8"]
        for _ in 0..<200 {
            let compas = compases.randomElement(using: &azar)!
            var eventos: [Evento] = []
            for _ in 0..<Int.random(in: 1...16, using: &azar) {
                let duracion = figuras.randomElement(using: &azar)!
                let alturas = (0..<Int.random(in: 0...3, using: &azar)).map { _ in
                    Altura(Nota(pasosDeQuinta: Int.random(in: -12...12, using: &azar)), octava: Int.random(in: 1...7, using: &azar))
                }
                eventos.append(Evento(alturas: alturas, duracion: duracion, ligada: Bool.random(using: &azar)))
            }
            let anacrusa = Bool.random(using: &azar) ? Duracion(1, compas.denominador) : .cero
            let voz = Voz(eventos, compas: compas, anacrusa: anacrusa)
            let tonalidad = Tonalidad(armadura: Int.random(in: -7...7, using: &azar), modo: .mayor)
            let raiz = leer(voz.mei(tonalidad: tonalidad), line: #line)
            let contexto = voz.eventos.map(\.description).joined(separator: " ") + " en \(compas), \(tonalidad)"
            let ppq = try XCTUnwrap(raiz.buscar("staffDef").first?.atributos["ppq"].flatMap { Int($0) }, contexto)
            for (i, medida) in raiz.buscar("measure").enumerated().dropLast() where medida.buscar("mRest").isEmpty {
                let capa = try XCTUnwrap(medida.buscar("layer").first, contexto)
                let conTiempo = capa.buscar("rest") + capa.buscar("chord") + capa.buscar("note").filter { $0.atributos["xml:id"] != nil }
                let exacta = conTiempo.reduce(Duracion.cero) { total, elemento in
                    total + Duracion(Int(elemento.atributos["dur.ppq"] ?? "0")!, 4 * ppq)
                }
                XCTAssertEqual(exacta, i == 0 && anacrusa > .cero ? anacrusa : compas.duracion, contexto)
                // Si todo tiene figura, las figuras, los puntillos y los grupos dan lo mismo.
                if conTiempo.allSatisfy({ $0.atributos["dur"] != nil }) { XCTAssertEqual(duracion(capa), exacta, contexto) }
            }
            XCTAssertEqual(notas(raiz).compactMap(altura), voz.grafia.joined().flatMap(\.alturas), contexto)
            // Todo lo que ocupa tiempo (las notas de un acorde, no: el acorde) tiene su duración exacta.
            let conTiempo = raiz.buscar("rest") + raiz.buscar("chord") + notas(raiz).filter { $0.atributos["xml:id"] != nil }
            XCTAssertNil(conTiempo.first { $0.atributos["dur.ppq"] == nil }, contexto)
        }
    }
}
