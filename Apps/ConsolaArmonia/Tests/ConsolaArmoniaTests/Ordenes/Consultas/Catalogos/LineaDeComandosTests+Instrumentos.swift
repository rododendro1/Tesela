import Foundation
import Testing

@testable import ConsolaArmonia

// Los catálogos de instrumentos de cuerda y de ornamentos en la consola: `instrumentos` y `ornamentos`, con su ficha y
// en JSON.

extension LineaDeComandosTests {
    /// `instrumentos`: cada uno con su afinación y sus cuerdas; con `--familia`, los de unos trastes.
    @Test func instrumentosDeCuerda() {
        let todos = salida("instrumentos")
        #expect(todos.hasPrefix("guitarra: Mi₂ La₂ Re₃ Sol₃ Si₃ Mi₄ · 6\n"), Comment(rawValue: todos))
        #expect(todos.contains("\nmandolina: Sol₃ Re₄ La₄ Mi₅ · 4 órdenes, 8 cuerdas\n"))
        #expect(salida("instrumentos mandolina") == "mandolina: Sol₃ Re₄ La₄ Mi₅ · 4 órdenes, 8 cuerdas\n")
        #expect(
            salida("instrumentos doce")
                == "guitarra de doce cuerdas: Mi₂ La₂ Re₃ Sol₃ Si₃ Mi₄ · 6 órdenes, 12 cuerdas\n")
        #expect(salida("instrumentos --familia diatonicos") == "dulcémele de los Apalaches: Re₃ La₃ Re₄ · 3\n")
        let sinTrastes = salida("instruments --family fretless --ingles")
        #expect(sinTrastes.hasPrefix("oud: "), Comment(rawValue: sinTrastes))
        #expect(sinTrastes.contains("\nviolin: G3 D4 A4 E5 · 4\n"))
        let agrupados = salida("instrumentos --agrupar continente")
        #expect(agrupados.contains("Europa ("), Comment(rawValue: agrupados))
        #expect(agrupados.contains("\n  mandolina: "))
        let ninguno = resultado("instrumentos", "zzz")
        #expect(ninguno.codigo == 1 && ninguno.error.contains("ningún instrumento"))
        let familia = resultado("instrumentos", "--familia", "diatonico")
        #expect(familia.codigo == 2 && familia.error.contains("no es una familia de instrumentos"))
        #expect(familia.error.contains("diatonicos"), Comment(rawValue: familia.error))
    }

    /// `instrumentos --familia` con una familia, y `--agrupar familia`.
    @Test func instrumentosPorFamilias() throws {
        let frotada = salida("instruments --family bowed-strings --ingles")
        #expect(
            frotada
                == "violin: G3 D4 A4 E5 · 4\nviola: C3 G3 D4 A4 · 4\ncello: C2 G2 D3 A3 · 4\ndouble bass: E1 A1 D2 G2 · 4\n"
        )
        let agrupados = salida("instrumentos --agrupar familia")
        #expect(agrupados.hasPrefix("guitarras (12)\n  guitarra: "), Comment(rawValue: agrupados))
        #expect(agrupados.contains("\ncuerda frotada (4)\n  violín: "))
        #expect(salida("instrumentos --familia banjos-y-citaras --agrupar familia").hasPrefix("banjos y cítaras (2)\n"))
        let datos = try #require(try json("instrumentos violín") as? [[String: Any]])
        #expect(datos.first?["familiaId"] as? String == "cuerdaFrotada")
    }

    /// `instrumentos … --estadisticas` y `--json`: la ficha, con los órdenes en octavas y los trastes.
    @Test func instrumentosDeCuerdaConFicha() throws {
        let charango = salida("instrumentos charango --estadisticas")
        #expect(charango.contains("\n  Cuerdas: 5 órdenes, 10 cuerdas\n"), Comment(rawValue: charango))
        #expect(charango.contains("\n  Trastes: cromáticos\n"))
        #expect(charango.contains("3: Mi₅ Mi₄"), Comment(rawValue: charango))
        let datos = try #require(try json("instrumentos dulcémele") as? [[String: Any]])
        #expect(datos.count == 1 && datos[0]["trastesId"] as? String == "diatonicos")
        #expect(datos[0]["cuerdasReales"] as? Int == 3)
    }

    /// `ornamentos`: cada uno con sus pasos; con `--sobre` y `--en`, lo que suena.
    @Test func ornamentosDelCatalogo() {
        let todos = salida("ornamentos")
        #expect(todos.hasPrefix("trino: +1 0 +1 0 +1 0 +1 0\n"), Comment(rawValue: todos))
        #expect(todos.contains("\nSchleifer: −2 −1 0\n"))
        #expect(salida("ornamentos grupeto --sobre Re4 --en Do mayor") == "grupeto: +1 0 −1 0 · Mi₄ Re₄ Do₄ Re₄\n")
        // Sin octava, en la cuarta; sin escala, en la mayor de la nota.
        #expect(salida("ornamentos mordente --sobre Mi") == "mordente: 0 −1 0 · Mi₄ Re♯₄ Mi₄\n")
        #expect(salida("ornaments turn --over D4 --in C major --ingles") == "turn: +1 0 −1 0 · E4 D4 C4 D4\n")
        let ninguno = resultado("ornamentos", "zzz")
        #expect(ninguno.codigo == 1 && ninguno.error.contains("ningún ornamento"))
        let fuera = resultado("ornamentos", "trino", "--sobre", "Fa#4", "--en", "Do", "mayor")
        #expect(fuera.codigo == 2 && fuera.error.contains("no es una nota de Do mayor"), Comment(rawValue: fuera.error))
    }

    /// `ornamentos … --estadisticas` y `--json`: la ficha, con lo que suena y la época.
    @Test func ornamentosConFicha() throws {
        let grupeto = salida("ornamentos grupeto --sobre Re4 --en Do mayor --estadisticas")
        #expect(grupeto.contains("\n  Suena: Mi₄ Re₄ Do₄ Re₄\n"), Comment(rawValue: grupeto))
        #expect(grupeto.contains("\n  Otros nombres: gruppetto\n"))
        let datos = try #require(try json("ornamentos schleifer --sobre Sol4") as? [[String: Any]])
        #expect(datos.count == 1 && datos[0]["pasos"] as? [Int] == [-2, -1, 0])
        #expect(datos[0]["alturas"] as? [String] == ["Mi₄", "Fa♯₄", "Sol₄"])
        let sinAlturas = try #require(try json("ornamentos trino corto") as? [[String: Any]])
        #expect(sinAlturas.count == 1 && sinAlturas[0]["alturas"] == nil)
    }
}
