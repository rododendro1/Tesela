import Armonia
import Foundation
import XCTest

@testable import ArmoniaPresentacion

// «Abrir» en la vista de análisis: de un fichero MIDI o MusicXML a una progresión que se analiza como si se
// hubiera escrito.
final class ImportacionDeProgresionTests: XCTestCase {
    func testUnFicheroDaSuProgresion() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        XCTAssertEqual(try ImportacionDeProgresion.progresion(de: analisis.midi()), "Do Lam Re7 Sol7 Do")
        XCTAssertEqual(try ImportacionDeProgresion.progresion(de: Data(analisis.musicXML().utf8)), "Do Lam Re7 Sol7 Do")
    }

    func testLaProgresionSeAnalizaComoLaEscrita() throws {
        let texto = "Do Fa Sol7 Do Lam Re7 Sol"
        let progresion = try ImportacionDeProgresion.progresion(de: AnalisisArmonico.analizar(leyendo: texto).midi())
        XCTAssertEqual(progresion, texto)
        XCTAssertEqual(
            try PresentacionDeAnalisis.analizar(progresion, notacion: .espanolUnicode),
            try PresentacionDeAnalisis.analizar(texto, notacion: .espanolUnicode))
    }

    func testUnaMelodiaSolaNoTieneAcordes() throws {
        let melodia = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi()
        XCTAssertThrowsError(try ImportacionDeProgresion.progresion(de: melodia)) {
            XCTAssertEqual($0 as? ErrorDeImportacion, .sinAcordes)
        }
        XCTAssertThrowsError(try ImportacionDeProgresion.progresion(de: Data("hola".utf8))) {
            XCTAssertEqual($0 as? ErrorDeImportacion, .formatoDesconocido)
        }
    }

    func testLosErroresSeExplicanEnLaNotacion() {
        XCTAssertEqual(ErrorDeImportacion.sinAcordes.descripcion(en: .inglesASCII), "No chords sound in the file.")
    }
}
