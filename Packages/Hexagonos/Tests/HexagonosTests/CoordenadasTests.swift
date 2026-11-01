import Foundation
import Testing

@testable import Hexagonos

/// Varios de los valores esperados son los de las pruebas de la guía de Red Blob Games
/// (https://www.redblobgames.com/grids/hexagons/implementation.html).
@Suite struct CoordenadaAxialTests {
    @Test func laTerceraCoordenadaHaceQueSumenCero() {
        let a = CoordenadaAxial(q: 3, r: -7)
        #expect(a.s == 4)
        #expect((a.q + a.r + a.s) == 0)
        #expect(CoordenadaAxial(1, -2) == CoordenadaAxial(q: 1, r: -2))
        #expect(CoordenadaAxial.origen.description == "(q: 0, r: 0)")
    }

    @Test func seSumanYRestanComoVectores() {
        let a = CoordenadaAxial(q: 1, r: -3)
        let b = CoordenadaAxial(q: 3, r: -7)
        #expect((a + b) == CoordenadaAxial(q: 4, r: -10))
        #expect((a - b) == CoordenadaAxial(q: -2, r: 4))
        #expect((a * 2) == CoordenadaAxial(q: 2, r: -6))
        #expect((2 * a) == (a * 2))
        #expect(-a == CoordenadaAxial(q: -1, r: 3))
        var c = a
        c += b
        c -= b
        #expect(c == a)
    }

    @Test func vecinos() {
        let a = CoordenadaAxial(q: 1, r: -2)
        #expect(a.vecino(2) == CoordenadaAxial(q: 1, r: -3))
        #expect(a.vecino(8) == a.vecino(2))
        #expect(a.vecino(-1) == a.vecino(5))
        #expect(a.vecinos.count == 6)
        #expect(Set(a.vecinos).count == 6)
        for (i, vecina) in a.vecinos.enumerated() {
            #expect(a.distancia(hasta: vecina) == 1)
            #expect(a.esVecina(de: vecina))
            #expect(a.direccion(hacia: vecina)?.numero == i)
        }
        #expect(a.direccion(hacia: a) == nil)
        #expect(a.direccion(hacia: a.vecinoDiagonal(0)) == nil)
        #expect(!a.esVecina(de: a))
    }

    @Test func lasDireccionesOpuestasSeAnulan() {
        for i in 0..<3 {
            #expect((CoordenadaAxial.direcciones[i] + CoordenadaAxial.direcciones[i + 3]) == .origen)
        }
    }

    @Test func diagonales() {
        let a = CoordenadaAxial(q: 1, r: -2)
        #expect(a.vecinoDiagonal(3) == CoordenadaAxial(q: -1, r: -1))
        for i in 0..<6 {
            // Cada diagonal queda entre dos direcciones seguidas, a distancia 2.
            #expect(
                CoordenadaAxial.diagonales[i]
                    == (CoordenadaAxial.direcciones[i] + CoordenadaAxial.direcciones[(i + 1) % 6]))
            #expect(a.distancia(hasta: a.vecinoDiagonal(i)) == 2)
        }
        #expect(Set(a.vecinosDiagonales).count == 6)
    }

    @Test func distancia() {
        #expect(CoordenadaAxial(q: 3, r: -7).distancia(hasta: .origen) == 7)
        #expect(CoordenadaAxial(q: 3, r: -7).distanciaAlOrigen == 7)
        #expect(CoordenadaAxial(q: -2, r: 5).distancia(hasta: CoordenadaAxial(q: 1, r: 1)) == 4)
        #expect(CoordenadaAxial.origen.distanciaAlOrigen == 0)
    }
}

@Suite struct CoordenadaCubicaTests {
    @Test func idaYVueltaConLasAxiales() {
        let c = CoordenadaCubica(q: 1, r: -3, s: 2)
        #expect(c.axial == CoordenadaAxial(q: 1, r: -3))
        #expect(CoordenadaCubica(c.axial) == c)
        #expect(CoordenadaAxial(c) == c.axial)
        #expect(c.axial.cubica == c)
        #expect(c.description == "(q: 1, r: -3, s: 2)")
    }

