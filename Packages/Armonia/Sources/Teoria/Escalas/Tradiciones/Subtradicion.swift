import Elementos

// MARK: - Subtradición de una escala

/// Una tradición dentro de una `Tradicion`: la música carnática o la indostánica en la India, Java o Bali en
/// Indonesia, el país o el pueblo de una escala de África, de Europa o del sudeste asiático, el gagaku o las islas
/// Ryūkyū en Japón.
///
/// Cada caso sabe de qué tradición es (`tradicion`). Una escala la lleva en su declaración (`subtradicion: .bali`),
/// salvo las de la India, a las que se la da su categoría (`Subtradicion.de(_:)`). Las que no tienen una clara (el
/// sléndro, que se toca en Java y en Bali, o las escalas chinas) no la llevan, y los teóricos (Aristóxeno, Ptolomeo,
/// Glareano) no son subtradiciones: son la `fuente` de la escala (`FuenteTeorica`).
public enum Subtradicion: String, Sendable, Codable, CaseIterable {
    /// India: la música carnática (del sur), la indostánica (del norte) y la del Nāṭyaśāstra (grāma y mūrchanā).
    case carnatica, indostanica, indiaAntigua
    /// Indonesia: los gamelan de Java, de Bali y de Sunda (el oeste de Java).
    case java, bali, sunda
    /// Sudeste asiático: los conjuntos piphat de Tailandia y pinpeat de Camboya, y el arpa de Birmania.
    case tailandia, camboya, birmania
    /// África: el amadinda de Buganda (Uganda), el timbila de los chopi (Mozambique), la kora mandinga y la mbira
    /// de los shona (Zimbabue).
    case buganda, chopi, mandinga, shona
    /// Europa: el país o la región de cada escala popular.
    case ucrania, polonia, hungria, alpes, escocia, georgia, istria
    /// Japón: la música cortesana (gagaku) y la de Okinawa (Ryūkyū).
    case gagaku, ryukyu

    /// La tradición a la que pertenece. El `switch` no tiene `default`: una subtradición nueva no compila sin la suya.
    public var tradicion: Tradicion {
        switch self {
        case .carnatica, .indostanica, .indiaAntigua: .india
        case .java, .bali, .sunda: .indonesia
        case .tailandia, .camboya, .birmania: .sudesteAsiatico
        case .buganda, .chopi, .mandinga, .shona: .africa
        case .ucrania, .polonia, .hungria, .alpes, .escocia, .georgia, .istria: .europa
        case .gagaku, .ryukyu: .japon
        }
    }

    /// La que da una categoría por sí sola: los mēḷa y los janya son carnáticos, los thāṭ y los rāgas indostánicos,
    /// y los grāma y las mūrchanā, del Nāṭyaśāstra. `nil` en las demás categorías.
    public static func de(_ categoria: CategoriaTradicional) -> Subtradicion? {
        switch categoria {
        case .melakarta, .janya: .carnatica
        case .thaat, .raga: .indostanica
        case .grama, .murchana: .indiaAntigua
        default: nil
        }
    }

    /// El nombre en el idioma de los textos de la notación: «Carnática», «Carnatic», «Karnatikoa», «Καρνατική».
    /// En español, también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los doce idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .carnatica: TextosDeTeoria.traduccion(\.subtradicionCarnatica)
        case .indostanica: TextosDeTeoria.traduccion(\.subtradicionIndostanica)
        case .indiaAntigua: TextosDeTeoria.traduccion(\.subtradicionIndiaAntigua)
        case .java: TextosDeTeoria.traduccion(\.subtradicionJava)
        case .bali: TextosDeTeoria.traduccion(\.subtradicionBali)
        case .sunda: TextosDeTeoria.traduccion(\.subtradicionSunda)
        case .tailandia: TextosDeTeoria.traduccion(\.subtradicionTailandia)
        case .camboya: TextosDeTeoria.traduccion(\.subtradicionCamboya)
        case .birmania: TextosDeTeoria.traduccion(\.subtradicionBirmania)
        case .buganda: TextosDeTeoria.traduccion(\.subtradicionBuganda)
        case .chopi: TextosDeTeoria.traduccion(\.subtradicionChopi)
        case .mandinga: TextosDeTeoria.traduccion(\.subtradicionMandinga)
        case .shona: TextosDeTeoria.traduccion(\.subtradicionShona)
        case .ucrania: TextosDeTeoria.traduccion(\.subtradicionUcrania)
        case .polonia: TextosDeTeoria.traduccion(\.subtradicionPolonia)
        case .hungria: TextosDeTeoria.traduccion(\.subtradicionHungria)
        case .alpes: TextosDeTeoria.traduccion(\.subtradicionAlpes)
        case .escocia: TextosDeTeoria.traduccion(\.subtradicionEscocia)
        case .georgia: TextosDeTeoria.traduccion(\.subtradicionGeorgia)
        case .istria: TextosDeTeoria.traduccion(\.subtradicionIstria)
        case .gagaku: TextosDeTeoria.traduccion(\.subtradicionGagaku)
        case .ryukyu: TextosDeTeoria.traduccion(\.subtradicionRyukyu)
        }
    }
}

extension Subtradicion: Nombrable {}

extension TipoDeEscala {
    /// La subtradición de la escala dentro de su tradición (`.carnatica`, `.bali`, `.escocia`…); `nil` en las
    /// occidentales, en las propias y en las de otras tradiciones que no tienen una clara. Como `categoria`, por su
    /// identidad.
    ///
    ///     TipoDeEscala.mohanam.subtradicion        // .carnatica
    ///     TipoDeEscala.pelogTembung.subtradicion   // .bali
    public var subtradicion: Subtradicion? { fichaDelCatalogo.subtradicion }

    /// Las escalas de otras tradiciones de una subtradición: `tradicionales(subtradicion: .java)` da los pathet de
    /// Java.
    public static func tradicionales(subtradicion: Subtradicion) -> [TipoDeEscala] {
        tradicionales.filter { $0.subtradicion == subtradicion }
    }
}
