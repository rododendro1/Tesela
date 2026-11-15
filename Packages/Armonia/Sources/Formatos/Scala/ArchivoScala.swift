import Elementos
import Foundation
import Teoria

// Los ficheros de afinación de Scala: `.scl` (los pasos de una escala o un temperamento) y `.kbm` (qué tecla MIDI
// toca cada paso). Son los que leen casi todos los sintetizadores y los del archivo de Scala de Manuel Op de Coul,
// con miles de escalas.
//
//     ! werckmeister-iii.scl
//     !
//     Werckmeister III
//      12
//     !
//      90.225
//      192.180
//      …
//      2/1
//
// Una línea que empieza por `!` es un comentario. La primera que no lo es, la descripción; la segunda, cuántos pasos
// siguen, y cada uno de los siguientes, un paso: en cents si lleva un punto (`701.955`), y si no, como razón (`3/2`,
// o `2`, que es `2/1`). El 1/1 no se escribe y el último paso es el periodo, casi siempre la octava.

// MARK: - El fichero .scl

/// Un fichero `.scl` de Scala: una descripción y los pasos desde la nota de partida, sin el 1/1 y con el periodo
/// (casi siempre 2/1) al final.
///
///     let scl = ArchivoScala(.werckmeisterIII)
///     scl.pasos.count              // 12: once teclas y la octava
///     scl.texto()                  // "! werckmeister-iii.scl\n!\nWerckmeister III\n 12\n!\n 90.225000\n…"
///     try ArchivoScala(leyendo: scl.texto()).parecidos().first?.elemento   // .temperamento(.werckmeisterIII)
public struct ArchivoScala: Hashable, Sendable {
    /// La línea de la descripción.
    public var descripcion: String
    /// Los pasos, sin el 1/1 y con el periodo al final.
    public var pasos: [PasoDeScala]

    /// Una escala con esos pasos. Detiene el programa si no hay ninguno: el periodo, al menos, tiene que estar.
    public init(descripcion: String, pasos: [PasoDeScala]) {
        precondition(!pasos.isEmpty, "un fichero de Scala tiene al menos el periodo")
        self.descripcion = descripcion
        self.pasos = pasos
    }

    /// El periodo en cents: lo que mide el último paso (1200 si es la octava).
    public var periodo: Double { pasos[pasos.count - 1].cents }

    /// Los cents de cada nota del periodo desde la de partida: 0 y los pasos, sin el periodo.
    public var cents: [Double] { [0] + pasos.dropLast().map(\.cents) }

    /// Las notas del periodo: los pasos con el 1/1 y sin el periodo.
    public var notasPorPeriodo: Int { pasos.count }
}

/// Un paso de un fichero de Scala: en cents o como razón de frecuencias.
public enum PasoDeScala: Hashable, Sendable, CustomStringConvertible {
    case cents(Double)
    /// Numerador y denominador, positivos.
    case razon(Int, Int)

    /// Lo que mide, en cents.
    public var cents: Double {
        switch self {
        case .cents(let cents): return cents
        case .razon(let numerador, let denominador): return 1200 * log2(Double(numerador) / Double(denominador))
        }
    }

    /// Como se escribe en el fichero: los cents con seis decimales y punto (`701.955001`), la razón con su barra
    /// (`3/2`).
    public var description: String {
        switch self {
        case .cents(let cents): return String(format: "%.6f", locale: Locale(identifier: "en_US_POSIX"), cents)
        case .razon(let numerador, let denominador): return "\(numerador)/\(denominador)"
        }
    }
}

// MARK: - Leer

