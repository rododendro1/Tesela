import Testing

@testable import Elementos
@testable import Partituras
@testable import Teoria

@Suite struct RitmoConNombreVozTests {
    /// El compás de un ciclo, reducido mientras se pueda.
    @Test func compas() {
        #expect(RitmoConNombre.claveDeSon.compas.description == "4/4")
        #expect(RitmoConNombre.bembe.compas.description == "12/8")
        #expect(RitmoConNombre.claveDeSon.pulso == Duracion(1, 16))
        #expect(RitmoConNombre.tresillo.duraciones == [Duracion(3, 8), Duracion(3, 8), Duracion(1, 4)])
    }

    /// La voz de un ritmo: un silencio hasta el primer golpe, y los fuertes con acento.
    @Test func voz() {
        let tresillo = RitmoConNombre.tresillo.voz()
        #expect(tresillo.eventos.count == 3)
        #expect(tresillo.eventos.allSatisfy { $0.articulaciones.contains(.acento) })
        let dosTres = RitmoConNombre.claveDeSonDosTres.voz(ciclos: 2)
        #expect(dosTres.eventos.count == 11)
        #expect(dosTres.eventos.first?.alturas.isEmpty == true)
        #expect(dosTres.eventos.first?.duracion == Duracion(1, 8))
        let total = dosTres.eventos.map(\.duracion).reduce(Duracion(0, 1), +)
        #expect(total == Duracion(2, 1))
        let debil = RitmoConNombre(nombre: "mío", patron: "x.o.", unidad: 8, familia: .danza).voz()
        #expect(debil.eventos.map(\.articulaciones.isEmpty) == [false, true])
        #expect(RitmoConNombre(nombre: "nada", patron: "....", familia: .danza).voz().eventos.isEmpty)
        #expect(RitmoConNombre.tresillo.voz(ciclos: 0).eventos.isEmpty)
    }
}
