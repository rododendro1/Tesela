import Armonia
import Foundation

/// Lo que hace «Abrir» en la vista de análisis: lee un fichero MIDI o MusicXML y escribe sus acordes como una
/// progresión, en español («Do Sol/Si Lam Mi7»), que es como la lee el campo de la progresión. Así se puede
/// retocar antes de analizarla. No usa SwiftUI, así que se prueba en Linux.
public enum ImportacionDeProgresion {
    /// Las extensiones que se ofrecen al abrir.
    public static let extensiones = ["mid", "midi", "musicxml", "xml"]

    /// La progresión de un fichero, con un acorde por pulso (`ventana`, como en `PiezaImportada.acordes`).
    /// Lanza `ErrorDeImportacion` si no se puede leer o no suena ningún acorde.
    public static func progresion(de datos: Data, ventana: Duracion? = nil) throws -> String {
        let acordes = try PiezaImportada(leyendo: datos).acordes(ventana: ventana)
        guard !acordes.isEmpty else { throw ErrorDeImportacion.sinAcordes }
        return acordes.map { $0.cifrado(en: .espanolUnicode) }.joined(separator: " ")
    }
}
