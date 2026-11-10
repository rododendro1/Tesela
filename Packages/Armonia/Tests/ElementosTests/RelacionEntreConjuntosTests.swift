import Testing

@testable import Elementos

/// Lo que se parecen dos conjuntos de clases de altura: Fourier, Isaacson, Morris y Forte.
@Suite struct RelacionEntreConjuntosTests {
    @Test func mismoContenido() {
        // La tríada mayor y la menor, y los dos conjuntos Z de cuatro notas, tienen el mismo vector.
        let triadas = ConjuntoDeClasesDeAltura([0, 4, 7]).relacion(con: [0, 3, 7])
        #expect(casi(triadas.distanciaDeFourier, 0))
        #expect(triadas.distanciaIntervalica == 0)
        #expect(triadas.asimilitudDeMorris == 0)
        #expect(triadas.relacionDeForte == nil)
        #expect(!triadas.relacionRp)
        let z = ConjuntoDeClasesDeAltura([0, 1, 4, 6]).relacion(con: [0, 1, 3, 7])
        #expect(casi(z.distanciaDeFourier, 0))
    }

    @Test func distintos() {
        // El cromático de tres notas y el aumentado no comparten ningún intervalo.
        let relacion = ConjuntoDeClasesDeAltura([0, 1, 2]).relacion(con: [0, 4, 8])
        #expect(relacion.asimilitudDeMorris == 1)
        #expect(casi(relacion.distanciaDeFourier, 4.472))
        #expect(casi(relacion.distanciaIntervalica, 1.528))
        // Coinciden en los ceros: no es R0, que pide que no coincida ninguna entrada.
        #expect(relacion.relacionDeForte == nil)
        #expect(!relacion.relacionRp)
    }

    @Test func relacionesDeForte() {
        // 4-1 [3,2,1,0,0,0] y 4-2 [2,2,1,1,0,0]: difieren en dos entradas que no se intercambian.
        #expect(RelacionEntreConjuntos.relacionDeForte([3, 2, 1, 0, 0, 0], [2, 2, 1, 1, 0, 0]) == .r2)
        #expect(RelacionEntreConjuntos.relacionDeForte([2, 1, 1, 1, 1, 0], [1, 2, 1, 1, 1, 0]) == .r1)
        #expect(RelacionEntreConjuntos.relacionDeForte([1, 1, 1, 1, 1, 1], [2, 0, 2, 0, 2, 0]) == .r0)
        // Do Re Mi y Do Re Fa♯ comparten Do–Re.
        #expect(ConjuntoDeClasesDeAltura([0, 2, 4]).relacion(con: [0, 2, 6]).relacionRp)
        #expect(ConjuntoDeClasesDeAltura([0, 4, 7]).relacion(con: [0, 1, 2, 3]).relacionDeForte == nil)
    }
}
