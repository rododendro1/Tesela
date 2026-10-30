import XCTest
@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria
@testable import ArmoniaPartitura

/// Los arpegios: recorridos de un acorde, desde escalas, con nombre en cada idioma y en pentagrama.
final class ArpegioTests: XCTestCase {
    private func midis(_ arpegio: Arpegio, octava: Int = 4) -> [Int] { arpegio.alturas(octava: octava).map(\.midi) }

    func testLosPatrones() {
        let do7 = Acorde("Do7")
        XCTAssertEqual(midis(Arpegio(do7)), [60, 64, 67, 70, 72])
        XCTAssertEqual(midis(Arpegio(do7, conOctava: false)), [60, 64, 67, 70])
        XCTAssertEqual(midis(Arpegio(Acorde("Do"), patron: .descendente)), [72, 67, 64, 60])
        XCTAssertEqual(midis(Arpegio(Acorde("Do"), patron: .idaYVuelta)), [60, 64, 67, 72, 67, 64, 60])
        XCTAssertEqual(midis(Arpegio(Acorde("Do"), patron: .alberti), octava: 3), [48, 55, 52, 55])
        XCTAssertEqual(midis(Arpegio(Acorde("Do"), patron: .alberti, octavas: 2), octava: 3),
                       [48, 55, 52, 55, 60, 67, 64, 67])
    }

    func testVariasOctavasYElBajoDelAcorde() {
        XCTAssertEqual(midis(Arpegio(Acorde("Do"), octavas: 2)), [60, 64, 67, 72, 76, 79, 84])
        XCTAssertEqual(Arpegio(Acorde("Do"), octavas: 0).octavas, 1)
        // Una inversión empieza por su bajo: Do/Mi → Mi, Sol, Do, y Mi arriba.
        XCTAssertEqual(midis(Arpegio(Acorde("Do/Mi"))), [64, 67, 72, 76])
        // La ortografía es la del acorde: Si♭ y no La♯.
        XCTAssertEqual(Arpegio(Acorde("Do7")).alturas(octava: 4)[3].nota, Nota.si.bemol)
    }

    func testDesdeUnaEscala() throws {
        let doMayor = Escala("Do mayor")
        XCTAssertEqual(try XCTUnwrap(doMayor.arpegio(grado: 5, cuatriada: true)).acorde, Acorde("Sol7"))
        XCTAssertEqual(try XCTUnwrap(doMayor.arpegio(grado: 2)).acorde, Acorde("Rem"))
        XCTAssertEqual(try XCTUnwrap(Escala("Re dórico").arpegio(cuatriada: true)).acorde, Acorde("Rem7"))
        XCTAssertEqual(midis(try XCTUnwrap(doMayor.arpegio(grados: [1, 3, 5, 6]))), [60, 64, 67, 69, 72])
        XCTAssertNil(doMayor.arpegio(grados: [1]))
        XCTAssertEqual(doMayor.arpegios().count, 7)
        XCTAssertTrue(doMayor.arpegios().allSatisfy { $0 != nil })
        XCTAssertEqual(try XCTUnwrap(doMayor.arpegio(grado: 5, patron: .descendente, octavas: 2)).octavas, 2)
        XCTAssertEqual(Acorde("Sol7").arpegio(patron: .idaYVuelta).patron, .idaYVuelta)
    }

    func testTransponer() {
        let arpegio = Arpegio(Acorde("Do7"), patron: .idaYVuelta, octavas: 2)
        let sol = arpegio.transponer(.quintaJusta)
        XCTAssertEqual(sol.acorde, Acorde("Sol7"))
        XCTAssertEqual(sol.patron, .idaYVuelta)
        XCTAssertEqual(midis(sol), midis(arpegio).map { $0 + 7 })
    }

    func testLeerYNombrar() throws {
        XCTAssertEqual(try Arpegio(leyendo: "arpegio Dom7").acorde, Acorde("Dom7"))
        XCTAssertEqual(try Arpegio(leyendo: "Dom7 arpeggio").acorde, Acorde("Dom7"))
        XCTAssertEqual(try Arpegio(leyendo: "Arpège de Do").acorde, Acorde("Do"))
        XCTAssertEqual(try Arpegio(leyendo: "Sol7").acorde, Acorde("Sol7"))
        XCTAssertThrowsError(try Arpegio(leyendo: "arpegio"))
        XCTAssertThrowsError(try Arpegio(leyendo: "arpegio de zzz"))

        let arpegio = Arpegio(Acorde("Do"))
        XCTAssertTrue(arpegio.nombre.hasPrefix("Arpegio de Do"), arpegio.nombre)
        XCTAssertTrue(arpegio.nombre(en: .inglesASCII).hasSuffix(" arpeggio"))
        XCTAssertTrue(arpegio.nombre(en: .aleman).hasPrefix("Arpeggio: "))
        for idioma in Idioma.traducidos {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            XCTAssertFalse(arpegio.nombre(en: notacion).contains("{}"), "\(idioma)")
            XCTAssertTrue(arpegio.nombre(en: notacion).count > Acorde("Do").nombre(en: notacion).count, "\(idioma)")
            for patron in Arpegio.Patron.allCases {
                XCTAssertFalse(patron.nombre(en: notacion).isEmpty, "\(patron) en \(idioma)")
            }
        }
        XCTAssertEqual(Set(Arpegio.Patron.allCases.map(\.nombre)).count, 4)
    }

