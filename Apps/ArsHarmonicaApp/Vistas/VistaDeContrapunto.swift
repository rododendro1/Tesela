import Armonia
import Interfaz
import SwiftUI

/// Un ejercicio de contrapunto de especies a dos voces, como los del Gradus ad Parnassum de Fux: se escriben el
/// cantus firmus y el contrapunto, y se ven compás a compás sus notas, los intervalos con el cantus y las faltas,
/// marcadas en el compás donde están. Se escucha (resaltando el compás que suena) y se exporta como partitura o
/// MIDI. Cada especie empieza con un ejemplo sin faltas.
struct VistaDeContrapunto: View {
    @Environment(\.notacion) private var notacion
    @State private var especie = Contrapunto.Especie.primera
    @State private var cantus: [Contrapunto.Especie: String] = Dictionary(
        uniqueKeysWithValues: Contrapunto.Especie.allCases.map { ($0, PresentacionDeContrapunto.ejemplo($0).cantus) })
    @State private var contrapunto: [Contrapunto.Especie: String] = Dictionary(
        uniqueKeysWithValues: Contrapunto.Especie.allCases.map {
            ($0, PresentacionDeContrapunto.ejemplo($0).contrapunto)
        })
    @State private var resultado: Result<ContrapuntoPresentado, Error>?
    /// Lo que está sonando, para resaltar el compás que se oye.
    @ObservedObject private var reproductor = Reproductor.compartido

    private var textoDelCantus: Binding<String> {
        Binding(get: { cantus[especie] ?? "" }, set: { cantus[especie] = $0 })
    }

    private var textoDelContrapunto: Binding<String> {
        Binding(get: { contrapunto[especie] ?? "" }, set: { contrapunto[especie] = $0 })
    }

    private var clave: String {
        "\(especie.rawValue)|\(cantus[especie] ?? "")|\(contrapunto[especie] ?? "")|\(notacion.clave)"
    }

    var body: some View {
        Form {
            Section {
                Picker(notacion.texto(\.especie), selection: $especie) {
                    ForEach(Contrapunto.Especie.allCases, id: \.self) { Text("\($0.rawValue)").tag($0) }
                }
                .pickerStyle(.segmented)
                TextField(
                    PresentacionDeContrapunto.indicacionDelCantus(en: notacion), text: textoDelCantus,
                    axis: .vertical
                )
                .comoCampoDeCifrado()
                TextField(
                    PresentacionDeContrapunto.indicacionDelContrapunto(en: notacion), text: textoDelContrapunto,
                    axis: .vertical
                )
                .comoCampoDeCifrado()
            }
            switch resultado {
            case .some(.success(let presentado)):
                contenido(presentado)
            case .some(.failure(let error)):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            case .none:
                EmptyView()
            }
        }
        .navigationTitle(notacion.texto(\.contrapunto))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .task(id: clave) {
            resultado = Result {
                try PresentacionDeContrapunto.presentar(
                    cantus: cantus[especie] ?? "", contrapunto: contrapunto[especie] ?? "", especie: especie,
                    en: notacion)
            }
        }
    }

    private var ficheros: [FicheroParaExportar] {
        (try? resultado?.get())?.ficheros ?? []
    }

    @ViewBuilder
    private func contenido(_ presentado: ContrapuntoPresentado) -> some View {
        Section(notacion.texto(\.conduccionDeLasVoces)) {
            Text(presentado.cabecera).font(.headline)
            ForEach(presentado.informe, id: \.self) { linea in
                Text(linea).foregroundColor(presentado.esCorrecto ? .secondary : .red)
            }
            BotonDeEscuchar(presentado.sonido)
        }
        let sonando = presentado.compas(enElPaso: reproductor.paso(de: presentado.sonido))
        Section {
            ForEach(presentado.filas, id: \.compas) { fila in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(fila.titulo).foregroundColor(.secondary)
                            .frame(minWidth: 90, alignment: .leading)
                        Text(fila.contrapunto).font(.system(.body, design: .monospaced))
                        Spacer()
                        Text(fila.intervalos).font(.system(.callout, design: .monospaced)).bold()
                    }
                    HStack(alignment: .firstTextBaseline) {
                        Text("").frame(minWidth: 90, alignment: .leading)
                        Text(fila.cantus).font(.system(.body, design: .monospaced)).foregroundColor(.secondary)
                    }
                    ForEach(fila.faltas, id: \.self) { falta in
                        Label(falta, systemImage: "exclamationmark.triangle").foregroundColor(.red).font(.callout)
                    }
                }
                .listRowBackground(sonando == fila.compas ? TemaDeLasApps.resaltado.opacity(0.25) : nil)
                .accessibilityElement(children: .combine)
            }
        }
    }
}
