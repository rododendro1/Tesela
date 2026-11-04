import ArmoniaNucleo
import ArmoniaTeoria

// El ritmo armónico: cada acorde de una progresión con lo que dura. Lo da una pieza importada
// (`PiezaImportada.ritmoArmonico(ventana:)`), lo siguen su partitura (`RitmoArmonico.partitura(en:…)`) y su
// arpegio (`Voz(arpegiando:patron:…)`).

/// Un acorde con lo que dura.
public struct AcordeConDuracion: Hashable, Sendable {
    public let acorde: Acorde
    public let duracion: Duracion

    /// Detiene el programa si `duracion` no es positiva, como `Duracion(_:_:)` con un denominador 0.
    public init(_ acorde: Acorde, _ duracion: Duracion) {
        precondition(duracion > .cero, "un acorde tiene que durar algo")
        self.acorde = acorde
        self.duracion = duracion
    }
}

/// Un acorde con el momento en que empieza, en redondas desde el principio de la pieza.
public struct AcordeConInicio: Hashable, Sendable {
    public let acorde: Acorde
    public let inicio: Duracion

    public init(_ acorde: Acorde, inicio: Duracion) {
        self.acorde = acorde
        self.inicio = inicio
    }
}

/// Una progresión con su ritmo armónico: cada acorde con lo que dura, en un compás y, si se sabe, a un tempo.
///
///     let ritmo = RitmoArmonico([AcordeConDuracion("Do", .blanca), AcordeConDuracion("Sol7", .negra)])
///     ritmo.duraciones == [.blanca, .negra]   // true
public struct RitmoArmonico: Hashable, Sendable {
    public let acordes: [AcordeConDuracion]
    public let compas: Compas
    public let tempo: Tempo?

    public init(_ acordes: [AcordeConDuracion], compas: Compas = .compasillo, tempo: Tempo? = nil) {
        self.acordes = acordes
        self.compas = compas
        self.tempo = tempo
    }

    /// Todos los acordes con la misma duración (negras, si no se pide otra).
    public init(_ acordes: [Acorde], duracion: Duracion = .negra, compas: Compas = .compasillo, tempo: Tempo? = nil) {
        self.init(acordes.map { AcordeConDuracion($0, duracion) }, compas: compas, tempo: tempo)
    }

    /// Lo que dura cada acorde, en orden.
    public var duraciones: [Duracion] { acordes.map(\.duracion) }

    /// El mismo ritmo con otras duraciones, todas iguales: lo que hace `--duracion` en la línea de comandos.
    public func con(duracion: Duracion) -> RitmoArmonico {
        RitmoArmonico(acordes.map(\.acorde), duracion: duracion, compas: compas, tempo: tempo)
    }
}

extension RitmoArmonico: Transponible {
    public func transponer(_ intervalo: Intervalo) -> RitmoArmonico {
        RitmoArmonico(
            acordes.map { AcordeConDuracion($0.acorde.transponer(intervalo), $0.duracion) }, compas: compas,
            tempo: tempo)
    }
}
