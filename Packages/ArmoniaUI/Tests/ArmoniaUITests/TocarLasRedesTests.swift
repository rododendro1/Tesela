import XCTest
import Armonia
import Hexagonos
@testable import ArmoniaUI

// Qué nota suena al tocar el dibujo de una red en la app Tonnetz. No usa SwiftUI: se ejecuta también en Linux.

final class TocarLasRedesTests: XCTestCase {
    func testLaCajaDelSVG() {
        let caja = PresentacionSVG.caja(de: #"<svg xmlns="http://www.w3.org/2000/svg" viewBox="-10.5 -20 100 50">"#)
        XCTAssertEqual(caja?.x, -10.5)
        XCTAssertEqual(caja?.y, -20)
        XCTAssertEqual(caja?.ancho, 100)
        XCTAssertEqual(caja?.alto, 50)
        XCTAssertNil(PresentacionSVG.caja(de: "<svg>"))
        XCTAssertNil(PresentacionSVG.caja(de: #"<svg viewBox="0 0 0 10">"#))
    }

    func testElToqueSePasaALasCoordenadasDelDibujo() {
        // Un dibujo de 100 × 50 en una vista de 200 × 200: se ve a doble tamaño, centrado en vertical.
        let svg = #"<svg viewBox="0 0 100 50"></svg>"#
        let punto = PresentacionSVG.punto(en: Punto(x: 100, y: 100), de: svg, ancho: 200, alto: 200)
        XCTAssertEqual(punto?.x, 50)
        XCTAssertEqual(punto?.y, 25)
        // En la franja vacía de arriba, nada.
        XCTAssertNil(PresentacionSVG.punto(en: Punto(x: 100, y: 10), de: svg, ancho: 200, alto: 200))
    }

    func testEnElTonnetzSuenaLaNotaTocada() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let trazado = Tonnetz.trazado(paso: PresentacionDeRedes.paso(doMayor, en: .tonnetz))
        func midi(_ quintas: Int, _ terceras: Int) -> Int? {
            PresentacionDeRedes.midi(en: trazado.centro(de: CoordenadaAxial(q: quintas, r: terceras)), de: doMayor,
                                     enLaRed: .tonnetz)
        }
        XCTAssertEqual(midi(0, 0), 60)    // Do
        XCTAssertEqual(midi(1, 0), 67)    // Sol
        XCTAssertEqual(midi(0, 1), 64)    // Mi
        XCTAssertEqual(midi(-1, 0), 65)   // Fa
        // Entre Do y Sol no hay nota.
        let entre = trazado.centro(de: CoordenadaAxial(q: 0, r: 0)).x / 2 + trazado.centro(de: CoordenadaAxial(q: 1, r: 0)).x / 2
        XCTAssertNil(PresentacionDeRedes.midi(en: Punto(x: entre, y: 0), de: doMayor, enLaRed: .tonnetz))
    }

    func testEnLaTablaYEnLosTecladosTambien() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let tabla = TablaArmonica.trazado(paso: PresentacionDeRedes.paso(doMayor, en: .tablaArmonica))
        let sol = tabla.centro(de: TablaArmonica.coordenada(de: PuntoDeLaRed(quintas: 1, terceras: 0)))
        XCTAssertEqual(PresentacionDeRedes.midi(en: sol, de: doMayor, enLaRed: .tablaArmonica), 67)

        for red in RedDeNotas.allCases where red.teclado != nil {
            let teclado = try XCTUnwrap(red.teclado)
            let trazado = Trazado(orientacion: teclado.orientacion, tamano: PresentacionDeRedes.tamanoDelTeclado)
            for casilla in PresentacionDeRedes.casillasDelTeclado(teclado).prefix(20) {
                XCTAssertEqual(PresentacionDeRedes.midi(en: trazado.centro(de: casilla), de: doMayor, enLaRed: red),
                               teclado.midi(en: casilla), "\(red) \(casilla)")
            }
            // Fuera del teclado, nada.
            XCTAssertNil(PresentacionDeRedes.midi(en: Punto(x: 10_000, y: 0), de: doMayor, enLaRed: red))
        }
    }

    func testElTecladoUILSeGiraYSeRefleja() throws {
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        var ajuste = AjusteUIL(texto: "2,7,5;R30M")
        XCTAssertEqual(ajuste.resultado, "2,7,5;R30M")
        // Un giro de −30° lo deja plano (el Wicki-Hayden plano); de +30°, también plano pero girado el otro lado.
        ajuste.giros = -1
        XCTAssertEqual(ajuste.resultado, "2,7,5;R0M")
        XCTAssertEqual(ajuste.teclado?.orientacion, .plana)
        ajuste.giros = 12
        XCTAssertEqual(ajuste.resultado, "2,7,5;R30M")
        ajuste.espejo = true
        XCTAssertEqual(ajuste.resultado, "2,7,5;R330")
        XCTAssertEqual(PresentacionDeRedes.teclado(de: .uil, uil: ajuste)?.orientacion, .puntiaguda)
        XCTAssertNil(PresentacionDeRedes.teclado(de: .tonnetz, uil: ajuste))

        // Se dibuja y se toca igual que los otros teclados.
        let teclado = try XCTUnwrap(ajuste.teclado)
        let svg = try XCTUnwrap(PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolUnicode, uil: ajuste))
        XCTAssertTrue(svg.contains(">Do4<"))
        let trazado = Trazado(orientacion: teclado.orientacion, tamano: PresentacionDeRedes.tamanoDelTeclado)
        for casilla in PresentacionDeRedes.casillasDelTeclado(teclado).prefix(20) {
            XCTAssertEqual(PresentacionDeRedes.midi(en: trazado.centro(de: casilla), de: doMayor, enLaRed: .uil, uil: ajuste),
                           teclado.midi(en: casilla))
        }
        XCTAssertEqual(PresentacionDeRedes.nombre(doMayor, en: .uil, notacion: .espanolUnicode, uil: ajuste), "UIL 2,7,5;R330 · Do")

        // Un texto que no es UIL no se dibuja ni suena.
        ajuste.texto = "7,5,2"
        XCTAssertNil(ajuste.teclado)
        XCTAssertNil(ajuste.resultado)
        XCTAssertNil(PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolUnicode, uil: ajuste))
        XCTAssertNil(PresentacionDeRedes.midi(en: Punto(x: 0, y: 0), de: doMayor, enLaRed: .uil, uil: ajuste))
        XCTAssertEqual(AjusteUIL.conocidos.count, 8)
    }

    func testLosRecorridosSeDibujanConMasSitio() throws {
        let acordes = try ["Do", "Lam", "Fa"].map { try Acorde(leyendo: $0) }
        XCTAssertEqual(PresentacionDeRedes.paso(.recorrido(acordes), en: .tonnetz), 88)
        XCTAssertEqual(PresentacionDeRedes.paso(.recorrido(Array(acordes.prefix(1))), en: .tonnetz), 64)
        XCTAssertEqual(PresentacionDeRedes.paso(.recorrido(acordes), en: .tablaArmonica), 72)
        // Y el dibujo usa ese paso: el radio de las notas es 0,26 · paso.
        let svg = try XCTUnwrap(PresentacionDeRedes.svg(.recorrido(acordes), en: .tonnetz, notacion: .espanolUnicode))
        XCTAssertTrue(svg.contains(#"r="22.9""#), "el círculo de una nota con paso 88")
    }
}
