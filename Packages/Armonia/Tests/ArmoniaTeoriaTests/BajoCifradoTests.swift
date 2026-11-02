import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct BajoCifradoTests {
    private let doMayor = Tonalidad(.do)
    private let laMenor = Tonalidad(.la, .menor)

    // MARK: Un acorde

    @Test func triadasYSusInversiones() {
        #expect(doMayor.acorde(sobre: .do, cifras: "") == Acorde("Do"))
        #expect(doMayor.acorde(sobre: .do, cifras: "5") == Acorde("Do"))
        #expect(doMayor.acorde(sobre: .do, cifras: "53") == Acorde("Do"))
        #expect(doMayor.acorde(sobre: .re, cifras: "") == Acorde("Rem"))
        #expect(doMayor.acorde(sobre: .mi, cifras: "6") == Acorde("Do/Mi"))
        #expect(doMayor.acorde(sobre: .sol, cifras: "64") == Acorde("Do/Sol"))
        #expect(doMayor.acorde(sobre: .sol, cifras: "6/4") == Acorde("Do/Sol"))
        #expect(doMayor.acorde(sobre: .si, cifras: "") == Acorde("Si°"))
    }

    @Test func septimasYSusInversiones() {
        #expect(doMayor.acorde(sobre: .sol, cifras: "7") == Acorde("Sol7"))
        #expect(doMayor.acorde(sobre: .si, cifras: "65") == Acorde("Sol7/Si"))
        #expect(doMayor.acorde(sobre: .re, cifras: "43") == Acorde("Sol7/Re"))
        #expect(doMayor.acorde(sobre: .fa, cifras: "42") == Acorde("Sol7/Fa"))
        #expect(doMayor.acorde(sobre: .fa, cifras: "2") == Acorde("Sol7/Fa"))
        #expect(doMayor.acorde(sobre: .re, cifras: "7") == Acorde("Rem7"))
    }

    @Test func alteraciones() {
        // Sola, altera la tercera: la sensible en menor.
        #expect(laMenor.acorde(sobre: .mi, cifras: "#") == Acorde("Mi"))
        #expect(laMenor.acorde(sobre: .mi, cifras: "♯") == Acorde("Mi"))
        #expect(laMenor.acorde(sobre: .mi, cifras: "") == Acorde("Mim"))
        // Delante o detrás de una cifra, la suya.
        #expect(laMenor.acorde(sobre: .si, cifras: "#6") == Acorde("Sol#°/Si"))
        #expect(laMenor.acorde(sobre: .si, cifras: "6+") == Acorde("Sol#°/Si"))
        #expect(doMayor.acorde(sobre: .do, cifras: "b7") == Acorde("Do7"))
        #expect(Tonalidad(.fa).acorde(sobre: .sol, cifras: "♮") == Acorde("Sol"))
        // La cuarta en vez de la tercera, y la novena como segunda.
        #expect(doMayor.acorde(sobre: .sol, cifras: "4") == Acorde("Solsus4"))
        #expect(Set(doMayor.acorde(sobre: .do, cifras: "9")?.notas ?? []) == [.do, .re, .mi, .sol])
    }

    @Test func cifrasQueNoSeLeen() {
        #expect(doMayor.acorde(sobre: .do, cifras: "x") == nil)
        #expect(doMayor.acorde(sobre: .do, cifras: "60") == nil)
        #expect(doMayor.acorde(sobre: .do, cifras: "##6") == nil)
    }

    // MARK: Una línea de bajo

    @Test func lineaDeBajo() {
        #expect(doMayor.acordes(bajoCifrado: "Do Fa Sol:7 Do") == ["Do", "Fa", "Sol7", "Do"])
        #expect(doMayor.acordes(bajoCifrado: "Do Re:43 Mi:6 Fa Sol") == ["Do", "Sol7/Re", "Do/Mi", "Fa", "Sol"])
        #expect(laMenor.acordes(bajoCifrado: "La Fa:6 Mi:# La") == ["Lam", "Rem/Fa", "Mi", "Lam"])
        #expect(doMayor.acordes(bajoCifrado: "") == nil)
        #expect(doMayor.acordes(bajoCifrado: "Do Xa") == nil)
        #expect(doMayor.acordes(bajoCifrado: "Do Sol:z") == nil)
    }

    @Test func realizacion() throws {
        let coral = try #require(Coral.realizar(bajoCifrado: "Do Fa Sol:7 Do", en: doMayor))
        #expect(coral.esCorrecta)
        #expect(coral.voz(0).map(\.nota) == [.do, .fa, .sol, .do])
        let menor = try #require(Coral.realizar(bajoCifrado: "La Fa:6 Mi:# La", en: laMenor))
        #expect(menor.voz(0).map(\.nota) == [.la, .fa, .mi, .la])
        #expect(Coral.realizar(bajoCifrado: "Do Xa", en: doMayor) == nil)
    }
}