extension ArchivoScala {
    /// Lee el texto de un fichero `.scl`. Lanza ``ErrorDeLecturaDeScala`` si le falta la cuenta de los pasos, si
    /// tiene menos pasos de los que dice, o si un paso no es un número de cents ni una razón positiva. Lo que va
    /// detrás del valor en la línea de un paso (un comentario, un nombre) no cuenta, y tampoco las líneas que sobran.
    public init(leyendo texto: String) throws(ErrorDeLecturaDeScala) {
        // Los finales de línea de Windows y los antiguos de Mac, también.
        let todas = texto.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
            .split(separator: "\n", omittingEmptySubsequences: false).enumerated()
            .filter { !$0.element.hasPrefix("!") }
        guard let primera = todas.first else { throw .sinDescripcion }
        let descripcion = primera.element.trimmingCharacters(in: .whitespaces)
        // Tras la descripción, que puede estar en blanco, las líneas en blanco no cuentan.
        let lineas = [primera] + todas.dropFirst().filter { !$0.element.allSatisfy(\.isWhitespace) }
        guard lineas.count > 1 else { throw .sinCuenta }
        let cuenta = lineas[1]
        guard let total = Int(Self.primerValor(cuenta.element)), total >= 1, total <= Self.maximoDePasos else {
            throw .cuentaNoValida(linea: cuenta.offset + 1, String(cuenta.element))
        }
        let pasosEscritos = lineas.dropFirst(2).prefix(total)
        guard pasosEscritos.count == total else { throw .faltanPasos(esperados: total, hallados: pasosEscritos.count) }
        var pasos: [PasoDeScala] = []
        for (numero, linea) in pasosEscritos {
            guard let paso = Self.paso(Self.primerValor(linea)) else {
                throw .pasoNoValido(linea: numero + 1, String(linea).trimmingCharacters(in: .whitespaces))
            }
            pasos.append(paso)
        }
        self.init(descripcion: descripcion, pasos: pasos)
    }

    /// Los pasos que se aceptan en un fichero, para que uno estropeado no pida memoria sin fin.
    static let maximoDePasos = 10_000

    /// La primera palabra de una línea.
    private static func primerValor(_ linea: Substring) -> String {
        linea.split(whereSeparator: \.isWhitespace).first.map(String.init) ?? ""
    }

    /// Un paso escrito: con punto, en cents; si no, una razón (`3/2`) o un entero (`2`, que es `2/1`).
    static func paso(_ texto: String) -> PasoDeScala? {
        if texto.contains(".") {
            guard let cents = Double(texto), cents.isFinite else { return nil }
            return .cents(cents)
        }
        let partes = texto.split(separator: "/", omittingEmptySubsequences: false)
        guard (1...2).contains(partes.count), let numerador = Int(partes[0]), numerador > 0 else { return nil }
        guard partes.count == 2 else { return .razon(numerador, 1) }
        guard let denominador = Int(partes[1]), denominador > 0 else { return nil }
        return .razon(numerador, denominador)
    }
}

/// Por qué no se puede leer un fichero `.scl`.
public enum ErrorDeLecturaDeScala: ErrorDeArmonia, Hashable {
    /// El fichero está vacío o solo tiene comentarios.
    case sinDescripcion
    /// Tras la descripción no viene la cuenta de los pasos.
    case sinCuenta
    /// La cuenta de los pasos no es un número de 1 a 10.000; la línea, contando desde 1.
    case cuentaNoValida(linea: Int, String)
    /// Dice más pasos de los que tiene.
    case faltanPasos(esperados: Int, hallados: Int)
    /// Un paso no es un número de cents ni una razón positiva; la línea, contando desde 1.
    case pasoNoValido(linea: Int, String)

    public func descripcion(en notacion: Notacion) -> String {
        switch self {
        case .sinDescripcion: return TextosDeFormatos.en(notacion, \.sclVacio)
        case .sinCuenta: return TextosDeFormatos.en(notacion, \.sclSinCuenta)
        case .cuentaNoValida(let linea, let texto):
            return TextosDeFormatos.en(notacion) { $0.sclCuentaNoValida(linea, texto) }
        case .faltanPasos(let esperados, let hallados):
            return TextosDeFormatos.en(notacion) { $0.sclFaltanPasos(esperados, hallados) }
        case .pasoNoValido(let linea, let texto):
            return TextosDeFormatos.en(notacion) { $0.sclPasoNoValido(linea, texto) }
        }
    }
}

// MARK: - Escribir

extension ArchivoScala {
    /// El texto del fichero, con su nombre en el primer comentario (si se da) y un paso por línea.
    public func texto(nombreDeArchivo: String? = nil) -> String {
        var lineas: [String] = []
        if let nombreDeArchivo { lineas.append("! " + nombreDeArchivo) }
        lineas += ["!", descripcion.replacingOccurrences(of: "\n", with: " "), " \(pasos.count)", "!"]
        lineas += pasos.map { " " + $0.description }
        return lineas.joined(separator: "\n") + "\n"
    }

    /// Un nombre de fichero para la descripción, en minúsculas, sin tildes y con guiones: «Werckmeister III» da
    /// `werckmeister-iii.scl`.
    public var nombreDeArchivo: String { Self.nombreDeArchivo(descripcion) + ".scl" }

