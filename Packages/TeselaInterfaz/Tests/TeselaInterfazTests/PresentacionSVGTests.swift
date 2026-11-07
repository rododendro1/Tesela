import Foundation
import Hexagonos
import Testing

@testable import TeselaInterfaz

// Dónde se toca un dibujo SVG que `VistaSVG` muestra entero y centrado. No usa SwiftUI: se ejecuta también en Linux.

@Suite struct PresentacionSVGTests {
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
}
