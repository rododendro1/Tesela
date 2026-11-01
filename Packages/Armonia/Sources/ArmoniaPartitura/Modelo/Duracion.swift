import ArmoniaNucleo
import ArmoniaTeoria

// Ritmo: figuras, duraciones exactas y tempo. Los compases están en Compas.swift, los eventos
// (notas con duración) en Evento.swift y las voces, que encadenan eventos en un compás, en
// Melodia.swift.
//
// Las duraciones son fracciones exactas de redonda (una negra es 1/4, una corchea con
// puntillo 3/16, una corchea de tresillo 1/12), así que sumar, comparar y repartir en
// compases nunca acumula errores de redondeo.

// MARK: - Figura

/// Figuras musicales, de la cuadrada (dos redondas) a la garrapatea (1/128).
public enum Figura: Int, CaseIterable, Hashable, Sendable, CustomStringConvertible {
    case cuadrada = -1
    case redonda, blanca, negra, corchea, semicorchea, fusa, semifusa, garrapatea

    /// Duración en redondas: blanca → 1/2, negra → 1/4, cuadrada → 2.
    public var duracion: Duracion {
        rawValue < 0 ? Duracion(2) : Duracion(1, 1 << rawValue)
    }

    public var description: String { nombre }
}

extension Figura: Nombrable {}

// MARK: - Duración

/// Duración exacta, como fracción de redonda (siempre reducida).
///
///     Duracion.negra                       // 1/4
///     Duracion(.negra, puntillos: 1)       // 3/8, «negra con puntillo»
///     Duracion.corchea.grupoIrregular(3, en: 2)   // 1/12, corchea de tresillo
///     Duracion("8.")                       // corchea con puntillo
///     Duracion.blanca + .corchea           // 5/8
///     (Duracion.blanca + .corchea).descomposicion   // [blanca, corchea] (para ligar)
public struct Duracion: Hashable, Sendable, Comparable {
    public let numerador: Int
    public let denominador: Int

    /// `numerador/denominador` redondas, o `nil` si el denominador es 0. Si el denominador viene de fuera, usa esta
    /// variante: `init(_:_:)` detiene el programa en ese caso.
    public init?(comprobando numerador: Int, _ denominador: Int) {
        guard denominador != 0 else { return nil }
        self.init(numerador, denominador)
    }

    /// Figura con puntillos, o `nil` si el número de puntillos no está entre 0 y 30.
    public init?(comprobando figura: Figura, puntillos: Int) {
        guard (0...30).contains(puntillos) else { return nil }
        self.init(figura, puntillos: puntillos)
    }

    /// `numerador/denominador` redondas; se reduce y el signo queda en el numerador. Detiene el programa si el
    /// denominador es 0 (un error de quien llama): `init?(comprobando:_:)` devuelve `nil`.
    public init(_ numerador: Int, _ denominador: Int = 1) {
        precondition(denominador != 0, "una duración no puede tener denominador 0")
        let divisor = max(1, maximoComunDivisor(numerador, denominador))
        let signo = denominador < 0 ? -1 : 1
        self.numerador = signo * numerador / divisor
        self.denominador = abs(denominador) / divisor
    }

    /// Figura con puntillos: cada puntillo añade la mitad de lo anterior
    /// (negra con puntillo = 3/8, con doble puntillo = 7/16).
    public init(_ figura: Figura, puntillos: Int = 0) {
        precondition(puntillos >= 0, "el número de puntillos no puede ser negativo")
        self = figura.duracion * Duracion((1 << (puntillos + 1)) - 1, 1 << puntillos)
    }

    /// Lee una figura al estilo de LilyPond ("1" redonda, "4" negra, "8." corchea con puntillo,
    /// "2.." blanca con doble puntillo) o una fracción de redonda ("3/8", "1/12", "2/1").
    public init(leyendo texto: String) throws {
        let limpio = texto.trimmingEspacios()
        let error = ErrorDeLectura(texto: texto, posicion: nil, motivo: .duracionNoValida(limpio))
        if let barra = limpio.firstIndex(of: "/") {
            guard let numerador = Int(limpio[..<barra]), let denominador = Int(limpio[limpio.index(after: barra)...]),
                numerador >= 0, denominador > 0
            else { throw error }
            self.init(numerador, denominador)
            return
        }
        let cifras = limpio.cifrasIniciales
        let puntos = limpio.dropFirst(cifras.count)
        guard let divisor = Int(cifras), divisor > 0, divisor & (divisor - 1) == 0, divisor <= 128,
            puntos.allSatisfy({ $0 == "." }), let figura = Figura(rawValue: divisor.trailingZeroBitCount)
        else { throw error }
        self.init(figura, puntillos: puntos.count)
    }

    // MARK: Constantes

