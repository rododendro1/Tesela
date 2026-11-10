import Foundation
import Testing

@testable import ConsolaArmonia

// El catálogo de ritmos en la consola: `ritmos`, con sus medidas, sus distancias y en JSON.

extension LineaDeComandosTests {
    /// `ritmos`: cada ritmo con su patrón y su compás; con un nombre, solo ese; con `--familia`, los de una familia.
    @Test func ritmos() {
        let todos = salida("ritmos")
        #expect(todos.hasPrefix("tresillo: x..x..x. · 4/4\n"), Comment(rawValue: todos))
        #expect(salida("ritmos son clave") == "clave de son: x..x..x...x.x... · 4/4\n")
        let talas = salida("rhythms --family tala --ingles")
        #expect(talas.hasPrefix("tīntāl: xoooxoooooooxooo"), Comment(rawValue: talas))
        #expect(!talas.contains("clave"))
        #expect(salida("ritmos --familia tāla de la India").contains("ektāl"))
        let ninguno = resultado("ritmos", "clave", "--familia", "tala")
        #expect(ninguno.codigo == 1 && ninguno.error.contains("ningún ritmo"))
    }

    /// `ritmos … --estadisticas` y `--comparar`: la ficha, las medidas de Toussaint y las distancias.
    @Test func ritmosConEstadisticas() throws {
        let texto = salida("ritmos clave de son --estadisticas --comparar clave de rumba")
        #expect(texto.contains("\n  Agrupación: 4 + 4 + 4 + 4\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Vector de distancias: [0, 1, 2, 2, 0, 3, 2, 0]\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Distancia de Hamming (clave de rumba): 2\n"), Comment(rawValue: texto))
        #expect(salida("ritmos tresillo --estadisticas").contains("\n  Propiedades: euclídeo · profundo (Erdős)\n"))
        let datos = try #require(try json("ritmos clave de son --comparar clave de rumba") as? [[String: Any]])
        let ritmo = try #require(datos[0]["ritmo"] as? [String: Any])
        #expect(ritmo["patron"] as? String == "x..x..x...x.x...")
        #expect((datos[0]["relacion"] as? [String: Any])?["distanciaDeIntercambio"] as? Int == 1)
    }

    /// Una familia o un ritmo que no existen: el error, con una propuesta.
    @Test func ritmosConErrores() {
        let familia = resultado("ritmos", "--familia", "flamneco")
        #expect(familia.codigo == 2 && familia.error.contains("no es una familia de ritmos"))
        #expect(familia.error.contains("flamenco"), Comment(rawValue: familia.error))
        let ritmo = resultado("ritmos", "--comparar", "tresilo")
        #expect(ritmo.codigo == 2 && ritmo.error.contains("no es un ritmo del catálogo"))
        #expect(ritmo.error.contains("tresillo"), Comment(rawValue: ritmo.error))
    }
}
