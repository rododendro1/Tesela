import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria
import Foundation

// Los formatos de partitura como un solo tipo. Cada formato tiene sus funciones (`voz.musicXML(…)`, `coral.guido(…)`,
// `analisis.midi(…)`…), y `exportar(como:…)` elige una de ellas: así, quien ofrece todos los formatos (el menú de
// exportar de las apps, la línea de comandos, `armonia grabar`) los recorre con `FormatoDePartitura.allCases` y no
// repite la llamada de cada uno. Un formato nuevo es un caso más aquí y una rama más en cada `exportar`.

/// Un formato de fichero en que se exporta una partitura: MusicXML, MEI, LilyPond, GUIDO, ABC o MIDI.
///
///     let voz = try Voz(leyendo: "Do4:4 Re4:8 Mi4:8 Fa4:2", compas: "3/4")
///     for formato in FormatoDePartitura.allCases {
///         let datos = voz.exportar(como: formato, titulo: "Escala")
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

extension Voz {
    /// La voz en el formato pedido, como `musicXML(tonalidad:clave:tempo:titulo:parte:)` y las demás: los formatos
    /// de texto, en UTF-8. La clave no cuenta en MIDI, ni el instrumento (el programa General MIDI) en los demás.
    public func exportar(
        como formato: FormatoDePartitura, tonalidad: Tonalidad? = nil, clave: Clave? = nil, tempo: Tempo? = nil,
        titulo: String? = nil, parte: String = "Voz", instrumento: Int = 0
    ) -> Data {
        let texto: String
        switch formato {
        case .musicXML: texto = musicXML(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo, parte: parte)
        case .mei: texto = mei(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo, parte: parte)
        case .lilyPond: texto = lilyPond(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo, parte: parte)
        case .guido: texto = guido(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo, parte: parte)
        case .abc: texto = abc(tonalidad: tonalidad, clave: clave, tempo: tempo, titulo: titulo, parte: parte)
        case .midi:
            return midi(tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte, instrumento: instrumento)
        }
        return Data(texto.utf8)
    }
}

extension Coral {
    /// El coral en el formato pedido, como
    /// `musicXML(duracion:compas:tonalidad:tempo:titulo:parte:cifrados:analisis:notacion:)` y las demás: los formatos
    /// de texto, en UTF-8. El MIDI no lleva parte, cifrados ni análisis, y el instrumento solo cuenta en él.
    public func exportar(
        como formato: FormatoDePartitura, duracion: Duracion = .negra, compas: Compas = .compasillo,
        tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil, parte: String = "Coro",
        cifrados: Bool = false, analisis: Bool = false, instrumento: Int = 52,
        notacion: Notacion = .espanolCompacto
    ) -> Data {
        let texto: String
        switch formato {
        case .musicXML:
            texto = musicXML(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .mei:
            texto = mei(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .lilyPond:
            texto = lilyPond(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .guido:
            texto = guido(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .abc:
            texto = abc(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .midi:
            return midi(
                duracion: duracion, compas: compas, tonalidad: tonalidad, tempo: tempo, titulo: titulo,
                instrumento: instrumento, notacion: notacion)
        }
        return Data(texto.utf8)
    }
}

extension AnalisisArmonico {
    /// La progresión en el formato pedido, como
    /// `musicXML(duracion:compas:tempo:titulo:parte:cifrados:analisis:notacion:)` y las demás: los formatos de texto,
    /// en UTF-8. El MIDI no lleva parte, cifrados ni análisis, y el instrumento solo cuenta en él.
    public func exportar(
        como formato: FormatoDePartitura, duracion: Duracion = .blanca, compas: Compas = .compasillo,
        tempo: Tempo? = nil, titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, instrumento: Int = 0, notacion: Notacion = .espanolCompacto
    ) -> Data {
        exportar(
            como: formato, duraciones: Array(repeating: duracion, count: acordes.count), compas: compas,
            tempo: tempo, titulo: titulo, parte: parte, cifrados: cifrados, analisis: analisis,
            instrumento: instrumento, notacion: notacion)
    }

    /// Lo mismo, con lo que dura cada acorde; el último se alarga hasta la barra.
    ///
    /// Detiene el programa si no hay una duración positiva por acorde.
    public func exportar(
        como formato: FormatoDePartitura, duraciones: [Duracion], compas: Compas = .compasillo,
        tempo: Tempo? = nil, titulo: String? = nil, parte: String = "Piano", cifrados: Bool = true,
        analisis: Bool = true, instrumento: Int = 0, notacion: Notacion = .espanolCompacto
    ) -> Data {
        let texto: String
        switch formato {
        case .musicXML:
            texto = musicXML(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .mei:
            texto = mei(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .lilyPond:
            texto = lilyPond(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .guido:
            texto = guido(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .abc:
            texto = abc(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, parte: parte,
                cifrados: cifrados, analisis: analisis, notacion: notacion)
        case .midi:
            return midi(
                duraciones: duraciones, compas: compas, tempo: tempo, titulo: titulo, instrumento: instrumento,
                notacion: notacion)
        }
        return Data(texto.utf8)
    }
}

extension Contrapunto {
    /// El contrapunto en el formato pedido, como `musicXML(tonalidad:tempo:titulo:)` y las demás: los formatos de
    /// texto, en UTF-8. El instrumento solo cuenta en MIDI.
    public func exportar(
        como formato: FormatoDePartitura, tonalidad: Tonalidad? = nil, tempo: Tempo? = nil, titulo: String? = nil,
        instrumento: Int = 52
    ) -> Data {
        let texto: String
        switch formato {
        case .musicXML: texto = musicXML(tonalidad: tonalidad, tempo: tempo, titulo: titulo)
        case .mei: texto = mei(tonalidad: tonalidad, tempo: tempo, titulo: titulo)
        case .lilyPond: texto = lilyPond(tonalidad: tonalidad, tempo: tempo, titulo: titulo)
        case .guido: texto = guido(tonalidad: tonalidad, tempo: tempo, titulo: titulo)
        case .abc: texto = abc(tonalidad: tonalidad, tempo: tempo, titulo: titulo)
        case .midi: return midi(tonalidad: tonalidad, tempo: tempo, titulo: titulo, instrumento: instrumento)
        }
        return Data(texto.utf8)
    }
}