    func testLaRelacionAcordeEscala() {
        let escalas = Acorde("Do7").escalasCompatibles()
        XCTAssertTrue(escalas.contains(Escala(.do, .mixolidio)))
        XCTAssertFalse(escalas.contains(Escala(.do, .mayor)))      // le falta el Si♭
        let tamanos = escalas.map { $0.tipo.intervalos.count }
        XCTAssertEqual(tamanos, tamanos.sorted())
        XCTAssertEqual(Acorde("Do").escalasCompatibles(entre: [.mayor, .menorNatural]), [Escala(.do, .mayor)])
        XCTAssertTrue(Acorde("Dom").escalasCompatibles().contains(Escala(.do, .dorico)))
    }

    func testElPentagramaDelArpegio() {
        let svg = Arpegio(Acorde("Do7")).svgPentagrama()
        XCTAssertTrue(svg.hasPrefix("<svg"))
        XCTAssertEqual(svg.components(separatedBy: "<g><title>").count - 1, 5)
        XCTAssertTrue(svg.contains("<title>Do4</title>"))
        XCTAssertTrue(svg.contains("<title>Do5</title>"))
        let alberti = Arpegio(Acorde("Do"), patron: .alberti, octavas: 2).svgPentagrama(octava: 3)
        XCTAssertEqual(alberti.components(separatedBy: "<g><title>").count - 1, 8)
        XCTAssertEqual(svg, Arpegio(Acorde("Do7")).svgPentagrama())
    }

    // MARK: Arpegios como voces

    func testUnArpegioComoVoz() {
        let voz = Voz(Arpegio(Acorde("Do7"), patron: .idaYVuelta), figura: .semicorchea)
        XCTAssertEqual(voz.eventos.flatMap(\.alturas).map(\.midi), [60, 64, 67, 70, 72, 70, 67, 64, 60])
        XCTAssertTrue(voz.eventos.allSatisfy { $0.duracion == .semicorchea })
        XCTAssertEqual(Voz(Arpegio(Acorde("Do")), octava: 3).eventos.first?.alturas.first?.midi, 48)
    }

    func testUnaProgresionArpegiada() {
        // Sin duración por acorde, cada uno suena su patrón entero; el Sol7 baja a Sol2, más cerca de Do3.
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")])
        XCTAssertEqual(voz.eventos.flatMap(\.alturas).map(\.midi), [48, 52, 55, 60, 43, 47, 50, 53, 55])
        XCTAssertTrue(voz.eventos.allSatisfy { $0.duracion == .corchea })

        // Con una blanca por acorde, cuatro corcheas cada uno.
        let alberti = Voz(arpegiando: [Acorde("Do"), Acorde("Lam"), Acorde("Fa"), Acorde("Sol7")],
                          patron: .alberti, porAcorde: .blanca)
        XCTAssertEqual(alberti.eventos.count, 16)
        XCTAssertEqual(alberti.eventos.prefix(12).flatMap(\.alturas).map(\.midi),
                       [48, 55, 52, 55, 45, 52, 48, 52, 53, 60, 57, 60])
        XCTAssertEqual(alberti.eventos.map(\.duracion).reduce(.cero, +), .redonda * 2)

        // Si no cabe un número entero de notas, la última se alarga; si cabe menos de una, suena una.
        let cinco = Voz(arpegiando: [Acorde("Do")], figura: .negra, porAcorde: Duracion(5, 8))
        XCTAssertEqual(cinco.eventos.map(\.duracion), [.negra, Duracion(3, 8)])
        let corta = Voz(arpegiando: [Acorde("Do")], figura: .blanca, porAcorde: .negra)
        XCTAssertEqual(corta.eventos.map(\.duracion), [.negra])
        // El patrón se repite hasta llenar el acorde.
        let larga = Voz(arpegiando: [Acorde("Do")], porAcorde: .redonda)
        XCTAssertEqual(larga.eventos.flatMap(\.alturas).map(\.midi), [48, 52, 55, 60, 48, 52, 55, 60])
        XCTAssertTrue(Voz(arpegiando: []).eventos.isEmpty)
    }

    func testUnaProgresionArpegiadaSeExporta() throws {
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")], patron: .descendente, porAcorde: .blanca)
        let xml = voz.musicXML(titulo: "Arpegios")
        XCTAssertEqual(xml.components(separatedBy: "<pitch>").count - 1, 8)
        XCTAssertTrue(voz.mei().contains("<mei"))
        let pieza = try PiezaImportada(midi: voz.midi())
        XCTAssertEqual(pieza.notas.map(\.altura.midi), voz.eventos.flatMap(\.alturas).map(\.midi))
    }
}
