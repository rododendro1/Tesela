import ApoyoDePruebas
import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaDiagramas
@testable import ArmoniaTeoria

/// El Tonnetz y la tabla armónica se usan igual a través de `RedDeTriadas`: lo mismo que sus inicializadores.
@Suite struct RedDeTriadasTests {
    /// La red de un recorrido, con el tipo que se elija.
    private func recorrido<Red: RedDeTriadas>(_: Red.Type, _ acordes: [Acorde]) -> Red? {
        Red(recorrido: acordes)
    }

    @Test func lasDosRedesSeCreanIgual() throws {
        let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Fa")]
        #expect(recorrido(Tonnetz.self, acordes) == Tonnetz(recorrido: acordes))
        #expect(recorrido(TablaArmonica.self, acordes) == TablaArmonica(recorrido: acordes))
        #expect(recorrido(Tonnetz.self, [Acorde("Do7")]) == nil)
        #expect(recorrido(TablaArmonica.self, [Acorde("Do7")]) == nil)
    }

    @Test func yDibujanLoMismoQueSinElProtocolo() {
        func svg<Red: RedDeTriadas>(_ red: Red) -> String {
            red.svg(opciones: OpcionesDeDiagrama(), margen: nil, leyenda: true)
        }
        #expect(svg(Tonnetz(Acorde("Do"))) == Tonnetz(Acorde("Do")).svg())
        #expect(svg(TablaArmonica(Escala(.re, .dorico))) == TablaArmonica(Escala(.re, .dorico)).svg())
    }
}
