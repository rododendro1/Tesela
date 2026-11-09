// MARK: - Notación

/// Cómo se escribe todo lo que el motor convierte en texto: el idioma (nombres de nota,
/// de intervalos, de acordes, de escalas…) y si las alteraciones se escriben con palabras o de forma compacta
/// (con #/b o con ♯/♭ en español e inglés; Fis, Es, B y H en alemán; Fa♯, Ré♭, Фа♯ en los demás).
///
/// | Notación | Nota | Intervalo | Acorde | Escala |
/// |---|---|---|---|---|
/// | `.conPalabras(.espanol)` | Fa sostenido | 3ª mayor | séptima de dominante | Re dórico |
/// | `.ascii(.espanol)` | Fa# | 3ª mayor | séptima de dominante | Re dórico |
/// | `.compacta(.espanol)` | Fa♯ | 3ª mayor | séptima de dominante | Re dórico |
/// | `.conPalabras(.ingles)` | F sharp | major third | dominant seventh | D dorian |
/// | `.ascii(.ingles)` | F# | major third | dominant seventh | D dorian |
/// | `.compacta(.ingles)` | F♯ | major third | dominant seventh | D dorian |
/// | `.conPalabras(.catalan)` | fa sostingut | 3a major | setena de dominant | fa sostingut dòric |
/// | `.compacta(.catalan)` | Fa♯ | 3a major | setena de dominant | Fa♯ dòric |
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
/// | `.conPalabras(.griego).conGrafia(.transliterada)` | fa díesi | megáli tríti | synchordía évdomis despózousas | fa díesi dórios |
/// | `.conPalabras(.ruso)` | фа-диез | большая терция | доминантсептаккорд | фа-диез дорийский |
/// | `.compacta(.ruso)` | Фа♯ | большая терция | доминантсептаккорд | Фа♯ дорийский |
/// | `.conPalabras(.ruso).conGrafia(.transliterada)` | fa-diez | bolʹšaâ terciâ | dominantseptakkord | fa-diez dorijskij |
/// | `.conPalabras(.ruso).conGrafia(.ascii)` | fa-diez | bol'shaya tertsiya | dominantseptakkord | fa-diez doriyskiy |
/// | `.conPalabras(.hungaro)` | F kereszt | nagy terc | domináns szeptimakkord | F kereszt dór |
/// | `.compacta(.hungaro)` | Fisz | nagy terc | domináns szeptimakkord | Fisz dór |
/// | `.conPalabras(.sueco)` | F kors | stor ters | dominantseptimackord | F kors dorisk |
/// | `.compacta(.sueco)` | Fiss | stor ters | dominantseptimackord | Fiss dorisk |
///
/// En los trece idiomas están traducidos los nombres de nota y de alteración, los modos de las
/// tonalidades (Fis-Dur, fa dièse majeur, фа-диез мажор), los textos del motor (mensajes de error,
/// intervalos, cadencias…) y los nombres de los catálogos (acordes, escalas, instrumentos).
///
/// Una notación son tres elecciones: cómo se escriben las notas (`escritura`), en qué idioma salen los textos
/// (`textos`) y en qué alfabeto (`grafia`). Todos los idiomas se construyen igual: `.conPalabras(_:)`, `.compacta(_:)`
/// y `.ascii(_:)` (o `Notacion(.ruso, .palabras)`), y `.delIdioma(_:)` da la habitual. Llevan los textos en el idioma
/// de sus notas, y `conTextos(en:)` los cambia: `Notacion.conPalabras(.ruso).conTextos(en: .espanol)` escribe
/// «соль séptima de dominante, primera inversión».
///
/// El ruso y el griego se escriben también en el alfabeto latino, con `conGrafia(.transliterada)` (el cirílico con
/// la transliteración ISO 9 y el griego con la ELOT 743) o, sin diacríticos, con `conGrafia(.ascii)`
/// (``Transliteracion``). Se leen igual en todas las grafías. Es la misma ``Grafia`` que la de los sistemas de otras
/// tradiciones: `Notacion.sistema(.bizantino, grafia: .original)` escribe Γα♯.
///
/// La octava de las alturas se escribe con cifras (La4) o como subíndice (La₄). Las notaciones compactas
/// (`.compacta(.espanol)`, `.compacta(.aleman)`, `.compacta(.frances)`…) la escriben como subíndice y las demás con cifras;
/// `conOctavas(_:)` la cambia.
public struct Notacion: Hashable, Sendable, CaseIterable, Codable {
    /// Cómo se escriben los nombres de nota.
    public let escritura: EscrituraDeNotas
    /// El idioma de los textos (intervalos, acordes, mensajes…).
    public let textos: Idioma
    /// Cómo se escribe la octava de las alturas: con cifras (La4) o como subíndice (La₄). Si no se elige, la de
    /// la escritura (``EscrituraDeNotas/octavas``): subíndice en las compactas y cifras en las demás.
    public let octavas: EscrituraDeLaOctava
    /// En qué alfabeto se escriben los nombres de un sistema de otra tradición (Νη, Ni) y, en ruso y en griego, las
    /// notas y los textos: en el suyo (`.original`: соль, большая терция) o en el latino, con diacríticos
    /// (`.transliterada`: solʹ, bolʹšaâ terciâ; megáli tríti) o sin ellos (`.ascii`: sol', bol'shaya tertsiya;
    /// megali triti). En las demás notaciones no cambia nada, y es siempre `.original`.
    public let grafia: Grafia

