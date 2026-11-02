import Armonia
import ArmoniaUI
import SwiftUI
import UniformTypeIdentifiers

/// Un acorde, una escala o un recorrido de tríadas con las transformaciones P, L y R, en el Tonnetz, en la
/// tabla armónica o en un teclado isomórfico (Wicki-Hayden, Jankó, acordeón cromático, Gerhard o Park), y su dibujo
/// para exportar. Al tocar una nota del dibujo, suena. En el modo «Identificar», además, la nota tocada se marca (o se
/// desmarca) y se dice
/// qué acorde forman las marcadas y su número de Forte; un acorde tocado en un teclado MIDI conectado también se
/// marca, con la nota más grave como bajo. En el modo «Partitura» se abre un fichero MIDI, MusicXML, MEI o ABC y se
/// siguen sus acordes en la red, paso a paso o mientras suenan, con las transformaciones P, L y R entre las tríadas.
struct VistaDeTonnetz: View {
    enum Contenido: CaseIterable, Identifiable {
        case recorrido
        case acorde
        case escala
        case identificar
        case partitura
        var id: Self { self }

        func titulo(en notacion: Notacion) -> String {
            switch self {
            case .recorrido: return notacion.texto(\.recorridoPLR)
            case .acorde: return notacion.texto(\.acorde)
            case .escala: return notacion.texto(\.escala)
            case .identificar: return notacion.texto(\.identificar)
            case .partitura: return notacion.texto(\.partitura)
            }
        }
    }

    @Environment(\.notacion) private var notacion
    @State private var contenido = Contenido.recorrido
    @State private var red = RedDeNotas.tonnetz
    @State private var uil = AjusteUIL()
    @State private var textoInicial = "Do"
    @State private var textoAcorde = "Dom7"
    @State private var textoEscala = "Re dórico"
    @State private var recorrido: [Acorde] = []
    @State private var transformaciones: [TransformacionNeorriemanniana] = []
    /// Las clases de altura tocadas en el modo «Identificar», en el orden en que se tocaron: la primera es el bajo.
    @State private var clasesTocadas: [Int] = []
    @ObservedObject private var entradaMIDI = EntradaMIDI.compartida
    /// El último acorde tocado en el teclado MIDI y las teclas pulsadas la última vez que cambiaron.
    @State private var notasMIDI: [Int] = []
    @State private var pulsadasAntes: [Int] = []
    /// La pieza abierta en el modo «Partitura», el acorde elegido con «Anterior» y «Siguiente», y por qué no se pudo
    /// abrir el último fichero.
    @State private var partitura: RecorridoDePartitura?
    /// Lo leído del fichero, para volver a escribir los cifrados si cambia la notación.
    @State private var importada: ProgresionImportada?
    @State private var pasoElegido: Int?
    @State private var abriendo = false
    @State private var errorAlAbrir: Error?
    /// Lo que está sonando, para seguir en la red el acorde que se oye.
    @ObservedObject private var reproductor = Reproductor.compartido

    /// MIDI, MusicXML (.musicxml, .xml y .mxl), MEI y ABC.
    private static let tipos: [UTType] =
        [.midi, .xml]
        + ImportacionDeProgresion.extensiones.compactMap { UTType(filenameExtension: $0) }

