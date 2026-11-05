import ArmoniaNucleo
import ArmoniaTeoria

// Nombres antiguos de la API pública, que siguen compilando con un aviso hasta que se quiten.

extension OpcionesDePentagrama {
    /// El nombre de antes de `Posicion`.
    @available(*, deprecated, renamed: "Posicion")
    public typealias Disposicion = Posicion
}

extension OpcionesDePentagrama.Maquetacion {
    /// El nombre de antes de `posicionDelAcorde`.
    @available(*, deprecated, renamed: "posicionDelAcorde")
    public var disposicionDelAcorde: OpcionesDePentagrama.Posicion {
        get { posicionDelAcorde }
        set { posicionDelAcorde = newValue }
    }

    /// El inicializador de antes, con `disposicionDelAcorde` en lugar de `posicionDelAcorde`.
    @available(*, deprecated, message: "usa posicionDelAcorde en lugar de disposicionDelAcorde")
    public init(
        clave: Clave? = nil, pentagramas: OpcionesDePentagrama.Pentagramas = .automatico, cambiosDeClave: Bool = false,
        marcaDeOctava: Bool = true, disposicionDelAcorde: OpcionesDePentagrama.Posicion, compasesPorLinea: Int? = nil,
        anchoDeLosCaracteres: Double = 1
    ) {
        self.init(
            clave: clave, pentagramas: pentagramas, cambiosDeClave: cambiosDeClave, marcaDeOctava: marcaDeOctava,
            posicionDelAcorde: disposicionDelAcorde, compasesPorLinea: compasesPorLinea,
            anchoDeLosCaracteres: anchoDeLosCaracteres)
    }
}

extension Acorde {
    /// El nombre de antes de `partitura(octava:posicion:)`.
    @available(*, deprecated, renamed: "partitura(octava:posicion:)")
    public func partitura(octava: Int = 4, disposicion: OpcionesDePentagrama.Posicion) -> Partitura {
        partitura(octava: octava, posicion: disposicion)
    }
}

extension Evento {
    /// El nombre de antes de `NotaDelEvento`.
    @available(*, deprecated, renamed: "NotaDelEvento")
    public typealias Nota = NotaDelEvento
}

extension Partitura {
    /// El nombre de antes de `LineaEnElPentagrama`.
    @available(*, deprecated, renamed: "LineaEnElPentagrama")
    public typealias LineaEnPentagrama = LineaEnElPentagrama
}

/// El nombre de antes de `PosicionEnElPentagrama`.
@available(*, deprecated, renamed: "PosicionEnElPentagrama")
public typealias PosicionEnPentagrama = PosicionEnElPentagrama
