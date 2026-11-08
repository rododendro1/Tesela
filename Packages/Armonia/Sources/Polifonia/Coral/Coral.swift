import Elementos
import Teoria

// Conducción de voces: las reglas de la armonía a cuatro voces sobre una sucesión de acordes.

// MARK: - FaltaDeConduccion

/// Una falta de conducción de voces: qué regla se rompe, dónde y entre qué voces.
///
/// Las voces se numeran de grave a agudo desde 0; a cuatro voces son bajo, tenor, contralto y
/// soprano. `acorde` es el índice del acorde donde está la falta o, si es un movimiento, del
/// acorde de partida (el movimiento va de `acorde` a `acorde + 1`).
public struct FaltaDeConduccion: Hashable, Sendable, CustomStringConvertible {
    /// Qué regla de la conducción de voces se rompe.
    public enum Tipo: Hashable, Sendable, CaseIterable {
        /// Dos voces a distancia de quinta justa que se mueven a otra quinta justa.
        case quintasParalelas
        /// Dos voces a distancia de octava justa (o unísono) que se mueven a otra.
        case octavasParalelas
        /// Las voces extremas llegan a una quinta justa por movimiento directo con salto en el soprano.
        case quintasDirectas
        /// Las voces extremas llegan a una octava justa por movimiento directo con salto en el soprano.
        case octavasDirectas
        /// Una voz queda por encima de la que debería ir más aguda.
        case cruceDeVoces
        /// Una voz pasa por encima (o por debajo) de la nota que la voz vecina tenía antes.
        case superposicion
        /// Más de una octava entre dos voces superiores vecinas (contralto–soprano, tenor–contralto).
        case separacionExcesiva
        /// Un salto mayor que una octava o un intervalo aumentado en una voz.
        case saltoNoMelodico
        /// Una nota fuera de la extensión habitual de la voz (solo a cuatro voces).
        case fueraDeTesitura
    }

    public let tipo: Tipo
    public let acorde: Int
    public let voces: [Int]
    package let numeroDeVoces: Int

    /// "Quintas paralelas entre bajo y soprano (acordes 1 → 2)". Los acordes se cuentan desde 1.
    public var description: String { descripcion(en: .compacta(.espanol)) }

    public func descripcion(en notacion: Notacion) -> String {
        let nombres = voces.map { Coral.nombreDeVoz($0, de: numeroDeVoces, en: notacion) }
        let primera = nombres.first ?? ""
        let entre = TextosDePolifonia.en(notacion) { $0.entreLasVoces(nombres) }
        let en = TextosDePolifonia.en(notacion) { $0.enLaVoz(primera) }
        let lugar: String
        switch tipo {
        case .quintasParalelas, .octavasParalelas, .quintasDirectas, .octavasDirectas, .superposicion, .saltoNoMelodico:
            let pasos = "\(acorde + 1) → \(acorde + 2)"
            lugar = TextosDePolifonia.en(notacion) { $0.enLosAcordes(pasos) }
        case .cruceDeVoces, .separacionExcesiva, .fueraDeTesitura:
            lugar = TextosDePolifonia.en(notacion) { $0.enElAcorde(acorde) }
        }
        switch tipo {
        case .saltoNoMelodico, .fueraDeTesitura:
            return "\(tipo.nombre(en: notacion)) \(en) \(lugar)"
        default:
            return "\(tipo.nombre(en: notacion)) \(entre) \(lugar)"
        }
    }
}

extension FaltaDeConduccion.Tipo: Nombrable, CustomStringConvertible {
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .quintasParalelas:
            return TextosDePolifonia.en(notacion, \.quintasParalelas)
        case .octavasParalelas:
            return TextosDePolifonia.en(notacion, \.octavasParalelas)
        case .quintasDirectas:
            return TextosDePolifonia.en(notacion, \.quintasDirectas)
        case .octavasDirectas:
            return TextosDePolifonia.en(notacion, \.octavasDirectas)
        case .cruceDeVoces:
            return TextosDePolifonia.en(notacion, \.cruceDeVoces)
        case .superposicion:
            return TextosDePolifonia.en(notacion, \.superposicion)
        case .separacionExcesiva:
            return TextosDePolifonia.en(notacion, \.separacionExcesiva)
        case .saltoNoMelodico:
            return TextosDePolifonia.en(notacion, \.saltoNoMelodico)
        case .fueraDeTesitura:
            return TextosDePolifonia.en(notacion, \.fueraDeTesitura)
        }
    }

    public var description: String { nombre }
}

// MARK: - Coral