    @Test func validando() {
        #expect(CoordenadaCubica(validando: 1, -3, 2) != nil)
        #expect(CoordenadaCubica(validando: 1, 1, 1) == nil)
    }

    @Test func aritmeticaYDistancia() {
        let a = CoordenadaCubica(q: 1, r: -3, s: 2)
        let b = CoordenadaCubica(q: 3, r: -7, s: 4)
        #expect((a + b) == CoordenadaCubica(q: 4, r: -10, s: 6))
        #expect((a - b) == CoordenadaCubica(q: -2, r: 4, s: -2))
        #expect((a * 3) == CoordenadaCubica(q: 3, r: -9, s: 6))
        #expect(b.distancia(hasta: .origen) == 7)
        #expect(a.distancia(hasta: b) == a.axial.distancia(hasta: b.axial))
        #expect(a.vecinos.map(\.axial) == a.axial.vecinos)
    }

    @Test func codable() throws {
        let c = CoordenadaCubica(q: 1, r: -3, s: 2)
        let datos = try JSONEncoder().encode(c)
        #expect(try (JSONDecoder().decode(CoordenadaCubica.self, from: datos)) == c)
        let mal = Data(#"{"q": 1, "r": 1, "s": 1}"#.utf8)
        #expect(throws: (any Error).self) { try JSONDecoder().decode(CoordenadaCubica.self, from: mal) }
        let axial = CoordenadaAxial(q: 2, r: -5)
        #expect(try (JSONDecoder().decode(CoordenadaAxial.self, from: JSONEncoder().encode(axial))) == axial)
    }
}

@Suite struct CoordenadaFraccionariaTests {
    private let a = CoordenadaFraccionaria(CoordenadaAxial(q: 0, r: 0))
    private let b = CoordenadaFraccionaria(CoordenadaAxial(q: 1, r: -1))
    private let c = CoordenadaFraccionaria(CoordenadaAxial(q: 0, r: -1))

    @Test func redondeo() {
        let lejos = CoordenadaFraccionaria(q: 10, r: -20)
        #expect(CoordenadaFraccionaria.interpolar(a, lejos, 0.5).redondeada() == CoordenadaAxial(q: 5, r: -10))
        #expect(CoordenadaFraccionaria.interpolar(a, b, 0.499).redondeada() == a.redondeada())
        #expect(CoordenadaFraccionaria.interpolar(a, b, 0.501).redondeada() == b.redondeada())
    }

    @Test func texto() {
        #expect(CoordenadaFraccionaria(q: 0.5, r: -1).description == "(q: 0.5, r: -1.0)")
    }

    @Test func redondeoEntreTresCasillas() {
        func mezcla(_ pa: Double, _ pb: Double, _ pc: Double) -> CoordenadaFraccionaria {
            CoordenadaFraccionaria(q: a.q * pa + b.q * pb + c.q * pc, r: a.r * pa + b.r * pb + c.r * pc)
        }
        #expect(mezcla(0.4, 0.3, 0.3).redondeada() == a.redondeada())
        #expect(mezcla(0.3, 0.3, 0.4).redondeada() == c.redondeada())
    }

    @Test func elCentroDeUnaCasillaEsLaCasilla() {
        for casilla in CoordenadaAxial.origen.alcance(radio: 4) {
            #expect(CoordenadaFraccionaria(casilla).redondeada() == casilla)
        }
        #expect(CoordenadaFraccionaria(q: 1.5, r: 0.25).s == -1.75)
    }
}

@Suite struct CoordenadaDesplazadaTests {
    @Test func valoresConocidos() {
        let a = CoordenadaAxial(q: 1, r: 2)
        #expect(a.desplazada(.columnasPares) == CoordenadaDesplazada(columna: 1, fila: 3))
        #expect(a.desplazada(.columnasImpares) == CoordenadaDesplazada(columna: 1, fila: 2))
        #expect(a.desplazada(.filasPares) == CoordenadaDesplazada(columna: 2, fila: 2))
        #expect(a.desplazada(.filasImpares) == CoordenadaDesplazada(columna: 2, fila: 2))
        // Una fila impar: aquí sí se distinguen.
        let d = CoordenadaDesplazada(columna: 3, fila: 1)
        #expect(d.axial(.filasImpares) == CoordenadaAxial(q: 3, r: 1))
        #expect(d.axial(.filasImpares).desplazada(.filasPares) == CoordenadaDesplazada(columna: 4, fila: 1))
        #expect(d.description == "(columna: 3, fila: 1)")
    }

