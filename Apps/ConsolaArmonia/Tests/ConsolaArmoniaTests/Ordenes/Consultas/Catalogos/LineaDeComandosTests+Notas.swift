import Foundation
import Testing

@testable import ConsolaArmonia

// El catálogo de notas en la consola: `notas`, con su ficha y en JSON.

extension LineaDeComandosTests {
    /// `notas`: cada una con su altura y su frecuencia; con `--familia`, las de una.
    @Test func notasConNombre() {
        let todas = salida("notas")
        #expect(todas.hasPrefix("La 440: La₄ · 440 Hz\n"), Comment(rawValue: todas))
        #expect(todas.contains("\nSīkāh: Mi₄ · 320.244 Hz\n"))
        #expect(salida("notas middle C") == "Do central: Do₄ · 261.626 Hz\n")
        let griegas = salida("notes --family greek --ingles")
        #expect(griegas.hasPrefix("proslambanómenos: A2 · 110 Hz"), Comment(rawValue: griegas))
        #expect(!griegas.contains("Rāst"))
        #expect(salida("notas --familia la mano guidoniana").contains("b fa ♮ mi"))
        let ninguna = resultado("notas", "Sikah", "--familia", "turca")
        #expect(ninguna.codigo == 1 && ninguna.error.contains("ninguna nota"))
        let familia = resultado("notas", "--familia", "griga")
        #expect(familia.codigo == 2 && familia.error.contains("no es una familia de notas"))
        #expect(familia.error.contains("griega"), Comment(rawValue: familia.error))
    }

    /// `notas … --estadisticas` y `--json`: la ficha, con el desvío y el nombre original.
    @Test func notasConNombreConFicha() throws {
        let texto = salida("notas Segah --estadisticas")
        #expect(texto.contains("\n  Desvío del temperado: −13.208 ¢\n"), Comment(rawValue: texto))
        let diapason = salida("notas Do 256 --estadisticas")
        #expect(diapason.contains("\n  La4: 430.539 Hz\n"), Comment(rawValue: diapason))
        let datos = try #require(try json("notas La 415") as? [[String: Any]])
        #expect(datos.count == 1 && datos[0]["frecuencia"] as? Double == 415 && datos[0]["midi"] as? Int == 69)
    }
}
