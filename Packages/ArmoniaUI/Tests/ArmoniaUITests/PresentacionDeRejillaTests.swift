import Foundation
import Hexagonos
import Testing

@testable import ArmoniaUI

// No usa SwiftUI: se ejecuta también en Linux.

@Suite struct PresentacionDeRejillaTests {
    private let mapa = FormasDeMapa.hexagono(radio: 2)

    @Test func laProporcionEsLaDeLosHexagonos() throws {
        let raiz3 = 3.0.squareRoot()
        // Un solo hexágono puntiagudo mide √3 de ancho por 2 de alto; uno plano, al revés.
        #expect(
            try abs(#require(PresentacionDeRejilla.proporcion(de: [.origen], orientacion: .puntiaguda)) - (raiz3 / 2))
                <= 1e-9)
        #expect(
            try abs(#require(PresentacionDeRejilla.proporcion(de: [.origen], orientacion: .plana)) - (2 / raiz3))
                <= 1e-9)
        #expect(PresentacionDeRejilla.proporcion(de: [], orientacion: .plana) == nil)
    }

    @Test func elMapaCabeCentradoYConMargen() throws {
        for orientacion in Orientacion.allCases {
            for (ancho, alto) in [(300.0, 200.0), (120.0, 400.0)] {
                let d = try #require(
                    PresentacionDeRejilla.trazado(
                        para: mapa, orientacion: orientacion,
                        ancho: ancho, alto: alto, margen: 5))
                let caja = try #require(d.limites(de: mapa))
                #expect(caja.minimo.x >= (5 - 1e-9))
                #expect(caja.minimo.y >= (5 - 1e-9))
                #expect(caja.maximo.x <= (ancho - 5 + 1e-9))
                #expect(caja.maximo.y <= (alto - 5 + 1e-9))
                // Centrado en los dos ejes, y tocando el margen en al menos uno (lo más grande posible).
                #expect(abs(caja.minimo.x + caja.maximo.x - (ancho)) <= 1e-9)
                #expect(abs(caja.minimo.y + caja.maximo.y - (alto)) <= 1e-9)
                let holguraX = caja.minimo.x - 5
                let holguraY = caja.minimo.y - 5
                #expect(abs(min(holguraX, holguraY) - (0)) <= 1e-9)
            }
        }
    }

    @Test func sinCasillasOSinSitioNoHayTrazado() {
        #expect(PresentacionDeRejilla.trazado(para: [], orientacion: .plana, ancho: 100, alto: 100) == nil)
        #expect(PresentacionDeRejilla.trazado(para: mapa, orientacion: .plana, ancho: 10, alto: 10, margen: 5) == nil)
        #expect(PresentacionDeRejilla.trazado(para: mapa, orientacion: .plana, ancho: 0, alto: 0) == nil)
    }

    @Test func elToqueDaLaCasillaDelMapa() throws {
        let d = try #require(
            PresentacionDeRejilla.trazado(
                para: mapa, orientacion: .puntiaguda,
                ancho: 300, alto: 300, margen: 3))
        let conjunto = Set(mapa)
        for casilla in mapa {
            #expect(PresentacionDeRejilla.casilla(en: d.centro(de: casilla), trazado: d, mapa: conjunto) == casilla)
        }
        // Fuera del mapa: la esquina del rectángulo y una casilla que no está.
        #expect(PresentacionDeRejilla.casilla(en: Punto(x: 1, y: 1), trazado: d, mapa: conjunto) == nil)
        let fuera = CoordenadaAxial(q: 3, r: 0)
        #expect(PresentacionDeRejilla.casilla(en: d.centro(de: fuera), trazado: d, mapa: conjunto) == nil)
    }

    @Test func descripcion() {
        #expect(PresentacionDeRejilla.descripcion(casillas: 19, seleccionada: nil) == "19 casillas")
        #expect(
            PresentacionDeRejilla.descripcion(casillas: 1, seleccionada: CoordenadaAxial(q: 2, r: -1))
                == "1 casilla; elegida q 2, r -1")
    }
}
