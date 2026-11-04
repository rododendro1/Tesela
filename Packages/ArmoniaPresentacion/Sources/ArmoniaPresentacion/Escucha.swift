import Armonia

/// Lo que suena al pulsar «Escuchar» en las apps: notas MIDI con su inicio y su duración, en segundos. Aquí solo
/// se decide qué suena, cuándo y con qué afinación; el reproductor de ArmoniaUI lo toca con el sintetizador del
/// sistema.
///
///     Escucha.acorde(Acorde("Sol7/Si")).notas.map(\.midi)   // [59, 62, 65, 67]: Si3 Re4 Fa4 Sol4
///
/// Cada nota guarda su altura escrita, así que `afinado(en:)` puede afinar Sol♯ y La♭ de forma distinta en un
/// temperamento que los distinga.
public struct Escucha: Hashable, Sendable {
    /// Una nota que suena: su altura (y su número MIDI), cuándo empieza, cuánto dura y cuánto se aparta, en
    /// cents, del temperamento igual.
    public struct NotaMIDI: Hashable, Sendable {
        public let altura: Altura
        public let inicio: Double
        public let duracion: Double
        /// Cents por encima (o por debajo) de la nota MIDI en temperamento igual con La4 = 440.
        public var desviacion: Double
        /// Los cents que se aparta de su nota escrita por ser un microtono (el Mi𝄳 de Bayātī es un Mi♭ cincuenta
        /// cents más alto), sea cual sea el temperamento: `afinado(en:)` los suma a los del temperamento.
        public let microtono: Double

        public var midi: Int { altura.midi }

        /// Una nota; `desviacion`, si no se da, es la del microtono.
        public init(
            altura: Altura, inicio: Double, duracion: Double, desviacion: Double? = nil, microtono: Double = 0
        ) {
            self.altura = altura
            self.inicio = inicio
            self.duracion = duracion
            self.microtono = microtono
            self.desviacion = desviacion ?? microtono
        }

        /// Una nota con la ortografía más habitual de su número MIDI.
        public init(midi: Int, inicio: Double, duracion: Double) {
            self.init(altura: Altura(midi: midi), inicio: inicio, duracion: duracion)
        }
    }

    /// Una nota que empieza o termina, en orden de tiempo para el reproductor. `nota` es su índice en `notas`,
    /// para que el reproductor apague la misma que encendió.
    public struct Cambio: Hashable, Sendable {
        public let tiempo: Double
        public let midi: Int
        public let esInicio: Bool
        public let nota: Int
        public let desviacion: Double
    }

    public let notas: [NotaMIDI]
    /// La tónica de lo que suena, si se conoce: la de la escala o la tonalidad. La afinación justa se construye
    /// sobre ella.
    public let tonica: Nota?

    public init(notas: [NotaMIDI], tonica: Nota? = nil) {
        self.notas = notas.filter { (0...127).contains($0.midi) && $0.duracion > 0 }
        self.tonica = tonica
    }

    /// Lo mismo, con otra tónica.
    public func conTonica(_ tonica: Nota?) -> Escucha {
        Escucha(notas: notas, tonica: tonica)
    }

    /// Lo mismo, con cada nota afinada en `temperamento` (la justa, sobre la tónica, o sobre Do si no se conoce).
    /// Los microtonos se conservan: se suman a la afinación de su nota escrita.
    ///
    ///     Escucha.acorde(Acorde("Do")).afinado(en: .justa).notas.map { Int($0.desviacion.rounded()) }   // [0, -14, 2]
    public func afinado(en temperamento: AfinacionHistorica) -> Escucha {
        let afinacion = temperamento.afinacion(tonica: tonica ?? .do)
        return Escucha(
            notas: notas.map { nota in
                var afinada = nota
                afinada.desviacion = afinacion.desviacion(de: nota.altura) + nota.microtono
                return afinada
            }, tonica: tonica)
    }

    /// Nada que tocar.
    public static let silencio = Escucha(notas: [])

    /// Cuánto dura todo, en segundos.
    public var duracion: Double { notas.map { $0.inicio + $0.duracion }.max() ?? 0 }

    /// Los momentos en que empieza algo, sin repetir y en orden: uno por nota en un arpegio, uno por acorde en
    /// una progresión. El paso `i` es lo que empieza en `inicios[i]`.
    public var inicios: [Double] {
        Array(Set(notas.map(\.inicio))).sorted()
    }

    /// Lo que está sonando en un momento: el índice del último paso de `inicios` que ha empezado, o `nil` antes
    /// de empezar y después de acabar. En un arpegio es la nota; en una progresión, el acorde.
    ///
    ///     Escucha.arpegio(Arpegio(Acorde("Do"))).paso(en: 0.3)   // 1: suena Mi
    public func paso(en tiempo: Double) -> Int? {
        guard tiempo >= 0, tiempo < duracion else { return nil }
        return inicios.lastIndex { $0 <= tiempo }
    }

