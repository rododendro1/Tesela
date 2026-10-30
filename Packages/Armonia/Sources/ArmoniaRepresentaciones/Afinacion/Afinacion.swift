import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Afinaciones y temperamentos.
//
// Las coordenadas (quintas, octavas) encajan de forma natural con los temperamentos
// regulares: en todos ellos la octava es pura y todas las quintas miden lo mismo, así que
// una nota queda afinada con un solo número, el tamaño de la quinta:
//
//     cents(nota) = quintas · quinta + octavas · 1200      (desde Do4)
//
// Con quinta = 700 sale el temperamento igual; con 701,955, el pitagórico; con
// 696,578 (¼ de coma), el mesotónico, cuyas terceras mayores son puras.

/// Una forma de dar frecuencia a cada nota.
public protocol Afinacion: Sendable {
    func frecuencia(de nota: Altura) -> Double
}

extension Afinacion {
    /// Distancia en cents entre dos notas en esta afinación.
    public func cents(desde a: Altura, hasta b: Altura) -> Double {
        1200 * log2(frecuencia(de: b) / frecuencia(de: a))
    }

    /// Cuánto se aparta una nota (en cents) de la misma nota en temperamento igual con La4 = 440.
    public func desviacion(de nota: Altura) -> Double {
        1200 * log2(frecuencia(de: nota) / nota.frecuencia())
    }
}

extension Altura {
    /// Frecuencia en una afinación cualquiera: `nota.frecuencia(en: .mesotonicoCuartoDeComa)`.
    public func frecuencia(en afinacion: some Afinacion) -> Double {
        afinacion.frecuencia(de: self)
    }
}

// MARK: - Temperamentos regulares

/// Temperamento regular: octava pura y todas las quintas del mismo tamaño.
public struct TemperamentoRegular: Afinacion, Hashable {
    public let nombre: String
    /// Tamaño de la quinta en cents.
    public let quinta: Double
    /// Frecuencia del La4 de referencia.
    public let la4: Double

    public init(nombre: String, quinta: Double, la4: Double = 440) {
        self.nombre = nombre
        self.quinta = quinta
        self.la4 = la4
    }

    /// Cents desde Do4.
    public func cents(de nota: Altura) -> Double {
        Double(nota.pasosDeQuinta) * quinta + Double(nota.pasosDeOctava) * 1200
    }

    /// Tamaño de un intervalo en cents (con signo).
    public func cents(de intervalo: Intervalo) -> Double {
        Double(intervalo.pasosDeQuintaConSigno) * quinta + Double(intervalo.pasosDeOctavaConSigno) * 1200
    }

    public func frecuencia(de nota: Altura) -> Double {
        // La4 está en (3, −1).
        la4 * pow(2, (cents(de: nota) - cents(de: .la440)) / 1200)
    }

    /// El mismo temperamento con otra frecuencia de referencia: `.igual.afinar(la4: 415)`.
    public func afinar(la4 frecuencia: Double) -> TemperamentoRegular {
        TemperamentoRegular(nombre: nombre, quinta: quinta, la4: frecuencia)
    }

    /// Temperamento igual de `divisiones` partes por octava, con la quinta en el paso más cercano
    /// a la quinta pura: `.igual(divisiones: 12)` es `.igual`; 19, 31 (casi mesotónico),
    /// 53 (casi pitagórico).
    public static func igual(divisiones: Int, la4: Double = 440) -> TemperamentoRegular {
        let pasos = (Double(divisiones) * log2(1.5)).rounded()
        return TemperamentoRegular(nombre: "\(divisiones) divisiones iguales",
                                   quinta: 1200 * pasos / Double(divisiones), la4: la4)
    }

    /// Mesotónico de 1/`fraccion` de coma sintónica: cada quinta se estrecha esa parte de la coma.
    public static func mesotonico(fraccionDeComa fraccion: Double, la4: Double = 440) -> TemperamentoRegular {
        let pura = 1200 * log2(1.5)
        let coma = 1200 * log2(81.0 / 80.0)
        return TemperamentoRegular(nombre: "mesotónico de 1/\(Int(fraccion)) de coma",
                                   quinta: pura - coma / fraccion, la4: la4)
    }

    public static let igual = TemperamentoRegular(nombre: "temperamento igual", quinta: 700)
    public static let pitagorico = TemperamentoRegular(nombre: "pitagórico", quinta: 1200 * log2(1.5))
    /// Terceras mayores puras (5/4).
    public static let mesotonicoCuartoDeComa = mesotonico(fraccionDeComa: 4)
    /// Terceras menores puras (6/5).
    public static let mesotonicoTercioDeComa = mesotonico(fraccionDeComa: 3)
    public static let mesotonicoSextoDeComa = mesotonico(fraccionDeComa: 6)
}

