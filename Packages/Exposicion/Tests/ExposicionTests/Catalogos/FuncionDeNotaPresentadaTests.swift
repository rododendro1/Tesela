import Armonia
import Foundation
import Testing

@testable import Exposicion

@Suite struct FuncionDeNotaPresentadaTests {
    /// La ficha de una blue note, con el intervalo, los cents y el desvío; la de un adorno, solo la familia.
    @Test func ficha() throws {
        let notacion = Notacion.compacta(.espanol)
        let septima = FuncionDeNotaPresentada(.septimaBlue, en: notacion)
        #expect(septima.nombre == "séptima blue" && septima.referencias == ["Van der Merwe 1989"])
        let ficha = septima.ficha(en: notacion)
        #expect(ficha.count == 4 && ficha[0].valor == "blue notes")
        #expect(ficha[2] == DatoPresentado(nombre: "Cents desde la tónica", valor: "968.826"))
        #expect(ficha[3].valor == "−31.174 ¢")
        let trino = FuncionDeNotaPresentada(.trino, en: .compacta(.ingles))
        #expect(trino.nombre == "trill" && trino.intervalo == nil && trino.ficha(en: .compacta(.ingles)).count == 1)
        let json = try JSONEncoder().encode(septima)
        #expect(try JSONDecoder().decode(FuncionDeNotaPresentada.self, from: json) == septima)
    }
}
