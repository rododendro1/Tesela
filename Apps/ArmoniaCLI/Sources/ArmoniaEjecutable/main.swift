import ArmoniaCLI
import Foundation

let resultado = LineaDeComandos.ejecutar(
    Array(CommandLine.arguments.dropFirst()),
    entrada: { String(decoding: FileHandle.standardInput.readDataToEndOfFile(), as: UTF8.self) },
    entradaEsTerminal: isatty(STDIN_FILENO) != 0,
    salidaEsTerminal: isatty(STDOUT_FILENO) != 0)
if let datos = resultado.datos {
    FileHandle.standardOutput.write(datos)
} else {
    FileHandle.standardOutput.write(Data(resultado.salida.utf8))
}
FileHandle.standardError.write(Data(resultado.error.utf8))
exit(resultado.codigo)
