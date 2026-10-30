import Foundation
import Armonia

/// Un fichero que las apps ofrecen para compartir: una partitura MusicXML o MEI, un MIDI o un dibujo SVG.
/// No usa SwiftUI, así que se prueba en Linux; `BotonDeExportar` lo escribe y lo comparte.
///
///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
///     let fichero = FicheroParaExportar.midi(analisis.midi(), nombre: "Progresión")
///     fichero.nombreDeFichero   // "Progresión.mid"
public struct FicheroParaExportar: Hashable, Sendable, Identifiable {
    public enum Formato: String, Hashable, Sendable, CaseIterable {
        case musicXML
        case mei
        case midi
        case svg

        /// La extensión del fichero, sin el punto.
        public var extensionDeFichero: String {
            switch self {
            case .musicXML: return "musicxml"
            case .mei: return "mei"
            case .midi: return "mid"
            case .svg: return "svg"
            }
        }

        /// Cómo se llama el formato en el menú.
        public var titulo: String {
            switch self {
            case .musicXML: return "Partitura MusicXML"
            case .mei: return "Partitura MEI"
            case .midi: return "MIDI"
            case .svg: return "Dibujo SVG"
            }
        }

        /// El símbolo de SF Symbols del menú.
        public var icono: String {
            switch self {
            case .musicXML: return "music.note.list"
            case .mei: return "doc.richtext"
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
// Los nombres de los formatos de exportación en los catorce idiomas de los textos (`Traduccion`).

extension FicheroParaExportar.Formato {
    /// Cómo se llama el formato en el menú: «Partitura MusicXML», «MusicXML score»…
    public func titulo(en notacion: Notacion) -> String {
        let traduccion: Traduccion
        switch self {
        case .musicXML:
            traduccion = Traduccion("Partitura MusicXML", "MusicXML score", ca: "Partitura MusicXML",
                                    gl: "Partitura MusicXML", ast: "Partitura MusicXML", an: "Partitura MusicXML",
                                    eu: "MusicXML partitura", pt: "Partitura MusicXML",
                                    fr: "Partition MusicXML", oc: "Particion MusicXML", it: "Partitura MusicXML",
                                    de: "MusicXML-Partitur",
                                    el: "Παρτιτούρα MusicXML", ru: "Партитура MusicXML")
        case .mei:
            traduccion = Traduccion("Partitura MEI", "MEI score", ca: "Partitura MEI",
                                    gl: "Partitura MEI", ast: "Partitura MEI", an: "Partitura MEI",
                                    eu: "MEI partitura", pt: "Partitura MEI",
                                    fr: "Partition MEI", oc: "Particion MEI", it: "Partitura MEI",
                                    de: "MEI-Partitur",
                                    el: "Παρτιτούρα MEI", ru: "Партитура MEI")
        case .midi:
            return "MIDI"
        case .svg:
            traduccion = Traduccion("Dibujo SVG", "SVG drawing", ca: "Dibuix SVG", gl: "Debuxo SVG", ast: "Dibuxu SVG",
                                    an: "Dibuixo SVG", eu: "SVG marrazkia", pt: "Desenho SVG",
                                    fr: "Dessin SVG", oc: "Dessenh SVG", it: "Disegno SVG", de: "SVG-Zeichnung",
                                    el: "Σχέδιο SVG", ru: "Рисунок SVG")
        }
        return traduccion.en(notacion)
    }
}
