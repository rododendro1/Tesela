// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

import ArmoniaNucleo

extension ModoDeEscala {
    /// El nombre de antes de `grado`.
    @available(*, deprecated, renamed: "grado")
    public var modo: Int { grado }
}

extension TipoDeEscala {
    /// Lo de antes de `cromatica(ventana:)`, con la primera nota de la ventana en pasos de quinta desde la tónica.
    @available(*, deprecated, message: "usa cromatica(ventana:) con VentanaDeQuintas(inicio:), .bemoles o .sostenidos")
    public static func cromatica(desdeLaQuinta primera: Int) -> TipoDeEscala {
        cromatica(ventana: VentanaDeQuintas(inicio: primera))
    }
}
