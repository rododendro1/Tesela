// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

/// El nombre de antes de ``ConjuntoDeClasesDeAltura``.
@available(*, deprecated, renamed: "ConjuntoDeClasesDeAltura")
public typealias ConjuntoDeClases = ConjuntoDeClasesDeAltura

extension ConClasesDeAltura {
    /// El nombre de antes de `conjuntoDeClasesDeAltura`.
    @available(*, deprecated, renamed: "conjuntoDeClasesDeAltura")
    public var conjuntoDeClases: ConjuntoDeClasesDeAltura { conjuntoDeClasesDeAltura }
}

/// El nombre de antes de `SistemaDeAfinacion`.
@available(*, deprecated, renamed: "SistemaDeAfinacion")
public typealias Afinacion = SistemaDeAfinacion
