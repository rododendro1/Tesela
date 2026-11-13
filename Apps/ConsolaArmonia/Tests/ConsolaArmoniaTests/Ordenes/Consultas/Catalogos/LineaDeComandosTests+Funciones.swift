import Foundation
import Testing

@testable import ConsolaArmonia

// El catálogo de funciones de nota en la consola: `funciones`, con su ficha y en JSON.

extension LineaDeComandosTests {
    /// `funciones`: cada una con su familia y su intervalo desde la tónica; con `--familia`, las de una.
    @Test func funcionesDeNota() {
        let todas = salida("funciones")
        #expect(todas.hasPrefix("tónica: grados de la escala · 1ª justa\n"), Comment(rawValue: todas))
        #expect(todas.contains("\ntenor: notas del modo gregoriano\n"))
        #expect(salida("funciones leading tone") == "sensible: grados de la escala · 7ª mayor\n")
        let adornos = salida("functions --family ornament --ingles")
        #expect(adornos == "acciaccatura: ornaments\nmordent: ornaments\nturn: ornaments\ntrill: ornaments\n")
        #expect(salida("funciones --familia notas del rāga").contains("vādī"))
        let ninguna = resultado("funciones", "trino", "--familia", "blues")
        #expect(ninguna.codigo == 1 && ninguna.error.contains("ninguna función"))
        let familia = resultado("funciones", "--familia", "adorn")
        #expect(familia.codigo == 2 && familia.error.contains("no es una familia de funciones de nota"))
        #expect(familia.error.contains("adorno"), Comment(rawValue: familia.error))
    }

    /// `funciones … --estadisticas` y `--json`: la ficha, con los cents y el desvío.
    @Test func funcionesDeNotaConFicha() throws {
        let texto = salida("funciones séptima blue --estadisticas")
        #expect(texto.contains("\n  Cents desde la tónica: 968.826\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Desvío del temperado: −31.174 ¢\n"), Comment(rawValue: texto))
        let datos = try #require(try json("funciones dominante") as? [[String: Any]])
        #expect(datos.count == 1 && datos[0]["cents"] as? Double == 700)
    }
}
