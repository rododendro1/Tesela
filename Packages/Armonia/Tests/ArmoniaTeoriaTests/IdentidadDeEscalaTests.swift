import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// La identidad de una escala (`TipoDeEscala.identidad`): su nombre y su contenido. Las tablas del catálogo (tradición,
/// categoría, usos, afinaciones, nombres en otros idiomas) se buscan por ella.
@Suite struct IdentidadDeEscalaTests {
    @Test func mismoContenidoNoEsLaMismaEscala() {
        #expect(TipoDeEscala.hardino == .mayor)
        #expect(TipoDeEscala.hardino.identidad != TipoDeEscala.mayor.identidad)
        #expect(!TipoDeEscala.hardino.esIdentico(a: .mayor))
        #expect(TipoDeEscala.mayor.esIdentico(a: .mayor))
    }

    @Test func laIdentidadSobreviveACodificar() throws {
        let datos = try JSONEncoder().encode(TipoDeEscala.bayati)
        let leido = try JSONDecoder().decode(TipoDeEscala.self, from: datos)
        #expect(leido.identidad == TipoDeEscala.bayati.identidad)
        #expect(leido.tradicion == .mundoArabe)
        #expect(leido.microtonal == TipoDeEscala.bayati.microtonal)
    }

    @Test func cadaTablaDistingueLasEscalasDeMismoContenido() {
        // Hardino es de África y no tiene usos occidentales; la mayor, al revés.
        #expect(TipoDeEscala.hardino.tradicion == .africa)
        #expect(TipoDeEscala.mayor.tradicion == nil)
        #expect(TipoDeEscala.hardino.usos.isEmpty)
        #expect(!TipoDeEscala.mayor.usos.isEmpty)
        // La afinación de Knight es la de Hardino, no la de la mayor ni la de Tomora ba (también mayor).
        #expect(TipoDeEscala.hardino.microtonal != nil)
        #expect(TipoDeEscala.mayor.afinaciones.isEmpty)
        #expect(TipoDeEscala.tomoraBa.microtonal != TipoDeEscala.hardino.microtonal)
    }

    @Test func unaEscalaPropiaConElNombreDeOtraNoEsElla() {
        let falsa = TipoDeEscala(nombre: TipoDeEscala.bayati.nombre, intervalos: TipoDeEscala.mayor.intervalos)
        #expect(falsa.identidad != TipoDeEscala.bayati.identidad)
        #expect(falsa.tradicion == nil)
        #expect(falsa.categoria == nil)
        #expect(falsa.afinaciones.isEmpty)
        // Con el nombre y el contenido de Bayātī, es Bayātī.
        let copia = TipoDeEscala(nombre: TipoDeEscala.bayati.nombre, intervalos: TipoDeEscala.bayati.intervalos)
        #expect(copia.tradicion == .mundoArabe)
        #expect(copia.microtonal == TipoDeEscala.bayati.microtonal)
    }
}
