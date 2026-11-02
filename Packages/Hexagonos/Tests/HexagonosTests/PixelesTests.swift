import Foundation
import Testing

@testable import Hexagonos

@Suite struct TrazadoTests {
    private let raiz3 = 3.0.squareRoot()

    private func igual(_ a: Punto, _ b: Punto, sourceLocation: SourceLocation = #_sourceLocation) {
        #expect(abs(a.x - (b.x)) <= 1e-9, sourceLocation: sourceLocation)
        #expect(abs(a.y - (b.y)) <= 1e-9, sourceLocation: sourceLocation)
    }

    @Test func centrosPuntiagudos() {
        let d = Trazado(orientacion: .puntiaguda, tamano: 10)
        igual(d.centro(de: .origen), .cero)
        igual(d.centro(de: CoordenadaAxial(q: 1, r: 0)), Punto(x: 10 * raiz3, y: 0))
        igual(d.centro(de: CoordenadaAxial(q: 0, r: 1)), Punto(x: 5 * raiz3, y: 15))
    }

    @Test func centrosPlanos() {
        let d = Trazado(orientacion: .plana, tamano: 10, origen: Punto(x: 100, y: 50))
        igual(d.centro(de: .origen), Punto(x: 100, y: 50))
        igual(d.centro(de: CoordenadaAxial(q: 1, r: 0)), Punto(x: 115, y: 50 + 5 * raiz3))
        igual(d.centro(de: CoordenadaAxial(q: 0, r: 1)), Punto(x: 100, y: 50 + 10 * raiz3))
    }

    @Test func dePixelACasillaYVuelta() {
        let trazados = [
            Trazado(orientacion: .puntiaguda, tamano: Punto(x: 3, y: 2), origen: Punto(x: 1, y: -4)),
            Trazado(orientacion: .plana, tamano: Punto(x: 7, y: 5), origen: Punto(x: -2, y: 9)),
        ]
        for d in trazados {
            for casilla in CoordenadaAxial.origen.alcance(radio: 5) {
                let centro = d.centro(de: casilla)
                #expect(d.casilla(en: centro) == casilla)
                let c = d.coordenada(en: centro)
                #expect(abs(c.q - (Double(casilla.q))) <= 1e-9)
                #expect(abs(c.r - (Double(casilla.r))) <= 1e-9)
                // Un punto un poco desplazado del centro sigue en la misma casilla.
                #expect(d.casilla(en: centro + Punto(x: d.tamano.x * 0.3, y: -d.tamano.y * 0.3)) == casilla)
            }
        }
    }

    @Test func vertices() {
        for orientacion in Orientacion.allCases {
            let d = Trazado(orientacion: orientacion, tamano: 10)
            let casilla = CoordenadaAxial(q: 2, r: -1)
            let centro = d.centro(de: casilla)
            let vertices = d.vertices(de: casilla)
            #expect(vertices.count == 6)
            for (v, siguiente) in zip(vertices, vertices.dropFirst() + [vertices[0]]) {
                // Hexágono regular: todos a distancia 10 del centro y lados de 10.
                #expect(abs(hypot(v.x - centro.x, v.y - centro.y) - (10)) <= 1e-9)
                #expect(abs(hypot(v.x - siguiente.x, v.y - siguiente.y) - (10)) <= 1e-9)
            }
        }
        // El primer vértice: a 30° en los puntiagudos, a 0° en los planos.
        igual(Trazado(orientacion: .puntiaguda, tamano: 10).vertices(de: .origen)[0], Punto(x: 5 * raiz3, y: 5))
        igual(Trazado(orientacion: .plana, tamano: 10).vertices(de: .origen)[0], Punto(x: 10, y: 0))
    }

