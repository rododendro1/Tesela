import XCTest

// Lo que comparten las pruebas de interfaz de las dos apps: abrirlas siempre con la misma notación y buscar
// textos, pestañas y botones igual en iOS y en macOS.

extension XCUIApplication {
    /// Abre la app con la notación española y el temperamento igual, sea cual sea el idioma del sistema o lo
    /// que se eligiera antes. Los argumentos `-clave valor` van a los ajustes (UserDefaults) solo mientras dura
    /// la prueba, y `@AppStorage` los lee como si estuvieran guardados.
    static func enEspanol() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += ["-notacionElegida", "espanolUnicode", "-temperamentoElegido", "igual"]
        app.launch()
        return app
    }

    /// El primer texto que contiene `texto`. En iOS el texto está en la etiqueta; en macOS, a veces en el valor.
    func texto(_ texto: String) -> XCUIElement {
        staticTexts.matching(NSPredicate(format: "label CONTAINS %@ OR value CONTAINS %@", texto, texto)).firstMatch
    }

    /// Una pestaña o una opción de un selector segmentado: un botón en iOS, un botón de opción en macOS.
    func opcion(_ titulo: String) -> XCUIElement {
        #if os(macOS)
        let opcion = radioButtons[titulo]
        return opcion.waitForExistence(timeout: 5) ? opcion : buttons[titulo]
        #else
        return buttons[titulo]
        #endif
    }

    /// Abre la app sin fijar la notación: la que se eligió la última vez o, si no, la del idioma del sistema.
    /// Para probar el selector, que guarda en los ajustes de la app (los argumentos de `enEspanol()` mandan
    /// sobre ellos y no dejarían ver el cambio).
    static func conLaNotacionGuardada() -> XCUIApplication {
        let app = XCUIApplication()
        app.launch()
        return app
    }

    /// El menú con ese identificador de accesibilidad («selectorDeNotacion», «exportar»). Se busca por el
    /// identificador porque en macOS la barra no da a sus menús la etiqueta que se ve.
    func menu(_ identificador: String) -> XCUIElement {
        descendants(matching: .any).matching(identifier: identificador).firstMatch
    }

    /// Una opción de un menú abierto. Si no está a la vista, abre antes el submenú que exista de `submenus`
    /// (su nombre depende del idioma en que esté la app).
    func elegirEnMenu(_ titulo: String, submenus: [String] = []) {
        #if os(macOS)
        let opcion = menuItems[titulo]
        if !opcion.waitForExistence(timeout: 3), let submenu = submenus.map({ menuItems[$0] }).first(where: { $0.exists }) {
            submenu.hover()
        }
        esperar(opcion, "la opción «\(titulo)»")
        opcion.click()
        #else
        // El botón del selector lleva por título la notación elegida: no confundirlo con la opción del menú.
        let opcion = buttons.matching(NSPredicate(format: "label == %@ AND identifier != %@", titulo, "selectorDeNotacion"))
            .firstMatch
        if !opcion.waitForExistence(timeout: 3), let submenu = submenus.map({ buttons[$0] }).first(where: { $0.exists }) {
            submenu.tap()
        }
        esperar(opcion, "la opción «\(titulo)»")
        opcion.tap()
        #endif
    }

    /// Hay algún elemento cuya etiqueta contiene `texto` (botones y opciones de menú incluidos). En macOS las
    /// opciones de menú lo llevan en el título.
    func etiqueta(_ texto: String) -> XCUIElement {
        descendants(matching: .any).matching(NSPredicate(format: "label CONTAINS %@ OR title CONTAINS %@", texto, texto))
            .firstMatch
    }

    /// Borra lo escrito en `campo` y escribe `texto`.
    func reemplazar(en campo: XCUIElement, por texto: String) {
        #if os(macOS)
        campo.click()
        campo.typeKey("a", modifierFlags: .command)
        campo.typeText(XCUIKeyboardKey.delete.rawValue)
        #else
        // Tocando a la derecha el cursor queda al final del texto.
        campo.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        let escrito = campo.value as? String ?? ""
        campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: escrito.count))
        #endif
        campo.typeText(texto)
    }
}

/// Falla si `elemento` no aparece en `segundos` (los cálculos en segundo plano tardan un poco).
@MainActor
func esperar(_ elemento: XCUIElement, _ descripcion: String, segundos: Double = 15,
             file: StaticString = #filePath, line: UInt = #line) {
    guard elemento.waitForExistence(timeout: segundos) else {
        // Lo que hay en pantalla, para ver en el registro del CI qué se buscaba mal.
        print(XCUIApplication().debugDescription)
        XCTFail("No aparece \(descripcion)", file: file, line: line)
        return
    }
}
