import Testing

@testable import ArmoniaElementos
@testable import ArmoniaPartitura

/// Las frases, las letras de la forma y los motivos de una voz.
@Suite struct FormaTests {
    @Test func frasesQueAcabanEnUnaNotaLarga() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Re4:4 Mi4:4 Do4:2")
        let frases = voz.frases()
        #expect(frases.map(\.eventos) == [0..<3, 3..<6])
        #expect(frases.map(\.inicio) == [.cero, .redonda])
        #expect(frases.map(\.duracion) == [.redonda, .redonda])
        // Con un mínimo de dos compases, es una sola frase.
        #expect(voz.frases(minimo: Duracion(2)).map(\.eventos) == [0..<6])
    }

    @Test func frasesQueAcabanEnUnSilencio() throws {
        // El silencio se queda en la frase que cierra.
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4 -:4 Fa4:4 Mi4:4 Re4:2")
        #expect(voz.frases().map(\.eventos) == [0..<4, 4..<7])
    }

    @Test func unaNotaLigadaCuentaUnaVez() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4~ Mi4:4 Re4:4 Mi4:4 Do4:2")
        #expect(voz.frases().map(\.eventos) == [0..<4, 4..<7])
    }

    @Test func sinNotas() {
        let vacia = Voz([], compas: Compas(4, 4))
        #expect(vacia.frases().isEmpty && vacia.forma().isEmpty && vacia.motivos().isEmpty)
    }

    @Test func letrasDeLaForma() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Do4:4 Re4:4 Mi4:2 Sol4:4 Fa4:4 Mi4:2 Do4:4 Re4:4 Do4:2")
        #expect(voz.forma() == ["A", "A", "B", "A′"])
        // Una frase transportada lleva la misma letra.
        #expect(try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Sol4:4 La4:4 Si4:2").forma() == ["A", "A"])
    }

    @Test func unMotivoQueVuelve() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Do4:8 Sol4:2 Do4:8 Re4:8 Mi4:8 Do4:8 La4:2")
        let motivos = voz.motivos()
        #expect(motivos.count == 1, "\(motivos)")
        let motivo = try #require(motivos.first)
        #expect(motivo.intervalos == [2, 2, -4])
        #expect(motivo.ritmo == [.corchea, .corchea, .corchea])
        #expect(motivo.notas == 4)
        #expect(motivo.apariciones == [0, 5])
        #expect(motivo.transposiciones == [0, 0])
        #expect(!motivo.esSecuencia)
    }

    @Test func unaSecuencia() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4 Re4:8 Mi4:8 Fa#4:4 Mi4:8 Fa#4:8 Sol#4:2")
        let secuencia = try #require(voz.motivos(minimo: 3).first { $0.esSecuencia })
        #expect(secuencia.intervalos == [2, 2])
        #expect(secuencia.apariciones == [0, 3, 6])
        #expect(secuencia.transposiciones == [0, 2, 4])
    }

    @Test func repetirUnaNotaNoEsUnMotivo() throws {
        #expect(try Voz(leyendo: "Do4:4 Do4:4 Do4:4 Do4:4 Do4:4 Do4:4 Do4:4 Do4:4").motivos().isEmpty)
    }
}
