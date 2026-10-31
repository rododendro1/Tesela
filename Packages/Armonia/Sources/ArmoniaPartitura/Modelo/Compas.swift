import ArmoniaNucleo
import ArmoniaTeoria

// Compases: el número de pulsos, su agrupación y sus acentos.

// MARK: - Compás

/// Compás: `numerador` unidades de `1/denominador` redonda, agrupadas en pulsos.
///
///     let c: Compas = "6/8"
///     c.tipo         // .compuesto
///     c.pulsos       // 2
///     c.pulso        // negra con puntillo
///     c.agrupacion   // [3, 3]
///     Compas("7/8").agrupacion        // [2, 2, 3]
///     Compas("3+2+2/8").agrupacion    // [3, 2, 2]
///     Compas.compasillo.duracion       // 1 (una redonda)
public struct Compas: Hashable, Sendable, CustomStringConvertible {
    public let numerador: Int
    public let denominador: Int
    /// Unidades (de `1/denominador`) de cada pulso, en orden: [1, 1, 1, 1] en 4/4, [3, 3] en 6/8,
    /// [2, 2, 3] en 7/8. Suman `numerador`.
    public let agrupacion: [Int]

    public enum Tipo: Hashable, Sendable {
        /// Pulsos de una unidad, divisibles en dos (2/4, 3/4, 4/4, 2/2).
        case simple
        /// Pulsos con puntillo, de tres unidades (6/8, 9/8, 12/8).
        case compuesto
        /// Pulsos desiguales (5/8 = 2+3, 7/8 = 2+2+3).
        case amalgama
    }

    /// Fuerza métrica del comienzo de un pulso.
    public enum Acento: Int, Hashable, Sendable, Comparable {
        case debil, semifuerte, fuerte
        public static func < (a: Acento, b: Acento) -> Bool { a.rawValue < b.rawValue }
    }

    /// Como `init(_:_:agrupacion:)`, pero devuelve `nil` en vez de detener el programa si el compás o su
    /// agrupación no son válidos. Es la que hay que usar con datos de fuera.
    public init?(comprobando numerador: Int, _ denominador: Int, agrupacion: [Int]? = nil) {
        guard Compas.esValido(numerador, denominador) else { return nil }
        let grupos = agrupacion ?? Compas.agrupacionHabitual(numerador)
        guard grupos.allSatisfy({ $0 > 0 }), grupos.reduce(0, +) == numerador else { return nil }
        self.init(numerador, denominador, agrupacion: grupos)
    }

    /// El denominador tiene que ser una potencia de 2 (1…64) y el numerador, positivo. Sin
    /// `agrupacion` se usa la habitual: pulsos de una unidad (hasta 4), de tres (6, 9, 12…) o,
    /// en los de amalgama, grupos de dos con uno de tres al final (5 = 2+3, 7 = 2+2+3).
    /// Detiene el programa si no se cumple: con datos de fuera, `init?(comprobando:_:agrupacion:)`.
    public init(_ numerador: Int, _ denominador: Int, agrupacion: [Int]? = nil) {
        precondition(Compas.esValido(numerador, denominador), "compás no válido: \(numerador)/\(denominador)")
        let grupos = agrupacion ?? Compas.agrupacionHabitual(numerador)
        precondition(
            grupos.allSatisfy { $0 > 0 } && grupos.reduce(0, +) == numerador,
            "la agrupación \(grupos) no suma \(numerador)")
        self.numerador = numerador
        self.denominador = denominador
        self.agrupacion = grupos
    }

    package static func esValido(_ numerador: Int, _ denominador: Int) -> Bool {
        numerador > 0 && denominador > 0 && denominador & (denominador - 1) == 0 && denominador <= 64
    }

    package static func agrupacionHabitual(_ numerador: Int) -> [Int] {
        if numerador <= 4 { return Array(repeating: 1, count: numerador) }
        if numerador % 3 == 0 { return Array(repeating: 3, count: numerador / 3) }
        return Array(repeating: 2, count: (numerador - 3) / 2) + [3]
    }

