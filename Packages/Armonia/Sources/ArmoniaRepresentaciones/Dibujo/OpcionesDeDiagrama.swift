import ArmoniaNucleo

// Lo que comparten los dibujos SVG que no son pentagramas (el Tonnetz, la tabla armónica, los teclados isomórficos y
// cuadrados, el teclado de piano y el reloj de clases): cómo se escriben las notas, el título y el tamaño, y qué
// notas se marcan. Lo propio de cada dibujo (las casillas, el margen, la leyenda) va en su `svg`.

/// Las opciones de un diagrama: `Tonnetz(Acorde("Do")).svg(opciones: .init(notacion: .inglesASCII, escala: 1.5))`.
public struct OpcionesDeDiagrama: Hashable, Sendable {
    /// Cómo se escriben los nombres de las notas y el título que pone el dibujo. El teclado de piano y el reloj no
    /// nombran notas por sí solos: sus rótulos llegan escritos.
    public var notacion: Notacion
    /// Si las notas negras del piano se nombran con bemol (Si♭) y no con sostenido (La♯), donde el dibujo no sabe
    /// cuál es (en los teclados isomórficos y cuadrados).
    public var preferirBemoles: Bool
    /// El título: si es `nil`, el que ponga el dibujo (el acorde o la escala en el Tonnetz y la tabla; ninguno en
    /// los teclados, el piano y el reloj); si es "", ninguno.
    public var titulo: String?
    /// El tamaño, como factor del de siempre: 2 lo dibuja el doble de grande.
    public var escala: Double

    public init(
        notacion: Notacion = .espanolCompacto, preferirBemoles: Bool = false, titulo: String? = nil,
        escala: Double = 1
    ) {
        self.notacion = notacion
        self.preferirBemoles = preferirBemoles
        self.titulo = titulo
        self.escala = escala
    }
}

/// Las notas que se marcan en un diagrama, por su número MIDI, cada una con su rótulo si lo lleva (un dedo, un
/// grado): `[60, 64, 67]` las marca sin rótulo; `[60: "1", 62: "2"]`, con él.
public struct MarcasDeDiagrama: Hashable, Sendable, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    /// Las notas marcadas.
    public private(set) var notas: Set<Int>
    /// El rótulo de las que lo llevan.
    public private(set) var rotulos: [Int: String]

    /// Ninguna nota.
    public init() { self.init([Int]()) }

    /// Esas notas, sin rótulo.
    public init(_ notas: some Sequence<Int>) {
        self.notas = Set(notas)
        self.rotulos = [:]
    }

    /// Esas notas, cada una con su rótulo.
    public init(rotulos: [Int: String]) {
        self.notas = Set(rotulos.keys)
        self.rotulos = rotulos
    }

    public init(arrayLiteral notas: Int...) { self.init(notas) }

    public init(dictionaryLiteral rotulos: (Int, String)...) {
        self.init(rotulos: Dictionary(rotulos) { primero, _ in primero })
    }

    /// ¿Se marca esa nota?
    public func contains(_ nota: Int) -> Bool { notas.contains(nota) }

    /// El rótulo de esa nota, si se marca con uno.
    public func rotulo(de nota: Int) -> String? { rotulos[nota] }

    public var isEmpty: Bool { notas.isEmpty }
}
