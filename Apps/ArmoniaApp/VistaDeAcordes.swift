import Armonia
import ArmoniaUI
import SwiftUI

/// Escribe un cifrado (Sol7/Si, Dom, Fa#m7b5…) y muestra el acorde, su arpegio, las escalas que encajan con él,
/// sus digitaciones y el arpegio en el mástil.
struct VistaDeAcordes: View {
    @Environment(\.notacion) private var notacion
    @EnvironmentObject private var navegacion: Navegacion
    @State private var texto = "Sol7/Si"
    /// El acorde leído de `texto`. Se lee una vez por cambio del texto, no en cada redibujado.
    @State private var lectura = VistaDeAcordes.leer("Sol7/Si")
    @State private var encordado = Encordado.guitarra
    @State private var patron = Arpegio.Patron.ascendente
    @State private var octavas = 1
    @State private var conOctava = true
    @State private var figura = Figura.corchea
    /// El traste del capo en las digitaciones y el arpegio en el mástil, o 0 sin capo.
    @State private var capo = 0
    /// Lo que está sonando, para resaltar la nota en el pentagrama y en el mástil.
    @ObservedObject private var reproductor = Reproductor.compartido
    /// Las digitaciones y para qué texto e instrumento se calcularon. Mientras no coincidan con lo que hay
    /// escrito, se muestra «Calculando…» y no las de otro acorde.
    @State private var digitaciones: Calculado<[Digitacion]>?

    private var claveActual: String { "\(texto)|\(encordado.nombre)|\(capo)" }

    /// Las figuras que se ofrecen para las notas del arpegio.
    private static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// El mástil del instrumento elegido, con el capo si lo lleva.
    private func mastil(trastes: Int) -> Mastil {
        Mastil(encordado.conCapo(capo), trastes: trastes)
    }

    private func arpegio(de acorde: Acorde) -> Arpegio {
        Arpegio(acorde, patron: patron, octavas: octavas, conOctava: conOctava)
    }

    var body: some View {
        Form {
            Section(notacion.texto(\.acorde)) {
                TextField(notacion.campo(.cifrado), text: $texto)
                    .comoCampoDeCifrado()
            }
            switch lectura {
            case .success(let acorde):
                informacion(de: acorde)
                Section(notacion.texto(\.pentagrama)) {
                    DiagramaDePentagrama(PentagramaPresentado(acorde, notacion: notacion))
                }
                seccionDelArpegio(de: acorde)
                escalas(de: acorde)
                digitaciones(de: acorde)
                arpegioEnElMastil(de: acorde)
            case .failure(let error):
                Section {
                    Text(notacion.mensaje(de: error)).foregroundColor(.red)
                }
            }
        }
        .navigationTitle(notacion.texto(\.acordes))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .onChange(of: texto) { lectura = Self.leer($0) }
        // Un acorde pedido desde otra pestaña («Ver en Acordes»), ahora o si se pidió antes de abrir esta.
        .onChange(of: navegacion.acordePedido) { _ in tomarElAcordePedido() }
        .onAppear(perform: tomarElAcordePedido)
        // La búsqueda de digitaciones puede tardar: se hace fuera del hilo principal cuando se deja de escribir.
        .calcularEnSegundoPlano(para: claveActual, en: $digitaciones) {
            [texto = self.texto, mastil = self.mastil(trastes: 15)] in
            guard let acorde = try? Acorde(leyendo: texto) else { return [] }
            // La quinta puede faltar en los acordes de cuatro notas o más (el Do7 `x32310`), como se toca.
            return mastil.digitaciones(de: acorde, exigirQuinta: false, limite: 6)
        }
    }

    /// Los pentagramas del acorde leído y de su arpegio como SVG, el arpegio en MusicXML, MEI y MIDI, y las
    /// digitaciones y el arpegio en el mástil como tablaturas MusicXML; o nada si el texto no se lee.
    private var ficheros: [FicheroParaExportar] {
        guard case .success(let acorde) = lectura else { return [] }
        let arpegio = self.arpegio(de: acorde)
        var ficheros = [
            PentagramaPresentado(acorde, notacion: notacion).fichero,
            PentagramaPresentado(arpegio, notacion: notacion).fichero,
        ]
        ficheros += PresentacionDeArpegios.arpegio(arpegio, figura: figura.duracion, notacion: notacion).ficheros
        let cifrado = acorde.cifrado(en: notacion)
        if let formas = digitaciones?.valor(para: claveActual), !formas.isEmpty {
            let titulo = "Tablatura " + cifrado
            let xml = PresentacionDeTablatura.musicXML(
                digitaciones: formas, acordes: formas.map { _ in acorde }, titulo: titulo, notacion: notacion)
            ficheros.append(.musicXML(xml, nombre: titulo))
        }
        if let posicion = self.mastil(trastes: 12).arpegios(de: acorde).first {
            let titulo = "Tablatura del arpegio " + cifrado
            let xml = PresentacionDeTablatura.musicXML(
                arpegio: posicion, acorde: acorde, figura: figura, titulo: titulo, notacion: notacion)
            ficheros.append(.musicXML(xml, nombre: titulo))
        }
        return ficheros
    }

