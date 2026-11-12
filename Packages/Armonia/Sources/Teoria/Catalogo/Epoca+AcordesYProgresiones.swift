import Elementos

// MARK: - La época de los acordes y las progresiones del catálogo
//
// Como en las escalas (`TipoDeEscala.epocaDeOrigen`), no se escribe: la de origen sale del año de la obra que lo
// documenta (`documentada`) o, si no la tiene, de la más antigua de las de uso de sus estilos; las de uso, de sus
// estilos. El acorde de Tristán es del Romanticismo por Wagner (1859), aunque sea de la música clásica; la sexta
// aumentada alemana, del Barroco por su estilo; el monte, del Clasicismo por Riepel (1755).

extension FichaDelCatalogo {
    /// El año de la obra que lo documenta, si la tiene.
    var anioDeOrigen: Int? { documentada?.anio }

    /// La de su año, o si no la más antigua de las de uso de sus estilos; `nil` si ninguna da nada.
    var epocaDeOrigen: Epoca? {
        if let anio = anioDeOrigen { return Epoca(anio: anio) }
        return estilos.flatMap(\.epocasDeUso).min()
    }

    /// Las de uso de sus estilos, en orden, sin la de origen ni las anteriores a ella.
    var epocasDeUso: [Epoca] {
        let origen = epocaDeOrigen
        return Epoca.allCases.filter { epoca in
            epoca != origen && (origen.map { $0 < epoca } ?? true) && estilos.contains { $0.epocasDeUso.contains(epoca) }
        }
    }

    /// La de origen y las de uso, en orden.
    var epocas: [Epoca] { ([epocaDeOrigen].compactMap { $0 } + epocasDeUso).sorted() }
}

extension AcordeConNombre {
    /// El año en que aparece, el de la obra que lo documenta (`documentada`), si se sabe.
    ///
    ///     AcordeConNombre.tristan.anioDeOrigen   // 1859
    public var anioDeOrigen: Int? { ficha.anioDeOrigen }

    /// La época en que aparece: la de su año (`anioDeOrigen`) o, si no se sabe, la más antigua de las de uso de sus
    /// estilos (`Estilo.epocasDeUso`). `nil` si no tiene ni año ni estilos con épocas.
    ///
    ///     AcordeConNombre.tristan.epocaDeOrigen          // .romanticismo (Wagner, 1859)
    ///     AcordeConNombre.sextaAumentadaAlemana.epocaDeOrigen   // .barroco (de la música clásica)
    public var epocaDeOrigen: Epoca? { ficha.epocaDeOrigen }

    /// Las épocas en que se usa por sus estilos, en orden, después de la de origen.
    public var epocasDeUso: [Epoca] { ficha.epocasDeUso }

    /// La de origen y las de uso, en orden.
    public var epocas: [Epoca] { ficha.epocas }
}

extension ProgresionConNombre {
    /// El año en que aparece, el de la obra que la documenta (`documentada`), si se sabe.
    ///
    ///     ProgresionConNombre.monte.anioDeOrigen   // 1755
    public var anioDeOrigen: Int? { ficha.anioDeOrigen }

    /// La época en que aparece: la de su año (`anioDeOrigen`) o, si no se sabe, la más antigua de las de uso de sus
    /// estilos (`Estilo.epocasDeUso`). `nil` si no tiene ni año ni estilos con épocas.
    ///
    ///     ProgresionConNombre.folia.epocaDeOrigen   // .renacimiento (Ortiz, 1553)
    ///     ProgresionConNombre.iiVI.epocaDeOrigen    // .sigloXX (del jazz)
    public var epocaDeOrigen: Epoca? { ficha.epocaDeOrigen }

    /// Las épocas en que se usa por sus estilos, en orden, después de la de origen.
    public var epocasDeUso: [Epoca] { ficha.epocasDeUso }

    /// La de origen y las de uso, en orden.
    public var epocas: [Epoca] { ficha.epocas }
}
