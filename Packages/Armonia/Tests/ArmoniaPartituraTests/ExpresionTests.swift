import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La dinámica y las articulaciones de los eventos.
@Suite struct ExpresionTests {
    @Test func seLeenYSeEscribenEntreLlaves() throws {
        let evento = try Evento(leyendo: "Sol4:8{f,staccato,acento}")
        #expect(evento.alturas == [Altura("Sol4")])
        #expect(evento.duracion == .corchea)
        #expect(evento.dinamica == .f)
        #expect(evento.articulaciones == [.staccato, .acento])
        #expect(evento.tieneExpresion)
        #expect(evento.description == "Sol4:8{f,staccato,acento}")
        // La ligadura va antes de las llaves; las articulaciones salen en su orden y sin repetir.
        let ligada = try Evento(leyendo: "Do4+Mi4:2~{acento,tenuto,acento}")
        #expect(ligada.ligada)
        #expect(ligada.articulaciones == [.tenuto, .acento])
        #expect(ligada.description == "Do4+Mi4:2~{tenuto,acento}")
        // En un silencio, el calderón; con tilde, en mayúsculas o en inglés.
        #expect(try Evento(leyendo: "-:4{Calderón}").articulaciones == [.calderon])
        #expect(try Evento(leyendo: "La4:4{fermata,accent}").articulaciones == [.acento, .calderon])
        #expect(try Evento(leyendo: "La4:4{MF}").dinamica == .mf)
        // Sin llaves, como siempre.
        let sencillo = try Evento(leyendo: "Do4:4")
        #expect(sencillo.dinamica == nil && sencillo.articulaciones.isEmpty && !sencillo.tieneExpresion)
        #expect(sencillo.description == "Do4:4")
    }

    @Test func loQueNoSeConoceEsUnError() {
        #expect(throws: (any Error).self) { try Evento(leyendo: "Do4:4{forte}") }
        // Dos dinámicas en el mismo evento.
        #expect(throws: (any Error).self) { try Evento(leyendo: "Do4:4{p,f}") }
    }

    @Test func seConservanAlTransformarLaVoz() throws {
        let voz = try Voz(leyendo: "Do4:4{p} Re4:2{acento} Mi4:4{calderon}", compas: "2/4")
        #expect(try JSONDecoder().decode(Voz.self, from: JSONEncoder().encode(voz)) == voz)
        let transportada = voz.transponer(.segundaMayor)
        #expect(transportada.eventos.map(\.dinamica) == [.p, nil, nil])
        #expect(transportada.eventos.map(\.articulaciones) == [[], [.acento], [.calderon]])
        #expect(voz.aumentar(2).eventos[1].articulaciones == [.acento])
        // Una nota partida por la barra lleva sus marcas solo en la primera parte.
        let partida = try Voz(leyendo: "Do4:4 Re4:2{f} Mi4:4", compas: "2/4").compases
        #expect(partida[0][1].dinamica == .f && partida[0][1].ligada)
        #expect(partida[1][0].dinamica == nil)
        let escrita = try Voz(leyendo: "Do4:4 Re4:2{acento} Do4:4").grafia
        #expect(escrita[0].map(\.articulaciones) == [[], [.acento], [], []])
    }

    @Test func conCambiaSoloLaExpresion() {
        let ligada: Evento = "Do4:4~"
        let evento = ligada.con(dinamica: .pp, articulaciones: [.tenuto])
        #expect(evento.description == "Do4:4~{pp,tenuto}")
        #expect(evento.con(dinamica: nil, articulaciones: []).description == "Do4:4~")
    }

    @Test func dinamicas() {
        #expect(Dinamica.allCases.filter(\.esDeUnaNota) == [.sfz, .fp])
        let velocidades = [Dinamica.ppp, .pp, .p, .mp, .mf, .f, .ff, .fff].map(\.velocidadMIDI)
        #expect(velocidades == velocidades.sorted() && Set(velocidades).count == 8)
        #expect(velocidades.allSatisfy { (1...127).contains($0) })
    }
}
