import Elementos

// MARK: - La época de los elementos del catálogo
//
// Como en las escalas (`TipoDeEscala.epocaDeOrigen`), no se escribe: la de origen sale del año de la obra que lo
// documenta (`documentada`), del año que da el catálogo (un temperamento, un diapasón) o, si no lo tiene, de la más
// antigua de las de uso de sus estilos; las de uso, de sus estilos. Así en los acordes, las progresiones, los ritmos,
// los temperamentos, las notas y las funciones con nombre. El acorde de Tristán es del Romanticismo por Wagner (1859),
// aunque sea de la música clásica; la sexta aumentada alemana, del Barroco por su estilo; el monte, del Clasicismo por
// Riepel (1755).

extension AcordeConNombre {
    /// El año en que aparece, el de la obra que lo documenta (`documentada`), si se sabe.
    ///
    ///     AcordeConNombre.tristan.anioDeOrigen   // 1859
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece: la de su año (`anioDeOrigen`) o, si no se sabe, la más antigua de las de uso de sus
    /// estilos (`Estilo.epocasDeUso`). `nil` si no tiene ni año ni estilos con épocas.
    ///
    ///     AcordeConNombre.tristan.epocaDeOrigen          // .romanticismo (Wagner, 1859)
    ///     AcordeConNombre.sextaAumentadaAlemana.epocaDeOrigen   // .barroco (de la música clásica)
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }

    /// Las épocas en que se usa por sus estilos, en orden, después de la de origen.
    public var epocasDeUso: [Epoca] { datos.epocasDeUso }

    /// La de origen y las de uso, en orden.
    public var epocas: [Epoca] { datos.epocas }
}

extension ProgresionConNombre {
    /// El año en que aparece, el de la obra que la documenta (`documentada`), si se sabe.
    ///
    ///     ProgresionConNombre.monte.anioDeOrigen   // 1755
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece: la de su año (`anioDeOrigen`) o, si no se sabe, la más antigua de las de uso de sus
    /// estilos (`Estilo.epocasDeUso`). `nil` si no tiene ni año ni estilos con épocas.
    ///
    ///     ProgresionConNombre.folia.epocaDeOrigen   // .renacimiento (Ortiz, 1553)
    ///     ProgresionConNombre.iiVI.epocaDeOrigen    // .sigloXX (del jazz)
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }

    /// Las épocas en que se usa por sus estilos, en orden, después de la de origen.
    public var epocasDeUso: [Epoca] { datos.epocasDeUso }

    /// La de origen y las de uso, en orden.
    public var epocas: [Epoca] { datos.epocas }
}

extension RitmoConNombre {
    /// La obra más antigua que da el ritmo, con su año; `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// El año en que aparece, si se sabe: el de los modos rítmicos de Garlandia (hacia 1250), el del charleston (1923).
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece: la de su año (`anioDeOrigen`) o, si no se sabe, la más antigua de las de uso de sus
    /// estilos (`Estilo.epocasDeUso`). `nil` si no tiene ni año ni estilos con épocas.
    ///
    ///     RitmoConNombre.primerModoRitmico.epocaDeOrigen   // .edadMedia
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }

    /// Las épocas en que se usa por sus estilos, en orden, después de la de origen.
    public var epocasDeUso: [Epoca] { datos.epocasDeUso }

    /// La de origen y las de uso, en orden.
    public var epocas: [Epoca] { datos.epocas }
}

extension TemperamentoConNombre {
    /// La obra más antigua que da el temperamento, con su año; `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// El año en que se publicó, o hacia el que se usaba: 1691 en Werckmeister III; `nil` si no se sabe.
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece, la de su año (`anioDeOrigen`); `nil` si no se sabe.
    ///
    ///     TemperamentoConNombre.werckmeisterIII.epocaDeOrigen          // .barroco (1691)
    ///     TemperamentoConNombre.mesotonicoCuartoDeComa.epocaDeOrigen   // .renacimiento (Aron, 1523)
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }
}

extension NotaConNombre {
    /// La obra más antigua que da la nota, con su año; `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// El año en que se fijó, en los diapasones que tienen uno: 1939 en el La 440; `nil` si no se sabe.
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece, la de su año (`anioDeOrigen`); `nil` si no se sabe.
    ///
    ///     NotaConNombre.la440.epocaDeOrigen   // .sigloXX (1939)
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }
}

extension FuncionDeNota {
    /// La obra más antigua que da la función, con su año; `nil` si no se sabe.
    public var documentada: Referencia? { datos.documentada }

    /// El año en que aparece, el de la obra que la documenta (`documentada`), si se sabe.
    public var anioDeOrigen: Int? { datos.anioDeOrigen }

    /// La época en que aparece, la de su año (`anioDeOrigen`); `nil` si no se sabe.
    public var epocaDeOrigen: Epoca? { datos.epocaDeOrigen }
}
