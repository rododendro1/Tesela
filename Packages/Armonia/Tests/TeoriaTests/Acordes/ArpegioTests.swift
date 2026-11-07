import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Los arpegios: recorridos de un acorde, desde escalas y con nombre en cada idioma.
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

    @Test func lasTensiones() throws {
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
        #expect(try Arpegio.tensiones(leyendo: "9,13") == [9, 13])
        #expect(try Arpegio.tensiones(leyendo: "9 11") == [9, 11])
        #expect(
            throws: ErrorDeLecturaDeTeoria(
                texto: "9 10", posicion: 2, motivo: .nombreNoReconocido("10", opciones: ["9", "11", "13"]))
        ) { try Arpegio.tensiones(leyendo: "9 10") }
        #expect(throws: ErrorDeLectura(texto: "", posicion: nil, motivo: .textoVacio)) {
            try Arpegio.tensiones(leyendo: "")
        }
    }

    @Test func unRecorridoPorGrados() throws {
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
        #expect(try Arpegio.grados(leyendo: "1 5 3 8") == [1, 5, 3, 8])
        #expect(try Arpegio.grados(leyendo: "1-5-3-8") == [1, 5, 3, 8])
        #expect(try Arpegio.grados(leyendo: "1, 5, 3, 8") == [1, 5, 3, 8])
        func fuera(_ texto: String, _ posicion: Int, _ parte: String) -> ErrorDeLecturaDeTeoria {
            ErrorDeLecturaDeTeoria(
                texto: texto, posicion: posicion, motivo: .numeroFueraDeRango(parte, desde: 1, hasta: 22))
        }
        #expect(throws: fuera("1-x", 2, "x")) { try Arpegio.grados(leyendo: "1-x") }
        #expect(throws: fuera("23", 0, "23")) { try Arpegio.grados(leyendo: "23") }
        #expect(fuera("23", 0, "23").explicacion == "«23» no es un número de 1 a 22")
        #expect(throws: ErrorDeLectura(texto: ", ", posicion: nil, motivo: .textoVacio)) {
            try Arpegio.grados(leyendo: ", ")
        }
    }

    @Test func lasNotasDeAproximacion() throws {
        let enDo = Acorde("Do")
        #expect(midis(Arpegio(enDo, conOctava: false, aproximacion: .desdeAbajo)) == [59, 60, 63, 64, 66, 67])
        #expect(midis(Arpegio(enDo, conOctava: false, aproximacion: .desdeArriba)) == [61, 60, 65, 64, 68, 67])
        #expect(
            midis(Arpegio(enDo, conOctava: false, aproximacion: .encierro)) == [61, 59, 60, 65, 63, 64, 68, 66, 67])
        #expect(midis(Arpegio(enDo, grados: [1, 5], aproximacion: .desdeAbajo)) == [59, 60, 66, 67])
        // La ortografía: Re♯ lleva a Mi y Fa♯ a Sol.
        #expect(Arpegio(enDo, aproximacion: .desdeAbajo).alturas()[2].nota == Nota.re.sostenido)

        #expect(try Arpegio.Aproximacion(leyendo: "abajo") == .desdeAbajo)
        #expect(try Arpegio.Aproximacion(leyendo: "Above") == .desdeArriba)
        #expect(try Arpegio.Aproximacion(leyendo: "desde-abajo") == .desdeAbajo)
        #expect(try Arpegio.Aproximacion(leyendo: "desdeArriba") == .desdeArriba)
        #expect(try Arpegio.Aproximacion(leyendo: "enclosure") == .encierro)
        #expect(
            throws: ErrorDeLecturaDeTeoria(
                texto: "lejos", posicion: nil,
                motivo: .nombreNoReconocido("lejos", opciones: ["desdeAbajo", "desdeArriba", "encierro"]))
        ) { try Arpegio.Aproximacion(leyendo: "lejos") }
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            for aproximacion in Arpegio.Aproximacion.allCases {
                let nombre = aproximacion.nombre(en: notacion)
                #expect(!nombre.isEmpty, "\(aproximacion) en \(idioma)")
                #expect(try Arpegio.Aproximacion(leyendo: nombre) == aproximacion, "\(nombre) (\(idioma))")
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
        #expect(arpegio.nombre(en: .conPalabras(.aleman)).hasPrefix("Arpeggio: "))
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

    @Test func leerUnPatron() throws {
        #expect(try Arpegio.Patron(leyendo: "idaYVuelta") == .idaYVuelta)
        #expect(try Arpegio.Patron(leyendo: "ida_y_vuelta") == .idaYVuelta)
        #expect(try Arpegio.Patron(leyendo: "down-up") == .bajaYSube)
        #expect(try Arpegio.Patron(leyendo: "Aller-retour") == .idaYVuelta)
        #expect(try Arpegio.Patron(leyendo: "aufwarts") == .ascendente)
        #expect(try Arpegio.Patron(leyendo: "ВОСХОДЯЩИЙ") == .ascendente)
        let opciones = ["ascendente", "descendente", "idaYVuelta", "alberti", "quebrado", "bajaYSube"]
        let error = ErrorDeLecturaDeTeoria(
            texto: "zigzag", posicion: nil, motivo: .nombreNoReconocido("zigzag", opciones: opciones))
        #expect(throws: error) { try Arpegio.Patron(leyendo: "zigzag") }
        #expect(
            error.explicacion
                == "«zigzag» no es ninguno de estos: ascendente, descendente, idaYVuelta, alberti, quebrado, bajaYSube")
        for idioma in Idioma.allCases {
            for patron in Arpegio.Patron.allCases {
                let nombre = patron.nombre(en: Notacion.espanolCompacto.conTextos(en: idioma))
                #expect(try Arpegio.Patron(leyendo: nombre) == patron, "\(nombre) (\(idioma))")
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
}
