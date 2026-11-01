import Foundation
import Testing

@testable import Hexagonos

@Suite struct LineasTests {
    @Test func lineaConocida() {
        let linea = CoordenadaAxial.origen.linea(hasta: CoordenadaAxial(q: 1, r: -5))
        #expect(
            linea == [
                CoordenadaAxial(q: 0, r: 0), CoordenadaAxial(q: 0, r: -1), CoordenadaAxial(q: 0, r: -2),
                CoordenadaAxial(q: 1, r: -3), CoordenadaAxial(q: 1, r: -4), CoordenadaAxial(q: 1, r: -5),
            ])
    }

    @Test func lineaRecta() {
        #expect(
            CoordenadaAxial.origen.linea(hasta: CoordenadaAxial(q: 3, r: 0))
                == (0...3).map { CoordenadaAxial(q: $0, r: 0) })
        let a = CoordenadaAxial(q: 2, r: -1)
        #expect(a.linea(hasta: a) == [a])
    }

    @Test func cadaCasillaEsVecinaDeLaAnterior() {
        let origen = CoordenadaAxial(q: -2, r: 1)
        for destino in origen.alcance(radio: 6) {
            let linea = origen.linea(hasta: destino)
            #expect(linea.count == (origen.distancia(hasta: destino) + 1))
            #expect(linea.first == origen)
            #expect(linea.last == destino)
            for (anterior, siguiente) in zip(linea, linea.dropFirst()) {
                #expect(anterior.distancia(hasta: siguiente) == 1, "\(origen) → \(destino)")
            }
        }
    }

    @Test func visibilidad() {
        let muro: Set = [CoordenadaAxial(q: 1, r: 0)]
        let tapada = { muro.contains($0) }
        #expect(!CoordenadaAxial.origen.esVisible(CoordenadaAxial(q: 3, r: 0), tapada: tapada))
        #expect(CoordenadaAxial.origen.esVisible(CoordenadaAxial(q: 0, r: 3), tapada: tapada))
        // Una casilla tapada no se tapa a sí misma, ni tapa a una vecina.
        #expect(CoordenadaAxial.origen.esVisible(CoordenadaAxial(q: 1, r: 0), tapada: tapada))
        let visibles = CoordenadaAxial.origen.visibles(en: CoordenadaAxial.origen.alcance(radio: 3), tapada: tapada)
        #expect(!visibles.contains(CoordenadaAxial(q: 1, r: 0)))
        #expect(!visibles.contains(CoordenadaAxial(q: 2, r: 0)))
        #expect(visibles.contains(CoordenadaAxial(q: 0, r: 1)))
        #expect(visibles.contains(.origen))
    }

    @Test func laLineaDeVueltaEsLaDeIdaAlReves() {
        let a = CoordenadaAxial(q: 1, r: -2)
        for b in a.alcance(radio: 6) {
            #expect(b.linea(hasta: a) == a.linea(hasta: b).reversed(), "\(a) ↔ \(b)")
        }
    }

    @Test func porUnaAristaBastaUnLado() {
        // La recta a (2, −1) pasa justo entre (1, −1) y (1, 0).
        let destino = CoordenadaAxial(q: 2, r: -1)
        let lados = [CoordenadaAxial(q: 1, r: -1), CoordenadaAxial(q: 1, r: 0)]
        #expect(lados.contains(CoordenadaAxial.origen.linea(hasta: destino)[1]))
        #expect(CoordenadaAxial.origen.esVisible(destino) { $0 == lados[0] })
        #expect(CoordenadaAxial.origen.esVisible(destino) { $0 == lados[1] })
        #expect(!(CoordenadaAxial.origen.esVisible(destino) { lados.contains($0) }))
    }

    @Test func laVisibilidadEsSimetrica() {
        // Unos muros sin azar, y las doce simetrías de la rejilla alrededor de una casilla cualquiera.
        let region = FormasDeMapa.hexagono(radio: 6)
        let muros = Set(region.filter { modulo($0.q * 7 + $0.r * 13, 6) == 0 && $0 != .origen })
        let centro = CoordenadaAxial(q: 1, r: -1)
        var simetrias: [(CoordenadaAxial) -> CoordenadaAxial] = []
        for sextos in 0..<6 {
            simetrias.append { $0.rotada(sextos: sextos, alrededorDe: centro) }
            simetrias.append {
                $0.reflejada(sobre: .q, alrededorDe: centro).rotada(sextos: sextos, alrededorDe: centro)
            }
        }
        for a in [CoordenadaAxial.origen, CoordenadaAxial(q: -2, r: 3)] {
            for b in region {
                let ve = a.esVisible(b) { muros.contains($0) }
                #expect(b.esVisible(a) { muros.contains($0) } == ve, "\(a) ↔ \(b)")
                for simetria in simetrias {
                    let movidos = Set(muros.map(simetria))
                    #expect(simetria(a).esVisible(simetria(b)) { movidos.contains($0) } == ve, "\(a) → \(b)")
                }
            }
        }
    }
}

