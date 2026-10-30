import XCTest
import Armonia
@testable import ArmoniaUI
@testable import ArmoniaPresentacion

// El teclado UIL de la app Tonnetz con cada teclado del artículo, y los avisos del coral en todos los idiomas.
// No usa SwiftUI: se ejecuta también en Linux.

final class AjusteUILTests: XCTestCase {
    func testLosTecladosDelArticuloSeDibujan() throws {
        XCTAssertEqual(AjusteUIL.conocidos.count, 8)
        let doMayor = ContenidoDeRed.acorde(try Acorde(leyendo: "Do"))
        for conocido in AjusteUIL.conocidos {
            let ajuste = AjusteUIL(texto: conocido.texto)
            XCTAssertNotNil(ajuste.teclado, conocido.nombre)
            XCTAssertNotNil(ajuste.resultado, conocido.nombre)
            XCTAssertNotNil(PresentacionDeRedes.svg(doMayor, en: .uil, notacion: .espanolUnicode, uil: ajuste), conocido.nombre)
        }
    }

    func testDoceGirosDanLaVueltaEntera() {
        for conocido in AjusteUIL.conocidos {
            let ajuste = AjusteUIL(texto: conocido.texto)
            XCTAssertEqual(AjusteUIL(texto: conocido.texto, giros: 12).resultado, ajuste.resultado, conocido.nombre)
            XCTAssertEqual(AjusteUIL(texto: conocido.texto, giros: -1).resultado,
                           AjusteUIL(texto: conocido.texto, giros: 11).resultado, conocido.nombre)
            XCTAssertNotEqual(AjusteUIL(texto: conocido.texto, giros: 1).resultado, ajuste.resultado, conocido.nombre)
        }
    }

    func testElEspejoPoneOQuitaLaM() throws {
        for conocido in AjusteUIL.conocidos {
            let antes = try XCTUnwrap(AjusteUIL(texto: conocido.texto).resultado)
            let despues = try XCTUnwrap(AjusteUIL(texto: conocido.texto, espejo: true).resultado)
            XCTAssertNotEqual(antes.hasSuffix("M"), despues.hasSuffix("M"), "\(conocido.nombre): \(antes) → \(despues)")
        }
    }

    func testGirarYReflejarMuevenLosIntervalos() throws {
        // Girado, cada intervalo queda 30° más allá por giro; reflejado, al otro lado del eje vertical.
        let recto = try XCTUnwrap(AjusteUIL(texto: "2,7,5;R30M").teclado)
        let girado = try XCTUnwrap(AjusteUIL(texto: "2,7,5;R30M", giros: 1).teclado)
        let reflejado = try XCTUnwrap(AjusteUIL(texto: "2,7,5;R30M", espejo: true).teclado)
        XCTAssertNotEqual(girado.orientacion, recto.orientacion)
        XCTAssertEqual(reflejado.orientacion, recto.orientacion)
        var vecinas = 0
        for rumbo in stride(from: 0, to: 360, by: 30) {
            guard let semitonos = recto.semitonos(rumbo: rumbo) else { continue }
            vecinas += 1
            XCTAssertEqual(girado.semitonos(rumbo: rumbo + 30), semitonos, "rumbo \(rumbo)")
            XCTAssertEqual(reflejado.semitonos(rumbo: -rumbo), semitonos, "rumbo \(rumbo)")
        }
        XCTAssertEqual(vecinas, 6)
    }
}

final class AvisosDelCoralTests: XCTestCase {
    func testLosAvisosTienenTextoEnCadaNotacion() {
        let avisos: [CoralPresentado.Aviso] = [.sinArmonizacion, .faltanOctavas, .sinCoralParaLaMelodia, .sinRealizacion,
                                              .sinFaltasDeConduccion]
        for notacion in Notacion.allCases {
            for aviso in avisos {
                XCTAssertFalse(aviso.texto(en: notacion).isEmpty, "\(aviso) en \(notacion)")
            }
        }
        // Y cada uno dice algo distinto.
        XCTAssertEqual(Set(avisos.map { $0.texto(en: .espanolUnicode) }).count, avisos.count)
        XCTAssertNotEqual(CoralPresentado.Aviso.sinRealizacion.texto(en: .espanolUnicode),
                          CoralPresentado.Aviso.sinRealizacion.texto(en: .inglesASCII))
    }
}
