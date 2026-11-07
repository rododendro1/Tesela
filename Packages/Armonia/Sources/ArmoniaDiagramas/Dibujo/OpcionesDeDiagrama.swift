import ArmoniaElementos

// Lo que comparten los dibujos SVG que no son pentagramas (el Tonnetz, la tabla armónica, los teclados isomórficos y
// cuadrados, el teclado de piano y el reloj de clases): cómo se escriben las notas, el título y el tamaño, y qué
// notas se marcan. Lo propio de cada dibujo (las casillas, el margen, la leyenda) va en su `svg`.

/// Las opciones de un diagrama: `Tonnetz(Acorde("Do")).svg(opciones: .init(notacion: .inglesASCII, escala: 1.5))`.
public struct OpcionesDeDiagrama: Hashable, Sendable {
    /// Cómo se escriben los nombres de las notas y el título que pone el dibujo.
    public var notacion: Notacion
    /// Cómo se nombran las notas donde el dibujo no sabe cómo se escriben (en los teclados isomórficos y cuadrados,
    /// el teclado de piano y el reloj): con ``VentanaDeQuintas/sostenidos`` (La♯), con ``VentanaDeQuintas/bemoles``
    /// (Si♭) o con cualquier otra ventana, como `.centrada(en: "Fa")`.
    public var ventana: VentanaDeQuintas
    /// Si el teclado de piano y el reloj nombran, en `notacion`, las notas a las que no se da rótulo: las marcadas
    /// del piano y las doce horas del reloj. Con `false`, como antes: el piano las marca sin texto y el reloj
    /// escribe el número de cada clase (0 es Do; 11, Si).
    public var nombresDeLasNotas: Bool
    /// El título: si es `nil`, el que ponga el dibujo (el acorde o la escala en el Tonnetz y la tabla; ninguno en
    /// los teclados, el piano y el reloj); si es "", ninguno.
    public var titulo: String?
    /// El tamaño, como factor del de siempre: 2 lo dibuja el doble de grande.
    public var escala: Double

    public init(
        notacion: Notacion = .espanolCompacto, ventana: VentanaDeQuintas = .sostenidos, nombresDeLasNotas: Bool = true,
        titulo: String? = nil, escala: Double = 1
    ) {
        self.notacion = notacion
        self.ventana = ventana
        self.nombresDeLasNotas = nombresDeLasNotas
        self.titulo = titulo
        self.escala = escala
    }
}

/// Las notas que se marcan en un diagrama, por su número MIDI, cada una con su rótulo si lo lleva (un dedo, un
/// grado): `[60, 64, 67]` las marca sin rótulo; `[60: "1", 62: "2"]`, con él. Marcadas con sus alturas, se nombran
/// como se escriben: `MarcasDeDiagrama(Escala("Fa mayor").alturas(octava: 4))` pone Si♭ y no La♯.
public struct MarcasDeDiagrama: Hashable, Sendable, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    /// Las notas marcadas.
    public private(set) var notas: Set<Int>
    /// El rótulo de las que lo llevan.
    public private(set) var rotulos: [Int: String]
    /// Cómo se escriben las que se marcaron con su altura, por su número MIDI.
    public private(set) var alturas: [Int: Altura]

    /// Ninguna nota.
    public init() { self.init([Int]()) }

    /// Esas notas, sin rótulo.
    public init(_ notas: some Sequence<Int>) {
        self.notas = Set(notas)
        self.rotulos = [:]
        self.alturas = [:]
    }

    /// Esas alturas, sin rótulo, nombradas como se escriben (la primera, si dos suenan igual).
    public init(_ alturas: some Sequence<Altura>) {
        let alturas = Array(alturas)
        self.notas = Set(alturas.map(\.midi))
        self.rotulos = [:]
        self.alturas = Dictionary(alturas.map { ($0.midi, $0) }) { primera, _ in primera }
    }

    /// Esas notas, cada una con su rótulo.
    public init(rotulos: [Int: String]) {
        self.notas = Set(rotulos.keys)
        self.rotulos = rotulos
        self.alturas = [:]
    }

    public init(arrayLiteral notas: Int...) { self.init(notas) }

    public init(dictionaryLiteral rotulos: (Int, String)...) {
        self.init(rotulos: Dictionary(rotulos) { primero, _ in primero })
    }

    /// ¿Se marca esa nota?
    public func contains(_ nota: Int) -> Bool { notas.contains(nota) }

    /// El rótulo de esa nota, si se marca con uno.
    public func rotulo(de nota: Int) -> String? { rotulos[nota] }

    /// La altura con que se marcó esa nota, si se marcó con la suya.
    public func altura(de nota: Int) -> Altura? { alturas[nota] }

    public var isEmpty: Bool { notas.isEmpty }
}

extension OpcionesDeDiagrama {
    /// La altura con que se nombra una nota (por su número MIDI): la de `marcas`, si se marcó con la suya, o la que
    /// dé `ventana`.
    func altura(de midi: Int, en marcas: MarcasDeDiagrama = []) -> Altura {
        marcas.altura(de: midi) ?? Altura(midi: midi, ventana: ventana)
    }

    /// El nombre de la nota sin octava, en `notacion`: el que ponen el piano y el reloj a las notas sin rótulo.
    func nombre(de midi: Int, en marcas: MarcasDeDiagrama = []) -> String {
        altura(de: midi, en: marcas).nota.nombreCompacto(en: notacion)
    }
}
