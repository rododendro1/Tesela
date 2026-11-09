import XCTest

/// El recorrido con P, L y R desde Do, deshacer, el cambio a un acorde y a una escala, el modo de partitura (sin
/// fichero y con una progresión abierta) y el de identificar.
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

    /// Sin fichero, «Partitura» pide abrir uno.
    func testPartitura() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Partitura").tap()
        esperar(app.texto("Abre un fichero MIDI"), "la indicación")
        esperar(app.buttons["Abrir"], "el botón de abrir")
    }

    /// Con una progresión abierta, «Siguiente» avanza de acorde y dice la transformación: de Do a Lam, R.
    func testPartituraAbierta() {
        let app = XCUIApplication()
        app.launchArguments += [
            "-notacionElegida", "espanolCompacto", "-temperamentoElegido", "igual",
            "-partituraDePrueba", "Do Lam Fa Sol",
        ]
        app.launch()
        esperar(app.texto("1/4 · Do"), "el primer acorde")
        app.buttons["Siguiente"].tap()
        esperar(app.texto("2/4 · Do –R→ Lam"), "la relativa de Do")
        app.buttons["Siguiente"].tap()
        esperar(app.texto("3/4 · Lam –L→ Fa"), "el cambio de sensible de Lam")
        app.buttons["Anterior"].tap()
        esperar(app.texto("2/4 · Do –R→ Lam"), "otra vez Lam")
    }

    func testIdentificar() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Identificar").tap()
        esperar(app.texto("Toca notas para saber"), "la indicación")
        esperar(app.buttons["Borrar"], "el botón de borrar")
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
