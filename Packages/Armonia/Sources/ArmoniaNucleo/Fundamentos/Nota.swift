// MARK: - NotaNatural

/// Las siete notas naturales (sin alteración), en orden diatónico: do, re, mi, fa, sol, la, si.
public enum NotaNatural: Int, CaseIterable, Hashable, Sendable, CustomStringConvertible {
    case `do` = 0
    case re, mi, fa, sol, la, si

    /// Posición diatónica dentro de la octava (Do = 0 … Si = 6).
    public var indiceDiatonico: Int { rawValue }

    /// Posición de la nota natural en la línea de quintas (Fa = −1, Do = 0 … Si = 5).
    public var pasosDeQuintaBase: Int { [0, 2, 4, -1, 1, 3, 5][rawValue] }

    public var description: String { nombre }

    /// NotaNatural correspondiente a una posición cualquiera de la línea de quintas.
    package init(pasosDeQuinta: Int) {
        let orden: [NotaNatural] = [.fa, .do, .sol, .re, .la, .mi, .si]
        self = orden[modulo(pasosDeQuinta + 1, 7)]
    }
}

extension NotaNatural: Nombrable {}

// MARK: - Alteración

/// Alteración de una nota: cuántos semitonos la suben (sostenidos) o la bajan (bemoles)
/// respecto a la nota natural. En la línea de quintas, cada sostenido son 7 quintas.
///
///     let a: Alteracion = .sostenido
///     a.simbolo                               // "♯"
///     Alteracion(-2).nombre                   // "doble bemol"
///     Alteracion(3).nombre(en: .inglesASCII)  // "triple sharp"
///     Alteracion("bb")                        // doble bemol
///     Nota(.fa, .sostenido)      // Fa♯ (también Nota(.fa, 1))
public struct Alteracion: Hashable, Sendable, Comparable, ExpressibleByIntegerLiteral {
    /// Semitonos: +1 = ♯, +2 = 𝄪, −1 = ♭, −2 = 𝄫, 0 = natural.
    public let semitonos: Int

    public init(_ semitonos: Int) { self.semitonos = semitonos }
    public init(integerLiteral semitonos: Int) { self.init(semitonos) }

    /// Lee "#", "♯", "x", "𝄪", "b", "♭", "𝄫", "♮", "n" o "" (natural) y sus combinaciones
    /// ("##", "bb", "#x"), y también los nombres: "sostenido", "doble bemol", "sharp"…
    public init(leyendo texto: String) throws {
        let limpio = texto.trimmingEspacios()
        if let porNombre = Alteracion.porNombre[limpio.claveDeBusqueda] {
            self = porNombre
            return
        }
        var total = 0
        for (i, c) in limpio.enumerated() {
            switch c {
            case "#", "♯": total += 1
            case "x", "𝄪": total += 2
            case "b", "♭": total -= 1
            case "𝄫": total -= 2
            case "♮": break
            case "n" where limpio.count == 1: break
            default:
                throw ErrorDeLectura(texto: texto, posicion: i, motivo: .alteracionNoReconocida(String(c)))
            }
        }
        self.init(total)
    }

    // MARK: Constantes

    public static let natural: Alteracion = 0
    public static let sostenido: Alteracion = 1
    public static let bemol: Alteracion = -1
    public static let dobleSostenido: Alteracion = 2
    public static let dobleBemol: Alteracion = -2

    // MARK: Propiedades

    /// Número de signos, sin importar el sentido: 𝄫 → 2.
    public var numeroDeSignos: Int { abs(semitonos) }
    /// Desplazamiento en la línea de quintas: ♯ → 7, ♭ → −7.
    public var pasosDeQuinta: Int { 7 * semitonos }

    public var esNatural: Bool { semitonos == 0 }
    public var esSostenido: Bool { semitonos > 0 }
    public var esBemol: Bool { semitonos < 0 }

    /// Los signos de la alteración en una tipografía: `Alteracion(2).simbolo(en: .compacta)` → "𝄪".
    public func simbolo(en tipografia: Tipografia) -> String {
        switch tipografia {
        case .unicode: return signos(sostenido: "♯", bemol: "♭")
        case .ascii: return signos(sostenido: "#", bemol: "b")
        case .compacta:
            if semitonos == 0 { return "♮" }
            let (pares, suelto) = (numeroDeSignos / 2, numeroDeSignos % 2)
            return esSostenido
                ? String(repeating: "𝄪", count: pares) + (suelto == 1 ? "♯" : "")
                : String(repeating: "𝄫", count: pares) + (suelto == 1 ? "♭" : "")
        }
    }

