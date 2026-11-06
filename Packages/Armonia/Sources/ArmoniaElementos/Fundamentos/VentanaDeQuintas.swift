// Doce quintas seguidas de la línea de quintas tienen una nota de cada clase de altura, así que cada tramo de doce es
// una manera de escribir la escala cromática: de Fa a La♯ con sostenidos, de Sol♭ a Si con bemoles, de Re♭ a Fa♯
// alrededor de Do… Es lo que se usa para nombrar una altura cuando no hay escala, tonalidad ni acorde que diga cómo
// se escribe (un número MIDI suelto, una casilla de un teclado, un traste).

/// Doce quintas seguidas de la línea de quintas: una escritura para cada clase de altura.
///
///     VentanaDeQuintas.sostenidos.nota(claseDeAltura: 10)        // La♯
///     VentanaDeQuintas.bemoles.nota(claseDeAltura: 10)           // Si♭
///     VentanaDeQuintas.centrada(en: "Re").nota(claseDeAltura: 1)  // Do♯
///     Altura(midi: 66, ventana: .centrada(en: "Fa"))             // Sol♭4
///
/// `Altura(midi:)` usa ``sostenidos``.
public struct VentanaDeQuintas: Hashable, Sendable, Codable {
    /// La posición en la línea de quintas de la primera nota (la más bemol): −1 es Fa.
    public let inicio: Int

    /// La ventana que empieza `inicio` quintas por encima de Do: `VentanaDeQuintas(inicio: -6)` va de Sol♭ a Si.
    public init(inicio: Int) {
        self.inicio = inicio
    }

    /// La ventana que empieza en esa nota: `VentanaDeQuintas(desde: "Re♭")` va de Re♭ a Fa♯.
    public init(desde primera: Nota) {
        self.init(inicio: primera.pasosDeQuinta)
    }

    /// Las doce quintas seguidas que contienen esas notas, con su escritura. Si puede ser, también las siete naturales
    /// (las ventanas de Sol♭–Si a Fa–La♯), para que una nota natural no cambie de nombre, y si no, las más que se
    /// pueda; entre ellas, la más centrada en las notas (su posición media en la línea de quintas) y, si hay dos igual
    /// de centradas, la más sostenida. `nil` si no hay notas o no caben en doce quintas, como Re♭ y Do♯.
    ///
    ///     VentanaDeQuintas(conteniendo: ["Do", "Mi", "Sol"])         // La♭–Do♯
    ///     VentanaDeQuintas(conteniendo: ["Do", "Mi", "Sol", "Si♭"])  // Re♭–Fa♯
    ///     VentanaDeQuintas(conteniendo: ["Do", "Mi♭"])               // Sol♭–Si
    ///     VentanaDeQuintas(conteniendo: ["Re"])                      // Mi♭–Sol♯, como .centrada(en: "Re")
    ///     VentanaDeQuintas(conteniendo: ["Fa♯", "La♯", "Do♯"])       // Fa–La♯
    ///     VentanaDeQuintas(conteniendo: ["Do♯", "Mi♯", "Sol♯"])      // Do–Mi♯: sin Fa, que no cabe
    public init?(conteniendo notas: some Sequence<Nota>) {
        let quintas = Set(notas.map(\.pasosDeQuinta))
        guard !quintas.isEmpty else { return nil }
        let centro = Double(quintas.reduce(0, +)) / Double(quintas.count)
        self.init(conteniendo: quintas, centro: centro, desempate: nil, conLasNaturales: true)
    }

    /// La de ``init(conteniendo:)`` con otro centro (el de una escala) y, antes de la más sostenida, otro desempate:
    /// la más cercana a esa posición. Sin `conLasNaturales`, no se miran las naturales.
    package init?(conteniendo quintas: Set<Int>, centro: Double, desempate: Double?, conLasNaturales: Bool) {
        guard let menor = quintas.min(), let mayor = quintas.max(), mayor - menor <= 11 else { return nil }
        func coste(_ inicio: Int) -> [Double] {
            // Cuántas naturales se quedan fuera: las ventanas de −6 a −1 tienen de Fa (−1) a Si (5).
            let fuera = conLasNaturales ? max(0, -6 - inicio, inicio + 1) : 0
            let medio = Double(inicio) + 5.5
            return [Double(fuera), abs(medio - centro), desempate.map { abs(medio - $0) } ?? 0, Double(-inicio)]
        }
        let inicio = ((mayor - 11)...menor).min { coste($0).lexicographicallyPrecedes(coste($1)) } ?? menor
        self.init(inicio: inicio)
    }

