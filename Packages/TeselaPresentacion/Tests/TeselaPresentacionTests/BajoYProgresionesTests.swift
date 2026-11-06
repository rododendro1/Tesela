import Armonia
import Testing

@testable import TeselaPresentacion

// El bajo caminante sobre una progresión y las progresiones con los acordes de una escala.
@Suite struct BajoYProgresionesTests {
    let notacion = Notacion.espanolCompacto

    @Test func bajoCaminante() throws {
        let progresion = [Acorde("Rem7"), Acorde("Sol7"), Acorde("Do7M")]
        let bajo = try #require(PresentacionDeAnalisis.bajoCaminante(progresion, notacion: notacion))
        // Re Fa La La♭ | Sol Fa Re Re♭ | Do: notas del acorde y la cromática que lleva a la siguiente fundamental.
        #expect(bajo.alturas.map(\.midi) == [50, 53, 57, 56, 55, 53, 50, 49, 48])
        #expect(bajo.alturas[3].nota == Nota.la.bemol)
        #expect(bajo.compases.count == 3)
        #expect(bajo.compases[2] == Altura(.do, octava: 3).nombre(en: notacion))
        #expect(bajo.voz.eventos.map(\.duracion).last == .redonda)
        #expect(bajo.partitura.pentagramas[0].clave == .fa)
        #expect(bajo.partitura.pentagramas[0].numeroDeCuerdas == 4)
        #expect(bajo.partitura.pentagramas[0].voces[0].pulsaciones.count == 9)
        #expect(bajo.pentagrama.svg.hasPrefix("<svg"))
        #expect(bajo.pentagrama.descripcion.hasPrefix("Rem7 – Sol7 – Domaj7: "))
        // El bajo suena una octava más grave de lo que se escribe, con los acordes encima.
        #expect(bajo.sonido.notas.first?.midi == 38)
        #expect(bajo.sonido.notas.count == 9 + 12)
        #expect(!bajo.ficheros.isEmpty)
        #expect(PresentacionDeAnalisis.bajoCaminante([], notacion: notacion) == nil)
        let uno = try #require(PresentacionDeAnalisis.bajoCaminante([Acorde("Do")], notacion: notacion))
        #expect(uno.alturas.map(\.midi) == [48])
    }

    @Test func caminarEnElRegistro() {
        // Si hacia el destino no caben dos notas del acorde, se va hacia el otro lado.
        let compas = PresentacionDeAnalisis.caminar(
            Acorde("Fa"), desde: Altura(.fa, octava: 3), hasta: Altura(.la, octava: 3))
        #expect(compas.count == 4)
        #expect(compas.allSatisfy { PresentacionDeAnalisis.registroDelBajo.contains($0.midi) })
        #expect(compas[1].midi < compas[0].midi)
        // La de paso, al lado del destino y sin repetir la anterior.
        #expect(abs(compas[3].midi - 57) == 1)
        #expect(compas[3].midi != compas[2].midi)
        #expect(PresentacionDeAnalisis.cercana(.mi, a: 0).midi == 40)
    }

    @Test func progresionesDeUnaEscala() {
        let hungara = PresentacionDeEstudioDeEscala.progresiones(de: Escala(.la, .menorHungara), notacion: notacion)
        let ultima = hungara.last
        #expect(ultima?.cifrados == "Lam – Sol♯m – Lam", Comment(rawValue: hungara.map(\.cifrados).description))
        #expect(ultima?.grados == "i–♯vii–i")
        #expect(ultima?.fuera.contains("Sol♯") == true, Comment(rawValue: ultima?.fuera ?? ""))
        #expect(ultima?.fuera.contains("Re♯") == true)
        let doble = PresentacionDeEstudioDeEscala.progresiones(de: Escala(.do, .dobleArmonica), notacion: notacion)
        let napolitana = doble.first { $0.cifrados == "Do – Re♭ – Do" }
        #expect(napolitana?.grados == "I–♭II–I", Comment(rawValue: doble.map(\.cifrados).description))
        #expect(napolitana?.fuera.contains("Re♭") == true)
        #expect(napolitana?.sonido.tonica == .do)
        // Con la mayor, todas son de ella.
        let mayor = PresentacionDeEstudioDeEscala.progresiones(de: Escala(.do), notacion: notacion)
        #expect(mayor.count == 5)
        #expect(mayor.first?.grados == "I–IV–V–I")
        #expect(mayor.allSatisfy { $0.fuera.isEmpty })
        let pentatonica = Escala(.do, .pentatonicaMayor)
        #expect(PresentacionDeEstudioDeEscala.progresiones(de: pentatonica, notacion: notacion).isEmpty)
    }
}
