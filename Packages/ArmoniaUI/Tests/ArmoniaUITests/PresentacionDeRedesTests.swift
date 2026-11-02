import Armonia
import Foundation
import Hexagonos
import Testing

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// Las presentaciones de las redes (Tonnetz, tabla armónica y teclados). No usan SwiftUI: se ejecutan también en
// Linux.

@Suite struct PresentacionDeRedesTests {
    @Test func cadaRedDibujaCadaContenido() throws {
        let contenidos: [ContenidoDeRed] = [
            .acorde(try Acorde(leyendo: "Dom7")),
            .escala(try Escala(leyendo: "Re dórico")),
            .recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam"), try Acorde(leyendo: "Fa")]),
            .recorrido([try Acorde(leyendo: "Do")]),
        ]
        for red in RedDeNotas.allCases {
            for contenido in contenidos {
                let svg = try #require(
                    PresentacionDeRedes.svg(contenido, en: red, notacion: .espanolCompacto), "\(red)")
                #expect(svg.contains("<svg"), "\(red) \(contenido)")
            }
        }
    }

    @Test func unRecorridoVacioNoSeDibuja() {
        #expect(PresentacionDeRedes.svg(.recorrido([]), en: .tonnetz, notacion: .espanolCompacto) == nil)
    }

    @Test func losTecladosMarcanLasNotasEnTodasLasOctavas() throws {
        let svg = try #require(
            PresentacionDeRedes.svg(
                .acorde(try Acorde(leyendo: "Do")), en: .wickiHayden,
                notacion: .espanolCompacto))
        #expect(svg.contains(">Do₄<"))
        #expect(svg.contains(">Do₅<"))
        #expect(PresentacionDeRedes.casillasDelTeclado.count == (12 * 7))
        #expect(PresentacionDeRedes.casillasDelTeclado.contains(.origen))
        // También los de hexágonos planos, con el Do4 dentro y ninguna casilla repetida.
        #expect(PresentacionDeRedes.casillasDelTecladoPlano.count == (12 * 7))
        #expect(PresentacionDeRedes.casillasDelTecladoPlano.contains(.origen))
        #expect(Set(PresentacionDeRedes.casillasDelTecladoPlano).count == (12 * 7))
        #expect(PresentacionDeRedes.casillasDelTeclado(.acordeonC) == PresentacionDeRedes.casillasDelTecladoPlano)
        #expect(PresentacionDeRedes.casillasDelTeclado(.janko) == PresentacionDeRedes.casillasDelTeclado)
        #expect(PresentacionDeRedes.casillasDelTeclado(.gerhard) == PresentacionDeRedes.casillasDelTecladoPlano)
        #expect(PresentacionDeRedes.casillasDelTeclado(.park) == PresentacionDeRedes.casillasDelTeclado)
        #expect(RedDeNotas.gerhard.teclado == .gerhard)
        #expect(RedDeNotas.park.teclado == .park)
    }

    @Test func lasRedesSonLosTecladosDelMotor() {
        // Cada teclado del catálogo del motor tiene su red, y cada red de teclado encuentra el suyo.
        let teclados = RedDeNotas.allCases.compactMap(\.teclado)
        #expect(([TecladoIsomorfico.tablaArmonica] + teclados) == TecladoIsomorfico.todos)
        for red in RedDeNotas.allCases where ![.tonnetz, .tablaArmonica, .uil].contains(red) {
            #expect(red.teclado?.nombre == red.rawValue)
            #expect(red.nombre(en: .inglesASCII) == red.teclado?.nombre(en: .inglesASCII))
        }
        #expect(RedDeNotas.acordeonC.nombre(en: .inglesASCII) == "C-system accordion")
    }

    @Test func lasNotasNoSeRepiten() throws {
        let recorrido = ContenidoDeRed.recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam")])
        #expect(recorrido.notas.count == 4)
    }

    @Test func elNombreDiceLaRedYElContenido() throws {
        let acorde = try Acorde(leyendo: "Dom7")
        #expect(
            PresentacionDeRedes.nombre(.acorde(acorde), en: .tablaArmonica, notacion: .espanolCompacto)
                == ("Tabla armónica · " + acorde.cifrado(en: .espanolCompacto)))
    }

    @Test func elNombreDelFicheroDeCadaContenido() throws {
        #expect(RedDeNotas.allCases.map(\.id) == RedDeNotas.allCases)
        let n = Notacion.espanolCompacto
        #expect(
            try PresentacionDeRedes.nombre(.escala(Escala(leyendo: "Re dórico")), en: .tonnetz, notacion: n)
                == "Tonnetz · Re dórico")
        #expect(
            PresentacionDeRedes.nombre(
                .recorrido([try Acorde(leyendo: "Do"), try Acorde(leyendo: "Lam")]),
                en: .tonnetz, notacion: n) == "Tonnetz · Do Lam")
        #expect(PresentacionDeRedes.nombre(.clases([0, 4, 7]), en: .tonnetz, notacion: n) == "Tonnetz · Do")
        // Sin acorde para las clases, sus notas; sin teclado UIL, solo «UIL».
        #expect(PresentacionDeRedes.nombre(.clases([]), en: .tonnetz, notacion: n) == "Tonnetz · ")
        #expect(
            PresentacionDeRedes.nombre(.clases([0, 4, 7]), en: .uil, notacion: n, uil: AjusteUIL(texto: ""))
                == "UIL  · Do")
        #expect(PresentacionDeRedes.svg(.recorrido([]), en: .tablaArmonica, notacion: n) == nil)
    }
}
