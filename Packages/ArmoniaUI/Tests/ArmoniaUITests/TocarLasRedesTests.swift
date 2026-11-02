import Armonia
import Foundation
import Hexagonos
import Testing

@testable import ArmoniaUI

// Qué nota suena al tocar el dibujo de una red en la app Tonnetz. No usa SwiftUI: se ejecuta también en Linux.

@Suite struct TocarLasRedesTests {
    @Test func laCajaDelSVG() {
        let caja = PresentacionSVG.caja(de: #"<svg xmlns="http://www.w3.org/2000/svg" viewBox="-10.5 -20 100 50">"#)
        #expect(caja?.x == -10.5)
        #expect(caja?.y == -20)
        #expect(caja?.ancho == 100)
        #expect(caja?.alto == 50)
        #expect(PresentacionSVG.caja(de: "<svg>") == nil)
        #expect(PresentacionSVG.caja(de: #"<svg viewBox="0 0 0 10">"#) == nil)
    }

    @Test func elToqueSePasaALasCoordenadasDelDibujo() {
        // Un dibujo de 100 × 50 en una vista de 200 × 200: se ve a doble tamaño, centrado en vertical.
        let svg = #"<svg viewBox="0 0 100 50"></svg>"#
        let punto = PresentacionSVG.punto(en: Punto(x: 100, y: 100), de: svg, ancho: 200, alto: 200)
        #expect(punto?.x == 50)
        #expect(punto?.y == 25)
        // En la franja vacía de arriba, nada.
        #expect(PresentacionSVG.punto(en: Punto(x: 100, y: 10), de: svg, ancho: 200, alto: 200) == nil)
        #expect(PresentacionSVG.punto(en: Punto(x: 0, y: 0), de: svg, ancho: 0, alto: 200) == nil)
    }

    @Test func enElTonnetzSuenaLaNotaTocada() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let trazado = Tonnetz.trazado(paso: PresentacionDeRedes.paso(doMayor, en: .tonnetz))
        func midi(_ quintas: Int, _ terceras: Int) -> Int? {
            PresentacionDeRedes.midi(
                en: trazado.centro(de: CoordenadaAxial(q: quintas, r: terceras)), de: doMayor,
                enLaRed: .tonnetz)
        }
        #expect(midi(0, 0) == 60) // Do
        #expect(midi(1, 0) == 67) // Sol
        #expect(midi(0, 1) == 64) // Mi
        #expect(midi(-1, 0) == 65) // Fa
        // Entre Do y Sol no hay nota.
        let entre =
            trazado.centro(de: CoordenadaAxial(q: 0, r: 0)).x / 2 + trazado.centro(de: CoordenadaAxial(q: 1, r: 0)).x
            / 2
        #expect(PresentacionDeRedes.midi(en: Punto(x: entre, y: 0), de: doMayor, enLaRed: .tonnetz) == nil)
    }

    @Test func enLaTablaYEnLosTecladosTambien() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let tabla = TablaArmonica.trazado(paso: PresentacionDeRedes.paso(doMayor, en: .tablaArmonica))
        let sol = tabla.centro(de: TablaArmonica.coordenada(de: PuntoDeLaRed(quintas: 1, terceras: 0)))
        #expect(PresentacionDeRedes.midi(en: sol, de: doMayor, enLaRed: .tablaArmonica) == 67)