    /// Las notas escritas como `escritura`, con los textos en `textos` o, si no se da, en el idioma de las
    /// notas, la octava escrita como `octavas` o, si no se da, como la escriba la escritura, y todo en la `grafia`
    /// que se dé o, si no, en la habitual: la transliterada en los sistemas de otras tradiciones y la original en
    /// los idiomas.
    public init(
        escritura: EscrituraDeNotas, textos: Idioma? = nil, octavas: EscrituraDeLaOctava? = nil,
        grafia: Grafia? = nil
    ) {
        self.escritura = escritura
        self.textos = textos ?? escritura.idioma
        self.octavas = octavas ?? escritura.octavas
        // La grafía solo cambia algo en los sistemas y en ruso y en griego; en lo demás se queda en la original,
        // para que dos notaciones que escriben lo mismo sean iguales.
        let cuenta =
            escritura.sistema != nil || Self.conOtroAlfabeto.contains(escritura.idioma)
            || Self.conOtroAlfabeto.contains(self.textos)
        self.grafia = cuenta ? grafia ?? escritura.grafiaHabitual : .original
    }

    /// Las notas de un idioma con las alteraciones de una forma (si no se da, la habitual del idioma:
    /// ``EscrituraDeNotas/habitual(_:)``), y los textos en `textos` o en el idioma de las notas:
    /// `Notacion(.ruso, .palabras, grafia: .transliterada)` escribe «fa-diez» y «bolʹšaâ terciâ».
    public init(
        _ idioma: Idioma, _ forma: FormaDeLasAlteraciones? = nil, textos: Idioma? = nil, grafia: Grafia? = nil
    ) {
        let escritura = forma.map { EscrituraDeNotas.idioma(idioma, $0) } ?? .habitual(idioma)
        self.init(escritura: escritura, textos: textos, grafia: grafia)
    }

    /// Los idiomas que no se escriben con letras latinas, en los que la grafía cambia algo.
    private static let conOtroAlfabeto: Set<Idioma> = [.ruso, .griego]

    /// Las notaciones con nombre, una por escritura, con los textos en el idioma de sus notas. No incluye
    /// las combinadas (`conTextos(en:)`), que también son notaciones válidas.
    public static let allCases: [Notacion] = EscrituraDeNotas.allCases.map { Notacion(escritura: $0) }

    /// La notación habitual de un idioma: con ♯ y ♭ en español (`.compacta(.espanol)`), con # y b en inglés
    /// (`.ascii(.ingles)`) y con Fis y Es en alemán (`.compacta(.aleman)`), Fisz en húngaro y Fiss en sueco, que
    /// es como se suelen escribir; en los demás, la de las alteraciones con palabras, y no la compacta:
    /// `Notacion.delIdioma(.catalan)` es `.conPalabras(.catalan)` (fa sostingut), no `.compacta(.catalan)` (Fa♯).
    public static func delIdioma(_ idioma: Idioma) -> Notacion { Notacion(idioma) }

