import Testing

@testable import Diagramas
@testable import Elementos
@testable import Teoria

@Suite struct ReticuloJustoTests {
    typealias Punto = ReticuloJusto.Punto

    func acordes(_ cifrados: String...) throws -> [Acorde] { try cifrados.map { try Acorde(leyendo: $0) } }

    @Test func lasRazonesYLosDesvios() {
        #expect(Punto(quintas: 1, terceras: 0).razon.description == "3/2")
        #expect(Punto(quintas: 0, terceras: 1).razon.description == "5/4")
        #expect(Punto(quintas: -1, terceras: 1).razon.description == "5/3")
        #expect(Punto(quintas: 2, terceras: 0).razon.description == "9/8")
        #expect(Punto(quintas: -2, terceras: 1).razon.description == "10/9")
        #expect(Punto(quintas: -4, terceras: 1).razon.description == "160/81")
        #expect(abs(Punto(quintas: 0, terceras: 1).desvio - -13.686) < 1e-3)
        #expect(abs(Punto(quintas: -1, terceras: 1).desvio - -15.641) < 1e-3)
        #expect(abs(Punto(quintas: -4, terceras: 1).desvio - -21.506) < 1e-3)
    }

    @Test func laComaDeDoLamRemSolDo() throws {
        let reticulo = ReticuloJusto(try acordes("Do", "Lam", "Rem", "Sol", "Do"))
        #expect(reticulo.tonica == .do)
        #expect(
            reticulo.acordes.map(\.fundamental) == [
                Punto(quintas: 0, terceras: 0), Punto(quintas: -1, terceras: 1), Punto(quintas: -2, terceras: 1),
                Punto(quintas: -3, terceras: 1), Punto(quintas: -4, terceras: 1),
            ])
        #expect(reticulo.deriva == -21.506)
        // Las notas de cada acorde, cerca de su fundamental: Do mayor es 1, 5/4 y 3/2.
        #expect(
            reticulo.acordes[0].notas == [
                Punto(quintas: 0, terceras: 0), Punto(quintas: 0, terceras: 1), Punto(quintas: 1, terceras: 0),
            ])
        // La menor: su tercera menor es 6/5, una quinta y una tercera bajada.
        let la = reticulo.acordes[1]
        #expect(la.notas == [la.fundamental, Punto(quintas: 0, terceras: 0), Punto(quintas: 0, terceras: 1)])
        #expect(reticulo.nota(de: Punto(quintas: -1, terceras: 1)) == .la)
        #expect(reticulo.nota(de: Punto(quintas: 4, terceras: 0)) == .mi)
    }

    @Test func sinDerivaYSinAcordes() throws {
        let cadencia = ReticuloJusto(try acordes("Do", "Fa", "Sol", "Do"))
        #expect(cadencia.deriva == 0)
        #expect(ReticuloJusto(try acordes("Do", "Sol")).deriva == nil)
        #expect(ReticuloJusto([]).acordes.isEmpty)
        #expect(ReticuloJusto([]).deriva == nil)
        // Con otra tónica.
        let enLa = ReticuloJusto(try acordes("Do"), tonica: .la)
        #expect(enLa.acordes[0].fundamental == Punto(quintas: 1, terceras: -1))
        // La séptima de dominante: la menor, 16/9 sobre la fundamental (dos quintas bajadas).
        let sol7 = ReticuloJusto(try acordes("Sol7"))
        #expect(sol7.acordes[0].notas.last == Punto(quintas: -2, terceras: 0))
    }

    @Test func elDibujo() throws {
        let svg = ReticuloJusto(try acordes("Do", "Lam", "Rem", "Sol", "Do")).svg()
        #expect(svg.hasPrefix("<svg"))
        #expect(
            svg.contains("<title>Do – Lam – Rem – Sol – Do · deriva de -21.506 cents</title>"), Comment(rawValue: svg))
        #expect(svg.contains(">160/81</text>") && svg.contains(">10/9</text>"))
        #expect(svg.contains("marker-end=\"url(#flecha)\""))
        #expect(svg.contains("de una fundamental a la siguiente"))
        let ingles = ReticuloJusto(try acordes("Do", "Fa")).svg(opciones: .init(notacion: .compacta(.ingles)))
        #expect(ingles.contains("<title>C – F</title>") && ingles.contains(">F</text>"))
        #expect(ReticuloJusto([]).svg().hasPrefix("<svg"))
    }
}
