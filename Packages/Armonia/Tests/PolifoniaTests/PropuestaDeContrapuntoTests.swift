import Testing

@testable import Elementos
@testable import Partituras
@testable import Polifonia
@testable import Teoria

/// Los contrapuntos que se proponen sobre un cantus no tienen faltas.
@Suite struct PropuestaDeContrapuntoTests {
    private func alturas(_ texto: String) throws -> [Altura] {
        try texto.split(separator: " ").map { try Altura(leyendo: String($0)) }
    }

    /// El cantus en re de Fux, encima y debajo.
    @Test func sobreElCantusDeFux() throws {
        let cantus = try alturas("Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4")
        let encima = Contrapunto.proponer(sobre: cantus, propuestas: 3)
        #expect(encima.count == 3)
        for propuesta in encima {
            #expect(propuesta.esCorrecto)
            #expect(propuesta.contrapuntoArriba)
            #expect(propuesta.cantusFirmus == cantus)
            #expect(propuesta.especie == .primera)
        }
        // Distintas entre sí.
        #expect(Set(encima.map(\.contrapunto)).count == encima.count)
        let debajo = Contrapunto.proponer(sobre: cantus, arriba: false)
        #expect(debajo.count == 1)
        #expect(debajo.allSatisfy { $0.esCorrecto && !$0.contrapuntoArriba })
    }

    /// Termina por grado conjunto en la octava o el unísono, con la sensible si hace falta (Do♯ en re).
    @Test func terminaConLaSensible() throws {
        let cantus = try alturas("Re4 Fa4 Mi4 Re4 Sol4 Fa4 La4 Sol4 Fa4 Mi4 Re4")
        let propuesta = try #require(Contrapunto.proponer(sobre: cantus).first)
        let notas = propuesta.contrapunto.eventos.flatMap(\.alturas)
        #expect(notas.last?.nota == .re)
        #expect(notas[notas.count - 2].nota == Nota(.do, .sostenido))
    }

    @Test func casosLimite() throws {
        #expect(Contrapunto.proponer(sobre: []).isEmpty)
        #expect(try Contrapunto.proponer(sobre: alturas("Do4 Re4"), propuestas: 0).isEmpty)
        // Una sola nota: la octava (o el unísono).
        let una = Contrapunto.proponer(sobre: try alturas("Do4"))
        #expect(una.allSatisfy { $0.esCorrecto })
    }
}