    /// Lee "4/4", "6/8", "7/8", "2+2+3/8" (con la agrupación), "C" (compasillo) o "¢"/"C|"
    /// (compás partido).
    public init(leyendo texto: String) throws {
        let limpio = texto.trimmingEspacios()
        switch limpio {
        case "C":
            self = .compasillo
            return
        case "¢", "C|":
            self = .partido
            return
        default: break
        }
        let error = ErrorDeLectura(texto: texto, posicion: nil, motivo: .compasNoValido(limpio))
        let partes = limpio.split(separator: "/", omittingEmptySubsequences: false)
        guard partes.count == 2, let denominador = Int(partes[1]) else { throw error }
        let sumandos = partes[0].split(separator: "+", omittingEmptySubsequences: false).map { Int($0) }
        guard !sumandos.isEmpty, sumandos.allSatisfy({ ($0 ?? 0) > 0 }) else { throw error }
        let grupos = sumandos.compactMap { $0 }
        let numerador = grupos.reduce(0, +)
        guard Compas.esValido(numerador, denominador) else { throw error }
        self.init(numerador, denominador, agrupacion: grupos.count > 1 ? grupos : nil)
    }

    /// 4/4.
    public static let compasillo = Compas(4, 4)
    /// 2/2.
    public static let partido = Compas(2, 2)

    /// Duración de un compás completo: 3/4 → blanca con puntillo.
    public var duracion: Duracion { Duracion(numerador, denominador) }

    public var tipo: Tipo {
        if agrupacion.allSatisfy({ $0 == 1 }) { return .simple }
        if agrupacion.allSatisfy({ $0 == 3 }) { return .compuesto }
        return .amalgama
    }

    /// Pulsos por compás: 4 en 4/4, 2 en 6/8, 3 en 7/8 (2+2+3).
    public var pulsos: Int { agrupacion.count }

    /// Duración de cada pulso: en 7/8, [negra, negra, negra con puntillo].
    public var duracionesDePulso: [Duracion] { agrupacion.map { Duracion($0, denominador) } }

    /// Duración del pulso: negra en 4/4, negra con puntillo en 6/8. En los compases de amalgama,
    /// cuyos pulsos son desiguales, la unidad (corchea en 7/8).
    public var pulso: Duracion {
        let distintas = Set(agrupacion)
        return distintas.count == 1 ? Duracion(agrupacion[0], denominador) : Duracion(1, denominador)
    }

    /// Dónde empieza cada pulso, desde el principio del compás: en 6/8, [0, 3/8].
    public var iniciosDePulso: [Duracion] {
        var inicio = Duracion.cero
        return duracionesDePulso.map { duracion in
            defer { inicio = inicio + duracion }
            return inicio
        }
    }

    /// Acento del pulso número `pulso` (desde 0): el primero es fuerte; en compases de 4 pulsos o más con
    /// un número par de pulsos, el de la mitad es semifuerte (el 3.º en 4/4 y en 12/8);
    /// en los de amalgama, el comienzo de cada grupo de tres es semifuerte; el resto, débiles.
    public func acento(pulso numero: Int) -> Acento {
        let posicion = modulo(numero, pulsos)
        if posicion == 0 { return .fuerte }
        if pulsos >= 4 && pulsos % 2 == 0 && posicion == pulsos / 2 { return .semifuerte }
        if tipo == .amalgama && agrupacion[posicion] == 3 { return .semifuerte }
        return .debil
    }

    /// Acento de una posición dentro del compás, si coincide con el comienzo de un pulso;
    /// `nil` si cae entre pulsos (a contratiempo).
    public func acento(en posicion: Duracion) -> Acento? {
        iniciosDePulso.firstIndex(of: posicion).map { acento(pulso: $0) }
    }

    /// Punto que no debe ocultar una nota que empieza después del principio del compás: la mitad
    /// en los compases de un número par de pulsos (desde 4), según la costumbre de escritura.
    package var mitad: Duracion? {
        pulsos >= 4 && pulsos % 2 == 0 ? iniciosDePulso[pulsos / 2] : nil
    }

    /// Comienzos de los grupos que no miden lo mismo que el anterior: en 7/8 (2+2+3), el del grupo
    /// de tres; en 3+2+2/8, el primero de dos. Una figura sola no los oculta: en 7/8 la nota de
    /// todo el compás se escribe blanca ligada a negra con puntillo, no blanca con dos puntillos.
    package var fronterasDeGrupo: [Duracion] {
        let inicios = iniciosDePulso
        return agrupacion.indices.dropFirst().filter { agrupacion[$0] != agrupacion[$0 - 1] }.map { inicios[$0] }
    }

    /// "4/4", "6/8"; con una agrupación que no es la habitual, "3+2+2/8".
    public var description: String {
        agrupacion == Compas.agrupacionHabitual(numerador)
            ? "\(numerador)/\(denominador)"
            : agrupacion.map(String.init).joined(separator: "+") + "/\(denominador)"
    }
}

extension Compas: RepresentableComoTexto {
    public func texto(en notacion: Notacion) -> String { description }
}