    /// Lo mismo con swing: en cada pulso de `pulso` segundos, la primera mitad se alarga hasta `proporcion` del
    /// pulso y la segunda se acorta (dos tercios y un tercio por omisión, como un tresillo de negra y corchea), así
    /// que dos corcheas iguales suenan larga-corta. Lo que empieza en el pulso no se mueve.
    ///
    ///     Escucha.voz(Voz(arpegio, figura: .corchea), tempo: Tempo(60)).conSwing(pulso: 1).inicios
    ///     // [0, 0.667, 1, 1.667…] en vez de [0, 0.5, 1, 1.5…]
    public func conSwing(pulso: Double, proporcion: Double = 2.0 / 3.0) -> Escucha {
        guard pulso > 0, proporcion > 0, proporcion < 1 else { return self }
        func mover(_ tiempo: Double) -> Double {
            let pulsos = (tiempo / pulso + 1e-9).rounded(.down)
            let dentro = max(0, tiempo - pulsos * pulso)
            let mitad = pulso / 2
            let movido =
                dentro <= mitad
                ? dentro * 2 * proporcion
                : pulso * proporcion + (dentro - mitad) * 2 * (1 - proporcion)
            return pulsos * pulso + movido
        }
        let movidas = notas.map { nota -> NotaMIDI in
            let inicio = mover(nota.inicio)
            let fin = mover(nota.inicio + nota.duracion)
            return NotaMIDI(
                altura: nota.altura, inicio: inicio, duracion: max(0.01, fin - inicio), desviacion: nota.desviacion,
                microtono: nota.microtono)
        }
        return Escucha(notas: movidas, tonica: tonica)
    }

    /// Los comienzos y finales de las notas, por orden de tiempo. A un mismo tiempo, los finales van antes,
    /// para que una nota repetida vuelva a sonar.
    public var cambios: [Cambio] {
        notas.enumerated().flatMap { i, nota in
            [
                Cambio(tiempo: nota.inicio, midi: nota.midi, esInicio: true, nota: i, desviacion: nota.desviacion),
                Cambio(
                    tiempo: nota.inicio + nota.duracion, midi: nota.midi, esInicio: false, nota: i,
                    desviacion: nota.desviacion),
            ]
        }
        .sorted { ($0.tiempo, $0.esInicio ? 1 : 0) < ($1.tiempo, $1.esInicio ? 1 : 0) }
    }

    // MARK: Lo que tocan las apps

    /// Una nota sola: la que se toca en un dibujo.
    public static func nota(_ midi: Int, duracion: Double = 0.8) -> Escucha {
        Escucha(notas: [NotaMIDI(midi: midi, inicio: 0, duracion: duracion)])
    }

    /// Una nota escrita sola.
    public static func nota(_ altura: Altura, duracion: Double = 0.8) -> Escucha {
        Escucha(notas: [NotaMIDI(altura: altura, inicio: 0, duracion: duracion)])
    }

    /// Un acorde desde su bajo, en posición cerrada a partir de Do3: primero arpegiado y luego junto. Su tónica
    /// es la fundamental.
    public static func acorde(_ acorde: Acorde) -> Escucha {
        let alturas = cerrada(acorde.notasDesdeElBajo, desde: 48)
        let paso = 0.12
        let final = paso * Double(alturas.count)
        return Escucha(
            notas: alturas.enumerated().map { i, altura in
                NotaMIDI(altura: altura, inicio: paso * Double(i), duracion: final - paso * Double(i) + 1.2)
            }, tonica: acorde.fundamental)
    }

    /// Una escala de la tónica a su octava, desde la tónica en la octava 4, y vuelta a la tónica. Si la escala
    /// tiene microtonos, suenan: el Mi𝄳 de Re Bayātī, un cuarto de tono sobre el Mi♭.
    ///
    ///     Escucha.escala(Escala(.re, .bayati)).notas.map(\.microtono)   // [0, 50, 0, 0, 0, 0, 0, 0]
    public static func escala(_ escala: Escala) -> Escucha {
        let subida = cerrada(escala.notas, desde: 60)
        guard let tonica = subida.first else { return .silencio }
        let alturas = subida + [tonica + .octava]
        // La tónica de arriba, como la de abajo: en Sīkāh, las dos son Mi𝄳.
        let desvios: [Double] = escala.tipo.microtonal?.desvios(sentido: .ascendente) ?? []
        let microtonos: [Double] = desvios + [desvios.first ?? 0]
        let paso = 0.3
        return Escucha(
            notas: alturas.enumerated().map { i, altura in
                NotaMIDI(
                    altura: altura, inicio: paso * Double(i), duracion: paso * 0.9,
                    microtono: microtonos.indices.contains(i) ? microtonos[i] : 0)
            }, tonica: escala.tonica)
    }

    /// Un arpegio nota a nota, en el orden de su patrón, desde el bajo del acorde en la octava 3. Su tónica es la
    /// fundamental.
    ///
    ///     Escucha.arpegio(Arpegio(Acorde("Do"), patron: .alberti)).notas.map(\.midi)   // [48, 55, 52, 55]
    public static func arpegio(_ arpegio: Arpegio, paso: Double = 0.25) -> Escucha {
        Escucha(
            notas: arpegio.alturas(octava: 3).enumerated().map { i, altura in
                NotaMIDI(altura: altura, inicio: paso * Double(i), duracion: paso * 0.95)
            }, tonica: arpegio.acorde.fundamental)
    }

