import Armonia
import Foundation
import Testing

@testable import ArmoniaUI

#if canImport(SwiftUI) && canImport(WebKit)
    @Suite struct VistaSVGTests {
        @Test func laPaginaIncluyeElSVG() {
            let pagina = VistaSVG.pagina("<svg id=\"dibujo\"></svg>")
            #expect(pagina.contains("<svg id=\"dibujo\"></svg>"))
            #expect(pagina.hasPrefix("<!doctype html>"))
            #expect(pagina.contains("background:#fff"))
        }

        @Test func laPaginaAdaptableSigueElModoDelSistema() {
            let pagina = VistaSVG.pagina("<svg></svg>", adaptable: true)
            #expect(pagina.contains("color-scheme:light dark"))
            #expect(pagina.contains("background:Canvas"))
            #expect(!pagina.contains("#fff"))
        }
    }
#endif
