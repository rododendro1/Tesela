// MARK: - Notación

/// Cómo se escribe todo lo que el motor convierte en texto: el idioma (nombres de nota,
/// de intervalos, de acordes, de escalas…) y si las alteraciones se escriben con palabras o de forma compacta
/// (con #/b o con ♯/♭ en español e inglés; Fis, Es, B y H en alemán; Fa♯, Ré♭, Фа♯ en los demás).
///
/// | Notación | Nota | Intervalo | Acorde | Escala |
/// |---|---|---|---|---|
/// | `.espanolPalabras` | Fa sostenido | 3ª mayor | séptima de dominante | Re dórico |
/// | `.espanolASCII` | Fa# | 3ª mayor | séptima de dominante | Re dórico |
/// | `.espanolCompacto` | Fa♯ | 3ª mayor | séptima de dominante | Re dórico |
/// | `.inglesPalabras` | F sharp | major third | dominant seventh | D dorian |
/// | `.inglesASCII` | F# | major third | dominant seventh | D dorian |
/// | `.inglesCompacto` | F♯ | major third | dominant seventh | D dorian |
/// | `.conPalabras(.catalan)` | fa sostingut | 3a major | sèptima de dominant | fa sostingut dòric |
/// | `.compacta(.catalan)` | Fa♯ | 3a major | sèptima de dominant | Fa♯ dòric |
/// | `.conPalabras(.gallego)` | fa sostido | 3ª maior | sétima de dominante | fa sostido dórico |
/// | `.compacta(.gallego)` | Fa♯ | 3ª maior | sétima de dominante | Fa♯ dórico |
/// | `.conPalabras(.euskera)` | fa diesa | 3. handia | dominanteko zazpigarrena | fa diesa doriarra |
/// | `.compacta(.euskera)` | Fa♯ | 3. handia | dominanteko zazpigarrena | Fa♯ doriarra |
/// | `.conPalabras(.portugues)` | fá sustenido | 3ª maior | sétima de dominante | fá sustenido dórico |
/// | `.compacta(.portugues)` | Fá♯ | 3ª maior | sétima de dominante | Fá♯ dórico |
/// | `.conPalabras(.frances)` | fa dièse | tierce majeure | septième de dominante | fa dièse dorien |
/// | `.compacta(.frances)` | Fa♯ | tierce majeure | septième de dominante | Fa♯ dorien |
/// | `.conPalabras(.italiano)` | fa diesis | terza maggiore | settima di dominante | fa diesis dorico |
/// | `.compacta(.italiano)` | Fa♯ | terza maggiore | settima di dominante | Fa♯ dorico |
/// | `.conPalabras(.aleman)` | F Kreuz | große Terz | Dominantseptakkord | F Kreuz dorisch |
/// | `.compacta(.aleman)` | Fis | große Terz | Dominantseptakkord | Fis dorisch |
/// | `.conPalabras(.griego)` | φα δίεση | μεγάλη τρίτη | συγχορδία έβδομης δεσπόζουσας | φα δίεση δώριος |
/// | `.compacta(.griego)` | Φα♯ | μεγάλη τρίτη | συγχορδία έβδομης δεσπόζουσας | Φα♯ δώριος |
/// | `.conPalabras(.ruso)` | фа-диез | большая терция | доминантсептаккорд | фа-диез дорийский |
/// | `.compacta(.ruso)` | Фа♯ | большая терция | доминантсептаккорд | Фа♯ дорийский |
/// | `.conPalabras(.hungaro)` | F kereszt | nagy terc | domináns szeptimakkord | F kereszt dór |
/// | `.compacta(.hungaro)` | Fisz | nagy terc | domináns szeptimakkord | Fisz dór |
/// | `.conPalabras(.sueco)` | F kors | stor ters | dominantseptimackord | F kors dorisk |
/// | `.compacta(.sueco)` | Fiss | stor ters | dominantseptimackord | Fiss dorisk |
///
/// En los trece idiomas están traducidos los nombres de nota y de alteración, los modos de las
/// tonalidades (Fis-Dur, fa dièse majeur, фа-диез мажор), los textos del motor (mensajes de error,
/// intervalos, cadencias…) y los nombres de los catálogos (acordes, escalas, instrumentos).
///
/// Una notación son dos elecciones: cómo se escriben las notas (`escritura`) y en qué idioma salen los
/// textos (`textos`). Las notaciones con nombre (`.espanolCompacto`, `.conPalabras(.ruso)`…) llevan los textos en el idioma de sus
/// notas, y `conTextos(en:)` los cambia: `Notacion.conPalabras(.ruso).conTextos(en: .espanol)` escribe
/// «соль séptima de dominante, primera inversión».
///
/// La octava de las alturas se escribe con cifras (La4) o como subíndice (La₄). Las notaciones compactas
/// (`.espanolCompacto`, `.compacta(.aleman)`, `.compacta(.frances)`…) la escriben como subíndice y las demás con cifras;
/// `conOctavas(_:)` la cambia.
public struct Notacion: Hashable, Sendable, CaseIterable, Codable {
    /// Cómo se escriben los nombres de nota.
    public let escritura: EscrituraDeNotas
    /// El idioma de los textos (intervalos, acordes, mensajes…).
    public let textos: Idioma
    /// Cómo se escribe la octava de las alturas: con cifras (La4) o como subíndice (La₄). Si no se elige, la de
    /// la escritura (``EscrituraDeNotas/octavas``): subíndice en las compactas y cifras en las demás.
    public let octavas: EscrituraDeLaOctava

