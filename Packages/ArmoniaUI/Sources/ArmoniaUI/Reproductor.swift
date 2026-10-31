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
    @MainActor
    public final class Reproductor {
        public static let compartido = Reproductor()

        /// Cuántas notas pueden sonar a la vez, cada una con su afinación.
        private static let voces = 8

        private let motor = AVAudioEngine()
        private let samplers = (0..<Reproductor.voces).map { _ in AVAudioUnitSampler() }
        private var preparado = false
        private var tarea: Task<Void, Never>?

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
            tarea = Task {
                var ahora = 0.0
                var libres = Array(samplers.indices)
                // Las notas que suenan, por orden de comienzo, con su sampler.
                var sonando: [(nota: Int, midi: Int, sampler: Int)] = []
                for cambio in cambios {
                    if cambio.tiempo > ahora {
                        try? await Task.sleep(nanoseconds: UInt64((cambio.tiempo - ahora) * 1_000_000_000))
                        ahora = cambio.tiempo
                    }
                    guard !Task.isCancelled else { return }
                    if cambio.esInicio {
                        let elegido: Int
                        if !libres.isEmpty {
                            elegido = libres.removeFirst()
                        } else {
                            let primera = sonando.removeFirst()
                            samplers[primera.sampler].stopNote(UInt8(primera.midi), onChannel: 0)
                            elegido = primera.sampler
                        }
                        samplers[elegido].globalTuning = Float(cambio.desviacion)
                        samplers[elegido].startNote(UInt8(cambio.midi), withVelocity: 90, onChannel: 0)
                        sonando.append((cambio.nota, cambio.midi, elegido))
                    } else if let i = sonando.firstIndex(where: { $0.nota == cambio.nota }) {
                        let nota = sonando.remove(at: i)
                        samplers[nota.sampler].stopNote(UInt8(nota.midi), onChannel: 0)
                        libres.append(nota.sampler)
                    }
                }
            }
        }

        /// Corta lo que esté sonando.
        public func detener() {
            tarea?.cancel()
            tarea = nil
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

    /// Un botón «Escuchar» que toca `sonido`. Se desactiva si no hay nada que tocar.
    public struct BotonDeEscuchar: View {
        public let sonido: Sonido
        @Environment(\.notacion) private var notacion

        public init(_ sonido: Sonido) {
            self.sonido = sonido
        }

        public var body: some View {
            Button {
                Reproductor.compartido.tocar(sonido)
            } label: {
                Label(notacion.texto(.escuchar), systemImage: "play.circle")
            }
            .disabled(sonido.notas.isEmpty)
        }
    }
#endif
