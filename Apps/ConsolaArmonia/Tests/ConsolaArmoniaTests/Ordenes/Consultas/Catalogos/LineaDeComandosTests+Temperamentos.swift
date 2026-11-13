import Foundation
import Testing

@testable import ConsolaArmonia

// El catálogo de temperamentos en la consola: `temperamentos`, con sus medidas y en JSON.

extension LineaDeComandosTests {
    /// `temperamentos`: cada uno con sus pasos por octava, su quinta y quién lo propuso; con `--familia`, los de una.
    @Test func temperamentos() {
        let todos = salida("temperamentos")
        #expect(todos.hasPrefix("temperamento igual: 12 · 700 (Zhu Zaiyu, 1584)\n"), Comment(rawValue: todos))
        #expect(todos.contains("\n22 śruti: 22\n"))
        #expect(salida("temperamentos 31-EDO") == "31 divisiones iguales: 31 · 696.774 (Christiaan Huygens, 1691)\n")
        let circulares = salida("temperaments --family circular --ingles")
        #expect(circulares.hasPrefix("Werckmeister III: 12"), Comment(rawValue: circulares))
        #expect(!circulares.contains("meantone"))
        #expect(salida("temperamentos --familia sistemas de otras tradiciones").contains("72 moria"))
        let ninguno = resultado("temperamentos", "werckmeister", "--familia", "justa")
        #expect(ninguno.codigo == 1 && ninguno.error.contains("ningún temperamento"))
        let familia = resultado("temperamentos", "--familia", "circulr")
        #expect(familia.codigo == 2 && familia.error.contains("no es una familia de temperamentos"))
        #expect(familia.error.contains("circular"), Comment(rawValue: familia.error))
    }

    /// `temperamentos … --reloj`: el primero que se encuentra, en un reloj de cents; con `--quintas`, de quinta en
    /// quinta, si su quinta recorre todos sus pasos.
    @Test func relojDeUnTemperamento() {
        let werckmeister = salida("temperamentos werckmeister --reloj")
        #expect(werckmeister.hasPrefix("<svg"), Comment(rawValue: werckmeister))
        #expect(werckmeister.contains("<title>Werckmeister III · Círculo cromático</title>"))
        #expect(werckmeister.contains(">Mi♭</text>") && werckmeister.contains("<path"))
        let diecinueve = salida("temperamentos 19-TET --reloj --quintas --colores")
        #expect(diecinueve.contains("· Círculo de quintas</title>") && diecinueve.contains(">11</text>"))
        #expect(!diecinueve.contains("#1f4e9c\" stroke=\"#ffffff"), Comment(rawValue: diecinueve))
        #expect(salida("temperaments 53 --clock --fifths --ingles").contains("Circle of fifths</title>"))
        let cuartos = resultado("temperamentos", "cuartos de tono", "--reloj", "--quintas")
        #expect(
            cuartos.codigo == 2 && cuartos.error.contains("no tiene círculo de quintas"),
            Comment(rawValue: cuartos.error))
        #expect(resultado("temperamentos", "nadie", "--reloj").codigo == 1)
        #expect(salida("ayuda temperamentos").contains("--reloj [--quintas] [--colores]"))
    }

    /// `temperamentos … --estadisticas` y `--json`: la ficha, los errores de las razones justas y, en los de doce
    /// notas, la quinta del lobo.
    @Test func temperamentosConEstadisticas() throws {
        let texto = salida("temperamentos mesotonico --estadisticas")
        #expect(texto.contains("\n  Quinta del lobo: 737.637\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Error de las razones justas: 3/2: −5.377 · 5/4: 0 · "), Comment(rawValue: texto))
        let comas = salida("temperamentos 53 comas --estadisticas")
        #expect(comas.contains("\n  Paso menor · mayor: 22.642 (pasos iguales)\n"), Comment(rawValue: comas))
        #expect(!comas.contains("lobo"))
        let datos = try #require(try json("temperamentos Vallotti") as? [[String: Any]])
        #expect(datos.count == 1 && datos[0]["pasosPorOctava"] as? Int == 12)
        #expect((datos[0]["quintas"] as? [Double])?.count == 12)
    }
}