    @Test func idaYVueltaConNegativos() {
        for desplazamiento in Desplazamiento.allCases {
            for casilla in CoordenadaAxial.origen.alcance(radio: 6) {
                let d = casilla.desplazada(desplazamiento)
                #expect(d.axial(desplazamiento) == casilla, "\(desplazamiento) \(casilla)")
                #expect(CoordenadaAxial(d, desplazamiento) == casilla)
            }
            for columna in -5...5 {
                for fila in -5...5 {
                    let d = CoordenadaDesplazada(columna: columna, fila: fila)
                    #expect(d.axial(desplazamiento).desplazada(desplazamiento) == d)
                }
            }
        }
    }

    @Test func enLasFilasDesplazadasLasFilasSonRectas() {
        // Con filas desplazadas, la fila es r; con columnas desplazadas, la columna es q.
        let a = CoordenadaAxial(q: -3, r: 5)
        #expect(a.desplazada(.filasImpares).fila == a.r)
        #expect(a.desplazada(.columnasPares).columna == a.q)
        #expect(Desplazamiento.filasPares.orientacion == .puntiaguda)
        #expect(Desplazamiento.columnasImpares.orientacion == .plana)
    }

    @Test func vecinosYDistancia() {
        let d = CoordenadaDesplazada(columna: 2, fila: 3)
        for desplazamiento in Desplazamiento.allCases {
            let vecinas = d.vecinos(desplazamiento)
            #expect(Set(vecinas).count == 6)
            for vecina in vecinas {
                #expect(d.distancia(hasta: vecina, desplazamiento) == 1)
            }
        }
        // En una fila impar con filas impares desplazadas, la vecina de arriba a la derecha está en la columna siguiente.
        #expect(d.vecinos(.filasImpares).contains(CoordenadaDesplazada(columna: 3, fila: 2)))
        #expect(!(d.vecinos(.filasPares).contains(CoordenadaDesplazada(columna: 3, fila: 2))))
    }
}

@Suite struct CoordenadaDobladaTests {
    @Test func valoresConocidos() {
        let a = CoordenadaAxial(q: 1, r: 2)
        #expect(a.doblada(.altoDoble) == CoordenadaDoblada(columna: 1, fila: 5))
        #expect(a.doblada(.anchoDoble) == CoordenadaDoblada(columna: 4, fila: 2))
        #expect(CoordenadaAxial(CoordenadaDoblada(columna: 4, fila: 2), .anchoDoble) == a)
        #expect(CoordenadaDoblada(columna: 1, fila: 5).axial(.altoDoble) == a)
        #expect(Doblado.anchoDoble.orientacion == .puntiaguda)
        #expect(Doblado.altoDoble.orientacion == .plana)
    }

    @Test func validez() {
        #expect(CoordenadaDoblada(columna: 4, fila: 2).esValida)
        #expect(CoordenadaDoblada(columna: -3, fila: 1).esValida)
        #expect(!(CoordenadaDoblada(columna: 3, fila: 2).esValida))
        #expect(!(CoordenadaDoblada(columna: -3, fila: 0).esValida))
    }

    @Test func texto() {
        #expect(CoordenadaDoblada(columna: 3, fila: 1).description == "(columna: 3, fila: 1)")
    }

    @Test func idaYVueltaYDistancia() {
        let region = CoordenadaAxial.origen.alcance(radio: 5)
        for doblado in Doblado.allCases {
            for casilla in region {
                let d = casilla.doblada(doblado)
                #expect(d.esValida)
                #expect(d.axial(doblado) == casilla)
                #expect(Set(d.vecinos(doblado)).count == 6)
            }
            let centro = CoordenadaAxial(q: 1, r: -2)
            for casilla in region {
                #expect(
                    casilla.doblada(doblado).distancia(hasta: centro.doblada(doblado), doblado)
                        == casilla.distancia(hasta: centro), "\(doblado) \(casilla)")
            }
        }
    }
}
