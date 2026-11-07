import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Lo que se sabe de un acorde suelto mirando a los demás: otros nombres, tonalidades, comparaciones y sustituciones.
@Suite struct RelacionesDeAcordeTests {
    @Test func otrosNombres() {
        #expect(Acorde("Do6").otrosNombres.contains(Acorde("Lam7/Do")))
        #expect(!Acorde("Do6").otrosNombres.contains(Acorde("Do6")))
        // Un disminuido con séptima se llama igual desde cualquiera de sus notas, sin bajo.
        let disminuidos = Acorde("Do°7").otrosNombres.filter { $0.tipo == .disminuidoSeptima }
        #expect(Set(disminuidos.map(\.fundamental.claseDeAltura)) == [3, 6, 9])
        #expect(disminuidos.allSatisfy { $0.bajo == $0.fundamental })
    }

    @Test func sinLaFundamental() {
        #expect(Acorde("Do7M").sinFundamental == Acorde("Mim"))
        #expect(Acorde("Sol7(b9)").sinFundamental == Acorde("Si°7"))
        #expect(Acorde("Do").sinFundamental == nil)
    }

    @Test func enQueTonalidadesEsta() {
        let rem7 = Acorde("Rem7").tonalidades
        #expect(rem7.first?.description == "ii7 en Do mayor")
        #expect(rem7.contains { $0.tonalidad == Tonalidad(.fa) })
        #expect(rem7.contains { $0.tonalidad == Tonalidad(Nota.si.bemol) })
        #expect(!rem7.contains { $0.tonalidad == Tonalidad(.sol) })
        #expect(rem7.allSatisfy { $0.acordes.first?.categoria == .diatonico })
        // Las de menos alteraciones primero.
        let alteraciones = rem7.map { abs($0.tonalidad.armadura) }
        #expect(alteraciones == alteraciones.sorted())
        // En menor cuentan el sexto y el séptimo grados elevados: Sol7 es la dominante de Do menor.
        #expect(Acorde("Sol7").tonalidades.contains { $0.tonalidad == Tonalidad(.do, .menor) })
    }

    @Test func compararDosAcordes() throws {
        let quintaATonica = try #require(Acorde("Sol7").comparar(con: Acorde("Do")))
        #expect(quintaATonica.comunes == [.sol])
        #expect(quintaATonica.desde.count == 4 && quintaATonica.hasta.count == 4)
        #expect(quintaATonica.movimientoTotal == quintaATonica.movimientos.map(abs).reduce(0, +))
        #expect(quintaATonica.movimientoTotal <= 4)
        #expect(Acorde("Do7M").comparar(con: Acorde("Lam7"))?.comunes == [.do, .mi, .sol])
        // Sin tercera no hay shell.
        #expect(Acorde(.do, .potencia).comparar(con: Acorde("Sol"), disposicion: .shell) == nil)
    }

    @Test func dominantesYTonalidadPropia() {
        #expect(Acorde("Sol7").esDeDominante)
        #expect(Acorde("Sol9").esDeDominante)
        #expect(!Acorde("Do7M").esDeDominante)
        #expect(!Acorde("Do").esDeDominante)
        #expect(Acorde("Sol7").tonalidadPropia == Tonalidad(.do))
        #expect(Acorde("Lam").tonalidadPropia == Tonalidad(.la, .menor))
        #expect(Acorde("Do").tonalidadPropia == Tonalidad(.do))
    }

    @Test func sustituciones() {
        let sol7 = Acorde("Sol7").sustituciones()
        func acordes(_ recurso: Rearmonizacion.Recurso) -> [Acorde]? {
            sol7.first { $0.recurso == recurso }?.acordes
        }
        #expect(acordes(.sustitutoTritonal) == [Acorde(Nota.re.bemol, .dominanteSeptima)])
        #expect(acordes(.iiRelativo) == [Acorde("Rem7"), Acorde("Sol7")])
        #expect(acordes(.disminuido) == [Acorde(.si, .disminuidoSeptima)])
        #expect(sol7.allSatisfy { $0.posicion == 0 && $0.original == Acorde("Sol7") })
        // Fuera de las dominantes no hay ii relativo ni disminuido; en Sol mayor, Do es el IV y su sustituto, Lam.
        let enSol = Acorde("Do").sustituciones(en: Tonalidad(.sol))
        #expect(!enSol.contains { $0.recurso == .iiRelativo || $0.recurso == .disminuido })
        #expect(enSol.contains { $0.recurso == .sustitutoDiatonico && $0.acordes == [Acorde("Lam")] })
    }
}
