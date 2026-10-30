import SwiftUI
import UniformTypeIdentifiers
import Armonia
import ArmoniaUI

/// Escribe una progresión (Do Fa Sol7 Do Lam Re7 Sol), o la saca de un fichero MIDI o MusicXML con «Abrir», y
/// muestra sus tonalidades, los grados, las funciones, las modulaciones y las cadencias, y la exporta como
/// partitura o MIDI.
struct VistaDeAnalisis: View {
    @Environment(\.notacion) private var notacion
    @State private var texto = "Do Fa Sol7 Do Lam Re7 Sol"
    /// El análisis de `texto`, que se rehace al cambiar el texto o la notación, no en cada redibujado.
    @State private var resultado: Result<AnalisisPresentado, Error>?
    @State private var abriendo = false
    /// Por qué no se pudo abrir el último fichero; se borra al abrir otro o al cambiar el texto.
    @State private var errorAlAbrir: Error?

    /// MIDI y MusicXML sin comprimir (.musicxml y .xml).
    private static let tipos: [UTType] = [.midi, .xml]
        + ImportacionDeProgresion.extensiones.compactMap { UTType(filenameExtension: $0) }

    var body: some View {
        Form {
            Section(notacion.texto(.progresion)) {
                TextField(notacion.texto(.campoDeProgresion), text: $texto)
                    .comoCampoDeCifrado()
                if let errorAlAbrir {
                    Text(notacion.mensaje(de: errorAlAbrir)).foregroundColor(.red)
                }
            }
            switch resultado {
            case .some(.success(let analisis)):
                Section(notacion.texto(.resultado)) {
                    Text(analisis.titulo).font(.headline)
                    BotonDeEscuchar(analisis.sonido)
                }
                ForEach(Array(analisis.tramos.enumerated()), id: \.offset) { _, tramo in
                    Section(tramo.cabecera ?? notacion.texto(.acordeAAcorde)) {
                        ForEach(Array(tramo.filas.enumerated()), id: \.offset) { _, fila in
                            HStack {
                                Text(fila.cifrado)
                                    .font(.system(.body, design: .monospaced))
                                    .frame(minWidth: 80, alignment: .leading)
                                Text(fila.grado).bold()
                                Spacer()
                                Text(fila.funcion).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                if !analisis.cadencias.isEmpty {
                    Section(notacion.texto(.cadencias)) {
                        ForEach(analisis.cadencias, id: \.self) { Text($0) }
                    }
                }
            case .some(.failure(let error)):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            case .none:
                EmptyView()
            }
        }
        .navigationTitle(notacion.texto(.analisis))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                Button { abriendo = true } label: { Label(notacion.texto(.abrir), systemImage: "folder") }
            }
            ToolbarItem {
                BotonDeExportar((try? resultado?.get())?.ficheros ?? [])
            }
        }
        .fileImporter(isPresented: $abriendo, allowedContentTypes: Self.tipos) { elegido in
            abrir(elegido)
        }
        .onChange(of: texto) { _ in errorAlAbrir = nil }
        .task(id: "\(texto)|\(notacion.clave)") {
            resultado = Result { try PresentacionDeAnalisis.analizar(texto, notacion: notacion) }
        }
    }

    /// Lee el fichero elegido y pone sus acordes en el campo de la progresión, que se analiza como si se
    /// hubieran escrito.
    private func abrir(_ elegido: Result<URL, Error>) {
        do {
            let url = try elegido.get()
            // Los ficheros de fuera de la app (Archivos, iCloud) solo se leen con permiso.
            let conPermiso = url.startAccessingSecurityScopedResource()
            defer { if conPermiso { url.stopAccessingSecurityScopedResource() } }
            let progresion = try ImportacionDeProgresion.progresion(de: Data(contentsOf: url))
            texto = progresion
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }
}