    /// Las notas escritas como `escritura`, con los textos en `textos` o, si no se da, en el idioma de las
    /// notas, y la octava escrita como `octavas` o, si no se da, como la escriba la escritura.
    public init(escritura: EscrituraDeNotas, textos: Idioma? = nil, octavas: EscrituraDeLaOctava? = nil) {
        self.escritura = escritura
        self.textos = textos ?? escritura.idioma
        self.octavas = octavas ?? escritura.octavas
    }

    /// Español con las alteraciones en palabras: Do, Fa sostenido, Si bemol; en los cifrados, Fa♯7, Si♭m.
    public static let espanolPalabras = Notacion(escritura: .espanolPalabras)
    /// Español con caracteres ASCII: Do, Fa#, Sib.
    public static let espanolASCII = Notacion(escritura: .espanolASCII)
    /// Español compacto, con símbolos tipográficos y la octava en subíndice: Do, Fa♯, Si𝄫; La₄.
    public static let espanolCompacto = Notacion(escritura: .espanolCompacto)
    /// Inglés con las alteraciones en palabras: C, F sharp, B flat; en los cifrados, F♯7, B♭m.
    public static let inglesPalabras = Notacion(escritura: .inglesPalabras)
    /// Inglés con caracteres ASCII: C, F#, Bb (la forma habitual de escribir en inglés).
    public static let inglesASCII = Notacion(escritura: .inglesASCII)
    /// Inglés compacto, con símbolos tipográficos y la octava en subíndice: C, F♯, B𝄫; A₄.
    public static let inglesCompacto = Notacion(escritura: .inglesCompacto)

    /// Las notaciones con nombre, una por escritura, con los textos en el idioma de sus notas. No incluye
    /// las combinadas (`conTextos(en:)`), que también son notaciones válidas.
    public static let allCases: [Notacion] = EscrituraDeNotas.allCases.map { Notacion(escritura: $0) }

    /// La notación habitual de un idioma: con ♯ y ♭ en español (`.espanolCompacto`), con # y b en inglés
    /// (`.inglesASCII`) y con Fis y Es en alemán (`.compacta(.aleman)`) o Fisz en húngaro (`.compacta(.hungaro)`) y Fiss en sueco (`.compacta(.sueco)`), que es
    /// como se suelen escribir; en los demás, la de las alteraciones con palabras, y no la compacta:
    /// `Notacion.delIdioma(.catalan)` es `.conPalabras(.catalan)` (fa sostingut), no `.compacta(.catalan)` (Fa♯).
    public static func delIdioma(_ idioma: Idioma) -> Notacion {
        Notacion(escritura: EscrituraDeNotas(idioma: idioma, ascii: idioma == .ingles))
    }

