import Foundation
import Hexagonos
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// El Tonnetz, la tabla armónica y los teclados isomórficos sobre la rejilla de `Hexagonos`.
@Suite struct RedesSobreHexagonosTests {
    private func punto(_ a: Int, _ b: Int) -> PuntoDeLaRed { PuntoDeLaRed(quintas: a, terceras: b) }
    private let region = FormasDeMapa.hexagono(radio: 5)

    // MARK: Tonnetz

    @Test func unPuntoEsUnaCasilla() {
        #expect(punto(2, -1).coordenada == CoordenadaAxial(q: 2, r: -1))
        #expect(PuntoDeLaRed(CoordenadaAxial(q: 0, r: 1)).nota == Nota.mi)
        for casilla in region {
            #expect(PuntoDeLaRed(casilla).coordenada == casilla)
        }
    }

    @Test func losVecinosDelTonnetzSonLosDeLaRejilla() {
        let p = punto(1, 2)
        #expect(Set(p.vecinos.map(\.coordenada)) == Set(p.coordenada.vecinos))
    }

    @Test func laDistanciaEsLaDeLaRejilla() {
        // La fórmula de antes, para comprobar que no cambia.
        func distanciaAnterior(_ p: PuntoDeLaRed, _ o: PuntoDeLaRed) -> Int {
            let x = o.quintas - p.quintas
            let y = o.terceras - p.terceras
            return (x >= 0) == (y >= 0) ? abs(x) + abs(y) : max(abs(x), abs(y))
        }
        let centro = punto(1, -2)
        for casilla in region {
            let p = PuntoDeLaRed(casilla)
            #expect(centro.distancia(hasta: p) == distanciaAnterior(centro, p), "\(p)")
        }
    }

    @Test func elTrazadoDelTonnetzEsElDelDibujo() {
        for paso in [64.0, 88, 50] {
            let d = Tonnetz.trazado(paso: paso)
            for casilla in region {
                let p = PuntoDeLaRed(casilla)
                let centro = d.centro(de: p.coordenada)
                // Las fórmulas que usaba el dibujo: x = (a + b/2)·paso, y = −b·(√3/2)·paso.
                #expect(abs(centro.x - ((Double(p.quintas) + Double(p.terceras) / 2) * paso)) <= 1e-9)
                #expect(abs(centro.y - (-Double(p.terceras) * paso * 0.8660254037844386)) <= 1e-9)
                #expect(Tonnetz.punto(en: centro, paso: paso) == p)
                // Cerca de la nota (a menos de medio paso) sigue siendo la misma.
                #expect(Tonnetz.punto(en: Punto(x: centro.x + paso * 0.3, y: centro.y - paso * 0.2), paso: paso) == p)
            }
        }
        // La quinta, a la derecha; la tercera mayor, arriba a la derecha (y hacia abajo en SVG).
        let d = Tonnetz.trazado(paso: 64)
        #expect(d.centro(de: punto(1, 0).coordenada).x > 0)
        #expect(d.centro(de: punto(0, 1).coordenada).y < 0)
    }

    // MARK: Tabla armónica

    @Test func laTablaEsElTonnetzGirado() {
        #expect(TablaArmonica.coordenada(de: punto(1, 0)) == CoordenadaAxial(q: 0, r: -1)) // la quinta, arriba
        #expect(TablaArmonica.coordenada(de: punto(0, 1)) == CoordenadaAxial(q: 1, r: -1)) // la tercera mayor
        for casilla in region {
            let p = PuntoDeLaRed(casilla)
            #expect(TablaArmonica.punto(de: TablaArmonica.coordenada(de: p)) == p)
            // Girar no cambia las distancias: dos hexágonos vecinos siguen siéndolo.
            #expect(TablaArmonica.coordenada(de: p).distanciaAlOrigen == p.coordenada.distanciaAlOrigen)
        }
    }

    @Test func elTrazadoDeLaTablaEsElDelDibujo() {
        for paso in [56.0, 72] {
            let d = TablaArmonica.trazado(paso: paso)
            #expect(d.orientacion == .plana)
            #expect(abs(d.tamano.x - (paso / (2 * 0.8660254037844386))) <= 1e-9)
            for casilla in region {
                let p = PuntoDeLaRed(casilla)
                let centro = d.centro(de: TablaArmonica.coordenada(de: p))
                // Las fórmulas que usaba el dibujo: x = b·cos 30°·paso, y = −(a + b/2)·paso.
                #expect(abs(centro.x - (Double(p.terceras) * 0.8660254037844386 * paso)) <= 1e-9)
                #expect(abs(centro.y - (-(Double(p.quintas) + Double(p.terceras) / 2) * paso)) <= 1e-9)
                #expect(TablaArmonica.punto(en: centro, paso: paso) == p)
            }
        }
    }

