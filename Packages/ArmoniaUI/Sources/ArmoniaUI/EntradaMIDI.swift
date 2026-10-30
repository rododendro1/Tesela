#if canImport(CoreMIDI) && canImport(Combine)
import Combine
import CoreMIDI
import ArmoniaPresentacion

/// Las teclas pulsadas en los teclados MIDI conectados (por USB, red o Bluetooth ya emparejado), para que las apps
/// muestren lo que se toca. Escucha todas las fuentes MIDI del sistema y se vuelve a conectar cuando cambian.
///
///     @ObservedObject private var midi = EntradaMIDI.compartida
///     …
///     .onAppear { midi.empezar() }
///     .onChange(of: midi.pulsadas) { … }
///
/// Los mensajes se leen con `CambioMIDI`, que no depende de CoreMIDI y se prueba en Linux.
@MainActor
public final class EntradaMIDI: ObservableObject {
    public static let compartida = EntradaMIDI()

    /// Las notas MIDI pulsadas ahora, en el orden en que se pulsaron.
    @Published public private(set) var pulsadas: [Int] = []
    /// Cuántas fuentes MIDI hay conectadas.
    @Published public private(set) var dispositivos = 0

    private var cliente = MIDIClientRef()
    private var puerto = MIDIPortRef()
    private var conectadas = Set<MIDIEndpointRef>()
    private var empezada = false

    private init() {}

    /// Empieza a escuchar. Llamarlo otra vez no hace nada.
    public func empezar() {
        guard !empezada else { return }
        empezada = true
        guard MIDIClientCreateWithBlock("Tesela" as CFString, &cliente, EntradaMIDI.avisos(para: self)) == noErr,
              MIDIInputPortCreateWithProtocol(cliente, "Teclados" as CFString, ._1_0, &puerto,
                                              EntradaMIDI.receptor(para: self)) == noErr
        else { return }
        conectar()
    }

    /// Conecta las fuentes que aún no lo están.
    private func conectar() {
        let fuentes = (0..<MIDIGetNumberOfSources()).map { MIDIGetSource($0) }
        for fuente in fuentes where !conectadas.contains(fuente) {
            if MIDIPortConnectSource(puerto, fuente, nil) == noErr { conectadas.insert(fuente) }
        }
        conectadas.formIntersection(fuentes)
        dispositivos = fuentes.count
    }

    private func aplicar(_ cambios: [CambioMIDI]) {
        pulsadas = CambioMIDI.aplicar(cambios, a: pulsadas)
    }

    // CoreMIDI llama a los bloques desde sus propios hilos: se crean fuera del actor principal (`nonisolated`) y
    // pasan lo leído al actor principal.

    nonisolated private static func receptor(para entrada: EntradaMIDI) -> MIDIReceiveBlock {
        { [weak entrada] lista, _ in
            var cambios: [CambioMIDI] = []
            for paquete in lista.unsafeSequence() {
                let copia = paquete.pointee
                let palabras = Int(copia.wordCount)
                withUnsafeBytes(of: copia.words) { bytes in
                    for palabra in bytes.bindMemory(to: UInt32.self).prefix(palabras) {
                        if let cambio = CambioMIDI(ump: palabra) { cambios.append(cambio) }
                    }
                }
            }
            guard !cambios.isEmpty else { return }
            let (destino, leidos) = (entrada, cambios)
            Task { @MainActor in destino?.aplicar(leidos) }
        }
    }

    nonisolated private static func avisos(para entrada: EntradaMIDI) -> MIDINotifyBlock {
        { [weak entrada] aviso in
            guard aviso.pointee.messageID == .msgSetupChanged else { return }
            let destino = entrada
            Task { @MainActor in destino?.conectar() }
        }
    }
}
#endif