    /// La notación compacta de un idioma, con los textos en ese idioma: `.compacta(.catalan)` escribe Fa♯ y Si𝄫,
    /// `.compacta(.aleman)`, Fis y Heses, y `.compacta(.ruso)`, Фа♯. Ver `EscrituraDeNotas.compacta(_:)`.
    public static func compacta(_ idioma: Idioma) -> Notacion { Notacion(escritura: .compacta(idioma)) }

    /// La notación de un idioma con las alteraciones en palabras, con los textos en ese idioma: `.conPalabras(.catalan)`
    /// escribe «fa sostingut», `.conPalabras(.aleman)`, «F Kreuz», y `.conPalabras(.frances)`, «fa dièse». Ver
    /// `EscrituraDeNotas.conPalabras(_:)`.
    public static func conPalabras(_ idioma: Idioma) -> Notacion { Notacion(escritura: .conPalabras(idioma)) }

    /// Las notas con los nombres de un sistema fijo de otra tradición y los textos en `textos` (en español si no se
    /// da): `Notacion.sistema(.bizantino, textos: .euskera)` escribe Ga♯ y explica en euskera. `nil` para los
    /// sistemas móviles, como el sargam: sus nombres son de grados, y se piden a la escala
    /// (`Escala.nombres(en:grafia:)`). Ver `EscrituraDeNotas.sistema(_:grafia:)`.
    public static func sistema(
        _ sistema: SistemaDeNombres, grafia: Grafia = .transliterada, textos: Idioma? = nil
    ) -> Notacion? {
        EscrituraDeNotas.sistema(sistema, grafia: grafia).map { Notacion(escritura: $0, textos: textos) }
    }

    /// El sistema de nombres de otra tradición de las notas, si lo hay (``EscrituraDeNotas/sistema``).
    public var sistemaDeNombres: SistemaDeNombres? { escritura.sistema }

    /// La misma notación de las notas con los textos en otro idioma: `Notacion.conPalabras(.ruso).conTextos(en:
    /// .espanol)`.
    public func conTextos(en idioma: Idioma) -> Notacion {
        Notacion(escritura: escritura, textos: idioma, octavas: octavas)
    }

    /// La misma notación con la octava escrita de otra forma: `Notacion.espanolCompacto.conOctavas(.cifras)`
    /// escribe La4 y Fa♯3, y `Notacion.espanolASCII.conOctavas(.subindices)`, La₄ y Fa#₃.
    public func conOctavas(_ octavas: EscrituraDeLaOctava) -> Notacion {
        Notacion(escritura: escritura, textos: textos, octavas: octavas)
    }

    /// La notación de las notas con los textos en su propio idioma y la octava como la escriba la escritura:
    /// `.conPalabras(.ruso).conTextos(en: .espanol).notas` es `.conPalabras(.ruso)`.
    public var notas: Notacion { Notacion(escritura: escritura) }

    /// ¿Lleva los textos en un idioma distinto del de sus notas?
    public var esCombinada: Bool { textos != escritura.idioma }

    /// El idioma de los nombres de nota.
    public var idiomaDeLasNotas: Idioma { escritura.idioma }

