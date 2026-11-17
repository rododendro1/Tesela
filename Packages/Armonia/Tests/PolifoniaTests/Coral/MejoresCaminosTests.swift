import Testing

@testable import Polifonia

/// La búsqueda de los caminos de menor coste que usan el armonizador y el coral.
@Suite struct MejoresCaminosTests {
    @Test func elMejorYLosKMejores() {
        // Dos pasos de dos estados; empezar en el 1 cuesta 1 y cambiar de estado cuesta 1.
        let inicio: (Int) -> Double? = { Double($0) }
        let paso: (Int, Int, Int) -> Double? = { _, a, b in a == b ? 0 : 1 }
        let uno = MejoresCaminos.buscar(estados: [2, 2], inicio: inicio, paso: paso)
        #expect(uno.map(\.estados) == [[0, 0], [0, 1]] && uno.map(\.coste) == [0, 1])
        // Con dos por estado, también los que vienen del 1: a igual coste, antes el que viene del 0.
        let dos = MejoresCaminos.buscar(estados: [2, 2], mejores: 2, inicio: inicio, paso: paso)
        #expect(dos.map(\.estados) == [[0, 0], [0, 1], [1, 1], [1, 0]])
        #expect(dos.map(\.coste) == [0, 1, 1, 2])
    }

    @Test func loQueNoSePuedeYElFinal() {
        // El estado 0 del segundo paso no se alcanza, y terminar viniendo del 1 cuesta 5.
        let caminos = MejoresCaminos.buscar(
            estados: [2, 2], inicio: { $0 == 0 ? 0 : nil }, paso: { _, _, b in b == 0 ? nil : 1 },
            final: { penultimo, _ in penultimo == 1 ? 5 : 0 })
        #expect(caminos.map(\.estados) == [[0, 1]] && caminos[0].coste == 1)
        // Con un solo paso, el final se suma al empezar.
        let solo = MejoresCaminos.buscar(
            estados: [2], inicio: { Double($0) }, paso: { _, _, _ in 0 },
            final: { _, u in
                u == 0 ? 3 : 0
            })
        #expect(solo.map(\.estados) == [[1], [0]])
        #expect(MejoresCaminos.buscar(estados: [], inicio: { _ in 0 }, paso: { _, _, _ in 0 }).isEmpty)
        #expect(MejoresCaminos.buscar(estados: [1, 0], inicio: { _ in 0 }, paso: { _, _, _ in 0 }).isEmpty)
        #expect(MejoresCaminos.buscar(estados: [1, 1], inicio: { _ in 0 }, paso: { _, _, _ in nil }).isEmpty)
    }
}