    /// Signos tipográficos que se escriben tras el nombre de la nota: "♯♯", "♭"; "" si es natural.
    public var simbolo: String { simbolo(en: .unicode) }
    /// Signos en ASCII: "##", "b"; "" si es natural.
    public var simboloASCII: String { simbolo(en: .ascii) }
    /// Signos compactos, con 𝄪 y 𝄫 para cada pareja: 𝄪♯ (triple sostenido), 𝄫 (doble bemol); ♮ si es natural.
    public var simboloCompacto: String { simbolo(en: .compacta) }

    package func signos(sostenido: String, bemol: String) -> String {
        String(repeating: esSostenido ? sostenido : bemol, count: numeroDeSignos)
    }

    package static let porNombre: [String: Alteracion] = {
        var tabla: [String: Alteracion] = ["": 0, "becuadro": 0, "natural": 0]
        for n in -4...4 where n != 0 {
            let a = Alteracion(n)
            for notacion in [
                Notacion.espanolUnicode, .inglesASCII, .aleman, .frances, .italiano, .catalan, .gallego,
                .euskera, .portugues, .occitano, .ruso, .griego, .aragones, .asturiano,
            ] {
                tabla[a.nombre(en: notacion).claveDeBusqueda] = a
            }
        }
        return tabla
    }()

    // MARK: Operaciones

    public static func < (a: Alteracion, b: Alteracion) -> Bool { a.semitonos < b.semitonos }
    public static func + (a: Alteracion, b: Alteracion) -> Alteracion { Alteracion(a.semitonos + b.semitonos) }
    public static func - (a: Alteracion, b: Alteracion) -> Alteracion { Alteracion(a.semitonos - b.semitonos) }
    public static prefix func - (a: Alteracion) -> Alteracion { Alteracion(-a.semitonos) }
}

/// Los estilos de escribir los signos de una alteración.
///
///     Alteracion(-2).simbolo(en: .unicode)    // "♭♭"
///     Alteracion(-2).simbolo(en: .ascii)      // "bb"
///     Alteracion(-2).simbolo(en: .compacta)   // "𝄫"
///
/// Un natural no lleva signo en `unicode` ni en `ascii` (la nota se escribe sola) y se escribe "♮" en
/// `compacta`. Las tres se leen igual con `Alteracion(leyendo:)`.
public enum Tipografia: String, Hashable, Sendable, CaseIterable {
    /// Un signo por semitono, ♯ y ♭: Fa♯, Si♭♭.
    case unicode
    /// Un signo por semitono, # y b, como se escribe en un teclado: F#, Bbb.
    case ascii
    /// 𝄪 y 𝄫 para cada pareja de signos, y ♮ para el natural: Fa𝄪, Si𝄫, Do𝄪♯.
    case compacta
}

extension Alteracion: CustomStringConvertible {
    public var description: String { nombre }
}

extension Alteracion: RepresentableComoTexto, Nombrable {
    /// Signos tras la nota ("♯", "bb"); el natural se escribe "♮" ("n" en ASCII).
    public func texto(en notacion: Notacion) -> String {
        if semitonos == 0 { return notacion.usaASCII ? "n" : "♮" }
        return simbolo(en: notacion.tipografia)
    }
}

// MARK: - Nota

/// Nota sin octava (con su ortografía): Do, Fa♯, Si♭♭… La nota con octava es `Altura`.
///
/// Se codifica como una única coordenada: la posición en la **línea de quintas**.
///
///     … Si♭♭  Fa♭  Do♭  Sol♭  Re♭  La♭  Mi♭  Si♭  Fa  Do  Sol  Re  La  Mi  Si  Fa♯  Do♯ …
///        −9   −8   −7    −6   −5   −4   −3   −2  −1   0    1   2   3   4   5    6    7
///
/// Subir una quinta suma 1; un sostenido suma 7; un bemol resta 7.
/// Así Fa♯ (6) y Sol♭ (−6) son nombres distintos aunque suenen igual.
public struct Nota: Hashable, Sendable {
    /// Pasos de quinta desde Do: la posición en la línea de quintas (Do = 0, Sol = 1, Fa = −1).
    public let pasosDeQuinta: Int

    public init(pasosDeQuinta: Int) {
        self.pasosDeQuinta = pasosDeQuinta
    }

    /// Construye a partir de letra y alteración: `Nota(.fa, .sostenido)` o `Nota(.fa, 1)`.
    public init(_ letra: NotaNatural, _ alteracion: Alteracion = .natural) {
        self.pasosDeQuinta = letra.pasosDeQuintaBase + alteracion.pasosDeQuinta
    }

