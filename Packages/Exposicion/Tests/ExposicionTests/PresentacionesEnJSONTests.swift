import Armonia
import Foundation
import Testing

@testable import Exposicion

// Lo que se escribe en JSON de los tipos que enseñan las apps (y que `armonia … --json` da tal cual): sus claves,
// sin lo que suena ni lo que se exporta.

@Suite struct PresentacionesEnJSONTests {
    private let notacion = Notacion.compacta(.espanol)

    /// Las claves de un objeto JSON.
    private func claves(_ valor: some Encodable) throws -> Set<String> {
        let datos = try JSONEncoder().encode(valor)
        let objeto = try #require(try JSONSerialization.jsonObject(with: datos) as? [String: Any])
        return Set(objeto.keys)
    }

    @Test func losModosYLasEscalasSobreUnAcorde() throws {
        let escala = Escala(.re, .dorico)
        let modo = try #require(PresentacionDeEstudioDeEscala.modosParalelos(de: escala, en: notacion).first)
        #expect(try claves(modo) == ["nombre", "brillo", "cambios"])
        let vecina = try #require(PresentacionDeEstudioDeEscala.vecinas(de: escala, en: notacion).first)
        #expect(try claves(vecina) == ["nombre", "detalle"])
    }

    @Test func losAcordesEnLasDoceTonalidades() throws {
        let tabla = try #require(
            PresentacionDeEstudioDeEscala.acordesEnLasDoceTonalidades(Escala(.do), cuatriadas: true, en: notacion))
        #expect(try claves(tabla) == ["grados", "filas"])
        #expect(try claves(try #require(tabla.filas.first)) == ["tonalidad", "acordes"])
    }

    @Test func elAnalisis() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Lam Re7 Sol7 Do", notacion: notacion)
        #expect(try claves(analisis) == ["titulo", "tramos", "cadencias"])
        let tramo = try #require(analisis.tramos.first)
        #expect(try claves(tramo).isSuperset(of: ["acordes"]))
        #expect(!(try claves(tramo).contains("filas")))
        #expect(try claves(try #require(tramo.filas.first)) == ["cifrado", "grado", "funcion"])
    }
}
