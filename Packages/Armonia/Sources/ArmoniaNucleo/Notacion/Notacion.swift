// MARK: - Notación

/// Cómo se escribe todo lo que el motor convierte en texto: el idioma (nombres de nota,
/// de intervalos, de acordes, de escalas…) y, en español e inglés, si las alteraciones se escriben con
/// palabras, con #/b o con ♯/♭.
///
/// | Notación | Nota | Intervalo | Acorde | Escala |
/// |---|---|---|---|---|
/// | `.espanol` | Fa sostenido | 3ª mayor | séptima de dominante | Re dórico |
/// | `.espanolASCII` | Fa# | 3ª mayor | séptima de dominante | Re dórico |
/// | `.espanolUnicode` | Fa♯ | 3ª mayor | séptima de dominante | Re dórico |
/// | `.ingles` | F sharp | major third | dominant seventh | D dorian |
/// | `.inglesASCII` | F# | major third | dominant seventh | D dorian |
/// | `.inglesUnicode` | F♯ | major third | dominant seventh | D dorian |
/// | `.catalan` | fa sostingut | 3a major | sèptima de dominant | fa sostingut dòric |
/// | `.gallego` | fa sostido | 3ª maior | sétima de dominante | fa sostido dórico |
/// | `.asturiano` | fa sosteníu | 3ª mayor | séptima de dominante | fa sosteníu dóricu |
/// | `.aragones` | fa sosteniu | 3ª mayor | séptima de dominant | fa sosteniu dórico |
/// | `.euskera` | fa diesa | 3. handia | dominanteko zazpigarrena | fa diesa doriarra |
/// | `.portugues` | fá sustenido | 3ª maior | sétima de dominante | fá sustenido dórico |
/// | `.frances` | fa dièse | tierce majeure | septième de dominante | fa dièse dorien |
/// | `.occitano` | fa dièsi | tèrça majora | setena de dominanta | fa dièsi dorian |
/// | `.italiano` | fa diesis | terza maggiore | settima di dominante | fa diesis dorico |
/// | `.aleman` | Fis | große Terz | Dominantseptakkord | Fis dorisch |
/// | `.griego` | φα δίεση | μεγάλη τρίτη | συγχορδία έβδομης δεσπόζουσας | φα δίεση δώριος |
/// | `.ruso` | фа-диез | большая терция | доминантсептаккорд | фа-диез дорийский |
///
/// En los catorce idiomas están traducidos los nombres de nota y de alteración, los modos de las
/// tonalidades (Fis-Dur, fa dièse majeur, фа-диез мажор), los textos del motor (mensajes de error,
/// intervalos, cadencias…) y los nombres de los catálogos (acordes, escalas, instrumentos).
///
/// Una notación son dos elecciones: cómo se escriben las notas (`escritura`) y en qué idioma salen los
/// textos (`textos`). Las notaciones con nombre (`.espanolUnicode`, `.ruso`…) llevan los textos en el idioma de sus
/// notas, y `conTextos(en:)` los cambia: `Notacion.ruso.conTextos(en: .espanol)` escribe
/// «соль séptima de dominante, primera inversión».
///
/// La octava de las alturas se escribe con cifras (La4) o, con `conOctavas(.subindices)`, como subíndice (La₄).
public struct Notacion: Hashable, Sendable, CaseIterable {
    /// Cómo se escriben los nombres de nota.
    public let escritura: EscrituraDeNotas
    /// El idioma de los textos (intervalos, acordes, mensajes…).
    public let textos: Idioma
    /// Cómo se escribe la octava de las alturas: con cifras (La4, por defecto) o como subíndice (La₄).
    public let octavas: EscrituraDeLaOctava

    /// Las notas escritas como `escritura`, con los textos en `textos` o, si no se da, en el idioma de las
    /// notas, y la octava escrita como `octavas`.
    public init(escritura: EscrituraDeNotas, textos: Idioma? = nil, octavas: EscrituraDeLaOctava = .cifras) {
        self.escritura = escritura
        self.textos = textos ?? escritura.idioma
        self.octavas = octavas
    }

