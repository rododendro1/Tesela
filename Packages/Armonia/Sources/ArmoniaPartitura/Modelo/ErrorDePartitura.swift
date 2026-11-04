import ArmoniaNucleo

/// Un error al hacer una voz o una partitura con datos que no casan: un arpegio con una figura que no dura, o una
/// progresión con más o menos duraciones que acordes. Con datos de fuera (los de una pieza importada, los de quien
/// usa una app), es lo que se lanza en vez de detener el programa.
///
///     do {
///         let voz = try Voz(arpegiando: [Acorde("Do"), Acorde("Sol")], duraciones: [.redonda])
///     } catch let error as ErrorDePartitura {
///         error.motivo   // .duracionesPorAcorde(acordes: 2, duraciones: 1)
///     }
public struct ErrorDePartitura: ErrorDeArmonia, Hashable {
    public enum Motivo: Hashable, Sendable {
        /// La figura de un arpegio no es positiva.
        case figuraSinDuracion
        /// No hay una duración por acorde.
        case duracionesPorAcorde(acordes: Int, duraciones: Int)
        /// La duración de un acorde (contado desde 0) no es positiva.
        case duracionNoPositiva(indice: Int)
    }

    public let motivo: Motivo

    public init(_ motivo: Motivo) { self.motivo = motivo }

    /// Si `duraciones` tiene una duración positiva por cada uno de los `acordes`; si no, el error que lo dice.
    package static func comprobar(_ duraciones: [Duracion], acordes: Int) throws(ErrorDePartitura) {
        guard duraciones.count == acordes else {
            throw ErrorDePartitura(.duracionesPorAcorde(acordes: acordes, duraciones: duraciones.count))
        }
        if let indice = duraciones.firstIndex(where: { $0 <= .cero }) {
            throw ErrorDePartitura(.duracionNoPositiva(indice: indice))
        }
    }

    public func descripcion(en notacion: Notacion) -> String {
        switch motivo {
        case .figuraSinDuracion: return TextosDePartitura.en(notacion, \.figuraSinDuracion)
        case .duracionesPorAcorde(let acordes, let duraciones):
            return TextosDePartitura.en(notacion) { $0.duracionesPorAcorde(acordes, duraciones) }
        case .duracionNoPositiva(let indice):
            return TextosDePartitura.en(notacion) { $0.duracionNoPositiva(indice + 1) }
        }
    }
}
