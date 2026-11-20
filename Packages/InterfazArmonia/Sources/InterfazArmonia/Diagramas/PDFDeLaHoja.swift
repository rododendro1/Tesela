#if canImport(SwiftUI) && canImport(WebKit) && canImport(PDFKit)
    import Foundation
    import PDFKit
    import WebKit
    import ExposicionArmonia

    /// Una hoja de estudio en SVG, a un PDF de páginas A4, sin programas de fuera: WebKit dibuja cada página de
    /// `HojaDeEstudio.paginas(deUnSVG:)` en un PDF de 595 × 842 puntos y PDFKit las junta. Es lo que hace
    /// `armonia grabar hoja` con `rsvg-convert`, para las apps.
    ///
    ///     let pdf = try await PDFDeLaHoja.pdf(deUnSVG: HojaDeEstudio.escala(Escala(.re, .dorico), en: notacion))
    @MainActor
    public enum PDFDeLaHoja {
        /// Lo que puede fallar: WebKit no da el PDF de una página, o no queda ninguna.
        public enum Fallo: Error, Sendable {
            case paginaSinDibujar
            case sinPaginas
        }

        /// Un A4, en puntos.
        static let ancho = 595.0
        static let alto = 842.0

        /// El PDF de todas las páginas de la hoja, en orden.
        public static func pdf(deUnSVG svg: String) async throws -> Data {
            let documento = PDFDocument()
            for pagina in HojaDeEstudio.paginas(deUnSVG: svg) {
                try Task.checkCancellation()
                guard let suelta = PDFDocument(data: try await dibujar(pagina)) else { throw Fallo.paginaSinDibujar }
                for indice in 0..<suelta.pageCount {
                    if let hoja = suelta.page(at: indice) { documento.insert(hoja, at: documento.pageCount) }
                }
            }
            guard documento.pageCount > 0, let datos = documento.dataRepresentation() else { throw Fallo.sinPaginas }
            return datos
        }

        /// La página: el SVG de un A4 a su tamaño (sus `pt` como píxeles de CSS, que en el PDF son puntos), sin
        /// márgenes y en blanco.
        static func pagina(_ svg: String) -> String {
            let (ancho, alto) = (Int(Self.ancho), Int(Self.alto))
            return """
                <!doctype html><html><head><meta charset="utf-8">
                <style>html,body{margin:0;background:#fff}svg{display:block;width:\(ancho)px;height:\(alto)px}</style>
                </head><body>\(svg)</body></html>
                """
        }

        /// Una página, en un PDF de una página.
        private static func dibujar(_ svg: String) async throws -> Data {
            let vista = VistaSVG.crearVista()
            vista.frame = CGRect(x: 0, y: 0, width: ancho, height: alto)
            let carga = EsperaDeLaCarga()
            vista.navigationDelegate = carga
            try await carga.cargar(pagina(svg), en: vista)
            let configuracion = WKPDFConfiguration()
            configuracion.rect = CGRect(x: 0, y: 0, width: ancho, height: alto)
            let datos: Data = try await withCheckedThrowingContinuation { continuacion in
                vista.createPDF(configuration: configuracion) { continuacion.resume(with: $0) }
            }
            // La vista no debe soltar a quien la espera antes de terminar.
            withExtendedLifetime(carga) {}
            return datos
        }
    }

    /// Espera a que WebKit termine de cargar una página.
    @MainActor
    private final class EsperaDeLaCarga: NSObject, WKNavigationDelegate {
        private var continuacion: CheckedContinuation<Void, Error>?

        func cargar(_ html: String, en vista: WKWebView) async throws {
            try await withCheckedThrowingContinuation { (continuacion: CheckedContinuation<Void, Error>) in
                self.continuacion = continuacion
                vista.loadHTMLString(html, baseURL: nil)
            }
        }

        private func terminar(_ error: Error?) {
            guard let continuacion else { return }
            self.continuacion = nil
            if let error { continuacion.resume(throwing: error) } else { continuacion.resume() }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            terminar(nil)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            terminar(error)
        }

        func webView(
            _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error
        ) {
            terminar(error)
        }
    }
#endif