// MARK: - Temperamentos circulares

/// Temperamento circular (un «buen temperamento» del Barroco): octava pura y doce quintas de
/// tamaños distintos que cierran el círculo. Todas las tonalidades se pueden tocar, pero cada una
/// tiene su color: las cercanas a Do, con terceras mayores casi puras; las lejanas, más tensas.
///
/// Al contrario que en un temperamento regular, las notas enarmónicas suenan igual (Sol♯ y La♭
/// son la misma tecla): hay doce sonidos por octava, y cada nota se afina por su número MIDI.
///
///     TemperamentoCircular.werckmeisterIII.cents(de: "Sol4")    // 696,09: Do–Sol, ¼ de coma más estrecha
///     TemperamentoCircular.werckmeisterIII.desviaciones[4]       // −9,78: Mi, más grave que en el igual
///     Altura("La4").frecuencia(en: TemperamentoCircular.vallotti)   // 440
public struct TemperamentoCircular: Afinacion, Hashable {
    public let nombre: String
    /// Las doce quintas en cents, en el orden del círculo desde Do: Do–Sol, Sol–Re, Re–La, La–Mi,
    /// Mi–Si, Si–Fa♯, Fa♯–Do♯, Do♯–Sol♯, Sol♯–Mi♭, Mi♭–Si♭, Si♭–Fa y Fa–Do. Suman siete octavas.
    public let quintas: [Double]
    /// Frecuencia del La4 de referencia.
    public let la4: Double
    /// Cents de cada nota desde Do, por clase de altura (Do = 0, Do♯ = 1… Si = 11).
    public let clases: [Double]

    /// `nil` si no son doce quintas o si no suman siete octavas (8400 cents, con una centésima de
    /// cent de margen): entonces el círculo no se cierra.
    public init?(nombre: String, quintas: [Double], la4: Double = 440) {
        guard quintas.count == 12, abs(quintas.reduce(0, +) - 8400) < 0.01 else { return nil }
        self.nombre = nombre
        self.quintas = quintas
        self.la4 = la4
        var clases = Array(repeating: 0.0, count: 12)
        var cents = 0.0
        for k in 0..<12 {
            clases[modulo(7 * k, 12)] = cents - 1200 * (cents / 1200).rounded(.down)
            cents += quintas[k]
        }
        self.clases = clases
    }

    /// Cuánto se aparta cada clase de altura (Do = 0… Si = 11) del temperamento igual, en cents,
    /// tomando Do como referencia.
    public var desviaciones: [Double] { clases.indices.map { clases[$0] - 100 * Double($0) } }

    /// Cents desde Do4. Las notas enarmónicas dan lo mismo.
    public func cents(de nota: Altura) -> Double {
        clases[modulo(nota.midi, 12)] + 1200 * Double(divisionEntera(nota.midi, 12) - 5)
    }

    public func frecuencia(de nota: Altura) -> Double {
        la4 * pow(2, (cents(de: nota) - cents(de: .la440)) / 1200)
    }

    /// El mismo temperamento con otra frecuencia de referencia.
    public func afinar(la4 frecuencia: Double) -> TemperamentoCircular {
        TemperamentoCircular(nombre: nombre, quintas: quintas, la4: frecuencia)!
    }

    /// Doce quintas puras, de las que se estrecha cada una lo que diga `estrechamientos` (en cents).
    private static func circulo(_ nombre: String, _ estrechamientos: [Int: Double]) -> TemperamentoCircular {
        let pura = 1200 * log2(1.5)
        return TemperamentoCircular(nombre: nombre,
                                    quintas: (0..<12).map { pura - (estrechamientos[$0] ?? 0) })!
    }

    private static let comaPitagorica = RazonDeFrecuencias.comaPitagorica.cents
    private static let comaSintonica = RazonDeFrecuencias.comaSintonica.cents

