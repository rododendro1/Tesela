import Elementos

// MARK: - El afecto medido
//
// Una tercera clase de dato, aparte del carácter de una tradición (`Caracter`) y de la sonoridad que calcula Tesela
// (`Sonoridad`): lo que mide un estudio con oyentes. Temperley y Tan (2013) tocaron a no músicos la misma melodía en
// dos modos y les preguntaron cuál era la más alegre, con todos los pares de seis modos de la mayor (sin el locrio).
// El dato es la proporción de las comparaciones en que se eligió cada modo (su figura 10, en la página 248). El jónico
// es el más alegre, y el lidio, aunque es el más claro por quintas, sale por debajo del mixolidio.

/// Lo que mide un estudio con oyentes del afecto de una escala: en Temperley y Tan (2013), la proporción de las
/// comparaciones en que se oyó como la más alegre de dos.
///
///     TipoDeEscala.mayor.medidasDelAfecto[0].proporcion   // 0.83
///     TipoDeEscala.frigio.medidasDelAfecto[0].afecto      // .alegre
///     TipoDeEscala.locrio.medidasDelAfecto                // []
public struct MedidaDelAfecto: Hashable, Sendable {
    /// Lo que se preguntó: si sonaba alegre.
    public let afecto: Afecto
    /// De 0 a 1: la proporción de las comparaciones en que se eligió por ese afecto.
    public let proporcion: Double
    /// El estudio, con la página de la medida.
    public let referencia: Referencia

    package init(_ afecto: Afecto, _ proporcion: Double, referencia: Referencia) {
        self.afecto = afecto
        self.proporcion = proporcion
        self.referencia = referencia
    }

    /// La proporción en tanto por ciento y el afecto, en una línea: «alegre: 83 %».
    public func descripcion(en notacion: Notacion) -> String {
        afecto.nombre(en: notacion) + ": " + String(Int((proporcion * 100).rounded())) + " %"
    }
}

extension TipoDeEscala {
    /// Cada modo con lo que mide de él un estudio.
    package static let medidas: [(tipo: TipoDeEscala, medidas: [MedidaDelAfecto])] = {
        let figura10 = Referencia.temperleyTan2013.paginas("248")
        let proporciones: [(TipoDeEscala, Double)] = [
            (.mayor, 0.83), (.mixolidio, 0.64), (.lidio, 0.58), (.dorico, 0.40), (.menorNatural, 0.34),
            (.frigio, 0.21),
        ]
        return proporciones.map { ($0.0, [MedidaDelAfecto(.alegre, $0.1, referencia: figura10)]) }
    }()

    /// Identidad → lo que miden sus estudios.
    package static let medidasPorIdentidad: [IdentidadDeEscala: [MedidaDelAfecto]] = {
        var tabla: [IdentidadDeEscala: [MedidaDelAfecto]] = [:]
        for (tipo, suyas) in medidas { tabla[tipo.identidad, default: []] += suyas }
        return tabla
    }()

    /// Lo que miden del afecto de la escala los estudios con oyentes; vacío si no la ha medido ninguno. Va por su
    /// identidad, como el carácter: la mayor tiene la suya y Bilāval, con las mismas notas, ninguna.
    public var medidasDelAfecto: [MedidaDelAfecto] { TipoDeEscala.medidasPorIdentidad[identidad] ?? [] }
}
