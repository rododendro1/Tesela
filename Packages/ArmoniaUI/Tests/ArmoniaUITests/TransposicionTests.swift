import Armonia
import XCTest

@testable import ArmoniaPresentacion

/// Transportar lo escrito en los campos: progresiones, melodías y corales.
final class TransposicionTests: XCTestCase {
    func testUnaProgresion() throws {
        let re = try PresentacionDeTransposicion.transponer(
            "Do Lam Re7 Sol7/Si", .segundaMayor, notacion: .espanolUnicode)
        XCTAssertEqual(re, "Re Sim Mi7 La7/Do♯")
        let abajo = try PresentacionDeTransposicion.transponer("Do  Fa | Sol7", -.terceraMenor, notacion: .inglesASCII)
        XCTAssertEqual(abajo, "A  D | E7")
        XCTAssertThrowsError(
            try PresentacionDeTransposicion.transponer("Do zzz", .segundaMayor, notacion: .espanolUnicode))
    }

    func testDeUnaTonalidadAOtra() throws {
        // De Do a La por el camino más corto: una tercera menor abajo.
        let texto = try PresentacionDeTransposicion.transponer(
            "Do Sol7", de: Tonalidad(.do), a: Tonalidad(.la), notacion: .espanolUnicode)
        XCTAssertEqual(texto, "La Mi7")
        let destinos = PresentacionDeTransposicion.destinos(desde: Tonalidad(.do))
        XCTAssertEqual(destinos.count, 11)
        XCTAssertFalse(destinos.contains(Tonalidad(.do)))
        let enMenor = PresentacionDeTransposicion.destinos(desde: Tonalidad(.la, .menor))
        XCTAssertTrue(enMenor.allSatisfy { $0.modo == .menor })
    }

    func testNotasYCorales() throws {
        let coral = try PresentacionDeTransposicion.transponer(
            "Do3 Mi4 Sol4 Do5, Sol2 Re4 Sol4 Si4", .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        XCTAssertEqual(coral, "Re3 Fa♯4 La4 Re5, La2 Mi4 La4 Do♯5")
        // Sol7 es aquí la nota Sol de la octava 7, no el acorde.
        func comoNotas(_ texto: String) throws -> String {
            try PresentacionDeTransposicion.transponer(
                texto, .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        }
        XCTAssertEqual(try comoNotas("Sol7"), "La7")
        XCTAssertEqual(try comoNotas("Si7"), "Do♯8")
        let melodia = try PresentacionDeTransposicion.transponer(
            "Mi4:4 Re4:8 -:8 Mi Fa", .cuartaJusta, contenido: .notas, notacion: .espanolUnicode)
        XCTAssertTrue(melodia.hasPrefix("La4:"), melodia)
        XCTAssertTrue(melodia.hasSuffix(" La Si♭"), melodia)
        XCTAssertTrue(melodia.contains(" -:"), melodia)
    }

    func testUnaProgresionAbierta() {
        let abierta = ProgresionImportada(
            acordes: [Acorde("Do"), Acorde("Sol")], ritmo: RitmoArmonico(duraciones: [.blanca, .blanca]),
            titulo: "Pieza")
        let enRe = PresentacionDeTransposicion.transponer(abierta, .segundaMayor)
        XCTAssertEqual(enRe.acordes, [Acorde("Re"), Acorde("La")])
        XCTAssertEqual(enRe.ritmo, abierta.ritmo)
        XCTAssertEqual(enRe.titulo, "Pieza")
    }

    func testLaTonalidadDeLoEscrito() throws {
        XCTAssertEqual(PresentacionDeTransposicion.tonalidad(de: "Do Fa | Sol7 Do"), Tonalidad(.do))
        let enRe = PresentacionDeTransposicion.tonalidad(de: "Re4:4 Mi4 Fa# Sol La4+Si4:2 Do#5", contenido: .notas)
        let tonica = try XCTUnwrap(enRe).tonica
        XCTAssertTrue([Nota.re, Nota.si].contains(tonica), "\(tonica)")
        XCTAssertNil(PresentacionDeTransposicion.tonalidad(de: "", contenido: .notas))
        XCTAssertNil(PresentacionDeTransposicion.tonalidad(de: "zzz", contenido: .notas))
        XCTAssertNil(PresentacionDeTransposicion.tonalidad(de: ""))
    }

    func testLosSilenciosYLasNotacionesQueNoSeLeen() throws {
        // Un guion o una tilde sueltos se dejan como están.
        let conSilencios = try PresentacionDeTransposicion.transponer(
            "Mi - ~ Fa", .segundaMayor, contenido: .notas, notacion: .espanolUnicode)
        XCTAssertEqual(conSilencios, "Fa♯ - ~ Sol")
        // En cualquier notación, lo transportado se vuelve a leer como lo que es.
        for notacion in Notacion.allCases {
            let acorde = try PresentacionDeTransposicion.transponer("Sol7", .segundaMenor, notacion: notacion)
            XCTAssertEqual(try Acorde(leyendo: acorde), Acorde("Lab7"), "\(notacion)")
            let altura = try PresentacionDeTransposicion.transponer(
                "Do4", .segundaMenor, contenido: .notas, notacion: notacion)
            XCTAssertEqual(try Altura(leyendo: altura), Altura(Nota.re.bemol, octava: 4), "\(notacion)")
        }
        XCTAssertEqual(PresentacionDeTransposicion.texto(de: [], notacion: .espanolUnicode), "")
        XCTAssertEqual(PresentacionDeTransposicion.intervalos.count, 6)
    }
}