/// Una sucesión de acordes escritos voz por voz, para comprobar su conducción.
///
///     let c = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Re3 La3 Fa4 Re5")
///     c.faltas.map(\.tipo)   // [.quintasParalelas, .octavasParalelas]
///
/// Cada acorde lleva sus alturas de grave a agudo, y todos tienen el mismo número de voces.
/// A cuatro voces se comprueban también las tesituras: bajo Mi2–Do4, tenor Do3–Sol4,
/// contralto Sol3–Re5 y soprano Do4–Sol5.
public struct Coral: Hashable, Sendable {
    /// Los acordes, cada uno con sus alturas de la voz más grave a la más aguda.
    public let acordes: [[Altura]]

    /// Lanza `ErrorDeLecturaDeTeoria` (`.vocesDistintas`) si no hay acordes, si hay menos de dos voces o si no
    /// todos tienen las mismas.
    public init(_ acordes: [[Altura]]) throws {
        guard let voces = acordes.first?.count, voces >= 2,
            acordes.allSatisfy({ $0.count == voces })
        else { throw ErrorDeLecturaDeTeoria(texto: "", posicion: nil, motivo: .vocesDistintas) }
        self.acordes = acordes
    }

    /// Las mismas alturas dadas voz por voz, de grave a agudo: `[bajo, tenor, contralto, soprano]`,
    /// cada una con sus notas en orden. Lanza `ErrorDeLecturaDeTeoria` si las voces no tienen todas el mismo número
    /// de notas (`.vocesDeDistintaLongitud`) o si no hay al menos dos con alguna nota (`.vocesDistintas`).
    public init(voces: [[Altura]]) throws {
        let longitud = voces.first?.count ?? 0
        guard voces.allSatisfy({ $0.count == longitud }) else {
            throw ErrorDeLecturaDeTeoria(texto: "", posicion: nil, motivo: .vocesDeDistintaLongitud)
        }
        try self.init((0..<longitud).map { i in voces.map { $0[i] } })
    }

    /// Lee los acordes separados por barras o comas, y en cada uno las alturas de grave a agudo:
    /// "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4".
    public init(leyendo texto: String) throws {
        var acordes: [[Altura]] = [[]]
        var actual = ""
        var posicion = 0
        func cerrarAltura() throws {
            defer { actual = "" }
            guard !actual.isEmpty else { return }
            do {
                acordes[acordes.count - 1].append(try Altura(leyendo: actual))
            } catch let error as any ErrorAlLeer {
                let inicio = posicion - actual.count
                throw error.situado(en: texto, posicion: error.posicion.map { inicio + $0 } ?? inicio)
            }
        }
        for caracter in texto {
            if caracter == "|" || caracter == "," {
                try cerrarAltura()
                acordes.append([])
            } else if caracter.isWhitespace {
                try cerrarAltura()
            } else {
                actual.append(caracter)
            }
            posicion += 1
        }
        try cerrarAltura()
        acordes.removeAll { $0.isEmpty }
        guard !acordes.isEmpty else { throw ErrorDeLectura(texto: texto, posicion: nil, motivo: .textoVacio) }
        do { self = try Coral(acordes) } catch let error as ErrorDeLecturaDeTeoria {
            throw error.situado(en: texto, posicion: nil)
        }
    }

    public var numeroDeVoces: Int { acordes[0].count }

    /// Las notas de una voz (0 = la más grave), en orden.
    public func voz(_ indice: Int) -> [Altura] { acordes.map { $0[indice] } }

    /// Todas las faltas, en orden de aparición.
    public var faltas: [FaltaDeConduccion] {
        var faltas: [FaltaDeConduccion] = []
        for (i, acorde) in acordes.enumerated() {
            Coral.faltas(en: acorde) { tipo, voces in
                faltas.append(FaltaDeConduccion(tipo: tipo, acorde: i, voces: voces, numeroDeVoces: numeroDeVoces))
            }
            guard i + 1 < acordes.count else { continue }
            Coral.faltas(de: acorde, a: acordes[i + 1]) { tipo, voces in
                faltas.append(FaltaDeConduccion(tipo: tipo, acorde: i, voces: voces, numeroDeVoces: numeroDeVoces))
            }
        }
        return faltas
    }

    /// Las faltas dentro de un acorde: cruces, separación y tesituras (estas, solo a cuatro voces).
    package static func faltas(en acorde: [Altura], _ anotar: (FaltaDeConduccion.Tipo, [Int]) -> Void) {
        let numeroDeVoces = acorde.count
        for v in 0..<(numeroDeVoces - 1) where acorde[v].midi > acorde[v + 1].midi {
            anotar(.cruceDeVoces, [v, v + 1])
        }
        for v in 1..<(numeroDeVoces - 1) where acorde[v + 1].midi - acorde[v].midi > 12 {
            anotar(.separacionExcesiva, [v, v + 1])
        }
        if numeroDeVoces == 4 {
            for v in 0..<4 where !tesituras[v].contains(acorde[v].midi) {
                anotar(.fueraDeTesitura, [v])
            }
        }
    }

