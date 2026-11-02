import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// El I64 cadencial, el sustituto tritonal y las semicadencias frigias y plagales menores.
@Suite struct AnalisisAmpliadoTests {
    // MARK: I64 cadencial

    @Test func cuartaYSextaCadencial() {
        let analisis = Tonalidad(.do).analizar(["Do", "Fa", "Do/Sol", "Sol7", "Do"])
        #expect(analisis.cifrados == ["I", "IV", "I64", "V7", "I"])
        #expect(analisis.acordes[2].categoria == .cuartaYSextaCadencial)
        #expect(analisis.acordes[2].funcion == .dominante)
        #expect(analisis.funciones == [.tonica, .subdominante, .dominante, .dominante, .tonica])
        // En menor también.
        let menor = Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Lam/Mi", "Mi7", "Lam"])
        #expect(menor.acordes[2].categoria == .cuartaYSextaCadencial)
        #expect(menor.cifrados[2] == "i64")
        // Si no va a la dominante sobre el mismo bajo, es un I64 cualquiera.
        #expect(Tonalidad(.do).analizar(["Do/Sol", "Sol7/Re"]).acordes[0].categoria == .diatonico)
        #expect(Tonalidad(.do).analizar(["Do/Sol", "Fa"]).acordes[0].funcion == .tonica)
        #expect(Tonalidad(.do).analizar(["Do/Sol"]).acordes[0].categoria == .diatonico)
        // Sigue sin cerrar: la cadencia es la de después.
        #expect(Tonalidad(.do).analizar(["Do", "Fa", "Do/Sol", "Sol7", "Do"]).cadencias.map(\.tipo) == [.autentica])
        #expect(Tonalidad(.do).escalaDelAcorde(Acorde("Do/Sol"), siguiente: Acorde("Sol"))?.nombre == "Do mayor")
    }

    // MARK: Sustituto tritonal

    @Test func sustitutoTritonal() {
        let analisis = Tonalidad(.do).analizar(["Rem7", "Reb7", "Do7M"])
        #expect(analisis.cifrados[1] == "subV7")
        #expect(analisis.acordes[1].categoria == .sustitutoTritonal(de: 1))
        #expect(analisis.acordes[1].funcion == .dominante)
        // De otro grado: Mi♭7 a Rem7 es subV7/ii.
        let deII = Tonalidad(.do).analizar(["Do", "Mib7", "Rem7", "Sol7", "Do"])
        #expect(deII.cifrados[1] == "subV7/ii")
        #expect(deII.acordes[1].categoria == .sustitutoTritonal(de: 2))
        // Solo si resuelve: Re♭7 suelto o yendo a otro sitio no lo es.
        #expect(Tonalidad(.do).analizar(["Reb7", "Fa"]).acordes[0].categoria != .sustitutoTritonal(de: 1))
        #expect(Tonalidad(.do).analizar(["Reb7"]).acordes[0].categoria != .sustitutoTritonal(de: 1))
        // La♭7 a Sol sigue siendo la sexta aumentada alemana.
        #expect(Tonalidad(.do).analizar(["Lab7", "Sol"]).acordes[0].categoria == .sextaAumentada)
        // Su escala es la lidia dominante.
        let escala = Tonalidad(.do).escalaDelAcorde(Acorde("Reb7"), siguiente: Acorde("Do"))
        #expect(escala?.nombre == "Re♭ lidio dominante")
    }

    // MARK: Cadencias

    @Test func semicadenciaFrigia() throws {
        let frigia = try #require(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi"]).cadencias.first)
        #expect(frigia.tipo == .semicadencia)
        #expect(frigia.esFrigia)
        #expect(frigia.description == "Semicadencia frigia iv6–V (acordes 2 → 3)")
        #expect(frigia.descripcion(en: .inglesASCII) == "Phrygian half cadence iv6–V (chords 2 → 3)")
        #expect(frigia.nombre(en: .inglesASCII) == "Phrygian half cadence")
        // Desde el iv en estado fundamental no es frigia.
        let normal = try #require(Tonalidad(.la, .menor).analizar(["Lam", "Rem", "Mi"]).cadencias.first)
        #expect(!normal.esFrigia)
        #expect(normal.nombre(en: .espanolCompacto) == "semicadencia")
    }

    @Test func plagalMenor() throws {
        let menor = try #require(Tonalidad(.do).analizar(["Do", "Fam", "Do"]).cadencias.first)
        #expect(menor.tipo == .plagal)
        #expect(menor.esPlagalMenor)
        #expect(menor.description == "Cadencia plagal menor iv–I (acordes 2 → 3)")
        let mayor = try #require(Tonalidad(.do).analizar(["Do", "Fa", "Do"]).cadencias.first)
        #expect(!mayor.esPlagalMenor)
        // En menor, iv–i es una plagal sin más.
        let enMenor = try #require(Tonalidad(.la, .menor).analizar(["Lam", "Rem", "Lam"]).cadencias.first)
        #expect(!enMenor.esPlagalMenor)
    }

    @Test func enLosQuinceIdiomas() throws {
        let frigia = try #require(Tonalidad(.la, .menor).analizar(["Lam", "Rem/Fa", "Mi"]).cadencias.first)
        let plagal = try #require(Tonalidad(.do).analizar(["Do", "Fam", "Do"]).cadencias.first)
        for idioma in Idioma.allCases {
            let notacion = Notacion.delIdioma(idioma)
            let nombres = [frigia.nombre(en: notacion), plagal.nombre(en: notacion)]
            #expect(!nombres.contains(""))
            #expect(nombres[0] != Cadencia.Tipo.semicadencia.nombre(en: notacion), Comment(rawValue: nombres[0]))
            #expect(nombres[1] != Cadencia.Tipo.plagal.nombre(en: notacion), Comment(rawValue: nombres[1]))
        }
    }
}
