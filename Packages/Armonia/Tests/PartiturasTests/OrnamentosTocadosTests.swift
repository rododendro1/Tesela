import Elementos
import Partituras
import Teoria
import Testing

// Los ornamentos tocados en sus notas: `Evento.realizandoElOrnamento(en:)`, `Voz.conLosOrnamentosRealizados(en:)` y
// `Partitura.conLosOrnamentosRealizados(en:)`.

@Suite struct OrnamentosTocadosTests {
    let doMayor = Escala(.do)

    func tocado(_ texto: String, en escala: Escala = Escala(.do)) throws -> String {
        try Evento(leyendo: texto).realizandoElOrnamento(en: escala).map(\.description).joined(separator: " ")
    }

    /// Cada signo con su ornamento del catálogo; las demás articulaciones, sin ninguno.
    @Test func elOrnamentoDeCadaSigno() {
        #expect(Articulacion.trino.ornamento == .trino)
        #expect(Articulacion.mordenteSuperior.ornamento == .mordenteSuperior)
        #expect(Articulacion.mordenteInferior.ornamento == .mordente)
        #expect(Articulacion.grupeto.ornamento == .grupeto)
        #expect(Articulacion.grupetoInvertido.ornamento == .grupetoInvertido)
        #expect(Articulacion.allCases.filter { $0.ornamento != nil } == Articulacion.allCases.filter(\.esOrnamento))
    }

    /// El trino, en fusas desde la de encima, acaba en la principal; en una corchea, en cuartos de la nota.
    @Test func elTrino() throws {
        #expect(try tocado("Re4:4{trino}") == "Mi4:32 Re4:32 Mi4:32 Re4:32 Mi4:32 Re4:32 Mi4:32 Re4:32")
        #expect(try tocado("Re4:8{trino}") == "Mi4:32 Re4:32 Mi4:32 Re4:32")
        // En una negra con puntillo, la principal se queda con lo que sobra.
        let largo = try Evento(leyendo: "Re4:4.{trino}").realizandoElOrnamento(en: doMayor)
        #expect(largo.count == 12 && largo.last?.duracion == .fusa)
        #expect(largo.map(\.duracion).reduce(.cero, +) == Duracion(3, 8))
        // En Fa mayor, la de encima de La es Si♭.
        #expect(try tocado("La4:8{trino}", en: Escala(.fa)) == "Si♭4:32 La4:32 Si♭4:32 La4:32")
    }

    /// Los mordentes, en fusas, y la principal sostenida; los grupetos, en semicorcheas.
    @Test func losMordentesYLosGrupetos() throws {
        #expect(try tocado("Mi4:4{mordenteInferior}") == "Mi4:32 Re4:32 Mi4:8.")
        #expect(try tocado("Mi4:4{mordenteSuperior}") == "Mi4:32 Fa4:32 Mi4:8.")
        #expect(try tocado("Re4:4{grupeto}") == "Mi4:16 Re4:16 Do4:16 Re4:16")
        let largo = try Evento(leyendo: "Re4:2{grupetoInvertido}").realizandoElOrnamento(en: doMayor)
        #expect(largo.map(\.alturas[0].description) == ["Do4", "Re4", "Mi4", "Re4"])
        #expect(largo.map(\.duracion) == [.semicorchea, .semicorchea, .semicorchea, Duracion(5, 16)])
        #expect(try tocado("Re4:16{grupeto}") == "Mi4:64 Re4:64 Do4:64 Re4:64")
    }

    /// La dinámica y las demás articulaciones van en la primera nota, y la ligadura, en la última.
    @Test func laExpresionYLaLigadura() throws {
        #expect(try tocado("Mi4:4~{f,acento,mordenteInferior}") == "Mi4:32{f,acento} Re4:32 Mi4:8.~")
    }

    /// Sin ornamento, un silencio, un acorde o una nota fuera de la escala quedan tal cual.
    @Test func loQueNoSeToca() throws {
        #expect(try tocado("Re4:4{acento}") == "Re4:4{acento}")
        #expect(try tocado("-:4{calderon}") == "-:4{calderon}")
        #expect(try tocado("Do4+Mi4:4{trino}") == "Do4+Mi4:4{trino}")
        #expect(try tocado("Fa♯4:4{grupeto}") == "Fa♯4:4{grupeto}")
    }

    /// En una voz y en una partitura, en la escala de su tonalidad.
    @Test func enLaVozYEnLaPartitura() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4{mordenteInferior} Mi4:2")
        #expect(voz.conLosOrnamentosRealizados(en: doMayor).eventos.count == 5)
        let enSol = Partitura(
            .init(try Voz(leyendo: "Sol4:4{grupeto} Sol4:4")), encabezado: Encabezado(tonalidad: Tonalidad(.sol)))
        let tocada = enSol.conLosOrnamentosRealizados()
        let eventos = tocada.pentagramas[0].voces[0].voz.eventos.map(\.description)
        #expect(eventos == ["La4:16", "Sol4:16", "Fa♯4:16", "Sol4:16", "Sol4:4"])
        let enDo = Partitura(.init(try Voz(leyendo: "Sol4:4{grupeto}"))).conLosOrnamentosRealizados()
        #expect(enDo.pentagramas[0].voces[0].voz.eventos[2].description == "Fa4:16")
    }
}
