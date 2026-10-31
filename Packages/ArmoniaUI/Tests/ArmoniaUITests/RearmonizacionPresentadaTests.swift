import Armonia
import XCTest

@testable import ArmoniaPresentacion

/// «Rearmonizar» en la app y en la línea de comandos.
final class RearmonizacionPresentadaTests: XCTestCase {
    func testLasPropuestasDeUnaProgresion() throws {
        let acordes = [Acorde("Do"), Acorde("Lam"), Acorde("Rem7"), Acorde("Sol7"), Acorde("Do")]
        let resultado = try XCTUnwrap(PresentacionDeRearmonizacion.proponer(acordes, notacion: .espanolUnicode))
        let (tonalidad, propuestas) = (resultado.tonalidad, resultado.propuestas)
        XCTAssertEqual(tonalidad, Tonalidad(.do))
        let tritonal = try XCTUnwrap(propuestas.first { $0.rearmonizacion.recurso == .sustitutoTritonal })
        XCTAssertEqual(tritonal.descripcion, "Sol7 → Re♭7 (sustituto tritonal)")
        XCTAssertEqual(tritonal.texto, "Do Lam Rem7 Re♭7 Do")
        // El pasaje: Rem7, Re♭7 y Do.
        XCTAssertEqual(tritonal.sonido.inicios.count, 3)
        XCTAssertEqual(tritonal.sonido.tonica, .do)
        // La dominante secundaria del primer Lam: Do, Mi7, Lam y Rem7.
        let secundaria = try XCTUnwrap(
            propuestas.first { $0.rearmonizacion.recurso == .dominanteSecundaria && $0.rearmonizacion.posicion == 1 })
        XCTAssertEqual(secundaria.texto, "Do Mi7 Lam Rem7 Sol7 Do")
        XCTAssertEqual(secundaria.sonido.inicios.count, 4)
        XCTAssertNil(PresentacionDeRearmonizacion.proponer([], notacion: .espanolUnicode))
    }

    func testDesdeElAnalisisYEnIngles() throws {
        let analisis = try PresentacionDeAnalisis.analizar("C Am F G7 C", notacion: .inglesASCII)
        let propuestas = analisis.rearmonizaciones(notacion: .inglesASCII)
        XCTAssertTrue(propuestas.contains { $0.descripcion == "G7 → Db7 (tritone substitution)" })
        XCTAssertTrue(propuestas.contains { $0.texto == "C Am F Db7 C" })
    }
}
