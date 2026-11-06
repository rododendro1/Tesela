import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaFormatos
@testable import ArmoniaElementos
@testable import ArmoniaPartitura
@testable import ArmoniaDiagramas

/// El MIDI en las afinaciones del catálogo: cada nota se aparta de la temperada lo que diga la afinación.
@Suite struct MIDIEnUnaAfinacionTests {
    @Test(arguments: [AfinacionHistorica.mesotonico, .werckmeisterIII, .justa])
    func unAcordeEnUnaAfinacionHistorica(_ historica: AfinacionHistorica) throws {
        let afinacion = historica.afinacion()
        let voz = try Voz(leyendo: "Do4+Mi4+Sol4:2 Re4+Fa♯4+La4:2")
        let pieza = try PiezaImportada(midi: voz.partitura().midi(afinacion: afinacion))
        // Todo en una parte, aunque las notas vayan por varios canales.
        #expect(Set(pieza.notas.map(\.parte)) == [0])
        let esperadas: [Altura] = ["Do4", "Mi4", "Sol4", "Re4", "Fa♯4", "La4"]
        #expect(pieza.notas.map(\.altura.midi) == esperadas.map(\.midi))
        for (nota, altura) in zip(pieza.notas, esperadas) {
            #expect(abs(nota.desvio - afinacion.desviacion(de: altura)) < 0.05)
        }
    }

    @Test func unTemperamentoRegular() throws {
        let voz = try Voz(leyendo: "Do4:4 Mi4:4")
        let mesotonico = TemperamentoRegular.mesotonicoCuartoDeComa
        let pieza = try PiezaImportada(midi: voz.partitura().midi(afinacion: mesotonico))
        // La tercera mayor pura: 386 cents, 14 menos que la temperada.
        let tercera = 400 + pieza.notas[1].desvio - pieza.notas[0].desvio
        #expect(abs(tercera - 386.31) < 0.05)
    }
}