    /// Las faltas al pasar de un acorde al siguiente: saltos, superposiciones, paralelas y directas.
    package static func faltas(
        de acorde: [Altura], a siguiente: [Altura], _ anotar: (FaltaDeConduccion.Tipo, [Int]) -> Void
    ) {
        let numeroDeVoces = acorde.count
        let soprano = numeroDeVoces - 1

        // Cada voz: saltos.
        for v in 0..<numeroDeVoces
        where Conduccion.Saltos.armonia.noEsMelodico(
            siguiente[v] - acorde[v], ascendente: siguiente[v].midi > acorde[v].midi)
        {
            anotar(.saltoNoMelodico, [v])
        }

        // Voces vecinas: superposición.
        for v in 0..<(numeroDeVoces - 1) {
            if siguiente[v].midi > acorde[v + 1].midi || siguiente[v + 1].midi < acorde[v].midi {
                anotar(.superposicion, [v, v + 1])
            }
        }

        // Cada pareja de voces: paralelas.
        for grave in 0..<(numeroDeVoces - 1) {
            for aguda in (grave + 1)..<numeroDeVoces {
                let paso = Conduccion.PasoDeVoces(
                    de: (acorde[grave], acorde[aguda]), a: (siguiente[grave], siguiente[aguda]))
                if let perfecta = paso.paralelas {
                    anotar(perfecta == 5 ? .quintasParalelas : .octavasParalelas, [grave, aguda])
                }
            }
        }

        // Voces extremas: quintas y octavas directas (movimiento directo y salto en el soprano).
        let extremas = Conduccion.PasoDeVoces(de: (acorde[0], acorde[soprano]), a: (siguiente[0], siguiente[soprano]))
        if let perfecta = extremas.directas, abs(extremas.movimientos.1) > 2 {
            anotar(perfecta == 5 ? .quintasDirectas : .octavasDirectas, [0, soprano])
        }
    }

    /// `true` si no hay ninguna falta.
    public var esCorrecta: Bool { faltas.isEmpty }

    // MARK: Auxiliares

    /// Extensión de cada voz en MIDI: bajo Mi2–Do4, tenor Do3–Sol4, contralto Sol3–Re5, soprano Do4–Sol5.
    package static let tesituras = [40...60, 48...67, 55...74, 60...79]

    package static func nombreDeVoz(_ voz: Int, de total: Int, en notacion: Notacion) -> String {
        if total == 4 {
            return [
                TextosDePolifonia.traduccion(\.vozBajo),
                TextosDePolifonia.traduccion(\.vozTenor),
                TextosDePolifonia.traduccion(\.vozContralto),
                TextosDePolifonia.traduccion(\.vozSoprano),
            ][voz].en(notacion)
        }
        let numero = voz + 1
        return TextosDePolifonia.en(notacion) { $0.vozNumero(numero) }
    }
}

// MARK: - Transportar

extension Coral: Transponible {
    /// El mismo coral, con todas las voces movidas el mismo intervalo.
    public func transponer(_ intervalo: Intervalo) -> Coral {
        // Las voces siguen siendo las mismas, así que el coral sigue siendo válido.
        (try? Coral(acordes.map { $0.map { $0.transponer(intervalo) } })) ?? self
    }

    /// Los acordes como se leen con `init(leyendo:)`: las alturas de grave a agudo, separados por barras.
    public func texto(en notacion: Notacion) -> String {
        acordes.map { $0.map { $0.nombre(en: notacion) }.joined(separator: " ") }.joined(separator: " | ")
    }
}

extension Coral: Codable {
    /// Se codifica como sus acordes, cada uno con sus alturas de grave a agudo: `[["Do3", "Sol3", "Mi4", "Do5"], …]`.
    /// Al leerlo se comprueba, como en `init(_:)`, que todos tengan las mismas voces, y al menos dos.
    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.singleValueContainer()
        let acordes = try contenedor.decode([[Altura]].self)
        let coral: Coral
        do { coral = try Coral(acordes) } catch let error as ErrorDeLecturaDeTeoria {
            throw DecodingError.dataCorruptedError(in: contenedor, debugDescription: error.description)
        }
        self = coral
    }

    public func encode(to encoder: Encoder) throws {
        var contenedor = encoder.singleValueContainer()
        try contenedor.encode(acordes)
    }
}