    /// Un nombre de fichero sin la extensión, en ASCII.
    static func nombreDeArchivo(_ texto: String) -> String {
        let plano = texto.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .init(identifier: "en"))
        let palabras = plano.split { !($0.isASCII && ($0.isLetter || $0.isNumber)) }
        return palabras.isEmpty ? "escala" : palabras.joined(separator: "-")
    }
}

// MARK: - Del catálogo

extension ArchivoScala {
    /// Un temperamento del catálogo, con su nombre en el idioma de la notación y sus pasos desde Do (desde el primero
    /// en los de otras tradiciones). La afinación justa y los 22 śruti van en razones; los demás, en cents.
    public init(_ temperamento: TemperamentoConNombre, en notacion: Notacion = .compacta(.espanol)) {
        let pasos: [PasoDeScala]
        if let razones = Self.razones(de: temperamento) {
            pasos = razones.dropFirst().map { .razon($0.numerador, $0.denominador) }
        } else {
            pasos = temperamento.pasos.dropFirst().map { .cents($0) }
        }
        self.init(descripcion: temperamento.nombre(en: notacion), pasos: pasos + [.razon(2, 1)])
    }

    /// Las razones de los pasos de la justa (las de Ptolomeo, desde Do) y de los śruti; `nil` en los demás.
    private static func razones(de temperamento: TemperamentoConNombre) -> [(numerador: Int, denominador: Int)]? {
        let razones: [RazonDeFrecuencias]
        if temperamento == .afinacionJusta {
            // Las doce teclas como las afina el catálogo: de Mi♭ a Sol♯ por quintas.
            let teclas: [(NotaNatural, Int)] = [
                (.do, 0), (.do, 1), (.re, 0), (.mi, -1), (.mi, 0), (.fa, 0), (.fa, 1), (.sol, 0), (.sol, 1), (.la, 0),
                (.si, -1), (.si, 0),
            ]
            let doCuatro = Altura(.do, octava: 4)
            razones = teclas.map { (Altura(Nota($0.0, Alteracion($0.1)), octava: 4) - doCuatro).razonJusta }
        } else if temperamento.sistemaDeAlturas == .sruti {
            razones = SistemaDeAlturas.razonesDeLosSruti
        } else {
            return nil
        }
        return razones.map { (Int($0.numerador), Int($0.denominador)) }
    }

    /// Una escala, con sus microtonos si los tiene (`AfinacionPropia`) o, si se da, en un temperamento que afina sus
    /// notas (`Escala.cents(con:)`); si no, en temperamento igual. Los pasos van desde la tónica, al subir. Los de una
    /// escala en los 22 śruti van en razones.
    ///
    ///     ArchivoScala(Escala(.re, .bayati)).cents   // 0, 150, 300, 500, 700, 800, 1000
    public init(
        _ escala: Escala, temperamento: TemperamentoQueAfina? = nil, en notacion: Notacion = .compacta(.espanol)
    ) {
        let descripcion = escala.nombre(en: notacion)
        let octava = PasoDeScala.razon(2, 1)
        if let temperamento {
            let cents = escala.cents(con: temperamento)
            let nombre = descripcion + " (" + temperamento.nombre(en: notacion) + ")"
            self.init(descripcion: nombre, pasos: cents.dropFirst().map { .cents($0) } + [octava])
            return
        }
        guard let propia = escala.tipo.afinacionPropia else {
            let cents = escala.tipo.intervalos.map { Double(100 * $0.semitonos) }
            self.init(descripcion: descripcion, pasos: cents.dropFirst().map { .cents($0) } + [octava])
            return
        }
        if propia.sistema == .sruti {
            let inicio = propia.pasos[0]
            let razones = propia.pasos.map { paso -> PasoDeScala in
                let relativo = paso - inicio
                let indice = ((relativo % 22) + 22) % 22
                let octavas = Int((Double(relativo) / 22).rounded(.down))
                let razon = SistemaDeAlturas.razonesDeLosSruti[indice]
                let numerador = Int(razon.numerador) * (octavas > 0 ? 1 << octavas : 1)
                let denominador = Int(razon.denominador) * (octavas < 0 ? 1 << -octavas : 1)
                return .razon(numerador, denominador)
            }
            self.init(descripcion: descripcion, pasos: Array(razones.dropFirst()) + [octava])
            return
        }
        // Desde la tónica misma, aunque sea un microtono (Sīkāh empieza un cuarto de tono bajo Mi).
        let cents = propia.cents
        let inicio = cents.first ?? 0
        self.init(descripcion: descripcion, pasos: cents.dropFirst().map { .cents($0 - inicio) } + [octava])
    }
}

