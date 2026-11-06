import Armonia
import Foundation
import Hexagonos
import Testing

@testable import TeselaPresentacion

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

    @Test func losTecladosDeCuadriculaSeDibujanConCuadrados() throws {
        let svg = try #require(
            PresentacionDeRedes.svg(
                .acorde(try Acorde(leyendo: "Do")), en: .cuadriculaEnCuartas, notacion: .espanolCompacto))
        #expect(svg.contains("<rect"))
        #expect(!svg.contains("<polygon"))
        #expect(svg.contains(">Do₄<"))
        #expect(svg.contains(">Do₅<"))
        // Las 84 casillas y, encima, el borde de los siete Do.
        let cuadrados = svg.components(separatedBy: "<rect").count - 1
        #expect(cuadrados == 91)
        #expect(PresentacionDeRedes.casillasDelTecladoCuadrado.count == 12 * 7)
        #expect(PresentacionDeRedes.casillasDelTecladoCuadrado.contains(.origen))
    }

    @Test func elAjusteDeLaCuadricula() throws {
        var ajuste = AjusteCuadrado()
        #expect(ajuste.teclado(de: .cuadriculaPersonalizada)?.ejes == "1,5")
        #expect(ajuste.teclado(de: .tonnetz) == nil)
        #expect(ajuste.teclado(de: .cuadriculaEnQuintas)?.ejes == "1,7")
        ajuste.texto = "2,7"
        ajuste.giros = 1
        #expect(ajuste.resultado == "7,-2")
        ajuste.espejo = true
        #expect(ajuste.resultado == "-7,-2")
        ajuste.texto = "no"
        #expect(ajuste.resultado == nil)
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let personalizada = RedDeNotas.cuadriculaPersonalizada
        let sinEjes = PresentacionDeRedes.svg(doMayor, en: personalizada, notacion: .espanolCompacto, cuadrado: ajuste)
        #expect(sinEjes == nil)
        // La rejilla trae su nota de origen, y al cambiarla se olvida la elegida.
        ajuste = AjusteCuadrado(origen: 48)
        #expect(ajuste.midiDelOrigen == 48)
        ajuste.rejilla = .launchpad
        #expect(ajuste.origen == nil)
        #expect(ajuste.midiDelOrigen == 36)
        #expect(ajuste.teclado(de: .cuadriculaEnCuartas)?.midi(en: .origen) == 36)
        // En tono, solo con una escala.
        ajuste.enTono = true
        #expect(ajuste.teclado(de: .cuadriculaEnCuartas)?.esCromatico == true)
        let enTono = try #require(ajuste.teclado(de: .cuadriculaEnCuartas, escala: Escala(.re, .dorico)))
        #expect(enTono.semitonosEnV == 3)
        #expect(enTono.midi(en: .origen) == 38) // Re2
    }

    @Test func laCuadriculaEnUnControladorEnTonoYConContorno() throws {
        let escala = ContenidoDeRed.escala(try Escala(leyendo: "Re dórico"))
        let ajuste = AjusteCuadrado(rejilla: .launchpad, enTono: true)
        let svg = try #require(
            PresentacionDeRedes.svg(escala, en: .cuadriculaEnCuartas, notacion: .espanolCompacto, cuadrado: ajuste))
        // Las 64 casillas y, encima, el borde de las 10 que son Re.
        let cuadrados = svg.components(separatedBy: "<rect").count - 1
        #expect(cuadrados == 74)
        #expect(svg.contains(">Re₂<"))
        #expect(!svg.contains(">Do♯"))
        #expect(svg.contains(#"class="primera""#))
        #expect(svg.contains(#"class="contorno""#))
        let lado = PresentacionDeRedes.ladoDelTecladoCuadrado
        #expect(PresentacionDeRedes.midi(en: .cero, de: escala, enLaRed: .cuadriculaEnCuartas, cuadrado: ajuste) == 38)
        #expect(
            PresentacionDeRedes.midi(
                en: Punto(x: lado, y: 0), de: escala, enLaRed: .cuadriculaEnCuartas, cuadrado: ajuste) == 40)
        // Fuera de los 8 × 8, nada.
        #expect(
            PresentacionDeRedes.midi(
                en: Punto(x: -lado, y: 0), de: escala, enLaRed: .cuadriculaEnCuartas, cuadrado: ajuste) == nil)
        #expect(
            PresentacionDeRedes.nombre(escala, en: .cuadriculaPersonalizada, notacion: .espanolCompacto)
                == "H,V 1,5 · Re dórico")
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
        let hexagonales = RedDeNotas.allCases.filter { !$0.esCuadricula }
        for red in hexagonales where ![.tonnetz, .tablaArmonica, .uil].contains(red) {
            #expect(red.teclado?.nombre == red.rawValue)
            #expect(red.nombre(en: .inglesASCII) == red.teclado?.nombre(en: .inglesASCII))
        }
        #expect(RedDeNotas.acordeonC.nombre(en: .inglesASCII) == "C-system accordion")
        // Y lo mismo con los de cuadrícula, que no son hexagonales.
        #expect(RedDeNotas.allCases.compactMap(\.tecladoCuadrado) == TecladoCuadrado.todos)
        for red in RedDeNotas.allCases where red.tecladoCuadrado != nil {
            #expect(red.teclado == nil)
            #expect(red.tecladoCuadrado?.nombre == red.rawValue)
            #expect(red.nombre(en: .inglesASCII) == red.tecladoCuadrado?.nombre(en: .inglesASCII))
        }
        #expect(RedDeNotas.cuadriculaEnCuartas.nombre(en: .inglesASCII) == "Grid in fourths")
        #expect(PresentacionDeRedes.teclado(de: .cuadriculaEnCuartas) == nil)
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

    @Test func losContenidosDeLaLineaDeComandos() throws {
        let n = Notacion.espanolCompacto
        let doMayor = try Acorde(leyendo: "Do")
        let mibMenor = try Acorde(leyendo: "Mibm")
        // Lo mismo que los inicializadores de cada red.
        let notas = ContenidoDeRed.notas([.do, .mi, .sol, .do])
        #expect(notas.notas == [.do, .mi, .sol])
        #expect(notas.red(Tonnetz.self) == Tonnetz([.do, .mi, .sol, .do]))
        let camino = ContenidoDeRed.camino(doMayor, mibMenor)
        #expect(camino.red(TablaArmonica.self) == TablaArmonica(caminoDesde: doMayor, hasta: mibMenor))
        let delCamino = try #require(Tonnetz(caminoDesde: doMayor, hasta: mibMenor)).puntos.map(\.nota)
        #expect(Set(camino.notas) == Set(delCamino))
        #expect(camino.notas.first == delCamino.first)
        let ciclo = ContenidoDeRed.ciclo(.hexatonico, doMayor)
        #expect(ciclo.red(Tonnetz.self) == Tonnetz(ciclo: .hexatonico, desde: doMayor))
        #expect(ContenidoDeRed.clases([7, 0, 4]).red(Tonnetz.self) == Tonnetz(ConjuntoDeClasesDeAltura([0, 4, 7])))
        // Sin tríadas, ni red ni notas.
        let septima = try Acorde(leyendo: "Do7")
        #expect(ContenidoDeRed.camino(septima, mibMenor).red(Tonnetz.self) == nil)
        #expect(ContenidoDeRed.ciclo(.lr, septima).notas.isEmpty)
        #expect(PresentacionDeRedes.svg(.ciclo(.lr, septima), en: .tonnetz, notacion: n) == nil)
        // Se dibujan en todas las redes, y con flechas en el Tonnetz y la tabla.
        for red in RedDeNotas.allCases {
            for contenido in [notas, camino, ciclo] {
                #expect(PresentacionDeRedes.svg(contenido, en: red, notacion: n) != nil, "\(red) \(contenido)")
            }
        }
        #expect(PresentacionDeRedes.paso(camino, en: .tonnetz) == 88)
        #expect(PresentacionDeRedes.paso(notas, en: .tablaArmonica) == 56)
        #expect(
            PresentacionDeRedes.svg(camino, en: .tonnetz, notacion: n)
                == Tonnetz(caminoDesde: doMayor, hasta: mibMenor)?.svg(opciones: .init(notacion: n)))
        #expect(PresentacionDeRedes.nombre(notas, en: .tonnetz, notacion: n) == "Tonnetz · Do Mi Sol Do")
        #expect(
            PresentacionDeRedes.nombre(camino, en: .tonnetz, notacion: n)
                == "Tonnetz · Do → " + mibMenor.cifrado(en: n))
        #expect(
            PresentacionDeRedes.nombre(ciclo, en: .tablaArmonica, notacion: n)
                == RedDeNotas.tablaArmonica.nombre(en: n) + " · ciclo hexatónico · Do")
        // Solo una escala se toca en tono.
        #expect(try ContenidoDeRed.escala(Escala(leyendo: "Re dórico")).escala != nil)
        #expect(camino.escala == nil)
    }

    @Test func enUnTecladoDeCuadriculaYaColocado() throws {
        let n = Notacion.espanolCompacto
        let contenido = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        let ajuste = AjusteCuadrado()
        let teclado = try #require(ajuste.teclado(de: .cuadriculaEnCuartas))
        #expect(
            PresentacionDeRedes.svg(contenido, en: teclado, casillas: ajuste.rejilla.casillas, notacion: n)
                == PresentacionDeRedes.svg(contenido, en: .cuadriculaEnCuartas, notacion: n))
    }
}
