// MARK: - Traducción
//
// Los textos del motor que no son nombres de nota (mensajes de error, nombres de intervalos, de
// papeles en el acorde, de grados, de claves, de figuras, de cadencias…) se escriben en los quince
// idiomas de las notaciones: español, inglés, catalán, gallego, asturiano, aragonés, euskera, portugués,
// francés, occitano, italiano, alemán, griego, ruso y húngaro.
//
// Los textos se escriben un idioma por fichero: cada módulo tiene su `TextosDeX` (`TextosDeNucleo`,
// `TextosDeTrastes`…) con un campo por texto, y un fichero por idioma en su carpeta `Textos/`
// (`TextosDeNucleo+Espanol.swift`, `…+Ingles.swift`…). Los campos no tienen valores por omisión, así que un
// texto nuevo no compila hasta que está en los quince ficheros. `TextosDeX.en(notacion, \.campo)` da el texto
// de un campo en un idioma, y `TextosDeX.traduccion(\.campo)` su `Traduccion` (ver `TextosTraducidos`).
//
// Los nombres de los catálogos (tipos de acorde y de escala, instrumentos) también están en los quince idiomas, salvo los nombres tradicionales de escala
// (raga, maqam, pentatónicas japonesas…), que se escriben igual en todos.

/// Un valor en cada uno de los quince idiomas en los que escribe el motor: un texto, una lista de textos…
///
///     let ordinales = Traducido<[String]>(["primera", "segunda"], ["first", "second"],
///                                         ca: ["primera", "segona"], …, ru: ["первая", "вторая"])
///     ordinales.en(.catalan)[1]    // "segona"
///
/// Como en ``Traduccion``, los quince valores son obligatorios y van en el mismo orden, así que una lista por
/// idioma se revisa junto a las demás en vez de repartida por los `case` de un `switch`.
public struct Traducido<Valor> {
    public let espanol: Valor
    public let ingles: Valor
    public let catalan: Valor
    public let gallego: Valor
    public let asturiano: Valor
    public let aragones: Valor
    public let euskera: Valor
    public let portugues: Valor
    public let frances: Valor
    public let occitano: Valor
    public let italiano: Valor
    public let aleman: Valor
    public let griego: Valor
    public let ruso: Valor
    public let hungaro: Valor

    public init(
        _ espanol: Valor, _ ingles: Valor, ca catalan: Valor, gl gallego: Valor, ast asturiano: Valor,
        an aragones: Valor, eu euskera: Valor, pt portugues: Valor, fr frances: Valor, oc occitano: Valor,
        it italiano: Valor, de aleman: Valor, el griego: Valor, ru ruso: Valor, hu hungaro: Valor
    ) {
        self.espanol = espanol
        self.ingles = ingles
        self.catalan = catalan
        self.gallego = gallego
        self.asturiano = asturiano
        self.aragones = aragones
        self.euskera = euskera
        self.portugues = portugues
        self.frances = frances
        self.occitano = occitano
        self.italiano = italiano
        self.aleman = aleman
        self.griego = griego
        self.ruso = ruso
        self.hungaro = hungaro
    }

    /// El valor de cada idioma, calculado con su notación habitual (`Notacion.delIdioma`): para los textos que ya
    /// sabe escribir el motor en cada idioma.
    ///
    ///     let inversion = Traduccion(cadaIdioma: { Acorde.nombreDeLaInversion(1, en: $0) })
    ///     inversion.en(.aleman)    // "erste Umkehrung"
    public init(cadaIdioma valor: (Notacion) -> Valor) {
        self.init(
            valor(.delIdioma(.espanol)), valor(.delIdioma(.ingles)), ca: valor(.delIdioma(.catalan)),
            gl: valor(.delIdioma(.gallego)), ast: valor(.delIdioma(.asturiano)), an: valor(.delIdioma(.aragones)),
            eu: valor(.delIdioma(.euskera)), pt: valor(.delIdioma(.portugues)), fr: valor(.delIdioma(.frances)),
            oc: valor(.delIdioma(.occitano)), it: valor(.delIdioma(.italiano)), de: valor(.delIdioma(.aleman)),
            el: valor(.delIdioma(.griego)), ru: valor(.delIdioma(.ruso)), hu: valor(.delIdioma(.hungaro)))
    }

    /// El valor de cada idioma, calculado a partir del idioma: para los datos que no dependen de cómo se escriben
    /// las notas.
    ///
    ///     let codigos = Traducido(porIdioma: { $0.codigo })
    ///     codigos.texto(en: .asturiano)    // "ast"
    public init(porIdioma valor: (Idioma) -> Valor) {
        self.init(
            valor(.espanol), valor(.ingles), ca: valor(.catalan), gl: valor(.gallego), ast: valor(.asturiano),
            an: valor(.aragones), eu: valor(.euskera), pt: valor(.portugues), fr: valor(.frances),
            oc: valor(.occitano), it: valor(.italiano), de: valor(.aleman), el: valor(.griego), ru: valor(.ruso),
            hu: valor(.hungaro))
    }

    /// Los quince valores, en el orden del inicializador.
    package var todos: [Valor] {
        [
            espanol, ingles, catalan, gallego, asturiano, aragones, euskera, portugues, frances, occitano, italiano,
            aleman, griego, ruso, hungaro,
        ]
    }

    /// El valor en el idioma de los textos de la notación (`Notacion.textos`).
    public func en(_ notacion: Notacion) -> Valor { texto(en: notacion.textos) }