    /// La notación de un idioma con las alteraciones en palabras, con los textos en ese idioma:
    /// `.conPalabras(.espanol)` escribe «Fa sostenido», `.conPalabras(.aleman)`, «F Kreuz», y `.conPalabras(.ruso)`,
    /// «фа-диез». Ver ``EscrituraDeNotas/conPalabras(_:)``.
    public static func conPalabras(_ idioma: Idioma) -> Notacion { Notacion(idioma, .palabras) }

    /// La notación de un idioma con # y b, con los textos en ese idioma: `.ascii(.espanol)` escribe Fa# y Sib, y
    /// `.ascii(.ingles)`, F# y Bb. Ver ``EscrituraDeNotas/ascii(_:)``.
    public static func ascii(_ idioma: Idioma) -> Notacion { Notacion(idioma, .ascii) }

    /// La notación compacta de un idioma, con los textos en ese idioma y la octava en subíndice:
    /// `.compacta(.espanol)` escribe Fa♯ y Si𝄫, `.compacta(.aleman)`, Fis y Heses, y `.compacta(.ruso)`, Фа♯. Ver
    /// ``EscrituraDeNotas/compacta(_:)``.
    public static func compacta(_ idioma: Idioma) -> Notacion { Notacion(idioma, .compacta) }

    /// Las notas con los nombres de un sistema fijo de otra tradición y los textos en `textos` (en español si no se
    /// da): `Notacion.sistema(.bizantino, textos: .euskera)` escribe Ga♯ y explica en euskera. `nil` para los
    /// sistemas móviles, como el sargam: sus nombres son de grados, y se piden a la escala
    /// (`Escala.nombres(en:grafia:)`).
    public static func sistema(
        _ sistema: SistemaDeNombres, grafia: Grafia = .transliterada, textos: Idioma? = nil
    ) -> Notacion? {
        guard sistema.familia == .fija else { return nil }
        return Notacion(escritura: .sistema(sistema), textos: textos, grafia: grafia)
    }

    /// Las notaciones de los sistemas fijos de otras tradiciones, en sus tres grafías. No están en `allCases`, que
    /// son las de los idiomas.
    public static let deOtrasTradiciones: [Notacion] = SistemaDeNombres.allCases.flatMap { sistema in
        Grafia.allCases.compactMap { Notacion.sistema(sistema, grafia: $0) }
    }

    /// El sistema de nombres de otra tradición de las notas, si lo hay (``EscrituraDeNotas/sistema``).
    public var sistemaDeNombres: SistemaDeNombres? { escritura.sistema }

    /// La misma notación de las notas con los textos en otro idioma: `Notacion.conPalabras(.ruso).conTextos(en:
    /// .espanol)`.
    public func conTextos(en idioma: Idioma) -> Notacion {
        Notacion(escritura: escritura, textos: idioma, octavas: octavas, grafia: grafia)
    }

    /// La misma notación con la octava escrita de otra forma: `Notacion.compacta(.espanol).conOctavas(.cifras)`
    /// escribe La4 y Fa♯3, y `Notacion.ascii(.espanol).conOctavas(.subindices)`, La₄ y Fa#₃.
    public func conOctavas(_ octavas: EscrituraDeLaOctava) -> Notacion {
        Notacion(escritura: escritura, textos: textos, octavas: octavas, grafia: grafia)
    }

    /// La misma notación en otra grafía: `Notacion.conPalabras(.ruso).conGrafia(.transliterada)` escribe «fa-diez»
    /// y «bolʹšaâ terciâ», `Notacion.compacta(.griego).conGrafia(.ascii)`, «Fa#» y «megali triti», y
    /// `Notacion.sistema(.bizantino)!.conGrafia(.original)`, «Γα♯». En las demás no cambia nada.
    public func conGrafia(_ grafia: Grafia) -> Notacion {
        Notacion(escritura: escritura, textos: textos, octavas: octavas, grafia: grafia)
    }

