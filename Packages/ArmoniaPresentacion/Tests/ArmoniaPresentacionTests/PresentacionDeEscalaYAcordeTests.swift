import Armonia
import Testing

@testable import ArmoniaPresentacion

// La relación escala-acorde de las vistas de acordes, escalas y análisis, y de `armonia analizar --escalas`.
@Suite struct PresentacionDeEscalaYAcordeTests {
    @Test func unaEscalaSobreUnAcorde() {
        let dorico = PresentacionDeEscalaYAcorde.presentar(
            Escala(.re, .dorico), sobre: Acorde("Rem7"), notacion: .espanolCompacto)
        #expect(dorico.nombre == "Re dórico")
        #expect(dorico.modo == "modo 2 de Do mayor")
        #expect(dorico.notas == "Re 1 · Mi 9 · Fa ♭3 · Sol 11 · La 5 · Si 13 · Do ♭7")
        #expect(dorico.tensiones == "Mi 9 · Sol 11 · Si 13")
        #expect(dorico.aEvitar.isEmpty)
        #expect(dorico.resumen == "Tensiones: Mi 9 · Sol 11 · Si 13")

        let jonico = PresentacionDeEscalaYAcorde.presentar(
            Escala(.do, .mayor), sobre: Acorde("Do7M"), notacion: .espanolCompacto)
        #expect(jonico.modo == nil)  // es la propia madre
        #expect(jonico.aEvitar == "Fa 11")
        #expect(jonico.resumen == "Tensiones: Re 9 · La 13 — A evitar: Fa 11")
    }

    @Test func enOtroIdioma() {
        let mixolidio = PresentacionDeEscalaYAcorde.presentar(
            Escala(.sol, .mixolidio), sobre: Acorde("Sol7"), notacion: .inglesASCII)
        #expect(mixolidio.modo == "mode 5 of C major")
        #expect(mixolidio.resumen.hasPrefix("Tensions: A 9 · E 13"))
        #expect(mixolidio.resumen.hasSuffix("Avoid: C 11"))
    }

    @Test func elModoDeUnaEscala() {
        #expect(
            PresentacionDeEscalaYAcorde.modo(de: Escala(.do, .alterada), notacion: .espanolCompacto)
                == "modo 7 de Re♭ menor melódica de jazz")
        #expect(PresentacionDeEscalaYAcorde.modo(de: Escala(.do, .tonosEnteros), notacion: .espanolCompacto) == nil)
    }

    @Test func laEscalaDeCadaAcordeDelAnalisis() throws {
        let analisis = try PresentacionDeAnalisis.analizar(
            "Do La7 Rem7 Sol7 Do", en: Tonalidad(.do), notacion: .espanolCompacto)
        let escalas = analisis.tramos.flatMap(\.filas).map { $0.escala?.nombre }
        #expect(escalas == ["Do mayor", "La frigio dominante", "Re dórico", "Sol mixolidio", "Do mayor"])
        let la7 = try #require(analisis.tramos[0].filas[1].escala)
        #expect(la7.tensiones == "Si♭ ♭9 · Fa ♭13")
        #expect(la7.aEvitar == "Re 11")
        #expect(la7.modo == "modo 5 de Re menor armónica")
    }
}
