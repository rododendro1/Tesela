import Armonia
import ArmoniaUI
import SwiftUI
import UniformTypeIdentifiers

/// Escribe una progresión (Do Fa Sol7 Do Lam Re7 Sol), o la saca de un fichero MIDI o MusicXML con «Abrir» (con su
/// ritmo armónico, que siguen la partitura, el MIDI y «Escuchar» mientras no se retoque), y
/// muestra sus tonalidades, los grados, las funciones, las modulaciones y las cadencias, y la exporta como
/// partitura o MIDI, también arpegiada. Mientras suena, se resalta el acorde que se oye. La progresión se puede
/// llevar a otra tonalidad y rearmonizar acorde a acorde.
struct VistaDeAnalisis: View {
    @Environment(\.notacion) private var notacion
    @State private var texto = "Do Fa Sol7 Do Lam Re7 Sol"
    /// El análisis de `texto`, que se rehace al cambiar el texto o la notación, no en cada redibujado.
    @State private var resultado: Result<AnalisisPresentado, Error>?
    @State private var abriendo = false
    /// Por qué no se pudo abrir el último fichero; se borra al abrir otro o al cambiar el texto.
    @State private var errorAlAbrir: Error?
    /// La progresión del último fichero abierto, con su ritmo armónico: se usa mientras el campo diga lo mismo.
    @State private var importada: ProgresionImportada?
    @State private var patron = Arpegio.Patron.ascendente
    @State private var figura = Figura.corchea
    /// Lo que está sonando, para resaltar el acorde que se oye.
    @ObservedObject private var reproductor = Reproductor.compartido

    /// Las figuras que se ofrecen para las notas de la progresión arpegiada.
    private static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// MIDI y MusicXML sin comprimir (.musicxml y .xml).
    private static let tipos: [UTType] =
        [.midi, .xml]
        + ImportacionDeProgresion.extensiones.compactMap { UTType(filenameExtension: $0) }

