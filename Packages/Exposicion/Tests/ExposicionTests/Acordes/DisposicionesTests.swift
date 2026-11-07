import Armonia
import Foundation
import Testing

@testable import Exposicion

// Las disposiciones de piano y jazz de la vista de acordes y la progresión dispuesta de la vista de análisis.
@Suite struct PresentacionDeDisposicionesTests {
    @Test func lasDisposicionesDeUnAcorde() throws {
        let presentadas = try #require(
            PresentacionDeDisposiciones.acorde(Acorde("Do7"), .drop2, en: .espanolCompacto))
        #expect(presentadas.filas.first?.voces == "Do₃ Sol₃ Si♭₃ Mi₄")
        #expect(presentadas.filas.allSatisfy { $0.cifrado.isEmpty })
        #expect(presentadas.ficheros.count == 6)
        #expect(presentadas.sonido.inicios.count == presentadas.filas.count)
        #expect(presentadas.pentagrama.descripcion.hasPrefix("Do7 · Drop 2: Do₃ Sol₃ Si♭₃ Mi₄;"))
        #expect(presentadas.pentagrama.svg.contains("<svg"))
    }

    @Test func unaProgresionDispuesta() throws {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let presentadas = try #require(
            PresentacionDeDisposiciones.progresion(acordes, .drop2, en: .espanolCompacto))
        #expect(presentadas.filas.map(\.cifrado) == acordes.map { $0.cifrado(en: .espanolCompacto) })
        #expect(presentadas.filas.allSatisfy { $0.voces.split(separator: " ").count == 4 })
        #expect(presentadas.ficheros.count == 6)
        #expect(presentadas.sonido.notas.count == 12)
        let shells = try #require(
            PresentacionDeDisposiciones.progresion(acordes, .shell, en: .espanolCompacto))
        #expect(shells.filas.allSatisfy { $0.voces.split(separator: " ").count == 3 })
    }

    @Test func sinDisposicion() {
        #expect(PresentacionDeDisposiciones.acorde(Acorde(.do, .potencia), .shell, en: .espanolCompacto) == nil)
        #expect(PresentacionDeDisposiciones.progresion([], .drop2, en: .espanolCompacto) == nil)
    }

    @Test func losNombres() {
        #expect(DisposicionDeAcorde.cerrada.nombre(en: .espanolCompacto) == "Cerrada")
        #expect(DisposicionDeAcorde.drop24.nombre(en: .inglesASCII) == "Drop 2 + 4")
        #expect(DisposicionDeAcorde.shell.nombre(en: .inglesASCII) == "Root, third and seventh")
        #expect(DisposicionDeAcorde.notasGuia.nombre(en: .espanolCompacto) == "Tercera y séptima")
        #expect(DisposicionDeAcorde.cuartal.nombre(en: .inglesASCII) == "Quartal")
        #expect(DisposicionDeAcorde.sinFundamentalA.nombre(en: .espanolCompacto) == "Sin fundamental (A)")
        #expect(DisposicionDeAcorde.dosManos.nombre(en: .espanolCompacto) == "A dos manos")
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let nombres = DisposicionDeAcorde.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }
}

// Las disposiciones de un acorde en un grupo de cuerdas de la guitarra.
@Suite struct DisposicionesEnElMastilTests {
    @Test func losGruposDeCuerdas() {
        let grupos = PresentacionDeDisposiciones.gruposDeCuerdas(
            .drop2, mastil: Mastil(.guitarra), en: .espanolCompacto)
        #expect(grupos.map(\.nombre) == ["Cuerdas 6-5-4-3", "Cuerdas 5-4-3-2", "Cuerdas 4-3-2-1"])
        #expect(grupos.first?.cuerdas == [0, 1, 2, 3])
    }

    @Test func lasFormasConSusDedos() throws {
        let formas = PresentacionDeDisposiciones.enElMastil(
            Acorde("Do7M"), .drop2, mastil: Mastil(.guitarra), cuerdas: [1, 2, 3, 4])
        let primera = try #require(formas.first)
        #expect(primera.tablatura == "x2201x")
        #expect(primera.dedos == "x 2 3 0 1 x")
        #expect(primera.sonido.notas.count == 4)
        #expect(formas.count > 1)
    }
}