    /// Lee textos como "Do", "fa#", "Sib", "Mi♭♭", "Rex", "Sol𝄪" o "C#", "Bb", con palabras
    /// ("Fa sostenido", "B flat") y también los nombres en catalán, gallego, asturiano, aragonés, euskera,
    /// portugués, occitano, griego y ruso ("re bemoll", "fa sostido", "si bemol bikoitza", "fá sustenido", "sòl dièsi", "фа-диез", "σι ύφεση",
    /// "fa sosteniu", "fa sosteníu"),
    /// que no se confunden con los anteriores. Si no se puede leer, el error indica dónde y por qué.
    public init(leyendo texto: String) throws {
        var lector = Lector(texto)
        try lector.exigirContenido()
        let enOtraLengua = Nota.leerEnLenguasPeninsulares(texto)
        guard let nombre = lector.leerNombreNota() else {
            if let enOtraLengua {
                self = enOtraLengua
                return
            }
            throw lector.error(.notaNoReconocida)
        }
        lector.saltarEspacios()
        guard lector.haTerminado else {
            if let enOtraLengua {
                self = enOtraLengua
                return
            }
            throw lector.error(.caracteresSobrantes(lector.restoSinEspacios))
        }
        self = nombre
    }

    /// Nombre en catalán, gallego, asturiano, aragonés, euskera, portugués, occitano, griego o ruso, si lo es.
    package static func leerEnLenguasPeninsulares(_ texto: String) -> Nota? {
        let clave = texto.claveDeBusqueda
        for notacion in Notacion.deLecturaGenerica + Notacion.conPalabras {
            if let nombre = porNombre[notacion]?[clave] { return nombre }
        }
        return nil
    }

    // MARK: Propiedades

    public var natural: NotaNatural { NotaNatural(pasosDeQuinta: pasosDeQuinta) }

    /// Alteración: Fa♯ → sostenido, Si♭♭ → doble bemol, Do → natural.
    public var alteracion: Alteracion { Alteracion(divisionEntera(pasosDeQuinta + 1, 7)) }

    /// Clase de altura 0…11 (Do = 0, Do♯/Re♭ = 1 … Si = 11).
    public var claseDeAltura: Int { modulo(pasosDeQuinta * 7, 12) }

    /// Las tres escrituras razonables de una clase de altura en la línea de quintas, de la más
    /// bemol a la más sostenida: para la clase 1, Re♭, Do♯ y Si𝄪.
    package static func pasosDeQuintaPosibles(deClase clase: Int) -> [Int] {
        let base = modulo(clase * 7, 12) // 7 es su propio inverso módulo 12
        return [base - 12, base, base + 12]
    }

    /// Lee un nombre escrito en una notación concreta: `Nota(leyendo: "Fis", en: .aleman)`,
    /// `Nota(leyendo: "B", en: .aleman)` → Si♭, `Nota(leyendo: "ré bémol", en: .frances)`.
    /// No distingue mayúsculas ni tildes. En español e inglés, igual que `init(leyendo:)`.
    public init(leyendo texto: String, en notacion: Notacion) throws {
        let notacion = notacion.notas
        switch notacion.escritura.escrituraDeLaAlteracion {
        case .signos:
            try self.init(leyendo: texto)
        case .palabras, .alemana:
            if let nombre = Nota.porNombre[notacion]?[texto.claveDeBusqueda] {
                self = nombre
            } else if Notacion.conPalabras.contains(notacion) {
                // En español e inglés se leen las tres formas: «Fa sostenido», «Fa#» y «Fa♯».
                try self.init(leyendo: texto)
            } else {
                throw ErrorDeLectura(texto: texto, posicion: 0, motivo: .notaNoReconocida)
            }
        }
    }

    /// Nombres de cada notación (hasta cuatro alteraciones) → nombre de nota.
    package static let porNombre: [Notacion: [String: Nota]] = {
        var tablas: [Notacion: [String: Nota]] = [:]
        for notacion in [Notacion.aleman, .frances, .italiano] + Notacion.deLecturaGenerica + Notacion.conPalabras {
            var tabla: [String: Nota] = [:]
            for quintas in -29...33 {
                let nombre = Nota(pasosDeQuinta: quintas)
                tabla[nombre.nombre(en: notacion).claveDeBusqueda] = nombre
                tabla[nombre.nombreCompacto(en: notacion).claveDeBusqueda] = nombre
            }
            tablas[notacion] = tabla
        }
        return tablas
    }()

    // MARK: Operaciones

