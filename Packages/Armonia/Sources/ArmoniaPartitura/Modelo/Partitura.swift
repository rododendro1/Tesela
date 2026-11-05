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
    /// De qué es una partitura que se nombra por lo que se toca: una escala, una secuencia de estudio, un acorde, un
    /// arpegio o una progresión.
    public enum Tema: Hashable, Sendable, Codable {
        case escala(Escala)
        /// La escala tocada en una secuencia de estudio (``Escala/secuencia(_:octava:octavas:sentido:)``).
        case secuencia(SecuenciaDeEscala, de: Escala)
        case acorde(Acorde)
        case arpegio(Arpegio)
        /// Unos acordes, uno tras otro.
        case progresion([Acorde])

        /// Su nombre en una notación: el de la escala («Re dórico», «D Dorian»), con el de la secuencia («Do mayor ·
        /// terceras»), el cifrado del acorde, el nombre del arpegio o los cifrados de la progresión («Rem7 – Sol7 –
        /// Do7M»).
        public func nombre(en notacion: Notacion) -> String {
            switch self {
            case .escala(let escala): escala.nombre(en: notacion)
            case .secuencia(let secuencia, let escala):
                escala.nombre(en: notacion) + " · " + secuencia.nombre(en: notacion)
            case .acorde(let acorde): acorde.cifrado(en: notacion)
            case .arpegio(let arpegio): arpegio.nombre(en: notacion)
            case .progresion(let acordes): acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
            }
        }
    }

    /// El título de la obra, tal cual.
    public var titulo: String?
    /// De qué es, si se nombra por lo que se toca: sin `titulo`, el título es su nombre en la notación con que se
    /// dibuja o se exporta (`titulo(en:)`).
    public var tema: Tema?
    /// La de la armadura; `nil`, ninguna. Las funciones que hacen la partitura la estiman si no se da.
    public var tonalidad: Tonalidad?
    /// La indicación metronómica; si es `nil`, no se escribe (en MIDI, negra = 120).
    public var tempo: Tempo?
    /// El nombre de la parte (o del pentagrama, si es uno); si es `nil`, el que le dé quien hace la partitura
    /// («Voz», «Coro», «Piano»…).
    public var nombreDeLaParte: String?
    /// El programa General MIDI con que suena (0 = piano de cola … 127); si es `nil`, el que le dé quien hace la
    /// partitura (el piano, o el coro en un coral y en un contrapunto). Solo cuenta en MIDI.
    public var instrumento: Int?

    /// Un encabezado con lo que se dé; lo que no, lo pone quien hace la partitura.
    public init(
        titulo: String? = nil, tema: Tema? = nil, tonalidad: Tonalidad? = nil, tempo: Tempo? = nil,
        nombreDeLaParte: String? = nil, instrumento: Int? = nil
    ) {
        self.titulo = titulo
        self.tema = tema
        self.tonalidad = tonalidad
        self.tempo = tempo
        self.nombreDeLaParte = nombreDeLaParte
        self.instrumento = instrumento
    }

    /// El título en una notación: `titulo` si se da; si no, el nombre del tema en esa notación.
    ///
    ///     let encabezado = Encabezado(tema: .escala(Escala("Re dórico")))
    ///     encabezado.titulo(en: .espanolCompacto)   // "Re dórico"; en otra notación, en esa
    public func titulo(en notacion: Notacion) -> String? { titulo ?? tema?.nombre(en: notacion) }
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
public struct Partitura: Hashable, Sendable, Codable {
    /// Una voz de la partitura con lo que se anota en ella.
    public struct Linea: Hashable, Sendable, Codable {
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
        public var dedos: [Duracion: [Int]]
        /// La cuerda y el traste de cada nota, en la tablatura del pentagrama (`Pentagrama.numeroDeCuerdas`): debajo en SVG, y
        /// en un pentagrama de tablatura en MusicXML.
        public var pulsaciones: [Duracion: [Tablatura.Pulsacion]]
        /// La nota desde la que se cuentan los intervalos de las notas (`marcas.intervalosDeLasNotas`) donde no suena
        /// ningún acorde: la tónica de una escala. Si es `nil`, la de la armadura `.tonalidad`. Solo cuenta en SVG.
        public var tonica: Nota?

