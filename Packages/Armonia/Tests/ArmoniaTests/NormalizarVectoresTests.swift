import XCTest
@testable import ArmoniaTeoria

/// `TipoDeEscala.normalizar` contra los casos de `Scripts/vectores/normalizar.tsv`, que también lee
/// `Scripts/normalizar_escalas.py` (la copia en Python que usan los scripts del repositorio): así las dos no se separan.
final class NormalizarVectoresTests: XCTestCase {
    func testNormalizarCumpleLosCasosCompartidos() throws {
        // …/Packages/Armonia/Tests/ArmoniaTests/<este fichero> → la raíz del repositorio, cinco niveles más arriba.
        var raiz = URL(fileURLWithPath: #filePath)
        for _ in 0..<5 { raiz.deleteLastPathComponent() }
        let ruta = raiz.appendingPathComponent("Scripts/vectores/normalizar.tsv")
        guard let texto = try? String(contentsOf: ruta, encoding: .utf8) else {
            throw XCTSkip("No está \(ruta.path): el paquete se prueba fuera del repositorio")
        }
        var casos = 0
        for (n, linea) in texto.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            if linea.isEmpty || linea.hasPrefix("#") { continue }
            let columnas = linea.split(separator: "\t", omittingEmptySubsequences: false).map(String.init)
            guard columnas.count == 2 else { XCTFail("línea \(n + 1): se esperaban dos columnas"); continue }
            XCTAssertEqual(TipoDeEscala.normalizar(columnas[0]), columnas[1], "línea \(n + 1): «\(columnas[0])»")
            casos += 1
        }
        XCTAssertGreaterThan(casos, 10)
    }
}
