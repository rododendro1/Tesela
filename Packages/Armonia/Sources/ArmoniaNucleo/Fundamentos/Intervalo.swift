// MARK: - Sentido del intervalo

/// Si un intervalo sube o baja.
public enum SentidoDelIntervalo: Int, Hashable, Sendable {
    case ascendente = 1
    case descendente = -1

    public var signo: Int { rawValue }
}

// MARK: - CalidadDeIntervalo

/// Calidad de un intervalo. Los grados aumentados/disminuidos admiten multiplicidad
/// (`.aumentada(2)` = doble aumentada).
public enum CalidadDeIntervalo: Hashable, Sendable, CustomStringConvertible {
    case justa
    case mayor
    case menor
    case aumentada(Int)
    case disminuida(Int)

    /// Abreviatura: J, M, m, A, AA, d, dd…
    public var abreviatura: String {
        switch self {
        case .justa: return "J"
        case .mayor: return "M"
        case .menor: return "m"
        case .aumentada(let veces): return String(repeating: "A", count: veces)
        case .disminuida(let veces): return String(repeating: "d", count: veces)
        }
    }

    public var description: String { nombre }

    /// Abreviatura en una notación: "J" en español y "P" (perfect) en inglés; las demás coinciden.
    public func abreviatura(en notacion: Notacion) -> String {
        notacion.idiomaDeLasAbreviaturas == .ingles && self == .justa ? "P" : abreviatura
    }
}

extension CalidadDeIntervalo: Nombrable {}

// MARK: - Intervalo

/// Intervalo entre dos notas, codificado como un vector en el plano
/// (pasos de quinta, pasos de octava) más una dirección.
///
/// Un intervalo ascendente de `q` pasos de quinta y `o` pasos de octava equivale a apilar
/// `q` quintas justas y `o` octavas justas (valores negativos = bajar):
///
///  * pasos diatónicos = 4·q + 7·o   (una quinta abarca 4 pasos, una octava 7)
///  * semitonos        = 7·q + 12·o
///
/// | Intervalo | pasosDeQuinta | pasosDeOctava |
/// |-----------|--------------:|--------------:|
/// | 5ª justa  |       1       |       0       |
/// | 2ª mayor  |       2       |      −1       |
/// | 3ª mayor  |       4       |      −2       |
/// | 3ª menor  |      −3       |       2       |
/// | 4ª justa  |      −1       |       1       |
/// | 8ª justa  |       0       |       1       |
///
/// Las coordenadas `pasosDeQuinta`/`pasosDeOctava` guardan siempre la **magnitud** (forma
/// ascendente canónica) y `sentido`, si sube o baja. El inicializador normaliza
/// cualquier vector, de modo que la igualdad estructural es la igualdad musical.
public struct Intervalo: Hashable, Sendable {
    public let pasosDeQuinta: Int
    public let pasosDeOctava: Int
    public let sentido: SentidoDelIntervalo

    /// Quintas que tiene el intervalo base de cada número simple
    /// (unísono, 2ª, 3ª, 4ª, 5ª, 6ª, 7ª) en su calidad justa o mayor.
    package static let pasosDeQuintaBase = [0, 2, 4, -1, 1, 3, 5]

    /// Crea un intervalo a partir de coordenadas. Si el vector resultante
    /// (`pasosDeQuinta`, `pasosDeOctava`) × signo de `sentido` desciende, se normaliza
    /// a magnitud positiva con dirección descendente.
    public init(pasosDeQuinta: Int, pasosDeOctava: Int, sentido: SentidoDelIntervalo = .ascendente) {
        let quintas = pasosDeQuinta * sentido.signo
        let octavas = pasosDeOctava * sentido.signo
        let pasos = 4 * quintas + 7 * octavas
        let semitonos = 7 * quintas + 12 * octavas
        if pasos < 0 || (pasos == 0 && semitonos < 0) {
            self.pasosDeQuinta = -quintas
            self.pasosDeOctava = -octavas
            self.sentido = .descendente
        } else {
            self.pasosDeQuinta = quintas
            self.pasosDeOctava = octavas
            self.sentido = .ascendente
        }
    }