    /// La grafía de los nombres de nota: la de la notación en los sistemas y en ruso y en griego, y la original
    /// en los demás idiomas.
    public var grafiaDeLasNotas: Grafia {
        escritura.sistema != nil || Self.conOtroAlfabeto.contains(escritura.idioma) ? grafia : .original
    }

    /// La grafía de los textos: la de la notación si van en ruso o en griego, y la original en los demás.
    public var grafiaDeLosTextos: Grafia { Self.conOtroAlfabeto.contains(textos) ? grafia : .original }

    /// Un texto del idioma de los textos en la grafía de la notación: transliterado (``Transliteracion``) si van en
    /// ruso o en griego y la grafía no es la original; si no, igual. Lo que escribe el motor ya sale así; sirve
    /// para los textos que se componen fuera de él.
    public func enSuGrafia(_ texto: String) -> String { Transliteracion.texto(texto, en: grafiaDeLosTextos) }

    /// Las reglas del idioma de las notas en su grafía: con los naturales, los separadores y los modos
    /// transliterados en ruso y en griego si la grafía no es la original (solʹ, mažor).
    public var reglasDeLasNotas: ReglasDeIdioma { idiomaDeLasNotas.reglas(en: grafiaDeLasNotas) }

    /// La notación de las notas con los textos en su propio idioma y la octava como la escriba la escritura:
    /// `.conPalabras(.ruso).conTextos(en: .espanol).notacionDeLasNotas` es `.conPalabras(.ruso)`. Conserva la
    /// grafía.
    public var notacionDeLasNotas: Notacion { Notacion(escritura: escritura, grafia: grafia) }

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
    /// de las notas con palabras o sufijos (Fis, fa dièse), solo afecta a los signos de los cifrados. Con las notas
    /// en la grafía ASCII, # y b.
    public var tipografia: Tipografia { grafiaDeLasNotas == .ascii ? .ascii : escritura.tipografia }

    /// Alteraciones como # y b en lugar de ♯ y ♭: `tipografia == .ascii`.
    public var usaASCII: Bool { tipografia == .ascii }
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

/// Cómo se escriben las alteraciones de los nombres de nota de un idioma en una ``EscrituraDeNotas``.
public enum FormaDeLasAlteraciones: String, Hashable, Sendable, CaseIterable, Codable {
    /// Con palabras: «Fa sostenido», «F sharp», «F Kreuz», «fa sostingut», «фа-диез».
    case palabras
    /// Con # y b, como se escribe en un teclado: Fa#, F#, Sib. En alemán, en húngaro y en sueco, como la compacta
    /// (Fis), que ya es ASCII.
    case ascii
    /// Con signos tipográficos (Fa♯, F♯, Si𝄫), con la sílaba en mayúscula en los idiomas que escriben las
    /// alteraciones con palabras (Ré♭, Фа♯), o a la alemana (Fis, Fisz, Fiss), y con la octava en subíndice.
    case compacta
}

/// Cómo se escriben los nombres de nota en una `Notacion`: los de un idioma, con las alteraciones en palabras, con
/// # y b o de forma compacta (Fa sostenido, Fa#, Fa♯; F Kreuz, Fis; фа-диез, Фа♯), o los de un sistema fijo de otra
/// tradición (Ga♯ en bizantino, 嬰ヘ en japonés).
///
/// `allCases` tiene las de los trece idiomas, en el orden de `Idioma`: tres en español y en inglés (palabras, ASCII
/// y compacta) y dos en los demás (palabras y compacta). Añadir un idioma es añadir su caso a ``Idioma`` y su fila a
/// ``ReglasDeIdioma``; aquí no hay nada que tocar.
public enum EscrituraDeNotas: Hashable, Sendable, CaseIterable {
    /// Los nombres de nota de un idioma, con las alteraciones de una forma.
    case idioma(Idioma, FormaDeLasAlteraciones)
    /// Los nombres de un sistema de otra tradición: con `.bizantino`, Fa♯ es Ga♯; con `.japones`, 嬰ヘ. Para escribir
    /// notas sueltas sirven los fijos (``FamiliaDeNombres/fija``): en los móviles el nombre depende de la tónica, y
    /// se piden a la escala (`Escala.nombres(en:grafia:)`); aquí se nombrarían desde Do.
    case sistema(SistemaDeNombres)

