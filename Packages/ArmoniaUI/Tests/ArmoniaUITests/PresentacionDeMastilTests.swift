import Armonia
import XCTest

@testable import ArmoniaUI

final class PresentacionDeMastilTests: XCTestCase {
    private let guitarra = Mastil(.guitarra)

    private func digitacion(_ trastes: [Int?]) -> Digitacion {
        Digitacion(mastil: guitarra, trastes: trastes)
    }

    // MARK: Rango

    func testCercaDeLaCejillaSeVeDesdeElCero() {
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([nil, 3, 2, 0, 1, 0])), 0...5) // Do
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([1, 3, 3, 2, 1, 1])), 0...5) // Fa con cejilla
    }

    func testSinTrastesPisadosSeVeDesdeElCero() {
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([nil, nil, 0, 0, nil, nil])), 0...5)
    }

    func testLejosDeLaCejillaHayUnaVentanaConMargen() {
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([nil, 7, 9, 9, 8, 7])), 6...10)
    }

    func testLaVentanaTieneAlMenosCuatroTrastes() {
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([nil, 0, 7, 7, 7, 7])), 6...9)
        XCTAssertEqual(PresentacionDeMastil.rango(de: digitacion([nil, 5, 5, 5, 5, nil])), 4...7)
    }

    func testTodaPosicionPisadaCabeEnElRango() throws {
        for cifrado in ["Do", "Sol7/Si", "Rem7", "Fa#m7b5", "Mib", "Sib"] {
            let acorde = try Acorde(leyendo: cifrado)
            for forma in guitarra.digitaciones(de: acorde, maximoTraste: 15) {
                let rango = PresentacionDeMastil.rango(de: forma)
                for posicion in forma.posiciones where posicion.traste > 0 {
                    XCTAssertTrue(rango.contains(posicion.traste), "\(cifrado) \(forma.tablatura): \(rango)")
                }
            }
        }
    }

    // MARK: Cuerdas apagadas

    func testLasCuerdasApagadas() {
        XCTAssertEqual(PresentacionDeMastil.apagadas(de: digitacion([nil, 3, 2, 0, 1, 0])), [0])
        XCTAssertEqual(PresentacionDeMastil.apagadas(de: digitacion([nil, nil, 0, 0, nil, 1])), [0, 1, 4])
        XCTAssertEqual(PresentacionDeMastil.apagadas(de: digitacion([3, 2, 0, 0, 0, 3])), [])
    }

    // MARK: Ortografía

    func testLaOrtografiaEsLaDeLaEscala() {
        // Con `Altura(midi:)` el Si♭ saldría como La♯.
        let ortografia = PresentacionDeMastil.ortografia(de: Escala(.fa, .mayor).notas)
        XCTAssertEqual(ortografia[10]?.nombre(en: .espanolUnicode), "Si♭")
        XCTAssertEqual(ortografia[5]?.nombre(en: .espanolUnicode), "Fa")
        XCTAssertNil(ortografia[1]) // Do♯ no está en Fa mayor
    }

    func testLaOrtografiaDelAcordeConBemoles() throws {
        let ortografia = PresentacionDeMastil.ortografia(de: try Acorde(leyendo: "Mib").notas)
        XCTAssertEqual(ortografia[3]?.nombre(en: .espanolUnicode), "Mi♭")
        XCTAssertEqual(ortografia[10]?.nombre(en: .espanolUnicode), "Si♭")
    }

    func testSiDosNotasComparteClaveGanaLaPrimera() {
        let notas = [Nota(pasosDeQuinta: 6), Nota(pasosDeQuinta: -6)] // Fa♯ y Sol♭
        XCTAssertEqual(PresentacionDeMastil.ortografia(de: notas)[6]?.nombre(en: .espanolUnicode), "Fa♯")
    }

    func testSinNotasNoHayOrtografia() {
        XCTAssertTrue(PresentacionDeMastil.ortografia(de: []).isEmpty)
    }

    // MARK: Descripción

    func testLaDescripcionVaDeGraveAAgudo() {
        let marcas = [PosicionEnElMastil(cuerda: 1, traste: 3), PosicionEnElMastil(cuerda: 0, traste: 0)]
        XCTAssertEqual(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: []),
            "cuerda 1, traste 0; cuerda 2, traste 3")
        XCTAssertEqual(
            PresentacionDeMastil.descripcion(marcas: marcas, apagadas: [5]),
            "cuerda 1, traste 0; cuerda 2, traste 3; cuerdas apagadas: 6")
    }

    func testLaDescripcionSeAcortaSiHayMuchasMarcas() {
        let muchas = (0...12).map { PosicionEnElMastil(cuerda: 0, traste: $0) }
        XCTAssertEqual(PresentacionDeMastil.descripcion(marcas: muchas, apagadas: []), "13 marcas")
    }

    func testSinMarcas() {
        XCTAssertEqual(PresentacionDeMastil.descripcion(marcas: [], apagadas: []), "Sin marcas")
    }

    // MARK: Tocar el mástil

    func testElToqueVaAlTrasteYALaCuerdaMasCercana() {
        // Trece columnas de 20 puntos (0…12) y seis cuerdas separadas 20: la grave a 108 del borde de arriba.
        func posicion(_ x: Double, _ y: Double) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: x, y: y, ancho: 276, alto: 130, cuerdas: 6, rango: 0...12, conCanal: false)
        }
        XCTAssertEqual(posicion(78, 88), PosicionEnElMastil(cuerda: 1, traste: 3))
        XCTAssertEqual(posicion(10, 100), PosicionEnElMastil(cuerda: 0, traste: 0))
        XCTAssertEqual(posicion(266, 8), PosicionEnElMastil(cuerda: 5, traste: 12))
        XCTAssertNil(posicion(5, 88)) // en el margen
        XCTAssertNil(posicion(78, 125)) // debajo de la cuerda grave, donde van los números de traste
    }

    func testElCanalDeLasCuerdasAlAireNoSeToca() {
        // Del 5 al 8 con canal: cinco columnas de 52 puntos, la primera para el canal.
        func posicion(_ x: Double) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: x, y: 108, ancho: 276, alto: 130, cuerdas: 6, rango: 5...8, conCanal: true)
        }
        XCTAssertNil(posicion(40))
        XCTAssertEqual(posicion(113), PosicionEnElMastil(cuerda: 0, traste: 6))
    }

    func testUnaSolaCuerdaONinguna() {
        func posicion(_ y: Double, cuerdas: Int) -> PosicionEnElMastil? {
            PresentacionDeMastil.posicion(
                enX: 100, y: y, ancho: 276, alto: 130, cuerdas: cuerdas, rango: 0...12, conCanal: false)
        }
        XCTAssertNil(posicion(100, cuerdas: 0))
        // Con una cuerda, abajo del todo, y hasta 12 puntos por encima o por debajo.
        XCTAssertEqual(posicion(108, cuerdas: 1)?.cuerda, 0)
        XCTAssertEqual(posicion(97, cuerdas: 1)?.cuerda, 0)
        XCTAssertNil(posicion(60, cuerdas: 1))
    }
}