    /// Crea un intervalo por número y calidad: `Intervalo(numero: 3, calidad: .mayor)`.
    /// Devuelve `nil` si la combinación no existe: "5ª mayor", "3ª justa" o el unísono
    /// disminuido (de Do a Do♭ hay un unísono aumentado descendente, no un unísono disminuido:
    /// el unísono es la distancia cero y no se puede achicar).
    public init?(numero: Int, calidad: CalidadDeIntervalo, sentido: SentidoDelIntervalo = .ascendente) {
        guard numero >= 1 else { return nil }
        let pasos = numero - 1
        let clase = pasos % 7
        let esJusta = [0, 3, 4].contains(clase)
        let desplazamiento: Int
        switch calidad {
        case .justa:
            guard esJusta else { return nil }
            desplazamiento = 0
        case .mayor:
            guard !esJusta else { return nil }
            desplazamiento = 0
        case .menor:
            guard !esJusta else { return nil }
            desplazamiento = -1
        case .aumentada(let veces):
            guard veces >= 1 else { return nil }
            desplazamiento = veces
        case .disminuida(let veces):
            guard veces >= 1, pasos != 0 else { return nil }
            desplazamiento = esJusta ? -veces : -(veces + 1)
        }
        let quintas = Intervalo.pasosDeQuintaBase[clase] + 7 * desplazamiento
        self.init(pasosDeQuinta: quintas, pasosDeOctava: (pasos - 4 * quintas) / 7, sentido: sentido)
    }

    /// Lee abreviaturas como "3M", "5J", "4A", "7m", "5d", "9M", "4AA" o "-3m" (descendente),
    /// y también en notación internacional: "M3", "P5", "A4", "m7", "-m3".
    /// Si no se puede leer, el error indica dónde y por qué.
    public init(leyendo texto: String) throws {
        var lector = Lector(texto)
        try lector.exigirContenido()
        let sentido: SentidoDelIntervalo = lector.consumir("-") ? .descendente : .ascendente

        // Notación internacional: la calidad va delante (M3, P5, m7, A4, dd5).
        let posicionLetras = lector.posicion
        let letrasDelante = lector.leer(mientras: { "PJMmAd".contains($0) })
        if !letrasDelante.isEmpty {
            let antesDelNumero = lector
            let numeroLeido = lector.leerEntero()
            lector.saltarEspacios()
            guard let numero = numeroLeido, numero >= 1, lector.haTerminado else {
                throw antesDelNumero.error(.numeroDeIntervaloNoValido(antesDelNumero.fragmento))
            }
            self = try Intervalo.construir(
                numero: numero, letras: letrasDelante, sentido: sentido,
                texto: texto, posicionLetras: posicionLetras)
            return
        }

        let antesDelNumero = lector
        guard let numero = lector.leerEntero(), numero >= 1 else {
            throw antesDelNumero.error(.numeroDeIntervaloNoValido(antesDelNumero.fragmento))
        }
        self = try Intervalo.construir(
            numero: numero, letras: lector.restoSinEspacios, sentido: sentido,
            texto: texto, posicionLetras: lector.posicion)
    }

    /// Intervalo a partir de su número y las letras de su calidad (J/P, M, m, A…, d…).
    private static func construir(
        numero: Int, letras: String, sentido: SentidoDelIntervalo,
        texto: String, posicionLetras: Int
    ) throws -> Intervalo {
        let calidad: CalidadDeIntervalo
        if letras == "J" || letras == "P" {
            calidad = .justa
        } else if letras == "M" {
            calidad = .mayor
        } else if letras == "m" {
            calidad = .menor
        } else if !letras.isEmpty && letras.allSatisfy({ $0 == "A" }) {
            calidad = .aumentada(letras.count)
        } else if !letras.isEmpty && letras.allSatisfy({ $0 == "d" }) {
            calidad = .disminuida(letras.count)
        } else {
            throw ErrorDeLectura(
                texto: texto, posicion: posicionLetras,
                motivo: .calidadNoValida(letras))
        }
        guard let intervalo = Intervalo(numero: numero, calidad: calidad, sentido: sentido) else {
            let inicio = texto.drop(while: { $0 == " " || $0 == "-" })
            throw ErrorDeLectura(
                texto: texto, posicion: inicio.posicionEnOrigen,
                motivo: .intervaloInexistente(numero: numero, calidad: calidad))
        }
        return intervalo
    }

    /// Intervalo simple ascendente (unísono…7ª) que corresponde a un número de quintas.
    public static func simpleAscendente(pasosDeQuinta q: Int) -> Intervalo {
        let pasos = modulo(4 * q, 7)
        return Intervalo(pasosDeQuinta: q, pasosDeOctava: (pasos - 4 * q) / 7)
    }

    // MARK: Propiedades

    /// Pasos diatónicos (0 = unísono, 2 = tercera, 7 = octava…). Siempre ≥ 0.
    public var pasos: Int { 4 * pasosDeQuinta + 7 * pasosDeOctava }