    /// Español con las alteraciones en palabras: Do, Fa sostenido, Si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let espanol = Notacion(escritura: .espanol)
    /// Español con caracteres ASCII: Do, Fa#, Sib.
    public static let espanolASCII = Notacion(escritura: .espanolASCII)
    /// Español con símbolos tipográficos: Do, Fa♯, Si♭.
    public static let espanolUnicode = Notacion(escritura: .espanolUnicode)
    /// Inglés con las alteraciones en palabras: C, F sharp, B flat; en los cifrados, F♯7, B♭m.
    public static let ingles = Notacion(escritura: .ingles)
    /// Inglés con caracteres ASCII: C, F#, Bb (la forma habitual de escribir en inglés).
    public static let inglesASCII = Notacion(escritura: .inglesASCII)
    /// Inglés con símbolos tipográficos: C, F♯, B♭.
    public static let inglesUnicode = Notacion(escritura: .inglesUnicode)
    /// Catalán: do, re, fa sostingut, si bemoll; en los cifrados, Fa♯7, Si♭m.
    public static let catalan = Notacion(escritura: .catalan)
    /// Gallego: do, re, fa sostido, si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let gallego = Notacion(escritura: .gallego)
    /// Asturiano: do, re, fa sosteníu, si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let asturiano = Notacion(escritura: .asturiano)
    /// Aragonés: do, re, fa sosteniu, si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let aragones = Notacion(escritura: .aragones)
    /// Euskera: do, re, fa diesa, si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let euskera = Notacion(escritura: .euskera)
    /// Portugués: dó, ré, fá sustenido, si bemol; en los cifrados, Fá♯7, Si♭m.
    public static let portugues = Notacion(escritura: .portugues)
    /// Francés: do, ré, fa dièse, si bémol; en los cifrados, Fa♯7, Si♭m.
    public static let frances = Notacion(escritura: .frances)
    /// Occitano: do, re, fa dièsi, si bemòl; en los cifrados, Fa♯7, Si♭m.
    public static let occitano = Notacion(escritura: .occitano)
    /// Italiano: do, re, fa diesis, si bemolle; en los cifrados, Fa♯7, Si♭m.
    public static let italiano = Notacion(escritura: .italiano)
    /// Alemán: C, Fis, Es, B (= Si♭), H (= Si), Heses; los cifrados quedan Fis7, B7, Hm7.
    public static let aleman = Notacion(escritura: .aleman)
    /// Griego: ντο, ρε, φα δίεση, σι ύφεση; en los cifrados, Φα♯7, Σι♭m.
    public static let griego = Notacion(escritura: .griego)
    /// Ruso: до, ре, фа-диез, си-бемоль; en los cifrados, Фа♯7, Си♭m.
    public static let ruso = Notacion(escritura: .ruso)

    /// Las notaciones con nombre, una por escritura, con los textos en el idioma de sus notas. No incluye
    /// las combinadas (`conTextos(en:)`), que también son notaciones válidas.
    public static let allCases: [Notacion] = EscrituraDeNotas.allCases.map { Notacion(escritura: $0) }