        for red in RedDeNotas.allCases where red.teclado != nil {
            let teclado = try #require(red.teclado)
            let trazado = Trazado(orientacion: teclado.orientacion, tamano: PresentacionDeRedes.tamanoDelTeclado)
            for casilla in PresentacionDeRedes.casillasDelTeclado(teclado).prefix(20) {
                #expect(
                    PresentacionDeRedes.midi(en: trazado.centro(de: casilla), de: doMayor, enLaRed: red)
                        == teclado.midi(en: casilla), "\(red) \(casilla)")
            }
            // Fuera del teclado, nada.
            #expect(PresentacionDeRedes.midi(en: Punto(x: 10_000, y: 0), de: doMayor, enLaRed: red) == nil)
        }
    }

    @Test func elTecladoUILSeGiraYSeRefleja() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        var ajuste = AjusteUIL(texto: "2,7,5;R30M")
        #expect(ajuste.resultado == "2,7,5;R30M")
        // Un giro de −30° lo deja plano (el Wicki-Hayden plano); de +30°, también plano pero girado el otro lado.
        ajuste.giros = -1
        #expect(ajuste.resultado == "2,7,5;R0M")
        #expect(ajuste.teclado?.orientacion == .plana)
        ajuste.giros = 12
        #expect(ajuste.resultado == "2,7,5;R30M")
        ajuste.espejo = true
        #expect(ajuste.resultado == "2,7,5;R330")
        #expect(PresentacionDeRedes.teclado(de: .uil, uil: ajuste)?.orientacion == .puntiaguda)
        #expect(PresentacionDeRedes.teclado(de: .tonnetz, uil: ajuste) == nil)

        // Se dibuja y se toca igual que los otros teclados.
        let teclado = try #require(ajuste.teclado)
        let svg = try #require(PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolCompacto, uil: ajuste))
        #expect(svg.contains(">Do₄<"))
        let trazado = Trazado(orientacion: teclado.orientacion, tamano: PresentacionDeRedes.tamanoDelTeclado)
        for casilla in PresentacionDeRedes.casillasDelTeclado(teclado).prefix(20) {
            #expect(
                PresentacionDeRedes.midi(en: trazado.centro(de: casilla), de: doMayor, enLaRed: .uil, uil: ajuste)
                    == teclado.midi(en: casilla))
        }
        #expect(
            PresentacionDeRedes.nombre(doMayor, en: .uil, notacion: .espanolCompacto, uil: ajuste)
                == "UIL 2,7,5;R330 · Do")

        // Un texto que no es UIL no se dibuja ni suena.
        ajuste.texto = "7,5,2"
        #expect(ajuste.teclado == nil)
        #expect(ajuste.resultado == nil)
        #expect(PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolCompacto, uil: ajuste) == nil)
        #expect(PresentacionDeRedes.midi(en: Punto(x: 0, y: 0), de: doMayor, enLaRed: .uil, uil: ajuste) == nil)
        #expect(AjusteUIL.conocidos.count == 8)
    }

    @Test func losRecorridosSeDibujanConMasSitio() throws {
        let acordes = try ["Do", "Lam", "Fa"].map { try Acorde(leyendo: $0) }
        #expect(PresentacionDeRedes.paso(.recorrido(acordes), en: .tonnetz) == 88)
        #expect(PresentacionDeRedes.paso(.recorrido(Array(acordes.prefix(1))), en: .tonnetz) == 64)
        #expect(PresentacionDeRedes.paso(.recorrido(acordes), en: .tablaArmonica) == 72)
        // Y el dibujo usa ese paso: el radio de las notas es 0,26 · paso.
        let svg = try #require(PresentacionDeRedes.svg(.recorrido(acordes), en: .tonnetz, notacion: .espanolCompacto))
        #expect(svg.contains(#"r="22.9""#), "el círculo de una nota con paso 88")
    }

    @Test func paraIdentificarSeMarcanYSeQuitanLasNotasTocadas() throws {
        #expect(PresentacionDeRedes.alternar(64, en: [0, 7]) == [0, 7, 4])
        #expect(PresentacionDeRedes.alternar(60, en: [0, 7]) == [7])
        #expect(PresentacionDeRedes.alternar(72, en: [0]) == []) // la misma clase, en otra octava
        // La primera tocada es el bajo.
        #expect(PresentacionDeRedes.acordes(de: [0, 4, 7]).first?.cifrado(en: .espanolCompacto) == "Do")
        #expect(PresentacionDeRedes.acordes(de: [4, 7, 0]).first?.cifrado(en: .espanolCompacto) == "Do/Mi")
        #expect(PresentacionDeRedes.acordes(de: [7, 11, 2, 5]).first?.cifrado(en: .espanolCompacto) == "Sol7")
        #expect(PresentacionDeRedes.acordes(de: [0]).isEmpty)
    }

    @Test func lasNotasTocadasSeDibujanEnTodasLasRedes() throws {
        for red in RedDeNotas.allCases where red != .uil {
            for clases in [[], [0, 4, 7]] {
                #expect(
                    PresentacionDeRedes.svg(.clases(clases), en: red, notacion: .espanolCompacto) != nil,
                    "\(red) \(clases)")
            }
        }
        // Y se tocan como las de un acorde.
        let tocadas = ContenidoDeRed.clases([0, 4, 7])
        #expect(tocadas.notas == [.do, .mi, .sol])
        let trazado = Tonnetz.trazado(paso: PresentacionDeRedes.paso(tocadas, en: .tonnetz))
        #expect(
            PresentacionDeRedes.midi(
                en: trazado.centro(de: CoordenadaAxial(q: 1, r: 0)), de: tocadas,
                enLaRed: .tonnetz) == 67)
        #expect(PresentacionDeRedes.nombre(tocadas, en: .tonnetz, notacion: .espanolCompacto) == "Tonnetz · Do")
    }
}
