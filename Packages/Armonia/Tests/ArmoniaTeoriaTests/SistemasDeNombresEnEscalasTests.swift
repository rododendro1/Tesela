import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaTeoria

/// Las notas de una escala con los nombres bizantinos y del sargam, también en su versión microtonal.
@Suite struct SistemasDeNombresEnEscalasTests {
    @Test func sargamDesdeLaTonica() {
        #expect(Escala(.re, .dorico).nombres(en: .sargam) == ["Sā", "Re", "ga", "ma", "Pa", "Dha", "ni"])
        #expect(Escala(.do, .mayor).nombres(en: .sargam) == ["Sā", "Re", "Ga", "ma", "Pa", "Dha", "Ni"])
        #expect(Escala(.do, .kafi).nombres(en: .sargam) == ["Sā", "Re", "ga", "ma", "Pa", "Dha", "ni"])
        #expect(
            Escala(.do, .mayor).nombres(en: .sargam, grafia: .original) == ["सा", "रे", "ग", "म", "प", "ध", "नि"])
        // Lidio: con el Ma tivra.
        let lidio = Escala(.sol, .lidio).nombres(en: .sargam, grafia: .ascii)
        #expect(lidio == ["Sa", "Re", "Ga", "Ma", "Pa", "Dha", "Ni"])
    }

    @Test func bizantinoConNiEnDo() {
        #expect(Escala(.re, .echosProtos).nombres(en: .bizantino) == ["Pa", "Vou", "Ga", "Di", "Ke", "Zo", "Ni"])
        #expect(
            Escala(.re, .echosProtos).nombres(en: .bizantino, grafia: .original)
                == ["Πα", "Βου", "Γα", "Δι", "Κε", "Ζω", "Νη"])
    }

    @Test func bizantinoEnMoria() throws {
        let notas = try #require(Escala(.re, .echosProtos).notasMicrotonales())
        // Vou y Zo, dos moria bajo Mi y Si.
        #expect(notas.map { $0.nombre(en: .bizantino) } == ["Pa", "Vou⁻²", "Ga", "Di", "Ke", "Zo⁻²", "Ni"])
        let ascii = notas.map { $0.nombre(en: .bizantino, grafia: .ascii) }
        #expect(ascii == ["Pa", "Vou(-2)", "Ga", "Di", "Ke", "Zo(-2)", "Ni"])
    }
}
