import Armonia
import Testing

@testable import ExposicionArmonia

// La relación escala-acorde de las vistas de acordes, escalas y análisis, y de `armonia analizar --escalas`.
@Suite struct PresentacionDeEscalaYAcordeTests {
    @Test func unaEscalaSobreUnAcorde() {
        let dorico = PresentacionDeEscalaYAcorde.presentar(
            Escala(.re, .dorico), sobre: Acorde("Rem7"), en: .compacta(.espanol))
        #expect(dorico.nombre == "Re dórico")
        #expect(dorico.modo == "modo 2 de Do mayor")
        #expect(dorico.notas == "Re 1 · Mi 9 · Fa ♭3 · Sol 11 · La 5 · Si 13 · Do ♭7")
        #expect(dorico.tensiones == "Mi 9 · Sol 11 · Si 13")
        #expect(dorico.aEvitar.isEmpty)
        #expect(dorico.resumen == "Tensiones: Mi 9 · Sol 11 · Si 13")
        #expect(dorico.estructurasSuperiores == "Mim · Sol · Do · Lam")

        let jonico = PresentacionDeEscalaYAcorde.presentar(
            Escala(.do, .mayor), sobre: Acorde("Do7M"), en: .compacta(.espanol))
        #expect(jonico.modo == nil) // es la propia madre
        #expect(jonico.aEvitar == "Fa 11")
        #expect(jonico.resumen == "Tensiones: Re 9 · La 13 — A evitar: Fa 11")
        #expect(jonico.estructurasSuperiores == "Sol · Lam")
    }

    /// Las escalas de un acorde llevan su motivo, salvo las que solo son compatibles.
    @Test func lasEscalasConSuMotivo() {
        let escalas = PresentacionDeEscalaYAcorde.escalas(de: Acorde("Do7"), notacion: .compacta(.espanol))
        #expect(PresentacionDeEscalaYAcorde.nombreConMotivo(escalas[0]) == "Do mixolidio (del cifrado)")
        #expect(
            escalas[1].motivo == nil && PresentacionDeEscalaYAcorde.nombreConMotivo(escalas[1]) == escalas[1].nombre)
        let enDo = PresentacionDeEscalaYAcorde.escalas(
            de: Acorde("Rem7"), en: Tonalidad(.do), notacion: .compacta(.ingles))
        #expect(enDo[0].motivo == "from the key")
        // Las del bajo se leen sobre el acorde que forma: el Re de Sol mixolidio es la 5.ª de Sol9sus4.
        let delBajo = PresentacionDeEscalaYAcorde.escalas(de: Acorde("Fa/Sol"), notacion: .compacta(.espanol))[0]
        #expect(delBajo.motivo == "del bajo" && !delBajo.tensiones.contains("Re"))
    }

    @Test func enOtroIdioma() {
        let mixolidio = PresentacionDeEscalaYAcorde.presentar(
            Escala(.sol, .mixolidio), sobre: Acorde("Sol7"), en: .ascii(.ingles))
        #expect(mixolidio.modo == "mode 5 of C major")
        #expect(mixolidio.resumen.hasPrefix("Tensions: A 9 · E 13"))
        #expect(mixolidio.resumen.hasSuffix("Avoid: C 11"))
    }

    @Test func elModoDeUnaEscala() {
        #expect(
            PresentacionDeEscalaYAcorde.modo(de: Escala(.do, .alterada), en: .compacta(.espanol))
                == "modo 7 de Re♭ menor melódica de jazz")
        #expect(PresentacionDeEscalaYAcorde.modo(de: Escala(.do, .tonosEnteros), en: .compacta(.espanol)) == nil)
    }

    @Test func losAcordesQueCaben() throws {
        let grados = PresentacionDeEscalaYAcorde.acordesQueCaben(Escala(.do, .mayor), en: .compacta(.espanol))
        #expect(grados.count == 7)
        let primero = try #require(grados.first)
        #expect(primero.grado == "1 · Do")
        #expect(primero.cifrados.hasPrefix("Do · "))
        #expect(primero.acordes.contains(Acorde(.do, .mayorSexta)))
        #expect(grados[4].acordes.contains(Acorde("Sol7")))
    }

    @Test func laEscalaDeCadaAcordeDelAnalisis() throws {
        let analisis = try PresentacionDeAnalisis.analizar(
            "Do La7 Rem7 Sol7 Do", en: Tonalidad(.do), notacion: .compacta(.espanol))
        let escalas = analisis.tramos.flatMap(\.filas).map { $0.escala?.nombre }
        #expect(escalas == ["Do mayor", "La frigio dominante", "Re dórico", "Sol mixolidio", "Do mayor"])
        let la7 = try #require(analisis.tramos[0].filas[1].escala)
        #expect(la7.tensiones == "Si♭ ♭9 · Fa ♭13")
        #expect(la7.aEvitar == "Re 11")
        #expect(la7.modo == "modo 5 de Re menor armónica")
    }
}
