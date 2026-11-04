import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct BajoCifradoTests {
    private let doMayor = Tonalidad(.do)
    private let laMenor = Tonalidad(.la, .menor)

    // MARK: Un acorde

    @Test func triadasYSusInversiones() throws {
        #expect(try doMayor.acorde(sobre: .do, cifras: "") == Acorde("Do"))
        #expect(try doMayor.acorde(sobre: .do, cifras: "5") == Acorde("Do"))
        #expect(try doMayor.acorde(sobre: .do, cifras: "53") == Acorde("Do"))
        #expect(try doMayor.acorde(sobre: .re, cifras: "") == Acorde("Rem"))
        #expect(try doMayor.acorde(sobre: .mi, cifras: "6") == Acorde("Do/Mi"))
        #expect(try doMayor.acorde(sobre: .sol, cifras: "64") == Acorde("Do/Sol"))
        #expect(try doMayor.acorde(sobre: .sol, cifras: "6/4") == Acorde("Do/Sol"))
        #expect(try doMayor.acorde(sobre: .si, cifras: "") == Acorde("Si°"))
    }

    @Test func septimasYSusInversiones() throws {
        #expect(try doMayor.acorde(sobre: .sol, cifras: "7") == Acorde("Sol7"))
        #expect(try doMayor.acorde(sobre: .si, cifras: "65") == Acorde("Sol7/Si"))
        #expect(try doMayor.acorde(sobre: .re, cifras: "43") == Acorde("Sol7/Re"))
        #expect(try doMayor.acorde(sobre: .fa, cifras: "42") == Acorde("Sol7/Fa"))
        #expect(try doMayor.acorde(sobre: .fa, cifras: "2") == Acorde("Sol7/Fa"))
        #expect(try doMayor.acorde(sobre: .re, cifras: "7") == Acorde("Rem7"))
    }

    @Test func alteraciones() throws {
        // Sola, altera la tercera: la sensible en menor.
        #expect(try laMenor.acorde(sobre: .mi, cifras: "#") == Acorde("Mi"))
        #expect(try laMenor.acorde(sobre: .mi, cifras: "♯") == Acorde("Mi"))
        #expect(try laMenor.acorde(sobre: .mi, cifras: "") == Acorde("Mim"))
        // Delante o detrás de una cifra, la suya.
        #expect(try laMenor.acorde(sobre: .si, cifras: "#6") == Acorde("Sol#°/Si"))
        #expect(try laMenor.acorde(sobre: .si, cifras: "6+") == Acorde("Sol#°/Si"))
        #expect(try doMayor.acorde(sobre: .do, cifras: "b7") == Acorde("Do7"))
        #expect(try Tonalidad(.fa).acorde(sobre: .sol, cifras: "♮") == Acorde("Sol"))
        // La cuarta en vez de la tercera, y la novena como segunda.
        #expect(try doMayor.acorde(sobre: .sol, cifras: "4") == Acorde("Solsus4"))
        #expect(Set(try doMayor.acorde(sobre: .do, cifras: "9").notas) == [.do, .re, .mi, .sol])
    }

    @Test func cifrasQueNoSeLeen() throws {
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "x", posicion: 0, motivo: .cifrasNoValidas("x"))) {
            try doMayor.acorde(sobre: .do, cifras: "x")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "60", posicion: 1, motivo: .cifrasNoValidas("60"))) {
            try doMayor.acorde(sobre: .do, cifras: "60")
        }
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "##6", posicion: 1, motivo: .cifrasNoValidas("##6"))) {
            try doMayor.acorde(sobre: .do, cifras: "##6")
        }
    }

    // MARK: Una línea de bajo

    @Test func lineaDeBajo() throws {
        #expect(try doMayor.acordes(bajoCifrado: "Do Fa Sol:7 Do") == ["Do", "Fa", "Sol7", "Do"])
        #expect(try doMayor.acordes(bajoCifrado: "Do Re:43 Mi:6 Fa Sol") == ["Do", "Sol7/Re", "Do/Mi", "Fa", "Sol"])
        #expect(try laMenor.acordes(bajoCifrado: "La Fa:6 Mi:# La") == ["Lam", "Rem/Fa", "Mi", "Lam"])
        #expect(throws: ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio)) {
            try doMayor.acordes(bajoCifrado: "")
        }
        #expect(throws: ErrorDeLectura.self) { try doMayor.acordes(bajoCifrado: "Do Xa") }
        // El error de las cifras, en su carácter de la línea entera.
        #expect(throws: ErrorDeLecturaDeTeoria(texto: "Do Sol:z", posicion: 7, motivo: .cifrasNoValidas("z"))) {
            try doMayor.acordes(bajoCifrado: "Do Sol:z")
        }
    }

    @Test func realizacion() throws {
        let coral = try #require(try Coral.realizar(bajoCifrado: "Do Fa Sol:7 Do", en: doMayor))
        #expect(coral.esCorrecta)
        #expect(coral.voz(0).map(\.nota) == [.do, .fa, .sol, .do])
        let menor = try #require(try Coral.realizar(bajoCifrado: "La Fa:6 Mi:# La", en: laMenor))
        #expect(menor.voz(0).map(\.nota) == [.la, .fa, .mi, .la])
        #expect(throws: ErrorDeLectura.self) { try Coral.realizar(bajoCifrado: "Do Xa", en: doMayor) }
    }
}