// MARK: - Parecidos

/// Lo que se parece en el catálogo a un fichero de Scala: un temperamento o una escala con tantas notas como él, y lo
/// que más se aparta una de sus notas.
public struct ParecidoDeScala: Hashable, Sendable {
    /// Un temperamento o un tipo de escala.
    public enum Coincidente: Hashable, Sendable {
        case temperamento(TemperamentoConNombre)
        case escala(TipoDeEscala)
    }

    public let elemento: Coincidente
    /// Lo que más se aparta una nota del fichero de la del catálogo, en cents.
    public let desviacionMaxima: Double
    /// En un temperamento, el paso desde el que empieza el fichero (0: desde Do, o desde el primero); en una escala,
    /// 0.
    public let desde: Int
}

extension ArchivoScala {
    /// Lo que se le parece en el catálogo, de más a menos parecido: los temperamentos con tantos pasos como notas
    /// tiene, empezando por cualquiera de ellos, y los tipos de escala con tantos grados, desde la tónica. Solo los
    /// que no se apartan en ninguna nota más de `tolerancia` cents, y solo si el periodo es la octava (con la misma
    /// tolerancia).
    ///
    ///     try ArchivoScala(leyendo: texto).parecidos(tolerancia: 5).first?.elemento   // .temperamento(.vallotti)
    public func parecidos(tolerancia: Double = 10, limite: Int = 10) -> [ParecidoDeScala] {
        guard abs(periodo - 1200) <= tolerancia else { return [] }
        let propios = cents
        var hallados: [ParecidoDeScala] = []
        for temperamento in TemperamentoConNombre.catalogo where temperamento.pasosPorOctava == propios.count {
            let suyos = temperamento.pasos
            // Desde cada paso: el fichero puede empezar en La o en cualquier otra nota.
            let mejor = suyos.indices.map { desde in
                (desde, Self.desviacion(propios, Self.rotados(suyos, desde: desde)))
            }.min { $0.1 < $1.1 }
            if let (desde, desviacion) = mejor, desviacion <= tolerancia {
                hallados.append(
                    .init(elemento: .temperamento(temperamento), desviacionMaxima: desviacion, desde: desde))
            }
        }
        for tipo in TipoDeEscala.catalogo where tipo.intervalos.count == propios.count {
            let suyos =
                tipo.afinacionPropia.map { propia in propia.cents.map { $0 - (propia.cents.first ?? 0) } }
                ?? tipo.intervalos.map { Double(100 * $0.semitonos) }
            let desviacion = Self.desviacion(propios, suyos)
            if desviacion <= tolerancia {
                hallados.append(.init(elemento: .escala(tipo), desviacionMaxima: desviacion, desde: 0))
            }
        }
        // De más a menos parecido; a igual desviación, los que empiezan donde el fichero, y luego los temperamentos y
        // el orden del catálogo.
        // Las desviaciones, a la milésima de cent: lo que escribe un .scl con seis decimales es la misma nota.
        func clave(_ parecido: ParecidoDeScala) -> (Double, Int) {
            (Redondeo.valor(parecido.desviacionMaxima), parecido.desde == 0 ? 0 : 1)
        }
        let ordenados = hallados.enumerated().sorted {
            (clave($0.element).0, clave($0.element).1, $0.offset) < (
                clave($1.element).0, clave($1.element).1, $1.offset
            )
        }
        return ordenados.prefix(max(0, limite)).map(\.element)
    }

    /// Los pasos de una octava empezando por `desde`, desde 0.
    static func rotados(_ pasos: [Double], desde: Int) -> [Double] {
        let inicio = pasos[desde]
        return (0..<pasos.count).map { i in
            let paso = pasos[(desde + i) % pasos.count] - inicio
            return paso < -1e-9 ? paso + 1200 : paso
        }
    }

    /// Lo que más se apartan dos listas de cents de la misma longitud.
    static func desviacion(_ a: [Double], _ b: [Double]) -> Double {
        zip(a, b).map { abs($0 - $1) }.max() ?? 0
    }
}

// MARK: - El fichero .kbm

