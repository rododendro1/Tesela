import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Lectura de ABC 2.1 (abcnotation.com): la primera melodía del texto, como las que exportan EasyABC, abcjs, los
// cancioneros de folk y `abc()`.
//
// De la cabecera: el título (`T:`), el compás (`M:`), la unidad (`L:`, o la que corresponde al compás), el tempo
// (`Q:`) y la tonalidad (`K:`, con sus modos). En la música: las notas con sus alteraciones (que valen hasta la barra,
// en esa octava), los cuartos de tono (`^/`, `_3/2`), las octavas (`c'`, `C,`), las duraciones (`3/2`, `/`, `//`), los
// acordes (`[CEG]`), los silencios (`z`, `x`, `Z`), las ligaduras (`-`), el ritmo con puntillo (`>`, `<`), los grupos
// irregulares (`(3`, `(p:q:r`) y cada voz (`V:`) como una parte. Los cambios en medio (`[K:…]`, `[M:…]`, `[L:…]`)
// valen desde ahí. De las decoraciones, la dinámica (`!mf!`) y las articulaciones (`.`, `!tenuto!`, `!>!`,
// `!fermata!`…) van con la nota siguiente. Las notas de adorno (`{…}`) van aparte, sin duración. Las repeticiones
// (`|:`, `:|`, `::`), las casillas (`|1`, `:|2`, `[1`) y los saltos (`!D.C.!`, `!D.S.!`, `!fine!`, `!segno!`,
// `!coda!`, `!dacoda!`) de la primera voz se despliegan. No cuentan los adornos (`!trill!`, `~`), los cifrados y los
// textos entre comillas ni la letra (`w:`).

extension PiezaImportada {
    /// Lee la primera melodía de un texto en ABC.
    ///
    ///     let abc = voz.abc(titulo: "Escala")
    ///     let pieza = try PiezaImportada(abc: abc)
    public init(abc texto: String) throws {
        var lector = LectorABC()
        lector.leer(texto)
        guard !lector.notas.isEmpty else { throw ErrorDeImportacion.sinNotas }
        let fin = PulsosDeLectura.duracion(lector.finDeLaPieza)
        self.init(
            titulo: lector.titulo, tonalidad: lector.tonalidad, compas: lector.compas, tempo: lector.tempo,
            notas: CompasLeido.desplegar(lector.notas, compases: lector.compases, fin: fin),
            notasDeAdorno: CompasLeido.desplegar(lector.adornos, compases: lector.compases, fin: fin))
    }

    /// Si el texto parece ABC: su primera línea con algo (sin contar los comentarios) es `X:`, o empieza por `%abc`.
    static func pareceABC(_ datos: Data) -> Bool {
        let inicio = String(decoding: datos.prefix(4096), as: UTF8.self)
        if inicio.hasPrefix("%abc") || inicio.hasPrefix("\u{FEFF}%abc") { return true }
        for linea in inicio.split(whereSeparator: \.isNewline) {
            let limpia = linea.trimmingCharacters(in: .whitespaces)
            if limpia.isEmpty || limpia.hasPrefix("%") { continue }
            return limpia.hasPrefix("X:") || limpia.hasPrefix("\u{FEFF}X:")
        }
        return false
    }
}

struct LectorABC {
    private(set) var titulo: String?
    private(set) var tonalidad: Tonalidad?
    private(set) var compas: Compas?
    private(set) var tempo: Tempo?
    private(set) var notas: [NotaDeLaPieza] = []
    private(set) var adornos: [NotaDeLaPieza] = []
    /// Los compases de la primera voz, con sus repeticiones y sus saltos.
    private(set) var compases: [CompasLeido] = []
    /// Las casillas abiertas (`|1`, `[2`): valen hasta una repetición, una doble barra u otra casilla.
    private var casillas: Set<Int>?

    /// Donde acaba la primera voz, en pulsos.
    var finDeLaPieza: Int { voces.values.first { $0.parte == 0 }?.posicion ?? 0 }

    /// La unidad de las duraciones (`L:`), en pulsos; `nil` hasta que se da o se deduce del compás.
    private var unidad: Int?
    private var duracionDelCompas = PulsosDeLectura.porRedonda
    private var compuesto = false
    private var armadura: [NotaNatural: Int] = [:]
    private var tempoSinUnidad: Double?

