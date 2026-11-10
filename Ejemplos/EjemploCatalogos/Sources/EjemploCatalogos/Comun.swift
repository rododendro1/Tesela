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