    @Test func elDibujoSigueIgual() throws {
        // Un hexágono por punto de la ventana, y los vértices del de Do donde estaban.
        let svg = TablaArmonica(Acorde("Do")).svg(leyenda: false)
        let raiz = try #require(ElementoXML.leer(svg))
        #expect(!(raiz.todos("polygon").isEmpty))
        let paso = 56.0
        let radio = paso / (2 * 0.8660254037844386)
        let esperados = stride(from: 0.0, to: 360, by: 60).map { angulo in
            "\(DibujoSVG.f(radio * cos(angulo * .pi / 180))),\(DibujoSVG.f(radio * sin(angulo * .pi / 180)))"
        }.joined(separator: " ")
        #expect(svg.contains("points=\"\(esperados)\""), "No está el hexágono de Do en (0, 0)")
        #expect(ElementoXML.leer(Tonnetz(Acorde("Do")).svg()) != nil)
    }

    // MARK: Teclados isomórficos

    @Test func laTablaArmonicaComoTeclado() {
        let teclado = TecladoIsomorfico.tablaArmonica
        for casilla in region {
            let p = PuntoDeLaRed(casilla)
            #expect(teclado.midi(en: TablaArmonica.coordenada(de: p)) == TablaArmonica.midi(de: p))
        }
        // Arriba (el norte de los planos), una quinta; arriba a la derecha, una tercera mayor; arriba a la izquierda, una menor.
        #expect(teclado.semitonos(hacia: DireccionHexagonal(.norte, .plana)!) == 7)
        #expect(teclado.semitonos(hacia: DireccionHexagonal(.noreste, .plana)!) == 4)
        #expect(teclado.semitonos(hacia: DireccionHexagonal(.noroeste, .plana)!) == 3)
    }

    @Test func wickiHaydenYJanko() {
        let wh = TecladoIsomorfico.wickiHayden
        #expect(wh.semitonos(hacia: DireccionHexagonal(.este, .puntiaguda)!) == 2)
        #expect(wh.semitonos(hacia: DireccionHexagonal(.noreste, .puntiaguda)!) == 7)
        #expect(wh.semitonos(hacia: DireccionHexagonal(.noroeste, .puntiaguda)!) == 5)
        let janko = TecladoIsomorfico.janko
        #expect(janko.semitonos(hacia: DireccionHexagonal(.este, .puntiaguda)!) == 2)
        #expect(janko.semitonos(hacia: DireccionHexagonal(.noreste, .puntiaguda)!) == 1)
        #expect(janko.semitonos(hacia: DireccionHexagonal(.sureste, .puntiaguda)!) == 1)
        for teclado in [wh, janko, .tablaArmonica] {
            for d in DireccionHexagonal.allCases {
                #expect(teclado.semitonos(hacia: d) == -teclado.semitonos(hacia: d.opuesta))
            }
        }
    }

