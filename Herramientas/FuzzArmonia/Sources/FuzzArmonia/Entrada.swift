import Foundation
import LecturaAlAzar

#if FUZZING
    /// La entrada de libFuzzer: la llama con cada caso que prueba.
    @_cdecl("LLVMFuzzerTestOneInput")
    public func probar(_ inicio: UnsafePointer<UInt8>, _ cantidad: Int) -> CInt {
        LecturaAlAzar.leer(Data(bytes: inicio, count: cantidad))
        return 0
    }

    // SwiftPM cambia el nombre del `main` de un ejecutable (para poder probarlo), así que el de libFuzzer no se
    // usa: este le pasa los argumentos a su bucle, `LLVMFuzzerRunDriver`.
    @_silgen_name("LLVMFuzzerRunDriver")
    private func bucleDeLibFuzzer(
        _ argc: UnsafeMutablePointer<CInt>,
        _ argv: UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>>,
        _ probar: @convention(c) (UnsafePointer<UInt8>, Int) -> CInt
    ) -> CInt

    @main enum FuzzArmonia {
        static func main() {
            var argc = CommandLine.argc
            var argv = CommandLine.unsafeArgv
            exit(bucleDeLibFuzzer(&argc, &argv) { probar($0, $1) })
        }
    }
#else
    /// Sin libFuzzer: `--semillas carpeta` escribe los ficheros de partida, y con ficheros (los `crash-…` que deja
    /// un fallo) los vuelve a leer, uno detrás de otro, para repetirlo con el depurador o con más mensajes.
    @main enum FuzzArmonia {
        static func main() throws {
            var argumentos = Array(CommandLine.arguments.dropFirst())
            if argumentos.first == "--semillas", argumentos.count == 2 {
                let carpeta = URL(fileURLWithPath: argumentos[1], isDirectory: true)
                try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
                let semillas = try LecturaAlAzar.semillas()
                for (nombre, datos) in semillas {
                    try datos.write(to: carpeta.appendingPathComponent(nombre))
                }
                print("\(semillas.count) ficheros en \(carpeta.path)")
                return
            }
            guard !argumentos.isEmpty, !argumentos.contains(where: { $0.hasPrefix("-") }) else {
                print("Uso: FuzzArmonia --semillas carpeta | FuzzArmonia fichero…")
                exit(2)
            }
            argumentos.sort()
            for ruta in argumentos {
                let datos = try Data(contentsOf: URL(fileURLWithPath: ruta))
                let lector = datos.first.map { LecturaAlAzar.lectores[Int($0) % LecturaAlAzar.lectores.count] }
                print("\(ruta): \(datos.count) bytes, \(lector?.nombre ?? "vacío")")
                LecturaAlAzar.leer(datos)
            }
            print("Leídos sin fallos.")
        }
    }
#endif
