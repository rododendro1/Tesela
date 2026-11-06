// MARK: - Ficha de una tradición

/// Las escalas de una tradición, en sus listas (los thāṭ, los mēḷa…) y en el orden en que tienen prioridad.
///
/// Cada fichero de `Tradiciones/` acaba con la ficha de su tradición, junto a sus escalas, y de las fichas sale
/// `TipoDeEscala.tradicion`. Lo demás de cada escala (su categoría, su versión microtonal y, de los rāgas janya, su
/// mēḷa) va en su declaración (`FichaDeEscala`). Las listas se nombran por su miembro de `TipoDeEscala`: si una se
/// renombra o se quita, no compila.
struct FichaDeTradicion: Sendable {
    let tradicion: Tradicion
    let listas: [[TipoDeEscala]]

    init(_ tradicion: Tradicion, _ listas: [[TipoDeEscala]]) {
        self.tradicion = tradicion
        self.listas = listas
    }

    /// Las escalas de la tradición, lista tras lista.
    var tipos: [TipoDeEscala] { listas.flatMap { $0 } }

    /// Las fichas de todas las tradiciones, en el orden de `Tradicion.allCases`.
    static let todas: [FichaDeTradicion] = Tradicion.allCases.map(\.ficha)
}

extension Tradicion {
    /// La ficha de la tradición. El `switch` no tiene `default`: una tradición nueva sin ficha no compila.
    var ficha: FichaDeTradicion {
        switch self {
        case .india: .india
        case .grecia: .grecia
        case .greciaAntigua: .greciaAntigua
        case .mundoArabe: .mundoArabe
        case .persia: .persia
        case .turquia: .turquia
        case .azerbaiyan: .azerbaiyan
        case .china: .china
        case .japon: .japon
        case .corea: .corea
        case .etiopia: .etiopia
        case .indonesia: .indonesia
        case .klezmer: .klezmer
        case .andes: .andes
        case .bizancio: .bizancio
        case .mesopotamia: .mesopotamia
        case .africa: .africa
        case .sudesteAsiatico: .sudesteAsiatico
        case .gregoriano: .gregoriano
        case .europa: .europa
        case .vietnam: .vietnam
        case .brasil: .brasil
        }
    }
}