    /// Una progresión, un acorde detrás de otro, cada uno desde su bajo a partir de Do3.
    public static func acordes(_ acordes: [Acorde], duracion: Double = 1) -> Escucha {
        grupos(acordes.map { cerrada($0.notasDesdeElBajo, desde: 48) }, duracion: duracion)
    }

    /// Una progresión con su ritmo armónico: cada acorde dura lo que dice `duraciones`, al tempo dado.
    ///
    ///     let sonido = Escucha.acordes([Acorde("Do"), Acorde("Sol")], duraciones: [.blanca, .negra], tempo: Tempo(60))
    ///     sonido.notas.last?.inicio   // 2
    public static func acordes(_ acordes: [Acorde], duraciones: [Duracion], tempo: Tempo = Escucha.tempo) -> Escucha {
        var inicio = 0.0
        var notas: [NotaMIDI] = []
        for (acorde, duracion) in zip(acordes, duraciones) {
            let segundos = tempo.segundos(de: duracion)
            notas += cerrada(acorde.notasDesdeElBajo, desde: 48).map {
                NotaMIDI(altura: $0, inicio: inicio, duracion: segundos * 0.92)
            }
            inicio += segundos
        }
        return Escucha(notas: notas)
    }

    /// Acordes con sus alturas escritas (un coral a cuatro voces), uno detrás de otro.
    public static func coral(_ acordes: [[Altura]], duracion: Double = 1) -> Escucha {
        grupos(acordes, duracion: duracion)
    }

    /// El tempo de lo que tiene ritmo, si no se da otro: negra a 72.
    public static let tempo = Tempo(72)

    /// Una voz con su ritmo: los silencios callan, las notas ligadas suenan como una sola y los microtonos
    /// (`Evento.Nota.desvio`) suenan con sus cents.
    ///
    ///     Escucha.voz(try Voz(leyendo: "Do4:4 Re4:8 -:8 Mi4:2")).notas.map(\.inicio)   // [0, 0.83, 1.67]
    public static func voz(_ voz: Voz, tempo: Tempo = Escucha.tempo) -> Escucha {
        Escucha(
            notas: notas(de: voz, tempo: tempo).flatMap { nota in
                nota.evento.alturas.indices.map {
                    NotaMIDI(
                        altura: nota.evento.alturas[$0], inicio: nota.inicio, duracion: nota.duracion * 0.95,
                        microtono: nota.evento.notas[$0].desvio)
                }
            })
    }

    /// Acordes con sus alturas escritas que empiezan y duran lo que las notas de una voz: el coral de una
    /// melodía con ritmo. Si hay más acordes que notas, los que sobran no suenan.
    public static func coral(_ acordes: [[Altura]], conElRitmoDe voz: Voz, tempo: Tempo = Escucha.tempo) -> Escucha {
        Escucha(
            notas: zip(acordes, notas(de: voz, tempo: tempo)).flatMap { acorde, nota in
                acorde.map { NotaMIDI(altura: $0, inicio: nota.inicio, duracion: nota.duracion * 0.95) }
            })
    }

    /// Las notas de una voz (su evento) con su comienzo y su duración en segundos, sin los silencios; una nota
    /// ligada se alarga con la siguiente en lugar de volver a empezar.
    static func notas(de voz: Voz, tempo: Tempo) -> [(evento: Evento, inicio: Double, duracion: Double)] {
        var notas: [(evento: Evento, inicio: Double, duracion: Double)] = []
        var tiempo = 0.0
        var ligadaALaAnterior = false
        for evento in voz.eventos {
            let segundos = tempo.segundos(de: evento.duracion)
            if ligadaALaAnterior, !notas.isEmpty {
                notas[notas.count - 1].duracion += segundos
            } else if !evento.alturas.isEmpty {
                notas.append((evento, tiempo, segundos))
            }
            tiempo += segundos
            ligadaALaAnterior = evento.ligada
        }
        return notas
    }

    static func grupos(_ grupos: [[Altura]], duracion: Double) -> Escucha {
        Escucha(
            notas: grupos.enumerated().flatMap { i, alturas in
                alturas.map { NotaMIDI(altura: $0, inicio: duracion * Double(i), duracion: duracion * 0.92) }
            })
    }

    /// Las notas en posición cerrada: la primera en la octava que empieza en `base` y cada una por encima de
    /// la anterior, con su ortografía. Do Mi Sol desde 48 → Do3 Mi3 Sol3.
    static func cerrada(_ notas: [Nota], desde base: Int) -> [Altura] {
        var alturas: [Altura] = []
        for nota in notas {
            let suelo = (alturas.last.map { $0.midi + 1 }) ?? base
            let midi = suelo + ((nota.claseDeAltura - suelo) % 12 + 12) % 12
            // La misma clase de altura: la diferencia con la nota en la octava 4 es un número de octavas.
            alturas.append(Altura(nota, octava: 4 + (midi - Altura(nota, octava: 4).midi) / 12))
        }
        return alturas
    }
}
