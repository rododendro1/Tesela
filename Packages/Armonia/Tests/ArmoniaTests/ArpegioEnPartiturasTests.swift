import Foundation
import Testing

@testable import Armonia
@testable import Diagramas
@testable import Elementos
@testable import Partituras
@testable import Teoria
@testable import Trastes

/// Los arpegios en pentagrama y como voces de una partitura (los recorridos, en TeoriaTests/Acordes/ArpegioTests).
@Suite struct ArpegioEnPartiturasTests {
    @Test func elPentagramaDelArpegio() {
        let svg = Arpegio(Acorde("Do7")).svgPentagrama()
        #expect(svg.hasPrefix("<svg"))
        #expect((svg.components(separatedBy: "<g><title>").count - 1) == 5)
        #expect(svg.contains("<title>Do₄</title>"))
        #expect(svg.contains("<title>Do₅</title>"))
        let alberti = Arpegio(Acorde("Do"), patron: .alberti, octavas: 2).svgPentagrama(octava: 3)
        #expect((alberti.components(separatedBy: "<g><title>").count - 1) == 8)
        #expect(svg == Arpegio(Acorde("Do7")).svgPentagrama())
    }

    // MARK: Arpegios como voces

    @Test func unArpegioComoVoz() {
        let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        #expect(voz.eventos.flatMap(\.alturas).map(\.midi) == [60, 64, 67, 70, 72, 70, 67, 64, 60])
        #expect(voz.eventos.allSatisfy { $0.duracion == .semicorchea })
        #expect(Voz(Arpegio(Acorde("Do")), octava: 3).eventos.first?.alturas.first?.midi == 48)
    }

    @Test func unaProgresionArpegiada() {
        // Sin duración por acorde, cada uno suena su patrón entero; el Sol7 baja a Sol2, más cerca de Do3.
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")])
        #expect(voz.eventos.flatMap(\.alturas).map(\.midi) == [48, 52, 55, 60, 43, 47, 50, 53, 55])
        #expect(voz.eventos.allSatisfy { $0.duracion == .corchea })

        // Con una blanca por acorde, cuatro corcheas cada uno.
        let alberti = Voz(
            arpegiando: [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Sol7")],
            patron: .alberti, porAcorde: .blanca)
        #expect(alberti.eventos.count == 16)
        #expect(
            alberti.eventos.prefix(12).flatMap(\.alturas).map(\.midi) == [
                48, 55, 52, 55, 45, 52, 48, 52, 53, 60, 57, 60,
            ])
        #expect(alberti.eventos.map(\.duracion).reduce(.cero, +) == (.redonda * 2))

        // Si no cabe un número entero de notas, la última se alarga; si cabe menos de una, suena una.
        let cinco = Voz(arpegiando: [Acorde("Do")], figura: .negra, porAcorde: Duracion(5, 8))
        #expect(cinco.eventos.map(\.duracion) == [.negra, Duracion(3, 8)])
        let corta = Voz(arpegiando: [Acorde("Do")], figura: .blanca, porAcorde: .negra)
        #expect(corta.eventos.map(\.duracion) == [.negra])
        // El patrón se repite hasta llenar el acorde.
        let larga = Voz(arpegiando: [Acorde("Do")], porAcorde: .redonda)
        #expect(larga.eventos.flatMap(\.alturas).map(\.midi) == [48, 52, 55, 60, 48, 52, 55, 60])
        #expect(Voz(arpegiando: []).eventos.isEmpty)
    }

    @Test func unaProgresionEnlazada() throws {
        // Tras Do3 Mi3 Sol3 Do4, el Sol7 empieza por Si3, a un semitono, en vez de bajar a Sol2.
        let sol7 = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")], enlazados: true)
        #expect(sol7.eventos.flatMap(\.alturas).map(\.midi) == [48, 52, 55, 60, 59, 62, 65, 67, 71])
        // Y el Fa, por el mismo Do.
        let fa = Voz(arpegiando: [Acorde("Do"), Acorde("Fa")], enlazados: true)
        #expect(fa.eventos.flatMap(\.alturas).map(\.midi) == [48, 52, 55, 60, 60, 65, 69, 72])
        // Con una blanca por acorde se enlaza con la última nota que suena (la cuarta corchea).
        let llenos = Voz(arpegiando: [Acorde("Do"), Acorde("Fa")], porAcorde: .blanca, enlazados: true)
        #expect(llenos.eventos[4].alturas.first?.midi == 60)
        // Las tensiones y las aproximaciones valen para todos los acordes, también con su ritmo.
        let conRitmo = Voz(
            arpegiando: RitmoArmonico([AcordeConDuracion("Do", .blanca)]), tensiones: [9], aproximacion: .desdeAbajo,
            enlazados: true)
        #expect(conRitmo.eventos.flatMap(\.alturas).map(\.midi) == [47, 48, 51, 52])
    }

    @Test func unaProgresionArpegiadaSeExporta() throws {
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")], patron: .descendente, porAcorde: .blanca)
        let xml = voz.partitura(encabezado: Encabezado(titulo: "Arpegios")).musicXML()
        #expect((xml.components(separatedBy: "<pitch>").count - 1) == 8)
        #expect(voz.partitura().mei().contains("<mei"))
        let pieza = try PiezaImportada(midi: voz.partitura().midi())
        #expect(pieza.notas.map(\.altura.midi) == voz.eventos.flatMap(\.alturas).map(\.midi))
    }
}