    /// Las escrituras de los trece idiomas: tres en los que tienen variantes de signos (palabras, ASCII y
    /// compacta) y dos en los demás (palabras y compacta).
    public static let allCases: [EscrituraDeNotas] = Idioma.allCases.flatMap { idioma in
        (idioma.reglas.tieneVariantes ? FormaDeLasAlteraciones.allCases : [.palabras, .compacta]).map {
            .idioma(idioma, $0)
        }
    }

    /// La escritura de un idioma con las alteraciones en palabras: «Fa sostenido», «F Kreuz», «fa dièse».
    public static func conPalabras(_ idioma: Idioma) -> EscrituraDeNotas { .idioma(idioma, .palabras) }

    /// La escritura de un idioma con # y b: Fa#, F#, Sib.
    public static func ascii(_ idioma: Idioma) -> EscrituraDeNotas { .idioma(idioma, .ascii) }

    /// La escritura compacta de un idioma, con la octava en subíndice: Fa♯, F♯, Fis, Ré♭, Фа♯.
    public static func compacta(_ idioma: Idioma) -> EscrituraDeNotas { .idioma(idioma, .compacta) }

    /// La escritura habitual de un idioma: en español la compacta (Fa♯) y en inglés la ASCII (F#); en alemán, en
    /// húngaro y en sueco, la compacta (Fis, Fisz, Fiss); en los demás, con palabras («fa sostingut»), como se
    /// escriben en el texto.
    public static func habitual(_ idioma: Idioma) -> EscrituraDeNotas {
        switch idioma.reglas.alteraciones {
        case .signos: return idioma == .ingles ? .ascii(idioma) : .compacta(idioma)
        case .alemana: return .compacta(idioma)
        case .palabras: return .conPalabras(idioma)
        }
    }

    /// El idioma de los nombres de nota. En los sistemas de otras tradiciones, el español: solo da los textos si la
    /// notación no elige otros, y las reglas de lo que no son nombres de nota.
    public var idioma: Idioma {
        if case .idioma(let idioma, _) = self { return idioma }
        return .espanol
    }

    /// Cómo se escriben las alteraciones de los nombres de nota del idioma; `nil` en los sistemas.
    public var forma: FormaDeLasAlteraciones? {
        if case .idioma(_, let forma) = self { return forma }
        return nil
    }

    /// El sistema de nombres de otra tradición con que se escriben las notas, si no son las del idioma.
    public var sistema: SistemaDeNombres? {
        if case .sistema(let sistema) = self { return sistema }
        return nil
    }

    /// Las alteraciones en palabras: «Fa sostenido», «F sharp», «F Kreuz», «fa sostingut».
    public var conPalabras: Bool { forma == .palabras }

    /// Cómo se escriben los signos de las alteraciones: con # y b (`.ascii`) en la ASCII y en alemán, en húngaro y
    /// en sueco; con 𝄪 y 𝄫 para las dobles (`.unicodeConDobles`) en las demás compactas (Fa𝄪, B𝄫); con ♯ y ♭
    /// (`.unicode`) en las demás, también en los cifrados de las que usan palabras.
    public var tipografia: Tipografia {
        switch self {
        case .sistema: return .unicode
        case .idioma(let idioma, .palabras): return idioma.reglas.tieneVariantes ? .unicode : idioma.reglas.tipografia
        case .idioma(_, .ascii): return .ascii
        case .idioma(let idioma, .compacta):
            // En alemán, en húngaro y en sueco, los del idioma, que escriben las alteraciones con sufijos (Fisis).
            return idioma.reglas.alteraciones == .alemana ? idioma.reglas.tipografia : .unicodeConDobles
        }
    }

    /// Alteraciones como # y b en lugar de ♯ y ♭: `tipografia == .ascii`.
    public var usaASCII: Bool { tipografia == .ascii }

    /// ¿Es una de las compactas? `.compacta(.espanol)` (Fa♯), `.compacta(.ingles)` (F♯), `.compacta(.aleman)` (Fis),
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

