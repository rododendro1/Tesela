import XCTest

/// Recorre las cinco pestañas de Armonía y las vistas que se abren desde ellas (contrapunto y serie dodecafónica) con
/// los textos de ejemplo de cada una y comprueba que se ve el resultado.
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
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Do mayor: Do₄, Re₄")), "el pentagrama de Do mayor")
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

    /// El contrapunto se abre desde Coral y empieza con el ejemplo de Fux de la primera especie, sin faltas.
    func testContrapunto() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Coral").tap()
        app.buttons["Contrapunto"].tap()
        esperar(app.texto("Sin faltas."), "el ejemplo de la primera especie")
        esperar(app.texto("Compás 1"), "la fila del primer compás")
        // La segunda especie, también con su ejemplo sin faltas.
        app.opcion("2").tap()
        esperar(app.texto("Especie 2"), "la cabecera de la segunda especie")
        esperar(app.texto("Sin faltas."), "el ejemplo de la segunda especie")
    }

    /// Las disposiciones del acorde: empieza en drop 2 y el selector cambia el pentagrama a la posición cerrada.
    func testDisposicionesDelAcorde() {
        let app = XCUIApplication.enEspanol()
        esperar(app.texto("Si Re Fa Sol"), "las notas de Sol7/Si")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Sol7/Si · Drop 2: ")), "el pentagrama en drop 2")
        app.elegirEnSelector("Cerrada", actual: "Drop 2")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Sol7/Si · Cerrada: ")), "el pentagrama en posición cerrada")
    }

    /// La progresión del análisis, dispuesta con el menor movimiento de las voces, también en posición cerrada.
    func testProgresionDispuesta() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Análisis").tap()
        esperar(app.texto("en Do mayor"), "el análisis")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Drop 2: ")), "la progresión en drop 2")
        app.elegirEnSelector("Cerrada", actual: "Drop 2")
        esperar(app.buscandoHaciaAbajo(app.etiqueta("Cerrada: ")), "la progresión en posición cerrada")
    }

    /// La serie dodecafónica se abre desde Identificar con la de Berg: sus datos, la matriz y, al tocar el nombre de
    /// una columna, esa inversión. Una serie a la que le faltan clases da un aviso.
    func testSerieDodecafonica() {
        let app = XCUIApplication.enEspanol()
        app.opcion("Identificar").tap()
        app.buttons["Serie dodecafónica"].tap()
        esperar(app.texto("6-32 · 6-32"), "los hexacordos de la serie de Berg")
        esperar(app.texto("De todos los intervalos"), "que es de todos los intervalos")
        esperar(app.texto("Fa Mi Do La Sol Re"), "las notas de P5")
        app.buscandoHaciaAbajo(app.buttons["I5"]).tap()
        esperar(app.texto("Fa Fa♯ Si♭ Do♯ Mi♭ La♭"), "las notas de I5")
        app.reemplazar(en: app.textFields["serie"], por: "0 1 2")
        esperar(app.texto("las doce clases de altura"), "el aviso de que no es dodecafónica")
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
