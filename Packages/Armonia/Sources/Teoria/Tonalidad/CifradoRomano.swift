import Elementos

// MARK: - CifradoRomano

/// Un cifrado romano por sus partes: el numeral (un grado con su alteración, el sustituto tritonal o una sexta
/// aumentada), la calidad del acorde, su inversión en cifras de bajo continuo y, tras la barra, el grado del que es
/// dominante, sensible o sustituto. Es lo que da el análisis (``AcordeAnalizado/romano``), y su texto
/// (`description`) es el de siempre: «V65/V», «♭VI», «viiø43», «subV7/ii», «Ger+6».
///
///     let analizado = Tonalidad(.do).analizar(Acorde("Re7/Do"), siguiente: Acorde("Sol"))
///     analizado.romano.numeral      // .grado(5, alteracion: 0, mayuscula: true)
///     analizado.romano.inversion    // 3
///     analizado.romano.destino?.description   // "V"
///     analizado.romano.description  // "V42/V"
public struct CifradoRomano: Hashable, Sendable, CustomStringConvertible {
    /// Lo que va delante de la calidad.
    public enum Numeral: Hashable, Sendable {
        /// Un grado (del 1 al 7) con la alteración de su fundamental respecto de la escala (en semitonos: −1 es
        /// ♭), en mayúsculas si la tríada es mayor o aumentada: ♭VII es `.grado(7, alteracion: -1, mayuscula: true)`.
        case grado(Int, alteracion: Int, mayuscula: Bool)
        /// «subV»: el sustituto tritonal de la dominante.
        case sustitutoTritonal
        /// «It+6», «Fr+6» o «Ger+6».
        case sextaAumentada(SextaAumentada)
    }

    /// Las tres sextas aumentadas, por su nombre.
    public enum SextaAumentada: String, Hashable, Sendable, CaseIterable {
        case italiana = "It+6"
        case francesa = "Fr+6"
        case alemana = "Ger+6"
    }

    public let numeral: Numeral
    /// La calidad tras el numeral, sin las cifras de la inversión, como la escribe el cifrado de acorde: «7», «ø7»,
    /// «°7», «maj7», «+», «(add6)»; vacío en una tríada mayor o menor.
    public let calidad: String
    /// 0 en estado fundamental; 1, 2 y 3, la 1.ª, 2.ª y 3.ª inversión.
    public let inversion: Int
    /// Las cifras de la inversión: «6» y «64» en las tríadas, «65», «43» y «42» en las cuatríadas (que dejan la
    /// séptima de la calidad) y, en los demás acordes, todos los intervalos sobre el bajo («643»). Vacío en estado
    /// fundamental.
    public let cifras: String
    /// Tras la barra, el grado del que el acorde es dominante, sensible o sustituto: el «V» de «V7/V». `nil` si no
    /// tiene.
    public var destino: CifradoRomano? { destinos.first }

    // Un array y no un opcional: un struct no puede guardarse a sí mismo de otra forma.
    private let destinos: [CifradoRomano]

    public init(
        _ numeral: Numeral, calidad: String = "", inversion: Int = 0, cifras: String = "",
        destino: CifradoRomano? = nil
    ) {
        self.numeral = numeral
        self.calidad = calidad
        self.inversion = inversion
        self.cifras = cifras
        self.destinos = destino.map { [$0] } ?? []
    }

    /// El grado del numeral (del 1 al 7), o `nil` si es un sustituto tritonal o una sexta aumentada.
    public var grado: Int? {
        if case .grado(let grado, _, _) = numeral { grado } else { nil }
    }

    /// Si el acorde tonicaliza otro grado: una dominante o una sensible secundaria, o un sustituto tritonal que no
    /// va a la tónica.
    public var esSecundario: Bool { destino != nil }

    /// «V65/V», «♭VI», «Ger+6».
    public var description: String {
        let delante: String
        switch numeral {
        case .grado(let grado, let alteracion, let mayuscula):
            let romano = CifradoRomano.romanos[modulo(grado - 1, 7)]
            delante = Alteracion(alteracion).simbolo + (mayuscula ? romano : romano.lowercased())
        case .sustitutoTritonal:
            delante = "subV"
        case .sextaAumentada(let sexta):
            delante = sexta.rawValue
        }
        // Las cifras de una cuatríada sustituyen al 7 de la calidad: «V7» en 1.ª inversión es «V65».
        let sufijo =
            ["65", "43", "42"].contains(cifras) && calidad.hasSuffix("7")
            ? String(calidad.dropLast()) + cifras : calidad + cifras
        return delante + sufijo + (destino.map { "/" + $0.description } ?? "")
    }

    static let romanos = ["I", "II", "III", "IV", "V", "VI", "VII"]
}

extension CifradoRomano: Codable {
    // Se codifica como su texto, que es lo que se lee y se escribe: «V65/V».
    public init(from decoder: any Decoder) throws {
        let texto = try decoder.singleValueContainer().decode(String.self)
        self = try CifradoRomano(leyendo: texto)
    }

    public func encode(to encoder: any Encoder) throws {
        var contenedor = encoder.singleValueContainer()
        try contenedor.encode(description)
    }
}
