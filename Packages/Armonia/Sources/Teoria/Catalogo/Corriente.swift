import Elementos

// MARK: - La corriente de un estilo

/// Una corriente dentro de un estilo occidental, con el año en que empieza: el bebop (1945) y el jazz modal (1959) en
/// el jazz; el impresionismo (1890) en las escalas de compositor; el rock (1955), el heavy metal (1970) y el metal
/// neoclásico (1984) en el pop y el rock. Precisa el estilo: el dórico es de jazz, y en el jazz, del modal, el de
/// «Kind of Blue». Una escala lleva sus corrientes en orden de importancia, como sus estilos, y cada corriente es de
/// uno de sus estilos.
///
///     TipoDeEscala.dorico.corrientes        // [.modal]
///     Corriente.modal.estilo                // .jazz
///     Corriente.modal.anio                  // 1959
public enum Corriente: String, Sendable, Codable, CaseIterable {
    case bebop, modal, impresionismo, rock, heavyMetal, metalNeoclasico

    /// El estilo del que es corriente. El `switch` no tiene `default`: una corriente nueva no compila sin el suyo.
    public var estilo: Estilo {
        switch self {
        case .bebop, .modal: .jazz
        case .impresionismo: .deCompositor
        case .rock, .heavyMetal, .metalNeoclasico: .popRock
        }
    }

    /// El año en que empieza, aproximado: el bebop, con Parker y Gillespie hacia 1945; el jazz modal, «Kind of Blue»
    /// de Miles Davis (1959); el impresionismo, Debussy hacia 1890; el rock, hacia 1955; el heavy metal, el primer
    /// disco de Black Sabbath (1970); el metal neoclásico, «Rising Force» de Yngwie Malmsteen (1984).
    public var anio: Int {
        switch self {
        case .bebop: 1945
        case .modal: 1959
        case .impresionismo: 1890
        case .rock: 1955
        case .heavyMetal: 1970
        case .metalNeoclasico: 1984
        }
    }

    /// El año en que deja de ser una corriente viva, o `nil` si se sigue tocando: el impresionismo, hacia 1930.
    public var fin: Int? {
        switch self {
        case .impresionismo: 1930
        case .bebop, .modal, .rock, .heavyMetal, .metalNeoclasico: nil
        }
    }

    /// Las épocas en que se usa, de la de su año a la de su fin (o hasta hoy, el siglo XXI), en orden: el
    /// impresionismo, el Romanticismo y el siglo XX; el bebop, el siglo XX y el XXI.
    public var epocasDeUso: [Epoca] {
        let desde = Epoca(anio: anio)
        let hasta = fin.map { Epoca(anio: $0) } ?? .sigloXXI
        return Epoca.allCases.filter { desde <= $0 && $0 <= hasta }
    }

    /// Las escalas del catálogo de esta corriente, en el orden de `TipoDeEscala.occidentales`.
    public var tipos: [TipoDeEscala] { TipoDeEscala.occidentales.filter { $0.corrientes.contains(self) } }

    /// El nombre en el idioma de los textos de la notación: «jazz modal», «modal jazz», «модальный джаз». En español,
    /// también `nombre` (de `Nombrable`).
    public func nombre(en notacion: Notacion) -> String { traduccion.en(notacion) }

    /// El nombre en los trece idiomas, de los `TextosDeTeoria`.
    private var traduccion: Traduccion {
        switch self {
        case .bebop: TextosDeTeoria.traduccion(\.corrienteBebop)
        case .modal: TextosDeTeoria.traduccion(\.corrienteModal)
        case .impresionismo: TextosDeTeoria.traduccion(\.corrienteImpresionismo)
        case .rock: TextosDeTeoria.traduccion(\.corrienteRock)
        case .heavyMetal: TextosDeTeoria.traduccion(\.corrienteHeavyMetal)
        case .metalNeoclasico: TextosDeTeoria.traduccion(\.corrienteMetalNeoclasico)
        }
    }
}

extension Corriente: Nombrable {}

extension Estilo {
    /// Sus corrientes, en el orden de `Corriente.allCases`: el bebop y el modal en el jazz; vacío si no tiene.
    public var corrientes: [Corriente] { Corriente.allCases.filter { $0.estilo == self } }
}

extension TipoDeEscala {
    /// Las corrientes en que se usa la escala, de más a menos importante: `[.modal]` en el dórico, `[.heavyMetal,
    /// .metalNeoclasico]` en el frigio dominante. Cada una es de uno de sus estilos. Vacío si no tiene; se busca por
    /// su `identidad`, como los estilos.
    public var corrientes: [Corriente] { fichaDelCatalogo.corrientes }

    /// Las épocas de uso de uno de sus estilos: las de sus corrientes de ese estilo, si las tiene, y si no, las del
    /// estilo (`Estilo.epocasDeUso`). La escala de tonos enteros, por el impresionismo, se usa ya en el Romanticismo.
    func epocasDeUso(de estilo: Estilo) -> [Epoca] {
        let suyas = corrientes.filter { $0.estilo == estilo }
        guard !suyas.isEmpty else { return estilo.epocasDeUso }
        return Epoca.allCases.filter { epoca in suyas.contains { $0.epocasDeUso.contains(epoca) } }
    }
}