@Suite struct RegionesTests {
    @Test func alcance() {
        let centro = CoordenadaAxial(q: 2, r: -3)
        for radio in 0...5 {
            let alcance = centro.alcance(radio: radio)
            #expect(alcance.count == (3 * radio * (radio + 1) + 1))
            #expect(Set(alcance).count == alcance.count)
            #expect(alcance.allSatisfy { $0.distancia(hasta: centro) <= radio })
        }
        #expect(centro.alcance(radio: 0) == [centro])
    }

    @Test func interseccion() {
        let a = (centro: CoordenadaAxial(q: 0, r: 0), radio: 3)
        let b = (centro: CoordenadaAxial(q: 3, r: -1), radio: 2)
        let c = (centro: CoordenadaAxial(q: 1, r: 1), radio: 2)
        let esperada = a.centro.alcance(radio: a.radio).filter {
            $0.distancia(hasta: b.centro) <= b.radio && $0.distancia(hasta: c.centro) <= c.radio
        }
        #expect(!esperada.isEmpty)
        #expect(Set(CoordenadaAxial.interseccion(de: [a, b, c])) == Set(esperada))
        #expect(Set(CoordenadaAxial.interseccion(de: [a])) == Set(a.centro.alcance(radio: a.radio)))
        let lejos = (centro: CoordenadaAxial(q: 20, r: 0), radio: 1)
        #expect(CoordenadaAxial.interseccion(de: [a, lejos]) == [])
    }

    /// Contra el filtro a lo bruto, también con alcances que solo se tocan en algunas columnas.
    @Test func interseccionComoElFiltro() {
        let centros = FormasDeMapa.hexagono(radio: 3)
        for a in centros where a.q >= 0 {
            for radio in 0...2 {
                let alcances = [(centro: CoordenadaAxial.origen, radio: 2), (centro: a, radio: radio)]
                let esperada = CoordenadaAxial.origen.alcance(radio: 2).filter { $0.distancia(hasta: a) <= radio }
                #expect(Set(CoordenadaAxial.interseccion(de: alcances)) == Set(esperada), "\(a) \(radio)")
            }
        }
    }

    @Test func anillo() {
        let centro = CoordenadaAxial(q: -1, r: 2)
        #expect(centro.anillo(radio: 0) == [centro])
        for radio in 1...5 {
            let anillo = centro.anillo(radio: radio)
            #expect(anillo.count == (6 * radio))
            #expect(Set(anillo).count == anillo.count)
            #expect(anillo.allSatisfy { $0.distancia(hasta: centro) == radio })
            #expect(anillo.first == (centro + CoordenadaAxial.direcciones[4] * radio))
            // Se recorre de vecina en vecina, y la última vuelve a tocar la primera.
            for (anterior, siguiente) in zip(anillo, anillo.dropFirst() + [anillo[0]]) {
                #expect(anterior.distancia(hasta: siguiente) == 1)
            }
        }
        #expect(CoordenadaAxial.origen.anillo(radio: 1).count == 6)
    }

