#if canImport(SwiftUI)
    import Foundation
    #if canImport(PDFKit)
        import PDFKit
    #endif
    #if os(macOS)
        import AppKit
    #elseif canImport(UIKit)
        import UIKit
    #endif

    /// Imprime una hoja de estudio en PDF (la de `PDFDeLaHoja`) con el diálogo del sistema: en macOS, el de
    /// imprimir, a su tamaño A4; en iOS, el de AirPrint.
    @MainActor
    public enum ImpresionDeLaHoja {
        /// Abre el diálogo de imprimir con el PDF. `nombre` es el del trabajo de impresión.
        public static func imprimir(_ pdf: Data, nombre: String) {
            #if os(macOS)
                guard let documento = PDFDocument(data: pdf) else { return }
                let ajustes = NSPrintInfo.shared
                guard
                    let operacion = documento.printOperation(
                        for: ajustes, scalingMode: .pageScaleToFit, autoRotate: true)
                else { return }
                operacion.jobTitle = nombre
                operacion.run()
            #elseif canImport(UIKit)
                let informacion = UIPrintInfo(dictionary: nil)
                informacion.outputType = .general
                informacion.jobName = nombre
                let controlador = UIPrintInteractionController.shared
                controlador.printInfo = informacion
                controlador.printingItem = pdf
                controlador.present(animated: true)
            #endif
        }
    }
#endif
