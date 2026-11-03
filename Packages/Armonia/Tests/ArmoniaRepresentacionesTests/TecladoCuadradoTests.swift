import Foundation
import Hexagonos
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Los teclados isomórficos de cuadrícula, definidos por sus ejes H y V.
@Suite struct TecladoCuadradoTests {
    private func casilla(_ columna: Int, _ fila: Int) -> CasillaCuadrada {
        CasillaCuadrada(columna: columna, fila: fila)
    }

    @Test func cadaEjeSubeSiempreLoMismo() {
        let ejes = TecladoCuadrado.todos.map { [$0.semitonosEnH, $0.semitonosEnV] }
        #expect(ejes == [[1, 5], [1, 4], [1, 7], [2, 5], [2, 1], [7, 4]])
        for teclado in TecladoCuadrado.todos {
            #expect(teclado.midi(en: .origen) == 60)
            for c in CasillaCuadrada.rectangulo(columnas: -3...3, filas: -3...3) {
                #expect(teclado.midi(en: casilla(c.columna + 1, c.fila)) - teclado.midi(en: c) == teclado.semitonosEnH)
                #expect(teclado.midi(en: casilla(c.columna, c.fila + 1)) - teclado.midi(en: c) == teclado.semitonosEnV)
                #expect(
                    teclado.midi(en: casilla(c.columna + 1, c.fila + 1)) - teclado.midi(en: c)
                        == teclado.semitonosEnDiagonal)
                #expect(
                    teclado.midi(en: casilla(c.columna - 1, c.fila + 1)) - teclado.midi(en: c)
                        == teclado.semitonosEnAntidiagonal)
            }
        }
        // En cuartas, Sol4 está dos a la derecha y una arriba; en Wicki-Hayden, la quinta es la diagonal.
        #expect(TecladoCuadrado.cuartas.midi(en: casilla(2, 1)) == 67)
        #expect(TecladoCuadrado.cuartas.semitonosEnDiagonal == 6)
        #expect(TecladoCuadrado.wickiHaydenCuadrado.semitonosEnDiagonal == 7)
        #expect(TecladoCuadrado.tonnetzDeEuler.semitonosEnAntidiagonal == -3)
    }

    @Test func todasLasNotasAparecen() {
        for teclado in TecladoCuadrado.todos { #expect(teclado.esCompleto, "\(teclado)") }
        #expect(!TecladoCuadrado(nombre: "", semitonosEnH: 2, semitonosEnV: 4).esCompleto)
        #expect(!TecladoCuadrado(nombre: "", semitonosEnH: 0, semitonosEnV: 0).esCompleto)
        // Las doce clases de altura, en una ventana de 12 × 7.
        let ventana = CasillaCuadrada.rectangulo(columnas: -5...6, filas: -3...3)
        #expect(ventana.count == 84)
        for teclado in TecladoCuadrado.todos {
            #expect(Set(ventana.map { modulo(teclado.midi(en: $0), 12) }).count == 12, "\(teclado)")
        }
    }

    @Test func seBuscanLasCasillasDeUnaAltura() throws {
        let ventana = CasillaCuadrada.rectangulo(columnas: 0...4, filas: 0...2)
        // En cuartas, La4 (69) está en la fila 1, columna 4; en la fila 0 caería en la columna 9, fuera, y en la 2, en
        // ninguna (empieza en 70).
        #expect(TecladoCuadrado.cuartas.casillas(de: 69, en: ventana) == [casilla(4, 1)])
        #expect(TecladoCuadrado.cuartas.casillas(de: try Altura(leyendo: "Fa4"), en: ventana) == [casilla(0, 1)])
        #expect(
            TecladoCuadrado.quintas.altura(en: casilla(1, 0), preferirBemoles: true).nota.nombre(en: .espanolCompacto)
                == "Re♭")
    }

    @Test func seGiraYSeRefleja() {
        let cuartas = TecladoCuadrado.cuartas
        let girado = cuartas.girado()
        #expect(girado.semitonosEnH == 5)
        #expect(girado.semitonosEnV == -1)
        #expect(girado.nombre == "Cuadrícula en cuartas ↻90°")
        // La misma casilla, girada, suena igual.
        for c in CasillaCuadrada.rectangulo(columnas: -2...2, filas: -2...2) {
            let movida = casilla(c.fila, -c.columna) // un cuarto de vuelta en sentido horario
            #expect(girado.midi(en: movida) == cuartas.midi(en: c))
        }
        #expect(cuartas.girado(cuartos: 4) == cuartas)
        #expect(cuartas.girado(cuartos: 2).semitonosEnH == -1)
        #expect(cuartas.girado(cuartos: -1).semitonosEnH == -5)
        #expect(cuartas.girado(cuartos: -1).nombre == "Cuadrícula en cuartas ↻270°")
        #expect(cuartas.reflejado.semitonosEnH == -1)
        #expect(cuartas.reflejado.semitonosEnV == 5)
        #expect(cuartas.reflejado.reflejado.semitonosEnH == 1)
        #expect(cuartas.description == "Cuadrícula en cuartas: H +1, V +5")
    }

    @Test func seDibujaYSeToca() {
        let ventana = CasillaCuadrada.rectangulo(columnas: 0...3, filas: 0...1)
        let svg = TecladoCuadrado.cuartas.svg(ventana, marcadas: [60, 64, 67])
        #expect(svg.hasPrefix("<svg"))
        #expect(svg.components(separatedBy: "<rect").count - 1 == 8)
        #expect(svg.contains(">Do₄<"))
        #expect(svg.contains(">Fa₄<"))
        #expect(svg.contains(DibujoSVG.Color.nota))
        // La fila de arriba se dibuja más arriba: y menor.
        #expect(TecladoCuadrado.centro(de: casilla(0, 1), lado: 40) == Punto(x: 0, y: -40))
        #expect(TecladoCuadrado.casilla(en: Punto(x: 81, y: -38), lado: 40) == casilla(2, 1))
        for c in ventana {
            #expect(TecladoCuadrado.casilla(en: TecladoCuadrado.centro(de: c, lado: 40), lado: 40) == c)
        }
        #expect(TecladoCuadrado.cuartas.svg([]).contains(#"width="0""#))
    }

    @Test func losNombresSeTraducen() {
        #expect(TecladoCuadrado.cuartas.nombre(en: .inglesASCII) == "Grid in fourths")
        #expect(TecladoCuadrado.tonnetzDeEuler.nombre(en: .alemanPalabras) == "Eulers Tonnetz")
        #expect(TecladoCuadrado.wickiHaydenCuadrado.nombre(en: .espanolCompacto) == "Wicki-Hayden (cuadrícula)")
        #expect(TecladoCuadrado.cuartas.reflejado.nombre(en: .inglesASCII) == "Cuadrícula en cuartas ⇋")
        for teclado in TecladoCuadrado.todos {
            #expect(teclado.traduccion != nil)
            #expect(teclado.nombre(en: .espanolCompacto) == teclado.nombre)
        }
    }
}