    @Test func espiral() {
        let centro = CoordenadaAxial(q: 4, r: -1)
        let espiral = centro.espiral(radio: 3)
        #expect(Set(espiral) == Set(centro.alcance(radio: 3)))
        #expect(espiral.count == 37)
        #expect(espiral.first == centro)
        #expect(espiral.map { $0.distancia(hasta: centro) } == espiral.map { $0.distancia(hasta: centro) }.sorted())
        #expect(centro.espiral(radio: 0) == [centro])
    }

    @Test func alcanzablesSinObstaculosEsElAlcance() {
        let pasos = CoordenadaAxial.origen.alcanzables(movimientos: 3) { _ in false }
        #expect(Set(pasos.keys) == Set(CoordenadaAxial.origen.alcance(radio: 3)))
        for (casilla, n) in pasos {
            #expect(n == casilla.distanciaAlOrigen)
        }
    }

    @Test func alcanzablesRodeaLosObstaculos() {
        // Un muro de una casilla de grueso al este del origen, con hueco por arriba y por abajo.
        let muro: Set = [CoordenadaAxial(q: 1, r: -1), CoordenadaAxial(q: 1, r: 0), CoordenadaAxial(q: 0, r: 1)]
        let pasos = CoordenadaAxial.origen.alcanzables(movimientos: 4) { muro.contains($0) }
        for bloque in muro {
            #expect(pasos[bloque] == nil)
        }
        #expect(pasos[.origen] == 0)
        // (2, 0) está a 2 en línea recta, pero hay que rodear el muro.
        #expect((pasos[CoordenadaAxial(q: 2, r: 0)] ?? .max) > 2)
        #expect(pasos.allSatisfy { $0.value <= 4 })
    }

    @Test func alcanzablesEncerrado() {
        let pasos = CoordenadaAxial.origen.alcanzables(movimientos: 10) { $0.distanciaAlOrigen == 1 }
        #expect(pasos == [.origen: 0])
    }

    @Test func camino() {
        let mapa = Set(FormasDeMapa.hexagono(radio: 4)).subtracting([
            CoordenadaAxial(q: 1, r: -1), CoordenadaAxial(q: 1, r: 0), CoordenadaAxial(q: 1, r: 1),
        ])
        let destino = CoordenadaAxial(q: 3, r: 0)
        let camino = CoordenadaAxial.origen.camino(hasta: destino, por: mapa)
        #expect(camino != nil)
        if let camino {
            #expect(camino.first == .origen)
            #expect(camino.last == destino)
            #expect(camino.dropFirst().allSatisfy { mapa.contains($0) })
            for (anterior, siguiente) in zip(camino, camino.dropFirst()) {
                #expect(anterior.distancia(hasta: siguiente) == 1)
            }
            let pasos = CoordenadaAxial.origen.alcanzables(movimientos: 20) { !mapa.contains($0) }
            #expect((camino.count - 1) == pasos[destino])
        }
        #expect(CoordenadaAxial.origen.camino(hasta: .origen, por: []) == [.origen])
        #expect(CoordenadaAxial.origen.camino(hasta: CoordenadaAxial(q: 9, r: 0), por: mapa) == nil)
        let isla: Set = [CoordenadaAxial(q: 3, r: 0)]
        #expect(CoordenadaAxial.origen.camino(hasta: CoordenadaAxial(q: 3, r: 0), por: isla) == nil)
    }
}

@Suite struct SimetriasTests {
    @Test func rotacionesConocidas() {
        let a = CoordenadaAxial(CoordenadaCubica(q: 1, r: -3, s: 2))
        #expect(a.rotadaEnSentidoHorario().cubica == CoordenadaCubica(q: 3, r: -2, s: -1))
        #expect(a.rotadaEnSentidoAntihorario().cubica == CoordenadaCubica(q: -2, r: -1, s: 3))
    }

    @Test func lasRotacionesSiguenLasDirecciones() {
        for i in 0..<6 {
            let d = CoordenadaAxial.direcciones[i]
            #expect(d.rotadaEnSentidoAntihorario() == CoordenadaAxial.direcciones[(i + 1) % 6])
            #expect(d.rotadaEnSentidoHorario() == CoordenadaAxial.direcciones[(i + 5) % 6])
            #expect(d.rotada(sextos: 2) == CoordenadaAxial.direcciones[(i + 2) % 6])
        }
    }

