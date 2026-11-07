import Foundation
import Testing

@testable import Elementos

@Suite struct VentanaDeQuintasTests {
    @Test func lasDeSiempre() {
        #expect(VentanaDeQuintas.sostenidos.description == "Fa–La♯")
        #expect(VentanaDeQuintas.bemoles.description == "Sol♭–Si")
        #expect(VentanaDeQuintas.sostenidos.nota(claseDeAltura: 10) == Nota(.la, 1))
        #expect(VentanaDeQuintas.bemoles.nota(claseDeAltura: 10) == Nota(.si, -1))
    }

    @Test func losAtajos() {
        #expect(VentanaDeQuintas.masSimple == .centrada(en: "Do"))
        #expect(VentanaDeQuintas.masSimple.description == "Re♭–Fa♯")
        #expect(VentanaDeQuintas.habitual.description == "Mi♭–Sol♯")
        let negras = [1, 3, 6, 8, 10].map { VentanaDeQuintas.habitual.nota(claseDeAltura: $0).nombre }
        #expect(negras == ["Do♯", "Mi♭", "Fa♯", "Sol♯", "Si♭"])
        #expect(VentanaDeQuintas.armadura(0).description == "La♭–Do♯")
        #expect(VentanaDeQuintas.armadura(2).description == "Si♭–Re♯")
        #expect(VentanaDeQuintas.armadura(-3).description == "Do♭–Mi")
        // Las siete notas de la armadura están dentro.
        for alteraciones in -7...7 {
            let ventana = VentanaDeQuintas.armadura(alteraciones)
            #expect(((alteraciones - 1)...(alteraciones + 5)).allSatisfy { ventana.contiene(Nota(pasosDeQuinta: $0)) })
        }
    }

    @Test func centradaEnUnaTonica() {
        #expect(VentanaDeQuintas.centrada(en: "Do").description == "Re♭–Fa♯")
        #expect(VentanaDeQuintas.centrada(en: "Re").description == "Mi♭–Sol♯")
        #expect(VentanaDeQuintas.centrada(en: "Re").nota(claseDeAltura: 1) == Nota(.do, 1))
        #expect(VentanaDeQuintas.centrada(en: "Fa") == .bemoles)
        // Alrededor de Do, las mismas notas que `enarmonicaMasSimple`.
        for quintas in -20...20 {
            let nota = Nota(pasosDeQuinta: quintas)
            #expect(VentanaDeQuintas.centrada(en: "Do").reescrita(nota) == nota.enarmonicaMasSimple)
        }
    }

    @Test func desdeUnaNota() {
        let ventana = VentanaDeQuintas(desde: "Re♭")
        #expect(ventana.inicio == -5)
        #expect(ventana.primera == Nota(.re, -1))
        #expect(ventana.ultima == Nota(.fa, 1))
        #expect(ventana.contiene(Nota(.re, -1)))
        #expect(!ventana.contiene(Nota(.do, 1)))
    }

    @Test func unaNotaDeCadaClase() {
        for inicio in -15...15 {
            let ventana = VentanaDeQuintas(inicio: inicio)
            let notas = ventana.notas
            #expect(notas.count == 12)
            #expect(Set(notas.map(\.claseDeAltura)) == Set(0..<12))
            #expect(notas.allSatisfy(ventana.contiene))
            for clase in 0..<12 {
                let nota = ventana.nota(claseDeAltura: clase)
                #expect(nota.claseDeAltura == clase)
                #expect(ventana.contiene(nota))
                #expect(ventana.nota(claseDeAltura: clase + 12 * 5) == nota)
                #expect(ventana.nota(claseDeAltura: clase - 12 * 5) == nota)
            }
        }
    }

    @Test func alturaDesdeMIDI() {
        #expect(Altura(midi: 70, ventana: .bemoles).description == "Si♭4")
        #expect(Altura(midi: 70, ventana: .sostenidos).description == "La♯4")
        #expect(Altura(midi: 66, ventana: .centrada(en: "Fa")).description == "Sol♭4")
        // Una ventana que no llega a Do: de Re a Fa𝄪, y Si♯3 suena como Do4.
        #expect(Altura(midi: 60, ventana: VentanaDeQuintas(desde: "Re")).description == "Si♯3")
        for midi in 0...127 {
            #expect(Altura(midi: midi, ventana: .sostenidos) == Altura(midi: midi))
            for inicio in -12...12 {
                let altura = Altura(midi: midi, ventana: VentanaDeQuintas(inicio: inicio))
                #expect(altura.midi == midi)
                #expect(VentanaDeQuintas(inicio: inicio).contiene(altura.nota))
            }
        }
    }

    @Test func laQueContieneUnasNotas() {
        func ventana(_ notas: [Nota]) -> String? { VentanaDeQuintas(conteniendo: notas)?.description }
        #expect(ventana(["Do", "Mi", "Sol"]) == "La♭–Do♯")
        #expect(ventana(["Do", "Mi", "Sol", "Si♭"]) == "Re♭–Fa♯")
        #expect(ventana(["Do", "Mi♭"]) == "Sol♭–Si")
        #expect(ventana(["Fa♯", "La♯", "Do♯"]) == "Fa–La♯")
        // Si las naturales no caben, se queda fuera la menos posible.
        #expect(ventana(["Do♯", "Mi♯", "Sol♯"]) == "Do–Mi♯")
        #expect(ventana(["Do♭", "Mi♭", "Sol♭"]) == "Do♭–Mi")
        #expect(ventana([]) == nil)
        #expect(ventana(["Re♭", "Do♯"]) == nil)
        // Una nota sola: la centrada en ella, si tiene las naturales.
        for nota in ["Fa", "Do", "Re", "La", "Mi"] as [Nota] {
            #expect(VentanaDeQuintas(conteniendo: [nota]) == .centrada(en: nota))
        }
        // Las notas repetidas no cuentan dos veces.
        #expect(ventana(["Do", "Do", "Do", "Mi♭"]) == ventana(["Do", "Mi♭"]))
        // Siempre las contiene.
        let notas: [Nota] = ["Sol♯", "Si", "Re", "Fa"]
        #expect(VentanaDeQuintas(conteniendo: notas).map { v in notas.allSatisfy(v.contiene) } == true)
    }

    @Test func reescribeAlturas() {
        #expect(VentanaDeQuintas.sostenidos.reescrita(Altura("Si♭4")).description == "La♯4")
        #expect(VentanaDeQuintas.masSimple.reescrita(Altura("Si♯3")).description == "Do4")
        #expect(VentanaDeQuintas.bemoles.reescrita(Altura("Do4")) == Altura("Do4"))
        for midi in 40...80 {
            let altura = Altura(midi: midi)
            #expect(VentanaDeQuintas.bemoles.reescrita(altura).midi == midi)
        }
    }

    @Test func seGuardaEnJSON() throws {
        let ventana = VentanaDeQuintas.centrada(en: "Re")
        let datos = try JSONEncoder().encode(ventana)
        #expect(try JSONDecoder().decode(VentanaDeQuintas.self, from: datos) == ventana)
    }
}
