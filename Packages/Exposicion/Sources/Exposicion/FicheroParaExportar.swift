import Armonia
import Foundation

/// Un fichero que las apps ofrecen para compartir: una partitura en uno de los formatos de `FormatoDePartitura`
/// (MusicXML, MEI, LilyPond, GUIDO, ABC o MIDI) o un dibujo SVG.
/// No usa SwiftUI, así que se prueba en Linux; `BotonDeExportar` lo escribe y lo comparte.
///
///     let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
///     let fichero = FicheroParaExportar.midi(analisis.partitura().midi(), nombre: "Progresión")
///     fichero.nombreDeFichero   // "Progresión.mid"
public struct FicheroParaExportar: Hashable, Sendable, Identifiable {
    /// Los formatos en que se exporta, cada uno con su extensión y su tipo.
    public enum Formato: String, Hashable, Sendable, CaseIterable {
        case musicXML
        case mei
        case lilyPond
        case guido
        case abc
        case midi
        case svg
        case html

        /// El de una partitura.
        public init(_ partitura: FormatoDePartitura) {
            switch partitura {
            case .musicXML: self = .musicXML
            case .mei: self = .mei
            case .lilyPond: self = .lilyPond
            case .guido: self = .guido
            case .abc: self = .abc
            case .midi: self = .midi
            }
        }

        /// El formato de partitura que es; `nil` el dibujo SVG y la página HTML.
        public var partitura: FormatoDePartitura? {
            switch self {
            case .musicXML: return .musicXML
            case .mei: return .mei
            case .lilyPond: return .lilyPond
            case .guido: return .guido
            case .abc: return .abc
            case .midi: return .midi
            case .svg, .html: return nil
            }
        }

        /// La extensión del fichero, sin el punto.
        public var extensionDeFichero: String { partitura?.extensionDeFichero ?? (self == .html ? "html" : "svg") }

        /// Cómo se llama el formato en el menú.
        public var titulo: String {
            switch self {
            case .musicXML: return "Partitura MusicXML"
            case .mei: return "Partitura MEI"
            case .lilyPond: return "Partitura LilyPond"
            case .guido: return "Partitura GUIDO"
            case .abc: return "Partitura ABC"
            case .midi: return "MIDI"
            case .svg: return "Dibujo SVG"
            case .html: return "Página HTML"
            }
        }

        /// El símbolo de SF Symbols del menú.
        public var icono: String {
            switch self {
            case .musicXML: return "music.note.list"
            case .mei: return "doc.richtext"
            case .lilyPond: return "doc.text"
            case .guido: return "music.quarternote.3"
            case .abc: return "text.alignleft"
            case .midi: return "pianokeys"
            case .svg: return "photo"
            case .html: return "globe"
            }
        }
    }

    /// El nombre sin extensión, tal como se escribió (`nombreDeFichero` lo limpia).
    public let nombre: String
    public let formato: Formato
    public let datos: Data

    /// Un fichero con ese nombre (sin extensión), en ese formato y con esos datos.
    public init(nombre: String, formato: Formato, datos: Data) {
        self.nombre = nombre
        self.formato = formato
        self.datos = datos
    }

    /// Una partitura en un formato: los de texto, en UTF-8, como los da `exportar(como:…)`.
    public static func partitura(
        _ datos: Data, formato: FormatoDePartitura, nombre: String
    ) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: Formato(formato), datos: datos)
    }

    /// Una partitura en todos los formatos, en el orden de `FormatoDePartitura.allCases`, para el menú de exportar:
    ///
    ///     let ficheros = FicheroParaExportar.partituras(nombre: "Coral") { formato in
    ///         coral.partitura(encabezado: Encabezado(titulo: "Coral")).exportar(como: formato)
    ///     }
    ///     ficheros.map(\.nombreDeFichero)   // ["Coral.musicxml", "Coral.mei", "Coral.ly", "Coral.gmn", …]
    public static func partituras(
        nombre: String, _ exportar: (FormatoDePartitura) -> Data
    ) -> [FicheroParaExportar] {
        FormatoDePartitura.allCases.map { partitura(exportar($0), formato: $0, nombre: nombre) }
    }

    /// Un fichero MusicXML con ese texto.
    public static func musicXML(_ xml: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .musicXML, datos: Data(xml.utf8))
    }

    /// Un fichero MEI con ese texto.
    public static func mei(_ mei: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .mei, datos: Data(mei.utf8))
    }

    /// Un fichero de LilyPond con ese texto.
    public static func lilyPond(_ ly: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .lilyPond, datos: Data(ly.utf8))
    }

    /// Un fichero ABC con ese texto.
    public static func abc(_ abc: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .abc, datos: Data(abc.utf8))
    }

    /// Un fichero MIDI con esos datos.
    public static func midi(_ datos: Data, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .midi, datos: datos)
    }

    /// Un dibujo SVG con ese texto.
    public static func svg(_ svg: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .svg, datos: Data(svg.utf8))
    }

    /// Una página HTML con ese texto.
    public static func html(_ html: String, nombre: String) -> FicheroParaExportar {
        FicheroParaExportar(nombre: nombre, formato: .html, datos: Data(html.utf8))
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
// Los nombres de los formatos de exportación en los trece idiomas, en `TextosDeApps`.

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
        case .guido:
            traduccion = TextosDeApps.traduccion(\.partituraGUIDO)
        case .abc:
            traduccion = TextosDeApps.traduccion(\.partituraABC)
        case .midi:
            return "MIDI"
        case .svg:
            traduccion = TextosDeApps.traduccion(\.dibujoSVG)
        case .html:
            traduccion = TextosDeApps.traduccion(\.paginaHTML)
        }
        return traduccion.en(notacion)
    }
}
