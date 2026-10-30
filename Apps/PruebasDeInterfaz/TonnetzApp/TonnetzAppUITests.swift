import XCTest

/// El recorrido con P, L y R desde Do, deshacer, el cambio a un acorde y a una escala, y el modo de identificar.
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

    func testIdentificar() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Identificar").tap()
        esperar(app.texto("Toca notas para saber"), "la indicación")
        esperar(app.buttons["Borrar"], "el botón de borrar")
    }
}
