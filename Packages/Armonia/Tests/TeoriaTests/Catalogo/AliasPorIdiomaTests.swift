import Testing

@testable import Elementos
@testable import Teoria

/// `alias(en:)` y `variantes(en:)` de los catálogos con nombre: los de cada idioma, como `nombre(en:)`.
@Suite struct AliasPorIdiomaTests {
    @Test func losDeCadaIdioma() {
        let ingles = Notacion.compacta(.ingles)
        #expect(AcordeConNombre.mistico.alias(en: ingles) == ["Prometheus chord"])
        #expect(AcordeConNombre.mistico.alias(en: .compacta(.espanol)) == AcordeConNombre.mistico.alias)
        #expect(NotaConNombre.la440.alias(en: ingles) == ["concert pitch", "standard pitch"])
        #expect(NotaConNombre.la440.variantes(en: .compacta(.espanol)) == NotaConNombre.la440.variantes)
    }

    /// En español, los del propio catálogo, en todos los catálogos.
    @Test func enEspanolLosDelCatalogo() {
        let espanol = Notacion.compacta(.espanol)
        #expect(AcordeConNombre.catalogo.allSatisfy { $0.alias(en: espanol) == $0.alias })
        #expect(ProgresionConNombre.catalogo.allSatisfy { $0.variantes(en: espanol) == $0.variantes })
        #expect(RitmoConNombre.catalogo.allSatisfy { $0.alias(en: espanol) == $0.alias })
        #expect(TemperamentoConNombre.catalogo.allSatisfy { $0.alias(en: espanol) == $0.alias })
        #expect(FuncionDeNota.catalogo.allSatisfy { $0.alias(en: espanol) == $0.alias })
    }
}
