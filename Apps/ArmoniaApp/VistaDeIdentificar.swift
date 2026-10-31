import Armonia
import ArmoniaUI
import SwiftUI

/// Toca notas en el mástil, una por cuerda como al tocar, o en un teclado MIDI conectado, y muestra qué acorde
/// forman (el bajo es la más grave) y cómo es el conjunto en teoría postonal. En el mástil, tocar otra vez una nota
/// la quita y las cuerdas que no se tocan se marcan apagadas; del teclado se queda el último acorde pulsado.
struct VistaDeIdentificar: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    @ObservedObject private var entradaMIDI = EntradaMIDI.compartida
    @State private var encordado = Encordado.guitarra
    /// El traste tocado en cada cuerda (la 0 es la grave). Las cuerdas que no están no suenan.
    @State private var trastes: [Int: Int] = [:]
    /// El último acorde tocado en el teclado MIDI. Mientras tenga notas, manda sobre el mástil.
    @State private var notasMIDI: [Int] = []
    /// Las teclas pulsadas la última vez que cambiaron, para saber si se empieza otro acorde.
    @State private var pulsadasAntes: [Int] = []

    private var mastil: Mastil { Mastil(encordado, trastes: 12) }

    private var posiciones: [PosicionEnElMastil] {
        trastes.map { PosicionEnElMastil(cuerda: $0.key, traste: $0.value) }.sorted()
    }

    /// Lo que suena, de la más grave a la más aguda: lo del teclado MIDI o, si no hay, lo del mástil.
    private var alturas: [Altura] {
        notasMIDI.isEmpty
            ? posiciones.map { mastil.altura(en: $0) }.sorted() : notasMIDI.sorted().map { Altura(midi: $0) }
    }

    var body: some View {
        let alturas = self.alturas
        // Con alturas sin ortografía (las de un mástil o un teclado), la primera, la más grave, es el bajo.
        let acordes = Acorde.candidatos(clasesDeAltura: alturas.map(\.midi)).map(\.valor)
        Form {
            Section(notacion.texto(.identificar)) {
                Picker(notacion.texto(.instrumentoYAfinacion), selection: $encordado) {
                    ForEach(Encordado.todos, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
                }
                Text(notacion.texto(.tocaElMastil))
                    .foregroundColor(.secondary)
                DiagramaDeMastil(
                    mastil: mastil, marcas: posiciones, rango: 0...12,
                    apagadas: Set(0..<encordado.numeroDeCuerdas).subtracting(trastes.keys),
                    ortografia: ortografia(de: acordes.first), notacion: notacion
                )
                .alTocar(tocar)
                Button(notacion.texto(.borrar)) { borrar() }
                    .disabled(trastes.isEmpty && notasMIDI.isEmpty)
            }
            if !alturas.isEmpty {
                Section(notacion.texto(.resultado)) {
                    if alturas.count >= 2 && acordes.isEmpty {
                        Text(notacion.texto(.sinAcordeConocido)).foregroundColor(.secondary)
                    }
                    ForEach(Array(acordes.prefix(4).enumerated()), id: \.offset) { indice, acorde in
                        HStack {
                            Text(acorde.cifrado(en: notacion))
                                .font(.system(.body, design: .monospaced))
                                .bold(indice == 0)
                            Spacer()
                            Text(acorde.nombre(en: notacion)).foregroundColor(.secondary)
                        }
                    }
                    LabeledContent(
                        notacion.texto(.notas),
                        value: alturas.map { $0.nombre(en: notacion) }.joined(separator: " "))
                    BotonDeEscuchar(.coral([alturas], duracion: 1.5))
                    if let primero = acordes.first {
                        // Sus digitaciones, su arpegio y sus escalas.
                        Button(notacion.texto(.verEnAcordes)) { navegacion.ver(primero) }
                    }
                }
                postonal(alturas)
            }
            Section(notacion.texto(.tecladoMIDI)) {
                LabeledContent(notacion.texto(.dispositivosMIDI), value: "\(entradaMIDI.dispositivos)")
            }
        }
        .navigationTitle(notacion.texto(.identificar))
        .selectorDeNotacionEnLaBarra()
        .onAppear { entradaMIDI.empezar() }
        // Otro instrumento tiene otras cuerdas: lo tocado deja de valer.
        .onChange(of: encordado) { _ in trastes = [:] }
        .onChange(of: entradaMIDI.pulsadas) { ahora in
            let retenidas = CambioMIDI.retener(notasMIDI, antes: pulsadasAntes, ahora: ahora)
            pulsadasAntes = ahora
            if retenidas != notasMIDI {
                notasMIDI = retenidas
                trastes = [:]
            }
        }
    }

    /// La forma prima, el número de Forte y el vector interválico de lo que suena.
    @ViewBuilder
    private func postonal(_ alturas: [Altura]) -> some View {
        let postonal = AnalisisPostonalPresentado(clases: alturas.map(\.midi))
        Section(notacion.texto(.teoriaPostonal)) {
            LabeledContent(notacion.texto(.formaPrima), value: postonal.formaPrima)
            if let forte = postonal.numeroDeForte {
                LabeledContent(notacion.texto(.numeroDeForte), value: forte)
            }
            LabeledContent(notacion.texto(.vectorIntervalico), value: postonal.vectorIntervalico)
        }
    }

    /// Pone la nota en su cuerda (en lugar de la que hubiera) y la hace sonar, o la quita si ya estaba. Tocar el
    /// mástil deja de mostrar lo del teclado MIDI.
    private func tocar(_ posicion: PosicionEnElMastil) {
        notasMIDI = []
        if trastes[posicion.cuerda] == posicion.traste {
            trastes[posicion.cuerda] = nil
        } else {
            trastes[posicion.cuerda] = posicion.traste
            Reproductor.compartido.tocar(.nota(mastil.altura(en: posicion)))
        }
    }

    private func borrar() {
        trastes = [:]
        notasMIDI = []
    }

    /// Las notas escritas como en el acorde identificado (Si♭ en Do7, no La♯).
    private func ortografia(de acorde: Acorde?) -> [Int: Nota] {
        Dictionary((acorde?.notas ?? []).map { ($0.claseDeAltura, $0) }, uniquingKeysWith: { primera, _ in primera })
    }
}