    var body: some View {
        Form {
            Section(notacion.texto(\.progresion)) {
                TextField(notacion.texto(\.campoDeProgresion), text: $texto)
                    .comoCampoDeCifrado()
                if let errorAlAbrir {
                    Text(notacion.mensaje(de: errorAlAbrir)).foregroundColor(.red)
                }
            }
            switch resultado {
            case .some(.success(let analisis)):
                Section(notacion.texto(\.resultado)) {
                    Text(analisis.titulo).font(.headline)
                    BotonDeEscuchar(analisis.sonido)
                }
                // El acorde que suena, contado desde el primero de todos los tramos.
                let sonando = reproductor.paso(de: analisis.sonido)
                ForEach(Array(analisis.tramos.enumerated()), id: \.offset) { t, tramo in
                    let antes = analisis.tramos.prefix(t).map(\.filas.count).reduce(0, +)
                    Section(tramo.cabecera ?? notacion.texto(\.acordeAAcorde)) {
                        ForEach(Array(tramo.filas.enumerated()), id: \.offset) { i, fila in
                            HStack {
                                Text(fila.cifrado)
                                    .font(.system(.body, design: .monospaced))
                                    .frame(minWidth: 80, alignment: .leading)
                                Text(fila.grado).bold()
                                Spacer()
                                Text(fila.funcion).foregroundColor(.secondary)
                            }
                            .listRowBackground(sonando == antes + i ? TemaDeLasApps.resaltado.opacity(0.25) : nil)
                        }
                    }
                }
                if !analisis.cadencias.isEmpty {
                    Section(notacion.texto(\.cadencias)) {
                        ForEach(analisis.cadencias, id: \.self) { Text($0) }
                    }
                }
                arpegiar(analisis)
                rearmonizar(analisis)
            case .some(.failure(let error)):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            case .none:
                EmptyView()
            }
        }
        .navigationTitle(notacion.texto(\.analisis))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                Button {
                    abriendo = true
                } label: {
                    Label(notacion.texto(\.abrir), systemImage: "folder")
                }
            }
            ToolbarItem {
                menuDeTransponer
            }
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .fileImporter(isPresented: $abriendo, allowedContentTypes: Self.tipos) { elegido in
            abrir(elegido)
        }
        .onChange(of: texto) { _ in errorAlAbrir = nil }
        .task(id: "\(texto)|\(notacion.clave)|\(importada?.hashValue ?? 0)") {
            // Lo abierto, con el ritmo de la pieza, mientras no se retoque; si no, lo escrito.
            let abierta = importada?.texto == texto ? importada : nil
            if let abierta, let analisis = PresentacionDeAnalisis.analizar(abierta, notacion: notacion) {
                resultado = .success(analisis)
            } else {
                resultado = Result { try PresentacionDeAnalisis.analizar(texto, notacion: notacion) }
            }
        }
    }

    /// Las partituras y el MIDI de la progresión y de la progresión arpegiada con el patrón elegido.
    private var ficheros: [FicheroParaExportar] {
        guard let analisis = try? resultado?.get() else { return [] }
        let arpegiada = analisis.arpegiada(patron, figura: figura.duracion, notacion: notacion)
        return analisis.ficheros + (arpegiada?.ficheros ?? [])
    }

    /// «Transponer»: las demás tonalidades del mismo modo. Lo abierto de un fichero conserva su ritmo armónico.
    @ViewBuilder
    private var menuDeTransponer: some View {
        if let analisis = try? resultado?.get(), let tonalidad = analisis.tonalidad {
            Menu {
                ForEach(PresentacionDeTransposicion.destinos(desde: tonalidad), id: \.self) { destino in
                    Button(destino.nombre(en: notacion)) { transponer(de: tonalidad, a: destino) }
                }
            } label: {
                Label(notacion.texto(\.transponer), systemImage: "arrow.up.arrow.down")
            }
        }
    }

    private func transponer(de origen: Tonalidad, a destino: Tonalidad) {
        if let abierta = importada, abierta.texto == texto {
            let intervalo = origen.tonica.intervaloMasCorto(hasta: destino.tonica)
            let transportada = PresentacionDeTransposicion.transponer(abierta, intervalo)
            importada = transportada
            texto = transportada.texto
        } else if let nuevo = try? PresentacionDeTransposicion.transponer(
            texto, de: origen, a: destino, notacion: notacion)
        {
            texto = nuevo
        }
    }

    /// Otras armonías para cada acorde: cómo suena el pasaje con el cambio y el botón que lo pone en la progresión.
    @ViewBuilder
    private func rearmonizar(_ analisis: AnalisisPresentado) -> some View {
        let propuestas = analisis.rearmonizaciones(en: notacion)
        if !propuestas.isEmpty {
            Section(notacion.texto(\.rearmonizar)) {
                ForEach(propuestas, id: \.self) { propuesta in
                    HStack {
                        Text(propuesta.descripcion)
                        Spacer()
                        BotonDeEscuchar(propuesta.sonido)
                            .labelStyle(.iconOnly)
                        Button(notacion.texto(\.aplicar)) { texto = propuesta.texto }
                    }
                    // Cada botón por su lado, no la fila entera.
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    /// La progresión arpegiada: cada acorde una blanca (o lo que dure en la pieza abierta), con el patrón y la
    /// figura elegidos.
    @ViewBuilder
    private func arpegiar(_ analisis: AnalisisPresentado) -> some View {
        if let arpegiada = analisis.arpegiada(patron, figura: figura.duracion, notacion: notacion) {
            Section(notacion.texto(\.arpegiar)) {
                Picker(notacion.texto(\.patron), selection: $patron) {
                    ForEach(Arpegio.Patron.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                }
                Picker(notacion.texto(\.figura), selection: $figura) {
                    ForEach(Self.figuras, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                }
                BotonDeEscuchar(arpegiada.sonido)
            }
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
            let leida = try ImportacionDeProgresion.leer(Data(contentsOf: url))
            importada = leida
            texto = leida.texto
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }
}
