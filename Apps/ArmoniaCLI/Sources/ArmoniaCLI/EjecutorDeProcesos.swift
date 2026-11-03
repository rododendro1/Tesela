import Foundation

// Los programas externos de `armonia grabar` (LilyPond, rsvg-convert…): cómo se encuentran y cómo se ejecutan. La
// orden no llama a `Process` directamente, sino a `LineaDeComandos.ejecutor`, así que las pruebas ponen uno que no
// ejecuta nada (`LineaDeComandos.$ejecutor.withValue(falso) { … }`) y comprueban qué se le pidió.

/// Lo que deja un programa externo al terminar.
public struct ResultadoDeProceso: Equatable, Sendable {
    /// El código de salida: 0 si fue bien.
    public var codigo: Int32
    /// Lo que escribió en la salida de errores y en la estándar, juntas.
    public var error: String
    /// Si se paró porque pasó el tiempo límite.
    public var agotado: Bool

    public init(codigo: Int32, error: String = "", agotado: Bool = false) {
        self.codigo = codigo
        self.error = error
        self.agotado = agotado
    }
}

/// Quien busca y ejecuta los programas externos.
public protocol EjecutorDeProcesos: Sendable {
    /// La ruta del programa, o `nil` si no está instalado.
    func buscar(_ programa: String) -> String?

    /// Ejecuta el programa de `ruta` con esos argumentos, sin pasar por una shell, en `carpeta`, y espera a que
    /// termine. Los ficheros que lee y escribe están en esa carpeta.
    func ejecutar(_ ruta: String, _ argumentos: [String], en carpeta: URL) throws -> ResultadoDeProceso
}

/// El ejecutor de verdad, con `Process`.
public struct EjecutorDelSistema: EjecutorDeProcesos {
    /// Las variables de entorno: `PATH` y las `ARMONIA_…` que dan la ruta de cada programa.
    public var entorno: [String: String]
    /// Lo que puede tardar un programa, en segundos, antes de pararlo.
    public var limite: TimeInterval

    public init(entorno: [String: String] = ProcessInfo.processInfo.environment, limite: TimeInterval = 120) {
        self.entorno = entorno
        self.limite = limite
    }

    /// La variable de entorno que da la ruta de un programa: `ARMONIA_LILYPOND`, `ARMONIA_RSVG_CONVERT`.
    public static func variable(de programa: String) -> String {
        "ARMONIA_" + programa.uppercased().replacingOccurrences(of: "-", with: "_")
    }

    /// La de su variable (`ARMONIA_LILYPOND`) si la tiene; si no, la primera carpeta del `PATH` que lo tenga, y
    /// después las de Homebrew y `/usr/local/bin`, que no siempre están en el `PATH` de una app de macOS.
    public func buscar(_ programa: String) -> String? {
        let gestor = FileManager.default
        if let ruta = entorno[Self.variable(de: programa)], !ruta.isEmpty {
            return gestor.isExecutableFile(atPath: ruta) ? ruta : nil
        }
        let carpetas = (entorno["PATH"] ?? "").split(separator: ":").map(String.init)
            + ["/opt/homebrew/bin", "/usr/local/bin"]
        return carpetas.lazy.map { $0 + "/" + programa }.first { gestor.isExecutableFile(atPath: $0) }
    }

    public func ejecutar(_ ruta: String, _ argumentos: [String], en carpeta: URL) throws -> ResultadoDeProceso {
        // Las salidas van a un fichero y no a una tubería: una tubería llena bloquearía al programa.
        let registro = carpeta.appendingPathComponent(".salida-del-programa")
        FileManager.default.createFile(atPath: registro.path, contents: nil)
        let manejador = try FileHandle(forWritingTo: registro)
        defer { try? manejador.close() }
        let proceso = Process()
        proceso.executableURL = URL(fileURLWithPath: ruta)
        proceso.arguments = argumentos
        proceso.currentDirectoryURL = carpeta
        proceso.standardInput = FileHandle.nullDevice
        proceso.standardOutput = manejador
        proceso.standardError = manejador
        try proceso.run()
        let fin = Date().addingTimeInterval(limite)
        while proceso.isRunning && Date() < fin { Thread.sleep(forTimeInterval: 0.02) }
        let agotado = proceso.isRunning
        if agotado { proceso.terminate() }
        proceso.waitUntilExit()
        let texto = (try? String(contentsOf: registro, encoding: .utf8)) ?? ""
        return ResultadoDeProceso(codigo: proceso.terminationStatus, error: texto, agotado: agotado)
    }
}
