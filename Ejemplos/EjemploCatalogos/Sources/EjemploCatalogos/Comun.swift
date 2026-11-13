import Armonia
import Foundation

// Lo que comparten todos los catálogos: cómo se escribe una celda, un número o una lista.

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

func siONo(_ valor: Bool) -> String { valor ? "sí" : "no" }

/// Un número con tres decimales como mucho: «696.578», «700».
func numero(_ valor: Double?) -> String {
    valor.map { Redondeo.texto($0) } ?? ""
}

func lista(_ valores: [Int]) -> String { valores.map(String.init).joined(separator: " ") }
func lista(_ valores: [Double]) -> String { valores.map(numero).joined(separator: " ") }
func citas(_ referencias: [Referencia]) -> String { referencias.map(\.cita).joined(separator: " · ") }

/// Los idiomas a los que se traduce el nombre, en el orden de `Idioma.allCases`: todos menos el español.
let traducciones = Idioma.allCases.filter { $0 != .espanol }
let columnasDeNombres = ["nombre"] + traducciones.map { "nombre_en_\($0.rawValue)" }

/// Las columnas de los alias y, si los catálogos los tienen, de las variantes en los demás idiomas, idioma a idioma:
/// «alias_en_ingles», «variantes_en_ingles», «alias_en_catalan»…
func columnasDeOtrosNombres(conVariantes: Bool = true) -> [String] {
    traducciones.flatMap { idioma in
        ["alias_en_\(idioma.rawValue)"] + (conVariantes ? ["variantes_en_\(idioma.rawValue)"] : [])
    }
}

/// Las columnas de los alias y las variantes en español y, después, en los demás idiomas.
func columnasDeAliasYVariantes(conVariantes: Bool = true) -> [String] {
    (conVariantes ? ["alias", "variantes"] : ["alias"]) + columnasDeOtrosNombres(conVariantes: conVariantes)
}

/// Los alias y las variantes de un elemento en español y en los demás idiomas, en el orden de
/// `columnasDeAliasYVariantes`; sin `variantes`, solo los alias.
func aliasYVariantes(_ alias: (Notacion) -> [String], _ variantes: ((Notacion) -> [String])? = nil) -> [String] {
    ([Idioma.espanol] + traducciones).flatMap { idioma -> [String] in
        let notacion = Notacion.delIdioma(idioma)
        var listas: [[String]] = [alias(notacion)]
        if let variantes { listas.append(variantes(notacion)) }
        return listas.map { $0.joined(separator: " · ") }
    }
}

/// Un catálogo: el fichero, las columnas, una fila por elemento y las obras que citan sus elementos.
struct Catalogo {
    let fichero: String
    let columnas: [String]
    let filas: [[String]]
    var obras: [Referencia] = []

    /// El nombre con que se elige en `--solo`: el del fichero sin «.tsv».
    var nombre: String { String(fichero.dropLast(4)) }

    var tsv: String {
        ([columnas] + filas).map { $0.map(celda).joined(separator: "\t") }.joined(separator: "\n") + "\n"
    }
}

/// Termina con un mensaje en la salida de errores.
func fallar(_ mensaje: String) -> Never {
    FileHandle.standardError.write(Data((mensaje + "\n").utf8))
    exit(1)
}