/// Las cifras de bajo continuo de un acorde: lo contrario de leerlas.
@Suite struct CifrasDeBajoTests {
    @Test func lasAbreviaturasHabituales() throws {
        let enDo = Tonalidad(.do)
        #expect(enDo.cifrasDeBajo(de: Acorde("Do")) == [])
        #expect(enDo.cifrasDeBajo(de: Acorde("Do/Mi")) == ["6"])
        #expect(enDo.cifrasDeBajo(de: Acorde("Do/Sol")) == ["6", "4"])
        #expect(enDo.cifrasDeBajo(de: Acorde("Sol7")) == ["7"])
        #expect(enDo.cifrasDeBajo(de: Acorde("Sol7/Si")) == ["6", "5"])
        #expect(enDo.cifrasDeBajo(de: Acorde("Sol7/Re")) == ["4", "3"])
        #expect(enDo.cifrasDeBajo(de: Acorde("Sol7/Fa")) == ["4", "2"])
    }

    /// Las notas que la armadura no da llevan su alteración; la de una tercera que no se escribe va sola.
    @Test func lasAlteraciones() throws {
        let enLaMenor = Tonalidad(.la, .menor)
        #expect(enLaMenor.cifrasDeBajo(de: Acorde("Mi")) == ["♯"])
        #expect(enLaMenor.cifrasDeBajo(de: Acorde("Mi7")) == ["7", "♯"])
        #expect(enLaMenor.cifrasDeBajo(de: Acorde("Mi7/Re")) == ["♯4", "2"])
        #expect(enLaMenor.cifrasDeBajo(de: Acorde("Mi/Sol♯")) == ["6"])
        #expect(Tonalidad(.do).cifrasDeBajo(de: Acorde("Re7/Fa♯")) == ["6", "5"])
        #expect(Tonalidad(.do).cifrasDeBajo(de: Acorde("Re7")) == ["7", "♯"])
    }

    /// Leer las cifras que se escriben da el mismo acorde.
    @Test func vanYVuelven() throws {
        let enDo = Tonalidad(.do)
        let cifrados = ["Do", "Do/Mi", "Do/Sol", "Sol7", "Sol7/Si", "Sol7/Re", "Sol7/Fa", "Rem/Fa", "Re7/Fa♯", "Fa/La"]
        for cifrado in cifrados {
            let acorde = try Acorde(leyendo: cifrado)
            let cifras = enDo.cifrasDeBajo(de: acorde).joined(separator: "/")
            let leido = try enDo.acorde(sobre: acorde.bajo, cifras: cifras)
            let clases = Set(leido.notas.map(\.claseDeAltura))
            #expect(clases == Set(acorde.notas.map(\.claseDeAltura)), Comment(rawValue: cifrado))
            #expect(leido.bajo == acorde.bajo, Comment(rawValue: cifrado))
        }
    }
}