    /// La grafía de una ``Notacion`` con esta escritura si no elige otra: la transliterada en los sistemas (Ni, Ga♯)
    /// y la original en los idiomas (соль).
    public var grafiaHabitual: Grafia { sistema != nil ? .transliterada : .original }
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
/// 3. Su fila en `Scripts/comun/idiomas.py`.
/// 4. Su argumento en el inicializador de `Traducido`, en el orden de `allCases`.
/// 5. Un fichero de textos por módulo en cada carpeta `Textos/`, que `comprobar_traducciones` busca.
///
/// Los nombres de nota y los datos del idioma no tienen más `switch` sobre `Idioma` que el de las reglas, sin
/// `default`, así que el compilador señala lo que falta; `Traducido` guarda sus valores en el orden de `allCases`, y
/// cada `TextosDeX` sin el argumento del idioma nuevo deja de compilar.
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

extension Notacion {
    private enum CodingKeys: String, CodingKey { case escritura, textos, octavas, grafia, alfabeto }
    private enum ClavesDeLaEscritura: String, CodingKey { case grafia }

    // La grafía solo se guarda si no es la habitual. Se leen también las guardadas antes: con el «alfabeto» latino
    // (la transliterada) y, en los sistemas, con la grafía dentro de la escritura.
    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.container(keyedBy: CodingKeys.self)
        let antigua: Grafia?
        if let alfabeto = try contenedor.decodeIfPresent(String.self, forKey: .alfabeto) {
            antigua = alfabeto == "latino" ? .transliterada : .original
        } else {
            let escritura = try contenedor.nestedContainer(keyedBy: ClavesDeLaEscritura.self, forKey: .escritura)
            antigua = try escritura.decodeIfPresent(Grafia.self, forKey: .grafia)
        }
        self.init(
            escritura: try contenedor.decode(EscrituraDeNotas.self, forKey: .escritura),
            textos: try contenedor.decode(Idioma.self, forKey: .textos),
            octavas: try contenedor.decode(EscrituraDeLaOctava.self, forKey: .octavas),
            grafia: try contenedor.decodeIfPresent(Grafia.self, forKey: .grafia) ?? antigua)
    }

    public func encode(to encoder: Encoder) throws {
        var contenedor = encoder.container(keyedBy: CodingKeys.self)
        try contenedor.encode(escritura, forKey: .escritura)
        try contenedor.encode(textos, forKey: .textos)
        try contenedor.encode(octavas, forKey: .octavas)
        if grafia != Notacion(escritura: escritura, textos: textos).grafia {
            try contenedor.encode(grafia, forKey: .grafia)
        }
    }
}

extension EscrituraDeNotas: Codable {
    // Las de los idiomas se guardan con su idioma, si van con palabras y su tipografía, como antes de que fueran un
    // `enum`, y al leerlas se busca la forma que escribe eso (la compacta antes que la ASCII, que en alemán son
    // iguales). Las de otras tradiciones, con su sistema.
    private enum Claves: String, CodingKey { case idioma, conPalabras, tipografia, sistema }

    public init(from decoder: Decoder) throws {
        let contenedor = try decoder.container(keyedBy: Claves.self)
        if let sistema = try contenedor.decodeIfPresent(SistemaDeNombres.self, forKey: .sistema) {
            guard sistema.familia == .fija else {
                throw DecodingError.dataCorruptedError(
                    forKey: .sistema, in: contenedor, debugDescription: "un sistema móvil no escribe notas sueltas")
            }
            self = .sistema(sistema)
            return
        }
        let idioma = try contenedor.decode(Idioma.self, forKey: .idioma)
        let conPalabras = try contenedor.decode(Bool.self, forKey: .conPalabras)
        let tipografia = try contenedor.decode(Tipografia.self, forKey: .tipografia)
        let formas: [FormaDeLasAlteraciones] = [.palabras, .compacta, .ascii]
        guard
            let escritura = formas.map({ EscrituraDeNotas.idioma(idioma, $0) }).first(where: {
                $0.conPalabras == conPalabras && $0.tipografia == tipografia
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
            return
        }
        try contenedor.encode(idioma, forKey: .idioma)
        try contenedor.encode(conPalabras, forKey: .conPalabras)
        try contenedor.encode(tipografia, forKey: .tipografia)
    }
}
