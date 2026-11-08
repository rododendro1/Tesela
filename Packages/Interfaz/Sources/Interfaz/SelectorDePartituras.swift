#if canImport(SwiftUI)
    import Armonia
    import Exposicion
    import Foundation
    import SwiftUI
    import UniformTypeIdentifiers

    extension View {
        /// El selector de ficheros para abrir una partitura: MIDI, MusicXML (también .mxl), MEI o ABC
        /// (`ImportacionDeProgresion.extensiones`). Lee el fichero elegido, con permiso si es de fuera de la app
        /// (Archivos, iCloud), y da su progresión o el error:
        ///
        ///     .selectorDePartituras(isPresented: $abriendo) { leida in
        ///         importada = try? leida.get()
        ///     }
        public func selectorDePartituras(
            isPresented: Binding<Bool>, alAbrir: @escaping (Result<ProgresionImportada, any Error>) -> Void
        ) -> some View {
            fileImporter(isPresented: isPresented, allowedContentTypes: tiposDePartitura) { elegido in
                alAbrir(Result { try leerPartitura(elegido.get()) })
            }
        }
    }

    /// Los tipos de fichero de las partituras que se leen.
    private var tiposDePartitura: [UTType] {
        [.midi, .xml] + ImportacionDeProgresion.extensiones.compactMap { UTType(filenameExtension: $0) }
    }

    /// La progresión de un fichero elegido. Los ficheros de fuera de la app (Archivos, iCloud) solo se leen con
    /// permiso.
    private func leerPartitura(_ url: URL) throws -> ProgresionImportada {
        let conPermiso = url.startAccessingSecurityScopedResource()
        defer { if conPermiso { url.stopAccessingSecurityScopedResource() } }
        return try ImportacionDeProgresion.leer(Data(contentsOf: url))
    }
#endif
