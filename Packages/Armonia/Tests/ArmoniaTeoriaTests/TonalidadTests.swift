import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

@Suite struct TonalidadTests {
    private func escrito(_ escala: Escala, _ midi: [Int]) -> [String] {
        escala.ortografiar(midi: midi).map(\.nota.nombre)
    }

    @Test func ortografiaCromaticaSegunLaDireccion() {
        let doMayor = Escala(.do)
        #expect(escrito(doMayor, [60, 61, 62]) == ["Do", "Do♯", "Re"])
        #expect(escrito(doMayor, [62, 61, 60]) == ["Re", "Re♭", "Do"])
        #expect(escrito(doMayor, [67, 68, 69]) == ["Sol", "Sol♯", "La"])
        #expect(escrito(doMayor, [69, 68, 67]) == ["La", "La♭", "Sol"])
        #expect(escrito(doMayor, [69, 70, 71]) == ["La", "La♯", "Si"])
        #expect(escrito(doMayor, [71, 70, 69]) == ["Si", "Si♭", "La"])
        #expect(escrito(doMayor, [60, 61, 61, 62]) == ["Do", "Do♯", "Do♯", "Re"])
    }

    @Test func ortografiaSinContexto() {
        let doMayor = Escala(.do)
        // Cada nota por separado (sin nota siguiente que indique dirección).
        #expect([61, 63, 66, 68, 70].map { escrito(doMayor, [$0])[0] } == ["Do♯", "Mi♭", "Fa♯", "La♭", "Si♭"])
        // En una línea ascendente suben con sostenido (la última, sin siguiente, vuelve a Si♭).
        #expect(escrito(doMayor, [61, 63, 66, 68, 70]) == ["Do♯", "Re♯", "Fa♯", "Sol♯", "Si♭"])
        #expect(escrito(Escala(.fa), [70]) == ["Si♭"])
        #expect(escrito(Escala(.la, .menorNatural), [68]) == ["Sol♯"])
        #expect(escrito(Escala(.la, .menorArmonica), [68]) == ["Sol♯"])
        #expect(escrito(Escala("Fa# mayor"), [65, 60]) == ["Mi♯", "Si♯"])
        #expect(Altura(midi: 70, escala: Escala(.fa)).description == "Si♭4")
        #expect(Escala(.do).ortografiar(midi: [60, 61, 62]).map(\.midi) == [60, 61, 62])
    }

    @Test func deteccionDeTonalidad() {
        let doMayor = Tonalidad.candidatos(midi: [60, 62, 64, 65, 67, 69, 71, 72])
        #expect(doMayor.count == 24)
        #expect(doMayor.first?.valor == Tonalidad(.do))
        #expect(doMayor.map(\.correlacion) == doMayor.map(\.correlacion).sorted(by: >))

        let laMenor = Tonalidad.candidatos(midi: [69, 71, 72, 74, 76, 77, 80, 81, 69, 76, 69])
        #expect(laMenor.first?.valor == Tonalidad(.la, .menor))

        #expect(Tonalidad.candidatos(midi: [61, 63, 65, 66, 68, 70, 72, 73]).first?.valor.nombre == "Re♭ mayor")
        #expect(Tonalidad.candidatos(midi: [66, 68, 70, 71, 73, 75, 77, 78]).first?.valor.nombre == "Fa♯ mayor")
        let solBemol: [Nota] = ["Solb", "Lab", "Sib", "Dob", "Reb", "Mib", "Fa"]
        #expect(Tonalidad.candidatos(notas: solBemol).first?.valor.nombre == "Sol♭ mayor")

        let ponderada = Tonalidad.candidatos(
            midi: [60, 64, 67, 72, 67, 64, 60],
            duraciones: [2, 1, 1, 2, 1, 1, 2])
        #expect(ponderada.first?.valor == Tonalidad(.do))
        #expect(Tonalidad.candidatos(midi: []).isEmpty)
    }
}
