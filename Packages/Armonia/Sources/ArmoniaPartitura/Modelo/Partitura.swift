import ArmoniaNucleo
import ArmoniaTeoria

// La partitura: lo que se escribe en cualquier formato (MusicXML, MEI, LilyPond, GUIDO, ABC, MIDI) y se dibuja en
// SVG. Una voz, un coral, una progresión analizada y un contrapunto saben hacer la suya (`voz.partitura(…)`,
// `coral.partitura(…)`…, en ArmoniaFormatos), y cada formato tiene un solo escritor, que la lee entera: las funciones
// de antes (`voz.musicXML(…)`, `coral.midi(…)`…) siguen, como atajos de `partitura(…)` y el formato.

// MARK: - Encabezado

/// Lo que va al principio de una partitura y vale para toda ella: el título, la armadura, el tempo, el nombre de la
/// parte y el instrumento con que suena en MIDI.
///
///     let encabezado = Encabezado(titulo: "Escala", tonalidad: Tonalidad(.re), tempo: Tempo(90))
public struct Encabezado: Hashable, Sendable {
    /// El título de la obra.
    public var titulo: String?
    /// La de la armadura; `nil`, ninguna. Las funciones que hacen la partitura la estiman si no se da.
    public var tonalidad: Tonalidad?
    /// La indicación metronómica; si es `nil`, no se escribe (en MIDI, negra = 120).
    public var tempo: Tempo?
    /// El nombre de la parte (o del pentagrama, si es uno).
    public var parte: String
    /// El programa General MIDI con que suena (0 = piano de cola … 127); solo cuenta en MIDI.
    public var instrumento: Int

    public init(
        titulo: String? = nil, tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, parte: String = "Voz",
        instrumento: Int = 0
    ) {
        self.titulo = titulo
        self.tonalidad = tonalidad
        self.tempo = tempo
        self.parte = parte
        self.instrumento = instrumento
    }
}

// MARK: - Partitura

/// Una partitura: uno o más pentagramas, de arriba abajo, con una o más voces cada uno, el encabezado, el compás y
/// lo que se anota en las voces (cifrados encima, análisis debajo).
///
///     let soprano = try Voz(leyendo: "Mi5:2 Re5:2")
///     let bajo = try Voz(leyendo: "Do3:2 Sol2:2")
///     let partitura = Partitura(
///         pentagramas: [.init(clave: .sol, voces: [.init(soprano)]), .init(clave: .fa, voces: [.init(bajo)])],
///         encabezado: Encabezado(titulo: "Dos voces"))
///     partitura.musicXML()   // en ArmoniaFormatos; también mei(), lilyPond(), guido(), abc(), midi() y svg()
public struct Partitura: Hashable, Sendable {
    /// Una voz de la partitura con lo que se anota en ella.
    public struct Linea: Hashable, Sendable {
        public var voz: Voz
        /// El nombre de su pista en MIDI; si es `nil`, el de la parte.
        public var nombre: String?
        /// `nil` si la plica va donde toque; si no, hacia arriba o hacia abajo (con dos voces en un pentagrama).
        public var plicaArriba: Bool?
        /// El acorde que se cifra encima de la nota que empieza en cada punto de la voz (contado desde su
        /// principio).
        public var cifrados: [Duracion: Acorde]
        /// El análisis (cifrado romano y función) que se escribe debajo de la nota que empieza en cada punto.
        public var analisis: [Duracion: AcordeAnalizado]
        /// Los marcadores de MIDI (los que los secuenciadores muestran al sonar), por el punto en que empiezan.
        public var marcadores: [Duracion: String]

        public init(
            _ voz: Voz, nombre: String? = nil, plicaArriba: Bool? = nil, cifrados: [Duracion: Acorde] = [:],
            analisis: [Duracion: AcordeAnalizado] = [:], marcadores: [Duracion: String] = [:]
        ) {
            self.voz = voz
            self.nombre = nombre
            self.plicaArriba = plicaArriba
            self.cifrados = cifrados
            self.analisis = analisis
            self.marcadores = marcadores
        }
    }

    /// Un pentagrama con sus voces y su clave.
    public struct Pentagrama: Hashable, Sendable {
        /// Si es `nil`, la de sol o la de fa, la que pidan sus notas.
        public var clave: Clave?
        public var voces: [Linea]

        public init(clave: Clave? = nil, voces: [Linea]) {
            self.clave = clave
            self.voces = voces
        }

        /// La clave con que se escribe: la suya o la que pidan sus notas.
        public var claveEscrita: Clave {
            clave ?? Clave.masAdecuada(para: voces.flatMap { $0.voz.eventos.flatMap(\.alturas) }) ?? .sol
        }
    }

    /// De arriba abajo.
    public var pentagramas: [Pentagrama]
    public var encabezado: Encabezado
    /// El compás y la anacrusa con que se miden todas las voces (si no se dan, los de la primera).
    public var compas: Compas
    public var anacrusa: Duracion
    /// La tonalidad que se escribe al principio, debajo del último pentagrama, si se analiza («Do:»).
    public var tonalidadDelAnalisis: Tonalidad?
    /// La de los cifrados y de la tonalidad del análisis.
    public var notacion: Notacion
    /// Si los pentagramas se unen con una llave, como el piano; si no, con un corchete. Solo cuenta en SVG.
    public var llave: Bool

    public init(
        pentagramas: [Pentagrama], encabezado: Encabezado = Encabezado(), compas: Compas? = nil,
        anacrusa: Duracion? = nil, tonalidadDelAnalisis: Tonalidad? = nil, notacion: Notacion = .espanolCompacto,
        llave: Bool = false
    ) {
        let primera = pentagramas.lazy.flatMap(\.voces).first?.voz
        self.pentagramas = pentagramas
        self.encabezado = encabezado
        self.compas = compas ?? primera?.compas ?? .compasillo
        self.anacrusa = anacrusa ?? primera?.anacrusa ?? .cero
        self.tonalidadDelAnalisis = tonalidadDelAnalisis
        self.notacion = notacion
        self.llave = llave
    }

    /// Todas las voces, de arriba abajo, con el número de su pentagrama (desde 1).
    public var lineas: [(linea: Linea, pentagrama: Int)] {
        pentagramas.enumerated().flatMap { p, pentagrama in pentagrama.voces.map { ($0, p + 1) } }
    }
}
