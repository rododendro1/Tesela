import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las escalas simétricas y las líneas de notas guía.
@Suite struct SimetriaYNotasGuiaTests {
    @Test func escalasSimetricas() {
        #expect(Escala(.do, .disminuida).intervaloDeSimetria == 3)
        #expect(Escala(.do, .tonosEnteros).intervaloDeSimetria == 2)
        #expect(Escala(.do, .aumentada).intervaloDeSimetria == 4)
        #expect(Escala(.do, .cromatica).intervaloDeSimetria == 1)
        #expect(Escala(.do).intervaloDeSimetria == nil)
        #expect(Escala(.do, .disminuida).transposicionesDistintas == 3)
        #expect(Escala(.do).transposicionesDistintas == 12)
        #expect(Escala(.do, .disminuidaSemitonoTono).tonicasEquivalentes.map(\.nombre) == ["Do", "Mi♭", "Fa♯", "La"])
        #expect(Escala(.re).tonicasEquivalentes == [.re])
        let vacia = Escala(.do, TipoDeEscala(nombre: "vacía", intervalos: []))
        #expect(vacia.intervaloDeSimetria == nil)
    }

    @Test func ciclosDeAcordes() throws {
        let semitonoTono = Escala(.do, .disminuidaSemitonoTono).ciclosSimetricos
        let tipos = semitonoTono.map(\.tipo)
        #expect(tipos.contains(.mayor) && tipos.contains(.dominanteSeptima) && tipos.contains(.disminuidoSeptima))
        #expect(!tipos.contains(.aumentado))
        let dominantes = try #require(semitonoTono.first { $0.tipo == .dominanteSeptima })
        #expect(dominantes.acordes.map(\.fundamental.nombre) == ["Do", "Mi♭", "Fa♯", "La"])
        #expect(Escala(.do, .tonosEnteros).ciclosSimetricos.map(\.tipo) == [.aumentado, .aumentadoSeptima])
        #expect(Escala(.do, .tonosEnteros).ciclosSimetricos[0].acordes.count == 6)
        #expect(Escala(.do, .disminuida).ciclosSimetricos.map(\.tipo) == [.disminuido, .disminuidoSeptima])
        #expect(Escala(.do).ciclosSimetricos.isEmpty)
        #expect(Escala(.do, .cromatica).ciclosSimetricos.isEmpty)
    }

    @Test func lineasDeNotasGuia() {
        let iiVI = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        #expect(Acorde.lineaDeNotasGuia(iiVI).map(\.midi) == [65, 65, 64])
        #expect(Acorde.lineaDeNotasGuia(iiVI, desde: .septima).map(\.midi) == [60, 59, 59])
        #expect(Acorde.lineaDeNotasGuia(iiVI, octava: 5).first?.midi == 77)
        // Un acorde sin tercera ni séptima da su fundamental.
        let quintas = [Acorde("Do5"), Acorde("Sol7")]
        #expect(Acorde.lineaDeNotasGuia(quintas).map(\.midi) == [60, 59])
        #expect(Acorde.lineaDeNotasGuia([]).isEmpty)
    }
}