    /// Lo que lleva cada voz.
    private struct Voz {
        var parte: Int
        var posicion = 0
        /// Las alteraciones escritas en el compás, por lugar (octava y nota natural), en cents.
        var vigentes: [Int: Double] = [:]
        /// Las notas con una ligadura que sigue, por altura MIDI: su índice en `notas`.
        var ligadas: [Int: Int] = [:]
        /// El grupo irregular en curso: cuántas notas le quedan y en qué proporción duran.
        var irregular: (quedan: Int, normales: Int, reales: Int)?
        /// Lo que el ritmo con puntillo (`>`, `<`) le cambia a la siguiente nota.
        var siguiente: (Int, Int)?
    }
    private var voces: [String: Voz] = [:]
    private var actual = "1"
    private var enLaMusica = false

    /// Las notas del último evento (una nota o un acorde), para las ligaduras y el ritmo con puntillo.
    private var ultimo: (indices: [Int], inicio: Int, pulsos: Int)?
    /// La dinámica y las articulaciones leídas que esperan a la nota siguiente.
    private var pendientes: (dinamica: Dinamica?, articulaciones: [Articulacion]) = (nil, [])

    /// Las decoraciones que son articulaciones.
    private static let decoraciones: [String: Articulacion] = [
        "staccato": .staccato, "wedge": .staccatissimo, "tenuto": .tenuto, ">": .acento, "accent": .acento,
        "emphasis": .acento, "marcato": .marcato, "fermata": .calderon,
    ]

    /// Una decoración (`!mf!`, `!fermata!`): si es una dinámica o una articulación, para la nota siguiente.
    private mutating func decoracion(_ nombre: String) {
        switch nombre.lowercased() {
        case "segno": marcar { $0.segno = true }
        case "coda": marcar { $0.coda = true }
        case "dacoda": marcar { $0.alCoda = true }
        case let otro where otro.hasPrefix("d.c.") || otro.hasPrefix("d.s.") || otro == "fine" || otro == "dacapo":
            marcar { $0.leer(indicacion: otro) }
        default: break
        }
        if let dinamica = Dinamica(rawValue: nombre) {
            pendientes.dinamica = dinamica
        } else if let articulacion = LectorABC.decoraciones[nombre] {
            pendientes.articulaciones.append(articulacion)
        }
    }