    @Test func elAcordeonYLasVariantesDeWickiHayden() {
        func vecinos(_ teclado: TecladoIsomorfico, _ a: PuntoCardinal, _ b: PuntoCardinal, _ c: PuntoCardinal) -> [Int]
        {
            [a, b, c].map { teclado.semitonos(hacia: DireccionHexagonal($0, teclado.orientacion)!) }
        }
        // Acordeón C: arriba una tercera menor, arriba a la derecha un semitono y arriba a la izquierda un tono.
        #expect(vecinos(.acordeonC, .norte, .noreste, .noroeste) == [3, 1, 2])
        // Sistema B: el espejo (el tono y el semitono, intercambiados).
        #expect(vecinos(.acordeonB, .norte, .noreste, .noroeste) == [3, 2, 1])
        // Wicki-Hayden plano: la quinta arriba, el tono arriba a la derecha y la cuarta arriba a la izquierda.
        #expect(vecinos(.wickiHaydenPlano, .norte, .noreste, .noroeste) == [7, 2, 5])
        // En espejo: la cuarta a la derecha y la quinta a la izquierda; el tono, hacia la izquierda.
        #expect(vecinos(.wickiHaydenEspejo, .este, .noreste, .noroeste) == [-2, 5, 7])
        for teclado in [TecladoIsomorfico.acordeonC, .acordeonB, .wickiHaydenPlano, .wickiHaydenEspejo] {
            for d in DireccionHexagonal.allCases {
                #expect(
                    teclado.semitonos(hacia: d) == -teclado.semitonos(hacia: d.opuesta),
                    Comment(rawValue: teclado.nombre))
            }
            #expect(teclado.midi(en: .origen) == 60)
        }
        // El acordeón cromático lo recorre todo con semitonos, tonos y terceras menores.
        let cromatico = Set(DireccionHexagonal.allCases.map { abs(TecladoIsomorfico.acordeonC.semitonos(hacia: $0)) })
        #expect(cromatico == [1, 2, 3])
    }

    @Test func gerhardYPark() {
        func vecinos(_ teclado: TecladoIsomorfico, _ a: PuntoCardinal, _ b: PuntoCardinal, _ c: PuntoCardinal) -> [Int]
        {
            [a, b, c].map { teclado.semitonos(hacia: DireccionHexagonal($0, teclado.orientacion)!) }
        }
        // Gerhard: arriba un semitono, arriba a la derecha una tercera mayor y abajo a la derecha una menor.
        #expect(vecinos(.gerhard, .norte, .noreste, .sureste) == [1, 4, 3])
        // Park: a la derecha una cuarta, arriba a la derecha una tercera menor y abajo a la derecha un tono.
        #expect(vecinos(.park, .este, .noreste, .sureste) == [5, 3, 2])
        for teclado in [TecladoIsomorfico.gerhard, .park] {
            for d in DireccionHexagonal.allCases {
                #expect(
                    teclado.semitonos(hacia: d) == -teclado.semitonos(hacia: d.opuesta),
                    Comment(rawValue: teclado.nombre))
            }
            #expect(teclado.midi(en: .origen) == 60)
            // Son completos: en un hexágono de radio 3 alrededor del Do4 suenan las doce notas.
            let clases = Set(FormasDeMapa.hexagono(radio: 3).map { (teclado.midi(en: $0) % 12 + 12) % 12 })
            #expect(clases.count == 12, Comment(rawValue: teclado.nombre))
        }
        // La escala cromática sube por cada columna de Gerhard.
        let columna = (0...12).map { TecladoIsomorfico.gerhard.midi(en: CoordenadaAxial(q: 0, r: -$0)) }
        #expect(columna == Array(60...72))
    }

    @Test func isomorfico() {
        // La misma forma suena al mismo acorde transportado: una tríada mayor desde cualquier casilla.
        let teclado = TecladoIsomorfico.wickiHayden
        let forma = [CoordenadaAxial.origen, CoordenadaAxial(q: 2, r: 0), CoordenadaAxial(q: 1, r: -1)] // Do, Mi, Sol
        #expect(forma.map { teclado.midi(en: $0) } == [60, 64, 67])
        for desplazamiento in region {
            let midis = forma.map { teclado.midi(en: $0 + desplazamiento) }
            #expect(midis.map { $0 - midis[0] } == [0, 4, 7])
        }
    }

    @Test func alturasYCasillas() {
        let teclado = TecladoIsomorfico.wickiHayden
        #expect(teclado.midi(en: .origen) == 60)
        #expect(teclado.casillas(de: 67, en: FormasDeMapa.hexagono(radio: 3)) == [CoordenadaAxial(q: 1, r: -1)])
        #expect(
            teclado.casillas(de: Altura("Sol4"), en: FormasDeMapa.hexagono(radio: 3)) == [CoordenadaAxial(q: 1, r: -1)])
        #expect(teclado.altura(en: CoordenadaAxial(q: 0, r: -1)).midi == 65)
        #expect(
            teclado.altura(en: CoordenadaAxial(q: 1, r: 0), preferirBemoles: true).nota.nombre(en: .espanolCompacto)
                == "Re")
        #expect(
            teclado.altura(en: CoordenadaAxial(q: 0, r: 1), preferirBemoles: true).nota.nombre(en: .espanolCompacto)
                == "Sol")
        #expect("\(teclado)" == "Wicki-Hayden: q +2, r -5")
        let otro = TecladoIsomorfico(
            nombre: "Prueba", orientacion: .plana, semitonosEnQ: 1, semitonosEnR: 3, midiDelOrigen: 48)
        #expect(otro.midi(en: CoordenadaAxial(q: 2, r: 1)) == 53)
    }

    @Test func sVGDelTeclado() throws {
        let teclado = TecladoIsomorfico.janko
        let casillas = FormasDeMapa.rectangulo(columnas: 6, filas: 2, .filasImpares)
        let svg = teclado.svg(casillas, marcadas: [60, 64, 67])
        let raiz = try #require(ElementoXML.leer(svg))
        #expect(raiz.todos("polygon").count == 12)
        #expect(svg.contains(">Do₄<"))
        #expect(svg.contains(DibujoSVG.Color.nota))
        #expect(svg.contains("#bbbbbb"))
        #expect(teclado.svg(casillas, notacion: .inglesASCII).contains(">C4<"))
    }

    @Test func elCatalogoDeTecladosYSusNombres() {
        #expect(TecladoIsomorfico.todos.count == 9)
        #expect(Set(TecladoIsomorfico.todos.map(\.nombre)).count == 9)
        #expect(TecladoIsomorfico.tablaArmonica.nombre(en: .inglesASCII) == "Harmonic table")
        #expect(TecladoIsomorfico.acordeonB.nombre(en: .aleman) == "Akkordeon B-Griff")
        #expect(TecladoIsomorfico.wickiHaydenEspejo.nombre(en: .espanolCompacto) == "Wicki-Hayden (espejo)")
        // Los nombres propios no se traducen, ni el de un teclado que no es del catálogo.
        #expect(TecladoIsomorfico.janko.nombre(en: .ruso) == "Jankó")
        #expect(TecladoIsomorfico.gerhard.traduccion == nil)
        let propio = TecladoIsomorfico(nombre: "Mío", orientacion: .plana, semitonosEnQ: 1, semitonosEnR: 2)
        #expect(propio.nombre(en: .inglesASCII) == "Mío")
        // En español, el nombre traducido es el del propio teclado.
        for teclado in TecladoIsomorfico.todos {
            #expect(teclado.nombre(en: .espanolCompacto) == teclado.nombre)
        }
    }
}