    /// Tamaño en semitonos (magnitud).
    public var semitonos: Int { 7 * pasosDeQuinta + 12 * pasosDeOctava }

    /// Número del intervalo (1 = unísono, 3 = tercera, 9 = novena…).
    public var numero: Int { pasos + 1 }

    /// Número reducido a la octava (la 9ª → 2, la 8ª se mantiene en 8).
    public var numeroSimple: Int { pasosSimples + 1 }

    public var pasosDeQuintaConSigno: Int { pasosDeQuinta * sentido.signo }
    public var pasosDeOctavaConSigno: Int { pasosDeOctava * sentido.signo }
    public var semitonosConSigno: Int { semitonos * sentido.signo }
    public var pasosConSigno: Int { pasos * sentido.signo }

    /// Las octavas no alteran la calidad: basta con mirar la coordenada de quintas.
    public var calidad: CalidadDeIntervalo {
        let alteraciones = divisionEntera(pasosDeQuinta + 1, 7)
        let base = pasosDeQuinta - 7 * alteraciones // −1…5
        if base <= 1 { // 4ª, unísono, 5ª
            if alteraciones == 0 { return .justa }
            return alteraciones > 0 ? .aumentada(alteraciones) : .disminuida(-alteraciones)
        }
        switch alteraciones { // 2ª, 6ª, 3ª, 7ª
        case 0: return .mayor
        case -1: return .menor
        default: return alteraciones > 0 ? .aumentada(alteraciones) : .disminuida(-alteraciones - 1)
        }
    }

    public var esCompuesto: Bool { pasos > 7 }

    /// "3M", "5J", "-4A".
    public var abreviatura: String {
        (sentido == .descendente ? "-" : "") + "\(numero)\(calidad.abreviatura)"
    }

    /// Abreviatura en una notación: "3M", "5J" en español; "M3", "P5", "-A4" en inglés
    /// (la calidad va delante).
    public func abreviatura(en notacion: Notacion) -> String {
        guard notacion.idiomaDeLasAbreviaturas == .ingles else { return abreviatura }
        return (sentido == .descendente ? "-" : "") + "\(calidad.abreviatura(en: notacion))\(numero)"
    }

    // MARK: Clase interválica y consonancia

    /// Clase interválica (0…6): el tamaño reducido a la octava, sin distinguir un intervalo
    /// de su inversión ni la ortografía. 3ª mayor → 4, 6ª menor → 4, 4ª aumentada → 6, 9ª menor → 1.
    public var claseIntervalica: Int {
        let reducido = modulo(semitonos, 12)
        return min(reducido, 12 - reducido)
    }

    /// Consonancia según la teoría tonal. Depende de la ortografía: la 3ª disminuida suena
    /// como una 2ª mayor y es disonante; la 2ª aumentada suena como una 3ª menor y también lo es.
    /// Con `cuartaDisonante`, la 4ª justa cuenta como disonancia (contrapunto, sobre el bajo).
    public func consonancia(cuartaDisonante: Bool = false) -> Consonancia {
        let clase = pasos % 7
        switch (clase, calidad) {
        case (0, .justa), (4, .justa): return .perfecta
        case (3, .justa): return cuartaDisonante ? .disonancia : .perfecta
        case (2, .mayor), (2, .menor), (5, .mayor), (5, .menor): return .imperfecta
        default: return .disonancia
        }
    }

    public var esConsonante: Bool { consonancia() != .disonancia }

    // MARK: Transformaciones

    /// Pasos reducidos a 1…7 (0 solo para el unísono), de modo que la octava siga siendo octava.
    private var pasosSimples: Int { pasos == 0 ? 0 : (pasos - 1) % 7 + 1 }

    /// Reducción a intervalo simple: 9ª mayor → 2ª mayor; conserva la dirección.
    public var simple: Intervalo {
        return Intervalo(
            pasosDeQuinta: pasosDeQuinta, pasosDeOctava: (pasosSimples - 4 * pasosDeQuinta) / 7, sentido: sentido)
    }

    /// Inversión dentro de la octava: 3ª mayor ↔ 6ª menor, 4ª aumentada ↔ 5ª disminuida.
    /// Es la diferencia entre la octava (0, 1) y el intervalo simple.
    public var inversion: Intervalo {
        let reducido = simple
        return Intervalo(
            pasosDeQuinta: -reducido.pasosDeQuinta, pasosDeOctava: 1 - reducido.pasosDeOctava, sentido: sentido)
    }

