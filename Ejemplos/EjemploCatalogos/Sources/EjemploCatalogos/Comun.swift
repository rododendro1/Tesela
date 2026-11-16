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

/// Las columnas de los alias y las variantes en español y, después, en los demás idiomas, idioma a idioma: «alias»,
/// «variantes», «alias_en_ingles», «variantes_en_ingles», «alias_en_catalan»…
let columnasDeAliasYVariantes: [String] =
    ["alias", "variantes"] + traducciones.flatMap { ["alias_en_\($0.rawValue)", "variantes_en_\($0.rawValue)"] }

/// El nombre de un elemento en español y en los demás idiomas, en el orden de `columnasDeNombres`.
func nombres(de elemento: some ElementoConNombre) -> [String] {
    [elemento.nombre] + traducciones.map { elemento.nombre(en: .delIdioma($0)) }
}

/// Los alias y las variantes de un elemento en español y en los demás idiomas, en el orden de
/// `columnasDeAliasYVariantes`.
func aliasYVariantes(de elemento: some ElementoConNombre) -> [String] {
    ([Idioma.espanol] + traducciones).flatMap { idioma -> [String] in
        let notacion = Notacion.delIdioma(idioma)
        return [elemento.alias(en: notacion), elemento.variantes(en: notacion)].map { $0.joined(separator: " · ") }
    }
}

/// Las columnas de la fecha de un elemento: el año y la época en que aparece, y la obra que documenta su nombre.
let columnasDeLaFecha = ["anio_de_origen", "epoca_de_origen", "documentada_en"]

/// El año y la época en que aparece un elemento y la cita de la obra que documenta su nombre (`documentada`), en el
/// orden de `columnasDeLaFecha`; vacíos si no se saben.
func fecha(de elemento: some ElementoConNombre) -> [String] {
    [
        elemento.anioDeOrigen.map(String.init) ?? "", elemento.epocaDeOrigen?.nombre ?? "",
        elemento.documentada?.cita ?? "",
    ]
}

/// Una clave en camelCase, como las del JSON, en snake_case, como las demás columnas: «numeroDeNotas» da
/// «numero_de_notas».
func enSnakeCase(_ clave: String) -> String {
    clave.reduce(into: "") { texto, letra in
        texto += letra.isUppercase ? "_" + letra.lowercased() : String(letra)
    }
}

/// Las columnas del carácter de un elemento: sus afectos, sus momentos y lo que dice cada fuente, con su cita.
let columnasDelCaracter = ["afectos", "momentos", "caracter"]

/// El carácter de un elemento, en el orden de `columnasDelCaracter`; vacíos si no tiene.
func caracter(de elemento: some ElementoConNombre) -> [String] {
    let espanol = Notacion.compacta(.espanol)
    return [
        elemento.afectos.map(\.nombre).joined(separator: " · "),
        elemento.momentos.map(\.nombre).joined(separator: " · "),
        elemento.caracter.map { $0.descripcion(en: espanol) + " (" + $0.cita(en: espanol) + ")" }
            .joined(separator: "; "),
    ]
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
