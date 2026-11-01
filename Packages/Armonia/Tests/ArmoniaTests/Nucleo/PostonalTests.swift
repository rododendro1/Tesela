import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct ConjuntoDeClasesTests {
    @Test func formasYNombres() {
        let mayor: ConjuntoDeClases = [0, 4, 7]
        #expect(mayor.formaPrima == [0, 3, 7])
        #expect(mayor.numeroDeForte == "3-11")
        #expect(mayor.vectorIntervalico == [0, 0, 1, 1, 1, 0])
        #expect(mayor.nombreComun == "tríada mayor o menor")
        #expect(ConjuntoDeClases([7, 0, 4]).formaNormal == [0, 4, 7])
        #expect(ConjuntoDeClases([11, 2, 7]).formaNormal == [7, 11, 2])
        #expect(ConjuntoDeClases([12, 16, 19, 4]) == mayor)

        let quinto: ConjuntoDeClases = [0, 1, 3, 7, 8]
        #expect(quinto.formaPrima == [0, 1, 3, 7, 8])
        #expect(quinto.formaPrimaRahn == [0, 1, 5, 6, 8])
        #expect(quinto.numeroDeForte == "5-20")
        #expect(ConjuntoDeClases([Int]()).numeroDeForte == nil)
    }

    @Test func operaciones() {
        let mayor: ConjuntoDeClases = [0, 4, 7]
        #expect(mayor.transponer(2) == [2, 6, 9])
        #expect(mayor.invertir() == [0, 5, 8])
        #expect(mayor.esDeLaMismaClase(que: mayor.invertir(3)))
        #expect(Escala(.do).conjuntoDeClases.complemento.numeroDeForte == "5-35")
        #expect(ConjuntoDeClases([0, 4]).esSubconjunto(de: mayor))
        #expect(mayor.unir(con: [2]) == [0, 2, 4, 7])
        #expect(mayor.intersecar(con: [4, 5, 7]) == [4, 7])
    }

    @Test func relacionZYSimetrias() {
        let a: ConjuntoDeClases = [0, 1, 4, 6]
        let b: ConjuntoDeClases = [0, 1, 3, 7]
        #expect(a.numeroDeForte == "4-Z15")
        #expect(b.numeroDeForte == "4-Z29")
        #expect(a.estaEnRelacionZ(con: b))
        #expect(!a.estaEnRelacionZ(con: a.transponer(5)))
        #expect(ConjuntoDeClases([0, 4, 8]).simetriasPorTransposicion == 3)
        #expect(ConjuntoDeClases([0, 2, 4, 6, 8, 10]).simetriasPorTransposicion == 6)
        #expect(ConjuntoDeClases([0, 3, 6, 9]).simetriasPorInversion == 4)
        #expect(ConjuntoDeClases([0, 4, 7]).simetriasPorTransposicion == 1)
        #expect(ConjuntoDeClases([0, 4, 7]).simetriasPorInversion == 0)
    }

    @Test func integracion() {
        #expect(Escala(.re).conjuntoDeClases.numeroDeForte == "7-35")
        #expect(Escala(.do, .menorMelodica).conjuntoDeClases.numeroDeForte == "7-34")
        #expect(Escala(.do, .disminuida).conjuntoDeClases.numeroDeForte == "8-28")
        #expect(Acorde("Sol7").conjuntoDeClases.numeroDeForte == "4-27")
        #expect(Acorde("Sim7b5").conjuntoDeClases.numeroDeForte == "4-27")
        #expect(Acorde("Do°7").conjuntoDeClases.nombreComun == "séptima disminuida")
    }
}