    var body: some View {
        VStack(spacing: 12) {
            Picker(notacion.texto(\.modo), selection: $contenido) {
                ForEach(Contenido.allCases) { Text($0.titulo(en: notacion)).tag($0) }
            }
            .pickerStyle(.segmented)

            Picker(notacion.texto(\.red), selection: $red) {
                ForEach(RedDeNotas.allCases) { Text($0.nombre(en: notacion)).tag($0) }
            }

            if red == .uil { controlesDeUIL }

            controles
            BotonDeEscuchar(sonido)

            if let dibujado, let svg = PresentacionDeRedes.svg(dibujado, en: red, notacion: notacion, uil: uil) {
                VistaSVG(svg: svg)
                    // Tocar una nota la hace sonar.
                    .alTocarElSVG(svg) { punto in
                        if let midi = PresentacionDeRedes.midi(en: punto, de: dibujado, enLaRed: red, uil: uil) {
                            Reproductor.compartido.tocar(.nota(midi))
                            if contenido == .identificar {
                                clasesTocadas = PresentacionDeRedes.alternar(midi, en: clasesTocadas)
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: TemaDeLasApps.radioDeEsquina))
                    .accessibilityLabel(
                        Text(PresentacionDeRedes.nombre(dibujado, en: red, notacion: notacion, uil: uil)))
            } else {
                Spacer()
                Text(notacion.texto(\.noSeDibuja)).foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(TemaDeLasApps.margen)
        .navigationTitle(red.nombre(en: notacion))
        .selectorDeNotacionEnLaBarra()
        .toolbar {
            ToolbarItem {
                BotonDeExportar(ficheros)
            }
        }
        .fileImporter(isPresented: $abriendo, allowedContentTypes: Self.tipos) { elegido in
            abrir(elegido)
        }
        .onChange(of: notacion.clave) { _ in
            partitura = importada.map { RecorridoDePartitura($0, notacion: notacion) }
        }
        .onAppear {
            if recorrido.isEmpty { reiniciar() }
            entradaMIDI.empezar()
        }
        // En el modo «Identificar», lo que se toca en el teclado MIDI se marca en el dibujo.
        .onChange(of: entradaMIDI.pulsadas) { ahora in
            let retenidas = CambioMIDI.retener(notasMIDI, antes: pulsadasAntes, ahora: ahora)
            pulsadasAntes = ahora
            guard retenidas != notasMIDI else { return }
            notasMIDI = retenidas
            if contenido == .identificar { clasesTocadas = CambioMIDI.clases(de: retenidas) }
        }
    }

    // MARK: Controles

    /// El teclado UIL: el texto, uno de los del artículo para rellenarlo, el giro de 30° en 30° y el espejo.
    @ViewBuilder
    private var controlesDeUIL: some View {
        HStack {
            TextField(notacion.texto(\.formatoUIL), text: $uil.texto)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))
                .comoCampoDeCifrado()
            Menu("UIL") {
                ForEach(AjusteUIL.conocidos, id: \.nombre) { conocido in
                    Button(conocido.nombre) { uil = AjusteUIL(texto: conocido.texto) }
                }
            }
        }
        HStack {
            Stepper("\(notacion.texto(\.giro)): \(modulo360(uil.giros * 30))°", value: $uil.giros)
            Toggle(notacion.texto(\.espejo), isOn: $uil.espejo)
        }
        Text(uil.resultado ?? notacion.texto(\.noSeDibuja))
            .font(.system(.callout, design: .monospaced))
            .foregroundColor(.secondary)
    }

    private func modulo360(_ grados: Int) -> Int { ((grados % 360) + 360) % 360 }

    @ViewBuilder
    private var controles: some View {
        switch contenido {
        case .recorrido:
            HStack {
                TextField(notacion.campo(.triadaInicial), text: $textoInicial)
                    .textFieldStyle(.roundedBorder)
                    .comoCampoDeCifrado()
                    .onSubmit(reiniciar)
                Button(notacion.texto(\.reiniciar), action: reiniciar)
            }
            HStack {
                ForEach(TransformacionNeorriemanniana.allCases, id: \.self) { transformacion in
                    Button(transformacion.rawValue.uppercased()) { aplicar(transformacion) }
                        .buttonStyle(.borderedProminent)
                        .help(transformacion.nombre(en: notacion))
                }
                Button(notacion.texto(\.deshacer)) { deshacer() }
                    .disabled(recorrido.count < 2)
            }
            Text(recorrido.map { $0.cifrado(en: notacion) }.joined(separator: " → "))
                .font(.system(.callout, design: .monospaced))
        case .acorde:
            TextField(notacion.campo(.acorde), text: $textoAcorde)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .escala:
            TextField(notacion.campo(.escala), text: $textoEscala)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .partitura:
            controlesDePartitura
        case .identificar:
            HStack {
                Text(identificado)
                    .font(.system(.callout, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(notacion.texto(\.borrar)) { clasesTocadas = [] }
                    .disabled(clasesTocadas.isEmpty)
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
            if let titulo = partitura?.titulo, !titulo.isEmpty {
                Text(titulo).font(.headline).lineLimit(1)
            }
            Spacer()
        }
        if let errorAlAbrir {
            Text(notacion.mensaje(de: errorAlAbrir)).foregroundColor(.red)
        }
        if let partitura, let actual = pasoActual {
            HStack {
                Button {
                    elegirPaso(avanzando: false)
                } label: {
                    Label(notacion.texto(\.anterior), systemImage: "chevron.backward")
                }
                .disabled(actual == 0)
                Spacer()
                Text(descripcion(de: actual, en: partitura))
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
        } else if errorAlAbrir == nil {
            Text(notacion.texto(\.abreUnaPartitura)).foregroundColor(.secondary)
        }
    }

    /// «3/24 · Lam –R→ Fa»: el número del paso, el acorde anterior y el actual y las transformaciones entre ellos.
    private func descripcion(de i: Int, en partitura: RecorridoDePartitura) -> String {
        let paso = partitura.pasos[i]
        let numero = "\(i + 1)/\(partitura.pasos.count) · "
        guard i > 0 else { return numero + paso.cifrado }
        return numero + partitura.pasos[i - 1].cifrado + " –" + paso.transformacion + "→ " + paso.cifrado
    }

    /// El acorde de la partitura que se ve: el que suena, si suena; si no, el elegido (el primero al abrirla).
    private var pasoActual: Int? {
        guard let partitura, !partitura.pasos.isEmpty else { return nil }
        if let sonando = reproductor.paso(de: partitura.sonido) { return sonando }
        return min(pasoElegido ?? 0, partitura.pasos.count - 1)
    }

    private func elegirPaso(avanzando: Bool) {
        guard let partitura else { return }
        pasoElegido = partitura.paso(desde: pasoActual, avanzando: avanzando)
        if let pasoElegido { Reproductor.compartido.tocar(.acorde(partitura.pasos[pasoElegido].acorde)) }
    }

    /// Lo que forman las notas tocadas: el acorde más probable con su nombre y, detrás, otras lecturas. Sin notas,
    /// la indicación; con notas que no forman acorde, sus nombres y el aviso.
    private var identificado: String {
        guard !clasesTocadas.isEmpty else { return notacion.texto(\.tocaNotas) }
        let acordes = PresentacionDeRedes.acordes(de: clasesTocadas)
        guard let primero = acordes.first else {
            let notas = ContenidoDeRed.clases(clasesTocadas).notas.map { $0.nombre(en: notacion) }.joined(
                separator: " ")
            return clasesTocadas.count < 2 ? notas : notas + " · " + notacion.texto(\.sinAcordeConocido)
        }
        let otros = acordes.dropFirst().prefix(3).map { $0.cifrado(en: notacion) }
        let forte =
            AnalisisPostonalPresentado(clases: clasesTocadas).numeroDeForte.map {
                "\n" + notacion.texto(\.numeroDeForte) + ": " + $0
            } ?? ""
        return primero.cifrado(en: notacion) + " · " + primero.nombre(en: notacion)
            + (otros.isEmpty ? "" : "\n" + otros.joined(separator: ", ")) + forte
    }

    // MARK: El dibujo

    /// Lo que se dibuja; `nil` si el texto no se puede leer.
    private var dibujado: ContenidoDeRed? {
        switch contenido {
        case .recorrido:
            return recorrido.isEmpty ? nil : .recorrido(recorrido)
        case .acorde:
            return (try? Acorde(leyendo: textoAcorde)).map { .acorde($0) }
        case .escala:
            return (try? Escala(leyendo: textoEscala)).map { .escala($0) }
        case .identificar:
            return .clases(clasesTocadas)
        case .partitura:
            // El acorde que se ve, con las tríadas que llevan a él y sus flechas.
            guard let partitura, let actual = pasoActual else { return nil }
            let tramo = partitura.tramo(hasta: actual)
            return tramo.count >= 2 ? .recorrido(tramo) : tramo.first.map { .acorde($0) }
        }
    }

    /// Lo que suena al pulsar «Escuchar»: el acorde, la escala o el recorrido.
    private var sonido: Escucha {
        if contenido == .partitura { return partitura?.sonido ?? .silencio }
        switch dibujado {
        case .acorde(let acorde): return .acorde(acorde)
        case .escala(let escala): return .escala(escala)
        case .recorrido(let acordes): return .acordes(acordes)
        case .clases(let clases):
            if let acorde = PresentacionDeRedes.acordes(de: clases).first { return .acorde(acorde) }
            return clases.isEmpty ? .silencio : .coral([clases.map { Altura(midi: 60 + $0) }])
        default: return .silencio
        }
    }

    private var ficheros: [FicheroParaExportar] {
        guard let dibujado, let svg = PresentacionDeRedes.svg(dibujado, en: red, notacion: notacion, uil: uil) else {
            return []
        }
        return [.svg(svg, nombre: PresentacionDeRedes.nombre(dibujado, en: red, notacion: notacion, uil: uil))]
    }

    // MARK: Acciones

    /// Lee el fichero elegido y empieza por su primer acorde.
    private func abrir(_ elegido: Result<URL, Error>) {
        do {
            let url = try elegido.get()
            // Los ficheros de fuera de la app (Archivos, iCloud) solo se leen con permiso.
            let conPermiso = url.startAccessingSecurityScopedResource()
            defer { if conPermiso { url.stopAccessingSecurityScopedResource() } }
            let leida = try ImportacionDeProgresion.leer(Data(contentsOf: url))
            importada = leida
            partitura = RecorridoDePartitura(leida, notacion: notacion)
            pasoElegido = 0
            errorAlAbrir = nil
        } catch {
            errorAlAbrir = error
        }
    }

    private func reiniciar() {
        transformaciones = []
        recorrido = (try? Acorde(leyendo: textoInicial)).map { [$0] } ?? []
    }

    private func aplicar(_ transformacion: TransformacionNeorriemanniana) {
        guard let ultimo = recorrido.last, let siguiente = ultimo.transformar(transformacion) else { return }
        recorrido.append(siguiente)
        transformaciones.append(transformacion)
    }

    private func deshacer() {
        guard recorrido.count > 1 else { return }
        recorrido.removeLast()
        transformaciones.removeLast()
    }
}
