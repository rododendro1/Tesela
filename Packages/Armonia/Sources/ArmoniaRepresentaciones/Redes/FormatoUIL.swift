import ArmoniaNucleo
import Hexagonos
// El formato UIL (Unified Isomorphic Layout) de Brett Park y David Gerhard, «Discrete Isomorphic Completeness
// and a Unified Isomorphic Layout Format» (Sound and Music Computing, 2013), que parte de la notación LGD de
// Brian Hayden. Describe cualquier teclado hexagonal isomórfico con tres intervalos, un giro y un espejo.

import Foundation

/// Un teclado hexagonal isomórfico descrito en el formato UIL: `L,G,D;R<grados>[M][;T<tonos>]`.
///
/// - `L`, `G` y `D` son los tres intervalos positivos que salen de una nota: el menor (`menor`), el mayor
///   (`mayor`) y su diferencia (`diferencia`), así que `G = L + D`. En un teclado de 12 notas se cuentan en
///   semitonos: Wicki-Hayden es `2,7,5` (tono, quinta y cuarta).
/// - `R` es el giro en sentido horario, en grados, de la disposición base, que tiene `G` hacia el norte, `D` hacia el
///   noreste y `L` hacia el noroeste (y los intervalos opuestos en las otras tres direcciones). Aquí solo valen
///   múltiplos de 30°: con 60° se pasa de una dirección a la siguiente, y con 30° además cambia la orientación de los
///   hexágonos, de planos (`R` múltiplo de 60) a puntiagudos.
/// - `M` marca que la disposición está en espejo: `L` y `D` se intercambian respecto a `G`, antes de girar.
/// - `T` es el número de tonos de la escala; se omite en los 12 de la afinación igual.
///
///     let formato = try FormatoUIL(leyendo: "2,7,5;R30M")      // Wicki-Hayden
///     formato.esCompleto                                       // true: aparecen las 12 notas
///     try formato.teclado().semitonos(hacia: .qMasSMenos)      // 2
///
/// Se leen también los intervalos en abreviatura (`M2,P5,P4`), en cifras romanas (`II,V,IV`) y en razones
/// (`9:8,3:2,4:3`), como en el artículo. No se leen todavía la cizalla (`S`, que solo vale 0) ni las afinaciones
/// que no son de 12 notas: se pueden describir, pero no dibujar con un `TecladoIsomorfico`.
public struct FormatoUIL: Hashable, Sendable {
    /// `L`: el menor de los tres intervalos.
    public let menor: Int
    /// `G`: el mayor de los tres intervalos (`menor + diferencia`).
    public let mayor: Int
    /// `D`: la diferencia entre `mayor` y `menor`.
    public let diferencia: Int
    /// `R`: el giro en sentido horario, de 0 a 330 en pasos de 30.
    public let rotacion: Int
    /// `M`: si la disposición está en espejo.
    public let espejo: Bool
    /// `T`: las notas de la escala (12 por defecto).
    public let tonos: Int

    /// Los casos especiales del artículo: el caso cero `0,1,1` y el caso de igualdad `L = D` (el único completo
    /// es `1,2,1`, el de Jankó), en los que el espejo no significa nada.
    public enum Caso: Hashable, Sendable {
        case general, cero, igualdad
    }

    public init(menor: Int, mayor: Int, diferencia: Int, rotacion: Int = 0, espejo: Bool = false, tonos: Int = 12) throws {
        let esCero = menor == 0 && mayor == 1 && diferencia == 1
        guard esCero || (menor >= 1 && menor <= diferencia && mayor == menor + diferencia) else {
            throw ErrorDeUIL.intervalosIncoherentes(menor: menor, mayor: mayor, diferencia: diferencia)
        }
        guard rotacion % 30 == 0 else { throw ErrorDeUIL.rotacionNoValida(rotacion) }
        guard tonos >= 1 else { throw ErrorDeUIL.formatoNoValido("T\(tonos)") }
        self.menor = menor
        self.mayor = mayor
        self.diferencia = diferencia
        self.rotacion = modulo(rotacion, 360)
        self.espejo = espejo
        self.tonos = tonos
    }

