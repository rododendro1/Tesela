import Armonia
import Foundation

// Recorre `ProgresionConNombre.catalogo` (las cadencias, el barroco, el galante y las danzas, el jazz y el blues, y el
// pop, en su orden) y escribe una fila por progresión con lo que dice de ella la API pública: nombres (y su traducción
// a los otros doce idiomas), modo, cifrado romano, acordes sobre Do, si `EsquemaArmonico` la reconoce en sus propios
// acordes, estilos y las obras que la citan. Las listas de una celda van separadas por espacios (grados, acordes) o
// por « · » (alias, variantes, estilos, citas); una celda vacía es un dato que la progresión no tiene, y las de sí o
// no dicen «sí» o «no».
//
//     swift run EjemploCatalogoDeProgresiones [fichero | -] [--bibtex <fichero.bib>]
//
// `--bibtex` escribe además las obras citadas por las progresiones, sin repetir, en BibTeX.

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

func siONo(_ valor: Bool) -> String { valor ? "sí" : "no" }

/// Los idiomas a los que se traduce el nombre, en el orden de `Idioma.allCases`: todos menos el español.
let traducciones = Idioma.allCases.filter { $0 != .espanol }

let columnas: [String] =
    ["nombre"] + traducciones.map { "nombre_en_\($0.rawValue)" } + [
        "alias", "variantes", "modo", "numero_de_acordes", "cifrado", "acordes_sobre_do", "se_reconoce", "estilos",
        "referencias",
    ]

/// La fila de una progresión, en el orden de `columnas`.
func fila(_ progresion: ProgresionConNombre) -> [String] {
    let comoSeLlama = [progresion.nombre] + traducciones.map { progresion.nombre(en: .delIdioma($0)) }
    let acordes = progresion.acordes(sobre: .do)
    let reconocida = EsquemaArmonico.buscar(en: acordes).contains { $0.tipo == progresion && $0.inicio == 0 }
    let resto: [String] = [
        progresion.alias.joined(separator: " · "),
        progresion.variantes.joined(separator: " · "),
        progresion.modo.nombre,
        String(progresion.grados.count),
        progresion.cifrado,
        acordes.map(\.cifrado).joined(separator: " "),
        siONo(reconocida),
        progresion.estilos.map(\.nombre).joined(separator: " · "),
        progresion.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + resto
}

var destino = "catalogo-de-progresiones.tsv"
// MARK: - Argumentos

/// Termina con un mensaje en la salida de errores.
func fallar(_ mensaje: String) -> Never {
    FileHandle.standardError.write(Data((mensaje + "\n").utf8))
    exit(1)
}

var destinoBibTeX: String?
var argumentos = CommandLine.arguments.dropFirst()
while let argumento = argumentos.popFirst() {
    switch argumento {
    case "--bibtex":
        guard let fichero = argumentos.popFirst() else { fallar("Falta el fichero después de --bibtex") }
        destinoBibTeX = fichero
    default:
        destino = argumento
    }
}

// MARK: - Salida

let tsv =
    ([columnas] + ProgresionConNombre.catalogo.map(fila)).map { $0.map(celda).joined(separator: "\t") }.joined(
        separator: "\n") + "\n"

/// Escribe un texto en un fichero, o en la salida estándar si el fichero es «-».
func escribir(_ texto: String, en fichero: String) {
    if fichero == "-" {
        print(texto, terminator: "")
        return
    }
    do {
        try texto.write(toFile: fichero, atomically: true, encoding: .utf8)
    } catch {
        fallar("No se pudo escribir \(fichero): \(error)")
    }
}

func lugar(_ fichero: String) -> String { fichero == "-" ? "la salida estándar" : fichero }

var resumen = ["\(ProgresionConNombre.catalogo.count) progresiones en \(lugar(destino))"]
escribir(tsv, en: destino)
if let destinoBibTeX {
    let obras = Referencia.sinRepetir(ProgresionConNombre.catalogo.flatMap(\.referencias))
    escribir(Referencia.bibtex(obras), en: destinoBibTeX)
    resumen.append("\(obras.count) obras en \(lugar(destinoBibTeX))")
}
// Con algo en la salida estándar, el resumen va a la de errores para no mezclarse con ello.
let texto = resumen.joined(separator: "\n") + "\n"
if destino == "-" || destinoBibTeX == "-" {
    FileHandle.standardError.write(Data(texto.utf8))
} else {
    print(texto, terminator: "")
}
