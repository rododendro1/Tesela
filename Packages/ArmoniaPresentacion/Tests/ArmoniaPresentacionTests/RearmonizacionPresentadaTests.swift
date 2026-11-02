import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

/// «Rearmonizar» en la app y en la línea de comandos.
@Suite struct RearmonizacionPresentadaTests {
    @Test func lasPropuestasDeUnaProgresion() throws {
        let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Rem7"), Acorde("Sol7"), Acorde("Do")]
        let resultado = try #require(PresentacionDeRearmonizacion.proponer(acordes, notacion: .espanolCompacto))
        let (tonalidad, propuestas) = (resultado.tonalidad, resultado.propuestas)
        #expect(tonalidad == Tonalidad(.do))
        let tritonal = try #require(propuestas.first { $0.rearmonizacion.recurso == .sustitutoTritonal })
        #expect(tritonal.descripcion == "Sol7 → Re♭7 (sustituto tritonal)")
        #expect(tritonal.texto == "Do Lam Rem7 Re♭7 Do")
        // El pasaje: Rem7, Re♭7 y Do.
        #expect(tritonal.sonido.inicios.count == 3)
        #expect(tritonal.sonido.tonica == .do)
        // La dominante secundaria del primer Lam: Do, Mi7, Lam y Rem7.
        let secundaria = try #require(
            propuestas.first { $0.rearmonizacion.recurso == .dominanteSecundaria && $0.rearmonizacion.posicion == 1 })
        #expect(secundaria.texto == "Do Mi7 Lam Rem7 Sol7 Do")
        #expect(secundaria.sonido.inicios.count == 4)
        #expect(PresentacionDeRearmonizacion.proponer([], notacion: .espanolCompacto) == nil)
    }

    @Test func desdeElAnalisisYEnIngles() throws {
        let analisis = try PresentacionDeAnalisis.analizar("C Am F G7 C", notacion: .inglesASCII)
        let propuestas = analisis.rearmonizaciones(en: .inglesASCII)
        #expect(propuestas.contains { $0.descripcion == "G7 → Db7 (tritone substitution)" })
        #expect(propuestas.contains { $0.texto == "C Am F Db7 C" })
        // Sin acordes ni tonalidad, ninguna propuesta.
        var vacio = analisis
        vacio.acordes = []
        vacio.tonalidad = nil
        #expect(vacio.rearmonizaciones(en: .inglesASCII) == [])
    }

    @Test func enUnaTonalidadDada() throws {
        let acordes = [Acorde("Do"), Acorde("Sol7"), Acorde("Do")]
        let enDo = try #require(
            PresentacionDeRearmonizacion.proponer(acordes, en: Tonalidad(.do), notacion: .espanolCompacto))
        #expect(enDo.tonalidad == Tonalidad(.do))
        // Las propuestas son distintas entre sí y se pueden comparar.
        #expect(Set(enDo.propuestas).count == enDo.propuestas.count)
        let analizada = PresentacionDeRearmonizacion.proponer(acordes, notacion: .espanolCompacto)
        #expect(enDo.propuestas == analizada?.propuestas)
    }
}
