import Testing

@testable import Elementos
@testable import Teoria

/// Los ajnas de los maqāmāt y los çeşni de los makam.
@Suite struct AjnasTests {
    @Test func bayatiEsBayatiYNahawand() {
        let bayati = Escala(.re, .bayati)
        #expect(TipoDeEscala.bayati.ajnas.map(\.fragmento) == [.jinsBayati, .jinsNahawand])
        #expect(TipoDeEscala.bayati.ajnas.map(\.grado) == [1, 4])
        #expect(TipoDeEscala.bayati.fuenteDeLosAjnas == .maqamWorld)
        #expect(bayati.notas(de: TipoDeEscala.bayati.ajnas[1]).map(\.nombre) == ["Sol", "La", "Si♭", "Do", "Re"])
        #expect(TipoDeEscala.rastMakami.fuenteDeLosAjnas == .tdvIslamAnsiklopedisi)
        #expect(TipoDeEscala.mayor.ajnas.isEmpty)
        #expect(TipoDeEscala.mayor.fuenteDeLosAjnas == nil)
    }

    /// Cada fragmento declarado tiene las notas de la escala, subiendo o bajando, y es un fragmento del catálogo.
    @Test func cadaFragmentoCasaConSuEscala() {
        let declarados = TipoDeEscala.tradicionales.filter { !$0.ajnas.isEmpty }
        #expect(declarados.count == 36)
        for tipo in declarados {
            let escala = Escala(.do, tipo)
            for fragmento in tipo.ajnas {
                #expect(fragmento.fragmento.clase == .fragmento)
                for nota in escala.notas(de: fragmento) {
                    #expect(
                        escala.contiene(nota), "\(tipo.nombre): \(fragmento.fragmento.nombre) en \(fragmento.grado)")
                }
            }
            #expect(tipo.ajnas.map(\.grado) == tipo.ajnas.map(\.grado).sorted())
        }
    }
}
