import Armonia
import ArmoniaUI
import SwiftUI

/// Elige una tónica y una escala del catálogo (occidentales y de otras tradiciones) y muestra sus notas,
/// sus acordes, dónde caen en el mástil y cómo se tocan por posiciones (CAGED o tres notas por cuerda).
struct VistaDeEscalas: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    @State private var tonica = 0 // índice en `tonicas`
    @State private var tipo = 0 // índice en `catalogo`
    /// Las posiciones en el mástil: las del sistema CAGED o las de tres (o dos) notas por cuerda.
    @State private var caged = true

    /// Las escalas habituales y, después, las de otras tradiciones. Se elige por índice porque dos
    /// escalas con las mismas notas son iguales (`==`) aunque se llamen distinto.
    private static let catalogo = TipoDeEscala.todos + TipoDeEscala.tradicionales

    /// Las doce tónicas, de Do a Si, con la grafía habitual de una tonalidad: Re♭, Mi♭, La♭ y Si♭ con
    /// bemoles y Fa♯ con sostenido. (`Altura(midi:)` daría Do♯, Re♯, Sol♯ y La♯, con dobles sostenidos
    /// en la escala.) Se indican por su posición en la línea de quintas.
    private static let tonicas: [Nota] = [0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5].map { Nota(pasosDeQuinta: $0) }

    private var escala: Escala {
        let nota = VistaDeEscalas.tonicas[min(tonica, VistaDeEscalas.tonicas.count - 1)]
        return Escala(nota, VistaDeEscalas.catalogo[min(tipo, VistaDeEscalas.catalogo.count - 1)])
    }

    var body: some View {
        let escala = self.escala
        let pentagrama = PresentacionDePentagrama(escala, notacion: notacion)
        Form {
            Section(notacion.texto(.escala)) {
                Picker(notacion.texto(.tonica), selection: $tonica) {
                    ForEach(VistaDeEscalas.tonicas.indices, id: \.self) {
                        Text(VistaDeEscalas.tonicas[$0].nombre(en: notacion)).tag($0)
                    }
                }
                Picker(notacion.texto(.tipo), selection: $tipo) {
                    Section(notacion.texto(.habituales)) {
                        ForEach(0..<TipoDeEscala.todos.count, id: \.self) { Text(nombre($0)).tag($0) }
                    }
                    Section(notacion.texto(.otrasTradiciones)) {
                        ForEach(TipoDeEscala.todos.count..<VistaDeEscalas.catalogo.count, id: \.self) {
                            Text(nombre($0)).tag($0)
                        }
                    }
                }
            }
            Section(notacion.texto(.notas)) {
                Text(escala.nombre(en: notacion)).font(.headline)
                Text(escala.notas.map { $0.nombre(en: notacion) }.joined(separator: "  "))
                    .font(.system(.body, design: .monospaced))
                BotonDeEscuchar(.escala(escala))
            }
            let acordes = escala.armonizar().compactMap { $0 }
            if !acordes.isEmpty {
                Section(notacion.texto(.acordesDeLaEscala)) {
                    Text(acordes.map { $0.cifrado(en: notacion) }.joined(separator: "   "))
                }
            }
            Section(notacion.texto(.pentagrama)) {
                DiagramaDePentagrama(pentagrama)
            }
            Section(notacion.texto(.mastilDeGuitarra)) {
                DiagramaDeMastil(mastil: Mastil(.guitarra, trastes: 12), escala: escala, notacion: notacion)
            }
            posiciones(de: escala)
        }
        .navigationTitle(notacion.texto(.escalas))
        .selectorDeNotacionEnLaBarra()
        // Una escala pedida desde otra pestaña (las compatibles con un acorde), ahora o si se pidió antes de abrir esta.
        .onChange(of: navegacion.escalaPedida) { _ in tomarLaEscalaPedida() }
        .onAppear(perform: tomarLaEscalaPedida)
        .toolbar {
            ToolbarItem {
                BotonDeExportar([pentagrama.fichero])
            }
        }
    }

    /// Elige la tónica y el tipo de la escala pedida: el tipo con el mismo nombre o, si no, el primero con las
    /// mismas notas.
    private func tomarLaEscalaPedida() {
        guard let pedida = navegacion.escalaPedida else { return }
        navegacion.escalaPedida = nil
        if let indice = VistaDeEscalas.tonicas.firstIndex(where: { $0.claseDeAltura == pedida.tonica.claseDeAltura }) {
            tonica = indice
        }
        let nombre = pedida.tipo.nombre(en: .espanolUnicode)
        if let indice = VistaDeEscalas.catalogo.firstIndex(where: { $0.nombre(en: .espanolUnicode) == nombre })
            ?? VistaDeEscalas.catalogo.firstIndex(of: pedida.tipo)
        {
            tipo = indice
        }
    }

    /// La escala por posiciones en la guitarra, con el diagrama de cada una y «Escuchar», de la más baja a la
    /// más alta.
    @ViewBuilder
    private func posiciones(de escala: Escala) -> some View {
        let mastil = Mastil(.guitarra, trastes: 15)
        let porCuerda = escala.notas.count >= 6 ? 3 : 2
        let posiciones = caged ? mastil.posicionesCAGED(de: escala) : mastil.posicionesPorCuerda(de: escala)
        Section(notacion.texto(.posicionesEnElMastil)) {
            Picker(notacion.texto(.posicionesEnElMastil), selection: $caged) {
                Text("CAGED").tag(true)
                Text(notacion.texto(.notasPorCuerda(porCuerda))).tag(false)
            }
            .pickerStyle(.segmented)
            ForEach(posiciones, id: \.self) { posicion in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if let forma = posicion.forma {
                            Text(notacion.texto(.forma(forma.rawValue))).bold()
                        }
                        Text(rotulo(de: posicion)).foregroundColor(.secondary)
                        Spacer()
                        BotonDeEscuchar(sonido(de: posicion, en: escala))
                    }
                    DiagramaDeMastil(posicion: posicion, escala: escala, notacion: notacion)
                        .frame(maxHeight: 120)
                }
            }
        }
    }

    /// Los trastes que abarca una posición: «Trastes 2–6».
    private func rotulo(de posicion: EscalaEnElMastil) -> String {
        notacion.texto(.trastes(desde: posicion.trastes.lowerBound, hasta: posicion.trastes.upperBound))
    }

    /// Una posición nota a nota, cuerda a cuerda, como se estudia.
    private func sonido(de posicion: EscalaEnElMastil, en escala: Escala) -> Sonido {
        Sonido.voz(Voz(posicion.alturas.map { Evento($0, .corchea) })).conTonica(escala.tonica)
    }

    private func nombre(_ indice: Int) -> String {
        VistaDeEscalas.catalogo[indice].nombre(en: notacion)
    }
}
