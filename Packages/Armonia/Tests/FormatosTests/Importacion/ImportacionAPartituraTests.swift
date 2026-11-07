import Foundation
import Testing

@testable import Elementos
@testable import Formatos
@testable import Partituras
@testable import Polifonia
@testable import Teoria

/// De la pieza importada a una partitura, que se dibuja y se exporta otra vez.
@Suite struct ImportacionAPartituraTests {
    @Test func unaVozVuelveComoEra() throws {
        let voz = try Voz(leyendo: "Do4:4 -:4 Mi4+Sol4:2 Fa4:8 Mi4:8 Re4:4 Do4:2")
        let pieza = try PiezaImportada(musicXML: Data(voz.partitura().musicXML().utf8))
        let partitura = pieza.partitura()
        #expect(partitura.pentagramas.count == 1 && partitura.pentagramas[0].voces.count == 1)
        let leida = partitura.pentagramas[0].voces[0].voz
        #expect(leida.eventos.map(\.notas) == voz.eventos.map(\.notas))
        #expect(leida.eventos.map(\.duracion) == voz.eventos.map(\.duracion))
        #expect(partitura.svg().hasPrefix("<svg") && partitura.musicXML().contains("<rest"))
    }

    @Test func cadaParteEnSuPentagramaYLoQueSeSolapaEnOtraVoz() throws {
        let coral = try Coral(leyendo: "Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 | Do3 Mi4 Sol4 Do5")
        let pieza = try PiezaImportada(midi: coral.partitura().midi())
        let partitura = pieza.partitura()
        #expect(partitura.pentagramas.count == Set(pieza.notas.map(\.parte)).count)
        #expect(partitura.lineas.map(\.linea).allSatisfy { $0.voz.eventos.allSatisfy { !$0.esSilencio } })
        // Una nota larga bajo dos cortas: dos voces, la segunda con su silencio delante si empieza después.
        let notas = [
            NotaDeLaPieza(altura: "Do4", inicio: .cero, duracion: .blanca),
            NotaDeLaPieza(altura: "Mi4", inicio: .cero, duracion: .negra),
            NotaDeLaPieza(altura: "Fa4", inicio: .negra, duracion: .negra),
            NotaDeLaPieza(altura: "Sol4", inicio: .negra, duracion: .negra),
        ]
        let dos = PiezaImportada(titulo: "Dos voces", notas: notas).partitura()
        let voces = dos.pentagramas[0].voces.map(\.voz)
        #expect(voces.count == 2)
        #expect(voces[0].eventos.map(\.alturas) == [["Do4"]])
        #expect(voces[1].eventos.map(\.alturas) == [["Mi4"], ["Fa4", "Sol4"]])
        #expect(dos.encabezado.titulo == "Dos voces")
        let tarde = PiezaImportada(notas: [NotaDeLaPieza(altura: "Do4", inicio: .negra, duracion: .negra)]).partitura()
        #expect(tarde.pentagramas[0].voces[0].voz.eventos.map(\.esSilencio) == [true, false])
    }

    @Test func losMicrotonosVuelvenConSuSistema() throws {
        let sur = Escala(.re, .sur).partitura(ritmo: .uniforme(.negra))
        let partitura = try PiezaImportada(musicXML: Data(sur.musicXML().utf8)).partitura()
        let mi = partitura.pentagramas[0].voces[0].voz.eventos[1].notas
        #expect(mi == [Evento.NotaDelEvento("Mi♭4", desvio: 50, sistema: .persa, ajuste: 1)])
        #expect(partitura.musicXML().contains("<accidental>koron</accidental>"))
    }
}
