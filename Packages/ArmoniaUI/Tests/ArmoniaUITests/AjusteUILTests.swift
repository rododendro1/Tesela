import Armonia
import Foundation
import Testing

@testable import ArmoniaPresentacion
@testable import ArmoniaUI

// El teclado UIL de la app Tonnetz con cada teclado del artículo, y los avisos del coral en todos los idiomas.
// No usa SwiftUI: se ejecuta también en Linux.

@Suite struct AjusteUILTests {
    @Test func losTecladosDelArticuloSeDibujan() throws {
        #expect(AjusteUIL.conocidos.count == 8)
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        for conocido in AjusteUIL.conocidos {
            let ajuste = AjusteUIL(texto: conocido.texto)
            #expect(ajuste.teclado != nil, Comment(rawValue: conocido.nombre))
            #expect(ajuste.resultado != nil, Comment(rawValue: conocido.nombre))
            #expect(
                PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolUnicode, uil: ajuste) != nil,
                Comment(rawValue: conocido.nombre))
        }
    }

    @Test func doceGirosDanLaVueltaEntera() {
        for conocido in AjusteUIL.conocidos {
            let ajuste = AjusteUIL(texto: conocido.texto)
            #expect(
                AjusteUIL(texto: conocido.texto, giros: 12).resultado == ajuste.resultado,
                Comment(rawValue: conocido.nombre))
            #expect(
                AjusteUIL(texto: conocido.texto, giros: -1).resultado
                    == AjusteUIL(texto: conocido.texto, giros: 11).resultado, Comment(rawValue: conocido.nombre))
            #expect(
                AjusteUIL(texto: conocido.texto, giros: 1).resultado != ajuste.resultado,
                Comment(rawValue: conocido.nombre))
        }
    }

    @Test func elEspejoDaOtraColocacionDeLosMismosIntervalos() throws {
        // Cambia el giro o la M, pero no los intervalos (`L,G,D`). En los teclados simétricos, como el Jankó, el
        // espejo es un giro de 180°: `1,2,1;R90` pasa a `1,2,1;R270`.
        for conocido in AjusteUIL.conocidos {
            let antes = try #require(AjusteUIL(texto: conocido.texto).resultado)
            let despues = try #require(AjusteUIL(texto: conocido.texto, espejo: true).resultado)
            #expect(antes != despues, Comment(rawValue: conocido.nombre))
            #expect(
                antes.split(separator: ";").first == despues.split(separator: ";").first,
                Comment(rawValue: conocido.nombre))
        }
    }

    @Test func girarYReflejarMuevenLosIntervalos() throws {
        // Girado, cada intervalo queda 30° más allá por giro; reflejado, al otro lado del eje vertical.
        let recto = try #require(AjusteUIL(texto: "2,7,5;R30M").teclado)
        let girado = try #require(AjusteUIL(texto: "2,7,5;R30M", giros: 1).teclado)
        let reflejado = try #require(AjusteUIL(texto: "2,7,5;R30M", espejo: true).teclado)
        #expect(girado.orientacion != recto.orientacion)
        #expect(reflejado.orientacion == recto.orientacion)
        var vecinas = 0
        for rumbo in stride(from: 0, to: 360, by: 30) {
            guard let semitonos = recto.semitonos(rumbo: rumbo) else { continue }
            vecinas += 1
            #expect(girado.semitonos(rumbo: rumbo + 30) == semitonos, "rumbo \(rumbo)")
            #expect(reflejado.semitonos(rumbo: -rumbo) == semitonos, "rumbo \(rumbo)")
        }
        #expect(vecinas == 6)
    }
}

@Suite struct AvisosDelCoralTests {
    @Test func losAvisosTienenTextoEnCadaNotacion() {
        let avisos: [CoralPresentado.Aviso] = [
            .sinArmonizacion, .faltanOctavas, .sinCoralParaLaMelodia, .sinRealizacion,
            .sinFaltasDeConduccion,
        ]
        for notacion in Notacion.allCases {
            for aviso in avisos {
                #expect(!(aviso.texto(en: notacion).isEmpty), "\(aviso) en \(notacion)")
            }
        }
        // Y cada uno dice algo distinto.
        #expect(Set(avisos.map { $0.texto(en: .espanolUnicode) }).count == avisos.count)
        #expect(
            CoralPresentado.Aviso.sinRealizacion.texto(en: .espanolUnicode)
                != CoralPresentado.Aviso.sinRealizacion.texto(en: .inglesASCII))
    }
}
