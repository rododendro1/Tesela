import Testing

@testable import Elementos
@testable import Teoria

@Suite struct VentanaDeQuintasDeEscalaTests {
    @Test func lasDeUnaEscala() {
        #expect(Escala("Do mayor").ventanaDeQuintas == .armadura(0))
        #expect(Escala("Do mayor").ventanaDeQuintas?.description == "La♭–Do♯")
        #expect(Escala("La menor armónica").ventanaDeQuintas?.description == "Si♭–Re♯")
        #expect(Escala("Fa mayor").ventanaDeQuintas == .masSimple)
        #expect(Tonalidad("La menor").ventanaDeQuintas == Escala("La menor armónica").ventanaDeQuintas)
        #expect(Tonalidad("Re mayor").ventanaDeQuintas == .armadura(2))
    }

    @Test func contieneLasNotasDeLaEscala() {
        let tipos: [TipoDeEscala] = [.mayor, .dorico, .lidio, .mixolidio, .menorArmonica, .menorMelodica]
        for tipo in tipos {
            for quintas in -7...7 {
                let escala = Escala(Nota(pasosDeQuinta: quintas), tipo)
                guard let ventana = escala.ventanaDeQuintas else {
                    Issue.record("\(escala) sin ventana")
                    continue
                }
                #expect(escala.notasEnAmbasDirecciones.allSatisfy(ventana.contiene), "\(escala)")
                // Nombra las doce clases como la escala, sin nota siguiente.
                for clase in 0..<12 {
                    let nombre = escala.nombre(claseDeAltura: clase)
                    #expect(ventana.nota(claseDeAltura: clase) == nombre, "\(escala) \(clase)")
                }
            }
        }
    }

    @Test func lasMayoresSonLasDeSuArmadura() {
        for armadura in -7...7 {
            #expect(Tonalidad(armadura: armadura).ventanaDeQuintas == .armadura(armadura))
        }
    }
}
