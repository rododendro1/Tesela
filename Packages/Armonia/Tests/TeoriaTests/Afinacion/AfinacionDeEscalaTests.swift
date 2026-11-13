import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct AfinacionDeEscalaTests {
    private func redondear(_ valores: [Double]) -> [Double] { valores.map { ($0 * 100).rounded() / 100 } }

    /// La escala de blues suena con sus blue notes.
    @Test func elBluesConSusBlueNotes() throws {
        let blues = try #require(Escala(.la, .blues).afinacion())
        #expect(abs(blues.desviacion(de: "Do5") - 50) <= 1e-9)
        #expect(abs(blues.desviacion(de: "Sol4") + 31) <= 1e-9)
    }

    /// Bayātī suena con su Mi𝄳; las notas que no son de la escala, en temperamento igual.
    @Test func unaEscalaMicrotonalComoAfinacion() throws {
        let bayati = try #require(Escala(.re, .bayati).afinacion())
        #expect(abs(bayati.desviacion(de: "Mib4") - 50) <= 1e-9)
        #expect(abs(bayati.desviacion(de: "Mib2") - 50) <= 1e-9)
        // Re♯ es la misma tecla que Mi♭.
        #expect(abs(bayati.desviacion(de: "Re#5") - 50) <= 1e-9)
        #expect(abs(bayati.desviacion(de: "Re4")) <= 1e-9)
        #expect(abs(bayati.desviacion(de: "Mi4")) <= 1e-9)
        #expect(abs(bayati.frecuencia(de: "La4") - 440) <= 1e-9)
        let a442 = try #require(Escala(.re, .bayati).afinacion(la4: 442))
        #expect(abs(a442.frecuencia(de: "La4") - 442) <= 1e-9)
        #expect(abs(a442.cents(desde: "Re4", hasta: "Mib4") - 150) <= 1e-9)
        // Sin versión microtonal no hay afinación.
        #expect(Escala(.do, .mayor).afinacion() == nil)
    }

    /// Otra de sus afinaciones: los echoi de Chrysanthos, con la tónica 12 cents sobre la temperada.
    @Test func otraAfinacionDeLaMismaEscala() throws {
        let chrysanthos = TipoDeEscala.echosProtos.afinaciones[1]
        let protos = try #require(Escala(.re, .echosProtos).afinacion(propia: chrysanthos))
        #expect(protos.afinacionPropia.fuente == .chrysanthos)
        #expect(redondear(["Re4", "Mi4", "Fa4", "Do5"].map { protos.desviacion(de: $0) }) == [12, -29, -6, 0])
        #expect(Escala(.re, .echosProtos).afinacion(propia: TipoDeEscala.bayati.afinacionPropia) == nil)
    }

    /// Los cents de cada grado en un temperamento histórico dependen de la tónica.
    @Test func centsEnUnaAfinacionHistorica() {
        #expect(
            redondear(Escala(.do, .mayor).cents(con: .afinacionJusta)) == [
                0, 203.91, 386.31, 498.04, 701.96, 884.36, 1088.27,
            ])
        #expect(
            redondear(Escala(.re, .protusAuthenticus).cents(con: .pitagorico)) == [
                0, 203.91, 294.13, 498.04, 701.96, 905.87, 996.09,
            ])
        #expect(
            redondear(Escala(.mi, .mayor).cents(con: .temperamentoIgual)) == [0, 200, 400, 500, 700, 900, 1100])
        // En Werckmeister III, la tercera de Do es más pura que la de Re♭.
        let tercerasDeDo = Escala(.do, .mayor).cents(con: .werckmeisterIII)[2]
        let tercerasDeReBemol = Escala(Nota(.re, .bemol), .mayor).cents(con: .werckmeisterIII)[2]
        #expect(abs(tercerasDeDo - 390.22) <= 0.01)
        #expect(abs(tercerasDeReBemol - 407.82) <= 0.01)
        // Al bajar, la menor melódica es la natural.
        #expect(
            redondear(Escala(.la, .menorMelodica).cents(con: .temperamentoIgual, sentido: .descendente)) == [
                0, 200, 300, 500, 700, 800, 1000,
            ])
    }

    @Test func laAfinacionDeCadaTradicion() {
        #expect(TipoDeEscala.protusAuthenticus.temperamentoSugerido == .pitagorico)
        #expect(Tradicion.india.temperamentoSugerido == .afinacionJusta)
        #expect(Tradicion.mundoArabe.temperamentoSugerido == nil)
        // Las occidentales, por su uso: los modos del Renacimiento, en mesotónico; la tonalidad, en un buen
        // temperamento; lo demás, en el igual.
        #expect(TipoDeEscala.dorico.temperamentoSugerido == .mesotonicoCuartoDeComa)
        #expect(TipoDeEscala.mayor.temperamentoSugerido == .werckmeisterIII)
        #expect(TipoDeEscala.menorArmonica.temperamentoSugerido == .werckmeisterIII)
        #expect(TipoDeEscala.alterada.temperamentoSugerido == .temperamentoIgual)
        #expect(TipoDeEscala.tonosEnteros.temperamentoSugerido == .temperamentoIgual)
        #expect(Estilo.blues.temperamentoSugerido == .temperamentoIgual)
        #expect(TipoDeEscala(nombre: "mía", intervalos: [.unisono, .segundaMayor]).temperamentoSugerido == nil)
    }
}
