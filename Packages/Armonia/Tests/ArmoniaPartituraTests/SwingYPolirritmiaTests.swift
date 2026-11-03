import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaPartitura

/// El swing y las polirritmias.
@Suite struct SwingYPolirritmiaTests {
    @Test func swingTernario() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:2")
        let conSwing = voz.conSwing()
        #expect(conSwing.ritmo == [Duracion(1, 6), Duracion(1, 12), Duracion(1, 6), Duracion(1, 12), .blanca])
        #expect(conSwing.melodia == voz.melodia)
        #expect(conSwing.duracion == voz.duracion)
        // Una negra a contratiempo empieza más tarde y dura lo mismo.
        let sincopa = try Voz(leyendo: "Do4:8 Re4:4 Mi4:8").conSwing()
        #expect(sincopa.ritmo == [Duracion(1, 6), .negra, Duracion(1, 12)])
    }

    @Test func otrasProporciones() throws {
        let voz = try Voz(leyendo: "Do4:8 Re4:8 Mi4:4")
        #expect(voz.conSwing(.conPuntillo).ritmo == [Duracion(3, 16), .semicorchea, .negra])
        #expect(voz.conSwing(.recto) == voz)
        let semicorcheas = try #require(Swing(unidad: .semicorchea, largo: 2, corto: 1))
        #expect(voz.conSwing(semicorcheas).ritmo == voz.ritmo)
        #expect(Swing(largo: 0, corto: 1) == nil)
        #expect(Swing(unidad: .cero, largo: 2, corto: 1) == nil)
    }

    @Test func swingConAnacrusa() throws {
        // La anacrusa de una corchea es la segunda de su par: se acorta.
        let voz = try Voz(leyendo: "Sol4:8 Do5:8 Re5:8 Mi5:2.", compas: "4/4", anacrusa: .corchea)
        #expect(voz.conSwing().ritmo == [Duracion(1, 12), Duracion(1, 6), Duracion(1, 12), Duracion(3, 4)])
    }

    @Test func tresContraDos() throws {
        let polirritmia = try #require(Polirritmia(3, contra: 2))
        let ataques = polirritmia.ataques()
        #expect(ataques.primera == [.cero, Duracion(1, 3), Duracion(2, 3)])
        #expect(ataques.segunda == [.cero, .blanca])
        #expect(polirritmia.resultante() == [Duracion(1, 3), Duracion(1, 6), Duracion(1, 6), Duracion(1, 3)])
        #expect(polirritmia.resultante(ciclo: .blanca).reduce(.cero, +) == .blanca)
        let voces = polirritmia.voces(compases: 2)
        #expect(voces.count == 2)
        #expect(voces[0].ritmo == Array(repeating: Duracion(1, 3), count: 6))
        #expect(voces[1].ritmo == Array(repeating: .blanca, count: 4))
        #expect(voces[0].melodia.alturas.allSatisfy { $0 == Altura("Do5") })
        #expect(Polirritmia(0, contra: 2) == nil)
    }

    @Test func cuatroContraTres() throws {
        let polirritmia = try #require(Polirritmia(4, contra: 3))
        // 0, 1/4, 1/3, 1/2, 2/3, 3/4.
        #expect(
            polirritmia.resultante() == [
                Duracion(1, 4), Duracion(1, 12), Duracion(1, 6), Duracion(1, 6), Duracion(1, 12), Duracion(1, 4),
            ])
    }
}
