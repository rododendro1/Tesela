import Elementos

// MARK: - La escuela de una escala de otra tradición

/// Una escuela o repertorio dentro de una tradición que no es la occidental: en la India, la música carnática (del
/// sur), la indostánica (del norte) y la del Nāṭyaśāstra; en Japón, el gagaku, la música de la corte. Es lo que en la
/// occidental es un ``Estilo``.
///
///     TipoDeEscala.kafi.escuelas        // [.indostanica]
///     Escuela.gagaku.tradicion          // .japon
public enum Escuela: String, Sendable, Codable, CaseIterable {
    case carnatica, indostanica, indiaAntigua, gagaku

    /// La tradición a la que pertenece. El `switch` no tiene `default`: una escuela nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .carnatica, .indostanica, .indiaAntigua: .india
        case .gagaku: .japon
        }
    }

    /// La que da una categoría por sí sola: los mēḷa y los janya son carnáticos, los thāṭ y los rāgas indostánicos, y
    /// los grāma y las mūrchanā, del Nāṭyaśāstra. `nil` en las demás categorías.
    public static func de(_ categoria: CategoriaTradicional) -> Escuela? {
        switch categoria {
        case .melakarta, .janya: .carnatica
        case .thaat, .raga: .indostanica
        case .grama, .murchana: .indiaAntigua
        default: nil
        }
    }

    /// Las escalas del catálogo de esta escuela, en el orden de `TipoDeEscala.tradicionales`.
    public var tipos: [TipoDeEscala] { TipoDeEscala.tradicionales.filter { $0.escuelas.contains(self) } }

    /// El nombre en el idioma de los textos de la notación: «Carnática», «Carnatic», «Καρνατική». En español, también
    /// `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .carnatica: TextosDeTeoria.traduccion(\.subtradicionCarnatica)
        case .indostanica: TextosDeTeoria.traduccion(\.subtradicionIndostanica)
        case .indiaAntigua: TextosDeTeoria.traduccion(\.subtradicionIndiaAntigua)
        case .gagaku: TextosDeTeoria.traduccion(\.subtradicionGagaku)
        }
    }
}

extension Escuela: Nombrable {}
