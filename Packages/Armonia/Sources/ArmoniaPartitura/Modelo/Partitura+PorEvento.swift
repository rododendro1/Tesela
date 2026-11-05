import ArmoniaNucleo
import ArmoniaTeoria

// Lo que se anota evento a evento y el ritmo de unas notas tocadas una tras otra: la forma en que lo dan las escalas, los
// arpegios, las disposiciones y las digitaciones del mástil, que cuentan las notas y no los puntos de la voz.

extension Partitura {
    /// Lo que se anota en una voz, evento a evento: cada cosa por el índice de su evento, contando desde 0. Es la forma en
    /// que lo dan las escalas, los arpegios y el mástil; una ``Linea`` lo guarda por el punto en que empieza cada
    /// evento, y ``Linea/init(_:porEvento:nombre:plicaArriba:tonica:)`` y ``Linea/porEvento`` pasan de una forma a la
    /// otra.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
    ///     let linea = Partitura.Linea(voz, porEvento: .init(cifrados: [0: Acorde("Do")], dedos: [2: [5]]))
    ///     linea.dedos   // [1/2: [5]]: el dedo de la tercera nota, por donde empieza
    public struct AnotacionesPorEvento: Hashable, Sendable {
        /// El acorde que se cifra encima de cada nota.
        public var cifrados: [Int: Acorde]
        /// El análisis (cifrado romano y función) que se escribe debajo.
        public var analisis: [Int: AcordeAnalizado]
        /// Los marcadores de MIDI (los que los secuenciadores muestran al sonar).
        public var marcadores: [Int: String]
        /// El grado, en números romanos, debajo.
        public var grados: [Int: String]
        /// Las cifras del bajo continuo, de arriba abajo.
        public var bajoCifrado: [Int: [String]]
        /// Los dedos, de la nota más grave a la más aguda.
        public var dedos: [Int: [Int]]
        /// La cuerda y el traste de cada nota, en la tablatura (``Tablatura/notas``).
        public var pulsaciones: [Int: [Tablatura.Pulsacion]]

        /// Lo que se anota en cada nota, por su índice.
        public init(
            cifrados: [Int: Acorde] = [:], analisis: [Int: AcordeAnalizado] = [:], marcadores: [Int: String] = [:],
            grados: [Int: String] = [:], bajoCifrado: [Int: [String]] = [:], dedos: [Int: [Int]] = [:],
            pulsaciones: [Int: [Tablatura.Pulsacion]] = [:]
        ) {
            self.cifrados = cifrados
            self.analisis = analisis
            self.marcadores = marcadores
            self.grados = grados
            self.bajoCifrado = bajoCifrado
            self.dedos = dedos
            self.pulsaciones = pulsaciones
        }
    }

    /// El ritmo de unas notas tocadas una tras otra (una escala, un arpegio, una posición del mástil): sin él, cada
    /// nota en una redonda y sin ritmo en el dibujo (``Partitura/dibujaElRitmo``); uniforme, todas con la misma
    /// duración y la última, una negra si esa duración es más corta.
    ///
    ///     Escala(.re, .dorico).partitura(ritmo: .uniforme(.corchea))   // en corcheas
    public enum Ritmo: Hashable, Sendable {
        /// Sin ritmo: cada nota en su columna, en una redonda.
        case libre
        /// Todas las notas con esa duración, y la última, una negra si la duración es más corta.
        case uniforme(Duracion)

        /// La duración de todas las notas, o `nil` sin ritmo.
        public var uniforme: Duracion? {
            guard case .uniforme(let duracion) = self else { return nil }
            return duracion
        }

        /// La duración de la nota `i` (desde 0) de unas `total` tocadas una tras otra: una redonda sin ritmo; con un
        /// ritmo uniforme, su duración, y una negra en la última si es más corta.
        public func duracion(de i: Int, entre total: Int) -> Duracion {
            guard let uniforme else { return .redonda }
            let ultima = i == total - 1 && total > 1
            return ultima && uniforme < .negra ? .negra : uniforme
        }
    }
}

extension Partitura.Linea {
    /// La voz con lo que se anota en cada nota, por su índice (``Partitura/AnotacionesPorEvento``), llevado al punto en
    /// que empieza cada evento. Los índices que no son de ningún evento se descartan.
    public init(
        _ voz: Voz, porEvento anotaciones: Partitura.AnotacionesPorEvento, nombre: String? = nil,
        plicaArriba: Bool? = nil, tonica: Nota? = nil
    ) {
        self.init(
            voz, nombre: nombre, plicaArriba: plicaArriba, cifrados: voz.porInicio(anotaciones.cifrados),
            analisis: voz.porInicio(anotaciones.analisis), marcadores: voz.porInicio(anotaciones.marcadores),
            grados: voz.porInicio(anotaciones.grados), bajoCifrado: voz.porInicio(anotaciones.bajoCifrado),
            dedos: voz.porInicio(anotaciones.dedos), pulsaciones: voz.porInicio(anotaciones.pulsaciones),
            tonica: tonica)
    }

    /// Lo que se anota en la voz, evento a evento (por el índice de cada evento): lo que no empieza con ningún evento
    /// no está.
    public var porEvento: Partitura.AnotacionesPorEvento {
        Partitura.AnotacionesPorEvento(
            cifrados: voz.porEvento(cifrados), analisis: voz.porEvento(analisis),
            marcadores: voz.porEvento(marcadores), grados: voz.porEvento(grados),
            bajoCifrado: voz.porEvento(bajoCifrado), dedos: voz.porEvento(dedos),
            pulsaciones: voz.porEvento(pulsaciones))
    }
}

extension Dictionary where Key == Int {
    /// Uno por nota (o por columna), en orden: el primero para la 0, el segundo para la 1… Es la forma de dar en
    /// ``Partitura/AnotacionesPorEvento`` una lista con algo para cada nota.
    ///
    ///     Partitura.AnotacionesPorEvento(cifrados: .enOrden([Acorde("Do"), Acorde("Sol7")]))   // [0: Do, 1: Sol7]
    public static func enOrden(_ valores: [Value]) -> [Int: Value] {
        Dictionary(uniqueKeysWithValues: valores.enumerated().map { ($0.offset, $0.element) })
    }
}

extension Voz {
    /// Lo que se tenía por el punto en que empieza cada evento, por su índice (desde 0): lo contrario de
    /// ``porInicio(_:)``. Lo que no empieza con ningún evento se descarta.
    ///
    ///     let voz = try Voz(leyendo: "Do4:4 Mi4:4 Sol4:2")
    ///     voz.porEvento([.cero: Acorde("Do"), .blanca: Acorde("Sol")])   // [0: Do, 2: Sol]
    public func porEvento<Valor>(_ porInicio: [Duracion: Valor]) -> [Int: Valor] {
        var resultado: [Int: Valor] = [:]
        for (i, inicio) in inicios.enumerated() { resultado[i] = porInicio[inicio] }
        return resultado
    }
}