    public static let cero = Duracion(0)
    public static let cuadrada = Figura.cuadrada.duracion
    public static let redonda = Figura.redonda.duracion
    public static let blanca = Figura.blanca.duracion
    public static let negra = Figura.negra.duracion
    public static let corchea = Figura.corchea.duracion
    public static let semicorchea = Figura.semicorchea.duracion
    public static let fusa = Figura.fusa.duracion
    public static let semifusa = Figura.semifusa.duracion
    public static let garrapatea = Figura.garrapatea.duracion

    // MARK: Propiedades

    /// Valor en redondas como número decimal: negra → 0,25.
    public var enRedondas: Double { Double(numerador) / Double(denominador) }

    public var esCero: Bool { numerador == 0 }

    /// La figura y los puntillos con que se escribe, si se puede escribir con una sola figura
    /// (hasta cuatro puntillos): 3/8 → (negra, 1). `nil` para 5/8 o 1/12.
    public var figuraYPuntillos: (figura: Figura, puntillos: Int)? {
        for puntillos in 0...4 {
            for figura in Figura.allCases where Duracion(figura, puntillos: puntillos) == self {
                return (figura, puntillos)
            }
        }
        return nil
    }

    /// Figuras sin puntillo que, ligadas, suman esta duración (de mayor a menor), si la duración
    /// es binaria: 5/8 → [blanca, corchea]; 3/8 → [negra con puntillo]. `nil` para duraciones de
    /// grupos irregulares (1/12) o menores que una garrapatea.
    public var descomposicion: [Duracion]? {
        guard numerador > 0 else { return numerador == 0 ? [] : nil }
        if figuraYPuntillos != nil { return [self] }
        guard denominador & (denominador - 1) == 0, denominador <= 128 else { return nil }
        var resto = self
        var partes: [Duracion] = []
        for figura in Figura.allCases {
            while figura.duracion <= resto {
                partes.append(figura.duracion)
                resto = resto - figura.duracion
            }
        }
        return resto.esCero ? partes : nil
    }

    // MARK: Operaciones

    /// Duración de cada nota de un grupo irregular de `n` notas en el tiempo de `m`:
    /// `Duracion.corchea.grupoIrregular(3, en: 2)` (tresillo) → 1/12;
    /// `Duracion.semicorchea.grupoIrregular(5, en: 4)` (quintillo) → 1/20.
    public func grupoIrregular(_ n: Int, en m: Int) -> Duracion { self * Duracion(m, n) }

    /// Pulsos MIDI con la resolución dada: `Duracion.corchea.ticks(porNegra: 480)` → 240.
    /// `nil` si no sale un número entero.
    public func ticks(porNegra resolucion: Int) -> Int? {
        let total = numerador * 4 * resolucion
        return total % denominador == 0 ? total / denominador : nil
    }

    public static func + (a: Duracion, b: Duracion) -> Duracion {
        Duracion(a.numerador * b.denominador + b.numerador * a.denominador, a.denominador * b.denominador)
    }
    public static func - (a: Duracion, b: Duracion) -> Duracion {
        Duracion(a.numerador * b.denominador - b.numerador * a.denominador, a.denominador * b.denominador)
    }
    public static func * (a: Duracion, b: Duracion) -> Duracion {
        Duracion(a.numerador * b.numerador, a.denominador * b.denominador)
    }
    public static func * (a: Duracion, n: Int) -> Duracion { Duracion(a.numerador * n, a.denominador) }
    public static func * (n: Int, a: Duracion) -> Duracion { a * n }
    public static func / (a: Duracion, n: Int) -> Duracion { Duracion(a.numerador, a.denominador * n) }
    /// Cuántas veces cabe `b` en `a` (como fracción): blanca / negra → 2.
    public static func / (a: Duracion, b: Duracion) -> Duracion {
        Duracion(a.numerador * b.denominador, a.denominador * b.numerador)
    }
    public static func < (a: Duracion, b: Duracion) -> Bool {
        a.numerador * b.denominador < b.numerador * a.denominador
    }
}

extension Duracion: CustomStringConvertible {
    /// El nombre, como en los demás tipos: "negra con puntillo", "5/8 de redonda".
    /// La forma corta para escribir y leer ("4.", "5/8") es `texto`.
    public var description: String { nombre }
}

extension Duracion: RepresentableComoTexto, Nombrable {
    /// "4", "8.", "2.."; si no es una figura de redonda o menor, la fracción ("5/8", "1/12", "2/1").
    public func texto(en notacion: Notacion) -> String {
        if let escritura = figuraYPuntillos, escritura.figura != .cuadrada {
            return "\(1 << escritura.figura.rawValue)" + String(repeating: ".", count: escritura.puntillos)
        }
        return "\(numerador)/\(denominador)"
    }
}

extension Sequence where Element == Duracion {
    /// Suma de las duraciones.
    public func sumar() -> Duracion { reduce(.cero, +) }
}

// MARK: - Tempo

