import Armonia
import Foundation

// Recorre `TipoDeEscala.catalogo` (las occidentales y las de otras tradiciones, en su orden) y escribe una fila por
// escala con lo que dice de ella la API pública: nombres, intervalos, tradición, categoría, fuente, usos y
// afinaciones. Las listas de una celda van separadas por espacios (intervalos, notas, cents) o por « · » (alias,
// usos), y una celda vacía es un dato que la escala no tiene.

/// Una celda de TSV: sin tabuladores ni saltos de línea, que partirían la fila.
func celda(_ texto: String) -> String {
    String(texto.map { $0 == "\t" || $0.isNewline ? " " : $0 })
}

/// Los cents con un decimal y punto decimal, sea cual sea la configuración regional: «0.0 151.0 294.1».
func cents(_ valores: [Double]) -> String {
    valores.map { String(($0 * 10).rounded() / 10) }.joined(separator: " ")
}

let columnas = [
    "nombre", "nombre_completo", "nombre_en_ingles", "alias", "tradicion", "subtradicion", "categoria", "clase",
    "fuente", "usos", "numero_de_notas", "intervalos", "semitonos", "intervalos_descendentes", "notas_sobre_do",
    "melakarta", "padre", "afinaciones", "sistema_microtonal", "cents",
]

func fila(_ tipo: TipoDeEscala) -> [String] {
    let ingles = Notacion.delIdioma(.ingles)
    let microtonal = tipo.microtonal
    return [
        tipo.nombre,
        tipo.nombreCompleto,
        tipo.nombre(en: ingles),
        tipo.alias.joined(separator: " · "),
        tipo.tradicion?.nombre ?? "",
        tipo.subtradicion?.nombre ?? "",
        tipo.categoria?.nombre ?? "",
        tipo.clase?.rawValue ?? "",
        tipo.fuente?.nombre ?? "",
        tipo.usos.map(\.nombre).joined(separator: " · "),
        String(tipo.numeroDeNotas),
        tipo.intervalos.map(\.abreviatura).joined(separator: " "),
        tipo.intervalos.map { String($0.semitonos) }.joined(separator: " "),
        tipo.intervalosDescendentes?.map(\.abreviatura).joined(separator: " ") ?? "",
        Escala(.do, tipo).notas.map(\.nombre).joined(separator: " "),
        tipo.numeroDeMelakarta.map(String.init) ?? "",
        tipo.padre?.nombre ?? "",
        String(tipo.afinaciones.count),
        microtonal?.sistema.rawValue ?? "",
        microtonal.map { cents($0.cents) } ?? "",
    ]
}

let filas = [columnas] + TipoDeEscala.catalogo.map(fila)
let tsv = filas.map { $0.map(celda).joined(separator: "\t") }.joined(separator: "\n") + "\n"

let destino = CommandLine.arguments.dropFirst().first ?? "catalogo-de-escalas.tsv"
if destino == "-" {
    print(tsv, terminator: "")
} else {
    do {
        try tsv.write(toFile: destino, atomically: true, encoding: .utf8)
        print("\(TipoDeEscala.catalogo.count) escalas en \(destino)")
    } catch {
        FileHandle.standardError.write(Data("No se pudo escribir \(destino): \(error)\n".utf8))
        exit(1)
    }
}