    /// Werckmeister III (1691): Do–Sol, Sol–Re, Re–La y Si–Fa♯, ¼ de coma pitagórica más
    /// estrechas; las demás, puras.
    public static let werckmeisterIII = circulo("Werckmeister III", [0: comaPitagorica / 4, 1: comaPitagorica / 4,
                                                                    2: comaPitagorica / 4, 5: comaPitagorica / 4])
    /// Kirnberger III (1779): de Do a Mi, cuatro quintas ¼ de coma sintónica más estrechas, con la
    /// tercera Do–Mi pura; Fa♯–Do♯, un esquisma más estrecha; las demás, puras.
    public static let kirnbergerIII = circulo("Kirnberger III", [0: comaSintonica / 4, 1: comaSintonica / 4,
                                                                2: comaSintonica / 4, 3: comaSintonica / 4,
                                                                6: comaPitagorica - comaSintonica])
    /// Vallotti (h. 1750): de Fa a Si, seis quintas ⅙ de coma pitagórica más estrechas; las demás, puras.
    public static let vallotti = circulo("Vallotti", Dictionary(uniqueKeysWithValues: [11, 0, 1, 2, 3, 4].map { ($0, comaPitagorica / 6) }))
    /// Young (1799): el de Vallotti, una quinta más arriba, de Do a Fa♯.
    public static let young = circulo("Young", Dictionary(uniqueKeysWithValues: (0...5).map { ($0, comaPitagorica / 6) }))
}

// MARK: - Afinación justa

/// Afinación justa de 5 límites relativa a una tónica: las notas se afinan con razones de
/// los números 2, 3 y 5 (5/4, 6/5, 3/2…).
///
/// Una nota escrita no determina por sí sola su razón justa (Mi puede ser 81/64 o 5/4 sobre
/// Do). Aquí, cada nota a `q` quintas de la tónica sustituye ⌊(q + 1) / 4⌋ grupos de cuatro
/// quintas por terceras puras, que es la afinación de Ptolomeo de la escala mayor:
/// 1, 9/8, 5/4, 4/3, 3/2, 5/3, 15/8.
public struct EntonacionJusta: Afinacion, Hashable {
    public let tonica: Nota
    /// Frecuencia de la tónica en la octava 4.
    public let frecuenciaTonica: Double

    /// La tónica en la octava 4 toma su frecuencia en temperamento igual con el La4 dado.
    public init(tonica: Nota, la4: Double = 440) {
        self.tonica = tonica
        self.frecuenciaTonica = Altura(tonica, octava: 4).frecuencia(la4: la4)
    }

    public init(tonica: Nota, frecuenciaTonica: Double) {
        self.tonica = tonica
        self.frecuenciaTonica = frecuenciaTonica
    }

    public func frecuencia(de nota: Altura) -> Double {
        let referencia = Altura(tonica, octava: 4)
        return frecuenciaTonica * Intervalo(pasosDeQuinta: nota.pasosDeQuinta - referencia.pasosDeQuinta,
                                            pasosDeOctava: nota.pasosDeOctava - referencia.pasosDeOctava).razonJusta.valor
    }
}

/// Razón de frecuencias como fracción (5/4, 3/2, 45/32…).
public struct RazonDeFrecuencias: Hashable, Sendable, CustomStringConvertible {
    public let numerador: Double
    public let denominador: Double

    public init(_ numerador: Double, _ denominador: Double) {
        self.numerador = numerador
        self.denominador = denominador
    }

    public var valor: Double { numerador / denominador }
    public var cents: Double { 1200 * log2(valor) }

    public var description: String {
        func entero(_ x: Double) -> String {
            x.rounded() == x && abs(x) < 1e15 ? String(Int64(x)) : String(x)
        }
        return "\(entero(numerador))/\(entero(denominador))"
    }

    /// Coma sintónica (81/80): la diferencia entre cuatro quintas puras y una tercera pura.
    public static let comaSintonica = RazonDeFrecuencias(81, 80)
    /// Coma pitagórica (531441/524288): doce quintas puras frente a siete octavas.
    public static let comaPitagorica = RazonDeFrecuencias(531_441, 524_288)
}

extension Intervalo {
    /// Razón justa de 5 límites del intervalo, con el mismo criterio que `EntonacionJusta`
    /// (como si la nota grave fuera la tónica): 3ª mayor → 5/4, 3ª menor → 6/5,
    /// 7ª mayor → 15/8, 4ª aumentada → 45/32. Si el intervalo desciende, la razón es menor que 1.
    public var razonJusta: RazonDeFrecuencias {
        let q = pasosDeQuintaConSigno
        let o = pasosDeOctavaConSigno
        let terceras = divisionEntera(q + 1, 4)
        let exponentes = [(3.0, q - 4 * terceras), (5.0, terceras), (2.0, o - q + 4 * terceras)]
        var numerador = 1.0, denominador = 1.0
        for (base, exponente) in exponentes {
            if exponente >= 0 { numerador *= pow(base, Double(exponente)) }
            else { denominador *= pow(base, Double(-exponente)) }
        }
        return RazonDeFrecuencias(numerador, denominador)
    }

    /// Tamaño en cents en un temperamento (temperamento igual por defecto).
    public func cents(en temperamento: TemperamentoRegular = .igual) -> Double {
        temperamento.cents(de: self)
    }
}
