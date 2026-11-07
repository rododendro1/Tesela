import Testing

@testable import Elementos
@testable import Polifonia
@testable import Teoria

/// Las reglas que comparten el coral y el contrapunto.
@Suite struct ConduccionTests {
    private func paso(_ antes: (String, String), _ despues: (String, String)) throws -> Conduccion.PasoDeVoces {
        Conduccion.PasoDeVoces(
            de: (try Altura(leyendo: antes.0), try Altura(leyendo: antes.1)),
            a: (try Altura(leyendo: despues.0), try Altura(leyendo: despues.1)))
    }

    @Test func lasConsonanciasPerfectas() throws {
        #expect(Conduccion.perfecta(.quintaJusta) == 5)
        #expect(Conduccion.perfecta(.octava) == 8)
        #expect(Conduccion.perfecta(.unisono) == 8)
        #expect(Conduccion.perfecta(.terceraMayor) == nil)
        #expect(Conduccion.perfecta(.quintaDisminuida) == nil)
        // Del grave al agudo, en el orden que vengan.
        #expect(Conduccion.intervalo(try Altura(leyendo: "Sol4"), try Altura(leyendo: "Do4")) == .quintaJusta)
    }

    @Test func paralelasYDirectas() throws {
        // Do–Sol a Re–La: quintas paralelas.
        #expect(try paso(("Do4", "Sol4"), ("Re4", "La4")).paralelas == 5)
        // Si una voz se queda, no son paralelas.
        #expect(try paso(("Do4", "Sol4"), ("Do4", "Sol4")).paralelas == nil)
        // De una tercera a una octava, las dos subiendo: octavas directas.
        let directas = try paso(("Do4", "Mi4"), ("Re4", "Re5"))
        #expect(directas.directas == 8)
        #expect(directas.paralelas == nil)
        // Por movimiento contrario, nada.
        #expect(try paso(("Do4", "Mi5"), ("Re4", "Re5")).directas == nil)
    }

    @Test func losSaltos() throws {
        let tritono = try Altura(leyendo: "Fa4").intervalo(hasta: try Altura(leyendo: "Si4"))
        let sextaMenor = try Altura(leyendo: "Mi4").intervalo(hasta: try Altura(leyendo: "Do5"))
        // En la armonía, la sexta menor vale y el tritono (cuarta aumentada), no.
        #expect(Conduccion.Saltos.armonia.noEsMelodico(tritono, ascendente: true))
        #expect(!Conduccion.Saltos.armonia.noEsMelodico(sextaMenor, ascendente: false))
        // En el contrapunto estricto, la sexta menor solo subiendo.
        #expect(!Conduccion.Saltos.contrapunto.noEsMelodico(sextaMenor, ascendente: true))
        #expect(Conduccion.Saltos.contrapunto.noEsMelodico(sextaMenor, ascendente: false))
    }
}
