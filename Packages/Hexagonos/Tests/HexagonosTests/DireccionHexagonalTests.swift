import Foundation
import Testing

@testable import Hexagonos

@Suite struct DireccionHexagonalTests {
    @Test func elPasoEsElDeLasDirecciones() {
        #expect(DireccionHexagonal.allCases.map(\.paso) == CoordenadaAxial.direcciones)
        #expect(DireccionHexagonal.allCases.map(\.numero) == Array(0..<6))
        // El nombre dice qué coordenada cúbica sube y cuál baja.
        let q = CoordenadaCubica(DireccionHexagonal.qMasSMenos.paso)
        #expect([q.q, q.r, q.s] == [1, 0, -1] as [Int])
        let r = CoordenadaCubica(DireccionHexagonal.rMasQMenos.paso)
        #expect([r.q, r.r, r.s] == [-1, 1, 0] as [Int])
        let s = CoordenadaCubica(DireccionHexagonal.sMasRMenos.paso)
        #expect([s.q, s.r, s.s] == [0, -1, 1] as [Int])
    }

    @Test func numeroModuloSeis() {
        #expect(DireccionHexagonal(numero: 7) == .qMasRMenos)
        #expect(DireccionHexagonal(numero: -1) == .rMasSMenos)
        #expect(DireccionHexagonal(numero: 12) == .qMasSMenos)
    }

    @Test func giros() {
        for d in DireccionHexagonal.allCases {
            #expect(d.opuesta.opuesta == d)
            #expect((d.paso + d.opuesta.paso) == .origen)
            #expect(d.siguiente.anterior == d)
            #expect(d.rotada(sextos: 6) == d)
            // Girar la dirección es girar su paso.
            #expect(d.siguiente.paso == d.paso.rotadaEnSentidoAntihorario())
            #expect(d.anterior.paso == d.paso.rotadaEnSentidoHorario())
        }
        #expect(DireccionHexagonal.qMasSMenos.opuesta == .sMasQMenos)
    }

    @Test func puntosCardinales() {
        #expect(
            DireccionHexagonal.allCases.map { $0.puntoCardinal(.puntiaguda) } == [
                .este, .noreste, .noroeste, .oeste, .suroeste, .sureste,
            ])
        #expect(
            DireccionHexagonal.allCases.map { $0.puntoCardinal(.plana) } == [
                .sureste, .noreste, .norte, .noroeste, .suroeste, .sur,
            ])
        #expect(DireccionHexagonal(.este, .puntiaguda) == .qMasSMenos)
        #expect(DireccionHexagonal(.norte, .plana) == .sMasRMenos)
        #expect(DireccionHexagonal(.norte, .puntiaguda) == nil)
        #expect(DireccionHexagonal(.este, .plana) == nil)
        for orientacion in Orientacion.allCases {
            for d in DireccionHexagonal.allCases {
                #expect(DireccionHexagonal(d.puntoCardinal(orientacion), orientacion) == d)
            }
        }
    }

    @Test func elAnguloCoincideConElDibujo() {
        // Con el eje y hacia abajo, el ángulo antihorario desde el este es atan2(−dy, dx).
        for orientacion in Orientacion.allCases {
            let trazado = Trazado(orientacion: orientacion, tamano: 10)
            #expect(
                DireccionHexagonal.allCases.map { $0.angulo(orientacion) }
                    == (orientacion == .puntiaguda ? [0, 60, 120, 180, 240, 300] : [330, 30, 90, 150, 210, 270]))
            for d in DireccionHexagonal.allCases {
                let centro = trazado.centro(de: d.paso)
                var grados = atan2(-centro.y, centro.x) * 180 / .pi
                if grados < -1e-9 { grados += 360 }
                #expect(abs(grados - (d.angulo(orientacion))) <= 1e-9, "\(orientacion) \(d)")
            }
        }
    }

    @Test func vecinosYAvances() {
        let a = CoordenadaAxial(q: 2, r: -1)
        for d in DireccionHexagonal.allCases {
            #expect(a.vecino(d) == a.vecino(d.numero))
            #expect(a.direccion(hacia: a.vecino(d)) == d)
            #expect(a.avanzando(3, hacia: d).distancia(hasta: a) == 3)
            #expect(a.avanzando(-2, hacia: d) == a.avanzando(2, hacia: d.opuesta))
        }
        #expect(CoordenadaAxial.origen.vecino(DireccionHexagonal(.este, .puntiaguda)!) == CoordenadaAxial(q: 1, r: 0))
        #expect(DireccionHexagonal(.este, .puntiaguda)?.puntoCardinal(.plana) == .sureste)
    }
}
