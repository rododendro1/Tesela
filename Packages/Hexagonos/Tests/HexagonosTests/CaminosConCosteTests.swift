import Foundation
import Testing

@testable import Hexagonos

@Suite struct CaminosConCosteTests {
    /// Un terreno de prueba: cada casilla cuesta de 1 a 4, sin azar, y algunas son muros.
    private let mapa = FormasDeMapa.hexagono(radio: 6)
    private func terreno(_ c: CoordenadaAxial) -> Double? {
        guard c.distanciaAlOrigen <= 6 else { return nil }
        let n = modulo(c.q * 7 + c.r * 13, 11)
        return n == 0 ? nil : Double(1 + n % 4)
    }

    /// Los costes de llegar a cada casilla calculados a lo bruto: relajando hasta que nada cambia.
    private func costesALoBruto(desde origen: CoordenadaAxial) -> [CoordenadaAxial: Double] {
        var costes: [CoordenadaAxial: Double] = [origen: 0]
        var cambia = true
        while cambia {
            cambia = false
            for casilla in mapa {
                guard let hastaAqui = costes[casilla] else { continue }
                for vecina in casilla.vecinos {
                    guard let paso = terreno(vecina) else { continue }
                    if hastaAqui + paso < costes[vecina, default: .infinity] {
                        costes[vecina] = hastaAqui + paso
                        cambia = true
                    }
                }
            }
        }
        return costes
    }

    @Test func monticulo() {
        var monticulo = MonticuloDeMinimos<String>()
        for (clave, texto) in [(3.0, "c"), (1, "a"), (2, "b1"), (5, "e"), (2, "b2"), (0, "0")] {
            monticulo.insertar(texto, clave: clave)
        }
        #expect(monticulo.count == 6)
        var salida: [String] = []
        while let siguiente = monticulo.extraer() { salida.append(siguiente.elemento) }
        #expect(salida == ["0", "a", "b1", "b2", "c", "e"])
        #expect(monticulo.estaVacio)
    }

    @Test func sinCostesEsElCaminoMasCorto() {
        let camino = CoordenadaAxial.origen.caminoMasBarato(hasta: CoordenadaAxial(q: 3, r: -1)) { _, hacia in
            hacia.distanciaAlOrigen <= 5 ? 1 : nil
        }
        #expect(camino?.pasos == 3)
        #expect(camino?.coste == 3)
        #expect(camino?.casillas.first == .origen)
        #expect(camino?.casillas.last == CoordenadaAxial(q: 3, r: -1))
        let vacio = CoordenadaAxial.origen.caminoMasBarato(hasta: .origen) { _, _ in 1 }
        #expect(vacio == CaminoHexagonal(casillas: [.origen], coste: 0))
    }

    @Test func rodeaLoCaro() {
        let pantano: Set = [CoordenadaAxial(q: 1, r: 0)]
        let camino = CoordenadaAxial.origen.caminoMasBarato(hasta: CoordenadaAxial(q: 2, r: 0)) { _, hacia in
            hacia.distanciaAlOrigen > 4 ? nil : (pantano.contains(hacia) ? 5 : 1)
        }
        #expect(camino?.coste == 3)
        #expect(camino?.pasos == 3)
        #expect(!(camino?.casillas.contains(CoordenadaAxial(q: 1, r: 0)) ?? true))
    }

    @Test func cuestaLoMismoQueALoBruto() {
        let origen = CoordenadaAxial(q: -2, r: 1)
        let costes = costesALoBruto(desde: origen)
        for destino in mapa {
            for costeMinimo in [0.0, 1] {
                let encontrado = origen.caminoMasBarato(hasta: destino, costeMinimo: costeMinimo) { _, hacia in
                    self.terreno(hacia)
                }
                guard let esperado = costes[destino] else {
                    #expect(encontrado == nil, "\(destino)")
                    continue
                }
                guard let camino = encontrado else {
                    Issue.record("Sin camino a \(destino)")
                    return
                }
                #expect(camino.coste == esperado, "\(destino)")
                // El coste es el de sus pasos, y cada paso va a una vecina.
                #expect(camino.casillas.dropFirst().reduce(0) { $0 + terreno($1)! } == camino.coste)
                for (a, b) in zip(camino.casillas, camino.casillas.dropFirst()) {
                    #expect(a.distancia(hasta: b) == 1)
                }
            }
        }
        let alcanzables = origen.alcanzables(presupuesto: .infinity) { _, hacia in self.terreno(hacia) }
        #expect(alcanzables == costes)
    }

