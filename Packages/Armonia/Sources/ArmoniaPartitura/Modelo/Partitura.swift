import ArmoniaNucleo
import ArmoniaTeoria

// La partitura: lo que se escribe en cualquier formato (MusicXML, MEI, LilyPond, GUIDO, ABC, MIDI) y se dibuja en
// SVG. Una voz, un coral, una progresión analizada y un contrapunto saben hacer la suya (`voz.partitura(…)`,
// `coral.partitura(…)`…, en ArmoniaFormatos), y cada formato tiene un solo escritor, que la lee entera:
// `voz.partitura().musicXML()`, `coral.partitura(duracion: .blanca).midi()`.

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
    /// El nombre de la parte (o del pentagrama, si es uno); si es `nil`, el que le dé quien hace la partitura
    /// («Voz», «Coro», «Piano»…).
    public var parte: String?
    /// El programa General MIDI con que suena (0 = piano de cola … 127); si es `nil`, el que le dé quien hace la
    /// partitura (el piano, o el coro en un coral y en un contrapunto). Solo cuenta en MIDI.
    public var instrumento: Int?

    public init(
        titulo: String? = nil, tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, parte: String? = nil,
        instrumento: Int? = nil
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
///     partitura.musicXML()   // en ArmoniaFormatos, con mei(), lilyPond(), guido(), abc() y midi(); svg(), aquí
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
        /// El grado en números romanos («V7/V») que se escribe debajo de la nota que empieza en cada punto, si no lo
        /// da `analisis`. Solo cuenta en SVG.
        public var grados: [Duracion: String]
        /// Las cifras del bajo continuo («6», «4») que van debajo del grado. Solo cuenta en SVG.
        public var bajoCifrado: [Duracion: [String]]
        /// El dedo de cada nota (de la grave a la aguda; 0, ninguno), encima. Solo cuenta en SVG.
        public var digitos: [Duracion: [Int]]
        /// La cuerda y el traste de cada nota, en la tablatura del pentagrama (`Pentagrama.cuerdas`). Solo cuenta en
        /// SVG.
        public var pulsaciones: [Duracion: [Tablatura.Pulsacion]]

        public init(
            _ voz: Voz, nombre: String? = nil, plicaArriba: Bool? = nil, cifrados: [Duracion: Acorde] = [:],
            analisis: [Duracion: AcordeAnalizado] = [:], marcadores: [Duracion: String] = [:],
            grados: [Duracion: String] = [:], bajoCifrado: [Duracion: [String]] = [:], digitos: [Duracion: [Int]] = [:],
            pulsaciones: [Duracion: [Tablatura.Pulsacion]] = [:]
        ) {
            self.voz = voz
            self.nombre = nombre
            self.plicaArriba = plicaArriba
            self.cifrados = cifrados
            self.analisis = analisis
            self.marcadores = marcadores
            self.grados = grados
            self.bajoCifrado = bajoCifrado
            self.digitos = digitos
            self.pulsaciones = pulsaciones
        }
    }

    /// Un pentagrama con sus voces y su clave.
    public struct Pentagrama: Hashable, Sendable {
        /// Si es `nil`, la de sol o la de fa, la que pidan sus notas.
        public var clave: Clave?
        public var voces: [Linea]
        /// Las cuerdas de la tablatura que va debajo, con las `pulsaciones` de su primera voz; `nil`, sin
        /// tablatura. Solo cuenta en SVG.
        public var cuerdas: Int?

        public init(clave: Clave? = nil, voces: [Linea], cuerdas: Int? = nil) {
            self.clave = clave
            self.voces = voces
            self.cuerdas = cuerdas
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

    /// El nombre de la parte: el del encabezado o «Voz».
    public var parte: String { encabezado.parte ?? "Voz" }

    /// El programa General MIDI: el del encabezado o el piano (0).
    public var instrumento: Int { encabezado.instrumento ?? 0 }

    /// Todas las voces, de arriba abajo, con el número de su pentagrama (desde 1).
    public var lineas: [(linea: Linea, pentagrama: Int)] {
        pentagramas.enumerated().flatMap { p, pentagrama in pentagrama.voces.map { ($0, p + 1) } }
    }
}

// MARK: - De los eventos a los puntos en que empiezan

extension Voz {
    /// Dónde empieza cada evento, contado desde el principio de la voz (sin la anacrusa).
    ///
    ///     try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2").inicios   // [0, 1/4, 3/8, 1/2]
    public var inicios: [Duracion] {
        var momento = Duracion.cero
        return eventos.map { evento in
            defer { momento = momento + evento.duracion }
            return momento
        }
    }

    /// Lo que se tenía por evento (por su índice, desde 0), por el punto en que empieza cada uno, como lo anota una
    /// `Partitura.Linea`. Los índices que no son de ningún evento se descartan.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
    ///     voz.porInicio([0: Acorde("Do"), 2: Acorde("Sol")])   // [0: Do, 1/2: Sol]
    public func porInicio<Valor>(_ porEvento: [Int: Valor]) -> [Duracion: Valor] {
        let inicios = self.inicios
        var resultado: [Duracion: Valor] = [:]
        for (i, valor) in porEvento where inicios.indices.contains(i) { resultado[inicios[i]] = valor }
        return resultado
    }
}

extension Partitura {
    /// Una voz sola en un pentagrama, con lo que se anota en ella, tal cual: sin la tonalidad que no dé el
    /// encabezado (`voz.partitura(…)`, en ArmoniaFormatos, la estima).
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
    ///     let svg = Partitura(.init(voz, cifrados: [.cero: Acorde("Do")]), encabezado: Encabezado(titulo: "Do")).svg()
    public init(_ linea: Linea, clave: Clave? = nil, cuerdas: Int? = nil, encabezado: Encabezado = Encabezado()) {
        self.init(pentagramas: [Pentagrama(clave: clave, voces: [linea], cuerdas: cuerdas)], encabezado: encabezado)
    }
}