/// Velocidad: cuántas unidades (negras, por defecto) caben en un minuto.
///
///     let t = Tempo(120)
///     t.segundos(de: .blanca)              // 1
///     Tempo(60, unidad: Duracion(.negra, puntillos: 1)).negrasPorMinuto   // 90
///     Tempo(100).indicacion                // "Andante"
public struct Tempo: Hashable, Sendable, CustomStringConvertible {
    public let pulsosPorMinuto: Double
    public let unidad: Duracion

    /// Como `init(_:unidad:)`, pero devuelve `nil` si la velocidad o la unidad no son positivas.
    public init?(comprobando pulsosPorMinuto: Double, unidad: Duracion = .negra) {
        guard pulsosPorMinuto > 0, unidad > .cero else { return nil }
        self.init(pulsosPorMinuto, unidad: unidad)
    }

    /// Detiene el programa si la velocidad o la unidad no son positivas: con datos de fuera,
    /// `init?(comprobando:unidad:)`.
    public init(_ pulsosPorMinuto: Double, unidad: Duracion = .negra) {
        precondition(pulsosPorMinuto > 0 && unidad > .cero, "el tempo tiene que ser positivo")
        self.pulsosPorMinuto = pulsosPorMinuto
        self.unidad = unidad
    }

    /// Lo que dura una duración, en segundos.
    public func segundos(de duracion: Duracion) -> Double {
        (duracion / unidad).enRedondas * 60 / pulsosPorMinuto
    }

    /// El mismo tempo expresado en negras por minuto.
    public var negrasPorMinuto: Double { pulsosPorMinuto * (unidad / .negra).enRedondas }

    /// Indicación italiana aproximada según las negras por minuto (los márgenes varían según
    /// la época y el metrónomo): Grave < 40 ≤ Largo < 60 ≤ Larghetto < 66 ≤ Adagio < 76 ≤
    /// Andante < 108 ≤ Moderato < 120 ≤ Allegro < 168 ≤ Presto < 200 ≤ Prestissimo.
    public var indicacion: String {
        let tabla: [(Double, String)] = [
            (40, "Grave"), (60, "Largo"), (66, "Larghetto"), (76, "Adagio"),
            (108, "Andante"), (120, "Moderato"), (168, "Allegro"), (200, "Presto"),
        ]
        return tabla.first { negrasPorMinuto < $0.0 }?.1 ?? "Prestissimo"
    }

    /// "♩ = 120" o, con otra unidad, "negra con puntillo = 60".
    public var description: String {
        let cifra =
            pulsosPorMinuto.rounded() == pulsosPorMinuto
            ? String(Int(pulsosPorMinuto)) : String(pulsosPorMinuto)
        return (unidad == .negra ? "♩" : unidad.nombre) + " = " + cifra
    }
}

// MARK: - Idiomas
//
// Nombres de las figuras y de las duraciones en los quince idiomas de los textos (`Traduccion`). El resto de nombres que dependen del idioma, en `Fundamentos/Nota.swift` y `Fundamentos/Intervalo.swift`.

// MARK: - Figura

extension Figura {
    /// En español, "negra"; en inglés, el nombre estadounidense ("quarter note").
    public func nombre(en notacion: Notacion) -> String { Figura.nombres[rawValue + 1].en(notacion) }

    private static let nombres: [Traduccion] = [
        TextosDePartitura.traduccion(\.cuadrada),
        TextosDePartitura.traduccion(\.redonda),
        TextosDePartitura.traduccion(\.blanca),
        TextosDePartitura.traduccion(\.negra),
        TextosDePartitura.traduccion(\.corchea),
        TextosDePartitura.traduccion(\.semicorchea),
        TextosDePartitura.traduccion(\.fusa),
        TextosDePartitura.traduccion(\.semifusa),
        TextosDePartitura.traduccion(\.garrapatea),
    ]
}

// MARK: - Duracion

extension Duracion {
    /// "negra", "corchea con puntillo", "blanca con doble puntillo"; si no es una figura,
    /// la fracción: "5/8 de redonda". La duración nula es "cero".
    public func nombre(en notacion: Notacion) -> String {
        if esCero { return TextosDePartitura.en(notacion, \.cero) }
        guard let escritura = figuraYPuntillos else {
            let fraccion = "\(numerador)/\(denominador)"
            return TextosDePartitura.en(notacion) { $0.fraccionDeRedonda(fraccion) }
        }
        let figura = escritura.figura.nombre(en: notacion)
        let puntillos = escritura.puntillos
        guard puntillos > 0 else { return figura }
        return Duracion.conPuntillos.en(notacion)[puntillos - 1].rellenada(con: figura)
    }
}

extension Duracion {
    /// La figura con uno, dos, tres o cuatro puntillos, en el sitio de `_`.
    private static let conPuntillos = TextosDePartitura.traduccion(\.conPuntillos)
}
