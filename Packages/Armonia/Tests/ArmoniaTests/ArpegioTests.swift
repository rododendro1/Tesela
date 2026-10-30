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
}
