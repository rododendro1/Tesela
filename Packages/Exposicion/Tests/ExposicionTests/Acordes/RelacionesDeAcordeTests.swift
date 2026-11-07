import Armonia
import Testing

@testable import Exposicion

// Las relaciones de un acorde suelto y la comparación de dos, de la vista de acordes y de `armonia acorde`.
@Suite struct PresentacionDeRelacionesDeAcordeTests {
    @Test func lasRelacionesDeUnAcorde() {
        let do6 = PresentacionDeRelacionesDeAcorde.relaciones(de: Acorde("Do6"), notacion: .espanolCompacto)
        #expect(do6.otrosNombres.contains("Lam7/Do"))
        let do7M = PresentacionDeRelacionesDeAcorde.relaciones(de: Acorde("Do7M"), notacion: .espanolCompacto)
        #expect(do7M.sinFundamental == "Mim")
        #expect(do6.tonalidad == Tonalidad(.do))

        let rem7 = PresentacionDeRelacionesDeAcorde.relaciones(de: Acorde("Rem7"), notacion: .espanolCompacto)
        #expect(rem7.tonalidades.first == "ii7 en Do mayor · subdominante")

        let sol7 = PresentacionDeRelacionesDeAcorde.relaciones(de: Acorde("Sol7"), notacion: .espanolCompacto)
        let tritonal = Acorde("Reb7").cifrado(en: .espanolCompacto)
        let disminuido = Acorde("Si°7").cifrado(en: .espanolCompacto)
        #expect(sol7.sustituciones.contains { $0.texto == tritonal })
        #expect(sol7.sustituciones.contains { $0.rearmonizacion.recurso == .disminuido && $0.texto == disminuido })
        #expect(sol7.sustituciones.allSatisfy { !$0.descripcion.isEmpty && !$0.sonido.notas.isEmpty })
    }

    @Test func enOtraTonalidad() {
        let relaciones = PresentacionDeRelacionesDeAcorde.relaciones(
            de: Acorde("Do"), en: Tonalidad(.sol), notacion: .inglesASCII)
        #expect(relaciones.tonalidad == Tonalidad(.sol))
        #expect(relaciones.sustituciones.contains { $0.texto == "Am" })
        #expect(relaciones.sinFundamental == nil)
    }

    @Test func dosAcordesComparados() throws {
        let quintaATonica = try #require(
            PresentacionDeRelacionesDeAcorde.comparar(Acorde("Sol7"), con: Acorde("Do"), en: .espanolCompacto))
        #expect(quintaATonica.comunes == "Sol")
        #expect(quintaATonica.voces.count == 4)
        #expect(quintaATonica.voces.allSatisfy { $0.contains(" → ") && $0.hasSuffix(")") })
        #expect(quintaATonica.voces.contains { $0.contains("(+") })
        #expect(quintaATonica.voces.contains { $0.contains("(-") })
        let total = quintaATonica.comparacion.movimientoTotal
        #expect(quintaATonica.movimiento == "Movimiento total: \(total) semitonos")
        #expect(quintaATonica.sonido.notas.count == 8)

        let lejos = try #require(
            PresentacionDeRelacionesDeAcorde.comparar(Acorde("Do"), con: Acorde("Fa#"), en: .espanolCompacto))
        #expect(lejos.comunes == "ninguna")
        #expect(
            PresentacionDeRelacionesDeAcorde.comparar(
                Acorde(.do, .potencia), con: Acorde("Sol"), disposicion: .shell, en: .espanolCompacto) == nil)
    }
}
