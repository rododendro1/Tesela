import ArmoniaNucleo
import Hexagonos

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

/// El nombre de antes de `ErrorDeLecturaDeUIL`.
@available(*, deprecated, renamed: "ErrorDeLecturaDeUIL")
public typealias ErrorDeUIL = ErrorDeLecturaDeUIL

extension OpcionesDeDiagrama {
    /// Si las notas se nombran con bemoles: `ventana == .bemoles`. Ponerlo a `true` elige `.bemoles`; a `false`,
    /// `.sostenidos`.
    @available(*, deprecated, message: "usa ventana: .bemoles o .sostenidos")
    public var preferirBemoles: Bool {
        get { ventana == .bemoles }
        set { ventana = newValue ? .bemoles : .sostenidos }
    }

    /// El inicializador de antes, con `preferirBemoles` en lugar de `ventana`.
    @available(*, deprecated, message: "usa init(notacion:ventana:nombresDeLasNotas:titulo:escala:)")
    public init(
        notacion: Notacion = .espanolCompacto, preferirBemoles: Bool, nombresDeLasNotas: Bool = true,
        titulo: String? = nil, escala: Double = 1
    ) {
        self.init(
            notacion: notacion, ventana: preferirBemoles ? .bemoles : .sostenidos,
            nombresDeLasNotas: nombresDeLasNotas, titulo: titulo, escala: escala)
    }
}

extension TecladoCuadrado {
    /// Con sostenidos, o con bemoles si `preferirBemoles`.
    @available(*, deprecated, message: "usa altura(en:ventana:) con .bemoles o .sostenidos")
    public func altura(en casilla: CasillaCuadrada, preferirBemoles: Bool) -> Altura {
        altura(en: casilla, ventana: preferirBemoles ? .bemoles : .sostenidos)
    }
}

extension TecladoIsomorfico {
    /// Con sostenidos, o con bemoles si `preferirBemoles`.
    @available(*, deprecated, message: "usa altura(en:ventana:) con .bemoles o .sostenidos")
    public func altura(en casilla: CoordenadaAxial, preferirBemoles: Bool) -> Altura {
        altura(en: casilla, ventana: preferirBemoles ? .bemoles : .sostenidos)
    }
}

/// El nombre de antes de `RelojDeClasesDeAltura`.
@available(*, deprecated, renamed: "RelojDeClasesDeAltura")
public typealias RelojDeClases = RelojDeClasesDeAltura