    @Test func verticesCompartidos() {
        // Dos vecinas comparten exactamente dos vértices.
        let d = Trazado(orientacion: .puntiaguda, tamano: 10)
        func redondear(_ p: Punto) -> [Double] { [(p.x * 1e6).rounded(), (p.y * 1e6).rounded()] }
        let a = Set(d.vertices(de: .origen).map(redondear))
        for vecina in CoordenadaAxial.origen.vecinos {
            #expect(a.intersection(d.vertices(de: vecina).map(redondear)).count == 2)
        }
    }

    @Test func anchuraYAltura() {
        let p = Trazado(orientacion: .puntiaguda, tamano: 10)
        #expect(abs(p.anchura - (10 * raiz3)) <= 1e-9)
        #expect(abs(p.altura - (20)) <= 1e-9)
        // En los puntiagudos, dos vecinas de la misma fila están a una anchura.
        #expect(abs(p.centro(de: CoordenadaAxial(q: 1, r: 0)).x - p.centro(de: .origen).x - (p.anchura)) <= 1e-9)
        let f = Trazado(orientacion: .plana, tamano: 10)
        #expect(abs(f.anchura - (20)) <= 1e-9)
        #expect(abs(f.altura - (10 * raiz3)) <= 1e-9)
        #expect(abs(f.centro(de: CoordenadaAxial(q: 0, r: 1)).y - f.centro(de: .origen).y - (f.altura)) <= 1e-9)
    }

    @Test func limites() {
        let d = Trazado(orientacion: .plana, tamano: 10)
        #expect(d.limites(de: []) == nil)
        let uno = d.limites(de: [.origen])
        #expect(abs((uno?.minimo.x ?? 0) - (-10)) <= 1e-9)
        #expect(abs((uno?.maximo.x ?? 0) - (10)) <= 1e-9)
        #expect(abs((uno?.minimo.y ?? 0) - (-5 * raiz3)) <= 1e-9)
        #expect(abs((uno?.maximo.y ?? 0) - (5 * raiz3)) <= 1e-9)
    }

    @Test func sVG() {
        let d = Trazado(orientacion: .puntiaguda, tamano: 10)
        let casillas = FormasDeMapa.hexagono(radio: 1)
        let svg = d.svg(casillas, relleno: { $0 == .origen ? "red" : nil }, rotulo: { "\($0.q),\($0.r)" })
        #expect(svg.hasPrefix("<svg xmlns=\"http://www.w3.org/2000/svg\""))
        #expect(svg.hasSuffix("</svg>"))
        #expect((svg.components(separatedBy: "<polygon").count - 1) == 7)
        #expect((svg.components(separatedBy: "<text").count - 1) == 7)
        #expect((svg.components(separatedBy: "fill=\"red\"").count - 1) == 1)
        #expect(svg.contains(">0,0</text>"))
        #expect(d.svg([.origen], rotulo: { _ in "<&>" }).contains("&lt;&amp;&gt;"))
        #expect(!(d.svg([.origen]).contains("<text")))
        #expect(d.svg([]).contains("width=\"0\""))
    }

    @Test func codable() throws {
        let d = Trazado(orientacion: .plana, tamano: Punto(x: 3, y: 4), origen: Punto(x: 1, y: 2))
        #expect(try (JSONDecoder().decode(Trazado.self, from: JSONEncoder().encode(d))) == d)
    }

    @Test func puntos() {
        #expect((Punto(x: 3, y: 5) - Punto(x: 1, y: 7)) == Punto(x: 2, y: -2))
        #expect((Punto(x: 1, y: 2) + Punto(x: 1, y: 2) - Punto(x: 1, y: 2)) == Punto(x: 1, y: 2))
        #expect(Punto(x: 1.5, y: -2).description == "(x: 1.5, y: -2.0)")
    }

    @Test func lasComillasSeEscapan() {
        let d = Trazado(orientacion: .plana, tamano: 10)
        let svg = d.svg([.origen], relleno: { _ in #"a"b"# }, rotulo: { _ in #"«"»"# })
        #expect(svg.contains(#"fill="a&quot;b""#))
        #expect(svg.contains(">«&quot;»</text>"))
    }
}