    /// La notación habitual de un idioma: con ♯ y ♭ en español (`.espanolUnicode`) y con # y b en inglés
    /// (`.inglesASCII`), que es como se suelen escribir; en los demás, la única que hay.
    /// `Notacion.delIdioma(.catalan)` es `.catalan`.
    public static func delIdioma(_ idioma: Idioma) -> Notacion {
        Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: idioma == .ingles))
    }

    /// La misma notación de las notas con los textos en otro idioma: `Notacion.ruso.conTextos(en:
    /// .espanol)`.
    public func conTextos(en idioma: Idioma) -> Notacion {
        Notacion(escritura: escritura, textos: idioma, octavas: octavas)
    }

    /// La misma notación con la octava escrita de otra forma: `Notacion.espanolUnicode.conOctavas(.subindices)`
    /// escribe La₄ y Fa♯₃.
    public func conOctavas(_ octavas: EscrituraDeLaOctava) -> Notacion {
        Notacion(escritura: escritura, textos: textos, octavas: octavas)
    }

    /// La notación de las notas con los textos en su propio idioma y la octava en cifras:
    /// `.ruso.conTextos(en: .espanol).notas` es `.ruso`.
    public var notas: Notacion { Notacion(escritura: escritura) }

    /// ¿Lleva los textos en un idioma distinto del de sus notas?
    public var esCombinada: Bool { textos != escritura.idioma }

    /// El idioma de los nombres de nota.
    public var idiomaDeLasNotas: Idioma { escritura.idioma }

    /// Idioma de las abreviaturas de los intervalos (5J, P5), que solo están en español e inglés:
    /// español en español, catalán, gallego, asturiano, aragonés, euskera, portugués y occitano; inglés en
    /// las demás (``ReglasDeIdioma/abreviaturas``). Los demás textos siguen `textos`.
    public var idiomaDeLasAbreviaturas: Idioma {
        // Con los textos en otro idioma manda ese; si no, el de las notas.
        (esCombinada ? textos : idiomaDeLasNotas).reglas.abreviaturas
    }

    /// Cómo se escriben los signos de las alteraciones. En las notaciones que escriben las alteraciones
    /// de las notas con palabras o sufijos (Fis, fa dièse), solo afecta a los signos de los cifrados.
    public var tipografia: Tipografia { escritura.tipografia }

    /// Alteraciones como # y b en lugar de ♯ y ♭: `tipografia == .ascii`.
    public var usaASCII: Bool { escritura.usaASCII }
}

// MARK: - Escritura de la octava

/// Cómo se escribe la octava de una altura (científica: Do4 es el Do central) en una `Notacion`.
public enum EscrituraDeLaOctava: Hashable, Sendable, CaseIterable {
    /// Con cifras: La4, Fa♯3, Si♭-1.
    case cifras
    /// Como subíndice: La₄, Fa♯₃, Si♭₋₁.
    case subindices

    /// La octava escrita así: `EscrituraDeLaOctava.subindices.escribir(-1)` es «₋₁».
    public func escribir(_ octava: Int) -> String {
        switch self {
        case .cifras: return String(octava)
        case .subindices: return String(String(octava).map { Self.tablaDeSubindices[$0] ?? $0 })
        }
    }

    private static let tablaDeSubindices: [Character: Character] = [
        "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄", "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉", "-": "₋",
    ]

    /// El texto con los subíndices (₀…₉ y ₋) cambiados por cifras y por «-»: «La₄» → «La4». Así se leen
    /// las alturas escritas de las dos formas.
    package static func conCifras(_ texto: some StringProtocol) -> String {
        String(texto.map { tablaDeCifras[$0] ?? $0 })
    }

    private static let tablaDeCifras: [Character: Character] = Dictionary(
        uniqueKeysWithValues: tablaDeSubindices.map { ($0.value, $0.key) })
}

// MARK: - Escritura de las notas

/// Cómo se escriben los nombres de nota en una `Notacion`: el idioma y, en español e inglés, si las
/// alteraciones van en palabras, con #/b o con ♯/♭.
///
/// No es una lista de casos, sino el idioma y su variante: las dieciocho escrituras con nombre
/// (`.espanolUnicode`, `.ruso`…) salen de los catorce idiomas, con tres formas en español y en inglés y una
/// en los demás. Añadir un idioma es añadir su caso a ``Idioma`` y su fila a ``ReglasDeIdioma``; aquí no
/// hay nada que tocar. `allCases` las recorre en el orden de `Idioma`.
public struct EscrituraDeNotas: Hashable, Sendable, CaseIterable {
    /// El idioma de los nombres de nota.
    public let idioma: Idioma
    /// Las alteraciones en palabras: «Fa sostenido», «F sharp». En los idiomas que solo las escriben así
    /// (catalán, ruso…) es `false`, porque no hay otra forma con la que compararla.
    public let conPalabras: Bool
    /// Cómo se escriben los signos de las alteraciones: con # y b (`.ascii`) en español e inglés ASCII y en
    /// alemán; con ♯ y ♭ (`.unicode`) en las demás, también en los cifrados de las que usan palabras.
    public let tipografia: Tipografia

