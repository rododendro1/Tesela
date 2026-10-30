import XCTest

/// El recorrido con P, L y R desde Do, deshacer, y el cambio a un acorde y a una escala.
@MainActor
final class TonnetzAppUITests: XCTestCase {
    func testRecorrido() {
        let app = XCUIApplication.enEspanol()
        app.buttons["P"].tap()
        esperar(app.texto("Do → Dom"), "la paralela de Do")
        app.buttons["Deshacer"].tap()
        app.buttons["L"].tap()
        esperar(app.texto("Do → Mim"), "el cambio de sensible de Do")
        app.buttons["R"].tap()
        esperar(app.texto("Do → Mim → Sol"), "la relativa de Mim")
    }

    func testAcordeYEscala() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Acorde").tap()
        esperar(app.textFields.firstMatch, "el campo del acorde")
        XCTAssertEqual(app.textFields.firstMatch.value as? String, "Dom7")
        app.opcion("Escala").tap()
        esperar(app.textFields.firstMatch, "el campo de la escala")
        XCTAssertEqual(app.textFields.firstMatch.value as? String, "Re dórico")
    }

    /// El teclado UIL: se elige en el selector de la red, empieza en el Wicki-Hayden y el espejo le quita la M.
    func testTecladoUIL() {
        let app = XCUIApplication.enEspanol()
        app.elegirEnSelector("UIL", actual: "Tonnetz")
        esperar(app.texto("2,7,5;R30M"), "el formato del Wicki-Hayden")
        esperar(app.etiqueta("UIL 2,7,5;R30M"), "el dibujo del teclado")
        app.activar("Espejo")
        esperar(app.texto("2,7,5;R330"), "el teclado reflejado")
        esperar(app.etiqueta("UIL 2,7,5;R330"), "el dibujo del teclado reflejado")
    }
}