    /// Con sostenidos, de Fa a La♯: la escritura de `Altura(midi:)`.
    public static let sostenidos = VentanaDeQuintas(inicio: -1)

    /// Con bemoles, de Sol♭ a Si: la de los dibujos que piden bemoles.
    public static let bemoles = VentanaDeQuintas(inicio: -6)

    /// Con las menos alteraciones posibles, de Re♭ a Fa♯: cinco naturales y siete con un sostenido o un bemol como
    /// mucho, sin Mi♯, Si♯, Fa♭ ni Do♭. Las notas de `Nota.enarmonicaMasSimple`, y `.centrada(en: "Do")`.
    public static let masSimple = VentanaDeQuintas(inicio: -5)

    /// La de muchos cifrados y teclados, de Mi♭ a Sol♯: las negras del piano son Do♯, Mi♭, Fa♯, Sol♯ y Si♭.
    public static let habitual = VentanaDeQuintas(inicio: -3)

    /// La de la tonalidad mayor con esa armadura (+ sostenidos, − bemoles): sus siete notas, dos quintas por debajo y
    /// tres por encima. Sin alteraciones, de La♭ a Do♯ (Do♯, Mi♭, Fa♯, La♭ y Si♭, como escribe Do mayor sus
    /// cromatismos); con dos sostenidos, de Si♭ a Re♯; con tres bemoles, de Do♭ a Mi.
    public static func armadura(_ alteraciones: Int) -> VentanaDeQuintas {
        VentanaDeQuintas(inicio: alteraciones - 4)
    }

    /// La ventana con la tónica casi en medio, de cinco quintas por debajo a seis por encima: alrededor de Do, de Re♭
    /// a Fa♯ (las notas de `Nota.enarmonicaMasSimple`); alrededor de Re, de Mi♭ a Sol♯.
    public static func centrada(en tonica: Nota) -> VentanaDeQuintas {
        VentanaDeQuintas(inicio: tonica.pasosDeQuinta - 5)
    }

    /// La primera nota, la más bemol: Fa en ``sostenidos``.
    public var primera: Nota { Nota(pasosDeQuinta: inicio) }

    /// La última nota, la más sostenida: La♯ en ``sostenidos``.
    public var ultima: Nota { Nota(pasosDeQuinta: inicio + 11) }

    /// Las doce notas, por quintas de la primera a la última: Fa, Do, Sol… La♯ en ``sostenidos``.
    public var notas: [Nota] { (inicio...(inicio + 11)).map(Nota.init(pasosDeQuinta:)) }

    /// ¿Está esa nota, con su escritura, en la ventana? La♯ está en ``sostenidos``; Si♭, no.
    public func contiene(_ nota: Nota) -> Bool {
        (inicio...(inicio + 11)).contains(nota.pasosDeQuinta)
    }

    /// La nota de la ventana con esa clase de altura (0 es Do; se toma módulo 12, así que vale un número MIDI).
    public func nota(claseDeAltura clase: Int) -> Nota {
        // 7 es su propio inverso módulo 12: la clase c está a 7·c quintas de Do, módulo 12.
        Nota(pasosDeQuinta: inicio + modulo(clase * 7 - inicio, 12))
    }

    /// La misma nota escrita como la escribe la ventana: Si♭ → La♯ en ``sostenidos``.
    public func reescrita(_ nota: Nota) -> Nota {
        self.nota(claseDeAltura: nota.claseDeAltura)
    }

    /// La misma altura, que suena igual, escrita como la escribe la ventana: Si♭4 → La♯4 en ``sostenidos``; Si♯3 → Do4
    /// en ``masSimple``.
    public func reescrita(_ altura: Altura) -> Altura {
        Altura(midi: altura.midi, ventana: self)
    }
}

extension VentanaDeQuintas: CustomStringConvertible {
    /// La primera y la última nota: "Fa–La♯".
    public var description: String { "\(primera)–\(ultima)" }
}

extension Altura {
    /// Altura a partir de un número MIDI, escrita con la nota de esa clase que hay en la ventana:
    /// `Altura(midi: 70, ventana: .bemoles)` es Si♭4; `Altura(midi: 70, ventana: .sostenidos)`, La♯4.
    public init(midi: Int, ventana: VentanaDeQuintas) {
        let quintas = ventana.nota(claseDeAltura: midi).pasosDeQuinta
        // midi − 60 y 7·quintas son congruentes módulo 12, así que la división es exacta.
        self.init(pasosDeQuinta: quintas, pasosDeOctava: (midi - 60 - 7 * quintas) / 12)
    }
}