    /// Idioma de las abreviaturas de los intervalos (5J, P5), que solo están en español e inglés:
    /// español en español, catalán, gallego, euskera y portugués; inglés en
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
public enum EscrituraDeLaOctava: String, Hashable, Sendable, CaseIterable, Codable {
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

/// Cómo se escriben los nombres de nota en una `Notacion`: el idioma y si las alteraciones van en palabras o de
/// forma compacta (con #/b o con ♯/♭ en español e inglés; Fis en alemán; Fa♯, Ré♭, Фа♯ en los demás).
///
/// No es una lista de casos, sino el idioma y su variante: las treinta y dos escrituras con nombre
/// (`.espanolCompacto`, `.conPalabras(.ruso)`…) salen de los trece idiomas, con tres formas en español y en inglés
/// (palabras, ASCII y compacta) y dos en los demás (palabras y compacta). Añadir un idioma es añadir su caso a
/// ``Idioma`` y su fila a ``ReglasDeIdioma``; aquí no hay nada que tocar. `allCases` las recorre en el orden de `Idioma`.
public struct EscrituraDeNotas: Hashable, Sendable, CaseIterable {
    /// El idioma de los nombres de nota.
    public let idioma: Idioma
    /// Las alteraciones en palabras: «Fa sostenido», «F sharp», «F Kreuz», «fa sostingut». Sin palabras, la forma
    /// compacta: Fa#, Fa♯, Fis, Fa♯ (con la sílaba en mayúscula, como en los cifrados).
    public let conPalabras: Bool
    /// Cómo se escriben los signos de las alteraciones: con # y b (`.ascii`) en español e inglés ASCII y en
    /// alemán; con 𝄪 y 𝄫 para las dobles (`.conDobles`) en las demás compactas (Fa𝄪, B𝄫); con ♯ y ♭
    /// (`.conSimples`) en las demás, también en los cifrados de las que usan palabras.
    public let tipografia: Tipografia
    /// El sistema de nombres de otra tradición con que se escriben las notas, si no son las del idioma: con
    /// `.bizantino`, Fa♯ es Ga♯; con `.japones`, 嬰ヘ. Solo los fijos (``FamiliaDeNombres/fija``): en los móviles el
    /// nombre depende de la tónica, y se piden a la escala (`Escala.nombres(en:grafia:)`).
    public let sistema: SistemaDeNombres?
    /// La grafía del `sistema`: la original (Νη, ハ), la transliterada (Ni, Ha) o la ASCII. Sin sistema, `.transliterada`,
    /// que no se usa.
    public let grafia: Grafia

    private init(_ idioma: Idioma, conPalabras: Bool = false, tipografia: Tipografia? = nil) {
        self.idioma = idioma
        self.conPalabras = conPalabras
        self.tipografia = tipografia ?? idioma.reglas.tipografia
        self.sistema = nil
        self.grafia = .transliterada
    }

    private init(sistema: SistemaDeNombres, grafia: Grafia) {
        // El idioma solo da los textos si la notación no elige otros, y las reglas de lo que no son nombres de nota.
        self.idioma = .espanol
        self.conPalabras = false
        self.tipografia = grafia == .ascii ? .ascii : .conSimples
        self.sistema = sistema
        self.grafia = grafia
    }

    /// Las notas con los nombres de un sistema fijo de otra tradición, en una grafía: `.sistema(.bizantino)` escribe
    /// Ni, Ga♯, Zo♭; `.sistema(.japones, grafia: .original)`, ハ, 嬰ヘ, 変ロ, y `.sistema(.luChinos)`, huángzhōng,
    /// dàlǚ. `nil` para los móviles (el sargam, el jianpu…), que nombran grados y no notas.
    public static func sistema(_ sistema: SistemaDeNombres, grafia: Grafia = .transliterada) -> EscrituraDeNotas? {
        guard sistema.familia == .fija else { return nil }
        return EscrituraDeNotas(sistema: sistema, grafia: grafia)
    }

    /// Las escrituras de los sistemas fijos de otras tradiciones, en sus tres grafías. No están en `allCases`, que
    /// son las de los idiomas.
    public static let deOtrasTradiciones: [EscrituraDeNotas] = SistemaDeNombres.allCases.flatMap { sistema in
        Grafia.allCases.compactMap { EscrituraDeNotas.sistema(sistema, grafia: $0) }
    }

