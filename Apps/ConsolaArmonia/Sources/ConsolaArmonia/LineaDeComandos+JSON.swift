import Armonia
import Exposicion
import Foundation

// MARK: - La salida en JSON
//
// Con `--json`, las consultas que lo admiten dan sus datos en JSON en lugar de texto, para leerlos desde un script o
// desde otro programa:
//
//     armonia acorde Sol7/Si --json | jq '.[0].notas'
//
// Las claves son siempre las mismas, en español y sin tildes, sea cual sea el idioma, y cambiarlas rompe a quien las
// lea. Los nombres de notas, acordes y escalas van en la notación elegida (`--ingles`, `--idioma`…), como en el
// texto, y al lado van los datos que no dependen de ella: las clases de altura (0 = Do … 11 = Si). Los errores no
// cambian: van en texto a la salida de errores, con el mismo código de salida.

extension LineaDeComandos {
    /// Lo que hace una orden con `--json` (`Orden.json`): sus datos, a partir del resto de los argumentos.
    typealias SalidaJSON = @Sendable (_ argumentos: [String], _ contexto: ContextoDeOrden) throws -> any Encodable

    /// Los datos en JSON con las claves ordenadas, para que la salida no cambie de una vez a otra: con sangría para
    /// leerlos en la terminal, o en una sola línea para un programa (`enUnaLinea`).
    static func textoJSON(_ datos: any Encodable, enUnaLinea: Bool = false) throws -> String {
        let codificador = JSONEncoder()
        codificador.outputFormatting =
            enUnaLinea
            ? [.sortedKeys, .withoutEscapingSlashes]
            : [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return String(decoding: try codificador.encode(datos), as: UTF8.self)
    }

    /// Los datos de una orden que comprueba algo (`revisar`, `contrapunto`): con faltas, la orden sale con código 3.
    protocol ConFaltas {
        var hayFaltas: Bool { get }
    }

    /// Las palabras de la orden, sin opciones: lanza el `ErrorDeUso` si queda alguna opción sin leer o si no hay
    /// ninguna palabra.
    static func palabras(_ argumentos: Argumentos, siFaltan error: ErrorDeUso) throws -> [String] {
        try argumentos.sinOpcionesDesconocidas()
        guard !argumentos.restantes.isEmpty else { throw error }
        return argumentos.restantes
    }
}
