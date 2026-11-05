import Testing

@testable import ArmoniaNucleo

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
}