    /// El arpegio en el patrón, las octavas y la figura elegidos: su pentagrama, nota a nota, y cómo suena. Mientras
    /// suena, la nota que se oye se resalta en el pentagrama.
    @ViewBuilder
    private func seccionDelArpegio(de acorde: Acorde) -> some View {
        let arpegio = self.arpegio(de: acorde)
        let sonido = PresentacionDeArpegios.arpegio(arpegio, figura: figura.duracion, notacion: notacion).sonido
        Section(notacion.texto(\.arpegio)) {
            Picker(notacion.texto(\.patron), selection: $patron) {
                ForEach(Arpegio.Patron.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            Stepper("\(notacion.texto(\.octavas)): \(octavas)", value: $octavas, in: 1...3)
            Toggle(notacion.texto(\.conLaOctavaFinal), isOn: $conOctava)
            Picker(notacion.texto(\.figura), selection: $figura) {
                ForEach(Self.figuras, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            DiagramaDePentagrama(
                PentagramaPresentado(arpegio, notacion: notacion, resaltada: reproductor.paso(de: sonido)))
            BotonDeEscuchar(sonido)
        }
    }

    /// Las escalas sobre la fundamental que contienen el acorde (Sol7 → Sol mixolidio…), de las de menos notas
    /// a las de más.
    @ViewBuilder
    private func escalas(de acorde: Acorde) -> some View {
        let escalas = acorde.escalasCompatibles()
        if !escalas.isEmpty {
            Section(notacion.texto(\.escalasCompatibles)) {
                // Cada una se abre en la pestaña de escalas.
                ForEach(Array(escalas.prefix(10).enumerated()), id: \.offset) { _, escala in
                    Button(escala.nombre(en: notacion)) { navegacion.ver(escala) }
                }
            }
        }
    }

    @ViewBuilder
    private func informacion(de acorde: Acorde) -> some View {
        Section(notacion.texto(\.informacion)) {
            LabeledContent(notacion.texto(\.nombre), value: acorde.nombre(en: notacion))
            LabeledContent(notacion.texto(\.cifrado), value: acorde.cifrado(en: notacion))
            LabeledContent(
                notacion.texto(\.notas),
                value: acorde.notasDesdeElBajo.map { $0.nombre(en: notacion) }.joined(separator: " "))
            BotonDeEscuchar(.acorde(acorde))
        }
    }

    @ViewBuilder
    private func digitaciones(de acorde: Acorde) -> some View {
        Section(notacion.texto(\.digitaciones)) {
            Picker(notacion.texto(\.instrumentoYAfinacion), selection: $encordado) {
                ForEach(Encordado.todos, id: \.self) { Text($0.titulo(en: notacion)).tag($0) }
            }
            // Los trastes se cuentan desde el capo, como los cuenta quien toca.
            Stepper(notacion.texto { $0.capoEnElTraste(capo) }, value: $capo, in: 0...9)
            if let formas = digitaciones?.valor(para: claveActual) {
                if formas.isEmpty {
                    Text(notacion.texto(\.sinDigitaciones))
                        .foregroundColor(.secondary)
                }
                ForEach(formas, id: \.tablatura) { forma in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(forma.tablatura).font(.system(.body, design: .monospaced))
                            Text(notacion.texto { $0.dedosYCejilla(forma.dedos, forma.cejilla) })
                                .font(.caption).foregroundColor(.secondary)
                        }
                        DiagramaDeMastil(digitacion: forma, acorde: acorde, notacion: notacion)
                            .frame(maxHeight: 120)
                    }
                }
            } else {
                FilaCalculando()
            }
        }
    }

    /// El arpegio en el mástil del instrumento elegido en las digitaciones: las notas del acorde por todo el
    /// mástil y, debajo, cada posición en que la mano lo toca sin moverse, de la más baja a la más alta.
    @ViewBuilder
    private func arpegioEnElMastil(de acorde: Acorde) -> some View {
        let mastil = self.mastil(trastes: 12)
        let instrumento = encordado.titulo(en: notacion) + (capo > 0 ? " · " + notacion.texto { $0.capo(capo) } : "")
        Section(notacion.texto(\.arpegioEnElMastil)) {
            Text(instrumento)
                .foregroundColor(.secondary)
            DiagramaDeMastil(mastil: mastil, acorde: acorde, notacion: notacion)
            ForEach(mastil.arpegios(de: acorde), id: \.trastes) { posicion in
                // De grave a agudo, en corcheas, como se toca al subir; mientras suena, se resalta la nota.
                let voz = Voz(posicion.alturas.map { Evento($0, .corchea) })
                let sonido = Escucha.voz(voz).conTonica(acorde.fundamental)
                let paso = reproductor.paso(de: sonido)
                let sonando = paso.flatMap { posicion.posiciones.indices.contains($0) ? posicion.posiciones[$0] : nil }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(
                            notacion.texto(
                                .trastes(
                                    desde: posicion.trastes.lowerBound,
                                    hasta: posicion.trastes.upperBound)))
                        Spacer()
                        BotonDeEscuchar(sonido)
                    }
                    DiagramaDeMastil(arpegio: posicion, acorde: acorde, notacion: notacion)
                        .resaltando(sonando)
                        .frame(maxHeight: 120)
                }
            }
        }
    }

    private func tomarElAcordePedido() {
        guard let acorde = navegacion.acordePedido else { return }
        navegacion.acordePedido = nil
        texto = acorde.cifrado(en: notacion)
    }

    private static func leer(_ texto: String) -> Result<Acorde, Error> {
        Result { try Acorde(leyendo: texto) }
    }
}
