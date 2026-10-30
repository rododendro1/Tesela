import XCTest
import Armonia
@testable import ArmoniaPresentacion

// Lo que se lee de un teclado MIDI y lo que se muestra en teoría postonal. No usa CoreMIDI: se ejecuta también
// en Linux.

final class TecladoMIDIYPostonalTests: XCTestCase {
    func testSeLeenLasNotasPulsadasYSoltadas() {
        XCTAssertEqual(CambioMIDI(ump: 0x2090_3C64), CambioMIDI(midi: 60, pulsada: true))
        XCTAssertEqual(CambioMIDI(ump: 0x2080_3C40), CambioMIDI(midi: 60, pulsada: false))
        // «Note on» con velocidad 0 es soltarla; el canal no importa.
        XCTAssertEqual(CambioMIDI(ump: 0x2093_4000), CambioMIDI(midi: 64, pulsada: false))
        XCTAssertEqual(CambioMIDI(ump: 0x209F_4301), CambioMIDI(midi: 67, pulsada: true))
        // Otros mensajes (un control, o MIDI 2.0), nada.
        XCTAssertNil(CambioMIDI(ump: 0x20B0_4000))
        XCTAssertNil(CambioMIDI(ump: 0x4090_3C00))
    }

    func testLasPulsadasVanEnElOrdenEnQueSePulsaron() {
        let cambios = [CambioMIDI(midi: 64, pulsada: true), CambioMIDI(midi: 60, pulsada: true),
                       CambioMIDI(midi: 67, pulsada: true), CambioMIDI(midi: 64, pulsada: false)]
        XCTAssertEqual(CambioMIDI.aplicar(cambios, a: []), [60, 67])
        XCTAssertEqual(CambioMIDI.aplicar([CambioMIDI(midi: 60, pulsada: true)], a: [60]), [60])
    }

    func testElAcordeSeQuedaAlSoltarloHastaQueEmpiezaOtro() {
        // Se pulsa Do–Mi–Sol nota a nota: crece.
        XCTAssertEqual(CambioMIDI.retener([], antes: [], ahora: [60]), [60])
        XCTAssertEqual(CambioMIDI.retener([60], antes: [60], ahora: [60, 64]), [60, 64])
        XCTAssertEqual(CambioMIDI.retener([60, 64], antes: [60, 64], ahora: [60, 64, 67]), [60, 64, 67])
        // Al soltarlo, se queda.
        XCTAssertEqual(CambioMIDI.retener([60, 64, 67], antes: [60, 64, 67], ahora: [64, 67]), [60, 64, 67])
        XCTAssertEqual(CambioMIDI.retener([60, 64, 67], antes: [64, 67], ahora: []), [60, 64, 67])
        // Con todo suelto, la siguiente tecla empieza otro.
        XCTAssertEqual(CambioMIDI.retener([60, 64, 67], antes: [], ahora: [62]), [62])
    }

    func testLasClasesVanDeLaMasGraveALaMasAguda() {
        XCTAssertEqual(CambioMIDI.clases(de: [67, 52, 60, 64]), [4, 0, 7])
        XCTAssertEqual(CambioMIDI.clases(de: []), [])
    }

    func testLaTeoriaPostonalDeUnaTriada() {
        let mayor = PresentacionPostonal(clases: [60, 64, 67, 72])
        XCTAssertEqual(mayor.formaPrima, "(0, 3, 7)")
        XCTAssertEqual(mayor.numeroDeForte, "3-11")
        XCTAssertEqual(mayor.vectorIntervalico, "⟨0, 0, 1, 1, 1, 0⟩")
        // La menor es la misma clase de conjuntos.
        XCTAssertEqual(PresentacionPostonal(clases: [9, 0, 4]), mayor)
        XCTAssertEqual(PresentacionPostonal(clases: [0, 4, 7, 10]).numeroDeForte, "4-27")
    }
}