    /// Do, Fa sostenido, Si bemol.
    public static let espanolPalabras = EscrituraDeNotas(.espanol, conPalabras: true, tipografia: .conSimples)
    /// Do, Fa#, Sib.
    public static let espanolASCII = EscrituraDeNotas(.espanol, tipografia: .ascii)
    /// Do, Fa♯, Si♭, Fa𝄪, Si𝄫.
    public static let espanolCompacto = EscrituraDeNotas(.espanol, tipografia: .conDobles)
    /// C, F sharp, B flat.
    public static let inglesPalabras = EscrituraDeNotas(.ingles, conPalabras: true, tipografia: .conSimples)
    /// C, F#, Bb.
    public static let inglesASCII = EscrituraDeNotas(.ingles, tipografia: .ascii)
    /// C, F♯, B♭, F𝄪, B𝄫.
    public static let inglesCompacto = EscrituraDeNotas(.ingles, tipografia: .conDobles)

    /// Las escrituras de los trece idiomas: tres en los que tienen variantes de signos (palabras, ASCII y
    /// compacta) y dos en los demás (palabras y compacta).
    public static let allCases: [EscrituraDeNotas] = Idioma.allCases.flatMap { idioma in
        switch idioma.reglas.alteraciones {
        case .signos:
            return [
                EscrituraDeNotas(idioma, conPalabras: true, tipografia: .conSimples),
                EscrituraDeNotas(idioma, tipografia: .ascii),
                EscrituraDeNotas(idioma, tipografia: tipografiaCompacta(idioma)),
            ]
        case .alemana, .palabras:
            return [EscrituraDeNotas(idioma, conPalabras: true), .compacta(idioma)]
        }
    }

    /// La escritura de un idioma con las alteraciones en palabras: «Fa sostenido», «F Kreuz», «fa dièse».
    public static func conPalabras(_ idioma: Idioma) -> EscrituraDeNotas {
        EscrituraDeNotas(idioma, conPalabras: true, tipografia: idioma.reglas.tieneVariantes ? .conSimples : nil)
    }

    /// La escritura compacta de un idioma, con la octava en subíndice: Fa♯, F♯, Fis, Ré♭, Фа♯.
    public static func compacta(_ idioma: Idioma) -> EscrituraDeNotas {
        EscrituraDeNotas(idioma, tipografia: tipografiaCompacta(idioma))
    }

    /// Los signos de la compacta de un idioma: 𝄪 y 𝄫 (Fa𝄪, F𝄪); en alemán, en húngaro y en sueco, los del idioma, que
    /// escriben las alteraciones con sufijos (Fisis).
    private static func tipografiaCompacta(_ idioma: Idioma) -> Tipografia? {
        idioma.reglas.alteraciones == .alemana ? nil : .conDobles
    }

    /// La escritura habitual de un idioma: en español e inglés, con # y b si `ascii` y la compacta si no; en alemán
    /// y en húngaro, la compacta (Fis, Fisz); en los demás, con palabras («fa sostingut»), como se escriben en el
    /// texto. Para las otras, ``conPalabras(_:)`` y ``compacta(_:)``.
    public init(idioma: Idioma, ascii: Bool) {
        switch idioma.reglas.alteraciones {
        case .signos: self = ascii ? EscrituraDeNotas(idioma, tipografia: .ascii) : .compacta(idioma)
        case .alemana: self = EscrituraDeNotas(idioma)
        case .palabras: self = EscrituraDeNotas(idioma, conPalabras: true)
        }
    }

    /// Alteraciones como # y b en lugar de ♯ y ♭: `tipografia == .ascii`.
    public var usaASCII: Bool { tipografia == .ascii }

    /// ¿Es una de las compactas? `.espanolCompacto` (Fa♯), `.inglesCompacto` (F♯), `.compacta(.aleman)` (Fis),
    /// `.compacta(.frances)` (Ré♭)…: sin palabras y, en español e inglés, con signos tipográficos y no con # y b.
    public var esCompacta: Bool {
        if sistema != nil { return false }
        switch escrituraDeLaAlteracion {
        case .alemana: return true
        case .signos: return tipografia != .ascii
        case .palabras: return false
        }
    }

