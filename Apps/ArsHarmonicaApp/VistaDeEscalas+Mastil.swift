import Armonia
import SwiftUI
import TeselaUI

// Las secciones de la pestaña de escalas que van en el mástil: las posiciones, las formas de la pentatónica y la
// secuencia de estudio en cada posición.

/// La escala por posiciones en la guitarra, con el diagrama de cada una y «Escuchar», de la más baja a la más alta;
/// mientras suena una, la nota que se oye, resaltada.
struct SeccionDePosiciones: View {
    let escala: Escala
    let mastil: Mastil
    @Binding var caged: Bool
    @Binding var encordado: Encordado
    @Binding var capo: Int
    @Environment(\.notacion) private var notacion
    @ObservedObject private var reproductor = Reproductor.compartido

    var body: some View {
        let porCuerda = escala.notas.count >= 6 ? 3 : 2
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        Section(notacion.texto(\.posicionesEnElMastil)) {
            Picker(notacion.texto(\.posicionesEnElMastil), selection: $caged) {
                Text("CAGED").tag(true)
                Text(notacion.texto { $0.notasPorCuerda(porCuerda) }).tag(false)
            }
            .pickerStyle(.segmented)
            Picker(notacion.texto(\.instrumentoYAfinacion), selection: $encordado) {
                ForEach(Encordado.todos, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
            }
            Stepper(
                capo == 0 ? notacion.texto(\.sinCapo) : notacion.texto { $0.capo(capo) }, value: $capo, in: 0...12)
            ForEach(posiciones, id: \.self) { posicion in
                let sonido = PresentacionDeEstudioDeEscala.sonido(de: posicion, en: escala)
                let paso = reproductor.paso(de: sonido)
                let sonando = paso.flatMap { posicion.posiciones.indices.contains($0) ? posicion.posiciones[$0] : nil }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if let forma = posicion.forma {
                            Text(notacion.texto { $0.forma(forma.rawValue) }).bold()
                        }
                        Text(PresentacionDeEstudioDeEscala.trastes(de: posicion, notacion: notacion))
                            .foregroundColor(.secondary)
                        Spacer()
                        BotonDeEscuchar(sonido)
                    }
                    DiagramaDeMastil(posicion: posicion, escala: escala, notacion: notacion)
                        .resaltando(sonando)
                        .frame(maxHeight: 120)
                }
            }
        }
    }
}

/// Las cinco formas de una pentatónica en la guitarra, con las notas que cada una comparte con la siguiente.
struct SeccionDeFormasPentatonicas: View {
    let escala: Escala
    let mastil: Mastil
    @Environment(\.notacion) private var notacion

    var body: some View {
        let formas = PresentacionDeEstudioDeEscala.formasPentatonicas(de: escala, mastil: mastil, notacion: notacion)
        if !formas.isEmpty {
            Section(notacion.texto(\.formasDeLaPentatonica)) {
                ForEach(formas, id: \.self) { forma in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(forma.titulo).bold()
                            Spacer()
                            BotonDeEscuchar(forma.sonido)
                        }
                        DiagramaDeMastil(posicion: forma.posicion, escala: escala, notacion: notacion)
                            .frame(maxHeight: 120)
                        Text(forma.comunes).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

/// La secuencia elegida tocada en cada posición (CAGED o por cuerdas, como arriba), sin salir de ella, en tablatura.
struct SeccionDeLaSecuenciaEnLasPosiciones: View {
    let escala: Escala
    let secuencia: SecuenciaDeEscala
    let bajando: Bool
    let caged: Bool
    let mastil: Mastil
    @Environment(\.notacion) private var notacion

    var body: some View {
        let posiciones = PresentacionDeEstudioDeEscala.secuenciaEnLasPosiciones(
            escala, secuencia, caged: caged, sentido: bajando ? .descendente : .ascendente, mastil: mastil,
            notacion: notacion
        ).filter { !$0.notas.isEmpty }
        if !posiciones.isEmpty {
            Section(notacion.texto(\.secuenciaEnLasPosiciones)) {
                ForEach(posiciones, id: \.self) { posicion in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(posicion.titulo).bold()
                            Spacer()
                            BotonDeEscuchar(posicion.sonido)
                        }
                        ScrollView(.horizontal) {
                            Text(posicion.tablatura.joined(separator: "\n"))
                                .font(.system(.caption2, design: .monospaced))
                                .fixedSize()
                        }
                    }
                }
            }
        }
    }
}
