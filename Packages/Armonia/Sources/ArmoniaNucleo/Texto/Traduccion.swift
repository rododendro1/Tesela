// MARK: - Traducción
//
// Los textos del motor que no son nombres de nota (mensajes de error, nombres de intervalos, de
// papeles en el acorde, de grados, de claves, de figuras, de cadencias…) se escriben en los catorce
// idiomas de las notaciones: español, inglés, catalán, gallego, asturiano, aragonés, euskera, portugués,
// francés, occitano, italiano, alemán, griego y ruso.
//
// Los textos se escriben un idioma por fichero: cada módulo tiene su `TextosDeX` (`TextosDeNucleo`,
// `TextosDeTrastes`…) con un campo por texto, y un fichero por idioma en su carpeta `Textos/`
// (`TextosDeNucleo+Espanol.swift`, `…+Ingles.swift`…). Los campos no tienen valores por omisión, así que un
// texto nuevo no compila hasta que está en los catorce ficheros. `TextosDeX.traducidos.map(\.campo)` da
// el `Traduccion` de un campo, y `traducidos.map { $0.campo(valor) }` el de un texto que lleva valores.
//
// Los nombres de los catálogos (tipos de acorde y de escala, instrumentos) también están en los catorce idiomas, salvo los nombres tradicionales de escala
// (raga, maqam, pentatónicas japonesas…), que se escriben igual en todos.

/// Un valor en cada uno de los catorce idiomas en los que escribe el motor: un texto, una lista de textos…
///
///     let ordinales = Traducido<[String]>(["primera", "segunda"], ["first", "second"],
///                                         ca: ["primera", "segona"], …, ru: ["первая", "вторая"])
///     ordinales.en(.catalan)[1]    // "segona"
///
/// Como en ``Traduccion``, los catorce valores son obligatorios y van en el mismo orden, así que una lista por
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

    public init(_ espanol: Valor, _ ingles: Valor, ca catalan: Valor, gl gallego: Valor, ast asturiano: Valor,
                an aragones: Valor, eu euskera: Valor, pt portugues: Valor, fr frances: Valor, oc occitano: Valor,
                it italiano: Valor, de aleman: Valor, el griego: Valor, ru ruso: Valor) {
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
    }

    /// Los catorce valores, en el orden del inicializador.
    package var todos: [Valor] {
        [espanol, ingles, catalan, gallego, asturiano, aragones, euskera, portugues, frances, occitano, italiano,
         aleman, griego, ruso]
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
        }
    }

    /// El mismo cambio en los catorce idiomas.
    public func map<Otro>(_ cambio: (Valor) throws -> Otro) rethrows -> Traducido<Otro> {
        Traducido<Otro>(try cambio(espanol), try cambio(ingles), ca: try cambio(catalan), gl: try cambio(gallego),
                        ast: try cambio(asturiano), an: try cambio(aragones), eu: try cambio(euskera),
                        pt: try cambio(portugues), fr: try cambio(frances), oc: try cambio(occitano),
                        it: try cambio(italiano), de: try cambio(aleman),
                        el: try cambio(griego), ru: try cambio(ruso))
    }
}

extension Traducido: Equatable where Valor: Equatable {}
extension Traducido: Hashable where Valor: Hashable {}
extension Traducido: Sendable where Valor: Sendable {}

/// Un texto en los catorce idiomas en los que escribe el motor.
///
///     let t = Traduccion("consonancia perfecta", "perfect consonance",
///                        ca: "consonància perfecta", gl: "consonancia perfecta", ast: "consonancia perfeuta",
///                        an: "consonancia perfecta", eu: "kontsonantzia perfektua", pt: "consonância perfeita",
///                        fr: "consonance parfaite", oc: "consonància perfiècha", it: "consonanza perfetta",
///                        de: "vollkommene Konsonanz", el: "τέλεια συμφωνία", ru: "совершенный консонанс")
///     t.en(.euskera)    // "kontsonantzia perfektua"
///     t.en(.aleman)     // "vollkommene Konsonanz"
public typealias Traduccion = Traducido<String>

extension String {
    /// Una plantilla de texto con `_` en el sitio de un valor: `"inversión _".rellenada(con: "7")` es
    /// "inversión 7". Sirve para que el valor vaya delante o detrás según el idioma.
    package func rellenada(con valor: String) -> String {
        split(separator: "_", omittingEmptySubsequences: false).joined(separator: valor)
    }
}

extension Traduccion {
    /// El plural ruso de un número: "1 полутон", "3 полутона", "5 полутонов", "21 полутон".
    public static func pluralRuso(_ n: Int, _ uno: String, _ pocos: String, _ muchos: String) -> String {
        let (decena, unidad) = (abs(n) % 100, abs(n) % 10)
        if (11...14).contains(decena) { return "\(n) \(muchos)" }
        switch unidad {
        case 1: return "\(n) \(uno)"
        case 2...4: return "\(n) \(pocos)"
        default: return "\(n) \(muchos)"
        }
    }
}

extension Idioma {
    /// Idiomas en los que el motor escribe sus textos: todos, en el orden del selector de las apps.
    public static let traducidos: [Idioma] = [.espanol, .ingles, .catalan, .gallego, .asturiano, .aragones,
                                              .euskera, .portugues, .frances, .occitano, .italiano, .aleman,
                                              .griego, .ruso]
}