    /// Cómo escribe la octava de las alturas si la ``Notacion`` no elige otra: como subíndice en las compactas
    /// (La₄, Fis₄) y con cifras en las demás (La4, Fa#4, fa dièse 4).
    public var octavas: EscrituraDeLaOctava { esCompacta ? .subindices : .cifras }
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
public enum Idioma: String, Hashable, Sendable, CaseIterable, Codable {
    case espanol
    case ingles
    case catalan
    case gallego
    case euskera
    case portugues
    case frances
    case italiano
    case aleman
    case griego
    case ruso
    case hungaro
    case sueco
}

extension Idioma {
    /// El código ISO 639 del idioma: «es», «en», «ca», «gl», «eu», «pt», «fr», «it», «de»,
    /// «el», «ru», «hu» y «sv». Está en sus ``ReglasDeIdioma``.
    public var codigo: String { reglas.codigo }

    /// El idioma de un código ISO 639 («eu») o de una etiqueta de idioma con región («ca-ES», «pt_BR»), sin
    /// importar las mayúsculas; `nil` si no es uno de los trece.
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
    /// «Deutsch»), sin importar las mayúsculas ni las tildes («aleman», «FRANCAIS», «ελληνικα»). Si no es uno de los
    /// doce, lanza `ErrorDeLectura` (`.idiomaNoReconocido`) con sus códigos.
    ///
    ///     try Idioma(leyendo: "euskara")   // .euskera
    public init(leyendo nombre: String) throws {
        if let idioma = Idioma(codigo: nombre) {
            self = idioma
            return
        }
        guard let encontrado = Idioma.porNombre[nombre.claveDeBusqueda] else {
            throw ErrorDeLectura(
                texto: nombre, posicion: nil,
                motivo: .idiomaNoReconocido(nombre, opciones: Idioma.allCases.map(\.codigo)))
        }
        self = encontrado
    }

    /// Cada nombre de idioma, sin tildes (`claveDeBusqueda`), con su idioma.
    private static let porNombre: [String: Idioma] = Dictionary(
        Idioma.allCases.flatMap { idioma in idioma.nombres.map { ($0.claveDeBusqueda, idioma) } },
        uniquingKeysWith: { primero, _ in primero })
}

extension EscrituraDeNotas: Codable {
    // Se codifica con sus tres campos, y al leerla se busca entre `allCases`: solo hay esas.
    // Las de otras tradiciones, con su sistema y su grafía.
    private enum Claves: String, CodingKey { case idioma, conPalabras, tipografia, sistema, grafia }

    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.container(keyedBy: Claves.self)
        if let sistema = try contenedor.decodeIfPresent(SistemaDeNombres.self, forKey: .sistema) {
            let grafia = try contenedor.decodeIfPresent(Grafia.self, forKey: .grafia) ?? .transliterada
            guard let escritura = EscrituraDeNotas.sistema(sistema, grafia: grafia) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .sistema, in: contenedor, debugDescription: "un sistema móvil no escribe notas sueltas")
            }
            self = escritura
            return
        }
        let idioma = try contenedor.decode(Idioma.self, forKey: .idioma)
        let conPalabras = try contenedor.decode(Bool.self, forKey: .conPalabras)
        let tipografia = try contenedor.decode(Tipografia.self, forKey: .tipografia)
        guard
            let escritura = EscrituraDeNotas.allCases.first(where: {
                $0.idioma == idioma && $0.conPalabras == conPalabras && $0.tipografia == tipografia
            })
        else {
            throw DecodingError.dataCorruptedError(
                forKey: .tipografia, in: contenedor, debugDescription: "no hay esa escritura de las notas")
        }
        self = escritura
    }

    public func encode(to encoder: Encoder) throws {
        var contenedor = encoder.container(keyedBy: Claves.self)
        if let sistema {
            try contenedor.encode(sistema, forKey: .sistema)
            try contenedor.encode(grafia, forKey: .grafia)
            return
        }
        try contenedor.encode(idioma, forKey: .idioma)
        try contenedor.encode(conPalabras, forKey: .conPalabras)
        try contenedor.encode(tipografia, forKey: .tipografia)
    }
}
