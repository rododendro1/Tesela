// MARK: - Ficha de una tradición

/// Lo que el catálogo sabe de las escalas de una tradición además de sus intervalos: qué categoría tiene cada una de
/// sus listas (los thāṭ, los mēḷa…), la versión microtonal de las que la tienen y, de los rāgas janya, su mēḷa.
///
/// Cada fichero de `Tradiciones/` acaba con la ficha de su tradición, junto a sus escalas, y de las fichas salen
/// `TipoDeEscala.categoria`, `tradicion`, `padre` y `microtonal`, y `TipoDeEscalaMicrotonal.catalogo`. Las escalas
/// se nombran por su miembro de `TipoDeEscala`: si una se renombra o se quita, no compila.
struct FichaDeTradicion: Sendable {
    /// Una lista de escalas de la tradición y la categoría de todas ellas.
    struct Lista: Sendable {
        let categoria: CategoriaTradicional
        let tipos: [TipoDeEscala]

        init(_ categoria: CategoriaTradicional, _ tipos: [TipoDeEscala]) {
            self.categoria = categoria
            self.tipos = tipos
        }
    }

    /// Un rāga janya y el número del mēḷa del que deriva.
    struct Padre: Sendable {
        let janya: TipoDeEscala
        let mela: Int

        init(_ janya: TipoDeEscala, mela: Int) {
            self.janya = janya
            self.mela = mela
        }
    }

    let tradicion: Tradicion
    let listas: [Lista]
    /// Las versiones microtonales de las escalas de la tradición que la tienen.
    let microtonales: [TipoDeEscalaMicrotonal]
    /// El mēḷa de cada janya (solo en la India).
    let padres: [Padre]

    init(
        _ tradicion: Tradicion, _ listas: [Lista], microtonales: [TipoDeEscalaMicrotonal] = [], padres: [Padre] = []
    ) {
        self.tradicion = tradicion
        self.listas = listas
        self.microtonales = microtonales
        self.padres = padres
    }

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