    public var ascendente: Intervalo { Intervalo(pasosDeQuinta: pasosDeQuinta, pasosDeOctava: pasosDeOctava) }
    public var descendente: Intervalo {
        Intervalo(pasosDeQuinta: pasosDeQuinta, pasosDeOctava: pasosDeOctava, sentido: .descendente)
    }

    /// ¿Mismo tamaño en semitonos? (4ª aumentada y 5ª disminuida → `true`).
    public func esEnarmonico(de otro: Intervalo) -> Bool {
        semitonosConSigno == otro.semitonosConSigno
    }

    // MARK: Aritmética vectorial

    public static prefix func - (i: Intervalo) -> Intervalo {
        Intervalo(
            pasosDeQuinta: i.pasosDeQuinta, pasosDeOctava: i.pasosDeOctava,
            sentido: i.sentido == .ascendente ? .descendente : .ascendente)
    }

    public static func + (a: Intervalo, b: Intervalo) -> Intervalo {
        Intervalo(
            pasosDeQuinta: a.pasosDeQuintaConSigno + b.pasosDeQuintaConSigno,
            pasosDeOctava: a.pasosDeOctavaConSigno + b.pasosDeOctavaConSigno)
    }

    public static func - (a: Intervalo, b: Intervalo) -> Intervalo { a + (-b) }

    public static func * (n: Int, i: Intervalo) -> Intervalo {
        Intervalo(pasosDeQuinta: n * i.pasosDeQuintaConSigno, pasosDeOctava: n * i.pasosDeOctavaConSigno)
    }

    // MARK: Constantes

    private static func crear(_ numero: Int, _ calidad: CalidadDeIntervalo) -> Intervalo {
        Intervalo(numero: numero, calidad: calidad)!
    }

    public static let unisono = crear(1, .justa)
    public static let unisonoAumentado = crear(1, .aumentada(1))
    public static let segundaMenor = crear(2, .menor)
    public static let segundaMayor = crear(2, .mayor)
    public static let segundaAumentada = crear(2, .aumentada(1))
    public static let terceraDisminuida = crear(3, .disminuida(1))
    public static let terceraMenor = crear(3, .menor)
    public static let terceraMayor = crear(3, .mayor)
    public static let terceraAumentada = crear(3, .aumentada(1))
    public static let cuartaDisminuida = crear(4, .disminuida(1))
    public static let cuartaJusta = crear(4, .justa)
    public static let cuartaAumentada = crear(4, .aumentada(1))
    public static let quintaDisminuida = crear(5, .disminuida(1))
    public static let quintaJusta = crear(5, .justa)
    public static let quintaAumentada = crear(5, .aumentada(1))
    public static let sextaDisminuida = crear(6, .disminuida(1))
    public static let sextaMenor = crear(6, .menor)
    public static let sextaMayor = crear(6, .mayor)
    public static let sextaAumentada = crear(6, .aumentada(1))
    public static let septimaDisminuida = crear(7, .disminuida(1))
    public static let septimaMenor = crear(7, .menor)
    public static let septimaMayor = crear(7, .mayor)
    public static let octava = crear(8, .justa)
    public static let novenaMenor = crear(9, .menor)
    public static let novenaMayor = crear(9, .mayor)
    public static let novenaAumentada = crear(9, .aumentada(1))
    public static let undecima = crear(11, .justa)
    public static let undecimaAumentada = crear(11, .aumentada(1))
    public static let decimoterceraMenor = crear(13, .menor)
    public static let decimoterceraMayor = crear(13, .mayor)

}

extension Intervalo: CustomStringConvertible {
    public var description: String { nombre }
}

extension Intervalo: Comparable {
    /// Ordena por tamaño con signo; a igual tamaño, por pasos (4ª aumentada < 5ª disminuida).
    public static func < (a: Intervalo, b: Intervalo) -> Bool {
        a.semitonosConSigno != b.semitonosConSigno
            ? a.semitonosConSigno < b.semitonosConSigno
            : a.pasosConSigno < b.pasosConSigno
    }
}

extension Intervalo: RepresentableComoTexto, Nombrable {
    /// "3M" en español, "M3" en inglés.
    public func texto(en notacion: Notacion) -> String { abreviatura(en: notacion) }
}

// MARK: - Consonancia

public enum Consonancia: Hashable, Sendable, CustomStringConvertible {
    /// Unísono, 8ª, 5ª y 4ª justas (y sus compuestos).
    case perfecta
    /// 3ª y 6ª mayores y menores.
    case imperfecta
    /// 2ª, 7ª y todos los intervalos aumentados y disminuidos.
    case disonancia