    /// El valor en un idioma.
    public func texto(en idioma: Idioma) -> Valor {
        switch idioma {
        case .espanol: return espanol
        case .ingles: return ingles
        case .catalan: return catalan
        case .gallego: return gallego
        case .asturiano: return asturiano
        case .aragones: return aragones
        case .euskera: return euskera
        case .portugues: return portugues
        case .frances: return frances
        case .occitano: return occitano
        case .italiano: return italiano
        case .aleman: return aleman
        case .griego: return griego
        case .ruso: return ruso
        case .hungaro: return hungaro
        }
    }

    /// El mismo cambio en los quince idiomas.
    public func map<Otro>(_ cambio: (Valor) throws -> Otro) rethrows -> Traducido<Otro> {
        Traducido<Otro>(
            try cambio(espanol), try cambio(ingles), ca: try cambio(catalan), gl: try cambio(gallego),
            ast: try cambio(asturiano), an: try cambio(aragones), eu: try cambio(euskera),
            pt: try cambio(portugues), fr: try cambio(frances), oc: try cambio(occitano),
            it: try cambio(italiano), de: try cambio(aleman),
            el: try cambio(griego), ru: try cambio(ruso), hu: try cambio(hungaro))
    }
}

/// Los textos de un módulo en los quince idiomas: los `TextosDeX` (`TextosDeNucleo`, `TextosDeTeoria`…), con un
/// campo por texto y un fichero por idioma.
///
///     TextosDeTeoria.en(notacion, \.pivote)              // el texto en el idioma de la notación
///     TextosDeTeoria.en(notacion) { $0.conBajoEn(bajo) } // un texto con valores
///     TextosDeTeoria.traduccion(\.pivote)                // la `Traduccion`, para guardarla o elegir después
///
/// Se usan en vez de `traducidos.map(…)`: sin optimizar (Debug, `swift test`), cada `traducidos.map` copia en la
/// pila del que llama los quince `TextosDeX` (decenas de KB), y un `switch` con un caso por texto guarda una
/// copia por caso. Con noventa casos, el marco pedía varios MB y desbordaba la pila en macOS. Aquí la copia es
/// una sola, en un marco que se suelta al volver.
public protocol TextosTraducidos: Sendable {
    /// Los textos en los quince idiomas.
    static var traducidos: Traducido<Self> { get }
}

extension TextosTraducidos {
    /// Un valor de los textos en los quince idiomas: `traduccion(\.campo)`, o `traduccion { $0.campo(n) }`.
    @inline(never)
    public static func traduccion<Valor>(_ campo: (Self) throws -> Valor) rethrows -> Traducido<Valor> {
        try traducidos.map(campo)
    }

    /// Un valor de los textos en el idioma de los textos de la notación: `en(notacion, \.campo)`.
    @inline(never)
    public static func en<Valor>(_ notacion: Notacion, _ campo: (Self) throws -> Valor) rethrows -> Valor {
        try campo(traducidos.en(notacion))
    }

    /// Un valor de los textos en un idioma: `en(idioma: .frances, \.campo)`.
    @inline(never)
    public static func en<Valor>(idioma: Idioma, _ campo: (Self) throws -> Valor) rethrows -> Valor {
        try campo(traducidos.texto(en: idioma))
    }
}

extension Traducido: Equatable where Valor: Equatable {}
extension Traducido: Hashable where Valor: Hashable {}
extension Traducido: Sendable where Valor: Sendable {}

/// Un texto en los quince idiomas en los que escribe el motor.
///
///     let t = Traduccion("consonancia perfecta", "perfect consonance",
///                        ca: "consonància perfecta", gl: "consonancia perfecta", ast: "consonancia perfeuta",
///                        an: "consonancia perfecta", eu: "kontsonantzia perfektua", pt: "consonância perfeita",
///                        fr: "consonance parfaite", oc: "consonància perfiècha", it: "consonanza perfetta",
///                        de: "vollkommene Konsonanz", el: "τέλεια συμφωνία", ru: "совершенный консонанс",
///                        hu: "tökéletes konszonancia")
///     t.en(.euskera)    // "kontsonantzia perfektua"
///     t.en(.aleman)     // "vollkommene Konsonanz"
public typealias Traduccion = Traducido<String>

extension String {
    /// Una plantilla de texto con `_` en el sitio de un valor: `"inversión _".rellenada(con: "7")` es
    /// "inversión 7". Sirve para que el valor vaya delante o detrás según el idioma.
    package func rellenada(con valor: String) -> String {
        split(separator: "_", omittingEmptySubsequences: false).joined(separator: valor)
    }

    /// El texto con el artículo húngaro delante: «az» si empieza por vocal o por una cifra que se lee con vocal
    /// (1 egy, 5 öt, 1000 ezer), y «a» si no: «a basszus», «az alt», «az 5. szólam», «a 3. szólam».
    package var conArticuloHungaro: String {
        let cifras = prefix(while: \.isNumber)
        let conVocal: Bool
        if let primera = cifras.first {
            // 1 (egy) y 1000–1999 (ezer) llevan «az»; 10–19 (tíz…) y 100–199 (száz…), no.
            conVocal = primera == "5" || (primera == "1" && (cifras.count == 1 || cifras.count == 4))
        } else {
            conVocal = first.map { "aáeéiíoóöőuúüűAÁEÉIÍOÓÖŐUÚÜŰ".contains($0) } ?? false
        }
        return (conVocal ? "az " : "a ") + self
    }
}
