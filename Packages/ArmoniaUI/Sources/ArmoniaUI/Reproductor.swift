#if canImport(SwiftUI) && canImport(AVFoundation)
    import AVFoundation
    import SwiftUI
    import Armonia
    import ArmoniaPresentacion

    /// Toca un `Sonido` con el sintetizador del sistema (`AVAudioUnitSampler`). En macOS usa el piano del banco
    /// General MIDI del sistema; en iOS, que no lo trae, el sonido básico del sampler. Tocar algo corta lo que
    /// estuviera sonando.
    ///
    /// Suena en el temperamento guardado en los ajustes (`AjustesDeLasApps.claveDeTemperamento`). Cada nota va a su
    /// propio sampler, afinado con `globalTuning`, para que las notas de un acorde se afinen cada una por su lado; si
    /// suenan más notas a la vez que samplers hay, la que lleva más tiempo sonando deja el suyo a la nueva.
    ///
    /// Publica lo que está sonando y el paso por el que va (`Sonido.paso(en:)`), para que las vistas resalten la
    /// nota o el acorde mientras se escucha.
    @MainActor
    public final class Reproductor: ObservableObject {
        public static let compartido = Reproductor()

        /// Cuántas notas pueden sonar a la vez, cada una con su afinación.
        private static let voces = 8

        private let motor = AVAudioEngine()
        private let samplers = (0..<Reproductor.voces).map { _ in AVAudioUnitSampler() }
        private var preparado = false
        private var tarea: Task<Void, Never>?

        /// Lo que está sonando (tal como se pidió, sin afinar), o `nil` si nada.
        @Published public private(set) var sonando: Sonido?
        /// El paso de `sonando` por el que va: la nota de un arpegio o el acorde de una progresión.
        @Published public private(set) var paso: Int?

        /// El paso por el que va `sonido`, si es lo que está sonando; si no, `nil`.
        public func paso(de sonido: Sonido) -> Int? {
            sonando == sonido ? paso : nil
        }

        private init() {}

        /// El temperamento guardado en los ajustes, o el igual si no hay ninguno.
        public static var temperamentoGuardado: Temperamento {
            UserDefaults.standard.string(forKey: AjustesDeLasApps.claveDeTemperamento).flatMap(Temperamento.init)
                ?? .igual
        }

        public func tocar(_ sonido: Sonido) {
            tocar(sonido, en: Reproductor.temperamentoGuardado)
        }

        public func tocar(_ sonido: Sonido, en temperamento: Temperamento) {
            detener()
            guard !sonido.notas.isEmpty, preparar() else { return }
            let cambios = sonido.afinado(en: temperamento).cambios
            sonando = sonido
            tarea = Task {
                var ahora = 0.0
                var libres = Array(samplers.indices)
                // Las notas que suenan, por orden de comienzo, con su sampler.
                var activas: [(nota: Int, midi: Int, sampler: Int)] = []
                for cambio in cambios {
                    if cambio.tiempo > ahora {
                        try? await Task.sleep(nanoseconds: UInt64((cambio.tiempo - ahora) * 1_000_000_000))
                        ahora = cambio.tiempo
                    }
                    guard !Task.isCancelled else { return }
                    if cambio.esInicio {
                        let actual = sonido.paso(en: cambio.tiempo)
                        if actual != paso { paso = actual }
                        let elegido: Int
                        if !libres.isEmpty {
                            elegido = libres.removeFirst()
                        } else {
                            let primera = activas.removeFirst()
                            samplers[primera.sampler].stopNote(UInt8(primera.midi), onChannel: 0)
                            elegido = primera.sampler
                        }
                        samplers[elegido].globalTuning = Float(cambio.desviacion)
                        samplers[elegido].startNote(UInt8(cambio.midi), withVelocity: 90, onChannel: 0)
                        activas.append((cambio.nota, cambio.midi, elegido))
                    } else if let i = activas.firstIndex(where: { $0.nota == cambio.nota }) {
                        let nota = activas.remove(at: i)
                        samplers[nota.sampler].stopNote(UInt8(nota.midi), onChannel: 0)
                        libres.append(nota.sampler)
                    }
                }
                guard !Task.isCancelled else { return }
                sonando = nil
                paso = nil
            }
        }

        /// Corta lo que esté sonando.
        public func detener() {
            tarea?.cancel()
            tarea = nil
            sonando = nil
            paso = nil
            guard preparado else { return }
            for sampler in samplers {
                for midi in UInt8(0)...UInt8(127) {
                    sampler.stopNote(midi, onChannel: 0)
                }
            }
        }

        /// Conecta los samplers y arranca el motor la primera vez. Dice si se puede tocar.
        private func preparar() -> Bool {
            if preparado { return true }
            #if os(iOS)
                try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                try? AVAudioSession.sharedInstance().setActive(true)
            #endif
            for sampler in samplers {
                motor.attach(sampler)
                motor.connect(sampler, to: motor.mainMixerNode, format: nil)
                #if os(macOS)
                    let banco = URL(
                        fileURLWithPath:
                            "/System/Library/Components/CoreAudio.component/Contents/Resources/gs_instruments.dls")
                    if FileManager.default.fileExists(atPath: banco.path) {
                        try? sampler.loadSoundBankInstrument(
                            at: banco, program: 0, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                            bankLSB: UInt8(kAUSampler_DefaultBankLSB))
                    }
                #endif
            }
            do {
                try motor.start()
            } catch {
                return false
            }
            preparado = true
            return true
        }
    }

    /// Un botón «Escuchar» que toca `sonido`, y que mientras suena lo detiene. Se desactiva si no hay nada que
    /// tocar.
    public struct BotonDeEscuchar: View {
        public let sonido: Sonido
        @Environment(\.notacion) private var notacion
        @ObservedObject private var reproductor = Reproductor.compartido

        public init(_ sonido: Sonido) {
            self.sonido = sonido
        }

        public var body: some View {
            if reproductor.sonando == sonido {
                Button {
                    reproductor.detener()
                } label: {
                    Label(notacion.texto(.detener), systemImage: "stop.circle")
                }
            } else {
                Button {
                    reproductor.tocar(sonido)
                } label: {
                    Label(notacion.texto(.escuchar), systemImage: "play.circle")
                }
                .disabled(sonido.notas.isEmpty)
            }
        }
    }
#endif
