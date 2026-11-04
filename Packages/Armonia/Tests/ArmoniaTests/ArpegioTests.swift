import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

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

    @Test func empezarPorOtraNota() {
        let enDo = Acorde("Do")
        #expect(midis(Arpegio(enDo, inicio: 1)) == [64, 67, 72, 76])
        #expect(midis(Arpegio(enDo, inicio: 2)) == [67, 72, 76, 79])
        // Se cuenta en círculo: -1 es la última nota y 3, otra vez el bajo.
        #expect(Arpegio(enDo, inicio: -1).inicio == 2)
        #expect(Arpegio(enDo, inicio: 3).inicio == 0)
        #expect(midis(Arpegio(enDo, patron: .descendente, conOctava: false, inicio: 1)) == [72, 67, 64])
        #expect(Arpegio.indice(de: .mi, en: enDo) == 1)
        #expect(Arpegio.indice(de: Nota.fa.bemol, en: enDo) == 1)
        #expect(Arpegio.indice(de: .fa, en: enDo) == nil)
        #expect(Arpegio.indice(delGrado: 3, en: enDo) == 1)
        #expect(Arpegio.indice(delGrado: 10, en: enDo) == 1)
        #expect(Arpegio.indice(delGrado: 5, en: enDo) == 2)
        #expect(Arpegio.indice(delGrado: 4, en: enDo) == nil)
        #expect(Arpegio.indice(delGrado: 0, en: enDo) == nil)
    }

    @Test func lasTensiones() {
        let do7 = Acorde("Do7")
        // La 9 por encima de la séptima, y la octava final, a dos octavas.
        #expect(midis(Arpegio(do7, tensiones: [9])) == [60, 64, 67, 70, 74, 84])
        // En Do7, la escala es el lidio dominante: la 11 es Fa♯.
        #expect(midis(Arpegio(do7, conOctava: false, tensiones: [13, 9, 11])) == [60, 64, 67, 70, 74, 78, 81])
        #expect(Arpegio(do7).nota(delGrado: 4) == Nota.fa.sostenido)
        #expect(Arpegio(Acorde("Dom")).nota(delGrado: 3) == Nota.mi.bemol)
        // Las que el acorde ya tiene no se repiten, y las que no son 9, 11 o 13 no cuentan.
        #expect(midis(Arpegio(Acorde("Do9"), tensiones: [9])) == midis(Arpegio(Acorde("Do9"))))
        #expect(Arpegio(do7, tensiones: [9, 9, 10]).tensiones == [9])
        let dosOctavas = [60, 64, 67, 70, 74, 84, 88, 91, 94, 98]
        #expect(midis(Arpegio(do7, octavas: 2, conOctava: false, tensiones: [9])) == dosOctavas)
        #expect(Arpegio.tensiones(leyendo: "9,13") == [9, 13])
        #expect(Arpegio.tensiones(leyendo: "9 11") == [9, 11])
        #expect(Arpegio.tensiones(leyendo: "10") == nil)
        #expect(Arpegio.tensiones(leyendo: "") == nil)
    }

    @Test func unRecorridoPorGrados() {
        let enDo = Acorde("Do")
        let propio = Arpegio(enDo, grados: [1, 5, 3, 8])
        #expect(midis(propio) == [60, 67, 64, 72])
        #expect(propio.grados == [1, 5, 3, 8])
        #expect(midis(Arpegio(enDo, grados: [1, 5, 3, 8], octavas: 2)) == [60, 67, 64, 72, 72, 79, 76, 84])
        // La 9 y la 10 están en la octava de arriba; cada vuelta sube dos.
        let conNovena = [60, 64, 67, 74, 76, 84, 88, 91, 98, 100]
        #expect(midis(Arpegio(enDo, grados: [1, 3, 5, 9, 10], octavas: 2)) == conNovena)
        #expect(Arpegio(Acorde("Dom"), grados: [1, 3]).alturas()[1].nota == Nota.mi.bemol)
        #expect(Arpegio(enDo, grados: [0, 1]).grados == [1])
        #expect(Arpegio.grados(leyendo: "1 5 3 8") == [1, 5, 3, 8])
        #expect(Arpegio.grados(leyendo: "1-5-3-8") == [1, 5, 3, 8])
        #expect(Arpegio.grados(leyendo: "1, 5, 3, 8") == [1, 5, 3, 8])
        #expect(Arpegio.grados(leyendo: "1-x") == nil)
        #expect(Arpegio.grados(leyendo: "23") == nil)
        #expect(Arpegio.grados(leyendo: "") == nil)
    }

    @Test func lasNotasDeAproximacion() {
        let enDo = Acorde("Do")
        #expect(midis(Arpegio(enDo, conOctava: false, aproximacion: .desdeAbajo)) == [59, 60, 63, 64, 66, 67])
        #expect(midis(Arpegio(enDo, conOctava: false, aproximacion: .desdeArriba)) == [61, 60, 65, 64, 68, 67])
        #expect(
            midis(Arpegio(enDo, conOctava: false, aproximacion: .encierro)) == [61, 59, 60, 65, 63, 64, 68, 66, 67])
        #expect(midis(Arpegio(enDo, grados: [1, 5], aproximacion: .desdeAbajo)) == [59, 60, 66, 67])
        // La ortografía: Re♯ lleva a Mi y Fa♯ a Sol.
        #expect(Arpegio(enDo, aproximacion: .desdeAbajo).alturas()[2].nota == Nota.re.sostenido)

        #expect(Arpegio.Aproximacion(leyendo: "abajo") == .desdeAbajo)
        #expect(Arpegio.Aproximacion(leyendo: "Above") == .desdeArriba)
        #expect(Arpegio.Aproximacion(leyendo: "desde-abajo") == .desdeAbajo)
        #expect(Arpegio.Aproximacion(leyendo: "desdeArriba") == .desdeArriba)
        #expect(Arpegio.Aproximacion(leyendo: "enclosure") == .encierro)
        #expect(Arpegio.Aproximacion(leyendo: "lejos") == nil)
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            for aproximacion in Arpegio.Aproximacion.allCases {
                let nombre = aproximacion.nombre(en: notacion)
                #expect(!nombre.isEmpty, "\(aproximacion) en \(idioma)")
                #expect(Arpegio.Aproximacion(leyendo: nombre) == aproximacion, "\(nombre) (\(idioma))")
            }
        }
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
        let completo = Arpegio(Acorde("Do7"), inicio: 1, tensiones: [9], aproximacion: .encierro)
        #expect(midis(completo.transponer(.quintaJusta)) == midis(completo).map { $0 + 7 })
        let propio = Arpegio(Acorde("Do"), grados: [1, 5, 3, 8]).transponer(.segundaMayor)
        #expect(propio.grados == [1, 5, 3, 8])
        #expect(propio.acorde == Acorde("Re"))
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
        #expect(arpegio.nombre(en: .alemanPalabras).hasPrefix("Arpeggio: "))
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
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
                let nombre = patron.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma))
                #expect(Arpegio.Patron(leyendo: nombre) == patron, "\(nombre) (\(idioma))")
            }
        }
    }

    @Test func laRelacionAcordeEscala() {
        let escalas = Acorde("Do7").escalasCompatibles()
        #expect(escalas.contains(Escala(.do, .mixolidio)))
        #expect(!escalas.contains(Escala(.do, .mayor))) // le falta el Si♭
        // De las que tienen menos notas a evitar a las que más.
        let aEvitar = escalas.map { $0.notasAEvitar(sobre: Acorde("Do7")).count }
        #expect(aEvitar == aEvitar.sorted())
        #expect(escalas.first == Escala(.do, .lidioDominante))
        #expect(escalas.allSatisfy { TipoDeEscala.deJazz.contains($0.tipo) })
        // Con la ♯11 en el cifrado, el lidio dominante va primero y el mixolidio ya no cabe.
        let conOncena = Acorde("Do7(#11)").escalasCompatibles()
        #expect(conOncena.first == Escala(.do, .lidioDominante))
        #expect(!conOncena.contains(Escala(.do, .mixolidio)))
        // En Do7M, el lidio (sin notas a evitar) antes que el jónico (con el fa).
        let mayor = Acorde("Do7M").escalasCompatibles()
        #expect(mayor.firstIndex(of: Escala(.do, .lidio))! < mayor.firstIndex(of: Escala(.do, .mayor))!)
        #expect(Acorde("Do").escalasCompatibles(entre: [.mayor, .menorNatural]) == [Escala(.do, .mayor)])
        #expect(Acorde("Dom").escalasCompatibles().contains(Escala(.do, .dorico)))
    }

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
        let conRitmo = try Voz(
            arpegiando: [Acorde("Do")], duraciones: [.blanca], tensiones: [9], aproximacion: .desdeAbajo,
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
