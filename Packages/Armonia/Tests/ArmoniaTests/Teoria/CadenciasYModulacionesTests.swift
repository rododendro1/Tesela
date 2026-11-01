import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct CadenciasYModulacionesTests {
    private func cadencias(_ texto: String, en tonalidad: Tonalidad? = nil) throws -> [Cadencia.Tipo] {
        try AnalisisArmonico.analizar(leyendo: texto, en: tonalidad).cadencias.map(\.tipo)
    }

    private func tonalidades(_ texto: String) throws -> [Tonalidad] {
        try RecorridoTonal(leyendo: texto).tramos.map(\.tonalidad)
    }

    // MARK: Cadencias

    @Test func testCadencias() throws {
        #expect(try (cadencias("Do Fa Sol7 Do")) == [.autentica])
        #expect(try (cadencias("Do Fa Do")) == [.plagal])
        #expect(try (cadencias("Do Fa Sol Lam", en: Tonalidad(.do))) == [.rota])
        #expect(try (cadencias("Do Lam Fa Sol", en: Tonalidad(.do))) == [.semicadencia])
        #expect(try (cadencias("Lam Rem Mi7 Lam")) == [.autentica])
        #expect(try (cadencias("Lam Rem/Fa Mi", en: Tonalidad(.la, .menor))) == [.semicadencia])
        #expect(try (cadencias("Lam Mi7 Fa", en: Tonalidad(.la, .menor))) == [.rota])
        // Rota con el ♭VI prestado en mayor.
        #expect(try (cadencias("Do Sol7 Lab", en: Tonalidad(.do))) == [.rota])
        // El I64 cadencial no cierra: la cadencia es la de después.
        #expect(try (cadencias("Do Fa Do/Sol Sol7 Do", en: Tonalidad(.do))) == [.autentica])
        // Una semicadencia solo al final.
        #expect(try (cadencias("Do Sol Lam Fa Sol Do", en: Tonalidad(.do))) == [.rota, .autentica])
        // Con la sensible.
        #expect(try (cadencias("Do Sim°/Re Do/Mi", en: Tonalidad(.do))) == [.autentica])
        #expect(try (cadencias("Do Lam Rem Mim")) == [])
    }

    @Test func cadenciaPerfectaEImperfecta() throws {
        let perfecta = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do").cadencias[0]
        #expect(perfecta.esPerfecta)
        #expect(perfecta.acorde == 2)
        #expect(perfecta.acordes.map(\.cifrado) == ["V7", "I"])
        #expect(perfecta.description == "Cadencia auténtica V7–I (acordes 3 → 4)")
        #expect(perfecta.descripcion(en: .inglesASCII) == "Authentic cadence V7–I (chords 3 → 4)")
        #expect(perfecta.descripcion(en: .catalan) == "Cadència autèntica V7–I (acords 3 → 4)")
        #expect(perfecta.descripcion(en: .euskera) == "Kadentzia autentikoa V7–I (3 → 4 akordeak)")
        let imperfecta = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7/Si Do", en: Tonalidad(.do)).cadencias[0]
        #expect(!imperfecta.esPerfecta)
        #expect(Cadencia.Tipo.semicadencia.nombre(en: .inglesASCII) == "half cadence")
        #expect(Cadencia.Tipo.rota.nombre == "cadencia rota")
    }

    // MARK: Modulaciones

    @Test func modulacionALaDominante() throws {
        let recorrido = try RecorridoTonal(leyendo: "Do Fa Sol7 Do Lam Re7 Sol")
        #expect(recorrido.tramos.map(\.tonalidad) == [Tonalidad(.do), Tonalidad(.sol)])
        #expect(recorrido.tramos.map(\.indices) == [0..<4, 4..<7])
        #expect(recorrido.cifrados == ["I", "IV", "V7", "I", "ii", "V7", "I"])
        let modulacion = try #require(recorrido.modulaciones.first)
        #expect(modulacion.acorde == 4)
        let pivote = try #require(modulacion.pivote)
        #expect(pivote.indice == 4)
        #expect(pivote.description == "Lam = vi en Do mayor = ii en Sol mayor")
        #expect(pivote.descripcion(en: .inglesASCII) == "Am = vi in C major = ii in G major")
        #expect(
            modulacion.description
                == "De Do mayor a Sol mayor en el acorde 5 (pivote: Lam = vi en Do mayor = ii en Sol mayor)")
        #expect(recorrido.description == "I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor")
        #expect(
            modulacion.descripcion(en: .catalan)
                == "De do major a sol major a l'acord 5 (pivot: Lam = vi en do major = ii en sol major)")
        #expect(
            modulacion.descripcion(en: .gallego)
                == "De do maior a sol maior no acorde 5 (pivote: Lam = vi en do maior = ii en sol maior)")
        #expect(
            modulacion.descripcion(en: .euskera)
                == "Do maiorretik sol maiorrera, 5. akordean (pibota: Lam = vi do maiorrean = ii sol maiorrean)")
        #expect(recorrido.cadencias.map(\.tipo) == [.autentica, .autentica])
        #expect(recorrido.cadencias.map(\.tonalidad) == [Tonalidad(.do), Tonalidad(.sol)])
        #expect(recorrido.cadencias.map(\.acorde) == [2, 5])
    }

    @Test func modulacionALaRelativa() throws {
        let recorrido = try RecorridoTonal(leyendo: "Do Sol Do Fa Rem Mi7 Lam")
        #expect(recorrido.tramos.map(\.tonalidad) == [Tonalidad(.do), Tonalidad(.la, .menor)])
        #expect(recorrido.modulaciones.first?.pivote?.description == "Rem = ii en Do mayor = iv en La menor")
        #expect(recorrido.cifrados.suffix(3) == ["iv", "V7", "i"])
    }

    @Test func deMenorASuRelativa() throws {
        #expect(try (tonalidades("Lam Rem Mi7 Lam Do Fa Sol7 Do")) == [Tonalidad(.la, .menor), Tonalidad(.do)])
    }

    @Test func idaYVuelta() throws {
        let recorrido = try RecorridoTonal(leyendo: "Do Fa Sol7 Do Lam Re7 Sol Mim Sim Do Re7 Sol Sol7 Do Fa Sol7 Do")
        #expect(recorrido.tramos.map(\.tonalidad) == [Tonalidad(.do), Tonalidad(.sol), Tonalidad(.do)])
        #expect(recorrido.modulaciones.count == 2)
    }

    @Test func tonicalizacionNoEsModulacion() throws {
        // Las dominantes secundarias que resuelven no cambian la tonalidad.
        #expect(try (tonalidades("Do Lam Re7 Sol7 Do")) == [Tonalidad(.do)])
        #expect(try (tonalidades("Do La7 Rem Sol7 Do")) == [Tonalidad(.do)])
        #expect(try (tonalidades("Do Mi7 Lam Re7 Sol7 Do")) == [Tonalidad(.do)])
        #expect(try (tonalidades("Do Fa Sol Do")) == [Tonalidad(.do)])
        let unico = try RecorridoTonal(leyendo: "Do Lam Re7 Sol7 Do")
        #expect(unico.modulaciones == [])
        #expect(try unico.tramos[0].analisis == (AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")))
    }

    @Test func recorridoCorto() throws {
        #expect(RecorridoTonal([]) == nil)
        #expect(try (tonalidades("Sol7 Do")) == [Tonalidad(.do)])
    }
}
