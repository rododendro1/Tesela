import Armonia
import Foundation

/// Lo que hace «Abrir» en la vista de análisis: lee un fichero MIDI, MusicXML (también comprimido, .mxl), MEI o
/// ABC y escribe sus acordes como una progresión, en español («Do Sol/Si Lam Mi7»), que es como la lee el campo de la
/// progresión. Así se puede retocar antes de analizarla. Guarda además el ritmo armónico de la pieza (lo que
/// dura cada acorde), que siguen la partitura, el MIDI y «Escuchar» mientras no se retoque. No usa SwiftUI, así
/// que se prueba en Linux.
public enum ImportacionDeProgresion {
    /// Las extensiones que se ofrecen al abrir.
    public static let extensiones = FormatoDePartitura.queSeLeen.flatMap(\.extensiones)

    /// La progresión de un fichero, con un acorde por pulso (`ventana`, como en `PiezaImportada.acordes`).
    /// Lanza `ErrorDeLecturaDeFichero` si no se puede leer o no suena ningún acorde.
    public static func progresion(de datos: Data, ventana: Duracion? = nil) throws -> String {
        try leer(datos, ventana: ventana).texto
    }

    /// La progresión de un fichero con su ritmo armónico, su compás, su tempo y su título.
    /// Lanza `ErrorDeLecturaDeFichero` si no se puede leer o no suena ningún acorde.
    public static func leer(_ datos: Data, ventana: Duracion? = nil) throws -> ProgresionImportada {
        let pieza = try PiezaImportada(leyendo: datos)
        let ritmo = pieza.ritmoArmonico(ventana: ventana)
        guard !ritmo.acordes.isEmpty else { throw ErrorDeLecturaDeFichero.sinAcordes }
        return ProgresionImportada(ritmo: ritmo, titulo: pieza.titulo)
    }
}

/// Una progresión leída de un fichero: sus acordes con lo que dura cada uno, y el título de la pieza.
public struct ProgresionImportada: Hashable, Sendable {
    public let ritmo: RitmoArmonico
    public let titulo: String?

    /// Una progresión importada con su ritmo armónico y, si lo tiene, el título de la pieza.
    public init(ritmo: RitmoArmonico, titulo: String? = nil) {
        self.ritmo = ritmo
        self.titulo = titulo
    }

    /// Los acordes, sin lo que duran.
    public var acordes: [Acorde] { ritmo.acordes.map(\.acorde) }

    /// Los acordes como se escriben en el campo de la progresión: «Do Sol/Si Lam Mi7».
    public var texto: String { acordes.map { $0.cifrado(en: .compacta(.espanol)) }.joined(separator: " ") }
}
