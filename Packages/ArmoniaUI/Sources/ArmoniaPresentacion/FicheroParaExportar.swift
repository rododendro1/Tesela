import Armonia
import Foundation

/// Un fichero que las apps ofrecen para compartir: una partitura MusicXML, MEI, LilyPond o ABC, un MIDI o
/// un dibujo SVG.
/// No usa SwiftUI, así que se prueba en Linux; `BotonDeExportar` lo escribe y lo comparte.
///
///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
///     let fichero = FicheroParaExportar.midi(analisis.midi(), nombre: "Progresión")
///     fichero.nombreDeFichero   // "Progresión.mid"
public struct FicheroParaExportar: Hashable, Sendable, Identifiable {
    public enum Formato: String, Hashable, Sendable, CaseIterable {
        case musicXML
        case mei
        case lilyPond
        case abc
        case midi
        case svg

        /// La extensión del fichero, sin el punto.
        public var extensionDeFichero: String {
            switch self {
            case .musicXML: return "musicxml"
            case .mei: return "mei"
            case .lilyPond: return "ly"
            case .abc: return "abc"
            case .midi: return "mid"
            case .svg: return "svg"
            }
        }

        /// Cómo se llama el formato en el menú.
        public var titulo: String {
            switch self {
            case .musicXML: return "Partitura MusicXML"
            case .mei: return "Partitura MEI"
            case .lilyPond: return "Partitura LilyPond"
            case .abc: return "Partitura ABC"
            case .midi: return "MIDI"
            case .svg: return "Dibujo SVG"
            }
        }

        /// El símbolo de SF Symbols del menú.
        public var icono: String {
            switch self {
            case .musicXML: return "music.note.list"
            case .mei: return "doc.richtext"
            case .lilyPond: return "doc.text"
            case .abc: return "text.alignleft"
            case .midi: return "pianokeys"
            case .svg: return "photo"
            }
        }
    }

    /// El nombre sin extensión, tal como se escribió (`nombreDeFichero` lo limpia).
    public let nombre: String
    public let formato: Formato
    public let datos: Data

    public init(nombre: String, formato: Formato, datos: Data) {
        self.nombre = nombre
        self.formato = formato
        self.datos = datos
    }

    public static func musicXML(_ xml: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .musicXML, datos: Data(xml.utf8))
    }

    public static func mei(_ mei: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .mei, datos: Data(mei.utf8))
    }

    public static func lilyPond(_ ly: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .lilyPond, datos: Data(ly.utf8))
    }

    public static func abc(_ abc: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .abc, datos: Data(abc.utf8))
    }

    public static func midi(_ datos: Data, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .midi, datos: datos)
    }

    public static func svg(_ svg: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .svg, datos: Data(svg.utf8))
    }

    public var id: String { nombreDeFichero }

    /// El nombre con su extensión, sin los caracteres que no admiten los sistemas de ficheros
    /// (`/`, `:`…) y como mucho de 80 caracteres: «Sol7/Si» se guarda como «Sol7-Si.mid».
    public var nombreDeFichero: String {
        FicheroParaExportar.limpiar(nombre) + "." + formato.extensionDeFichero
    }

    /// Escribe el fichero en la subcarpeta `Exportaciones` de `carpeta` (si ya había uno con el mismo
    /// nombre, lo sustituye) y devuelve dónde.
    @discardableResult
    public func escribir(en carpeta: URL = FileManager.default.temporaryDirectory) throws -> URL {
        let destino = carpeta.appendingPathComponent("Exportaciones", isDirectory: true)
        try FileManager.default.createDirectory(at: destino, withIntermediateDirectories: true)
        let url = destino.appendingPathComponent(nombreDeFichero)
        try datos.write(to: url, options: .atomic)
        return url
    }

    static func limpiar(_ nombre: String) -> String {
        let prohibidos = CharacterSet(charactersIn: "/\\:?*\"<>|").union(.newlines).union(.controlCharacters)
        let limpio = nombre.components(separatedBy: prohibidos).joined(separator: "-")
            .trimmingCharacters(in: .whitespaces)
        return limpio.isEmpty ? "Tesela" : String(limpio.prefix(80))
    }
}

// MARK: - Idiomas
//
// Los nombres de los formatos de exportación en los catorce idiomas, en `TextosDeApps`.

extension FicheroParaExportar.Formato {
    /// Cómo se llama el formato en el menú: «Partitura MusicXML», «MusicXML score»…
    public func titulo(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .musicXML:
            traduccion = TextosDeApps.traduccion(\.partituraMusicXML)
        case .mei:
            traduccion = TextosDeApps.traduccion(\.partituraMEI)
        case .lilyPond:
            traduccion = TextosDeApps.traduccion(\.partituraLilyPond)
        case .abc:
            traduccion = TextosDeApps.traduccion(\.partituraABC)
        case .midi:
            return "MIDI"
        case .svg:
            traduccion = TextosDeApps.traduccion(\.dibujoSVG)
        }
        return traduccion.en(notacion)
    }
}
