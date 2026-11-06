import Armonia
import Testing

@testable import ArmoniaPresentacion

// La hoja de una tonalidad y dos progresiones comparadas acorde a acorde.
@Suite struct TonalidadYComparacionTests {
    let notacion = Notacion.espanolCompacto

    @Test func armaduraYRelativas() {
        let sinAlteraciones = PresentacionDeTonalidad.armadura(de: Tonalidad(.do), notacion: notacion)
        #expect(sinAlteraciones == "Armadura: sin alteraciones")
        let fa = PresentacionDeTonalidad.armadura(de: Tonalidad(.fa), notacion: notacion)
        #expect(fa.hasPrefix("Armadura: Si"), Comment(rawValue: fa))
        #expect(fa.split(separator: " ").count == 2, Comment(rawValue: fa))
        #expect(
            PresentacionDeTonalidad.relativas(de: Tonalidad(.do), notacion: notacion)
                == "Relativa: La menor · Homónima: Do menor")
    }

    @Test func cadenciasTipicas() {
        let mayor = PresentacionDeTonalidad.cadenciasTipicas(de: Tonalidad(.do), notacion: notacion)
        #expect(mayor.map(\.grados) == ["V7–I", "IV–I", "V7–vi", "ii–V"])
        #expect(mayor.map(\.acordes) == ["Sol7 – Do", "Fa – Do", "Sol7 – Lam", "Rem – Sol"])
        #expect(mayor.allSatisfy { !$0.nombre.isEmpty })
        let menor = PresentacionDeTonalidad.cadenciasTipicas(de: Tonalidad(.la, .menor), notacion: notacion)
        #expect(menor.first?.acordes == "Mi7 – Lam", Comment(rawValue: menor.map(\.acordes).description))
        #expect(menor.first?.grados == "V7–i")
    }

    @Test func hojaDeUnaTonalidad() {
        let hoja = PresentacionDeTonalidad.hojaDeEstudio(de: Tonalidad(.re), notacion: notacion)
        #expect(hoja.hasPrefix("<svg "))
        #expect(hoja.hasSuffix("</svg>"))
        #expect(hoja.contains(">Re mayor</text>"))
        #expect(hoja.contains(">Relativa: Si menor · Homónima: Re menor</text>"), Comment(rawValue: hoja))
        #expect(hoja.contains(">Cadencias típicas</text>"))
        #expect(hoja.contains(">Modulaciones</text>"))
        #expect(hoja.contains(">La7 – Re</text>"))
        let menor = PresentacionDeTonalidad.hojaDeEstudio(de: Tonalidad(.la, .menor), notacion: notacion)
        #expect(menor.contains(">La menor</text>"))
    }

    @Test func compararDosProgresiones() throws {
        let original = [Acorde("Do"), Acorde("Lam"), Acorde("Rem"), Acorde("Sol7")]
        let nueva = [Acorde("Do"), Acorde("La7"), Acorde("Rem7"), Acorde("Sol7")]
        let comparacion = try #require(PresentacionDeAnalisis.comparar(original, con: nueva, notacion: notacion))
        #expect(comparacion.tonalidad == "Do mayor")
        #expect(comparacion.resumen == "Cambian 2 de 4 acordes")
        #expect(comparacion.filas.map(\.cambia) == [false, true, true, false])
        #expect(comparacion.filas[0].grados == "I")
        #expect(comparacion.filas[0].comunes.isEmpty)
        #expect(comparacion.filas[1].original == "Lam")
        #expect(comparacion.filas[1].nueva == "La7")
        #expect(comparacion.filas[1].grados.hasPrefix("vi → "), Comment(rawValue: comparacion.filas[1].grados))
        #expect(comparacion.filas[1].comunes == "Notas comunes: La, Mi")
        // Una más larga que la otra, y sin notas comunes.
        let larga = try #require(
            PresentacionDeAnalisis.comparar(
                [Acorde("Do")], con: [Acorde("Fa#"), Acorde("Sol")], en: Tonalidad(.do), notacion: notacion))
        #expect(larga.filas.count == 2)
        #expect(larga.filas[0].comunes == "Notas comunes: ninguna")
        #expect(larga.filas[1].original == "–")
        #expect(larga.filas[1].grados.hasPrefix("– → "))
        #expect(larga.resumen == "Cambian 2 de 2 acordes")
        #expect(PresentacionDeAnalisis.comparar([], con: nueva, notacion: notacion) == nil)
        #expect(PresentacionDeAnalisis.comparar(original, con: [], notacion: notacion) == nil)
    }

    @Test func hojaDeLaComparacion() throws {
        let original = [Acorde("Do"), Acorde("Lam"), Acorde("Rem"), Acorde("Sol7")]
        let nueva = [Acorde("Do"), Acorde("La7"), Acorde("Rem7"), Acorde("Sol7")]
        let hoja = try #require(PresentacionDeAnalisis.hojaDeLaComparacion(original, con: nueva, notacion: notacion))
        #expect(hoja.hasPrefix("<svg "))
        #expect(hoja.contains(">Do – Lam – Rem – Sol7</text>"))
        #expect(hoja.contains(">Do – La7 – Rem7 – Sol7</text>"))
        #expect(hoja.contains(">Lam → La7</text>"), Comment(rawValue: hoja))
        #expect(hoja.contains(">Cambian 2 de 4 acordes</text>"))
        #expect(PresentacionDeAnalisis.hojaDeLaComparacion([], con: nueva, notacion: notacion) == nil)
    }
}