    @Test func siempreElMismoCamino() {
        let destino = CoordenadaAxial(q: 4, r: -2)
        let caminos = (0..<5).map { _ in
            CoordenadaAxial.origen.caminoMasBarato(hasta: destino) { _, hacia in hacia.distanciaAlOrigen <= 6 ? 1 : nil
            }
        }
        #expect(caminos.allSatisfy { $0 == caminos[0] })
    }

    @Test func presupuesto() {
        let destino = CoordenadaAxial(q: 4, r: 0)
        let barato = { (_: CoordenadaAxial, _: CoordenadaAxial) -> Double? in 2 }
        #expect(CoordenadaAxial.origen.caminoMasBarato(hasta: destino, presupuesto: 8, coste: barato)?.coste == 8)
        #expect(CoordenadaAxial.origen.caminoMasBarato(hasta: destino, presupuesto: 7.9, coste: barato) == nil)
        // Sin región finita, el presupuesto hace que termine aunque no se pueda llegar.
        #expect(
            CoordenadaAxial.origen.caminoMasBarato(hasta: destino, presupuesto: 20) { _, hacia in
                hacia == destino ? nil : 1
            } == nil)
    }

    /// Con un coste mínimo, lo estimado ya pasa del presupuesto antes de dar ningún paso.
    @Test func presupuestoConCosteMinimo() {
        let destino = CoordenadaAxial(q: 4, r: 0)
        #expect(
            CoordenadaAxial.origen.caminoMasBarato(hasta: destino, costeMinimo: 1, presupuesto: 3) { _, _ in 1 } == nil)
        #expect(
            CoordenadaAxial.origen.caminoMasBarato(hasta: destino, costeMinimo: 1, presupuesto: 4) { _, _ in 1 }?.coste
                == 4)
    }

    /// Una casilla a la que primero se llega caro y luego barato se cuenta una vez, con lo barato.
    @Test func alcanzablesConUnAtajo() {
        let cara = CoordenadaAxial(q: 1, r: 0)
        let costes = CoordenadaAxial.origen.alcanzables(presupuesto: 6) { desde, hacia in
            desde == .origen && hacia == cara ? 5 : 1
        }
        #expect(costes[cara] == 2)
    }

    @Test func alcanzablesConCoste() {
        // Con todos los pasos a 1, son los de la búsqueda en anchura.
        let muro: Set = [CoordenadaAxial(q: 1, r: -1), CoordenadaAxial(q: 1, r: 0), CoordenadaAxial(q: 0, r: 1)]
        let porPasos = CoordenadaAxial.origen.alcanzables(movimientos: 4) { muro.contains($0) }
        let porCoste = CoordenadaAxial.origen.alcanzables(presupuesto: 4) { _, hacia in muro.contains(hacia) ? nil : 1 }
        #expect(porCoste == porPasos.mapValues { Double($0) })

        let costes = CoordenadaAxial.origen.alcanzables(presupuesto: 2) { _, hacia in hacia.q > 0 ? 2 : 1 }
        #expect(costes[.origen] == 0)
        #expect(costes[CoordenadaAxial(q: -2, r: 0)] == 2)
        #expect(costes[CoordenadaAxial(q: 1, r: 0)] == 2)
        #expect(costes[CoordenadaAxial(q: 2, r: 0)] == nil)
        #expect(costes.values.allSatisfy { $0 <= 2 })
        #expect(CoordenadaAxial.origen.alcanzables(presupuesto: 0) { _, _ in 1 } == [.origen: 0])
    }
}
