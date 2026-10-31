import Armonia
import XCTest

@testable import ArmoniaUI

#if canImport(SwiftUI) && canImport(WebKit)
    final class VistaSVGTests: XCTestCase {
        func testLaPaginaIncluyeElSVG() {
            let pagina = VistaSVG.pagina("<svg id=\"dibujo\"></svg>")
            XCTAssertTrue(pagina.contains("<svg id=\"dibujo\"></svg>"))
            XCTAssertTrue(pagina.hasPrefix("<!doctype html>"))
            XCTAssertTrue(pagina.contains("background:#fff"))
        }

        func testLaPaginaAdaptableSigueElModoDelSistema() {
            let pagina = VistaSVG.pagina("<svg></svg>", adaptable: true)
            XCTAssertTrue(pagina.contains("color-scheme:light dark"))
            XCTAssertTrue(pagina.contains("background:Canvas"))
            XCTAssertFalse(pagina.contains("#fff"))
        }
    }
#endif
