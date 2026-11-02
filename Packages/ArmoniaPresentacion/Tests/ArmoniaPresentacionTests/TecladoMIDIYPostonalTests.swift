import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// Lo que se lee de un teclado MIDI y lo que se muestra en teoría postonal. No usa CoreMIDI: se ejecuta también
// en Linux.

@Suite struct TecladoMIDIYPostonalTests {
    @Test func seLeenLasNotasPulsadasYSoltadas() {
        #expect(CambioMIDI(ump: 0x2090_3C64) == CambioMIDI(midi: 60, pulsada: true))
        #expect(CambioMIDI(ump: 0x2080_3C40) == CambioMIDI(midi: 60, pulsada: false))
        // «Note on» con velocidad 0 es soltarla; el canal no importa.
        #expect(CambioMIDI(ump: 0x2093_4000) == CambioMIDI(midi: 64, pulsada: false))
        #expect(CambioMIDI(ump: 0x209F_4301) == CambioMIDI(midi: 67, pulsada: true))
        // Otros mensajes (un control, o MIDI 2.0), nada.
        #expect(CambioMIDI(ump: 0x20B0_4000) == nil)
        #expect(CambioMIDI(ump: 0x4090_3C00) == nil)
    }

    @Test func lasPulsadasVanEnElOrdenEnQueSePulsaron() {
        let cambios = [
            CambioMIDI(midi: 64, pulsada: true), CambioMIDI(midi: 60, pulsada: true),
            CambioMIDI(midi: 67, pulsada: true), CambioMIDI(midi: 64, pulsada: false),
        ]
        #expect(CambioMIDI.aplicar(cambios, a: []) == [60, 67])
        #expect(CambioMIDI.aplicar([CambioMIDI(midi: 60, pulsada: true)], a: [60]) == [60])
    }

    @Test func elAcordeSeQuedaAlSoltarloHastaQueEmpiezaOtro() {
        // Se pulsa Do–Mi–Sol nota a nota: crece.
        #expect(CambioMIDI.retener([], antes: [], ahora: [60]) == [60])
        #expect(CambioMIDI.retener([60], antes: [60], ahora: [60, 64]) == [60, 64])
        #expect(CambioMIDI.retener([60, 64], antes: [60, 64], ahora: [60, 64, 67]) == [60, 64, 67])
        // Al soltarlo, se queda.
        #expect(CambioMIDI.retener([60, 64, 67], antes: [60, 64, 67], ahora: [64, 67]) == [60, 64, 67])
        #expect(CambioMIDI.retener([60, 64, 67], antes: [64, 67], ahora: []) == [60, 64, 67])
        // Con todo suelto, la siguiente tecla empieza otro.
        #expect(CambioMIDI.retener([60, 64, 67], antes: [], ahora: [62]) == [62])
    }

    @Test func lasClasesVanDeLaMasGraveALaMasAguda() {
        #expect(CambioMIDI.clases(de: [67, 52, 60, 64]) == [4, 0, 7])
        #expect(CambioMIDI.clases(de: []) == [])
    }

    @Test func laTeoriaPostonalDeUnaTriada() {
        let mayor = AnalisisPostonalPresentado(clases: [60, 64, 67, 72])
        #expect(mayor.formaPrima == "(0, 3, 7)")
        #expect(mayor.numeroDeForte == "3-11")
        #expect(mayor.vectorIntervalico == "⟨0, 0, 1, 1, 1, 0⟩")
        // La menor es la misma clase de conjuntos.
        #expect(AnalisisPostonalPresentado(clases: [9, 0, 4]) == mayor)
        #expect(AnalisisPostonalPresentado(clases: [0, 4, 7, 10]).numeroDeForte == "4-27")
    }
}
