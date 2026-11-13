import Armonia
import Foundation
import Testing

@testable import Exposicion

@Suite struct PresentacionDeNotaTests {
    /// La ficha de un diapasón, con el año y la frecuencia.
    @Test func diapason() throws {
        let notacion = Notacion.compacta(.espanol)
        let la = NotaPresentada(.la4225, en: notacion)
        #expect(la.nombre == "La 422,5" && la.frecuencia == 422.5 && la.midi == 69)
        #expect(
            la.ficha(en: notacion).map(\.valor) == [
                "diapasones", "La₄", "422.5 Hz", "422.5 Hz", "69", "diapasón de Händel", "Clasicismo (1751)",
            ])
        #expect(la.referencias == ["Haynes 2002"])
        let json = try JSONEncoder().encode(la)
        #expect(try JSONDecoder().decode(NotaPresentada.self, from: json) == la)
        let doCentral = NotaPresentada(.doCentral, en: .compacta(.ingles))
        #expect(doCentral.nombre == "middle C" && doCentral.ficha(en: .compacta(.ingles)).count == 4)
    }

    /// Las de las tradiciones dan su desvío y su nombre original; las guidonianas dobles, sus dos alturas.
    @Test func tradicionesYPosiciones() throws {
        let notacion = Notacion.compacta(.espanol)
        let sikah = NotaPresentada(try #require(NotaConNombre.buscar(nombre: "Sikah")), en: notacion)
        let ficha = sikah.ficha(en: notacion)
        #expect(ficha.contains(DatoPresentado(nombre: "Desvío del temperado", valor: "−50 ¢")))
        #expect(ficha.contains(DatoPresentado(nombre: "Nombre original", valor: "سيكاه")))
        let segah = NotaPresentada(try #require(NotaConNombre.buscar(nombre: "Segah")), en: notacion)
        #expect(segah.nombreOriginal == nil && segah.ficha(en: notacion)[2].valor == "−13.208 ¢")
        let doble = NotaPresentada(try #require(NotaConNombre.buscar(nombre: "b fa ♮ mi")), en: notacion)
        #expect(doble.ficha(en: notacion).last?.valor == "Si♭₃ Si₃")
        #expect(NotaPresentada(.doCentral, en: notacion).alturasDeLaPosicion == nil)
    }
}
