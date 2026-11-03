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
    /// La nota del acorde por la que empieza el arpegio, desde el bajo (``Arpegio/inicio``).
    @State private var inicio = 0
    @State private var tensiones: [Int] = []
    /// Un recorrido propio por grados («1 5 3 8»); si se lee, manda sobre el patrón.
    @State private var grados = ""
    @State private var aproximacion: Arpegio.Aproximacion?
    @State private var tresillos = false
    @State private var swing = false
    @State private var tempo = 72
    /// Qué posiciones del arpegio se enseñan en el mástil.
    @State private var formas = FormasDeArpegio.porPosiciones
    /// Si cada posición del arpegio sube y vuelve a bajar.
    @State private var subirYBajar = false
    /// El traste del capo en las digitaciones y el arpegio en el mástil, o 0 sin capo.
    @State private var capo = 0
    /// La disposición de piano o jazz que se enseña (drop 2, shell…).
    @State private var disposicion = DisposicionDeAcorde.drop2
    /// El grupo de cuerdas en que se toca la disposición en el instrumento de las digitaciones.
    @State private var grupoDeCuerdas = 0
    /// El acorde con que se compara el leído, o vacío.
    @State private var otroAcorde = "Do"
    /// Lo que está sonando, para resaltar la nota en el pentagrama y en el mástil.
    @ObservedObject private var reproductor = Reproductor.compartido
    /// Las digitaciones y para qué texto e instrumento se calcularon. Mientras no coincidan con lo que hay
    /// escrito, se muestra «Calculando…» y no las de otro acorde.
    @State private var digitaciones: Calculado<[Digitacion]>?

    private var claveActual: String { "\(texto)|\(encordado.nombre)|\(capo)" }

    /// Las figuras que se ofrecen para las notas del arpegio.
    private static let figuras: [Figura] = [.negra, .corchea, .semicorchea]

    /// Las tensiones que se ofrecen para añadir al arpegio.
    private static let opcionesDeTensiones: [[Int]] = [[], [9], [9, 11], [9, 13], [9, 11, 13]]

    /// Lo que dura cada nota del arpegio: la figura elegida, de tresillo si se pide.
    private var duracion: Duracion { tresillos ? figura.duracion.grupoIrregular(3, en: 2) : figura.duracion }

    /// El mástil del instrumento elegido, con el capo si lo lleva.
    private func mastil(trastes: Int) -> Mastil {
        Mastil(encordado.conCapo(capo), trastes: trastes)
    }

    private func arpegio(de acorde: Acorde) -> Arpegio {
        if let grados = Arpegio.grados(leyendo: grados) {
            return Arpegio(acorde, grados: grados, octavas: octavas, aproximacion: aproximacion)
        }
        return Arpegio(
            acorde, patron: patron, octavas: octavas, conOctava: conOctava, inicio: inicio, tensiones: tensiones,
            aproximacion: aproximacion)
    }

    private func presentado(_ arpegio: Arpegio) -> ArpegioPresentado {
        PresentacionDeArpegios.arpegio(
            arpegio, figura: duracion, tempo: Tempo(Double(tempo)), swing: swing, notacion: notacion)
    }

    /// El arpegio en el pentagrama con el ritmo con que suena: la figura elegida, en tresillos si se piden.
    private func pentagrama(de arpegio: Arpegio, resaltada: Int? = nil) -> PentagramaPresentado {
        PentagramaPresentado(
            presentado(arpegio).voz, titulo: arpegio.nombre(en: notacion), notacion: notacion, resaltada: resaltada)
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
                disposiciones(de: acorde)
                disposicionesEnElMastil(de: acorde)
                relaciones(de: acorde)
                escalas(de: acorde)
                escalasParaImprovisar(sobre: acorde)
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
        .onChange(of: texto) {
            lectura = Self.leer($0)
            inicio = 0
        }
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
            pentagrama(de: arpegio).fichero,
        ]
        if let presentadas = PresentacionDeDisposiciones.acorde(acorde, disposicion, notacion: notacion) {
            ficheros.append(presentadas.pentagrama.fichero)
            ficheros += presentadas.ficheros
        }
        ficheros += presentado(arpegio).ficheros
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

    /// El acorde dispuesto como en el piano o el jazz (cerrado, drop 2, drop 3, drop 2 y 4, con la fundamental, la
    /// tercera y la séptima, o solo las notas guía), en todas las octavas de Do3 a Sol5: su pentagrama y cada
    /// disposición con su botón para escucharla.
    @ViewBuilder
    private func disposiciones(de acorde: Acorde) -> some View {
        Section(notacion.texto(\.disposicion)) {
            Picker(notacion.texto(\.disposicion), selection: $disposicion) {
                ForEach(DisposicionDeAcorde.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            if let presentadas = PresentacionDeDisposiciones.acorde(acorde, disposicion, notacion: notacion) {
                DiagramaDePentagrama(presentadas.pentagrama)
                ForEach(Array(presentadas.filas.enumerated()), id: \.offset) { _, fila in
                    HStack {
                        Text(fila.voces).font(.system(.body, design: .monospaced))
                        Spacer()
                        BotonDeEscuchar(fila.sonido).labelStyle(.iconOnly)
                    }
                    .buttonStyle(.borderless)
                }
            } else {
                Text(notacion.texto(\.noSeDibuja)).foregroundColor(.secondary)
            }
        }
    }

    /// La disposición elegida tocada en un grupo de cuerdas del instrumento de las digitaciones (drop 2 en las
    /// cuerdas 4-3-2-1…): cada forma con su tablatura, los dedos sugeridos, su diagrama y su sonido.
    @ViewBuilder
    private func disposicionesEnElMastil(de acorde: Acorde) -> some View {
        let mastil = self.mastil(trastes: 15)
        let grupos = PresentacionDeDisposiciones.gruposDeCuerdas(disposicion, mastil: mastil, notacion: notacion)
        if !grupos.isEmpty {
            let elegido = min(grupoDeCuerdas, grupos.count - 1)
            let formas = PresentacionDeDisposiciones.enElMastil(
                acorde, disposicion, mastil: mastil, cuerdas: grupos[elegido].cuerdas)
            Section(notacion.texto(\.enElMastil) + " · " + disposicion.nombre(en: notacion)) {
                Picker(notacion.texto(\.enElMastil), selection: $grupoDeCuerdas) {
                    ForEach(grupos.indices, id: \.self) { Text(grupos[$0].nombre).tag($0) }
                }
                if formas.isEmpty {
                    Text(notacion.texto(\.noSeDibuja)).foregroundColor(.secondary)
                }
                ForEach(formas, id: \.tablatura) { forma in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(forma.tablatura).font(.system(.body, design: .monospaced))
                            Text(forma.dedos).font(.system(.caption, design: .monospaced)).foregroundColor(.secondary)
                            Spacer()
                            BotonDeEscuchar(forma.sonido).labelStyle(.iconOnly)
                        }
                        .buttonStyle(.borderless)
                        DiagramaDeMastil(digitacion: forma.digitacion, acorde: acorde, notacion: notacion)
                            .frame(maxHeight: 120)
                    }
                }
            }
        }
    }

    /// Otros nombres del acorde, el que queda sin la fundamental, las tonalidades en que está, sus sustituciones y
    /// la comparación con otro acorde: notas comunes y cómo va cada voz.
    @ViewBuilder
    private func relaciones(de acorde: Acorde) -> some View {
        let relaciones = PresentacionDeRelacionesDeAcorde.relaciones(de: acorde, notacion: notacion)
        Section(notacion.texto(\.otrosNombres)) {
            if !relaciones.otrosNombres.isEmpty {
                Text(relaciones.otrosNombres.joined(separator: " · "))
            }
            if let sinFundamental = relaciones.sinFundamental {
                LabeledContent(notacion.texto(\.sinLaFundamental), value: sinFundamental)
            }
        }
        Section(notacion.texto(\.tonalidadesDelAcorde)) {
            ForEach(relaciones.tonalidades, id: \.self) { Text($0) }
        }
        Section(notacion.texto(\.sustituciones) + " · " + relaciones.tonalidad.nombre(en: notacion)) {
            ForEach(Array(relaciones.sustituciones.enumerated()), id: \.offset) { _, propuesta in
                HStack {
                    Text(propuesta.descripcion)
                    Spacer()
                    BotonDeEscuchar(propuesta.sonido).labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
            }
        }
        Section(notacion.texto(\.compararCon)) {
            TextField(notacion.campo(.cifrado), text: $otroAcorde)
                .comoCampoDeCifrado()
            if let otro = try? Acorde(leyendo: otroAcorde),
                let comparacion = PresentacionDeRelacionesDeAcorde.comparar(acorde, con: otro, notacion: notacion)
            {
                LabeledContent(notacion.texto(\.notasComunes), value: comparacion.comunes)
                ForEach(comparacion.voces.reversed(), id: \.self) {
                    Text($0).font(.system(.body, design: .monospaced))
                }
                HStack {
                    Text(comparacion.movimiento).foregroundColor(.secondary)
                    Spacer()
                    BotonDeEscuchar(comparacion.sonido).labelStyle(.iconOnly)
                }
                .buttonStyle(.borderless)
            }
        }
    }

    /// El arpegio en el patrón (o los grados), las octavas, la nota de partida, las tensiones, las notas de
    /// aproximación y el ritmo elegidos: su pentagrama, nota a nota, y cómo suena. Mientras suena, la nota que se
    /// oye se resalta en el pentagrama.
    @ViewBuilder
    private func seccionDelArpegio(de acorde: Acorde) -> some View {
        let arpegio = self.arpegio(de: acorde)
        let sonido = presentado(arpegio).sonido
        Section(notacion.texto(\.arpegio)) {
            TextField(notacion.texto(\.porGrados) + " (1 5 3 8)", text: $grados)
                .comoCampoDeCifrado()
            if arpegio.grados.isEmpty {
                Picker(notacion.texto(\.patron), selection: $patron) {
                    ForEach(Arpegio.Patron.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
                }
                Picker(notacion.texto(\.empezarEn), selection: $inicio) {
                    ForEach(Array(acorde.notasDesdeElBajo.enumerated()), id: \.offset) { i, nota in
                        Text(nota.nombre(en: notacion)).tag(i)
                    }
                }
                Picker(notacion.texto(\.tensiones), selection: $tensiones) {
                    ForEach(Self.opcionesDeTensiones, id: \.self) { opcion in
                        Text(opcion.isEmpty ? "—" : opcion.map(String.init).joined(separator: " ")).tag(opcion)
                    }
                }
                Toggle(notacion.texto(\.conLaOctavaFinal), isOn: $conOctava)
            }
            Stepper("\(notacion.texto(\.octavas)): \(octavas)", value: $octavas, in: 1...3)
            Picker(notacion.texto(\.aproximacion), selection: $aproximacion) {
                Text("—").tag(Arpegio.Aproximacion?.none)
                ForEach(Arpegio.Aproximacion.allCases, id: \.self) { Text($0.nombre(en: notacion)).tag(Optional($0)) }
            }
            Picker(notacion.texto(\.figura), selection: $figura) {
                ForEach(Self.figuras, id: \.self) { Text($0.nombre(en: notacion)).tag($0) }
            }
            Toggle(notacion.texto(\.tresillos), isOn: $tresillos)
            Toggle(notacion.texto(\.swing), isOn: $swing)
            Stepper(notacion.texto { $0.tempo(tempo) }, value: $tempo, in: 40...240, step: 4)
            DiagramaDePentagrama(pentagrama(de: arpegio, resaltada: reproductor.paso(de: sonido)))
            BotonDeEscuchar(sonido)
        }
    }

    /// Las escalas sobre la fundamental que contienen el acorde (Sol7 → Sol mixolidio…), de las que tienen menos
    /// notas a evitar a las que más, con las tensiones y las notas a evitar de cada una.
    @ViewBuilder
    private func escalas(de acorde: Acorde) -> some View {
        let escalas = acorde.escalasCompatibles()
        if !escalas.isEmpty {
            Section(notacion.texto(\.escalasCompatibles)) {
                // Cada una se abre en la pestaña de escalas, y lleva debajo sus tensiones y sus notas a evitar.
                ForEach(Array(escalas.prefix(10).enumerated()), id: \.offset) { _, escala in
                    let presentada = PresentacionDeEscalaYAcorde.presentar(escala, sobre: acorde, notacion: notacion)
                    Button {
                        navegacion.ver(escala)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(presentada.nombre)
                            if !presentada.resumen.isEmpty {
                                Text(presentada.resumen).font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }

    /// Las escalas bebop (con su nota de paso) y las pentatónicas sin notas a evitar (con sus tensiones) para
    /// improvisar sobre el acorde, cada una con «Escuchar» y abriéndose en la pestaña de escalas.
    @ViewBuilder
    private func escalasParaImprovisar(sobre acorde: Acorde) -> some View {
        let bebop = PresentacionDeEstudioDeEscala.bebop(sobre: acorde, notacion: notacion)
        let pentatonicas = PresentacionDeEstudioDeEscala.pentatonicas(sobre: acorde, notacion: notacion)
        if !bebop.isEmpty {
            Section(notacion.texto(\.escalasBebop)) {
                ForEach(bebop, id: \.self) { filaDeEscala($0) }
            }
        }
        if !pentatonicas.isEmpty {
            Section(notacion.texto(\.pentatonicas)) {
                ForEach(pentatonicas, id: \.self) { filaDeEscala($0) }
            }
        }
    }

    private func filaDeEscala(_ presentada: EscalaSobreElAcordePresentada) -> some View {
        HStack {
            Button {
                navegacion.ver(presentada.escala)
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(presentada.nombre)
                    if !presentada.detalle.isEmpty {
                        Text(presentada.detalle).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
            BotonDeEscuchar(presentada.sonido).labelStyle(.iconOnly)
        }
        .buttonStyle(.borderless)
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
    /// mástil y, debajo, cada posición en que la mano lo toca (en franjas desde la fundamental, en las formas
    /// CAGED o con una nota por cuerda), de la más baja a la más alta, con los dedos que la pisan.
    @ViewBuilder
    private func arpegioEnElMastil(de acorde: Acorde) -> some View {
        let mastil = self.mastil(trastes: formas == .porPosiciones ? 12 : 15)
        let instrumento = encordado.titulo(en: notacion) + (capo > 0 ? " · " + notacion.texto { $0.capo(capo) } : "")
        let posiciones = PresentacionDeArpegios.enElMastil(
            acorde, formas: formas, idaYVuelta: subirYBajar, mastil: mastil, notacion: notacion)
        Section(notacion.texto(\.arpegioEnElMastil)) {
            Text(instrumento)
                .foregroundColor(.secondary)
            DiagramaDeMastil(mastil: mastil, acorde: acorde, notacion: notacion)
            Picker(notacion.texto(\.porPosiciones), selection: $formas) {
                Text(notacion.texto(\.porPosiciones)).tag(FormasDeArpegio.porPosiciones)
                Text("CAGED").tag(FormasDeArpegio.caged)
                Text(notacion.texto { $0.notasPorCuerda(1) }).tag(FormasDeArpegio.unaNotaPorCuerda)
            }
            .pickerStyle(.segmented)
            Toggle(notacion.texto(\.subirYBajar), isOn: $subirYBajar)
            ForEach(posiciones, id: \.self) { posicion in
                // En corcheas, en el orden en que se toca; mientras suena, se resalta la nota.
                let paso = reproductor.paso(de: posicion.sonido)
                let sonando = paso.flatMap { posicion.notas.indices.contains($0) ? posicion.notas[$0] : nil }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(posicion.titulo)
                        Spacer()
                        BotonDeEscuchar(posicion.sonido)
                        BotonDeExportar([posicion.fichero])
                    }
                    DiagramaDeMastil(arpegio: posicion.arpegio, acorde: acorde, notacion: notacion)
                        .resaltando(sonando)
                        .frame(maxHeight: 120)
                    Text(notacion.texto(\.dedosSugeridos) + ": " + posicion.dedos)
                        .font(.caption).foregroundColor(.secondary)
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
