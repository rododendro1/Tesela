import Armonia
import Foundation

/// Lo que hace «Abrir» en la vista de análisis: lee un fichero MIDI o MusicXML (también comprimido, .mxl) y
/// escribe sus acordes como una progresión, en español («Do Sol/Si Lam Mi7»), que es como la lee el campo de la
/// progresión. Así se puede retocar antes de analizarla. Guarda además el ritmo armónico de la pieza (lo que
/// dura cada acorde), que siguen la partitura, el MIDI y «Escuchar» mientras no se retoque. No usa SwiftUI, así
/// que se prueba en Linux.
public enum ImportacionDeProgresion {
    /// Las extensiones que se ofrecen al abrir.
    public static let extensiones = ["mid", "midi", "musicxml", "xml", "mxl"]

    /// La progresión de un fichero, con un acorde por pulso (`ventana`, como en `PiezaImportada.acordes`).
    /// Lanza `ErrorDeImportacion` si no se puede leer o no suena ningún acorde.
    public static func progresion(de datos: Data, ventana: Duracion? = nil) throws -> String {
        try leer(datos, ventana: ventana).texto
    }

    /// La progresión de un fichero con su ritmo armónico, su compás, su tempo y su título.
    /// Lanza `ErrorDeImportacion` si no se puede leer o no suena ningún acorde.
    public static func leer(_ datos: Data, ventana: Duracion? = nil) throws -> ProgresionImportada {
        let pieza = try PiezaImportada(leyendo: datos)
        let leidos = pieza.acordesConDuracion(ventana: ventana)
        guard !leidos.isEmpty else { throw ErrorDeImportacion.sinAcordes }
        return ProgresionImportada(acordes: leidos.map(\.acorde),
                                   ritmo: RitmoArmonico(duraciones: leidos.map(\.duracion),
                                                        compas: pieza.compas ?? .compasillo, tempo: pieza.tempo),
                                   titulo: pieza.titulo)
    }
}

/// Una progresión leída de un fichero: sus acordes, lo que dura cada uno y el título de la pieza.
public struct ProgresionImportada: Hashable, Sendable {
    public let acordes: [Acorde]
    public let ritmo: RitmoArmonico
    public let titulo: String?

    public init(acordes: [Acorde], ritmo: RitmoArmonico, titulo: String? = nil) {
        self.acordes = acordes
        self.ritmo = ritmo
        self.titulo = titulo
    }

    /// Los acordes como se escriben en el campo de la progresión: «Do Sol/Si Lam Mi7».
    public var texto: String { acordes.map { $0.cifrado(en: .espanolUnicode) }.joined(separator: " ") }
}
