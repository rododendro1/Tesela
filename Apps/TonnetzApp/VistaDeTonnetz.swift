import Armonia
import Interfaz
import SwiftUI

/// Un acorde, una escala o un recorrido de tríadas con las transformaciones P, L y R, en el Tonnetz, en la
/// tabla armónica o en un teclado isomórfico (Wicki-Hayden, Jankó, acordeón cromático, Gerhard o Park, o uno de
/// cuadrícula, como los de los controladores de pads, que se puede girar, reflejar y tocar en tono), y su dibujo
/// para exportar. Al tocar una nota del dibujo, suena. En el modo «Identificar», además, la nota tocada se marca (o se
/// desmarca) y se dice
/// qué acorde forman las marcadas y su número de Forte; un acorde tocado en un teclado MIDI conectado también se
/// marca, con la nota más grave como bajo. En el modo «Partitura» se abre un fichero MIDI, MusicXML, MEI o ABC y se
/// siguen sus acordes en la red, paso a paso o mientras suenan, con las transformaciones P, L y R entre las tríadas.
struct VistaDeTonnetz: View {
    @Environment(\.notacion) private var notacion
    /// Lo elegido y lo que sale de ello, que se prueba sin la vista.
    @State private var modelo = ModeloDelTonnetz()
    @ObservedObject private var entradaMIDI = EntradaMIDI.compartida
    /// El último acorde tocado en el teclado MIDI y las teclas pulsadas la última vez que cambiaron.
    @State private var notasMIDI: [Int] = []
    @State private var pulsadasAntes: [Int] = []
    @State private var abriendo = false
    /// Lo que está sonando, para seguir en la red el acorde que se oye.
    @ObservedObject private var reproductor = Reproductor.compartido

