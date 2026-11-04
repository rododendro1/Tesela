import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Los formatos de partitura como un solo tipo. Cada formato tiene su función en la `Partitura` (`musicXML()`, `guido()`,
// `midi()`…), y `partitura.exportar(como:)` elige una de ellas: así, quien ofrece todos los formatos (el menú de
// exportar de las apps, la línea de comandos, `armonia grabar`) los recorre con `FormatoDePartitura.allCases` y no
// repite la llamada de cada uno. Un formato nuevo es un caso más aquí y una rama más en `exportar`.

/// Un formato de fichero en que se exporta una partitura: MusicXML, MEI, LilyPond, GUIDO, ABC o MIDI.
///
///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
///     for formato in FormatoDePartitura.allCases {
///         let datos = voz.partitura(encabezado: Encabezado(titulo: "Escala")).exportar(como: formato)
///         // …se guarda en «Escala.\(formato.extensionDeFichero)»
///     }
public enum FormatoDePartitura: String, Hashable, Sendable, CaseIterable, Codable {
    case musicXML = "musicxml"
    case mei
    case lilyPond = "lilypond"
    case guido
    case abc
    case midi

    /// La extensión del fichero, sin el punto: «musicxml», «mei», «ly», «gmn», «abc» y «mid».
    public var extensionDeFichero: String {
        switch self {
        case .musicXML: return "musicxml"
        case .mei: return "mei"
        case .lilyPond: return "ly"
        case .guido: return "gmn"
        case .abc: return "abc"
        case .midi: return "mid"
        }
    }

    /// Si el fichero es texto (UTF-8); el MIDI es binario.
    public var esTexto: Bool { self != .midi }

    /// Cómo se llama el formato: «MusicXML», «MEI», «LilyPond», «GUIDO», «ABC» y «MIDI».
    public var nombre: String {
        switch self {
        case .musicXML: return "MusicXML"
        case .mei: return "MEI"
        case .lilyPond: return "LilyPond"
        case .guido: return "GUIDO"
        case .abc: return "ABC"
        case .midi: return "MIDI"
        }
    }
}
