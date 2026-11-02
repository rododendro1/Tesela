import Armonia
import Foundation

/// Unos acordes con sus alturas escritas, dispuestos como en el piano o el jazz (drop 2, shell…): una fila por acorde,
/// el pentagrama, lo que suena y, en una progresión, los ficheros para exportar.
public struct DisposicionesPresentadas: Hashable, Sendable {
    public struct Fila: Hashable, Sendable {
        /// El cifrado del acorde, o «» si son las disposiciones de un solo acorde.
        public let cifrado: String
        /// Las alturas de grave a agudo: «Do₃ Sol₃ Si♭₃ Mi₄».
        public let voces: String
        /// Este acorde solo, para escucharlo.
        public let sonido: Escucha
    }

    public let filas: [Fila]
    /// Todos los acordes, uno detrás de otro.
    public let sonido: Escucha
    public let pentagrama: PentagramaPresentado
    /// En una progresión, la partitura en MusicXML, MEI, LilyPond y ABC, y el MIDI; vacío con un solo acorde.
    public let ficheros: [FicheroParaExportar]
}

/// Las disposiciones de la vista de acordes y la progresión dispuesta de la vista de análisis. No usa SwiftUI, así que
/// se prueba en Linux.
///
///     let ii_V_I = PresentacionDeDisposiciones.progresion(
///         [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")], .drop2, notacion: .espanolCompacto)
///     ii_V_I?.filas.map(\.voces)   // la séptima de cada acorde baja a la tercera del siguiente
public enum PresentacionDeDisposiciones {
    /// Todas las disposiciones de un acorde en el ámbito de Do3 a Sol5, de la más grave a la más aguda. `nil` si
    /// no tiene ninguna (la shell de un acorde sin tercera).
    public static func acorde(
        _ acorde: Acorde, _ disposicion: DisposicionDeAcorde, notacion: Notacion
    ) -> DisposicionesPresentadas? {
        let todas = acorde.disposiciones(disposicion)
        guard !todas.isEmpty else { return nil }
        let titulo = acorde.cifrado(en: notacion) + " · " + disposicion.nombre(en: notacion)
        return presentar(todas, cifrados: nil, titulo: titulo, ficheros: [], notacion: notacion)
    }

    /// Una disposición para cada acorde de la progresión, con el menor movimiento de las voces de uno al siguiente.
    /// `nil` si algún acorde no se puede disponer así.
    public static func progresion(
        _ acordes: [Acorde], _ disposicion: DisposicionDeAcorde, notacion: Notacion
    ) -> DisposicionesPresentadas? {
        guard !acordes.isEmpty, let voces = disposicion.conducir(acordes), let coral = Coral(voces) else { return nil }
        let nombre = disposicion.nombre(en: notacion)
        let cifrados = acordes.map { $0.cifrado(en: notacion) }
        return presentar(
            voces, cifrados: cifrados, titulo: nombre,
            ficheros: PresentacionDeCoral.ficheros(coral, nil, notacion, nombre: nombre), notacion: notacion)
    }

    static func presentar(
        _ acordes: [[Altura]], cifrados: [String]?, titulo: String, ficheros: [FicheroParaExportar],
        notacion: Notacion
    ) -> DisposicionesPresentadas {
        let filas = acordes.indices.map { i in
            DisposicionesPresentadas.Fila(
                cifrado: cifrados.map { $0[i] } ?? "", voces: PresentacionDeCoral.voces(acordes[i], notacion),
                sonido: .coral([acordes[i]], duracion: 1.5))
        }
        return DisposicionesPresentadas(
            filas: filas, sonido: .coral(acordes),
            pentagrama: PentagramaPresentado(acordes, titulo: titulo, notacion: notacion),
            ficheros: ficheros)
    }
}

// MARK: - Idiomas

extension DisposicionDeAcorde {
    /// «Cerrada», «Drop 2», «Fundamental, tercera y séptima»… Los drops se llaman igual en todos los idiomas, como en
    /// los métodos de jazz.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .cerrada: return notacion.texto(\.disposicionCerrada)
        case .drop2: return "Drop 2"
        case .drop3: return "Drop 3"
        case .drop24: return "Drop 2 + 4"
        case .shell: return notacion.texto(\.fundamentalTerceraYSeptima)
        case .notasGuia: return notacion.texto(\.terceraYSeptima)
        case .cuartal: return notacion.texto(\.disposicionCuartal)
        }
    }
}