    public var description: String { nombre }
}

extension Consonancia: Nombrable {}

// MARK: - Idiomas
//
// Las calidades de intervalo, los intervalos y las consonancias en los catorce idiomas de los textos
// (`Notacion.textos`). Las notas y las alteraciones, en `Nota.swift`.

// MARK: - CalidadDeIntervalo

extension CalidadDeIntervalo {
    /// "justa", "mayor"… en español; "perfect", "major", "doubly diminished"… en inglés; "reine", "große" en
    /// alemán; "чистая", "большая" en ruso. Van en femenino, como los intervalos.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .justa: return TextosDeNucleo.en(notacion, \.calidadJusta)
        case .mayor: return TextosDeNucleo.en(notacion, \.calidadMayor)
        case .menor: return TextosDeNucleo.en(notacion, \.calidadMenor)
        case .aumentada(let n):
            return CalidadDeIntervalo.multiplicidad(n).en(notacion)
                + TextosDeNucleo.en(notacion, \.calidadAumentada)
        case .disminuida(let n):
            return CalidadDeIntervalo.multiplicidad(n).en(notacion)
                + TextosDeNucleo.en(notacion, \.calidadDisminuida)
        }
    }

    private static func multiplicidad(_ n: Int) -> Traduccion {
        switch n {
        case 1: return TextosDeNucleo.traduccion(\.multiplicidadSimple)
        case 2: return TextosDeNucleo.traduccion(\.multiplicidadDoble)
        case 3: return TextosDeNucleo.traduccion(\.multiplicidadTriple)
        default: return TextosDeNucleo.traduccion { $0.multiplicidad(n) }
        }
    }
}

// MARK: - Intervalo

extension Intervalo {
    /// "3ª mayor" en español; "major third", "descending minor sixth" en inglés; "3a major" en catalán;
    /// "beheranzko 6. txikia" en euskera; "tierce majeure" en francés; "große Terz" en alemán; "большая терция"
    /// en ruso.
    public func nombre(en notacion: Notacion) -> String {
        let ordinal = Intervalo.ordinal(numero, en: notacion.textos)
        let calidad = self.calidad.nombre(en: notacion)
        // El unísono es masculino en francés, occitano e italiano: "unisson augmenté".
        let concordada = numero == 1 ? TextosDeNucleo.en(notacion, { $0.unisonoEnMasculino(calidad) }) : calidad
        let nombre = TextosDeNucleo.en(notacion) { $0.nombreDeIntervalo(concordada, ordinal) }
        return sentido == .descendente ? Intervalo.plantillaDescendente.en(notacion).rellenada(con: nombre) : nombre
    }

    /// Dónde va «descendente» en cada idioma: delante o detrás del nombre (`_`).
    private static let plantillaDescendente = TextosDeNucleo.traduccion(\.plantillaDescendente)

    /// El nombre del n-ésimo intervalo: "third", "tierce", "Terz", "терция"… hasta la doble octava, y después en
    /// cifras ("16th", "16e"). En los idiomas que escriben los intervalos con número, en cifras: "3ª", "3a", "3.".
    package static func ordinal(_ n: Int, en idioma: Idioma) -> String {
        let nombres = TextosDeNucleo.en(idioma: idioma, \.ordinales)
        return nombres.indices.contains(n - 1) ? nombres[n - 1] : ordinalEnCifras(n, en: idioma)
    }

    /// "1ª", "21st", "16e", "16.", "16-я", "16η"…
    package static func ordinalEnCifras(_ n: Int, en idioma: Idioma) -> String {
        TextosDeNucleo.en(idioma: idioma) { $0.ordinalEnCifras(n) }
    }

    /// "1st", "2nd", "3rd", "4th", "11th", "21st"…
    package static func ordinalInglesEnCifras(_ n: Int) -> String {
        let sufijo: String
        switch (n % 100, n % 10) {
        case (11...13, _): sufijo = "th"
        case (_, 1): sufijo = "st"
        case (_, 2): sufijo = "nd"
        case (_, 3): sufijo = "rd"
        default: sufijo = "th"
        }
        return "\(n)\(sufijo)"
    }
}

// MARK: - Consonancia

extension Consonancia {
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .perfecta:
            return TextosDeNucleo.en(notacion, \.consonanciaPerfecta)
        case .imperfecta:
            return TextosDeNucleo.en(notacion, \.consonanciaImperfecta)
        case .disonancia:
            return TextosDeNucleo.en(notacion, \.disonancia)
        }
    }
}
