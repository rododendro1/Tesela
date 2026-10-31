import Armonia
import ArmoniaUI
import SwiftUI

/// Un acorde, una escala o un recorrido de tríadas con las transformaciones P, L y R, en el Tonnetz, en la
/// tabla armónica o en un teclado isomórfico (Wicki-Hayden, Jankó o acordeón cromático), y su dibujo para exportar. Al tocar una
/// nota del dibujo, suena. En el modo «Identificar», además, la nota tocada se marca (o se desmarca) y se dice
/// qué acorde forman las marcadas y su número de Forte; un acorde tocado en un teclado MIDI conectado también se
/// marca, con la nota más grave como bajo.
struct VistaDeTonnetz: View {
    enum Contenido: CaseIterable, Identifiable {
        case recorrido
        case acorde
        case escala
        case identificar
        var id: Self { self }

        var texto: TextoDeLasApps {
            switch self {
            case .recorrido: return .recorridoPLR
            case .acorde: return .acorde
            case .escala: return .escala
            case .identificar: return .identificar
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

    var body: some View {
        VStack(spacing: 12) {
            Picker(notacion.texto(.modo), selection: $contenido) {
                ForEach(Contenido.allCases) { Text(notacion.texto($0.texto)).tag($0) }
            }
            .pickerStyle(.segmented)

            Picker(notacion.texto(.red), selection: $red) {
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
                Text(notacion.texto(.noSeDibuja)).foregroundColor(.secondary)
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
            TextField(notacion.texto(.formatoUIL), text: $uil.texto)
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
            Stepper("\(notacion.texto(.giro)): \(modulo360(uil.giros * 30))°", value: $uil.giros)
            Toggle(notacion.texto(.espejo), isOn: $uil.espejo)
        }
        Text(uil.resultado ?? notacion.texto(.noSeDibuja))
            .font(.system(.callout, design: .monospaced))
            .foregroundColor(.secondary)
    }

    private func modulo360(_ grados: Int) -> Int { ((grados % 360) + 360) % 360 }

    @ViewBuilder
    private var controles: some View {
        switch contenido {
        case .recorrido:
            HStack {
                TextField(notacion.texto(.campoDeTriadaInicial), text: $textoInicial)
                    .textFieldStyle(.roundedBorder)
                    .comoCampoDeCifrado()
                    .onSubmit(reiniciar)
                Button(notacion.texto(.reiniciar), action: reiniciar)
            }
            HStack {
                ForEach(TransformacionNeorriemanniana.allCases, id: \.self) { transformacion in
                    Button(transformacion.rawValue.uppercased()) { aplicar(transformacion) }
                        .buttonStyle(.borderedProminent)
                        .help(transformacion.nombre(en: notacion))
                }
                Button(notacion.texto(.deshacer)) { deshacer() }
                    .disabled(recorrido.count < 2)
            }
            Text(recorrido.map { $0.cifrado(en: notacion) }.joined(separator: " → "))
                .font(.system(.callout, design: .monospaced))
        case .acorde:
            TextField(notacion.texto(.campoDeAcorde), text: $textoAcorde)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .escala:
            TextField(notacion.texto(.campoDeEscala), text: $textoEscala)
                .textFieldStyle(.roundedBorder)
                .comoCampoDeCifrado()
        case .identificar:
            HStack {
                Text(identificado)
                    .font(.system(.callout, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(notacion.texto(.borrar)) { clasesTocadas = [] }
                    .disabled(clasesTocadas.isEmpty)
            }
        }
    }

    /// Lo que forman las notas tocadas: el acorde más probable con su nombre y, detrás, otras lecturas. Sin notas,
    /// la indicación; con notas que no forman acorde, sus nombres y el aviso.
    private var identificado: String {
        guard !clasesTocadas.isEmpty else { return notacion.texto(.tocaNotas) }
        let acordes = PresentacionDeRedes.acordes(de: clasesTocadas)
        guard let primero = acordes.first else {
            let notas = ContenidoDeRed.clases(clasesTocadas).notas.map { $0.nombre(en: notacion) }.joined(
                separator: " ")
            return clasesTocadas.count < 2 ? notas : notas + " · " + notacion.texto(.sinAcordeConocido)
        }
        let otros = acordes.dropFirst().prefix(3).map { $0.cifrado(en: notacion) }
        let forte =
            PresentacionPostonal(clases: clasesTocadas).numeroDeForte.map {
                "\n" + notacion.texto(.numeroDeForte) + ": " + $0
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
        }
    }

    /// Lo que suena al pulsar «Escuchar»: el acorde, la escala o el recorrido.
    private var sonido: Sonido {
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