/// Un fichero `.kbm` de Scala: qué tecla MIDI toca cada paso de un `.scl` y con qué frecuencia. Con un mapa vacío, cada
/// tecla toca el paso siguiente (lineal); con uno de doce teclas, cada tecla de la octava toca el paso que dice, o
/// ninguno.
///
///     MapaDeTeclado(Escala(.re, .bayati)).texto()   // las teclas de Re, Mi, Fa, Sol, La, Si♭ y Do; las demás, x
public struct MapaDeTeclado: Hashable, Sendable {
    /// La primera y la última tecla que suenan.
    public var primera: Int
    public var ultima: Int
    /// La tecla que toca el paso 0 (la nota de partida del `.scl`).
    public var central: Int
    /// La tecla de la que se da la frecuencia, y esa frecuencia en Hz.
    public var referencia: Int
    public var frecuencia: Double
    /// El paso del `.scl` que es el periodo del mapa (la octava): en uno lineal, el número de notas del periodo.
    public var gradoDelPeriodo: Int
    /// El paso que toca cada tecla de un periodo del mapa desde la central; `nil` en una que no suena. Vacío en uno
    /// lineal.
    public var teclas: [Int?]

    public init(
        primera: Int = 0, ultima: Int = 127, central: Int, referencia: Int, frecuencia: Double,
        gradoDelPeriodo: Int, teclas: [Int?] = []
    ) {
        self.primera = primera
        self.ultima = ultima
        self.central = central
        self.referencia = referencia
        self.frecuencia = frecuencia
        self.gradoDelPeriodo = gradoDelPeriodo
        self.teclas = teclas
    }

    /// El de un temperamento del catálogo: lineal, con el Do4 (la tecla 60) en el primer paso y a la frecuencia que
    /// le da el temperamento con el La4 a `la4` Hz (la del temperamento igual en los de otras tradiciones).
    public init(_ temperamento: TemperamentoConNombre, la4: Double = 440) {
        let doCuatro = Altura(.do, octava: 4)
        let frecuencia =
            temperamento.afinacion(frecuenciaDelLa4: la4)?.frecuencia(de: doCuatro)
            ?? doCuatro.frecuencia(frecuenciaDelLa4: la4)
        let doce = temperamento.pasosPorOctava == 12
        self.init(
            central: 60, referencia: 60, frecuencia: frecuencia, gradoDelPeriodo: temperamento.pasosPorOctava,
            teclas: doce ? Array(0..<12) : [])
    }

    /// El de una escala: cada tecla de la octava toca el grado de la escala que cae en ella, y las demás no suenan,
    /// con la tónica en la octava 4 a su frecuencia en temperamento igual (con el La4 a `la4` Hz). Una escala de más
    /// de doce notas, o con dos en la misma tecla, va lineal.
    public init(_ escala: Escala, la4: Double = 440) {
        let tonica = Altura(escala.tonica, octava: 4)
        let semitonos = escala.tipo.intervalos.map { (($0.semitonos % 12) + 12) % 12 }
        let grados = escala.tipo.intervalos.count
        var teclas: [Int?] = []
        if grados <= 12, Set(semitonos).count == grados {
            teclas = (0..<12).map { semitonos.firstIndex(of: $0) }
        }
        self.init(
            central: tonica.midi, referencia: tonica.midi, frecuencia: tonica.frecuencia(frecuenciaDelLa4: la4),
            gradoDelPeriodo: grados, teclas: teclas)
    }

    /// El texto del fichero, cada valor con su comentario.
    public func texto(nombreDeArchivo: String? = nil) -> String {
        var lineas: [String] = []
        if let nombreDeArchivo { lineas += ["! " + nombreDeArchivo, "!"] }
        let hercios = String(format: "%.6f", locale: Locale(identifier: "en_US_POSIX"), frecuencia)
        lineas += [
            "! Map size:", "\(teclas.count)",
            "! First MIDI note number to retune:", "\(primera)",
            "! Last MIDI note number to retune:", "\(ultima)",
            "! Middle note where the first entry of the mapping is mapped to:", "\(central)",
            "! Reference note for which frequency is given:", "\(referencia)",
            "! Frequency to tune the above note to:", hercios,
            "! Scale degree to consider as formal octave:", "\(gradoDelPeriodo)",
            "! Mapping.",
        ]
        lineas += teclas.map { $0.map(String.init) ?? "x" }
        return lineas.joined(separator: "\n") + "\n"
    }
}
