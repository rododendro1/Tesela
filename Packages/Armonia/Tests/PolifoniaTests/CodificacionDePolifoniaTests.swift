import Foundation
import Testing

@testable import Elementos
@testable import Partituras
@testable import Polifonia
@testable import Teoria

/// El coral y el contrapunto se guardan en JSON y se leen igual, y lo que no se podría crear con sus inicializadores
/// no se lee.
@Suite struct CodificacionDePolifoniaTests {
    private func idaYVuelta<T: Codable & Equatable>(_ valor: T) throws -> T {
        try JSONDecoder().decode(T.self, from: JSONEncoder().encode(valor))
    }

    private func leer<T: Decodable>(_ tipo: T.Type, _ json: String) throws -> T {
        try JSONDecoder().decode(tipo, from: Data(json.utf8))
    }

    @Test func coral() throws {
        let coral = try Coral(leyendo: "Do3 Sol3 Mi4 Do5 | Sol2 Re4 Sol4 Si4")
        #expect(try idaYVuelta(coral) == coral)
        #expect(try leer(Coral.self, #"[["Do3", "Mi4"], ["Sol2", "Re4"]]"#).numeroDeVoces == 2)
        // Acordes con distintas voces no forman un coral.
        #expect(throws: DecodingError.self) { try leer(Coral.self, #"[["Do3", "Mi4"], ["Sol2"]]"#) }
    }

    @Test func contrapunto() throws {
        let fux = try Contrapunto(
            cantusFirmus: "Re4 Fa4 Mi4 Re4", contrapunto: "-:2 La4 Re5 La4 Si4 Do#5 Re5:1", especie: .segunda)
        let leido = try idaYVuelta(fux)
        #expect(leido == fux)
        #expect(leido.esCorrecto == fux.esCorrecto)
        // Un contrapunto que no dura una redonda por nota del cantus no se lee.
        let corto = try Contrapunto(cantusFirmus: "Re4", contrapunto: "Re5:1", especie: .primera)
        let cantusLargo = String(decoding: try JSONEncoder().encode(fux.cantusFirmus), as: UTF8.self)
        let eventosCortos = String(decoding: try JSONEncoder().encode(corto.contrapunto.eventos), as: UTF8.self)
        #expect(throws: DecodingError.self) {
            try leer(
                Contrapunto.self,
                #"{"cantusFirmus": \#(cantusLargo), "contrapunto": \#(eventosCortos), "especie": 1}"#)
        }
    }

    /// El coral se lee y se escribe con la octava en subíndice, en cifras o en ASCII.
    @Test func coralConOctavaEnSubindice() throws {
        let coral = try Coral(leyendo: "Do₃ Mi₄ | Re₃ Fa₄")
        #expect(try coral == (Coral(leyendo: "Do3 Mi4 | Re3 Fa4")))
        #expect(coral.texto(en: .compacta(.espanol)) == "Do₃ Mi₄ | Re₃ Fa₄")
        #expect(coral.texto(en: Notacion.compacta(.espanol).conOctavas(.cifras)) == "Do3 Mi4 | Re3 Fa4")
        #expect(coral.texto(en: .ascii(.espanol)) == "Do3 Mi4 | Re3 Fa4")
    }
}
