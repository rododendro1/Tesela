import Armonia
import Foundation

// Escribe en TSV, un fichero por catálogo, lo que dice la API pública de cada uno: las escalas, los acordes, los grados, las
// progresiones, los ritmos, los temperamentos, las notas con nombre y sus funciones, las escalas microtonales, las
// referencias, los encordados, los teclados isomórficos y cuadrados, los modos gregorianos y los instrumentos de la
// partitura. Las listas de una celda van separadas por espacios (intervalos, pasos, notas) o por « · » (alias,
// estilos, citas); una celda vacía es un dato que el elemento no tiene, y las de sí o no dicen «sí» o «no».
//
//     swift run EjemploCatalogos [carpeta | -] [--solo <catálogo>]… [--tradicion <tradición>] [--bibtex <fichero.bib>]
//
// Sin carpeta, los escribe en `catalogos/`; con «-», en la salida estándar, cada uno tras «# fichero.tsv» (si es uno
// solo, sin esa línea). `--solo` deja los catálogos que se nombren, por su fichero sin «.tsv» («escalas»,
// «acordes»…); `--tradicion` deja solo las escalas de una tradición, por su nombre («india», «mundoArabe», «Japón»), y
// `--bibtex` escribe además las obras que citan los catálogos escritos, sin repetir, en BibTeX.

// MARK: - Argumentos

var destino = "catalogos"
var soloDe: Tradicion?
var elegidos: [String] = []
var destinoBibTeX: String?
var argumentos = CommandLine.arguments.dropFirst()
while let argumento = argumentos.popFirst() {
    switch argumento {
    case "--solo":
        guard let nombre = argumentos.popFirst() else { fallar("Falta el catálogo después de --solo") }
        elegidos.append(nombre)
    case "--tradicion":
        guard let nombre = argumentos.popFirst() else { fallar("Falta la tradición después de --tradicion") }
        guard let elegida = tradicion(llamada: nombre) else {
            fallar(
                "«\(nombre)» no es una tradición; son: \(Tradicion.allCases.map(\.rawValue).joined(separator: ", "))")
        }
        soloDe = elegida
    case "--bibtex":
        guard let fichero = argumentos.popFirst() else { fallar("Falta el fichero después de --bibtex") }
        destinoBibTeX = fichero
    default:
        destino = argumento
    }
}

let todos = [
    escalas(de: soloDe), acordes, progresiones, grados, ritmos, temperamentos, notas, funciones, escalasMicrotonales,
    referencias, encordados, tecladosIsomorficos, tecladosCuadrados, modosGregorianos, instrumentos,
]
for nombre in elegidos where !todos.contains(where: { $0.nombre == nombre }) {
    fallar("«\(nombre)» no es un catálogo; son: \(todos.map(\.nombre).joined(separator: ", "))")
}
let catalogos = elegidos.isEmpty ? todos : todos.filter { elegidos.contains($0.nombre) }

// MARK: - Salida

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

var resumen: [String] = []
if destino == "-" {
    for catalogo in catalogos {
        escribir((catalogos.count > 1 ? "# " + catalogo.fichero + "\n" : "") + catalogo.tsv, en: "-")
        resumen.append("\(catalogo.fichero): \(catalogo.filas.count) filas")
    }
} else {
    do {
        try FileManager.default.createDirectory(atPath: destino, withIntermediateDirectories: true)
    } catch {
        fallar("No se pudo crear \(destino): \(error)")
    }
    for catalogo in catalogos {
        let ruta = (destino as NSString).appendingPathComponent(catalogo.fichero)
        escribir(catalogo.tsv, en: ruta)
        resumen.append("\(ruta): \(catalogo.filas.count) filas")
    }
}
if let destinoBibTeX {
    let obras = Referencia.sinRepetir(catalogos.flatMap(\.obras))
    escribir(Referencia.bibtex(obras), en: destinoBibTeX)
    resumen.append("\(obras.count) obras en \(destinoBibTeX == "-" ? "la salida estándar" : destinoBibTeX)")
}
// Con algo en la salida estándar, el resumen va a la de errores para no mezclarse con ello.
let texto = resumen.joined(separator: "\n") + "\n"
if destino == "-" || destinoBibTeX == "-" {
    FileHandle.standardError.write(Data(texto.utf8))
} else {
    print(texto, terminator: "")
}