    private init(_ idioma: Idioma, conPalabras: Bool = false, tipografia: Tipografia? = nil) {
        self.idioma = idioma
        self.conPalabras = conPalabras
        self.tipografia = tipografia ?? idioma.reglas.tipografia
    }

    /// Do, Fa sostenido, Si bemol.
    public static let espanol = EscrituraDeNotas(.espanol, conPalabras: true, tipografia: .unicode)
    /// Do, Fa#, Sib.
    public static let espanolASCII = EscrituraDeNotas(.espanol, tipografia: .ascii)
    /// Do, Fa♯, Si♭.
    public static let espanolUnicode = EscrituraDeNotas(.espanol, tipografia: .unicode)
    /// C, F sharp, B flat.
    public static let ingles = EscrituraDeNotas(.ingles, conPalabras: true, tipografia: .unicode)
    /// C, F#, Bb.
    public static let inglesASCII = EscrituraDeNotas(.ingles, tipografia: .ascii)
    /// C, F♯, B♭.
    public static let inglesUnicode = EscrituraDeNotas(.ingles, tipografia: .unicode)
    /// do, re, fa sostingut, si bemoll.
    public static let catalan = EscrituraDeNotas(.catalan)
    /// do, re, fa sostido, si bemol.
    public static let gallego = EscrituraDeNotas(.gallego)
    /// do, re, fa sosteníu, si bemol.
    public static let asturiano = EscrituraDeNotas(.asturiano)
    /// do, re, fa sosteniu, si bemol.
    public static let aragones = EscrituraDeNotas(.aragones)
    /// do, re, fa diesa, si bemol.
    public static let euskera = EscrituraDeNotas(.euskera)
    /// dó, ré, fá sustenido, si bemol.
    public static let portugues = EscrituraDeNotas(.portugues)
    /// do, ré, fa dièse, si bémol.
    public static let frances = EscrituraDeNotas(.frances)
    /// do, re, fa dièsi, si bemòl.
    public static let occitano = EscrituraDeNotas(.occitano)
    /// do, re, fa diesis, si bemolle.
    public static let italiano = EscrituraDeNotas(.italiano)
    /// C, Fis, Es, B, H.
    public static let aleman = EscrituraDeNotas(.aleman)
    /// ντο, ρε, φα δίεση, σι ύφεση.
    public static let griego = EscrituraDeNotas(.griego)
    /// до, ре, фа-диез, си-бемоль.
    public static let ruso = EscrituraDeNotas(.ruso)

    /// Las escrituras de los catorce idiomas: tres en los que tienen variantes (palabras, ASCII y Unicode)
    /// y una en los demás.
    public static let allCases: [EscrituraDeNotas] = Idioma.allCases.flatMap { idioma in
        idioma.reglas.tieneVariantes
            ? [
                EscrituraDeNotas(idioma, conPalabras: true, tipografia: .unicode),
                EscrituraDeNotas(idioma, tipografia: .ascii),
                EscrituraDeNotas(idioma, tipografia: .unicode),
            ]
            : [EscrituraDeNotas(idioma)]
    }

    /// La escritura de un idioma con signos: # y b si `ascii`, ♯ y ♭ si no. En los idiomas que escriben las
    /// alteraciones con palabras, la única que tienen. Para las palabras en español o inglés, `.espanol` e
    /// `.ingles`.
    public init(idioma: Idioma, ascii: Bool) {
        guard idioma.reglas.tieneVariantes else {
            self = EscrituraDeNotas(idioma)
            return
        }
        self = EscrituraDeNotas(idioma, tipografia: ascii ? .ascii : .unicode)
    }