    /// El formato de un teclado: la forma `L,G,D;R…` con la que se escribe, o `nil` si no sube ningún intervalo.
    /// Si dos formatos dan el mismo teclado (en los casos especiales), elige el que no está en espejo y gira menos.
    public init?(teclado: TecladoIsomorfico) {
        let a = teclado.semitonosEnQ
        let b = teclado.semitonosEnR
        // Los tres pasos independientes son a, b − a y −b, que suman 0: el mayor en valor absoluto es la suma de los otros.
        let tamanos = [abs(a), abs(b - a), abs(b)]
        guard let mayor = tamanos.max(), let menor = tamanos.min(), mayor > 0 else { return nil }
        let primerGiro = teclado.orientacion == .plana ? 0 : 30
        for espejo in [false, true] {
            for giro in stride(from: primerGiro, to: 360, by: 60) {
                guard let candidato = try? FormatoUIL(menor: menor, mayor: mayor, diferencia: mayor - menor,
                                                      rotacion: giro, espejo: espejo),
                      let posible = try? candidato.teclado(),
                      posible.orientacion == teclado.orientacion,
                      posible.semitonosEnQ == a, posible.semitonosEnR == b
                else { continue }
                self = candidato
                return
            }
        }
        return nil
    }

    /// Lee un texto UIL: `2,7,5;R30M`, `1,4,3;R30M;T7`, `M2,P5,P4;R30M`… Los espacios y las mayúsculas del giro
    /// (`r30m`) no importan; el giro se puede omitir (0°).
    public init(leyendo texto: String) throws {
        let partes = texto.split(separator: ";", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard let intervalos = partes.first, !intervalos.isEmpty else { throw ErrorDeUIL.formatoNoValido(texto) }

        var rotacion = 0
        var espejo = false
        var tonos = 12
        for parte in partes.dropFirst() {
            let mayusculas = parte.uppercased()
            guard let letra = mayusculas.first else { throw ErrorDeUIL.formatoNoValido(texto) }
            let resto = String(mayusculas.dropFirst()).trimmingCharacters(in: .whitespaces)
            switch letra {
            case "R":
                let numero = String(resto.prefix { $0 == "-" || ($0.isASCII && $0.isNumber) })
                let sufijo = String(resto.dropFirst(numero.count)).trimmingCharacters(in: .whitespaces)
                guard let grados = Int(numero), sufijo.isEmpty || sufijo == "M" else {
                    throw ErrorDeUIL.formatoNoValido(texto)
                }
                rotacion = grados
                espejo = espejo || sufijo == "M"
            case "M" where resto.isEmpty:
                espejo = true
            case "S":
                guard let cizalla = Int(resto) else { throw ErrorDeUIL.formatoNoValido(texto) }
                if cizalla != 0 { throw ErrorDeUIL.cizallaNoSoportada(cizalla) }
            case "T":
                guard let notas = Int(resto.replacingOccurrences(of: "TET", with: "")) else {
                    throw ErrorDeUIL.formatoNoValido(texto)
                }
                tonos = notas
            default:
                throw ErrorDeUIL.formatoNoValido(texto)
            }
        }

        let fichas = intervalos.split(separator: ",", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
        let valores = fichas.compactMap { Self.semitonos(de: $0, tonos: tonos) }
        guard fichas.count == 3, valores.count == 3 else { throw ErrorDeUIL.formatoNoValido(texto) }
        try self.init(menor: valores[0], mayor: valores[1], diferencia: valores[2], rotacion: rotacion,
                      espejo: espejo, tonos: tonos)
    }

    /// El caso especial del formato, o `.general`.
    public var caso: Caso {
        if menor == 0 { return .cero }
        return menor == diferencia ? .igualdad : .general
    }

    /// Si el teclado es completo: aparece al menos una vez cada nota. Ocurre si y solo si `L` y `D` son coprimos
    /// (el teorema del artículo, por la identidad de Bézout). Si no, es degenerado: faltan notas y las que hay
    /// se repiten con regularidad (con `2,…` solo suenan las notas de una escala de tonos enteros).
    public var esCompleto: Bool {
        Self.mcd(menor, diferencia) == 1
    }

    /// Cómo se colocan los hexágonos: planos si el giro es múltiplo de 60° (alineación vertical del artículo),
    /// puntiagudos si lo es más 30° (alineación horizontal).
    public var orientacion: Orientacion {
        rotacion % 60 == 0 ? .plana : .puntiaguda
    }

    /// Hacia dónde sube el tono (el eje de alturas), en grados en sentido horario desde el norte: 90° es hacia la
    /// derecha. Sin giro y sin espejo está entre 0° y 30°, y con espejo entre −30° y 0° (el artículo da una
    /// aproximación lineal; esta es exacta, el ángulo del gradiente de los intervalos).
    public var anguloDelEjeDeAltura: Double {
        let desvio = atan(Double(diferencia - menor) / (3.0.squareRoot() * Double(mayor))) * 180 / .pi
        let grados = Double(rotacion) + (espejo ? -desvio : desvio)
        return (grados.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
    }

    /// Los semitonos (o pasos de la escala) que sube un paso hacia ese rumbo, en grados en sentido horario desde
    /// el norte, o `nil` si no hay vecina: los rumbos válidos son el giro más múltiplos de 60°.
    public func semitonos(rumbo: Int) -> Int? {
        let relativo = rumbo - rotacion
        guard relativo % 60 == 0 else { return nil }
        let base = espejo
            ? [mayor, menor, -diferencia, -mayor, -menor, diferencia]
            : [mayor, diferencia, -menor, -mayor, -diferencia, menor]
        return base[modulo(relativo / 60, 6)]
    }

    /// El mismo formato con otro giro, sumado al actual: `rotado(grados: 30)`.
    public func rotado(grados: Int) throws -> FormatoUIL {
        try FormatoUIL(menor: menor, mayor: mayor, diferencia: diferencia, rotacion: rotacion + grados,
                       espejo: espejo, tonos: tonos)
    }

    /// El formato reflejado como en un espejo vertical: cambia el espejo y el giro se invierte (`R30M` ↔ `R330`).
    public var reflejado: FormatoUIL? {
        try? FormatoUIL(menor: menor, mayor: mayor, diferencia: diferencia, rotacion: -rotacion,
                        espejo: !espejo, tonos: tonos)
    }

    /// El teclado de 12 notas con este formato, con la casilla `(0, 0)` en `midiDelOrigen`.
    /// Falla con `afinacionNoSoportada` si `T` no es 12.
    public func teclado(nombre: String? = nil, midiDelOrigen: Int = 60) throws -> TecladoIsomorfico {
        guard tonos == 12 else { throw ErrorDeUIL.afinacionNoSoportada(tonos: tonos) }
        let orientacion = self.orientacion
        guard let enQ = semitonos(rumbo: DireccionHexagonal.qMasSMenos.rumbo(orientacion)),
              let enR = semitonos(rumbo: DireccionHexagonal.rMasSMenos.rumbo(orientacion))
        else { throw ErrorDeUIL.formatoNoValido(descripcion) }
        return TecladoIsomorfico(nombre: nombre ?? descripcion, orientacion: orientacion,
                                 semitonosEnQ: enQ, semitonosEnR: enR, midiDelOrigen: midiDelOrigen)
    }

    // MARK: Lectura de intervalos

    /// Las abreviaturas de intervalo del formato de abreviaturas (12 notas).
    private static let abreviaturas: [String: Int] = [
        "P1": 0, "m2": 1, "M2": 2, "m3": 3, "M3": 4, "P4": 5, "A4": 6, "TT": 6, "d5": 6, "P5": 7,
        "m6": 8, "M6": 9, "m7": 10, "M7": 11, "P8": 12,
    ]

    /// Los grados de la escala mayor en cifras romanas (12 notas).
    private static let romanas: [String: Int] = ["I": 0, "II": 2, "III": 4, "IV": 5, "V": 7, "VI": 9, "VII": 11]

    /// Los semitonos de un intervalo escrito como número, abreviatura (`P5`), cifra romana (`V`, `♭III`) o razón (`3:2`).
    /// Las tres últimas solo valen con 12 notas.
    private static func semitonos(de ficha: String, tonos: Int) -> Int? {
        if let numero = Int(ficha) { return numero }
        guard tonos == 12 else { return nil }
        if let semitonos = abreviaturas[ficha] { return semitonos }
        let partes = ficha.split(separator: ":", omittingEmptySubsequences: false)
        if partes.count == 2 {
            guard let numerador = Int(partes[0]), let denominador = Int(partes[1]), numerador > 0, denominador > 0
            else { return nil }
            return Int((12 * log2(Double(numerador) / Double(denominador))).rounded())
        }
        var romano = Substring(ficha)
        var alteracion = 0
        if let primero = romano.first, "♭b".contains(primero) { alteracion = -1; romano = romano.dropFirst() }
        else if let primero = romano.first, "♯#".contains(primero) { alteracion = 1; romano = romano.dropFirst() }
        return romanas[String(romano)].map { $0 + alteracion }
    }

    private static func mcd(_ a: Int, _ b: Int) -> Int {
        b == 0 ? abs(a) : mcd(b, a % b)
    }
}

extension FormatoUIL: CustomStringConvertible {
    /// El texto en su forma normalizada: `2,7,5;R30M`, `1,4,3;R30M;T7`.
    public var descripcion: String {
        "\(menor),\(mayor),\(diferencia);R\(rotacion)\(espejo ? "M" : "")\(tonos == 12 ? "" : ";T\(tonos)")"
    }

    public var description: String { descripcion }
}

/// Por qué no se puede leer o usar un texto UIL.
public enum ErrorDeUIL: Error, Hashable, Sendable, CustomStringConvertible {
    /// El texto no tiene la forma `L,G,D;R…`.
    case formatoNoValido(String)
    /// Los intervalos no cumplen `0 < L ≤ D` y `G = L + D` (ni son el caso cero `0,1,1`).
    case intervalosIncoherentes(menor: Int, mayor: Int, diferencia: Int)
    /// El giro no es múltiplo de 30°.
    case rotacionNoValida(Int)
    /// Un teclado de `TecladoIsomorfico` cuenta semitonos de 12 notas; otra afinación no se puede dibujar con él.
    case afinacionNoSoportada(tonos: Int)
    /// La cizalla (`S`) distinta de 0 no está soportada.
    case cizallaNoSoportada(Int)

    public var description: String {
        switch self {
        case .formatoNoValido(let texto):
            return "UIL no válido: «\(texto)». Se espera L,G,D;R<grados>[M], por ejemplo 2,7,5;R30M."
        case .intervalosIncoherentes(let menor, let mayor, let diferencia):
            return "Intervalos incoherentes: \(menor),\(mayor),\(diferencia). Deben cumplir 0 < L ≤ D y G = L + D."
        case .rotacionNoValida(let grados):
            return "El giro de \(grados)° no es múltiplo de 30°."
        case .afinacionNoSoportada(let tonos):
            return "Solo se dibujan teclados de 12 notas, no de \(tonos)."
        case .cizallaNoSoportada(let cizalla):
            return "La cizalla S\(cizalla) no está soportada."
        }
    }
}

/// Un teclado con nombre de los que reúne el artículo (su Tabla 1).
public struct DisposicionConocida: Hashable, Sendable {
    public let nombre: String
    public let formato: FormatoUIL

    /// El teclado con ese formato y nombre.
    public func teclado(midiDelOrigen: Int = 60) throws -> TecladoIsomorfico {
        try formato.teclado(nombre: nombre, midiDelOrigen: midiDelOrigen)
    }
}

extension FormatoUIL {
    /// Los teclados de la Tabla 1 del artículo. Wicki-Hayden, la tabla armónica y Jankó son los mismos que
    /// `TecladoIsomorfico.wickiHayden`, `.tablaArmonica` y `.janko`; los acordeones de aquí están girados 90°
    /// respecto a `.acordeonC` y `.acordeonB`, y el bayan es el espejo del sistema C girado 180°. El artículo escribe «Bajan».
    public static let conocidos: [DisposicionConocida] = {
        let tabla: [(nombre: String, texto: String)] = [
            ("Wicki-Hayden", "2,7,5;R30M"),
            ("Harmonic table", "3,7,4;R0"),
            ("Gerhard", "1,4,3;R60"),
            ("Park", "2,5,3;R90M"),
            ("Jankó", "1,2,1;R90"),
            ("C-system", "1,3,2;R270M"),
            ("B-system", "1,3,2;R270"),
            ("Bayan", "1,3,2;R90M"),
        ]
        return tabla.compactMap { fila in
            (try? FormatoUIL(leyendo: fila.texto)).map { DisposicionConocida(nombre: fila.nombre, formato: $0) }
        }
    }()
}

// MARK: - Rumbos

extension DireccionHexagonal {
    /// Hacia dónde apunta la dirección con esa orientación, en grados en sentido horario desde el norte
    /// (el ángulo de `angulo(_:)` es antihorario desde el este).
    func rumbo(_ orientacion: Orientacion) -> Int {
        modulo(90 - Int(angulo(orientacion)), 360)
    }
}

extension Orientacion {
    /// La otra orientación: la que se tiene al girar el teclado 30°.
    var alternada: Orientacion { self == .plana ? .puntiaguda : .plana }
}
