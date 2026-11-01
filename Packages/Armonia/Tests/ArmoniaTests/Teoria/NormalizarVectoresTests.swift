import Foundation
import Testing

@testable import ArmoniaTeoria

/// `TipoDeEscala.normalizar` contra los casos de `Scripts/datos/normalizar.tsv`, que también lee
/// `Scripts/comprobaciones/normalizar_escalas.py` (la copia en Python que usan los scripts del repositorio): así
/// las dos no se separan.
@Suite struct NormalizarVectoresTests {
    /// …/Packages/Armonia/Tests/ArmoniaTests/Teoria/<este fichero> → la raíz, seis niveles más arriba.
    static let ruta: URL = {
        var raiz = URL(fileURLWithPath: #filePath)
        for _ in 0..<6 { raiz.deleteLastPathComponent() }
        return raiz.appendingPathComponent("Scripts/datos/normalizar.tsv")
    }()

    /// Fuera del repositorio (el paquete probado por su cuenta) no está el fichero, y la prueba no se hace.
    @Test(.enabled(if: FileManager.default.fileExists(atPath: ruta.path), "No está Scripts/datos/normalizar.tsv"))
    func normalizarCumpleLosCasosCompartidos() throws {
        let texto = try String(contentsOf: Self.ruta, encoding: .utf8)
        var casos = 0
        for (n, linea) in texto.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            if linea.isEmpty || linea.hasPrefix("#") { continue }
            let columnas = linea.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            guard columnas.count == 2 else {
                Issue.record("línea \(n + 1): se esperaban dos columnas")
                continue
            }
            #expect(TipoDeEscala.normalizar(columnas[0]) == columnas[1], "línea \(n + 1): «\(columnas[0])»")
            casos += 1
        }
        #expect(casos > 10)
    }
}
