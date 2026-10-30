import XCTest
import Armonia
@testable import ArmoniaPresentacion

final class PresentacionDePentagramaTests: XCTestCase {
    func testLaEscalaDaSuDibujoYSuFichero() {
        let pentagrama = PresentacionDePentagrama(Escala("Re dórico"))
        XCTAssertTrue(pentagrama.svg.hasPrefix("<svg"))
        XCTAssertEqual(pentagrama.fichero.formato, .svg)
        XCTAssertEqual(pentagrama.fichero.nombreDeFichero, "Pentagrama Re dórico.svg")
        XCTAssertEqual(String(decoding: pentagrama.fichero.datos, as: UTF8.self), pentagrama.svg)
        XCTAssertTrue(pentagrama.descripcion.hasPrefix("Re dórico: Re4, Mi4"))
    }

    func testElAcordeLlevaElCifradoYLasNotasSolasSiSePide() {
        let pentagrama = PresentacionDePentagrama(Acorde("Sol7"))
        XCTAssertTrue(pentagrama.svg.contains(">Sol7</text>"))
        XCTAssertEqual(pentagrama.descripcion, "Sol7: Sol, Si, Re, Fa")
        XCTAssertFalse(pentagrama.svg.contains("Sol4 Si4"))
        XCTAssertTrue(PresentacionDePentagrama(Acorde("Sol7"), nombresDeLasNotas: true).svg.contains("Sol4 Si4"))
    }

    func testLaNotacionSeSigue() {
        let pentagrama = PresentacionDePentagrama(Escala("Do mayor"), notacion: .inglesASCII)
        XCTAssertTrue(pentagrama.svg.contains("<title>C4</title>"))
    }

    func testLaRelacionDeAspecto() {
        XCTAssertEqual(PresentacionDePentagrama.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10">"#), 2)
        XCTAssertEqual(PresentacionDePentagrama.relacionDeAspecto(deSVG: "<svg>"), 4)
        XCTAssertEqual(PresentacionDePentagrama.relacionDeAspecto(deSVG: #"<svg viewBox="0 0 0 0">"#), 4)
        let medida = PresentacionDePentagrama(Escala("Do mayor")).relacionDeAspecto
        XCTAssertGreaterThan(medida, 1)
    }
}
