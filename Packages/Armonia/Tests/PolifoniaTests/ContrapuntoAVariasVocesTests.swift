import Testing

@testable import Elementos
@testable import Partituras
@testable import Polifonia
@testable import Teoria

/// El contrapunto de especies a tres y cuatro voces.
@Suite struct ContrapuntoAVariasVocesTests {
    private let cantus = "Re4 Fa4 Mi4 Re4"

    private func faltas(
        _ cantus: String, _ voces: [(contrapunto: String, especie: Contrapunto.Especie)]
    ) throws -> [FaltaEntreVoces] {
        try ContrapuntoAVariasVoces(cantusFirmus: cantus, voces: voces).faltas
    }

    private func falta(
        _ tipo: FaltaDeContrapunto.Tipo, _ compases: ClosedRange<Int>, _ voces: [Int]
    ) -> FaltaEntreVoces {
        FaltaEntreVoces(falta: FaltaDeContrapunto(tipo: tipo, compases: compases), voces: voces)
    }

    @Test func unEjercicioCorrectoATresVoces() throws {
        // El bajo llega a la tónica saltando desde la dominante; las quintas directas entre el cantus y el bajo no
        // cuentan, porque no son las voces extremas.
        let ejercicio = try ContrapuntoAVariasVoces(
            cantusFirmus: cantus, voces: [("La4 La4 Do#5 Re5", .primera), ("Re3 Re3 La2 Re3", .primera)])
        #expect(ejercicio.voces.count == 2)
        #expect(ejercicio.cantusFirmus.count == 4)
        #expect(ejercicio.faltas == [], "\(ejercicio.faltas)")
        #expect(ejercicio.esCorrecto)
    }

    @Test func quintasParalelasEntreLasVocesQueSeAnaden() throws {
        let todas = try faltas(cantus, [("La4 La4 Sol4 La4", .primera), ("Re3 Re3 Do3 Re3", .primera)])
        #expect(todas.contains(falta(.quintasParalelas, 1...2, [1, 2])), "\(todas)")
        #expect(todas.contains(falta(.quintasParalelas, 2...3, [1, 2])), "\(todas)")
    }

    @Test func unaCuartaSoloEsDisonanciaConElBajo() throws {
        // La4 sobre Mi4 es una cuarta, pero el bajo es Do4: es un acorde de sexta.
        let altas = try faltas("La4 Si4", [("Mi4 Fa4", .primera), ("Do4 Re4", .primera)])
        #expect(!altas.contains { $0.falta.tipo == .disonanciaEnParteFuerte }, "\(altas)")
        // Fa4 sobre Do4, el bajo, sí es una disonancia.
        let conElBajo = try faltas("Fa4 Mi4", [("La4 Sol4", .primera), ("Do4 Do4", .primera)])
        #expect(conElBajo.contains(falta(.disonanciaEnParteFuerte, 0...0, [0, 2])), "\(conElBajo)")
    }

    @Test func elPrincipioSeMideDesdeElBajo() throws {
        // La4 sobre el bajo Do4 es una sexta: no vale para empezar.
        let todas = try faltas("Mi4 Re4", [("La4 Sol4", .primera), ("Do4 Si3", .primera)])
        #expect(todas.contains(falta(.comienzoImperfecto, 0...0, [1, 2])), "\(todas)")
    }

    @Test func crucesYUnisonos() throws {
        // Fa4 en la voz de arriba pasa por debajo del cantus en el segundo compás; Re4 y Re4, unísono en medio.
        let todas = try faltas(
            "Re4 Mi4 Fa4 Mi4 Re4", [("La4 Re4 Re5 Do#5 Re5", .primera), ("Re3 Re4 Re3 La2 Re3", .primera)])
        #expect(todas.contains(falta(.cruceDeVoces, 1...1, [0, 1])), "\(todas)")
        #expect(todas.contains(falta(.unisono, 1...1, [1, 2])), "\(todas)")
        #expect(todas.map(\.falta.compases.lowerBound) == todas.map(\.falta.compases.lowerBound).sorted())
    }

    @Test func cadaVozConSuEspecie() throws {
        // La voz de arriba, en segunda especie, repite La4 de un compás al siguiente.
        let todas = try faltas(cantus, [("-:2 La4 La4 Fa4 Do#5:1 Re5:1", .segunda), ("Re3 Re3 La2 Re3", .primera)])
        #expect(todas.contains(falta(.notaRepetida, 0...1, [0, 1])), "\(todas)")
    }

    @Test func sinVocesNoHayEjercicio() {
        #expect(throws: (any Error).self) { try ContrapuntoAVariasVoces(cantusFirmus: "Re4 Mi4", voces: []) }
        let cantus = [Altura("Re4"), Altura("Mi4")]
        #expect(throws: ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio)) {
            try ContrapuntoAVariasVoces(cantusFirmus: cantus, voces: [])
        }
        let corta: [Evento] = [Evento(Altura("La4"), .redonda)]
        #expect(
            throws: ErrorDeLecturaDePartitura(texto: "", posicion: nil, motivo: .contrapuntoDeOtraDuracion(redondas: 2))
        ) { try ContrapuntoAVariasVoces(cantusFirmus: cantus, voces: [(corta, .primera)]) }
    }

    @Test func lasVocesVanOrdenadas() {
        let unisono = falta(.unisono, 2...2, [2, 1])
        #expect(unisono.voces == [1, 2])
        #expect(unisono.description == unisono.falta.description)
    }
}

extension ContrapuntoAVariasVocesTests {
    @Test func elInformeNombraLasVoces() throws {
        let ejercicio = try ContrapuntoAVariasVoces(
            cantusFirmus: "Do4 Re4 Mi4 Do4", voces: [("Sol4 La4 Sol4 Do5", .primera), ("Do3 Re3 Mi3 Do3", .primera)])
        let informe = ejercicio.informe(en: .espanolCompacto).split(separator: "\n").map(String.init)
        #expect(informe.first == "Contrapunto a 3 voces")
        #expect(informe.contains("Quintas paralelas (compases 1 → 2): cantus firmus / voz 1"))
        #expect(informe.contains("Quintas paralelas (compases 1 → 2): voz 1 / voz 2"))
        #expect(ejercicio.informe(en: .inglesCompacto).hasPrefix("Counterpoint in 3 parts\n"))
    }
}