    /// ¿Suenan igual en temperamento igual? (Fa♯ y Sol♭ → `true`).
    public func esEnarmonica(de otra: Nota) -> Bool {
        claseDeAltura == otra.claseDeAltura
    }

    /// Enarmónico con menos alteraciones (entre Re♭ y Fa♯ en la línea de quintas).
    /// Mi♯ → Fa, Do♭ → Si, Sol𝄪 → La.
    public var enarmonicaMasSimple: Nota {
        Nota(pasosDeQuinta: modulo(pasosDeQuinta + 5, 12) - 5)
    }

    public var sostenido: Nota { Nota(pasosDeQuinta: pasosDeQuinta + 7) }
    public var bemol: Nota { Nota(pasosDeQuinta: pasosDeQuinta - 7) }

    public func transponer(_ intervalo: Intervalo) -> Nota {
        Nota(pasosDeQuinta: pasosDeQuinta + intervalo.pasosDeQuintaConSigno)
    }

    /// Intervalo simple ascendente desde esta nota hasta `otra` (Do → Mi = 3ª mayor).
    public func intervalo(hasta otra: Nota) -> Intervalo {
        Intervalo.simpleAscendente(pasosDeQuinta: otra.pasosDeQuinta - pasosDeQuinta)
    }

    /// El intervalo más corto hasta `otra`, subiendo o bajando: el que se usa para transportar sin que la música
    /// se aleje (Do → Re sube una 2ª mayor; Do → La baja una 3ª menor). El tritono sube.
    public func intervaloMasCorto(hasta otra: Nota) -> Intervalo {
        let subiendo = intervalo(hasta: otra)
        return subiendo.semitonos > 6 ? -subiendo.inversion : subiendo
    }

    // MARK: Constantes

    public static let `do` = Nota(.do)
    public static let re = Nota(.re)
    public static let mi = Nota(.mi)
    public static let fa = Nota(.fa)
    public static let sol = Nota(.sol)
    public static let la = Nota(.la)
    public static let si = Nota(.si)
}

extension Nota: CustomStringConvertible {
    public var description: String { nombre }
}

extension Nota: RepresentableComoTexto, Nombrable, Transponible {
    public func texto(en notacion: Notacion) -> String { nombre(en: notacion) }
}

extension Notacion {
    /// Notaciones que también leen `Nota(leyendo:)` y `Altura(leyendo:)` sin indicar el idioma,
    /// porque sus nombres no se confunden con los españoles ni con los ingleses.
    package static let deLecturaGenerica: [Notacion] = [
        .catalan, .gallego, .euskera, .portugues,
        .occitano, .ruso, .griego, .aragones, .asturiano,
    ]

    /// El español y el inglés con las alteraciones en palabras («Fa sostenido», «B flat»), que también se leen
    /// sin indicar la notación. Van aparte de `deLecturaGenerica` porque se prueban los últimos: «B» sola
    /// es Si en inglés, pero en «B dorisch» manda el alemán.
    package static let conPalabras: [Notacion] = [.espanol, .ingles]
}

// MARK: - Idiomas
//
// Las letras, las alteraciones y los nombres de nota en las catorce lenguas de `Notacion`. Siguen el idioma
// de las notas (`Notacion.idiomaDeLasNotas`), no el de los textos. Los intervalos, en `Intervalo.swift`.

// MARK: - NotaNatural

extension NotaNatural {
    public var nombre: String { ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"][rawValue] }

    /// Nombre en cada idioma: Do (español), C (inglés), H para el Si en alemán, ré (francés),
    /// re (italiano), sòl (occitano), соль (ruso), σολ (griego). En las lenguas que usan sílabas,
    /// salvo el español, en minúscula, como se escriben en el texto. Las sílabas de cada idioma están
    /// en ``ReglasDeIdioma``.
    public func nombre(en notacion: Notacion) -> String {
        notacion.idiomaDeLasNotas.reglas.naturales[rawValue]
    }
}

// MARK: - Alteracion

extension Alteracion {
    /// Nombre en cada idioma: "double sharp", "Doppelkreuz", "double dièse", "doppio diesis"…
    public func nombre(en notacion: Notacion) -> String {
        let idioma = notacion.idiomaDeLasNotas
        if semitonos == 0 { return Alteracion.palabraNatural.texto(en: idioma) }
        let base = (esSostenido ? Alteracion.palabraSostenido : Alteracion.palabraBemol).texto(en: idioma)
        let n = numeroDeSignos
        if n == 1 { return base }
        let multiplicadores = Alteracion.multiplicadores.texto(en: idioma)
        switch idioma.reglas.multiplicador {
        case .unido:
            // En alemán las palabras se unen: Doppelkreuz, Doppel-Be.
            let unida = esSostenido ? "kreuz" : "-Be"
            if n <= 4 { return multiplicadores[n - 2] + unida }
            return "\(n)" + (esSostenido ? " Kreuze" : " Be")
        case .detras:
            // En euskera el adjetivo va detrás, y el sustantivo no cambia con el número: diesa bikoitza, 5 diesa.
            if n <= 4 { return base + " " + multiplicadores[n - 2] }
            return "\(n) \(base)"
        case .delante:
            if n <= 4 { return multiplicadores[n - 2] + base }
            return "\(n) " + (esSostenido ? Alteracion.palabraSostenidos : Alteracion.palabraBemoles).texto(en: idioma)
        }
    }