        /// La voz con lo que se anota en ella, cada cosa por el punto de la voz en que empieza.
        public init(
            _ voz: Voz, nombre: String? = nil, plicaArriba: Bool? = nil, cifrados: [Duracion: Acorde] = [:],
            analisis: [Duracion: AcordeAnalizado] = [:], marcadores: [Duracion: String] = [:],
            grados: [Duracion: String] = [:], bajoCifrado: [Duracion: [String]] = [:], dedos: [Duracion: [Int]] = [:],
            pulsaciones: [Duracion: [Tablatura.Pulsacion]] = [:], tonica: Nota? = nil
        ) {
            self.voz = voz
            self.nombre = nombre
            self.plicaArriba = plicaArriba
            self.cifrados = cifrados
            self.analisis = analisis
            self.marcadores = marcadores
            self.grados = grados
            self.bajoCifrado = bajoCifrado
            self.dedos = dedos
            self.pulsaciones = pulsaciones
            self.tonica = tonica
        }
    }

    /// Un pentagrama con sus voces y su clave.
    public struct Pentagrama: Hashable, Sendable, Codable {
        /// Si es `nil`, la de sol o la de fa, la que pidan sus notas.
        public var clave: Clave?
        public var voces: [Linea]
        /// Cuántas cuerdas tiene la tablatura que va debajo, con las `pulsaciones` de su primera voz; `nil`, sin
        /// tablatura. En SVG va debajo del pentagrama; en MusicXML, en un pentagrama de tablatura aparte.
        public var numeroDeCuerdas: Int?
        /// Las notas de una armadura propia (la de Re dórico, con Do mayor), que se escribe si las opciones dejan la
        /// armadura en `.automatica` y el encabezado no da tonalidad, como en `Escala.svgPentagrama()`. Solo cuenta
        /// en SVG, con una voz en el pentagrama.
        public var armadura: [Nota]?
        /// Cómo suena cada cuerda de la tablatura al aire, sin el capo, en el orden de sus cuerdas
        /// (``Tablatura/afinacion``), si se sabe. MusicXML la escribe.
        public var afinacion: [Altura]?
        /// El traste del capo de la tablatura (``Tablatura/capo``), si lo hay. MusicXML lo escribe.
        public var capo: Int?

        /// Un pentagrama con esas voces, en esa clave (si no se da, la que mejor va a sus alturas: `claveEscrita`) y,
        /// con `numeroDeCuerdas`, con una tablatura de esas cuerdas debajo, con su afinación y su capo si se saben.
        public init(
            clave: Clave? = nil, voces: [Linea], numeroDeCuerdas: Int? = nil, armadura: [Nota]? = nil,
            afinacion: [Altura]? = nil, capo: Int? = nil
        ) {
            self.clave = clave
            self.voces = voces
            self.numeroDeCuerdas = numeroDeCuerdas
            self.armadura = armadura
            self.afinacion = afinacion
            self.capo = capo
        }

        /// Un pentagrama con esas voces y debajo esa tablatura: sus cuerdas, su afinación y su capo.
        public init(clave: Clave? = nil, voces: [Linea], tablatura: Tablatura?, armadura: [Nota]? = nil) {
            self.init(
                clave: clave, voces: voces, numeroDeCuerdas: tablatura?.numeroDeCuerdas, armadura: armadura,
                afinacion: tablatura?.afinacion, capo: tablatura?.capo)
        }

        /// La clave con que se escribe: la suya, la del instrumento de la tablatura o la que pidan sus notas.
        public var claveEscrita: Clave {
            clave ?? claveDelInstrumento
                ?? Clave.masAdecuada(para: voces.flatMap { $0.voz.eventos.flatMap(\.alturas) }) ?? .sol
        }