    /// MIDI, MusicXML (.musicxml, .xml y .mxl), MEI y ABC.
    var body: some View {
        VStack(spacing: 12) {
            Picker(notacion.texto(\.modo), selection: $modelo.contenido) {
                ForEach(ModeloDelTonnetz.Contenido.allCases) { Text($0.titulo(en: notacion)).tag($0) }
            }
            .pickerStyle(.segmented)

            Picker(notacion.texto(\.red), selection: $modelo.red) {
                ForEach(RedDeNotas.allCases) { Text($0.nombre(en: notacion)).tag($0) }
            }

            if modelo.red == .uil { controlesDeUIL }
            if modelo.red.esCuadricula { controlesDeCuadricula }

            controles
            BotonDeEscuchar(modelo.sonido(sonando: sonando))

            if let dibujado, let svg = modelo.dibujo(de: dibujado, en: notacion) {
                VistaSVG(svg: svg)
                    // Tocar una nota la hace sonar; en «Identificar», además, la marca o la desmarca.
                    .alTocarElSVG(svg) { punto in
                        if let midi = modelo.tocar(en: punto, de: dibujado) {
                            Reproductor.compartido.tocar(.nota(midi))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: TemaDeLasApps.radioDeEsquina))
                    .accessibilityLabel(Text(modelo.nombre(de: dibujado, en: notacion)))
            } else {
                Spacer()
                Text(notacion.texto(\.noSeDibuja)).foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(TemaDeLasApps.margen)
        .navigationTitle(modelo.red.nombre(en: notacion))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .selectorDePartituras(isPresented: $abriendo) { modelo.abrir($0, en: notacion) }
        .onChange(of: notacion.clave) { _ in modelo.cambiar(a: notacion) }
        .onAppear {
            abrirLaPartituraDePrueba()
            entradaMIDI.empezar()
        }
        // En el modo «Identificar», lo que se toca en el teclado MIDI se marca en el dibujo.
        .onChange(of: entradaMIDI.pulsadas) { ahora in
            let retenidas = CambioMIDI.retener(notasMIDI, antes: pulsadasAntes, ahora: ahora)
            pulsadasAntes = ahora
            guard retenidas != notasMIDI else { return }
            notasMIDI = retenidas
            if modelo.contenido == .identificar { modelo.clasesTocadas = CambioMIDI.clases(de: retenidas) }
        }
    }

    // MARK: Controles

    /// El teclado UIL: el texto, uno de los del artículo para rellenarlo, el giro de 30° en 30° y el espejo.
    @ViewBuilder
    private var controlesDeUIL: some View {
        HStack {
            TextField(notacion.texto(\.formatoUIL), text: $modelo.uil.texto)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
                .comoCampoDeCifrado()
            Menu("UIL") {
                ForEach(AjusteUIL.conocidos, id: \.nombre) { conocido in
                    Button(conocido.nombre) { modelo.uil = AjusteUIL(texto: conocido.texto) }
                }
            }
        }
        HStack {
            Stepper("\(notacion.texto(\.giro)): \(modulo360(modelo.uil.giros * 30))°", value: $modelo.uil.giros)
            Toggle(notacion.texto(\.espejo), isOn: $modelo.uil.espejo)
        }
        Text(modelo.uil.resultado ?? notacion.texto(\.noSeDibuja))
            .font(.system(.callout, design: .monospaced))
            .foregroundColor(.secondary)
    }

    private func modulo360(_ grados: Int) -> Int { ((grados % 360) + 360) % 360 }

    /// Los teclados de cuadrícula: los ejes del personalizado, la rejilla del controlador, la nota de origen, el giro
    /// de 90° en 90°, el espejo y si se toca en tono (solo con una escala).
    @ViewBuilder
    private var controlesDeCuadricula: some View {
        if modelo.red == .cuadriculaPersonalizada {
            TextField(notacion.texto(\.ejesHV), text: $modelo.cuadrado.texto)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
                .comoCampoDeCifrado()
        }
        HStack {
            Picker(notacion.texto(\.rejilla), selection: $modelo.cuadrado.rejilla) {
                ForEach(RejillaDeControlador.todas) { Text($0.nombre).tag($0) }
            }
            Stepper("\(notacion.texto(\.notaDeOrigen)): \(nombreDelOrigen)", value: origenElegido, in: 0...127)
        }
        HStack {
            Stepper(
                "\(notacion.texto(\.giro)): \(modulo360(modelo.cuadrado.giros * 90))°", value: $modelo.cuadrado.giros)
            Toggle(notacion.texto(\.espejo), isOn: $modelo.cuadrado.espejo)
            Toggle(notacion.texto(\.enTono), isOn: $modelo.cuadrado.enTono)
                .disabled(modelo.contenido != .escala)
        }
        if modelo.red == .cuadriculaPersonalizada {
            Text(modelo.cuadrado.resultado ?? notacion.texto(\.noSeDibuja))
                .font(.system(.callout, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }

    /// La nota de la casilla de origen, con su octava: «Do₂».
    private var nombreDelOrigen: String { Altura(midi: modelo.cuadrado.midiDelOrigen).nombreCompacto(en: notacion) }

    /// La nota de la casilla de origen: la de la rejilla hasta que se elige otra.
    private var origenElegido: Binding<Int> {
        Binding(get: { modelo.cuadrado.midiDelOrigen }, set: { modelo.cuadrado.origen = $0 })
    }

    @ViewBuilder
    private var controles: some View {
        switch modelo.contenido {
        case .recorrido:
            HStack {
                TextField(notacion.campo(.triadaInicial), text: $modelo.textoInicial)
                    .textFieldStyle(.roundedBorder)
                    .comoCampoDeCifrado()
                    .onSubmit { modelo.reiniciar() }
                Button(notacion.texto(\.reiniciar)) { modelo.reiniciar() }
            }
            HStack {
                ForEach(TransformacionNeorriemanniana.allCases, id: \.self) { transformacion in
                    Button(transformacion.rawValue.uppercased()) { modelo.aplicar(transformacion) }
                        .buttonStyle(.borderedProminent)
                        .help(transformacion.nombre(en: notacion))
                }
                Button(notacion.texto(\.deshacer)) { modelo.deshacer() }
                    .disabled(modelo.recorrido.count < 2)
            }
            Text(modelo.textoDelRecorrido(en: notacion))
                .font(.system(.callout, design: .monospaced))
        case .acorde:
            TextField(notacion.campo(.acorde), text: $modelo.textoAcorde)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .escala:
            TextField(notacion.campo(.escala), text: $modelo.textoEscala)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .partitura:
            controlesDePartitura
        case .identificar:
            HStack {
                Text(modelo.identificado(en: notacion))
                    .font(.system(.callout, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(notacion.texto(\.borrar)) { modelo.clasesTocadas = [] }
                    .disabled(modelo.clasesTocadas.isEmpty)
            }
        }
    }

    /// «Abrir», el título de la pieza y, con «Anterior» y «Siguiente», el acorde que se ve y cómo se llega a él.
    @ViewBuilder
    private var controlesDePartitura: some View {
        HStack {
            Button {
                abriendo = true
            } label: {
                Label(notacion.texto(\.abrir), systemImage: "folder")
            }
            if let titulo = modelo.partitura?.titulo, !titulo.isEmpty {
                Text(titulo).font(.headline).lineLimit(1)
            }
            Spacer()
        }
        if let errorAlAbrir = modelo.errorAlAbrir {
            Text(notacion.mensaje(de: errorAlAbrir)).foregroundColor(.red)
        }
        if let partitura = modelo.partitura, let actual = pasoActual {
            HStack {
                Button {
                    elegirPaso(avanzando: false)
                } label: {
                    Label(notacion.texto(\.anterior), systemImage: "chevron.backward")
                }
                .disabled(actual == 0)
                Spacer()
                Text(modelo.descripcion(delPaso: actual) ?? "")
                    .font(.system(.callout, design: .monospaced))
                Spacer()
                Button {
                    elegirPaso(avanzando: true)
                } label: {
                    Label(notacion.texto(\.siguiente), systemImage: "chevron.forward")
                }
                .disabled(actual == partitura.pasos.count - 1)
            }
            .labelStyle(.iconOnly)
        } else if modelo.errorAlAbrir == nil {
            Text(notacion.texto(\.abreUnaPartitura)).foregroundColor(.secondary)
        }
    }

    /// El paso de la partitura que está sonando, si suena.
    private var sonando: Int? {
        modelo.partitura.flatMap { reproductor.paso(de: $0.sonido) }
    }

    /// El acorde de la partitura que se ve: el que suena, si suena; si no, el elegido (el primero al abrirla).
    private var pasoActual: Int? { modelo.pasoActual(sonando: sonando) }

    private func elegirPaso(avanzando: Bool) {
        if let acorde = modelo.elegirPaso(avanzando: avanzando, sonando: sonando) {
            Reproductor.compartido.tocar(.acorde(acorde))
        }
    }

    // MARK: El dibujo

    /// Lo que se dibuja; `nil` si el texto no se puede leer.
    private var dibujado: ContenidoDeRed? { modelo.dibujado(sonando: sonando) }

    private var ficheros: [FicheroParaExportar] { modelo.ficheros(sonando: sonando, en: notacion) }

    // MARK: Acciones

    /// Las pruebas de interfaz no pueden usar el selector de ficheros: con `-partituraDePrueba "Do Lam Fa Sol"` la app
    /// empieza en «Partitura» con esos acordes, como si se hubiera abierto su MusicXML. Solo en las compilaciones de
    /// depuración, que son las que prueban.
    private func abrirLaPartituraDePrueba() {
        #if DEBUG
            guard modelo.partitura == nil, let texto = UserDefaults.standard.string(forKey: "partituraDePrueba"),
                let analisis = try? AnalisisArmonico.analizar(leyendo: texto),
                let leida = try? ImportacionDeProgresion.leer(Data(analisis.partitura().musicXML().utf8))
            else { return }
            modelo.abrir(.success(leida), en: notacion)
            modelo.contenido = .partitura
        #endif
    }
}
