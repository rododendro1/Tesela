import ConsolaArmonia
import Foundation

let argumentos = Array(CommandLine.arguments.dropFirst())
let entorno = ProcessInfo.processInfo.environment
let entradaEsTerminal = isatty(STDIN_FILENO) != 0
let salidaEsTerminal = isatty(STDOUT_FILENO) != 0

/// Escribe un resultado: el fichero binario o el texto en la salida estándar, y los errores en la de errores.
func escribir(_ resultado: ResultadoDeOrden) {
    if let datos = resultado.datos {
        FileHandle.standardOutput.write(datos)
    } else {
        FileHandle.standardOutput.write(Data(resultado.salida.utf8))
    }
    FileHandle.standardError.write(Data(resultado.error.utf8))
}

// `armonia mcp`: el servidor MCP, un mensaje JSON-RPC por línea, hasta que se cierre la entrada. Con `--help`, su
// ayuda, como cualquier orden.
if argumentos.first?.lowercased() == "mcp", !argumentos.contains(where: ["--help", "-h", "--ayuda"].contains) {
    LineaDeComandos.servidorMCP(
        Array(argumentos.dropFirst()), entorno: entorno, leerLinea: { readLine() },
        escribir: { FileHandle.standardOutput.write(Data(($0 + "\n").utf8)) })
    exit(0)
}

// Sin argumentos y en la terminal, una sesión: una orden por línea.
if argumentos.isEmpty, entradaEsTerminal, salidaEsTerminal {
    LineaDeComandos.sesion(
        entorno: entorno,
        leerLinea: {
            FileHandle.standardOutput.write(Data(LineaDeComandos.indicadorDeLaSesion.utf8))
            return readLine()
        },
        escribir: escribir)
    exit(0)
}

// Sin argumentos y con la entrada en un fichero o una tubería, sus órdenes, una por línea.
if argumentos.isEmpty, !entradaEsTerminal {
    let codigo = LineaDeComandos.lote(
        entorno: entorno, salidaEsTerminal: salidaEsTerminal, leerLinea: { readLine() }, escribir: escribir)
    exit(codigo)
}

let resultado = LineaDeComandos.ejecutar(
    argumentos,
    entrada: { FileHandle.standardInput.readDataToEndOfFile() },
    entradaEsTerminal: entradaEsTerminal,
    salidaEsTerminal: salidaEsTerminal,
    entorno: entorno)
escribir(resultado)
exit(resultado.codigo)
