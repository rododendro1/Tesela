import XCTest
import Armonia
@testable import ArmoniaUI

final class NotacionTests: XCTestCase {
    func testCadaNotacionTieneTituloYClaveDistintos() {
        let todas = Notacion.allCases
        XCTAssertEqual(Set(todas.map(\.titulo)).count, todas.count)
        XCTAssertEqual(Set(todas.map(\.clave)).count, todas.count)
    }

    /// La clave de cada notación es el nombre de su constante, y el título, el idioma con un ejemplo.
    func testLasClavesSonLosCasos() {
        XCTAssertEqual(Notacion.desde(clave: "espanol"), .espanol)
        XCTAssertEqual(Notacion.desde(clave: "espanolUnicode"), .espanolUnicode)
        XCTAssertEqual(Notacion.desde(clave: "inglesASCII"), .inglesASCII)
        XCTAssertEqual(Notacion.desde(clave: "inglesASCII+catalan"), Notacion.inglesASCII.conTextos(en: .catalan))
        XCTAssertEqual(Notacion.espanol.clave, "espanol")
        XCTAssertEqual(Notacion.ingles.clave, "ingles")
        XCTAssertEqual(Notacion.espanol.titulo, "Español (Fa sostenido)")
        XCTAssertEqual(Notacion.ingles.titulo, "English (F sharp)")
        XCTAssertEqual(Notacion.espanolASCII.titulo, "Español (Fa#)")
        XCTAssertEqual(Notacion.inglesASCII.titulo, "English (F#)")
        XCTAssertEqual(Notacion.aleman.titulo, "Deutsch (Fis)")
        XCTAssertEqual(Notacion.espanolASCII.clave, "espanolASCII")
        XCTAssertEqual(Notacion.catalan.clave, "catalan")
    }

    func testLaClaveVuelveALaNotacion() {
        for notacion in Notacion.allCases {
            XCTAssertEqual(Notacion.desde(clave: notacion.clave), notacion)
        }
    }

    func testNotasYTextosPorSeparado() {
        let rusoEnEspanol = Notacion.ruso.conTextos(en: .espanol)
        XCTAssertEqual(rusoEnEspanol.clave, "ruso+espanol")
        XCTAssertEqual(Notacion.desde(clave: "ruso+espanol"), rusoEnEspanol)
        XCTAssertEqual(rusoEnEspanol.titulo, "Русский (фа-диез) · Español")
        XCTAssertEqual(rusoEnEspanol.idiomaElegidoParaLosTextos, .espanol)
        XCTAssertNil(Notacion.ruso.idiomaElegidoParaLosTextos)
        // Cambiar las notas conserva los textos, y quitar los textos deja las notas.
        XCTAssertEqual(rusoEnEspanol.conNotas(.griego), Notacion.griego.conTextos(en: .espanol))
        XCTAssertEqual(rusoEnEspanol.conTextosElegidos(nil), .ruso)
        XCTAssertEqual(Notacion.inglesASCII.conTextosElegidos(.catalan).clave, "inglesASCII+catalan")
        // Una parte desconocida no rompe nada.
        XCTAssertEqual(Notacion.desde(clave: "ruso+klingon"), .ruso)
        XCTAssertEqual(Notacion.desde(clave: "klingon+espanol"), .espanolUnicode)
        XCTAssertEqual(Set(Idioma.allCases.map(\.clave)).count, Idioma.allCases.count)
    }

    func testUnaClaveDesconocidaDaElEspanol() {
        XCTAssertEqual(Notacion.desde(clave: ""), .espanolUnicode)
        XCTAssertEqual(Notacion.desde(clave: "klingon"), .espanolUnicode)
        // Un ajuste antiguo guardado como índice no rompe nada.
        XCTAssertEqual(Notacion.desde(clave: "3"), .espanolUnicode)
    }

    func testElMensajeDeUnErrorAjenoEsSuDescripcion() {
        struct Falla: LocalizedError { var errorDescription: String? { "falla de prueba" } }
        XCTAssertEqual(Notacion.espanolUnicode.mensaje(de: Falla()), "falla de prueba")
    }

    func testElMensajeDeUnErrorDeLecturaNoEstaVacio() {
        do {
            _ = try Acorde(leyendo: "xyz!")
            XCTFail("«xyz!» no es un cifrado")
        } catch {
            XCTAssertFalse(Notacion.espanolUnicode.mensaje(de: error).isEmpty)
            XCTAssertFalse(Notacion.inglesASCII.mensaje(de: error).isEmpty)
        }
    }
}
