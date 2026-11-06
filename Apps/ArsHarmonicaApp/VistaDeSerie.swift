import Armonia
import SwiftUI
import TeselaUI

/// Una serie dodecafónica: se escribe con cifras («5 4 0 9 7 2 8 1 3 6 t e») o con nombres de notas, y se ven sus
/// intervalos, sus hexacordos, sus formas combinatorias y la matriz de 12 × 12, con las P a la izquierda, las R a la
/// derecha, las I arriba y las RI abajo. Tocar el nombre de una fila o de una columna elige esa forma, que se resalta
/// en la matriz, se ve en el pentagrama, se escucha y se exporta. Se abre desde Identificar.
struct VistaDeSerie: View {
    @Environment(\.notacion) private var notacion
    @State private var texto = PresentacionDeSerie.ejemplo
    @State private var tipo = TipoDeFormaDeSerie.original
    /// La clase con que empieza la P o la I elegida; `nil`, la de la serie escrita (su P de la primera fila).
    @State private var indice: Int?
    @State private var resultado: Result<SeriePresentada, Error>?

    private var clave: String { "\(texto)|\(tipo.rawValue)|\(indice.map(String.init) ?? "")|\(notacion.clave)" }

    var body: some View {
        Form {
            Section {
                TextField(PresentacionDeSerie.indicacion(en: notacion), text: $texto, axis: .vertical)
                    .comoCampoDeCifrado()
                    .accessibilityIdentifier("serie")
            }
            switch resultado {
            case .some(.success(let presentada)):
                contenido(presentada)
            case .some(.failure(let error)):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            case .none:
                EmptyView()
            }
        }
        .navigationTitle(notacion.texto(\.serieDodecafonica))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        // Otra serie empieza otra vez en su P de la primera fila.
        .onChange(of: texto) { _ in indice = nil }
        .task(id: clave) {
            let primera = (try? SerieDodecafonica(leyendo: texto))?.clases.first ?? 0
            let forma = FormaDeSerie(tipo, indice ?? primera)
            resultado = Result { try PresentacionDeSerie.presentar(texto, forma: forma, en: notacion) }
        }
    }

    private var ficheros: [FicheroParaExportar] {
        (try? resultado?.get())?.ficheros ?? []
    }

    @ViewBuilder
    private func contenido(_ presentada: SeriePresentada) -> some View {
        Section(notacion.texto(\.serieDodecafonica)) {
            ForEach(presentada.datos, id: \.titulo) { dato in
                LabeledContent(dato.titulo, value: dato.valor)
            }
            Text(presentada.formasDistintas).foregroundColor(.secondary)
        }
        Section(notacion.texto(\.formaDeSerie)) {
            Picker(notacion.texto(\.formaDeSerie), selection: $tipo) {
                ForEach(TipoDeFormaDeSerie.allCases, id: \.self) { Text($0.simbolo).tag($0) }
            }
            .pickerStyle(.segmented)
            HStack(alignment: .firstTextBaseline) {
                Text(presentada.forma.description).font(.system(.body, design: .monospaced)).bold()
                Text(presentada.notasDeLaForma)
            }
            .accessibilityElement(children: .combine)
            DiagramaDePentagrama(presentada.pentagrama)
            BotonDeEscuchar(presentada.sonido)
        }
        Section(notacion.texto(\.matriz)) {
            ScrollView(.horizontal) {
                matriz(presentada)
            }
        }
    }

    /// La matriz con el nombre de las formas alrededor. Los nombres son botones que eligen esa forma.
    private func matriz(_ presentada: SeriePresentada) -> some View {
        Grid(horizontalSpacing: 2, verticalSpacing: 2) {
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ForEach(presentada.formasDeLasColumnas, id: \.self) { forma in
                    nombre(forma, elegida: presentada.forma)
                }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
            ForEach(presentada.matriz.indices, id: \.self) { fila in
                GridRow {
                    nombre(presentada.formasDeLasFilas[fila], elegida: presentada.forma)
                        .accessibilityValue(Text(presentada.descripcion(deLaFila: fila)))
                    ForEach(presentada.matriz[fila].indices, id: \.self) { columna in
                        Text(SeriePresentada.cifra(presentada.matriz[fila][columna]))
                            .font(.system(.body, design: .monospaced))
                            .frame(minWidth: 26, minHeight: 26)
                            .background(
                                presentada.estaEnLaForma(fila: fila, columna: columna)
                                    ? TemaDeLasApps.resaltado.opacity(0.3) : Color.clear
                            )
                            .accessibilityHidden(true)
                    }
                    nombre(
                        FormaDeSerie(.retrogrado, presentada.formasDeLasFilas[fila].indice),
                        elegida: presentada.forma)
                }
            }
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ForEach(presentada.formasDeLasColumnas, id: \.self) { forma in
                    nombre(FormaDeSerie(.retrogradoDeLaInversion, forma.indice), elegida: presentada.forma)
                }
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            }
        }
        .padding(.vertical, 4)
    }

    /// El nombre de una forma («P5», «RI3»), en negrita si es la elegida; tocarlo la elige.
    private func nombre(_ forma: FormaDeSerie, elegida: FormaDeSerie) -> some View {
        Button {
            tipo = forma.tipo
            indice = forma.indice
        } label: {
            Text(forma.description)
                .font(.system(.caption, design: .monospaced))
                .bold(forma == elegida)
                .foregroundColor(forma == elegida ? .primary : .secondary)
                .frame(minWidth: 30, minHeight: 26)
        }
        .buttonStyle(.plain)
    }
}