    @Test func rotarAlrededorDeUnCentro() {
        let centro = CoordenadaAxial(q: 2, r: -1)
        let a = CoordenadaAxial(q: 4, r: -3)
        #expect(a.rotada(sextos: 6, alrededorDe: centro) == a)
        #expect(a.rotada(sextos: 0, alrededorDe: centro) == a)
        #expect(a.rotada(sextos: -1, alrededorDe: centro) == a.rotadaEnSentidoHorario(alrededorDe: centro))
        #expect(a.rotada(sextos: 3, alrededorDe: centro) == (centro - (a - centro)))
        #expect(centro.rotada(sextos: 1, alrededorDe: centro) == centro)
        for k in 0..<6 {
            #expect(a.rotada(sextos: k, alrededorDe: centro).distancia(hasta: centro) == a.distancia(hasta: centro))
        }
        #expect(a.rotadaEnSentidoHorario(alrededorDe: centro).rotadaEnSentidoAntihorario(alrededorDe: centro) == a)
    }

    @Test func rotadaEsGirarVariasVeces() {
        let centro = CoordenadaAxial(q: -1, r: 3)
        for a in centro.alcance(radio: 3) {
            var girada = a
            for sextos in 0...7 {
                #expect(a.rotada(sextos: sextos, alrededorDe: centro) == girada, "\(a), \(sextos)")
                #expect(girada.rotada(sextos: -sextos, alrededorDe: centro) == a)
                girada = girada.rotadaEnSentidoAntihorario(alrededorDe: centro)
            }
        }
    }

    @Test func reflexiones() {
        let a = CoordenadaAxial(CoordenadaCubica(q: 1, r: -3, s: 2))
        #expect(a.reflejada(sobre: .q).cubica == CoordenadaCubica(q: 1, r: 2, s: -3))
        #expect(a.reflejada(sobre: .r).cubica == CoordenadaCubica(q: 2, r: -3, s: 1))
        #expect(a.reflejada(sobre: .s).cubica == CoordenadaCubica(q: -3, r: 1, s: 2))
        let centro = CoordenadaAxial(q: -1, r: 2)
        for eje in Eje.allCases {
            let b = a.reflejada(sobre: eje, alrededorDe: centro)
            #expect(b.reflejada(sobre: eje, alrededorDe: centro) == a)
            #expect(b.distancia(hasta: centro) == a.distancia(hasta: centro))
        }
    }
}

@Suite struct FormasDeMapaTests {
    @Test func hexagono() {
        #expect(FormasDeMapa.hexagono(radio: 2).count == 19)
        #expect(FormasDeMapa.hexagono(radio: 1, centro: CoordenadaAxial(q: 5, r: 5)).count == 7)
    }

    @Test func paralelogramo() {
        let p = FormasDeMapa.paralelogramo(columnas: -1...2, filas: 0...2)
        #expect(p.count == 12)
        #expect(p.contains(CoordenadaAxial(q: -1, r: 2)))
    }

    @Test func triangulo() {
        let t = FormasDeMapa.triangulo(lado: 4)
        #expect(t.count == 10)
        #expect(t.allSatisfy { $0.q >= 0 && $0.r >= 0 && $0.q + $0.r < 4 })
        let invertido = FormasDeMapa.triangulo(lado: 4, invertido: true)
        #expect(Set(invertido) == Set(t.map { -$0 }))
        #expect(FormasDeMapa.triangulo(lado: 0) == [])
    }

    @Test func rectangulo() {
        for desplazamiento in Desplazamiento.allCases {
            let r = FormasDeMapa.rectangulo(columnas: 5, filas: 3, desplazamiento)
            #expect(r.count == 15)
            #expect(Set(r).count == 15)
            let desplazadas = r.map { $0.desplazada(desplazamiento) }
            #expect(desplazadas.allSatisfy { (0..<5).contains($0.columna) && (0..<3).contains($0.fila) })
        }
    }
}
