import Armonia
import Foundation

/// Lo que hace «Partitura» en la app del Tonnetz: los acordes de un fichero MIDI, MusicXML (también .mxl), MEI o ABC,
/// uno detrás de otro con su ritmo armónico, para seguirlos en la red mientras suenan. Entre cada dos tríadas mayores
/// o menores dice qué transformaciones P, L y R llevan de una a otra por el camino más corto. No usa SwiftUI, así que
/// se prueba en Linux.
///
///     let recorrido = RecorridoDePartitura(progresion, notacion: .espanolCompacto)
///     recorrido.pasos.map(\.transformacion)   // ["", "R", "L", "–", …]
public struct RecorridoDePartitura: Hashable, Sendable {
    /// Un acorde de la pieza.
    public struct Paso: Hashable, Sendable {
        public let acorde: Acorde
        /// El cifrado en la notación.
        public let cifrado: String
        /// Las transformaciones desde el acorde anterior, de izquierda a derecha («R», «PL»); «» en el primero y
        /// «=» si es la misma tríada; «–» si alguno de los dos no es una tríada mayor o menor.
        public let transformacion: String
        /// Lo que dura en la pieza.
        public let duracion: Duracion
    }

    /// El título de la pieza, si el fichero lo da.
    public let titulo: String?
    public let pasos: [Paso]
    /// Los acordes con su ritmo, para «Escuchar»: el paso `i` de `Reproductor.paso(de:)` es `pasos[i]`.
    public let sonido: Escucha

    /// El recorrido por la progresión importada, escrito en la notación.
    public init(_ progresion: ProgresionImportada, notacion: Notacion) {
        titulo = progresion.titulo
        let acordes = progresion.acordes
        let pasos = progresion.ritmo.acordes.enumerated().map { i, conDuracion in
            let transformacion =
                i == 0 ? "" : RecorridoDePartitura.transformacion(desde: acordes[i - 1], hasta: acordes[i])
            return Paso(
                acorde: acordes[i], cifrado: acordes[i].cifrado(en: notacion), transformacion: transformacion,
                duracion: conDuracion.duracion)
        }
        self.pasos = pasos
        sonido = Escucha.acordes(
            acordes, duraciones: pasos.map(\.duracion), tempo: progresion.ritmo.tempo ?? Escucha.tempo)
    }

    /// Lee un fichero. Lanza `ErrorDeLecturaDeFichero` si no se puede leer o no suena ningún acorde.
    public static func leer(_ datos: Data, en notacion: Notacion) throws -> RecorridoDePartitura {
        RecorridoDePartitura(try ImportacionDeProgresion.leer(datos), notacion: notacion)
    }

    /// «R», «PL», «=» o «–»: ver `Paso.transformacion`. Basta que las tríadas suenen igual (Do♯ y Re♭ son la misma),
    /// porque la ortografía de un fichero MIDI es una estimación.
    static func transformacion(desde origen: Acorde, hasta destino: Acorde) -> String {
        guard let camino = Tonnetz.camino(desde: origen, hasta: destino, enarmonico: true) else { return "–" }
        return camino.isEmpty ? "=" : camino.map { $0.rawValue.uppercased() }.joined()
    }

    /// Lo que se dibuja en el paso `i`: las tríadas seguidas que llevan hasta él (como mucho `longitud`), para ver
    /// en la red el camino con sus flechas; si el acorde no es una tríada mayor o menor, o es la primera de su
    /// racha, solo él. Vacío si `i` no es un paso.
    ///
    ///     // Do Lam Fa Sol7 Do Mim
    ///     recorrido.tramo(hasta: 2)   // [Do, Lam, Fa]
    ///     recorrido.tramo(hasta: 3)   // [Sol7]
    ///     recorrido.tramo(hasta: 5)   // [Do, Mim]
    public func tramo(hasta i: Int, longitud: Int = 4) -> [Acorde] {
        guard pasos.indices.contains(i) else { return [] }
        var tramo = [pasos[i].acorde]
        guard RecorridoDePartitura.esTriada(pasos[i].acorde) else { return tramo }
        var j = i - 1
        while j >= 0, tramo.count < longitud, RecorridoDePartitura.esTriada(pasos[j].acorde) {
            tramo.insert(pasos[j].acorde, at: 0)
            j -= 1
        }
        return tramo
    }

    static func esTriada(_ acorde: Acorde) -> Bool { acorde.tipo == .mayor || acorde.tipo == .menor }

    /// El paso que sigue o el anterior a `i`, sin salirse: si `i` es `nil`, el primero.
    public func paso(desde i: Int?, avanzando: Bool) -> Int? {
        guard !pasos.isEmpty else { return nil }
        guard let i else { return 0 }
        return min(max(i + (avanzando ? 1 : -1), 0), pasos.count - 1)
    }
}
