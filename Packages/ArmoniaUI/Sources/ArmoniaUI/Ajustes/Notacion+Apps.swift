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
        return .espanolCompacto
    }

    /// La notación guardada con esa clave; si no existe, el español con ♯ y ♭. Lee también las claves de antes
    /// de las notaciones compactas («espanolUnicode», «inglesUnicode»).
    public static func desde(clave: String) -> Notacion {
        let partes = clave.split(separator: "+", maxSplits: 1).map(String.init)
        let clave = partes.first.map { clavesAntiguas[$0] ?? $0 }
        let notas = allCases.first { $0.clave == clave } ?? .espanolCompacto
        guard partes.count == 2, let textos = Idioma.allCases.first(where: { $0.clave == partes[1] }) else {
            return notas
        }
        return notas.conTextos(en: textos)
    }

    /// Las claves que se guardaban antes con otro nombre, con la de ahora.
    private static let clavesAntiguas = ["espanolUnicode": "espanolCompacto", "inglesUnicode": "inglesCompacto"]

    /// La notación guardada con esa clave, con la octava como subíndice (La₄) si `octavasEnSubindice` y con cifras
    /// (La4) si no, también en las notaciones compactas: en las apps manda el ajuste.
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
    /// «Español (Fa sostenido)», «English (F#)», «Deutsch (Fis)», «Deutsch (F Kreuz)»,
    /// «Русский (фа-диез)».
    public var titulo: String {
        "\(idioma.titulo) (\(EscrituraDeNotas.ejemplo.nombre(en: Notacion(escritura: self))))"
    }

    /// El Fa♯ con el que se muestra cada escritura en el selector.
    private static let ejemplo = Nota(.fa, .sostenido)

    /// El nombre con que se guarda en los ajustes: el del idioma y, en los que tienen variantes, la suya
    /// («espanol», «espanolASCII», «espanolCompacto»; «aleman», «alemanCompacto»).
    public var clave: String {
        guard idioma.reglas.alteraciones != .palabras, !conPalabras else { return idioma.clave }
        return idioma.clave + (usaASCII && idioma.reglas.tieneVariantes ? "ASCII" : "Compacto")
    }
}

extension Idioma {
    /// Cómo se llama cada idioma en el selector de los textos: su `nombrePropio` («Euskara», «Deutsch»).
    public var titulo: String { nombrePropio }

    /// El nombre con que se guarda en los ajustes: el del caso («euskera», «aleman»).
    public var clave: String { rawValue }
}
