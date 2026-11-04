import Foundation
import Testing

@testable import ArmoniaFormatos
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// Con datos que no casan (los de una pieza importada, los de quien usa una app), un error en vez de detener el
/// programa.
@Suite struct ErrorDePartituraTests {
    @Test func unaProgresionConMasOMenosDuracionesQueAcordes() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do")
        #expect(throws: ErrorDePartitura(.duracionesPorAcorde(acordes: 4, duraciones: 2))) {
            try analisis.partitura(duraciones: [.blanca, .negra])
        }
        #expect(throws: ErrorDePartitura(.duracionNoPositiva(indice: 1))) {
            try analisis.partitura(duraciones: [.blanca, .cero, .negra, .negra])
        }
        #expect(try analisis.partitura(duraciones: Array(repeating: .negra, count: 4)).pentagramas.count == 2)
    }

    @Test func unArpegioConSuRitmoQueNoCasa() {
        let acordes = [Acorde("Do"), Acorde("Sol")]
        #expect(throws: ErrorDePartitura(.duracionesPorAcorde(acordes: 2, duraciones: 1))) {
            try Voz(arpegiando: acordes, duraciones: [.redonda])
        }
        #expect(throws: ErrorDePartitura(.figuraSinDuracion)) {
            try Voz(arpegiando: acordes, duraciones: [.blanca, .blanca], figura: .cero)
        }
    }

    @Test func elMensajeEnCadaIdioma() {
        let errores = [
            ErrorDePartitura(.figuraSinDuracion), ErrorDePartitura(.duracionesPorAcorde(acordes: 4, duraciones: 2)),
            ErrorDePartitura(.duracionNoPositiva(indice: 1)),
        ]
        #expect(
            errores.map(\.description) == [
                "la figura de un arpegio tiene que durar algo",
                "hace falta una duración por acorde: hay 4 acordes y 2 duraciones",
                "la duración del acorde 2 tiene que ser positiva",
            ])
        #expect(errores[2].descripcion(en: .inglesASCII) == "the duration of chord 2 must be positive")
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            for error in errores {
                #expect(!error.descripcion(en: notacion).isEmpty, "\(error.motivo) en \(idioma)")
            }
        }
    }

    /// Un instrumento fuera de los de General MIDI se lleva al más cercano, en vez de detener el programa.
    @Test func unInstrumentoFueraDeGeneralMIDI() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4")
        func midi(_ instrumento: Int) -> Data { voz.partitura(encabezado: Encabezado(instrumento: instrumento)).midi() }
        #expect(midi(200) == midi(127))
        #expect(midi(-3) == midi(0))
        #expect(midi(200) != midi(0))
    }
}
