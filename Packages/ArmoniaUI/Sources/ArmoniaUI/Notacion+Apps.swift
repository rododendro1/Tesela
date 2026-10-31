import Armonia
import Foundation

/// Lo que comparten las apps al elegir y guardar la notación. No usa SwiftUI, así que se prueba en Linux.
extension Notacion {
    /// Cómo se llama cada notación en el selector.
    public var titulo: String {
        esCombinada ? "\(escritura.titulo) · \(textos.titulo)" : escritura.titulo
    }

    /// El nombre con que se guarda en los ajustes. Es estable: no depende del orden de `allCases`.
    /// Una notación combinada se guarda como «ruso+espanol».
    public var clave: String {
        esCombinada ? escritura.clave + "+" + textos.clave : escritura.clave
    }

    /// La notación del idioma del sistema, para cuando aún no se ha elegido ninguna: con el sistema en
    /// catalán, `.catalan`; en un idioma sin notación propia, la española. `idiomas` son los códigos
    /// de `Locale.preferredLanguages` («ca-ES», «en-GB»…), y manda el primero que se conozca.
    public static func delSistema(idiomas: [String] = Locale.preferredLanguages) -> Notacion {
        for codigo in idiomas {
            if let idioma = Idioma(codigo: codigo) { return .delIdioma(idioma) }
        }
        return .espanolUnicode
    }

    /// La notación guardada con esa clave; si no existe, el español con ♯ y ♭.
    public static func desde(clave: String) -> Notacion {
        let partes = clave.split(separator: "+", maxSplits: 1).map(String.init)
        let notas = allCases.first { $0.clave == partes.first } ?? .espanolUnicode
        guard partes.count == 2, let textos = Idioma.allCases.first(where: { $0.clave == partes[1] }) else {
            return notas
        }
        return notas.conTextos(en: textos)
    }

    /// La notación guardada con esa clave, con la octava como subíndice (La₄) si `octavasEnSubindice`.
    public static func desde(clave: String, octavasEnSubindice: Bool) -> Notacion {
        desde(clave: clave).conOctavas(octavasEnSubindice ? .subindices : .cifras)
    }

    /// El idioma elegido para los textos, o `nil` si van en el de las notas.
    public var idiomaElegidoParaLosTextos: Idioma? {
        esCombinada ? textos : nil
    }

    /// Otras notas, conservando el idioma elegido para los textos.
    public func conNotas(_ notas: Notacion) -> Notacion {
        idiomaElegidoParaLosTextos.map { notas.conTextos(en: $0) } ?? notas.notas
    }

    /// Los mismos nombres de nota con los textos en otro idioma, o en el de las notas si es `nil`.
    public func conTextosElegidos(_ idioma: Idioma?) -> Notacion {
        idioma.map { conTextos(en: $0) } ?? notas
    }

    /// Mensaje legible de un error del motor, en el idioma de esta notación.
    public func mensaje(de error: Error) -> String {
        (error as? ErrorDeLectura)?.descripcion(en: self)
            ?? (error as? ErrorDeImportacion)?.descripcion(en: self)
            ?? error.localizedDescription
    }
}

extension EscrituraDeNotas {
    /// Cómo se llama cada escritura en el selector: el idioma en su lengua y un ejemplo escrito con ella,
    /// «Español (Fa sostenido)», «English (F#)», «Deutsch (Fis)», «Русский (фа-диез)».
    public var titulo: String {
        "\(idioma.titulo) (\(EscrituraDeNotas.ejemplo.nombre(en: Notacion(escritura: self))))"
    }

    /// El Fa♯ con el que se muestra cada escritura en el selector.
    private static let ejemplo = Nota(.fa, .sostenido)

    /// El nombre con que se guarda en los ajustes: el del idioma y, en los que tienen variantes, la suya
    /// («espanol», «espanolASCII», «espanolUnicode»).
    public var clave: String {
        guard idioma.reglas.tieneVariantes, !conPalabras else { return idioma.clave }
        return idioma.clave + (usaASCII ? "ASCII" : "Unicode")
    }
}

extension Idioma {
    /// Cómo se llama cada idioma en el selector de los textos.
    public var titulo: String {
        switch self {
        case .espanol: return "Español"
        case .ingles: return "English"
        case .catalan: return "Català"
        case .gallego: return "Galego"
        case .asturiano: return "Asturianu"
        case .aragones: return "Aragonés"
        case .euskera: return "Euskara"
        case .portugues: return "Português"
        case .frances: return "Français"
        case .occitano: return "Occitan"
        case .italiano: return "Italiano"
        case .aleman: return "Deutsch"
        case .griego: return "Ελληνικά"
        case .ruso: return "Русский"
        }
    }

    /// El nombre con que se guarda en los ajustes.
    public var clave: String {
        switch self {
        case .espanol: return "espanol"
        case .ingles: return "ingles"
        case .catalan: return "catalan"
        case .gallego: return "gallego"
        case .asturiano: return "asturiano"
        case .aragones: return "aragones"
        case .euskera: return "euskera"
        case .portugues: return "portugues"
        case .frances: return "frances"
        case .occitano: return "occitano"
        case .italiano: return "italiano"
        case .aleman: return "aleman"
        case .griego: return "griego"
        case .ruso: return "ruso"
        }
    }
}