    mutating func leer(_ texto: String) {
        var empezada = false
        for linea in texto.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline) {
            let linea = String(linea)
            let limpia = linea.trimmingCharacters(in: .whitespaces)
            if limpia.hasPrefix("X:") {
                if empezada { break } // la melodía siguiente
                empezada = true
                continue
            }
            if limpia.hasPrefix("%") || limpia.isEmpty { continue }
            if let campo = LectorABC.campo(limpia) {
                cabecera(campo.letra, campo.valor)
                continue
            }
            if !enLaMusica {
                // Música sin `K:`: se empieza como si se hubiera dado.
                cabecera("K", "C")
            }
            musica(Array(linea.unicodeScalars))
            if notas.count > 1_000_000 { break }
        }
        if let abiertas = casillas { marcar { $0.casillas = abiertas } }
    }

    /// `T:Título` → ("T", "Título"): una letra y dos puntos al principio de la línea.
    private static func campo(_ linea: String) -> (letra: Character, valor: String)? {
        let caracteres = Array(linea)
        guard caracteres.count >= 2, caracteres[1] == ":", caracteres[0].isASCII, caracteres[0].isLetter else {
            return nil
        }
        // Una línea de música que empieza por una nota seguida de una barra con repetición («A:|») no es un campo.
        if "ABCDEFGabcdefg".contains(caracteres[0]), caracteres.count > 2, caracteres[2] == "|" { return nil }
        return (caracteres[0], String(caracteres.dropFirst(2)).trimmingCharacters(in: .whitespaces))
    }

    private mutating func cabecera(_ letra: Character, _ valor: String) {
        switch letra {
        case "T":
            if titulo == nil, !valor.isEmpty { titulo = valor }
        case "M":
            leerCompas(valor)
        case "L":
            if let duracion = LectorABC.fraccion(valor), duracion > .cero, duracion <= Duracion(16) {
                unidad = PulsosDeLectura.de(duracion)
            }
        case "Q":
            leerTempo(valor)
        case "K":
            leerTonalidad(valor)
            if !enLaMusica {
                enLaMusica = true
                if unidad == nil {
                    // Sin `L:`, la semicorchea si el compás es de menos de 3/4 y la corchea si no.
                    unidad =
                        PulsosDeLectura.porRedonda / (duracionDelCompas * 4 < 3 * PulsosDeLectura.porRedonda ? 16 : 8)
                }
                if tempo == nil, let bpm = tempoSinUnidad, let unidad {
                    tempo = Tempo(comprobando: bpm, unidad: PulsosDeLectura.duracion(unidad))
                }
            }
        case "V":
            let nombre = String(valor.prefix { !$0.isWhitespace })
            cambiarDeVoz(nombre.isEmpty ? "1" : nombre)
        default:
            break // w:, W:, P:, R:, C:, N:… no cambian las notas
        }
    }

    private mutating func cambiarDeVoz(_ nombre: String) {
        actual = nombre
        ultimo = nil
        if voces[nombre] == nil { voces[nombre] = Voz(parte: voces.count) }
    }

    private mutating func leerCompas(_ valor: String) {
        let texto = valor.trimmingCharacters(in: .whitespaces)
        let resultado: Compas?
        switch texto {
        case "C": resultado = .compasillo
        case "C|": resultado = .partido
        case "none", "": resultado = nil
        default:
            let partes = texto.split(separator: "/")
            guard partes.count == 2, let unidad = Int(partes[1].trimmingCharacters(in: .whitespaces)) else { return }
            let numeradores = partes[0].trimmingCharacters(in: CharacterSet(charactersIn: "() ")).split(separator: "+")
                .map { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard !numeradores.isEmpty, !numeradores.contains(nil) else { return }
            let total = numeradores.compactMap { $0 }.reduce(0, +)
            resultado = total <= 1000 ? Compas(comprobando: total, unidad) : nil
        }
        guard let leido = resultado else { return }
        if compas == nil { compas = leido }
        duracionDelCompas = PulsosDeLectura.de(leido.duracion)
        compuesto = leido.numerador % 3 == 0 && leido.numerador > 3 && leido.denominador >= 8
    }

    /// `Q:1/4=120`, `Q:"Allegro" 3/8=60` o `Q:120` (en la unidad de `L:`).
    private mutating func leerTempo(_ valor: String) {
        guard tempo == nil else { return }
        var texto = valor
        while let abre = texto.firstIndex(of: "\""),
            let cierra = texto[texto.index(after: abre)...].firstIndex(of: "\"")
        {
            texto.removeSubrange(abre...cierra)
        }
        let partes = texto.split(separator: "=")
        if partes.count == 2, let bpm = Double(partes[1].trimmingCharacters(in: .whitespaces)), bpm > 0, bpm < 10_000 {
            let figuras = partes[0].split(separator: " ").compactMap { LectorABC.fraccion(String($0)) }
            let unidad = figuras.reduce(Duracion.cero, +)
            if unidad > .cero, unidad <= Duracion(16) { tempo = Tempo(comprobando: bpm, unidad: unidad) }
        } else if partes.count == 1, let bpm = Double(texto.trimmingCharacters(in: .whitespaces)), bpm > 0,
            bpm < 10_000
        {
            if let unidad {
                tempo = Tempo(comprobando: bpm, unidad: PulsosDeLectura.duracion(unidad))
            } else {
                tempoSinUnidad = bpm
            }
        }
    }

    /// `K:G`, `K:F#m`, `K:Bb dor`, `K:none`: la armadura y, si es mayor o menor, la tonalidad.
    private mutating func leerTonalidad(_ valor: String) {
        let palabras = valor.split(separator: " ").map(String.init)
        guard let primera = palabras.first, primera != "none", let letra = primera.first,
            let natural = ["C", "D", "E", "F", "G", "A", "B"].firstIndex(of: String(letra)).flatMap(
                NotaNatural.init(rawValue:))
        else {
            if valor.hasPrefix("none") || valor.isEmpty { armadura = [:] }
            return
        }
        var resto = primera.dropFirst()
        var semitonos = 0
        if resto.first == "#" {
            semitonos = 1
            resto = resto.dropFirst()
        } else if resto.first == "b" {
            semitonos = -1
            resto = resto.dropFirst()
        }
        // El modo: pegado a la tónica («Am») o en la palabra siguiente («A minor»), sin contar `clef=`, etc.
        var modo = resto.lowercased()
        if modo.isEmpty, palabras.count > 1, !palabras[1].contains("=") { modo = palabras[1].lowercased() }
        let desplazamientos: [(String, Int)] = [
            ("maj", 0), ("ion", 0), ("mix", -1), ("dor", -2), ("min", -3), ("aeo", -3), ("phr", -4), ("loc", -5),
            ("lyd", 1), ("m", -3),
        ]
        guard let desplazamiento = modo.isEmpty ? 0 : desplazamientos.first(where: { modo.hasPrefix($0.0) })?.1 else {
            return
        }
        let quintas = Nota(natural, Alteracion(semitonos)).pasosDeQuinta + desplazamiento
        guard abs(quintas) <= 7 else { return }
        armadura = Dictionary(
            Tonalidad(armadura: quintas).notasDeLaArmadura.map { ($0.natural, $0.alteracion.semitonos) },
            uniquingKeysWith: { primera, _ in primera })
        let menor = desplazamiento == -3
        if tonalidad == nil, desplazamiento == 0 || menor {
            tonalidad = Tonalidad(armadura: quintas, modo: menor ? .menor : .mayor)
        }
    }

    /// `3/2` → 3/2, `1/8` → 1/8, `/` → 1/2, `3` → 3: una duración en ABC, como fracción.
    static func fraccion(_ texto: String) -> Duracion? {
        let partes = texto.split(separator: "/", omittingEmptySubsequences: false)
        guard partes.count <= 2, let numerador = partes[0].isEmpty ? 1 : Int(partes[0]), numerador > 0,
            numerador <= 10_000
        else { return nil }
        guard partes.count == 2 else { return Duracion(numerador) }
        guard let denominador = partes[1].isEmpty ? 2 : Int(partes[1]), denominador > 0, denominador <= 10_000 else {
            return nil
        }
        return Duracion(numerador, denominador)
    }

    // MARK: Música

    private mutating func musica(_ c: [Unicode.Scalar]) {
        if voces[actual] == nil { cambiarDeVoz(actual) }
        var i = 0
        func hasta(_ fin: Unicode.Scalar) {
            i += 1
            while i < c.count, c[i] != fin { i += 1 }
            i += 1
        }
        /// Si el carácter `k` es parte de una barra: `|`, `:`, `]` o el corchete de una casilla (`|[1`).
        func esDeLaBarra(_ k: Int) -> Bool {
            if c[k] == "|" || c[k] == ":" || c[k] == "]" { return true }
            return c[k] == "[" && k > 0 && c[k - 1] == "|" && k + 1 < c.count && LectorABC.cifra(c[k + 1]) != nil
        }
        /// Lo que hay entre `fin` y el siguiente `fin`, desde `i`, que queda detrás.
        func entre(_ fin: Unicode.Scalar) -> String {
            let inicio = i + 1
            hasta(fin)
            return String(String.UnicodeScalarView(c[inicio..<max(inicio, min(i - 1, c.count))]))
        }
        while i < c.count {
            let ch = c[i]
            switch ch {
            case "%":
                return
            case "\"":
                hasta("\"")
            case "!", "+":
                decoracion(entre(ch))
            case ".":
                pendientes.articulaciones.append(.staccato)
                i += 1
            case "{":
                // Las notas de adorno: empiezan donde empezará la nota a la que adornan.
                i += 1
                while i < c.count, c[i] != "}" {
                    if let nota = leerNota(c, &i) { adorno(nota.0, desvio: nota.1) } else { i += 1 }
                }
                i += 1
            case "-":
                ligar()
                i += 1
            case "(":
                i += 1
                if i < c.count, let p = LectorABC.cifra(c[i]) {
                    i += 1
                    var numeros = [p]
                    while numeros.count < 3, i < c.count, c[i] == ":" {
                        i += 1
                        var n: Int?
                        while i < c.count, let d = LectorABC.cifra(c[i]) {
                            n = (n ?? 0) * 10 + d
                            i += 1
                            if n! > 100 { break }
                        }
                        numeros.append(n ?? 0)
                    }
                    empezarIrregular(numeros)
                }
            case ">", "<":
                var n = 0
                while i < c.count, c[i] == ch, n < 3 {
                    n += 1
                    i += 1
                }
                puntillo(largo: ch == ">", veces: n)
            case "|", ":":
                let inicio = i
                while i < c.count, esDeLaBarra(i) { i += 1 }
                let signo = String(String.UnicodeScalarView(c[inicio..<i]))
                // La casilla que empieza: `|1`, `:|2`, `|1,3`, `|1-2`.
                let desde = i
                while i < c.count, LectorABC.cifra(c[i]) != nil || (i > desde && (c[i] == "," || c[i] == "-")) {
                    i += 1
                }
                let numeros = String(String.UnicodeScalarView(c[desde..<i]))
                barra(signo, casillas: numeros.isEmpty ? nil : LectorMusicXML.numerosDeCasilla(numeros))
            case "[":
                if i + 2 < c.count, c[i + 2] == ":", c[i + 1].properties.isAlphabetic {
                    // Un campo en medio: [K:D], [M:3/4], [V:2].
                    let letra = Character(c[i + 1])
                    var fin = i + 3
                    while fin < c.count, c[fin] != "]" { fin += 1 }
                    let valor = String(String.UnicodeScalarView(c[(i + 3)..<fin])).trimmingCharacters(in: .whitespaces)
                    i = fin + 1
                    cabecera(letra, valor)
                } else if i + 1 < c.count, LectorABC.cifra(c[i + 1]) != nil || c[i + 1] == "|" {
                    // `[1`, `[2`: una casilla; `[|`: una barra gruesa.
                    let inicio = i
                    i += 1
                    while i < c.count, LectorABC.cifra(c[i]) != nil || c[i] == "," || c[i] == "-" || c[i] == "|" {
                        i += 1
                    }
                    let leido = String(String.UnicodeScalarView(c[inicio..<i]))
                    let numeros = leido.filter { $0.isNumber || $0 == "," || $0 == "-" }
                    barra(
                        leido.filter { $0 == "[" || $0 == "|" },
                        casillas: numeros.isEmpty ? nil : LectorMusicXML.numerosDeCasilla(numeros))
                } else {
                    i += 1
                    var alturas: [(Altura, Double, Int?)] = []
                    var ligadasDentro = false
                    while i < c.count, c[i] != "]" {
                        if let nota = leerNota(c, &i) {
                            alturas.append(nota)
                        } else if c[i] == "-" {
                            ligadasDentro = true
                            i += 1
                        } else if c[i] == "\"" {
                            hasta("\"")
                        } else if c[i] == "!" {
                            decoracion(entre("!"))
                        } else {
                            i += 1
                        }
                    }
                    i += 1
                    let factor = LectorABC.leerLongitud(c, &i)
                    if let primera = alturas.first {
                        colocar(alturas.map { ($0.0, $0.1) }, pulsos: (primera.2 ?? 0) * factor.0 / factor.1)
                        if ligadasDentro { ligar() }
                    }
                }
            case "z", "x":
                i += 1
                let factor = LectorABC.leerLongitud(c, &i)
                silencio((unidad ?? 0) * factor.0 / factor.1)
            case "Z", "X":
                i += 1
                var compases = 0
                while i < c.count, let d = LectorABC.cifra(c[i]), compases < 10_000 {
                    compases = compases * 10 + d
                    i += 1
                }
                silencio(duracionDelCompas * max(1, compases))
                barra("|")
            default:
                if let nota = leerNota(c, &i) {
                    colocar([(nota.0, nota.1)], pulsos: nota.2 ?? 0)
                } else {
                    i += 1
                }
            }
        }
    }

    private static func cifra(_ c: Unicode.Scalar) -> Int? {
        ("0"..."9").contains(c) ? Int(c.value) - 48 : nil
    }

    /// `3`, `/`, `//`, `3/2`, `/4`: lo que multiplica a la unidad, como (numerador, denominador).
    private static func leerLongitud(_ c: [Unicode.Scalar], _ i: inout Int) -> (Int, Int) {
        var numerador = 0
        var hayNumerador = false
        while i < c.count, let d = cifra(c[i]), numerador < 10_000 {
            numerador = numerador * 10 + d
            hayNumerador = true
            i += 1
        }
        var denominador = 1
        while i < c.count, c[i] == "/", denominador < 1 << 12 {
            i += 1
            var n = 0
            var hayCifras = false
            while i < c.count, let d = cifra(c[i]), n < 10_000 {
                n = n * 10 + d
                hayCifras = true
                i += 1
            }
            denominador *= hayCifras ? max(1, n) : 2
        }
        return (hayNumerador ? numerador : 1, denominador)
    }

    /// Una nota: sus alteraciones, su letra, sus octavas y su duración. Devuelve la altura, el desvío en cents y lo
    /// que dura en pulsos; `nil` (sin avanzar) si en `i` no empieza una nota.
    private mutating func leerNota(_ c: [Unicode.Scalar], _ i: inout Int) -> (Altura, Double, Int?)? {
        var j = i
        var cents: Double?
        var signos = 0
        while j < c.count, c[j] == "^" || c[j] == "_" || c[j] == "=", signos < 3 {
            let paso: Double = c[j] == "^" ? 100 : c[j] == "_" ? -100 : 0
            cents = c[j] == "=" ? 0 : (cents ?? 0) + paso
            signos += 1
            j += 1
            // `^/` y `_/`: medio sostenido y medio bemol; `^3/2`: tres cuartos de tono.
            if j < c.count, paso != 0, c[j] == "/" || LectorABC.cifra(c[j]) != nil {
                var k = j
                let (n, d) = LectorABC.leerLongitud(c, &k)
                if k > j, d > 1 {
                    cents = (cents ?? 0) - paso + paso * Double(n) / Double(d)
                    j = k
                }
            }
        }
        let letras: [Unicode.Scalar] = ["C", "D", "E", "F", "G", "A", "B", "c", "d", "e", "f", "g", "a", "b"]
        guard j < c.count, let indice = letras.firstIndex(of: c[j]), let natural = NotaNatural(rawValue: indice % 7)
        else { return nil }
        var octava = indice >= 7 ? 5 : 4
        j += 1
        while j < c.count, c[j] == "'" || c[j] == "," {
            octava += c[j] == "'" ? 1 : -1
            j += 1
        }
        guard (-10...20).contains(octava) else { return nil }
        let factor = LectorABC.leerLongitud(c, &j)
        i = j
        guard var voz = voces[actual] else { return nil }
        let lugar = octava * 7 + natural.rawValue
        if let cents { voz.vigentes[lugar] = cents }
        voces[actual] = voz
        let total = cents ?? voz.vigentes[lugar] ?? 100 * Double(armadura[natural] ?? 0)
        let (semitonos, desvio) = alteracionYDesvio(cents: total)
        let altura = Altura(Nota(natural, Alteracion(semitonos)), octava: octava)
        return (altura, desvio, unidad.map { $0 * factor.0 / factor.1 })
    }

    private mutating func empezarIrregular(_ numeros: [Int]) {
        let reales = numeros[0]
        guard (2...9).contains(reales), var voz = voces[actual] else { return }
        let porDefecto = [2: 3, 3: 2, 4: 3, 6: 2, 8: 3][reales] ?? (compuesto ? 3 : 2)
        let normales = numeros.count > 1 && numeros[1] > 0 ? min(numeros[1], 64) : porDefecto
        let cuantas = numeros.count > 2 && numeros[2] > 0 ? min(numeros[2], 64) : reales
        voz.irregular = (cuantas, normales, reales)
        voces[actual] = voz
    }

    /// Lo que dura un evento en su grupo irregular y con el ritmo con puntillo de antes.
    private mutating func ajustar(_ pulsos: Int) -> Int {
        guard var voz = voces[actual] else { return pulsos }
        var resultado = pulsos
        if let (n, d) = voz.siguiente {
            resultado = resultado * n / d
            voz.siguiente = nil
        }
        if let irregular = voz.irregular {
            resultado = resultado * irregular.normales / irregular.reales
            voz.irregular = irregular.quedan > 1 ? (irregular.quedan - 1, irregular.normales, irregular.reales) : nil
        }
        voces[actual] = voz
        return resultado
    }

    private mutating func colocar(_ alturas: [(Altura, Double)], pulsos: Int) {
        let pulsos = ajustar(pulsos)
        guard pulsos > 0, var voz = voces[actual] else { return }
        let inicio = voz.posicion
        guard inicio + pulsos <= PulsosDeLectura.limite else { return }
        var indices: [Int] = []
        let desde = PulsosDeLectura.duracion(inicio)
        let duracion = PulsosDeLectura.duracion(pulsos)
        for (altura, desvio) in alturas {
            if let i = voz.ligadas[altura.midi], notas[i].fin == desde {
                notas[i] = notas[i].con(duracion: notas[i].duracion + duracion)
                indices.append(i)
            } else {
                notas.append(
                    NotaDeLaPieza(
                        altura: altura, inicio: desde, duracion: duracion, parte: voz.parte, desvio: desvio,
                        dinamica: pendientes.dinamica, articulaciones: pendientes.articulaciones))
                indices.append(notas.count - 1)
            }
        }
        pendientes = (nil, [])
        voz.ligadas = [:]
        voz.posicion = inicio + pulsos
        voces[actual] = voz
        ultimo = (indices, inicio, pulsos)
    }

    private mutating func silencio(_ pulsos: Int) {
        let pulsos = ajustar(pulsos)
        guard pulsos > 0, var voz = voces[actual] else { return }
        voz.posicion = min(voz.posicion + pulsos, PulsosDeLectura.limite + 1)
        voz.ligadas = [:]
        pendientes = (nil, [])
        voces[actual] = voz
        ultimo = nil
    }

    /// `-` después de una nota o de un acorde: se liga con la misma altura de lo que viene.
    private mutating func ligar() {
        guard let ultimo, var voz = voces[actual] else { return }
        for i in ultimo.indices { voz.ligadas[notas[i].altura.midi] = i }
        voces[actual] = voz
    }

    /// `>`: la nota de antes dura más y la siguiente menos (con uno, 3/2 y 1/2); `<`, al revés.
    private mutating func puntillo(largo: Bool, veces: Int) {
        guard let ultimo, var voz = voces[actual] else { return }
        let denominador = 1 << veces
        let corta = (1, denominador)
        let larga = (2 * denominador - 1, denominador)
        let (antes, despues) = largo ? (larga, corta) : (corta, larga)
        let nuevos = ultimo.pulsos * antes.0 / antes.1
        guard nuevos > 0 else { return }
        for i in ultimo.indices {
            let nota = notas[i]
            notas[i] = nota.con(
                duracion: nota.duracion - PulsosDeLectura.duracion(ultimo.pulsos) + PulsosDeLectura.duracion(nuevos))
        }
        voz.posicion = ultimo.inicio + nuevos
        voz.siguiente = despues
        voces[actual] = voz
        self.ultimo = (ultimo.indices, ultimo.inicio, nuevos)
    }

    /// Una barra (`signo`: `|`, `|:`, `:|`, `::`, `||`, `|]`…), con la casilla que empieza tras ella, si empieza
    /// alguna.
    private mutating func barra(_ signo: String, casillas nuevas: Set<Int>? = nil) {
        guard var voz = voces[actual] else { return }
        voz.vigentes = [:]
        voces[actual] = voz
        guard voz.parte == 0 else { return }
        if compases.isEmpty { compases.append(CompasLeido(inicio: .cero)) }
        let aqui = PulsosDeLectura.duracion(voz.posicion)
        // El compás que acaba en esta barra: si el último aún no ha empezado (dos barras seguidas), el anterior.
        let vacio = compases[compases.count - 1].inicio == aqui
        let acabado = vacio && compases.count > 1 ? compases.count - 2 : compases.count - 1
        let cierra = signo.hasPrefix(":")
        let abre = signo.hasSuffix(":")
        if let abiertas = casillas, !vacio { compases[acabado].casillas = abiertas }
        if cierra { compases[acabado].cierraRepeticion = 2 }
        if cierra || signo.contains("||") || signo.contains("]") || signo.contains("[") || nuevas != nil {
            casillas = nil
        }
        if !vacio { compases.append(CompasLeido(inicio: aqui)) }
        if abre { compases[compases.count - 1].abreRepeticion = true }
        if let nuevas {
            casillas = nuevas
            compases[compases.count - 1].casillas = nuevas
        }
    }

    /// Cambia lo que se sabe del compás en curso de la primera voz.
    private mutating func marcar(_ cambio: (inout CompasLeido) -> Void) {
        guard (voces[actual]?.parte ?? 0) == 0 else { return }
        if compases.isEmpty { compases.append(CompasLeido(inicio: .cero)) }
        cambio(&compases[compases.count - 1])
    }

    /// Una nota de adorno (`{g}`), que no dura.
    private mutating func adorno(_ altura: Altura, desvio: Double) {
        guard let voz = voces[actual], voz.posicion <= PulsosDeLectura.limite else { return }
        adornos.append(
            NotaDeLaPieza(
                altura: altura, inicio: PulsosDeLectura.duracion(voz.posicion), duracion: .cero, parte: voz.parte,
                desvio: desvio))
    }
}
