import Foundation
import Testing

@testable import ConsolaArmonia

// Las medidas de relación en la consola: entre acordes, con la tonalidad, entre escalas y de una progresión.

extension LineaDeComandosTests {
    /// `acorde … --comparar`: las distancias de Tymoczko, Lerdahl, Fourier y Forte debajo de la conducción.
    @Test func relacionEntreAcordes() throws {
        let texto = salida("acorde Sol7 --comparar Do")
        #expect(texto.contains("\n  Conducción de Tymoczko (taxista · euclídea · máximo): 4 · 2.449 · 2\n"))
        #expect(texto.contains("\n  Distancia de Lerdahl (Do mayor): 5\n"), Comment(rawValue: texto))
        let enFa = salida("acorde Do --comparar Lab --en Fa mayor")
        #expect(enFa.contains("\n  Pasos en el Tonnetz: 2\n"), Comment(rawValue: enFa))
        #expect(enFa.contains("Distancia de Lerdahl (Fa mayor)"), Comment(rawValue: enFa))
        let datos = try #require(try json("acorde Do --comparar Lab") as? [[String: Any]])
        let relacion = try #require(datos[0]["relacion"] as? [String: Any])
        #expect(relacion["distanciaEnElTonnetz"] as? Int == 2)
        #expect((relacion["conjunto"] as? [String: Any])?["distanciaDeFourier"] as? Double == 0)
    }

    /// `acorde … --estadisticas`: también cómo encaja en la tonalidad.
    @Test func acordeEnLaTonalidad() throws {
        let texto = salida("acorde Sol7 --estadisticas")
        #expect(texto.contains("\nCon la tonalidad (Do mayor):\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Función probable: dominante\n"), Comment(rawValue: texto))
        let ingles = salida("chord Db7 --statistics --ingles")
        #expect(ingles.contains("Probable function: dominant"), Comment(rawValue: ingles))
        let datos = try #require(try json("acorde Sol7 --estadisticas --en Do mayor") as? [[String: Any]])
        let enLaTonalidad = try #require(datos[0]["enLaTonalidad"] as? [String: Any])
        #expect(enLaTonalidad["funcionProbable"] as? String == "dominante")
        #expect((enLaTonalidad["tonalidadesCercanas"] as? [Any])?.count == 3)
    }

    /// `escala … --comparar`: la relación entre las dos escalas.
    @Test func relacionEntreEscalas() throws {
        let texto = salida("escala Do mayor --comparar Sol mayor")
        #expect(texto.contains("\n  Distancia en quintas: 1\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Conducción mínima: Fa→Fa♯ (+1)\n"), Comment(rawValue: texto))
        let datos = try #require(try json("escala Do mayor --comparar Sol mayor") as? [String: Any])
        let comparacion = try #require(datos["comparacion"] as? [String: Any])
        #expect((comparacion["relacion"] as? [String: Any])?["notasQueCambian"] as? Int == 1)
    }

    /// `analizar … --estadisticas`: lo que se mide de la progresión.
    @Test func estadisticasDeLaProgresion() throws {
        let texto = salida("analizar Do Fa Sol7 Do --estadisticas")
        #expect(texto.contains("\nEstadísticas de la progresión (Do mayor):\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Tensión de Lerdahl (desde el anterior): 0 5 8 5\n"), Comment(rawValue: texto))
        #expect(texto.contains("\n  Funciones probables: T S D T\n"), Comment(rawValue: texto))
        let ingles = salida("analyze C Ab Db7 C --statistics --ingles")
        #expect(ingles.contains("  Chromaticism: 0.308"), Comment(rawValue: ingles))
        let datos = try #require(try json("analizar Do Fa Sol7 Do --estadisticas") as? [String: Any])
        let estadisticas = try #require(datos["estadisticas"] as? [String: Any])
        #expect(estadisticas["movimientos"] as? [Int] == [3, 5, 4])
        let sinEstadisticas = try #require(try json("analizar Do Fa Sol7 Do") as? [String: Any])
        #expect(sinEstadisticas["estadisticas"] == nil)
    }
}
