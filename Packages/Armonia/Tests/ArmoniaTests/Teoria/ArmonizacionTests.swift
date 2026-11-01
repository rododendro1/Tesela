import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct ArmonizacionTests {
    // MARK: Acordes para una nota

    @Test func acordesParaUnaNota() {
        let doMayor = Tonalidad(.do)
        #expect(doMayor.acordes(para: .sol).prefix(3).map(\.valor) == ["Sol", "Do", "Sol7"])
        #expect(doMayor.acordes(para: .do).first?.valor == "Do")
        // Ordenados por coste.
        let costes = doMayor.acordes(para: .re).map(\.coste)
        #expect(costes == costes.sorted())
        // Una nota cromática: la dominante secundaria que la tiene.
        #expect(doMayor.acordes(para: "Fa#").map(\.valor).contains("Re7"))
        // Ninguno de la tonalidad tiene La♭: los del modo homónimo (iv y ♭VI).
        #expect(doMayor.acordes(para: "Lab").prefix(2).map(\.valor) == ["Fam", "Lab"])
        #expect(doMayor.acordes(para: "Do#").map(\.valor) == ["La", "La7"])
    }

    // MARK: Armonizar

    private func cifrados(_ tonalidad: Tonalidad, _ melodia: String) -> [String] {
        let notas = melodia.split(separator: " ").map { Nota(texto: String($0))! }
        return tonalidad.armonizar(melodia: notas).first?.valor.cifrados ?? []
    }

    @Test func armonizar() {
        #expect(cifrados(Tonalidad(.do), "Mi Re Do") == ["I", "V", "I"])
        #expect(cifrados(Tonalidad(.do), "Do Re Mi Fa Re Si Do") == ["I", "V", "I", "IV", "ii", "V", "I"])
        #expect(cifrados(Tonalidad(.la, .menor), "Do Si La Sol# La") == ["i", "V", "i", "V", "i"])
        #expect(cifrados(Tonalidad(.sol), "Si La Sol") == ["I", "V", "I"])
    }

    @Test func propuestasOrdenadasYDistintas() {
        let propuestas = Tonalidad(.do).armonizar(melodia: ["Mi", "Re", "Do"], propuestas: 4)
        #expect(propuestas.count == 4)
        #expect(propuestas.map(\.coste) == propuestas.map(\.coste).sorted())
        #expect(Set(propuestas.map(\.valor.acordes)).count == 4)
        #expect(propuestas[0].valor.description == "Do Sol Do (I–V–I)")
        #expect(propuestas[0].valor.texto(en: .inglesASCII) == "C G C (I–V–I)")
        #expect(propuestas[0].valor.melodia == ["Mi", "Re", "Do"])
    }

    @Test func terminaEnCadencia() {
        // Termina en el I precedido de la dominante, o en la dominante si la nota no es del I.
        for melodia in ["Sol La Si Do", "Mi Fa Sol La Sol Fa Mi Re Do", "Do Mi Re Si Do"] {
            let analisis = Tonalidad(.do).armonizar(
                melodia: melodia.split(separator: " ").map { Nota(texto: String($0))! })[0].valor.analisis
            #expect(analisis.cadencias.last?.tipo == .autentica, Comment(rawValue: melodia))
        }
        let semicadencia = cifrados(Tonalidad(.do), "Do Mi Fa Re")
        #expect(semicadencia.last == "V")
    }

    @Test func secundariaVaASuDestino() {
        // Fa♯ pide Re (V/V), que tiene que ir a Sol.
        let propuesta = Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"])[0].valor
        #expect(propuesta.cifrados.prefix(3) == ["I", "V/V", "V"])
        for candidato in Tonalidad(.do).armonizar(melodia: ["Mi", "Fa#", "Sol", "Do"], propuestas: 10) {
            for (i, a) in candidato.valor.analisis.acordes.enumerated() {
                if case .dominanteSecundaria(let destino) = a.categoria {
                    #expect(candidato.valor.analisis.acordes[i + 1].grado == destino, "\(candidato.valor)")
                }
            }
        }
    }

    @Test func armonizarVacio() {
        #expect(Tonalidad(.do).armonizar(melodia: []) == [])
        #expect(Tonalidad(.do).armonizar(melodia: ["Do"], propuestas: 0) == [])
        #expect(Tonalidad(.do).armonizar(melodia: ["Do"]).first?.valor.acordes == ["Do"])
    }

    // MARK: Realizar a cuatro voces

    private func comprobarRealizacion(
        _ texto: String, en tonalidad: Tonalidad? = nil,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let acordes = texto.split(separator: " ").map { Acorde(texto: String($0))! }
        guard let coral = Coral.realizar(acordes, en: tonalidad) else {
            Issue.record("«\(texto)» no se realiza", sourceLocation: sourceLocation)
            return
        }
        #expect(coral.faltas == [], Comment(rawValue: texto), sourceLocation: sourceLocation)
        #expect(coral.acordes.count == acordes.count, sourceLocation: sourceLocation)
        for (acorde, voces) in zip(acordes, coral.acordes) {
            let notas = voces.map(\.nota)
            #expect(notas[0] == acorde.bajo, "bajo de \(acorde)", sourceLocation: sourceLocation)
            #expect(
                notas.allSatisfy { acorde.notas.contains($0) || $0 == acorde.bajo }, "\(acorde): \(voces)",
                sourceLocation: sourceLocation)
            for nota in acorde.notas where nota != acorde.quinta {
                #expect(notas.contains(nota), "falta \(nota) en \(acorde): \(voces)", sourceLocation: sourceLocation)
            }
            if let septima = acorde.septima {
                #expect(
                    notas.filter { $0 == septima }.count <= 1, "\(acorde): \(voces)", sourceLocation: sourceLocation)
            }
        }
    }

    @Test func realizar() {
        comprobarRealizacion("Do Fa Sol7 Do")
        comprobarRealizacion("Do Lam Rem Sol7 Do")
        comprobarRealizacion("Do Fa/La Sol7/Si Do")
        comprobarRealizacion("Do Sol7/Fa Do/Mi Fa Sol Do")
        comprobarRealizacion("Do Re7 Sol Do Lam Fa Sol7 Do")
        comprobarRealizacion("Lam Rem/Fa Mi7 Lam")
        comprobarRealizacion("Lam Sol#°7 Lam Sim7(b5) Mi7 Lam")
        comprobarRealizacion("Do Fa Do/Sol Sol7 Do")
        comprobarRealizacion("Sol Do Re7 Sol Mim Do Re Sol")
    }

    @Test func realizarConSoprano() throws {
        let soprano: [Altura] = ["Mi4", "Fa4", "Re4", "Do4"]
        let coral = try #require(Coral.realizar(["Do", "Fa", "Sol", "Do"], soprano: soprano))
        #expect(coral.voz(3) == soprano)
        #expect(coral.esCorrecta)
        #expect(coral.voz(0).map(\.nota) == ["Do", "Fa", "Sol", "Do"])
        // Do–Rem con el soprano Sol4–La4 obliga a quintas paralelas con el bajo: no hay realización.
        #expect(Coral.realizar(["Do", "Rem"], soprano: ["Sol4", "La4"]) == nil)
    }

    @Test func laSensibleSubeEnElSoprano() throws {
        let coral = try #require(Coral.realizar(["Do", "Sol", "Do"], soprano: ["Mi4", "Si4", "Do5"]))
        #expect(coral.esCorrecta)
        // Y no se duplica.
        for voces in coral.acordes {
            #expect(voces.filter { $0.nota == .si }.count <= 1)
        }
    }

    @Test func realizarImposible() {
        #expect(Coral.realizar([]) == nil)
        // El soprano no tiene tantas notas, o una no es del acorde, o está fuera de tesitura.
        #expect(Coral.realizar(["Do", "Sol"], soprano: ["Do5"]) == nil)
        #expect(Coral.realizar(["Do", "Sol"], soprano: ["Do5", "Do5"]) == nil)
        #expect(Coral.realizar(["Do", "Sol"], soprano: ["Do6", "Si5"]) == nil)
        // Más de cuatro notas obligatorias.
        #expect(Coral.realizar(["Do7(9,13)"]) == nil)
    }

    @Test func disposicionesSinFaltas() {
        let disposiciones = Coral.disposiciones(de: "Sol7", soprano: nil, sensible: .si)
        #expect(!disposiciones.isEmpty)
        for d in disposiciones {
            #expect(Coral([d.alturas])!.esCorrecta)
            #expect(d.alturas[0].nota == .sol)
            #expect(d.alturas.filter { $0.nota == .si }.count <= 1)
        }
    }

    // MARK: Armonizar a cuatro voces

    @Test func armonizarACuatroVoces() throws {
        let melodia: [Altura] = ["Do5", "Si4", "La4", "Sol4", "Fa4", "Mi4", "Re4", "Do4"]
        let armonizada = try #require(Tonalidad(.do).armonizarACuatroVoces(melodia))
        #expect(armonizada.coral.voz(3) == melodia)
        #expect(armonizada.coral.esCorrecta)
        #expect(armonizada.armonizacion.melodia == melodia.map(\.nota))
        #expect(armonizada.armonizacion.cifrados.last == "I")
        #expect(Tonalidad(.do).armonizarACuatroVoces(["Do6", "Si5", "Do6"]) == nil)
    }

    @Test func armonizarMelodiasAlAzar() {
        // Cualquier melodía de la escala en la tesitura del soprano y sin saltos aumentados ni de más
        // de una octava: si sale un coral, no tiene faltas y lleva la melodía arriba. Y casi siempre sale.
        var generador = GeneradorConSemilla(semilla: 8)
        let tonalidad = Tonalidad(.re)
        let alturas = (0..<8).map { Altura(tonalidad.escala.grado($0 + 1), octava: $0 >= 6 ? 5 : 4) }
        var probadas = 0
        var realizadas = 0
        while probadas < 20 {
            let melodia = (0..<Int.random(in: 3...7, using: &generador)).map { _ in
                alturas.randomElement(using: &generador)!
            }
            let saltos = zip(melodia, melodia.dropFirst()).map { $1 - $0 }
            func alterado(_ salto: Intervalo) -> Bool {
                switch salto.calidad {
                case .aumentada, .disminuida: return true
                default: return salto.semitonos > 12
                }
            }
            guard !saltos.contains(where: alterado) else { continue }
            probadas += 1
            guard let armonizada = tonalidad.armonizarACuatroVoces(melodia) else { continue }
            realizadas += 1
            #expect(armonizada.coral.voz(3) == melodia)
            #expect(armonizada.coral.faltas == [], "\(melodia)")
        }
        #expect(realizadas >= 18)
    }
}
