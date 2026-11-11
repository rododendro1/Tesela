import Armonia
import Interfaz
import SwiftUI

/// Los catálogos con nombre: las progresiones, los acordes con nombre y los ritmos. Se buscan por su nombre en
/// cualquier idioma; cada ficha dice lo que es, sus estilos y sus fuentes, se escucha y, si es una progresión o un
/// acorde, se abre en Análisis o en Acordes.
struct VistaDelCatalogo: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    /// Lo elegido y lo que sale de ello, que se prueba sin la vista.
    @State private var modelo = ModeloDelCatalogo()

    var body: some View {
        Form {
            Section {
                Picker(notacion.texto(\.catalogo), selection: $modelo.lista) {
                    ForEach(ModeloDelCatalogo.Lista.allCases) { Text($0.titulo(en: notacion)).tag($0) }
                }
                .pickerStyle(.segmented)
                TextField(notacion.texto(\.buscarEnElCatalogo), text: $modelo.texto)
                    .autocorrectionDisabled()
                if modelo.lista != .ritmos {
                    Picker(notacion.texto(\.tonica), selection: $modelo.tonica) {
                        ForEach(EleccionDeEscala.tonicas, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                    }
                }
            }
            let fichas = modelo.fichas(en: notacion)
            Section(modelo.lista.titulo(en: notacion)) {
                if fichas.isEmpty {
                    Text(notacion.texto(\.sinResultados)).foregroundColor(.secondary)
                }
                ForEach(fichas) { fila($0) }
            }
        }
        .navigationTitle(notacion.texto(\.catalogo))
        .selectorDeNotacionEnLaBarra()
    }

    private func fila(_ ficha: ModeloDelCatalogo.Ficha) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ficha.nombre).font(.headline)
            Text(ficha.detalle).font(.system(.callout, design: .monospaced))
            if !ficha.estilos.isEmpty {
                Text(ficha.estilos).font(.caption).foregroundColor(.secondary)
            }
            if !ficha.fuentes.isEmpty {
                Text(notacion.texto(\.fuentes) + ": " + ficha.fuentes.joined(separator: "; "))
                    .font(.caption).foregroundColor(.secondary)
            }
            HStack {
                BotonDeEscuchar(ficha.sonido)
                Spacer()
                switch ficha.destino {
                case .analisis(let progresion):
                    Button(notacion.texto(\.verEnAnalisis)) { navegacion.ver(progresion: progresion) }
                case .acordes(let acorde):
                    Button(notacion.texto(\.verEnAcordes)) { navegacion.ver(acorde) }
                case nil:
                    EmptyView()
                }
            }
            .buttonStyle(.borderless)
        }
        .accessibilityElement(children: .contain)
        .padding(.vertical, 2)
    }
}
