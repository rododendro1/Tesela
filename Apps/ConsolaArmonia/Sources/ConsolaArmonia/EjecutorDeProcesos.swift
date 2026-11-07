import Foundation

// Los programas externos de `armonia grabar` (LilyPond, MuseScore, Verovio, rsvg-convert…): cómo se encuentran y
// cómo se ejecutan. La orden no llama a `Process` directamente, sino a `LineaDeComandos.ejecutor`, así que las
// pruebas ponen uno que no ejecuta nada (`LineaDeComandos.$ejecutor.withValue(falso) { … }`) y comprueban qué se le
// pidió.

/// Lo que deja un programa externo al terminar.
public struct ResultadoDeProceso: Equatable, Sendable {
    /// El código de salida: 0 si fue bien.
    public var codigo: Int32
    /// Lo que escribió en la salida estándar: el SVG, en los programas que lo dan por ahí (`guido2svg`).
    public var salida: Data
    /// Lo que escribió en la salida de errores.
    public var error: String
    /// Si se paró porque pasó el tiempo límite.
    public var agotado: Bool

    public init(codigo: Int32, salida: Data = Data(), error: String = "", agotado: Bool = false) {
        self.codigo = codigo
        self.salida = salida
        self.error = error
        self.agotado = agotado
    }
}

/// Quien busca y ejecuta los programas externos.
public protocol EjecutorDeProcesos: Sendable {
    /// La ruta del programa, o `nil` si no está instalado.
    func buscar(_ programa: String) -> String?

    /// Ejecuta el programa de `ruta` con esos argumentos, sin pasar por una shell, en `carpeta`, y espera a que
    /// termine, o lo para si tarda más de `limite` segundos. Los ficheros que lee y escribe están en esa carpeta.
    func ejecutar(
        _ ruta: String, _ argumentos: [String], en carpeta: URL, limite: TimeInterval
    ) throws -> ResultadoDeProceso
}

/// El ejecutor de verdad, con `Process`.
public struct EjecutorDelSistema: EjecutorDeProcesos {
    /// Las variables de entorno: `PATH` y las `ARMONIA_…` que dan la ruta de cada programa. Son también las que
    /// reciben los programas.
    public var entorno: [String: String]

    public init(entorno: [String: String] = ProcessInfo.processInfo.environment) {
        self.entorno = entorno
    }

    /// La variable de entorno que da la ruta de un programa: `ARMONIA_LILYPOND`, `ARMONIA_RSVG_CONVERT`,
    /// `ARMONIA_MSCORE`.
    public static func variable(de programa: String) -> String {
        "ARMONIA_" + programa.uppercased().replacingOccurrences(of: "-", with: "_")
    }

    /// La de su variable (`ARMONIA_LILYPOND`) si la tiene; si no, la primera carpeta del `PATH` que lo tenga, y
    /// después las de Homebrew y `/usr/local/bin`, que no siempre están en el `PATH` de una app de macOS, y las de
    /// MuseScore en macOS, que no deja `mscore` en ninguna de ellas.
    public func buscar(_ programa: String) -> String? {
        let gestor = FileManager.default
        if let ruta = entorno[Self.variable(de: programa)], !ruta.isEmpty {
            return gestor.isExecutableFile(atPath: ruta) ? ruta : nil
        }
        let carpetas =
            (entorno["PATH"] ?? "").split(separator: ":").map(String.init) + Self.otrasCarpetas
        return carpetas.lazy.map { $0 + "/" + programa }.first { gestor.isExecutableFile(atPath: $0) }
    }

    /// Las carpetas donde se busca después de las del `PATH`.
    static let otrasCarpetas = [
        "/opt/homebrew/bin", "/usr/local/bin", "/Applications/MuseScore 4.app/Contents/MacOS",
        "/Applications/MuseScore 3.app/Contents/MacOS",
    ]

    public func ejecutar(
        _ ruta: String, _ argumentos: [String], en carpeta: URL, limite: TimeInterval
    ) throws -> ResultadoDeProceso {
        // Las salidas van a ficheros y no a tuberías: una tubería llena bloquearía al programa.
        let salida = carpeta.appendingPathComponent(".salida-del-programa")
        let errores = carpeta.appendingPathComponent(".errores-del-programa")
        try Data().write(to: salida)
        try Data().write(to: errores)
        let manejadorDeSalida = try FileHandle(forWritingTo: salida)
        defer { try? manejadorDeSalida.close() }
        let manejadorDeErrores = try FileHandle(forWritingTo: errores)
        defer { try? manejadorDeErrores.close() }
        let proceso = Process()
        proceso.executableURL = URL(fileURLWithPath: ruta)
        proceso.arguments = argumentos
        proceso.currentDirectoryURL = carpeta
        proceso.environment = Self.variablesDelPrograma(entorno)
        proceso.standardInput = FileHandle.nullDevice
        proceso.standardOutput = manejadorDeSalida
        proceso.standardError = manejadorDeErrores
        try proceso.run()
        let fin = Date().addingTimeInterval(limite)
        while proceso.isRunning && Date() < fin { Thread.sleep(forTimeInterval: 0.02) }
        let agotado = proceso.isRunning
        if agotado { proceso.terminate() }
        proceso.waitUntilExit()
        let texto = (try? String(contentsOf: errores, encoding: .utf8)) ?? ""
        return ResultadoDeProceso(
            codigo: proceso.terminationStatus, salida: (try? Data(contentsOf: salida)) ?? Data(), error: texto,
            agotado: agotado)
    }

    /// Las variables con que se ejecuta un programa: las de `entorno` y, en un Linux sin pantalla, la que deja a
    /// MuseScore (que usa Qt) dibujar sin ella.
    static func variablesDelPrograma(_ entorno: [String: String]) -> [String: String] {
        var variables = entorno
        #if os(Linux)
            if variables["DISPLAY"] == nil, variables["WAYLAND_DISPLAY"] == nil, variables["QT_QPA_PLATFORM"] == nil {
                variables["QT_QPA_PLATFORM"] = "offscreen"
            }
        #endif
        return variables
    }
}
