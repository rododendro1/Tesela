import Foundation
import Testing

@testable import Elementos
@testable import Teoria

@Suite struct DisposicionDeAcordeTests {
    private func midis(_ alturas: [Altura]) -> [Int] { alturas.map(\.midi) }

    @Test func lasNotasQueSeDisponen() {
        #expect(Acorde("Do").notasParaDisponer == [.do, .mi, .sol])
        #expect(Acorde("Do7").notasParaDisponer.map(\.nombre) == ["Do", "Mi", "Sol", "Si♭"])
        // De más de cuatro notas: sin la fundamental ni la quinta.
        let novena = Acorde("Do9").notasParaDisponer
        #expect(novena.count == 4)
        #expect(!novena.contains(.sol))
        #expect(novena.contains(.mi) && novena.contains(.re))
    }

    @Test func lasNotasGuia() {
        #expect(Acorde("Sol7").notasGuia.map(\.nombre) == ["Si", "Fa"])
        #expect(Acorde("Do6").notasGuia.map(\.nombre) == ["Mi", "La"])
        #expect(Acorde("Do").notasGuia.map(\.nombre) == ["Mi", "Sol"])
    }

    @Test func drop2() {
        let todas = Acorde("Do7").disposiciones(.drop2, en: 48...72)
        #expect(todas.first.map(midis) == [48, 55, 58, 64])
        for alturas in todas {
            #expect(alturas.count == 4)
            #expect(alturas.allSatisfy { (48...72).contains($0.midi) })
            #expect(Set(alturas.map(\.nota)) == Set(Acorde("Do7").notas))
            #expect(midis(alturas) == midis(alturas).sorted())
            // Abierta: la voz que baja deja más de una octava entre la más grave y la más aguda.
            #expect(alturas[3].midi - alturas[0].midi > 12)
        }
    }

    @Test func cerradaYDrops() {
        for alturas in Acorde("Do7M").disposiciones(.cerrada) {
            #expect(alturas[3].midi - alturas[0].midi < 12)
        }
        // Una tríada cerrada dobla la nota del bajo una octava más arriba.
        for alturas in Acorde("Do").disposiciones(.cerrada) {
            #expect(alturas[3].midi - alturas[0].midi == 12)
        }
        for disposicion in [DisposicionDeAcorde.drop3, .drop24] {
            let todas = Acorde("Rem7").disposiciones(disposicion)
            #expect(!todas.isEmpty)
            #expect(todas.allSatisfy { $0.count == 4 && Set($0.map(\.nota)) == Set(Acorde("Rem7").notas) })
        }
    }

    @Test func shellYNotasGuia() {
        let shells = Acorde("Do7").disposiciones(.shell)
        #expect(shells.first.map(midis) == [48, 52, 58])
        #expect(shells.allSatisfy { $0.count == 3 && $0[0].nota == .do })
        let guias = Acorde("Do7").disposiciones(.notasGuia)
        #expect(guias.allSatisfy { $0.count == 2 && Set($0.map(\.nota)) == Set(Acorde("Do7").notasGuia) })
        #expect(DisposicionDeAcorde.allCases.map(\.voces) == [4, 4, 4, 4, 3, 2, 4, 4, 4, 5])
    }

    @Test func sinFundamentalYADosManos() {
        // Sol7: la A es Si Mi Fa La (con la 13.ª en lugar de la quinta) y la B, Fa La Si Mi.
        #expect(Acorde("Sol7").disposiciones(.sinFundamentalA).map(midis) == [[59, 64, 65, 69]])
        #expect(Acorde("Sol7").disposiciones(.sinFundamentalB).map(midis) == [[53, 57, 59, 64], [65, 69, 71, 76]])
        // Do7M: tercera, quinta, séptima y novena.
        let doMayor = Acorde("Do7M").disposiciones(.sinFundamentalA)
        #expect(!doMayor.isEmpty)
        #expect(doMayor.allSatisfy { Set($0.map(\.nota)) == [.mi, .sol, .si, .re] })
        let doSexta = Acorde("Do6").disposiciones(.sinFundamentalB)
        #expect(!doSexta.isEmpty)
        #expect(doSexta.allSatisfy { Set($0.map(\.nota)) == [.mi, .sol, .la, .re] })
        // A dos manos: Do y Si♭ abajo; Mi, La y Re arriba.
        #expect(Acorde("Do7").disposiciones(.dosManos).map(midis) == [[48, 58, 64, 69, 74]])
        // Sin séptima ni sexta no hay disposición sin fundamental.
        #expect(Acorde("Do").disposiciones(.sinFundamentalA).isEmpty)
    }

    @Test func laConduccionDeUnIIVI() throws {
        let acordes = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let pasos = try #require(DisposicionDeAcorde.drop2.conducir(acordes))
        #expect(pasos.count == 3)
        // Lo mínimo: Do → Si y La → Sol; luego Re → Do y Fa → Mi.
        let movimiento = zip(pasos, pasos.dropFirst()).map { a, b in
            zip(a, b).map { abs($0.midi - $1.midi) }.reduce(0, +)
        }
        #expect(movimiento == [3, 3])
        let septima = try #require(pasos[0].firstIndex { $0.nota == .do })
        #expect(pasos[1][septima].nota == .si)
        #expect(pasos[1][septima].midi == pasos[0][septima].midi - 1)
    }

    @Test func sinDisposicionNoHayConduccion() {
        #expect(DisposicionDeAcorde.drop2.conducir([]) == [])
        // Nada cabe en un ámbito de un semitono.
        #expect(DisposicionDeAcorde.drop2.conducir([Acorde("Do")], en: 60...61) == nil)
    }
}
