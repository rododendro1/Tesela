import Armonia
import Exposicion
import Foundation

// Recorre `AcordeConNombre.catalogo` (los genéricos y después los de nombre propio, en su orden) y escribe una fila por
// acorde con lo que dice de él la API pública: nombres (y su traducción a los otros doce idiomas), intervalos, notas
// sobre Do, el cifrado y el nombre de su tipo de acorde, lo que se mide de él, estilos y las obras que lo citan. Las
// medidas son las de `MedidaDeAcorde.todas` que van al JSON, con su clave por columna y su valor en texto plano
// (`ValorDeMedida.textoPlano`): una medida nueva sale aquí sin tocar este fichero. Las listas de una celda van
// separadas por espacios (intervalos, semitonos, notas) o por « · » (alias, variantes, estilos, citas); una celda
// vacía es un dato que el acorde no tiene.
//
//     swift run EjemploCatalogoDeAcordes [fichero | -] [--bibtex <fichero.bib>]
//
// `--bibtex` escribe además las obras citadas por los acordes, sin repetir, en BibTeX.

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

/// Los idiomas a los que se traduce el nombre, en el orden de `Idioma.allCases`: todos menos el español.
let traducciones = Idioma.allCases.filter { $0 != .espanol }

/// Las medidas, en el orden en que se leen.
let medidas = MedidaDeAcorde.todas.filter(\.vaAlJSON)

/// Los nombres, como en la API: con ♭ y ♯ y en español.
let notacion = Notacion.compacta(.espanol)

let columnas: [String] =
    ["nombre"] + traducciones.map { "nombre_en_\($0.rawValue)" } + [
        "alias", "variantes", "grupo", "intervalos", "semitonos", "notas_sobre_do", "cifrado", "nombre_del_tipo",
    ] + medidas.map(\.clave) + ["estilos", "referencias"]

let genericos = Set(AcordeConNombre.genericos)

/// La fila de un acorde, en el orden de `columnas`.
func fila(_ acorde: AcordeConNombre) -> [String] {
    let comoSeLlama = [acorde.nombre] + traducciones.map { acorde.nombre(en: .delIdioma($0)) }
    let estadisticas = acorde.estadisticas
    let antes: [String] = [
        acorde.alias.joined(separator: " · "),
        acorde.variantes.joined(separator: " · "),
        genericos.contains(acorde) ? "genérico" : "nombre propio",
        acorde.intervalos.map(\.abreviatura).joined(separator: " "),
        acorde.intervalos.map { String($0.semitonos) }.joined(separator: " "),
        acorde.notas(sobre: .do).map(\.nombre).joined(separator: " "),
        acorde.tipo?.cifrado ?? "",
        acorde.tipo?.acordeConNombre?.nombre ?? "",
    ]
    // En `numeroDeNotas`, las notas distintas: el acorde de la Sinfonía de los salmos tiene cuatro voces y tres notas.
    let valores = medidas.map { $0.valor(de: estadisticas, en: notacion)?.textoPlano ?? "" }
    let despues = [
        acorde.estilos.map(\.nombre).joined(separator: " · "),
        acorde.referencias.map(\.cita).joined(separator: " · "),
    ]
    return comoSeLlama + antes + valores + despues
}

var destino = "catalogo-de-acordes.tsv"
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
    ([columnas] + AcordeConNombre.catalogo.map(fila)).map { $0.map(celda).joined(separator: "\t") }.joined(
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

var resumen = ["\(AcordeConNombre.catalogo.count) acordes en \(lugar(destino))"]
escribir(tsv, en: destino)
if let destinoBibTeX {
    let obras = Referencia.sinRepetir(AcordeConNombre.catalogo.flatMap(\.referencias))
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