        /// La clave en que se escribe el instrumento de la tablatura: la de sol octava baja si su cuerda más grave
        /// está entre el Si1 y el Do3, como en la guitarra, que se escribe una octava más aguda de lo que suena;
        /// si no, o sin afinación, `nil`.
        public var claveDelInstrumento: Clave? {
            guard numeroDeCuerdas != nil, let grave = afinacion?.map(\.midi).min() else { return nil }
            return (35..<48).contains(grave) ? .solOctavaBaja : nil
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
    /// La notación de la partitura: la de los cifrados, la tonalidad del análisis y el título que se nombra por su
    /// tema (``Encabezado/tema``), al exportarla y al dibujarla; en SVG, también la de los nombres de las notas.
    /// `OpcionesDePentagrama(notacion:)` dibuja con otra.
    public var notacion: Notacion
    /// Si los pentagramas se unen con una llave, como el piano; si no, con un corchete. Solo cuenta en SVG.
    public var llave: Bool
    /// Si se dibuja el ritmo. Con `false`, un pentagrama de una voz va con cada evento en su columna, sin plicas,
    /// cifra de compás ni barras, como los acordes de `init(acordes:titulo:…)`. Solo cuenta en SVG.
    public var dibujaElRitmo: Bool

    /// Una partitura con esos pentagramas. Si no se dan `compas` y `anacrusa`, los de la primera voz.
    public init(
        pentagramas: [Pentagrama], encabezado: Encabezado = Encabezado(), compas: Compas? = nil,
        anacrusa: Duracion? = nil, tonalidadDelAnalisis: Tonalidad? = nil, notacion: Notacion = .espanolCompacto,
        llave: Bool = false, dibujaElRitmo: Bool = true
    ) {
        let primera = pentagramas.lazy.flatMap(\.voces).first?.voz
        self.pentagramas = pentagramas
        self.encabezado = encabezado
        self.compas = compas ?? primera?.compas ?? .compasillo
        self.anacrusa = anacrusa ?? primera?.anacrusa ?? .cero
        self.tonalidadDelAnalisis = tonalidadDelAnalisis
        self.notacion = notacion
        self.llave = llave
        self.dibujaElRitmo = dibujaElRitmo
    }

    /// Acordes con sus alturas escritas (las disposiciones de `Acorde.disposiciones(_:en:)` o de
    /// `DisposicionDeAcorde.conducir(_:en:)`), uno por columna y sin ritmo (``dibujaElRitmo``), sin armadura (salvo la de
    /// `.tonalidad` en las opciones): en dos pentagramas si las notas pasan a los dos lados del Do central y con uno
    /// harían falta más de tres líneas adicionales. En MusicXML, MIDI y los demás formatos, cada acorde es una redonda.
    ///
    ///     let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
    ///     let voces = DisposicionDeAcorde.drop2.conducir(progresion) ?? []
    ///     let svg = Partitura(acordes: voces, titulo: "ii–V–I", porEvento: .init(cifrados: .enOrden(progresion))).svg()
    ///
    /// Sin `titulo`, el de la partitura son los cifrados («Rem7 – Sol7 – Do7M»: el tema
    /// ``Encabezado/Tema/progresion(_:)``), en orden de columna y en la notación con que se dibuja o se exporta; sin
    /// cifrados, ninguno.
    ///
    /// Lo que se anota va en `porEvento`, por columna (contada desde 0; `.enOrden(_:)` da una por columna). Con
    /// `cifrados`, cada columna lleva encima su cifrado, y los intervalos de las notas (`intervalosDeLasNotas`) se
    /// cuentan desde la fundamental de su acorde. Con `grados` (como los de `AnalisisArmonico.cifrados`) o `analisis`,
    /// debajo, su grado en números romanos; con `dedos`, el dedo de cada nota encima (de la grave a la aguda), y con
    /// `tablatura`, la cuerda y el traste debajo (sus pulsaciones, si `porEvento` no trae las suyas). Con `bajoCifrado`
    /// (como los de `Tonalidad.cifrasDeBajo(de:)`), las cifras del bajo continuo debajo de todo, una encima de otra.
    public init(
        acordes: [[Altura]], titulo: String? = nil, porEvento: AnotacionesPorEvento = AnotacionesPorEvento(),
        tablatura: Tablatura? = nil
    ) {
        let voz = Voz(acordes.map { Evento(alturas: $0, duracion: .redonda) })
        var anotaciones = porEvento
        if anotaciones.pulsaciones.isEmpty { anotaciones.pulsaciones = tablatura?.pulsaciones ?? [:] }
        let cifrados = anotaciones.cifrados.keys.sorted().compactMap { anotaciones.cifrados[$0] }
        self.init(
            pentagramas: [Pentagrama(voces: [Linea(voz, porEvento: anotaciones)], tablatura: tablatura)],
            encabezado: Encabezado(titulo: titulo, tema: cifrados.isEmpty ? nil : .progresion(cifrados)),
            dibujaElRitmo: false)
    }

    /// El nombre de la parte: el del encabezado o «Voz».
    public var nombreDeLaParte: String { encabezado.nombreDeLaParte ?? "Voz" }

    /// El programa General MIDI: el del encabezado o el piano (0).
    public var instrumento: Int { encabezado.instrumento ?? 0 }

    /// Todas las voces, de arriba abajo, con el índice de su pentagrama (desde 0, el de arriba).
    public var lineas: [LineaEnElPentagrama] {
        pentagramas.enumerated().flatMap { p, pentagrama in
            pentagrama.voces.map { LineaEnElPentagrama(linea: $0, pentagrama: p) }
        }
    }

    /// Una voz de la partitura y el índice de su pentagrama (desde 0): lo que da ``lineas``.
    public struct LineaEnElPentagrama: Hashable, Sendable {
        public let linea: Linea
        /// El índice del pentagrama, desde 0 (el de arriba).
        public let pentagrama: Int

        /// Una línea en el pentagrama con ese índice (0 es el de arriba).
        public init(linea: Linea, pentagrama: Int) {
            self.linea = linea
            self.pentagrama = pentagrama
        }
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
    public init(
        _ linea: Linea, clave: Clave? = nil, numeroDeCuerdas: Int? = nil, encabezado: Encabezado = Encabezado()
    ) {
        self.init(
            pentagramas: [Pentagrama(clave: clave, voces: [linea], numeroDeCuerdas: numeroDeCuerdas)],
            encabezado: encabezado)
    }
}

/// Se codifica con los campos que tiene, y sin los que faltan.
extension Encabezado: Codable {}

extension Partitura {
    /// Unas notas tocadas una tras otra (con sus microtonos, si los tienen), con lo que se anota en cada una (por su
    /// índice), con su ``Ritmo``. Es lo que hacen `Escala.partitura(tocadaEn:…)` y `Acorde.partitura(arpegiadoEn:…)`.
    static func tocada(
        _ notas: [Evento.NotaDelEvento], titulo: String? = nil, tema: Encabezado.Tema, ritmo: Ritmo = .libre,
        porEvento: AnotacionesPorEvento = AnotacionesPorEvento(), tablatura: Tablatura? = nil, acorde: Acorde?,
        tonica: Nota?, armadura: [Nota]?
    ) -> Partitura {
        tocada(
            juntas: notas.map { [$0] }, titulo: titulo, tema: tema, ritmo: ritmo, porEvento: porEvento,
            tablatura: tablatura, acorde: acorde, tonica: tonica, armadura: armadura)
    }

    /// Como `tocada(_:…)`, con las notas de cada evento juntas: todas las de un acorde en uno. El cifrado de
    /// `acorde` va en la primera nota, si `porEvento` no le da otro, y las pulsaciones de `tablatura`, si `porEvento` no
    /// trae las suyas.
    static func tocada(
        juntas notas: [[Evento.NotaDelEvento]], titulo: String? = nil, tema: Encabezado.Tema, ritmo: Ritmo = .libre,
        porEvento anotaciones: AnotacionesPorEvento = AnotacionesPorEvento(), tablatura: Tablatura? = nil,
        acorde: Acorde?, tonica: Nota?, armadura: [Nota]?
    ) -> Partitura {
        let voz = Voz(
            notas.indices.map { Evento(notas: notas[$0], duracion: ritmo.duracion(de: $0, entre: notas.count)) })
        var porEvento = anotaciones
        if let acorde, porEvento.cifrados[0] == nil { porEvento.cifrados[0] = acorde }
        if porEvento.pulsaciones.isEmpty { porEvento.pulsaciones = tablatura?.pulsaciones ?? [:] }
        let linea = Linea(voz, porEvento: porEvento, tonica: tonica)
        return Partitura(
            pentagramas: [Pentagrama(voces: [linea], tablatura: tablatura, armadura: armadura)],
            encabezado: Encabezado(titulo: titulo, tema: tema), dibujaElRitmo: ritmo != .libre)
    }
}
