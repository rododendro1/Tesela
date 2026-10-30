import XCTest

/// Recorre las cinco pestañas de Armonía con los textos de ejemplo de cada una y comprueba que se ve el resultado.
@MainActor
final class ArmoniaAppUITests: XCTestCase {
    func testAcordes() {
        let app = XCUIApplication.enEspanol()
        // El ejemplo, Sol7/Si, con el bajo primero.
        esperar(app.texto("Si Re Fa Sol"), "las notas de Sol7/Si")
        app.reemplazar(en: app.textFields.firstMatch, por: "Do7")
        esperar(app.texto("Do Mi Sol Si♭"), "las notas de Do7")
    }

    /// El pentagrama del acorde se lee con sus notas desde el bajo.
    func testPentagramaDelAcorde() {
        let app = XCUIApplication.enEspanol()
        esperar(app.texto("Si Re Fa Sol"), "las notas de Sol7/Si")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Sol7/Si: Si, Re, Fa, Sol")), "el pentagrama de Sol7/Si")
        app.reemplazar(en: app.textFields.firstMatch, por: "Do7")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Do7: Do, Mi, Sol, Si♭")), "el pentagrama de Do7")
    }

    func testEscalas() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Escalas").tap()
        // La primera tónica y la primera escala del catálogo: Do mayor.
        esperar(app.texto("Do  Re  Mi  Fa  Sol  La  Si"), "las notas de Do mayor")
        esperar(app.texto("Rem"), "los acordes de la escala")
    }

    /// El pentagrama de la escala dice sus notas con la octava.
    func testPentagramaDeLaEscala() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Escalas").tap()
        esperar(app.texto("Do  Re  Mi  Fa  Sol  La  Si"), "las notas de Do mayor")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Do mayor: Do4, Re4")), "el pentagrama de Do mayor")
    }

    func testAnalisis() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Análisis").tap()
        // Do Fa Sol7 Do Lam Re7 Sol: empieza en Do mayor y modula a Sol mayor.
        esperar(app.texto("en Do mayor"), "la tonalidad del principio")
        esperar(app.texto("en Sol mayor"), "la modulación")
    }

    func testCoral() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Coral").tap()
        // Mi4 Fa4 Re4 Do4: las armonizaciones van numeradas.
        esperar(app.texto("1. "), "la primera armonización")
        // Do Fa Sol7 Do a cuatro voces, con sus grados.
        app.opcion("Realizar").tap()
        esperar(app.texto("V7"), "el grado de Sol7", segundos: 30)
    }

    func testIdentificar() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Identificar").tap()
        esperar(app.texto("Toca el mástil"), "la indicación del mástil")
    }

    /// El selector de la barra cambia la notación de toda la app y la guarda.
    func testSelectorDeNotacion() {
        let app = XCUIApplication.conLaNotacionGuardada()
        // Empieza en la notación guardada o en la del idioma del simulador, normalmente el inglés.
        let selector = app.menu("selectorDeNotacion")
        esperar(selector, "el selector de notación")
        selector.tap()
        app.elegirEnMenu("English (F#)", submenus: ["Notas", "Notes"])
        esperar(app.texto("B D F G"), "las notas de Sol7/Si en inglés")
        esperar(app.opcion("Scales"), "las pestañas en inglés")

        selector.tap()
        app.elegirEnMenu("Español (Fa♯)", submenus: ["Notas", "Notes"])
        esperar(app.texto("Si Re Fa Sol"), "las notas de Sol7/Si en español")
        esperar(app.opcion("Escalas"), "las pestañas en español")
    }

    /// El menú de exportar del análisis ofrece la partitura, en MusicXML entre otros formatos.
    func testExportar() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Análisis").tap()
        esperar(app.texto("en Do mayor"), "el análisis")
        let exportar = app.menu("exportar")
        esperar(exportar, "el botón de exportar")
        // Se activa cuando los ficheros están escritos.
        expectation(for: NSPredicate(format: "isEnabled == true"), evaluatedWith: exportar)
        waitForExpectations(timeout: 15)
        exportar.tap()
        esperar(app.etiqueta("Partitura MusicXML"), "la partitura MusicXML en el menú")
    }
}
