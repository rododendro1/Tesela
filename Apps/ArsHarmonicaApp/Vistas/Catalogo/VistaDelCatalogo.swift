import Armonia
import InterfazArmonia
import SwiftUI

/// Los catálogos con nombre: las progresiones, los acordes con nombre, los ritmos, los ornamentos y los
/// instrumentos. Se buscan por su nombre en cualquier idioma; cada tarjeta dice lo que es, sus estilos y sus fuentes,
/// se escucha, se exporta en una hoja de estudio (salvo los ornamentos) y, si es una progresión o un acorde, se abre
/// en Análisis o en Acordes.
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
                if modelo.lista.usaLaTonica {
                    Picker(notacion.texto(\.tonica), selection: $modelo.tonica) {
                        ForEach(EleccionDeEscala.tonicas, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                    }
                }
            }
            let tarjetas = modelo.tarjetas(en: notacion)
            Section(modelo.lista.titulo(en: notacion)) {
                if tarjetas.isEmpty {
                    Text(notacion.texto(\.sinResultados)).foregroundColor(.secondary)
                }
                ForEach(tarjetas) { fila($0) }
            }
        }
        .navigationTitle(notacion.texto(\.catalogo))
        .selectorDeNotacionEnLaBarra()
    }

    private func fila(_ tarjeta: ModeloDelCatalogo.Tarjeta) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(tarjeta.nombre).font(.headline)
            Text(tarjeta.detalle).font(.system(.callout, design: .monospaced))
            if !tarjeta.estilos.isEmpty {
                Text(tarjeta.estilos).font(.caption).foregroundColor(.secondary)
            }
            if !tarjeta.referencias.isEmpty {
                Text(notacion.texto(\.fuentes) + ": " + tarjeta.referencias.joined(separator: "; "))
                    .font(.caption).foregroundColor(.secondary)
            }
            HStack {
                BotonDeEscuchar(tarjeta.sonido)
                // La hoja de estudio de la tarjeta, en SVG, HTML y PDF: se hace al aparecer la fila, no antes.
                if modelo.lista != .ornamentos {
                    let modelo = self.modelo
                    let notacion = self.notacion
                    let clave = "\(modelo.lista)|\(tarjeta.id)|\(modelo.tonica.claseDeAltura)|\(notacion.clave)"
                    BotonDeExportar(id: clave) {
                        modelo.ficheros(deLaTarjeta: tarjeta.id, en: notacion)
                    }
                    .labelStyle(.iconOnly)
                }
                Spacer()
                switch tarjeta.destino {
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