    /// Alteraciones como # y b en lugar de ♯ y ♭: `tipografia == .ascii`.
    public var usaASCII: Bool { tipografia == .ascii }
}

// MARK: - Idioma

/// Un idioma del motor: el de los nombres de nota de una `EscrituraDeNotas` y el de los textos de una
/// `Notacion`.
///
/// Su `rawValue` es el nombre del caso («euskera», «aleman»), que las apps guardan en los ajustes.
///
/// Para añadir uno:
///
/// 1. Un caso aquí.
/// 2. Su fila en ``ReglasDeIdioma``: su código, cómo se llama, las sílabas, cómo se le pega la alteración, los modos,
///    las abreviaturas de los intervalos y el plural.
/// 3. Su fila en `Scripts/comprobaciones/idiomas.py`.
/// 4. Un campo en `Traducido`, con su argumento en los inicializadores y su caso en `texto(en:)`.
/// 5. Las constantes `EscrituraDeNotas.<idioma>` y `Notacion.<idioma>`. Las escrituras de `allCases` salen solas de
///    las reglas.
/// 6. Un fichero de textos por módulo en cada carpeta `Textos/`, que `comprobar_traducciones` busca.
///
/// Los nombres de nota y los datos del idioma no tienen más `switch` sobre `Idioma` que el de las reglas y el de
/// `Traducido`. Ninguno tiene `default`, así que el compilador señala lo que falta, y cada `TextosDeX` sin el idioma
/// nuevo deja de compilar.
public enum Idioma: String, Hashable, Sendable, CaseIterable {
    case espanol
    case ingles
    case catalan
    case gallego
    case asturiano
    case aragones
    case euskera
    case portugues
    case frances
    case occitano
    case italiano
    case aleman
    case griego
    case ruso
}

extension Idioma {
    /// El código ISO 639 del idioma: «es», «en», «ca», «gl», «ast», «an», «eu», «pt», «fr», «oc», «it», «de»,
    /// «el» y «ru». Está en sus ``ReglasDeIdioma``.
    public var codigo: String { reglas.codigo }

    /// El idioma de un código ISO 639 («ast») o de una etiqueta de idioma con región («ca-ES», «pt_BR»), sin
    /// importar las mayúsculas; `nil` si no es uno de los catorce.
    public init?(codigo: String) {
        let idioma = codigo.lowercased().split(whereSeparator: { $0 == "-" || $0 == "_" }).first.map(String.init)
        guard let encontrado = Idioma.allCases.first(where: { $0.codigo == idioma }) else { return nil }
        self = encontrado
    }

    /// Cómo se escribe el nombre del idioma, en minúsculas: en español, con y sin tildes, y en el propio idioma
    /// («euskera», «euskara»; «alemán», «aleman», «deutsch»). Están en sus ``ReglasDeIdioma``.
    public var nombres: [String] { reglas.nombres }

    /// Cómo se llama el idioma en el propio idioma: «Español», «Euskara», «Deutsch», «Ελληνικά».
    public var nombrePropio: String { reglas.nombrePropio }

    /// El idioma de un código (como `init?(codigo:)`: «eu», «pt-BR») o de uno de sus `nombres` («euskara»,
    /// «Deutsch»), sin importar las mayúsculas ni las tildes («aleman», «FRANCAIS», «ελληνικα»); `nil` si no es uno
    /// de los catorce.
    public init?(nombre: String) {
        if let idioma = Idioma(codigo: nombre) {
            self = idioma
            return
        }
        guard let encontrado = Idioma.porNombre[nombre.claveDeBusqueda] else { return nil }
        self = encontrado
    }

    /// Cada nombre de idioma, sin tildes (`claveDeBusqueda`), con su idioma.
    private static let porNombre: [String: Idioma] = Dictionary(
        Idioma.allCases.flatMap { idioma in idioma.nombres.map { ($0.claveDeBusqueda, idioma) } },
        uniquingKeysWith: { primero, _ in primero })
}
