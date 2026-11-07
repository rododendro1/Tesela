import Testing

@testable import Elementos
@testable import Teoria

@Suite struct ManoGuidonianaTests {
    /// Las veinte posiciones del gamut, de Γ ut a ee la, con sus nombres de los tratados.
    @Test func elGamut() {
        #expect(ManoGuidoniana.hexacordos.count == 7)
        #expect(
            ManoGuidoniana.gamut.map(\.nombre) == [
                "Γ ut", "A re", "B mi", "C fa ut", "D sol re", "E la mi", "F fa ut", "G sol re ut", "a la mi re",
                "b fa ♮ mi", "c sol fa ut", "d la sol re", "e la mi", "f fa ut", "g sol re ut", "aa la mi re",
                "bb fa ♮♮ mi", "cc sol fa", "dd la sol", "ee la",
            ])
        #expect(ManoGuidoniana.gamut.first?.alturas == [Altura(.sol, octava: 2)])
        #expect(ManoGuidoniana.gamut.last?.alturas == [Altura(.mi, octava: 5)])
        #expect(ManoGuidoniana.gamut[9].alturas == [Altura(Nota(.si, .bemol), octava: 3), Altura(.si, octava: 3)])
    }

    @Test func silabasYMutaciones() {
        #expect(ManoGuidoniana.nombre(de: Altura(.do, octava: 3)) == "C fa ut")
        #expect(ManoGuidoniana.nombre(de: Altura(.fa, octava: 5)) == nil)
        #expect(ManoGuidoniana.silabas(de: Altura(.sol, octava: 3)) == ["sol", "re", "ut"])
        #expect(ManoGuidoniana.silabas(de: Altura(Nota(.si, .bemol), octava: 3)) == ["fa"])
        #expect(ManoGuidoniana.silabas(de: Altura(.fa, octava: 2)).isEmpty)
        let natural = ManoGuidoniana.hexacordos[1]
        let duro = ManoGuidoniana.hexacordos[3]
        let mutacion = ManoGuidoniana.mutacion(en: Altura(.la, octava: 3), desde: natural, hasta: duro)
        #expect(mutacion?.desde == "la" && mutacion?.hasta == "re")
        #expect(ManoGuidoniana.mutacion(en: Altura(.do, octava: 3), desde: natural, hasta: duro) == nil)
        #expect(natural.tipo == .hexacordoNatural && duro.alturas.first == Altura(.sol, octava: 3))
    }
}
