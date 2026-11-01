import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// Los arpegios: recorridos de un acorde, desde escalas, con nombre en cada idioma y en pentagrama.
@Suite struct ArpegioTests {
    private func midis(_ arpegio: Arpegio, octava: Int = 4) -> [Int] { arpegio.alturas(octava: octava).map(\.midi) }

    @Test func losPatrones() {
        let do7 = Acorde("Do7")
        #expect(midis(Arpegio(do7)) == [60, 64, 67, 70, 72])
        #expect(midis(Arpegio(do7, conOctava: false)) == [60, 64, 67, 70])
        #expect(midis(Arpegio(Acorde("Do"), patron: .descendente)) == [72, 67, 64, 60])
        #expect(midis(Arpegio(Acorde("Do"), patron: .idaYVuelta)) == [60, 64, 67, 72, 67, 64, 60])
        #expect(midis(Arpegio(Acorde("Do"), patron: .alberti), octava: 3) == [48, 55, 52, 55])
        #expect(
            midis(Arpegio(Acorde("Do"), patron: .alberti, octavas: 2), octava: 3) == [48, 55, 52, 55, 60, 67, 64, 67])
        // Quebrado: Do Mi Sol Do → Do Sol, Mi Do.
        #expect(midis(Arpegio(Acorde("Do"), patron: .quebrado)) == [60, 67, 64, 72])
        #expect(midis(Arpegio(Acorde("Do"), patron: .bajaYSube)) == [72, 67, 64, 60, 64, 67, 72])
        #expect(midis(Arpegio(Acorde("Do"), patron: .bajaYSube, conOctava: false)) == [67, 64, 60, 64, 67])
    }

    @Test func variasOctavasYElBajoDelAcorde() {
        #expect(midis(Arpegio(Acorde("Do"), octavas: 2)) == [60, 64, 67, 72, 76, 79, 84])
        #expect(Arpegio(Acorde("Do"), octavas: 0).octavas == 1)
        // Una inversión empieza por su bajo: Do/Mi → Mi, Sol, Do, y Mi arriba.
        #expect(midis(Arpegio(Acorde("Do/Mi"))) == [64, 67, 72, 76])
        // La ortografía es la del acorde: Si♭ y no La♯.
        #expect(Arpegio(Acorde("Do7")).alturas(octava: 4)[3].nota == Nota.si.bemol)
    }

    @Test func desdeUnaEscala() throws {
        let doMayor = Escala("Do mayor")
        #expect(try (#require(doMayor.arpegio(grado: 5, cuatriada: true)).acorde) == Acorde("Sol7"))
        #expect(try (#require(doMayor.arpegio(grado: 2)).acorde) == Acorde("Rem"))
        #expect(try (#require(Escala("Re dórico").arpegio(cuatriada: true)).acorde) == Acorde("Rem7"))
        #expect(try midis(#require(doMayor.arpegio(grados: [1, 3, 5, 6]))) == [60, 64, 67, 69, 72])
        #expect(doMayor.arpegio(grados: [1]) == nil)
        #expect(doMayor.arpegios().count == 7)
        #expect(doMayor.arpegios().allSatisfy { $0 != nil })
        #expect(try (#require(doMayor.arpegio(grado: 5, patron: .descendente, octavas: 2)).octavas) == 2)
        #expect(Acorde("Sol7").arpegio(patron: .idaYVuelta).patron == .idaYVuelta)
    }

    @Test func transponer() {
        let arpegio = Arpegio(Acorde("Do7"), patron: .idaYVuelta, octavas: 2)
        let sol = arpegio.transponer(.quintaJusta)
        #expect(sol.acorde == Acorde("Sol7"))
        #expect(sol.patron == .idaYVuelta)
        #expect(midis(sol) == midis(arpegio).map { $0 + 7 })
    }

    @Test func leerYNombrar() throws {
        #expect(try (Arpegio(leyendo: "arpegio Dom7").acorde) == Acorde("Dom7"))
        #expect(try (Arpegio(leyendo: "Dom7 arpeggio").acorde) == Acorde("Dom7"))
        #expect(try (Arpegio(leyendo: "Arpège de Do").acorde) == Acorde("Do"))
        #expect(try (Arpegio(leyendo: "Sol7").acorde) == Acorde("Sol7"))
        #expect(throws: (any Error).self) { try Arpegio(leyendo: "arpegio") }
        #expect(throws: (any Error).self) { try Arpegio(leyendo: "arpegio de zzz") }

        let arpegio = Arpegio(Acorde("Do"))
        #expect(arpegio.nombre.hasPrefix("Arpegio de Do"), Comment(rawValue: arpegio.nombre))
        #expect(arpegio.nombre(en: .inglesASCII).hasSuffix(" arpeggio"))
        #expect(arpegio.nombre(en: .aleman).hasPrefix("Arpeggio: "))
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            #expect(!(arpegio.nombre(en: notacion).contains("{}")), "\(idioma)")
            #expect(arpegio.nombre(en: notacion).count > Acorde("Do").nombre(en: notacion).count, "\(idioma)")
            for patron in Arpegio.Patron.allCases {
                #expect(!(patron.nombre(en: notacion).isEmpty), "\(patron) en \(idioma)")
            }
        }
        #expect(Set(Arpegio.Patron.allCases.map(\.nombre)).count == Arpegio.Patron.allCases.count)
    }

    @Test func leerUnPatron() {
        #expect(Arpegio.Patron(leyendo: "idaYVuelta") == .idaYVuelta)
        #expect(Arpegio.Patron(leyendo: "ida_y_vuelta") == .idaYVuelta)
        #expect(Arpegio.Patron(leyendo: "down-up") == .bajaYSube)
        #expect(Arpegio.Patron(leyendo: "Aller-retour") == .idaYVuelta)
        #expect(Arpegio.Patron(leyendo: "aufwarts") == .ascendente)
        #expect(Arpegio.Patron(leyendo: "ВОСХОДЯЩИЙ") == .ascendente)
        #expect(Arpegio.Patron(leyendo: "zigzag") == nil)
        for idioma in Idioma.allCases {
            for patron in Arpegio.Patron.allCases {
                let nombre = patron.nombre(en: Notacion.espanolUnicode.conTextos(en: idioma))
                #expect(Arpegio.Patron(leyendo: nombre) == patron, "\(nombre) (\(idioma))")
            }
        }
    }

    @Test func laRelacionAcordeEscala() {
        let escalas = Acorde("Do7").escalasCompatibles()
        #expect(escalas.contains(Escala(.do, .mixolidio)))
        #expect(!escalas.contains(Escala(.do, .mayor))) // le falta el Si♭
        let tamanos = escalas.map { $0.tipo.intervalos.count }
        #expect(tamanos == tamanos.sorted())
        #expect(Acorde("Do").escalasCompatibles(entre: [.mayor, .menorNatural]) == [Escala(.do, .mayor)])
        #expect(Acorde("Dom").escalasCompatibles().contains(Escala(.do, .dorico)))
    }

    @Test func elPentagramaDelArpegio() {
        let svg = Arpegio(Acorde("Do7")).svgPentagrama()
        #expect(svg.hasPrefix("<svg"))
        #expect((svg.components(separatedBy: "<g><title>").count - 1) == 5)
        #expect(svg.contains("<title>Do4</title>"))
        #expect(svg.contains("<title>Do5</title>"))
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

    @Test func unaProgresionArpegiadaSeExporta() throws {
        let voz = Voz(arpegiando: [Acorde("Do"), Acorde("Sol7")], patron: .descendente, porAcorde: .blanca)
        let xml = voz.musicXML(titulo: "Arpegios")
        #expect((xml.components(separatedBy: "<pitch>").count - 1) == 8)
        #expect(voz.mei().contains("<mei"))
        let pieza = try PiezaImportada(midi: voz.midi())
        #expect(pieza.notas.map(\.altura.midi) == voz.eventos.flatMap(\.alturas).map(\.midi))
    }
}
