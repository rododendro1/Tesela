import SwiftUI
import Armonia
import ArmoniaUI

/// Toca notas en el mástil, una por cuerda como al tocar, y muestra qué acorde forman: el bajo es la más grave.
/// Tocar otra vez una nota la quita; las cuerdas que no se tocan se marcan apagadas.
struct VistaDeIdentificar: View {
    @Environment(\.notacion) private var notacion
    @State private var encordado = Encordado.guitarra
    /// El traste tocado en cada cuerda (la 0 es la grave). Las cuerdas que no están no suenan.
    @State private var trastes: [Int: Int] = [:]

    private var mastil: Mastil { Mastil(encordado, trastes: 12) }

    private var posiciones: [PosicionEnElMastil] {
        trastes.map { PosicionEnElMastil(cuerda: $0.key, traste: $0.value) }.sorted()
    }

    var body: some View {
        let alturas = posiciones.map { mastil.altura(en: $0) }.sorted()
        // Con alturas sin ortografía (las de un mástil), la primera, la más grave, es el bajo.
        let acordes = Acorde.candidatos(clasesDeAltura: alturas.map(\.midi)).map(\.valor)
        Form {
            Section(notacion.texto(.identificar)) {
                Picker(notacion.texto(.instrumentoYAfinacion), selection: $encordado) {
                    ForEach(Encordado.todos, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
                }
                Text(notacion.texto(.tocaElMastil))
                    .foregroundColor(.secondary)
                DiagramaDeMastil(mastil: mastil, marcas: posiciones, rango: 0...12,
                                 apagadas: Set(0..<encordado.numeroDeCuerdas).subtracting(trastes.keys),
                                 ortografia: ortografia(de: acordes.first), notacion: notacion)
                    .alTocar(tocar)
                Button(notacion.texto(.borrar)) { trastes = [:] }
                    .disabled(trastes.isEmpty)
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
                    LabeledContent(notacion.texto(.notas),
                                   value: alturas.map { $0.nombre(en: notacion) }.joined(separator: " "))
                    BotonDeEscuchar(.coral([alturas], duracion: 1.5))
                }
            }
        }
        .navigationTitle(notacion.texto(.identificar))
        .selectorDeNotacionEnLaBarra()
        // Otro instrumento tiene otras cuerdas: lo tocado deja de valer.
        .onChange(of: encordado) { _ in trastes = [:] }
    }

    /// Pone la nota en su cuerda (en lugar de la que hubiera) y la hace sonar, o la quita si ya estaba.
    private func tocar(_ posicion: PosicionEnElMastil) {
        if trastes[posicion.cuerda] == posicion.traste {
            trastes[posicion.cuerda] = nil
        } else {
            trastes[posicion.cuerda] = posicion.traste
            Reproductor.compartido.tocar(.nota(mastil.altura(en: posicion)))
        }
    }

    /// Las notas escritas como en el acorde identificado (Si♭ en Do7, no La♯).
    private func ortografia(de acorde: Acorde?) -> [Int: Nota] {
        Dictionary((acorde?.notas ?? []).map { ($0.claseDeAltura, $0) }, uniquingKeysWith: { primera, _ in primera })
    }
}