    private static let palabraNatural = TextosDeNucleo.traduccion(\.palabraNatural)
    private static let palabraSostenido = TextosDeNucleo.traduccion(\.palabraSostenido)
    private static let palabraBemol = TextosDeNucleo.traduccion(\.palabraBemol)
    /// «Doble», «triple» y «cuádruple», para 2, 3 y 4 signos. Dónde se ponen y cómo se pegan a la palabra
    /// lo dice `ReglasDeIdioma.multiplicador`: delante y separados, detrás (euskera) o unidos (alemán).
    private static let multiplicadores = TextosDeNucleo.traduccion(\.multiplicadores)
    /// Para 5 signos o más: "5 sostenidos".
    private static let palabraSostenidos = TextosDeNucleo.traduccion(\.palabraSostenidos)
    private static let palabraBemoles = TextosDeNucleo.traduccion(\.palabraBemoles)
}

// MARK: - Nota

extension Nota {
    /// Nombre con símbolos tipográficos: "Fa♯", "Si♭".
    public var nombre: String { natural.nombre + alteracion.simbolo }

    /// Nombre en ASCII: "Fa#", "Sib".
    public var nombreASCII: String { natural.nombre + alteracion.simboloASCII }

    /// Nombre en la notación indicada: `.espanol` → "Fa sostenido", `.espanolASCII` → "Fa#",
    /// `.espanolUnicode` → "Fa♯", `.ingles` → "F sharp", `.inglesASCII` → "F#", `.inglesUnicode` → "F♯",
    /// `.aleman` → "Fis", `.frances` → "fa dièse",
    /// `.italiano` → "fa diesis", `.ruso` → "фа-диез", `.griego` → "φα δίεση".
    public func nombre(en notacion: Notacion) -> String {
        let base = natural.nombre(en: notacion)
        switch notacion.escritura.escrituraDeLaAlteracion {
        case .alemana:
            return nombreAleman
        case .signos:
            return base + (notacion.usaASCII ? alteracion.simboloASCII : alteracion.simbolo)
        case .palabras:
            // El separador lo pone el idioma: un espacio en casi todos, un guion en ruso (фа-диез).
            guard !alteracion.esNatural else { return base }
            return base + notacion.idiomaDeLasNotas.reglas.separador + alteracion.nombre(en: notacion)
        }
    }

    /// Nombre alemán: sostenidos con -is (Fis, Cisis), bemoles con -es (Des, Ges), con Es y As
    /// para Mi♭ y La♭ (Eses, Asas), B para Si♭ y H para Si (His, Heses).
    package var nombreAleman: String {
        let n = alteracion.numeroDeSignos
        if alteracion.esNatural { return natural.nombre(en: .aleman) }
        if alteracion.esSostenido { return natural.nombre(en: .aleman) + String(repeating: "is", count: n) }
        switch natural {
        case .si: return n == 1 ? "B" : "H" + String(repeating: "es", count: n)
        case .mi: return "Es" + String(repeating: "es", count: n - 1)
        case .la: return "As" + String(repeating: "as", count: n - 1)
        default: return natural.nombre(en: .aleman) + String(repeating: "es", count: n)
        }
    }

    /// Nombre compacto para cifrados: igual que `nombre(en:)` salvo en las notaciones que escriben
    /// las alteraciones con palabras, que usan la sílaba con mayúscula y el símbolo (Fa♯, F♯, Ré♭, Фа♯, Φα♯).
    public func nombreCompacto(en notacion: Notacion) -> String {
        let notacion = notacion.notas
        switch notacion.escritura.escrituraDeLaAlteracion {
        case .palabras:
            return natural.nombre(en: notacion).conMayusculaInicial + alteracion.simbolo
        case .signos, .alemana:
            return nombre(en: notacion)
        }
    }
}
