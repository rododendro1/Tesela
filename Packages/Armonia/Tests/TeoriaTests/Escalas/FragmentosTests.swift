import Testing

@testable import Elementos
@testable import Teoria

/// Los fragmentos de menos de una octava: los tetracordos, los ajnas, los çeşni y los hexacordos.
@Suite struct FragmentosTests {
    /// La clase sale de la categoría en las de otras tradiciones y de la declaración en las occidentales: el
    /// hexacordo de Guido es un fragmento, como el hexachordum naturale.
    @Test func elHexacordoEsUnFragmentoComoLosDeOtrasTradiciones() {
        #expect(TipoDeEscala.hexacordo.esFragmento)
        #expect(TipoDeEscala.hexacordo.clase == .fragmento)
        #expect(TipoDeEscala.tetracordoDiatonico.esFragmento)
        #expect(!TipoDeEscala.mayor.esFragmento && TipoDeEscala.mayor.clase == nil)
        #expect(!TipoDeEscala.bayati.esFragmento)
        let occidentales = TipoDeEscala.occidentales.filter(\.esFragmento)
        #expect(occidentales.map(\.nombre) == ["hexacordo"])
    }

    /// Lo que abarca un fragmento es su intervalo más agudo, y no llega a la octava; las demás no tienen ámbito.
    @Test func elAmbitoNoLlegaALaOctava() throws {
        let fragmentos = TipoDeEscala.catalogo.filter(\.esFragmento)
        #expect(fragmentos.count == 49)
        for tipo in fragmentos {
            let ambito = try #require(tipo.ambito, Comment(rawValue: tipo.nombre))
            #expect(ambito == tipo.intervalos.last && ambito.semitonos < 12, Comment(rawValue: tipo.nombre))
        }
        #expect(TipoDeEscala.tetracordoDiatonico.ambito == .cuartaJusta)
        #expect(TipoDeEscala.hexacordo.ambito == .sextaMayor)
        #expect(TipoDeEscala.catalogo.filter { !$0.esFragmento }.allSatisfy { $0.ambito == nil })
    }

    /// Un fragmento no tiene modos, porque no se repite a la octava.
    @Test func unFragmentoNoTieneModos() {
        let tetracordo = Escala(.mi, .tetracordoDiatonico)
        #expect(tetracordo.modosRelativos.isEmpty && tetracordo.modosParalelos.isEmpty)
        #expect(Escala(.do, .hexacordo).modosRelativos.isEmpty)
        #expect(Escala(.do).modosRelativos.count == 7)
    }
}
