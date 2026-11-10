import Testing

@testable import Elementos
@testable import Polifonia
@testable import Teoria

@Suite struct NotaExtranaFuncionTests {
    /// Cada nota extraña lleva a su función del catálogo, que se llama igual en todos los idiomas.
    @Test func cadaNotaExtranaEsUnaFuncion() {
        #expect(Set(NotaExtrana.allCases.map(\.funcion)) == Set(FuncionDeNota.todas(de: .notaExtrana)))
        for extrana in NotaExtrana.allCases {
            #expect(extrana.funcion.familia == .notaExtrana)
            for idioma in Idioma.allCases {
                #expect(
                    extrana.funcion.nombre(en: .conPalabras(idioma)) == extrana.nombre(en: .conPalabras(idioma)),
                    "\(extrana) en \(idioma)")
            }
        }
    }
}
