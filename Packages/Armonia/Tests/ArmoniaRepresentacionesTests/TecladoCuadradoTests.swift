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
        #expect(ejes == [[1, 5], [1, 4], [1, 7], [2, 5], [2, 1], [7, 4], [1, 3], [1, 6], [1, 12], [1, 8]])
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
        #expect(TecladoCuadrado.quintas.altura(en: casilla(1, 0), ventana: .sostenidos).nota == Nota(.do, 1))
    }

    @Test func lasOpcionesEligenUnaVentanaDeQuintas() {
        var opciones = OpcionesDeDiagrama(preferirBemoles: true)
        #expect(opciones.ventana == .bemoles && opciones.preferirBemoles)
        opciones.preferirBemoles = false
        #expect(opciones.ventana == .sostenidos && !opciones.preferirBemoles)
        // `ventana` manda sobre `preferirBemoles`.
        opciones = OpcionesDeDiagrama(preferirBemoles: true, ventana: .centrada(en: "Re"))
        #expect(opciones.ventana == .centrada(en: "Re") && !opciones.preferirBemoles)
        #expect(OpcionesDeDiagrama() == OpcionesDeDiagrama(ventana: .sostenidos))
        let svg = TecladoCuadrado.quintas.svg([casilla(1, 0)], opciones: .init(ventana: .bemoles))
        #expect(svg.contains(">Re♭₄</text>"))
    }

    @Test func seGiraYSeRefleja() {
        let cuartas = TecladoCuadrado.cuartas
        let girado = cuartas.rotado()
        #expect(girado.semitonosEnH == 5)
        #expect(girado.semitonosEnV == -1)
        #expect(girado.nombre == "Cuadrícula en cuartas ↻90°")
        // La misma casilla, girada, suena igual.
        for c in CasillaCuadrada.rectangulo(columnas: -2...2, filas: -2...2) {
            let movida = casilla(c.fila, -c.columna) // un cuarto de vuelta en sentido horario
            #expect(girado.midi(en: movida) == cuartas.midi(en: c))
        }
        #expect(cuartas.rotado(cuartos: 4) == cuartas)
        #expect(cuartas.rotado(cuartos: 2).semitonosEnH == -1)
        #expect(cuartas.rotado(cuartos: -1).semitonosEnH == -5)
        #expect(cuartas.rotado(cuartos: -1).nombre == "Cuadrícula en cuartas ↻270°")
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
        // Las opciones comunes: la escala, el título, los bemoles y los rótulos de las marcadas.
        let grande = TecladoCuadrado.cuartas.svg(ventana, opciones: .init(titulo: "Cuartas", escala: 2))
        #expect(grande.contains(#"width="80""#) && grande.contains("<title>Cuartas</title>"))
        #expect(!svg.contains("<title>"))
        #expect(TecladoCuadrado.cuartas.svg(ventana, opciones: .init(preferirBemoles: true)).contains(">Re♭₄<"))
        let conRotulo = TecladoCuadrado.cuartas.svg(ventana, marcadas: [60: "1"])
        #expect(conRotulo.contains(">1<") && !conRotulo.contains(">Do₄<"))
    }

    @Test func seEscribenConSusEjes() throws {
        let teclado = try #require(TecladoCuadrado.conEjes("2,7"))
        #expect(teclado.semitonosEnH == 2)
        #expect(teclado.semitonosEnV == 7)
        #expect(teclado.nombre == "2,7")
        #expect(teclado.ejes == "2,7")
        #expect(TecladoCuadrado.conEjes(" -1 5 ")?.semitonosEnH == -1)
        #expect(TecladoCuadrado.conEjes("1;5", nombre: "Bajo")?.nombre == "Bajo")
        #expect(TecladoCuadrado.conEjes("1,5", midiDelOrigen: 36)?.midi(en: .origen) == 36)
        for malo in ["", "H", "1", "1,2,3", "1,x", "1,500"] {
            #expect(TecladoCuadrado.conEjes(malo) == nil, Comment(rawValue: malo))
        }
        #expect(TecladoCuadrado.cuartas.ejes == "1,5")
        #expect(TecladoCuadrado.cuartas.conOrigen(36).midi(en: casilla(1, 1)) == 42)
        #expect(TecladoCuadrado.cuartas.esCromatico)
    }

    @Test func enTonoSoloSuenanLasNotasDeLaEscala() throws {
        let doMayor = Escala(.do)
        let teclado = TecladoCuadrado.cuartas.enTono(doMayor)
        #expect(!teclado.esCromatico)
        #expect(teclado.grados == [0, 2, 4, 5, 7, 9, 11])
        #expect(teclado.semitonosEnH == 1)
        #expect(teclado.semitonosEnV == 3) // la cuarta: tres grados
        #expect(teclado.esCompleto)
        // La fila de abajo es la escala; la de encima empieza en la cuarta.
        let fila = (0...7).map { teclado.midi(en: casilla($0, 0)) }
        #expect(fila == [60, 62, 64, 65, 67, 69, 71, 72])
        #expect(teclado.midi(en: casilla(0, 1)) == 65)
        #expect(teclado.midi(en: casilla(-1, 0)) == 59)
        #expect(teclado.midi(en: casilla(0, -1)) == 55)
        // Todas las casillas son notas de la escala.
        let clases = Set(doMayor.notas.map(\.claseDeAltura))
        for c in CasillaCuadrada.rectangulo(columnas: -5...6, filas: -3...3) {
            #expect(clases.contains(modulo(teclado.midi(en: c), 12)))
        }
        // La tónica, en el origen o justo por encima: Re dórico empieza en Re4.
        let dorico = TecladoCuadrado.cuartas.enTono(Escala(.re, .dorico))
        #expect(dorico.midi(en: .origen) == 62)
        #expect(TecladoCuadrado.tonnetzDeEuler.enTono(doMayor).semitonosEnH == 4) // la quinta
        #expect(TecladoCuadrado.tonnetzDeEuler.enTono(doMayor).semitonosEnV == 2) // la tercera
        #expect(TecladoCuadrado.octavas.enTono(doMayor).semitonosEnV == 7)
        #expect(TecladoCuadrado.cuartas.reflejado.enTono(doMayor).semitonosEnH == -1)
        // Girar y reflejar no la pierden.
        #expect(teclado.rotado().grados == teclado.grados)
        #expect(teclado.reflejado.grados == teclado.grados)
        #expect(teclado.conOrigen(50).grados == teclado.grados)
        // Los grados se limpian: de 0 a 11, sin repetir y ordenados.
        #expect(TecladoCuadrado(nombre: "", semitonosEnH: 1, semitonosEnV: 1, grados: [14, 0, 2]).grados == [0, 2])
        #expect(TecladoCuadrado(nombre: "", semitonosEnH: 1, semitonosEnV: 1, grados: []).grados == [0])
    }

    @Test func lasRejillasDeLosControladores() throws {
        #expect(RejillaDeControlador.ventana.casillas.count == 84)
        #expect(RejillaDeControlador.ventana.casillas.contains(.origen))
        #expect(RejillaDeControlador.launchpad.casillas.count == 64)
        #expect(RejillaDeControlador.launchpad.casillas.first == .origen) // abajo a la izquierda
        #expect(RejillaDeControlador.linnStrument128.casillas.count == 128)
        #expect(RejillaDeControlador.linnStrument.casillas.count == 200)
        #expect(RejillaDeControlador.todas.map(\.origenPorDefecto) == [60, 36, 36, 36])
        #expect(Set(RejillaDeControlador.todas.map(\.id)).count == 4)
        #expect(RejillaDeControlador(columnas: 8, filas: 8) == .launchpad)
        #expect(RejillaDeControlador(columnas: 12, filas: 7) == .ventana)
        let otra = RejillaDeControlador(columnas: 4, filas: 2)
        #expect(otra.nombre == "4 × 2")
        #expect(otra.casillas.count == 8)
        #expect(RejillaDeControlador(comprobando: 0, filas: 8) == nil)
        #expect(RejillaDeControlador(comprobando: 8, filas: 33) == nil)
        #expect(RejillaDeControlador(comprobando: 8, filas: 8) == .launchpad)
    }

    @Test func elContornoYLaPrimeraNota() {
        let ventana = CasillaCuadrada.rectangulo(columnas: 0...3, filas: 0...1)
        // Do4 (0, 0) y Do♯4 (1, 0) marcados: un rectángulo de 2 × 1 tiene seis lados de contorno.
        let svg = TecladoCuadrado.cuartas.svg(ventana, marcadas: [60, 61], primeras: [60], contorno: true)
        #expect(svg.components(separatedBy: #"class="contorno""#).count - 1 == 6)
        #expect(svg.components(separatedBy: #"class="primera""#).count - 1 == 1)
        #expect(svg.contains(DibujoSVG.Color.primera))
        // Sin contorno, ninguno; y sin marcadas, tampoco.
        #expect(!TecladoCuadrado.cuartas.svg(ventana, marcadas: [60, 61]).contains("contorno"))
        #expect(!TecladoCuadrado.cuartas.svg(ventana, contorno: true).contains("contorno"))
    }

    @Test func losNombresSeTraducen() {
        #expect(TecladoCuadrado.cuartas.nombre(en: .inglesASCII) == "Grid in fourths")
        #expect(TecladoCuadrado.tonnetzDeEuler.nombre(en: .alemanPalabras) == "Eulers Tonnetz")
        #expect(TecladoCuadrado.wickiHaydenCuadrado.nombre(en: .espanolCompacto) == "Wicki-Hayden (cuadrícula)")
        #expect(TecladoCuadrado.secuencial.nombre(en: .inglesASCII) == "Sequential grid")
        #expect(TecladoCuadrado.tritonos.nombre(en: .alemanPalabras) == "Tritonusraster")
        #expect(TecladoCuadrado.cuartas.reflejado.nombre(en: .inglesASCII) == "Cuadrícula en cuartas ⇋")
        for teclado in TecladoCuadrado.todos {
            #expect(teclado.traduccion != nil)
            #expect(teclado.nombre(en: .espanolCompacto) == teclado.nombre)
        }
    }
}
