import Armonia
import XCTest

@testable import ArmoniaPresentacion

final class PresentacionDePentagramaTests: XCTestCase {
    func testLaEscalaDaSuDibujoYSuFichero() {
        let pentagrama = PentagramaPresentado(Escala("Re dórico"))
        XCTAssertTrue(pentagrama.svg.hasPrefix("<svg"))
        XCTAssertEqual(pentagrama.fichero.formato, .svg)
        XCTAssertEqual(pentagrama.fichero.nombreDeFichero, "Pentagrama Re dórico.svg")
        XCTAssertEqual(String(decoding: pentagrama.fichero.datos, as: UTF8.self), pentagrama.svg)
        XCTAssertTrue(pentagrama.descripcion.hasPrefix("Re dórico: Re4, Mi4"))
    }

    func testElAcordeLlevaElCifradoYLasNotasSolasSiSePide() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"))
        XCTAssertTrue(pentagrama.svg.contains(">Sol7</text>"))
        XCTAssertEqual(pentagrama.descripcion, "Sol7: Sol, Si, Re, Fa")
        XCTAssertFalse(pentagrama.svg.contains("Sol4 Si4"))
        XCTAssertTrue(PentagramaPresentado(Acorde("Sol7"), nombresDeLasNotas: true).svg.contains("Sol4 Si4"))
    }

    func testLaNotacionSeSigue() {
        let pentagrama = PentagramaPresentado(Escala("Do mayor"), notacion: .inglesASCII)
        XCTAssertTrue(pentagrama.svg.contains("<title>C4</title>"))
    }

    func testLaRelacionDeAspecto() {
        XCTAssertEqual(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10">"#), 2)
        XCTAssertEqual(PentagramaPresentado.relacionDeAspecto(deSVG: "<svg>"), 4)
        XCTAssertEqual(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 0 0 0">"#), 4)
        let medida = PentagramaPresentado(Escala("Do mayor")).relacionDeAspecto
        XCTAssertGreaterThan(medida, 1)
    }

    func testElArpegioVaNotaANota() {
        let pentagrama = PentagramaPresentado(Arpegio(Acorde("Do"), patron: .alberti))
        XCTAssertTrue(pentagrama.descripcion.hasSuffix(": Do4, Sol4, Mi4, Sol4"), pentagrama.descripcion)
        XCTAssertTrue(pentagrama.fichero.nombreDeFichero.hasPrefix("Pentagrama Arpegio de Do"))
        XCTAssertTrue(pentagrama.svg.hasPrefix("<svg"))
    }

    func testLaNotaQueSuenaSeResalta() {
        let arpegio = Arpegio(Acorde("Do"))
        let normal = PentagramaPresentado(arpegio)
        XCTAssertFalse(normal.svg.contains("#E8590C"))
        let resaltada = PentagramaPresentado(arpegio, resaltada: 2)
        // Solo la tercera nota (Sol4) cambia de color.
        XCTAssertEqual(resaltada.svg.components(separatedBy: "<g fill=\"#E8590C\"><title>").count - 1, 1)
        XCTAssertTrue(resaltada.svg.contains("<g fill=\"#E8590C\"><title>Sol4</title>"))
        XCTAssertEqual(PentagramaPresentado(Escala("Do mayor"), resaltada: 0).svg.contains("<title>Do4"), true)
    }

    func testUnViewBoxSinCerrar() {
        XCTAssertEqual(PentagramaPresentado.relacionDeAspecto(deSVG: #"<svg viewBox="0 -3 20 10"#), 4)
    }
}

final class PresentacionDePentagramaMasTests: XCTestCase {
    func testElAcordeConBajoEmpiezaPorElBajoYElFicheroNoLlevaBarras() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7/Si"))
        XCTAssertEqual(pentagrama.descripcion, "Sol7/Si: Si, Re, Fa, Sol")
        XCTAssertEqual(pentagrama.fichero.nombreDeFichero, "Pentagrama Sol7-Si.svg")
    }

    func testLaOctavaCambiaLasAlturas() {
        XCTAssertTrue(
            PentagramaPresentado(Escala("Re dórico"), octava: 3).descripcion.hasPrefix("Re dórico: Re3, Mi3"))
        XCTAssertNotEqual(
            PentagramaPresentado(Escala("Re dórico"), octava: 3).svg,
            PentagramaPresentado(Escala("Re dórico")).svg)
    }

    func testElSentidoCambiaElDibujo() {
        let subida = PentagramaPresentado(Escala("Do mayor"), sentido: .ascendente)
        let bajada = PentagramaPresentado(Escala("Do mayor"), sentido: .descendente)
        XCTAssertNotEqual(subida.svg, bajada.svg)
        // La descripción dice las notas de la escala, no el orden del dibujo.
        XCTAssertEqual(subida.descripcion, bajada.descripcion)
    }

    func testLaNotacionSeSigueTambienEnElAcorde() {
        let pentagrama = PentagramaPresentado(Acorde("Sol7"), notacion: .inglesASCII)
        XCTAssertEqual(pentagrama.descripcion, "G7: G, B, D, F")
        XCTAssertTrue(pentagrama.svg.contains(">G7</text>"))
        XCTAssertEqual(pentagrama.fichero.nombreDeFichero, "Pentagrama G7.svg")
    }

    func testLaProporcionEsLaDeSuDibujo() {
        for pentagrama in [
            PentagramaPresentado(Escala("La menor melódica")), PentagramaPresentado(Acorde("Do")),
        ] {
            XCTAssertEqual(
                pentagrama.relacionDeAspecto, PentagramaPresentado.relacionDeAspecto(deSVG: pentagrama.svg))
            XCTAssertNotEqual(pentagrama.relacionDeAspecto, 4, "el SVG del motor lleva viewBox")
        }
    }
}
