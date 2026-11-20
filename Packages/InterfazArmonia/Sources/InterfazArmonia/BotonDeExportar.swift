#if canImport(SwiftUI)
    import SwiftUI
    import Armonia
    import ExposicionArmonia

    /// Un menú «Exportar» con una entrada por fichero, que abre la hoja de compartir del sistema
    /// (guardar en Archivos, AirDrop, Mail…):
    ///
    ///     .toolbar {
    ///         ToolbarItem { BotonDeExportar([.midi(analisis.partitura().midi(), nombre: "Progresión")]) }
    ///     }
    ///
    /// Los ficheros se escriben en la carpeta temporal cada vez que cambian, no al pulsar. Una hoja de estudio en SVG
    /// (`FicheroParaExportar.esUnaHojaEnSVG`) se exporta también en PDF, en páginas A4 (`PDFDeLaHoja`), y se puede
    /// imprimir desde el mismo menú; el PDF se hace un momento después, cuando se deja de escribir.
    ///
    /// Con `BotonDeExportar(id:_:)`, los ficheros se hacen al aparecer el botón y no antes: para una lista con un
    /// botón por fila, como las tarjetas del catálogo, sin hacer la hoja de las que no se ven.
    public struct BotonDeExportar: View {
        public let ficheros: [FicheroParaExportar]
        /// Lo que distingue los ficheros que se hacen al aparecer (`init(id:_:)`), que no se tienen antes.
        private let clave: String?
        private let crear: (@MainActor () -> [FicheroParaExportar])?
        @State private var escritos: [Escrito] = []
        @Environment(\.notacion) private var notacion

        struct Escrito: Identifiable {
            let fichero: FicheroParaExportar
            let url: URL
            var id: String { fichero.id }
        }

        /// Lo que hace que se escriban otra vez: los ficheros, o la clave de los que se hacen al aparecer.
        struct Pedido: Hashable {
            let ficheros: [FicheroParaExportar]
            let clave: String?
        }

        /// Un botón que comparte esos ficheros.
        public init(_ ficheros: [FicheroParaExportar]) {
            self.ficheros = ficheros
            clave = nil
            crear = nil
        }

        /// Un botón que comparte los ficheros de `crear`, que se llama al aparecer el botón y cada vez que cambia
        /// `id`.
        public init(id: String, _ crear: @escaping @MainActor () -> [FicheroParaExportar]) {
            ficheros = []
            clave = id
            self.crear = crear
        }

        public var body: some View {
            Menu {
                ForEach(escritos) { escrito in
                    ShareLink(item: escrito.url) {
                        Label(
                            "\(escrito.fichero.formato.titulo(en: notacion)) · \(escrito.fichero.nombreDeFichero)",
                            systemImage: escrito.fichero.formato.icono)
                    }
                }
                let hojas = escritos.filter { $0.fichero.formato == .pdf }
                if !hojas.isEmpty {
                    Divider()
                    ForEach(hojas) { hoja in
                        let titulo =
                            notacion.texto(\.imprimirLaHoja) + (hojas.count > 1 ? " · " + hoja.fichero.nombre : "")
                        let fichero = hoja.fichero
                        Button {
                            Task { @MainActor in ImpresionDeLaHoja.imprimir(fichero.datos, nombre: fichero.nombre) }
                        } label: {
                            Label(titulo, systemImage: "printer")
                        }
                    }
                }
            } label: {
                Label(notacion.texto(\.exportar), systemImage: "square.and.arrow.up")
            }
            .disabled(escritos.isEmpty)
            .accessibilityIdentifier("exportar")
            .task(id: Pedido(ficheros: ficheros, clave: clave)) {
                let pedidos = crear?() ?? ficheros
                escritos = pedidos.compactMap { fichero in
                    (try? fichero.escribir()).map { Escrito(fichero: fichero, url: $0) }
                }
                await anadirLosPDF(de: pedidos)
            }
        }

        /// El PDF de cada hoja de estudio en SVG, detrás de su SVG. Espera medio segundo antes: si los ficheros
        /// cambian mientras tanto (se está escribiendo un acorde), la tarea se cancela y no se hace.
        @MainActor
        private func anadirLosPDF(de ficheros: [FicheroParaExportar]) async {
            #if canImport(WebKit) && canImport(PDFKit)
                let hojas = ficheros.filter(\.esUnaHojaEnSVG)
                guard !hojas.isEmpty else { return }
                do { try await Task.sleep(nanoseconds: 500_000_000) } catch { return }
                for hoja in hojas {
                    let svg = String(decoding: hoja.datos, as: UTF8.self)
                    guard let datos = try? await PDFDeLaHoja.pdf(deUnSVG: svg), !Task.isCancelled else { continue }
                    let pdf = FicheroParaExportar.pdf(datos, nombre: hoja.nombre)
                    guard let url = try? pdf.escribir() else { continue }
                    let escrito = Escrito(fichero: pdf, url: url)
                    escritos.removeAll { $0.id == escrito.id }
                    let detras = escritos.firstIndex { $0.fichero == hoja }.map { $0 + 1 } ?? escritos.count
                    escritos.insert(escrito, at: detras)
                }
            #endif
        }
    }
#endif
