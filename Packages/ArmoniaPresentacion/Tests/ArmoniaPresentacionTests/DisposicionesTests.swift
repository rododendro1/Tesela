import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion

// Las disposiciones de piano y jazz de la vista de acordes y la progresión dispuesta de la vista de análisis.
@Suite struct PresentacionDeDisposicionesTests {
    @Test func lasDisposicionesDeUnAcorde() throws {
        let presentadas = try #require(
            PresentacionDeDisposiciones.acorde(Acorde("Do7"), .drop2, notacion: .espanolCompacto))
        #expect(presentadas.filas.first?.voces == "Do₃ Sol₃ Si♭₃ Mi₄")
        #expect(presentadas.filas.allSatisfy { $0.cifrado.isEmpty })
        #expect(presentadas.ficheros.isEmpty)
        #expect(presentadas.sonido.inicios.count == presentadas.filas.count)
        #expect(presentadas.pentagrama.descripcion.hasPrefix("Do7 · Drop 2: Do₃ Sol₃ Si♭₃ Mi₄;"))
        #expect(presentadas.pentagrama.svg.contains("<svg"))
    }

    @Test func unaProgresionDispuesta() throws {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let presentadas = try #require(
            PresentacionDeDisposiciones.progresion(acordes, .drop2, notacion: .espanolCompacto))
        #expect(presentadas.filas.map(\.cifrado) == acordes.map { $0.cifrado(en: .espanolCompacto) })
        #expect(presentadas.filas.allSatisfy { $0.voces.split(separator: " ").count == 4 })
        #expect(presentadas.ficheros.count == 5)
        #expect(presentadas.sonido.notas.count == 12)
        let shells = try #require(
            PresentacionDeDisposiciones.progresion(acordes, .shell, notacion: .espanolCompacto))
        #expect(shells.filas.allSatisfy { $0.voces.split(separator: " ").count == 3 })
    }

    @Test func sinDisposicion() {
        #expect(PresentacionDeDisposiciones.progresion([], .drop2, notacion: .espanolCompacto) == nil)
    }

    @Test func losNombres() {
        #expect(DisposicionDeAcorde.cerrada.nombre(en: .espanolCompacto) == "Cerrada")
        #expect(DisposicionDeAcorde.drop24.nombre(en: .inglesASCII) == "Drop 2 + 4")
        #expect(DisposicionDeAcorde.shell.nombre(en: .inglesASCII) == "Root, third and seventh")
        #expect(DisposicionDeAcorde.notasGuia.nombre(en: .espanolCompacto) == "Tercera y séptima")
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let nombres = DisposicionDeAcorde.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }
}
