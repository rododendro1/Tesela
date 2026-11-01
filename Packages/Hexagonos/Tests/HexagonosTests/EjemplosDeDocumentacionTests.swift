import Foundation
import Hexagonos
import Testing

/// Los resultados que la documentación (DocC y comentarios) promete en sus ejemplos.
@Suite struct EjemplosDeDocumentacionTests {
    @Test func portada() {
        let a = CoordenadaAxial(q: 1, r: -2)
        #expect(a.vecinos.count == 6)
        #expect(a.distancia(hasta: .origen) == 2)
        #expect(a.linea(hasta: CoordenadaAxial(q: 4, r: -2)).count == 4)
        #expect(a.desplazada(.filasImpares) == CoordenadaDesplazada(columna: 0, fila: -2))
        #expect(a.s == 1)
        #expect((a + CoordenadaAxial(q: 0, r: 1)) == CoordenadaAxial(q: 1, r: -1))
    }

    @Test func sistemasDeCoordenadas() {
        let a = CoordenadaAxial(q: 2, r: -1)
        #expect(a.cubica == CoordenadaCubica(q: 2, r: -1, s: -1))
        let d = CoordenadaDesplazada(columna: 3, fila: 1)
        #expect(d.axial(.filasImpares) == CoordenadaAxial(q: 3, r: 1))
        #expect(d.axial(.filasImpares).desplazada(.filasPares) == CoordenadaDesplazada(columna: 4, fila: 1))
        #expect(CoordenadaAxial(q: 1, r: 2).doblada(.anchoDoble) == CoordenadaDoblada(columna: 4, fila: 2))
        #expect(CoordenadaAxial(q: 1, r: 2).doblada(.altoDoble) == CoordenadaDoblada(columna: 1, fila: 5))
        let c = CoordenadaCubica(q: 1, r: -3, s: 2)
        #expect(c.axial == CoordenadaAxial(q: 1, r: -3))
    }

    @Test func algoritmos() {
        #expect(CoordenadaAxial.origen.vecino(0) == CoordenadaAxial(q: 1, r: 0))
        #expect(CoordenadaAxial.origen.distancia(hasta: CoordenadaAxial(q: 3, r: -7)) == 7)
        #expect(CoordenadaAxial.origen.alcance(radio: 2).count == 19)
        #expect(CoordenadaAxial.origen.anillo(radio: 2).count == 12)
        #expect(
            CoordenadaAxial.origen.linea(hasta: CoordenadaAxial(q: 3, r: 0)) == [
                CoordenadaAxial(q: 0, r: 0), CoordenadaAxial(q: 1, r: 0),
                CoordenadaAxial(q: 2, r: 0), CoordenadaAxial(q: 3, r: 0),
            ])
    }

    @Test func pixeles() {
        let puntiaguda = Trazado(orientacion: .puntiaguda, tamano: 10)
        #expect(abs(puntiaguda.centro(de: CoordenadaAxial(q: 1, r: 0)).x - (17.3205)) <= 1e-4)
        #expect(puntiaguda.casilla(en: Punto(x: 17, y: 1)) == CoordenadaAxial(q: 1, r: 0))
        let plana = Trazado(orientacion: .plana, tamano: 20, origen: Punto(x: 200, y: 150))
        let centro = plana.centro(de: CoordenadaAxial(q: 1, r: 0))
        #expect(abs(centro.x - (230)) <= 1e-9)
        #expect(abs(centro.y - (167.3205)) <= 1e-4)
        #expect(plana.casilla(en: Punto(x: 231, y: 160)) == CoordenadaAxial(q: 1, r: 0))
    }

    @Test func mapasYCaminos() {
        var mapa = MapaHexagonal(repitiendo: "hierba", en: FormasDeMapa.hexagono(radio: 2))
        mapa[CoordenadaAxial(q: 1, r: 0)] = "agua"
        #expect(mapa.count == 19)
        #expect(mapa[CoordenadaAxial(q: 5, r: 0)] == nil)
        #expect(mapa.vecinas(de: .origen).count == 6)

        let pantano: Set = [CoordenadaAxial(q: 1, r: 0)]
        let camino = CoordenadaAxial.origen.caminoMasBarato(hasta: CoordenadaAxial(q: 2, r: 0)) { _, hacia in
            hacia.distanciaAlOrigen > 4 ? nil : (pantano.contains(hacia) ? 5 : 1)
        }
        #expect(camino?.coste == 3.0)
        #expect(camino?.pasos == 3)

        let costes = CoordenadaAxial.origen.alcanzables(presupuesto: 2) { _, hacia in
            hacia.q > 0 ? 2 : 1
        }
        #expect(costes[CoordenadaAxial(q: -2, r: 0)] == 2.0)
        #expect(costes[CoordenadaAxial(q: 2, r: 0)] == nil)

        var terreno = MapaHexagonal(repitiendo: 1.0, en: FormasDeMapa.hexagono(radio: 3))
        terreno[CoordenadaAxial(q: 1, r: 0)] = 10
        #expect(terreno.caminoMasBarato(desde: .origen, hasta: CoordenadaAxial(q: 2, r: 0)) { $0 }?.coste == 3.0)
        #expect(terreno.alcanzables(desde: .origen, presupuesto: 2) { $0 }.count == 17)
    }
}
