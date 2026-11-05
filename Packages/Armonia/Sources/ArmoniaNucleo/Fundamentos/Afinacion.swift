import Foundation

// El protocolo de las afinaciones: lo que da frecuencia a cada nota. Está en el Núcleo para que lo usen todas las
// capas (el MIDI de los formatos suena en la que se le pida); los temperamentos y las afinaciones históricas están
// en la Teoría (ArmoniaTeoria/Afinacion/).

/// Una forma de dar frecuencia a cada nota.
public protocol Afinacion: Sendable {
    func frecuencia(de nota: Altura) -> Double
}

extension Afinacion {
    /// Distancia en cents entre dos notas en esta afinación.
    public func cents(desde a: Altura, hasta b: Altura) -> Double {
        1200 * log2(frecuencia(de: b) / frecuencia(de: a))
    }

    /// Cuánto se aparta una nota (en cents) de la misma nota en temperamento igual con La4 = 440.
    public func desviacion(de nota: Altura) -> Double {
        1200 * log2(frecuencia(de: nota) / nota.frecuencia())
    }
}

extension Altura {
    /// Frecuencia en una afinación cualquiera: `nota.frecuencia(en: .mesotonicoCuartoDeComa)`.
    public func frecuencia(en afinacion: some Afinacion) -> Double {
        afinacion.frecuencia(de: self)
    }
}
