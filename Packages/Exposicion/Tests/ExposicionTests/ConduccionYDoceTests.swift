import Armonia
import Testing

@testable import Exposicion

// La conducción de las voces de una progresión y la progresión en las doce tonalidades.
@Suite struct ConduccionYDoceTests {
    let notacion = Notacion.espanolCompacto
    let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]

    @Test func conduccionDeUnaProgresion() throws {
        let conduccion = try #require(PresentacionDeAnalisis.conduccion(progresion, en: notacion))
        #expect(conduccion.disposicion == "Drop 2")
        #expect(conduccion.pasos.map(\.titulo) == ["Rem7 → Sol7", "Sol7 → Domaj7"])
        #expect(conduccion.pasos[0].comunes == "Notas comunes: Re, Fa")
        #expect(conduccion.pasos.allSatisfy { $0.voces.count == 4 })
        #expect(conduccion.pasos[0].voces.allSatisfy { $0.contains(" → ") && $0.hasSuffix(")") })
        let total = conduccion.pasos.map(\.movimiento).reduce(0, +)
        #expect(conduccion.movimientoTotal == "Movimiento total: \(total) semitonos")
        #expect(PresentacionDeAnalisis.conduccion([Acorde("Do")], en: notacion) == nil)
        let sinComunes = try #require(
            PresentacionDeAnalisis.conduccion([Acorde("Do"), Acorde("Fa#")], en: notacion))
        #expect(sinComunes.pasos[0].comunes == "Notas comunes: ninguna")
    }

    @Test func enLasDoceTonalidades() {
        let doce = PresentacionDeAnalisis.enLasDoceTonalidades(
            progresion, tonalidad: Tonalidad(.do), en: notacion)
        #expect(doce.count == 12)
        #expect(doce[0].cifrados == "Rem7 Sol7 Domaj7")
        #expect(doce[1].titulo == "Sol mayor")
        #expect(doce[1].cifrados == "Lam7 Re7 Solmaj7")
        #expect(doce[11].titulo == "Fa mayor")
        #expect(Set(doce.map(\.tonalidad.tonica.claseDeAltura)).count == 12)
        let menor = PresentacionDeAnalisis.enLasDoceTonalidades(
            [Acorde("Lam"), Acorde("Mi7")], tonalidad: Tonalidad(.la, .menor), en: notacion)
        #expect(menor[1].titulo == "Mi menor")
        #expect(menor[1].cifrados == "Mim Si7")
    }

    @Test func hojas() throws {
        let doce = PresentacionDeAnalisis.hojaEnLasDoceTonalidades(
            progresion, tonalidad: Tonalidad(.do), en: notacion)
        #expect(doce.hasPrefix("<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"595\""))
        #expect(doce.hasSuffix("</svg>"))
        #expect(doce.contains(">Sol mayor</text>"), Comment(rawValue: String(doce.prefix(800))))
        #expect(doce.contains(">Lam7 Re7 Solmaj7</text>"))
        #expect(doce.components(separatedBy: "<svg").count == doce.components(separatedBy: "</svg>").count)
        let analisis = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Domaj7", notacion: notacion)
        let hoja = PresentacionDeAnalisis.hojaDeEstudio(analisis, en: notacion)
        #expect(hoja.contains(">Conducción de voces · Drop 2</text>"))
        #expect(hoja.contains(">Rem7 → Sol7 · Notas comunes: Re, Fa</text>"))
    }
}
