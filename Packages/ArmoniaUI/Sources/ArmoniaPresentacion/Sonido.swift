import Armonia

/// Lo que suena al pulsar «Escuchar» en las apps: notas MIDI con su inicio y su duración, en segundos. Aquí solo
/// se decide qué suena, cuándo y con qué afinación; el reproductor de ArmoniaUI lo toca con el sintetizador del
/// sistema.
///
///     Sonido.acorde(Acorde("Sol7/Si")).notas.map(\.midi)   // [59, 62, 65, 67]: Si3 Re4 Fa4 Sol4
///
/// Cada nota guarda su altura escrita, así que `afinado(en:)` puede afinar Sol♯ y La♭ de forma distinta en un
/// temperamento que los distinga.
public struct Sonido: Hashable, Sendable {
    /// Una nota que suena: su altura (y su número MIDI), cuándo empieza, cuánto dura y cuánto se aparta, en
    /// cents, del temperamento igual.
    public struct NotaMIDI: Hashable, Sendable {
        public let altura: Altura
        public let inicio: Double
        public let duracion: Double
        /// Cents por encima (o por debajo) de la nota MIDI en temperamento igual con La4 = 440.
        public var desviacion: Double

        public var midi: Int { altura.midi }

        public init(altura: Altura, inicio: Double, duracion: Double, desviacion: Double = 0) {
            self.altura = altura
            self.inicio = inicio
            self.duracion = duracion
            self.desviacion = desviacion
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
    public func conTonica(_ tonica: Nota?) -> Sonido {
        Sonido(notas: notas, tonica: tonica)
    }

    /// Lo mismo, con cada nota afinada en `temperamento` (la justa, sobre la tónica, o sobre Do si no se conoce).
    ///
    ///     Sonido.acorde(Acorde("Do")).afinado(en: .justa).notas.map { Int($0.desviacion.rounded()) }   // [0, -14, 2]
    public func afinado(en temperamento: Temperamento) -> Sonido {
        let afinacion = temperamento.afinacion(tonica: tonica ?? .do)
        return Sonido(notas: notas.map { nota in
            var afinada = nota
            afinada.desviacion = afinacion.desviacion(de: nota.altura)
            return afinada
        }, tonica: tonica)
    }

    /// Nada que tocar.
    public static let silencio = Sonido(notas: [])

    /// Cuánto dura todo, en segundos.
    public var duracion: Double { notas.map { $0.inicio + $0.duracion }.max() ?? 0 }

    /// Los comienzos y finales de las notas, por orden de tiempo. A un mismo tiempo, los finales van antes,
    /// para que una nota repetida vuelva a sonar.
    public var cambios: [Cambio] {
        notas.enumerated().flatMap { i, nota in
            [Cambio(tiempo: nota.inicio, midi: nota.midi, esInicio: true, nota: i, desviacion: nota.desviacion),
             Cambio(tiempo: nota.inicio + nota.duracion, midi: nota.midi, esInicio: false, nota: i, desviacion: nota.desviacion)]
        }
            .sorted { ($0.tiempo, $0.esInicio ? 1 : 0) < ($1.tiempo, $1.esInicio ? 1 : 0) }
    }

    // MARK: Lo que tocan las apps

    /// Una nota sola: la que se toca en un dibujo.
    public static func nota(_ midi: Int, duracion: Double = 0.8) -> Sonido {
        Sonido(notas: [NotaMIDI(midi: midi, inicio: 0, duracion: duracion)])
    }

    /// Una nota escrita sola.
    public static func nota(_ altura: Altura, duracion: Double = 0.8) -> Sonido {
        Sonido(notas: [NotaMIDI(altura: altura, inicio: 0, duracion: duracion)])
    }

    /// Un acorde desde su bajo, en posición cerrada a partir de Do3: primero arpegiado y luego junto. Su tónica
    /// es la fundamental.
    public static func acorde(_ acorde: Acorde) -> Sonido {
        let alturas = cerrada(acorde.notasDesdeElBajo, desde: 48)
        let paso = 0.12
        let final = paso * Double(alturas.count)
        return Sonido(notas: alturas.enumerated().map { i, altura in
            NotaMIDI(altura: altura, inicio: paso * Double(i), duracion: final - paso * Double(i) + 1.2)
        }, tonica: acorde.fundamental)
    }

    /// Una escala de la tónica a su octava, desde la tónica en la octava 4, y vuelta a la tónica.
    public static func escala(_ escala: Escala) -> Sonido {
        let subida = cerrada(escala.notas, desde: 60)
        guard let tonica = subida.first else { return .silencio }
        let alturas = subida + [tonica + .octava]
        let paso = 0.3
        return Sonido(notas: alturas.enumerated().map { i, altura in
            NotaMIDI(altura: altura, inicio: paso * Double(i), duracion: paso * 0.9)
        }, tonica: escala.tonica)
    }

    /// Una progresión, un acorde detrás de otro, cada uno desde su bajo a partir de Do3.
    public static func acordes(_ acordes: [Acorde], duracion: Double = 1) -> Sonido {
        grupos(acordes.map { cerrada($0.notasDesdeElBajo, desde: 48) }, duracion: duracion)
    }

    /// Acordes con sus alturas escritas (un coral a cuatro voces), uno detrás de otro.
    public static func coral(_ acordes: [[Altura]], duracion: Double = 1) -> Sonido {
        grupos(acordes, duracion: duracion)
    }

    /// El tempo de lo que tiene ritmo, si no se da otro: negra a 72.
    public static let tempo = Tempo(72)

    /// Una voz con su ritmo: los silencios callan y las notas ligadas suenan como una sola.
    ///
    ///     Sonido.voz(try Voz(leyendo: "Do4:4 Re4:8 -:8 Mi4:2")).notas.map(\.inicio)   // [0, 0.83, 1.67]
    public static func voz(_ voz: Voz, tempo: Tempo = Sonido.tempo) -> Sonido {
        Sonido(notas: notas(de: voz, tempo: tempo).flatMap { nota in
            nota.alturas.map { NotaMIDI(altura: $0, inicio: nota.inicio, duracion: nota.duracion * 0.95) }
        })
    }

    /// Acordes con sus alturas escritas que empiezan y duran lo que las notas de una voz: el coral de una
    /// melodía con ritmo. Si hay más acordes que notas, los que sobran no suenan.
    public static func coral(_ acordes: [[Altura]], conElRitmoDe voz: Voz, tempo: Tempo = Sonido.tempo) -> Sonido {
        Sonido(notas: zip(acordes, notas(de: voz, tempo: tempo)).flatMap { acorde, nota in
            acorde.map { NotaMIDI(altura: $0, inicio: nota.inicio, duracion: nota.duracion * 0.95) }
        })
    }

    /// Las notas de una voz con su comienzo y su duración en segundos, sin los silencios; una nota ligada
    /// se alarga con la siguiente en lugar de volver a empezar.
    static func notas(de voz: Voz, tempo: Tempo) -> [(alturas: [Altura], inicio: Double, duracion: Double)] {
        var notas: [(alturas: [Altura], inicio: Double, duracion: Double)] = []
        var tiempo = 0.0
        var ligadaALaAnterior = false
        for evento in voz.eventos {
            let segundos = tempo.segundos(de: evento.duracion)
            if ligadaALaAnterior, !notas.isEmpty {
                notas[notas.count - 1].duracion += segundos
            } else if !evento.alturas.isEmpty {
                notas.append((evento.alturas, tiempo, segundos))
            }
            tiempo += segundos
            ligadaALaAnterior = evento.ligada
        }
        return notas
    }

    static func grupos(_ grupos: [[Altura]], duracion: Double) -> Sonido {
        Sonido(notas: grupos.enumerated().flatMap { i, alturas in
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
