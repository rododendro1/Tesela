import Foundation
import Testing

@testable import Elementos
@testable import Teoria
@testable import Trastes

/// El mástil de cada instrumento como es: los trastes diatónicos del dulcémele, la cuerda corta del banjo y los
/// órdenes en octavas.
@Suite struct MastilDelInstrumentoTests {
    /// El dulcémele solo tiene los trastes de su escala, con el «6½»: el 1, el 3, el 6 y el 8 no existen.
    @Test func trastesDelDulcemele() throws {
        let mastil = Mastil(.dulcemele, numeroDeTrastes: 15)
        #expect(mastil.trastes(deCuerda: 0) == [0, 2, 4, 5, 7, 9, 10, 11, 12, 14])
        #expect(!mastil.contiene(PosicionEnElMastil(cuerda: 0, traste: 1)))
        #expect(mastil.alturaSiExiste(en: PosicionEnElMastil(cuerda: 0, traste: 3)) == nil)
        #expect(mastil.posiciones(de: Altura(.re, octava: 3)) == [PosicionEnElMastil(cuerda: 0, traste: 0)])
        // El Mi♭3 no se puede tocar en ninguna cuerda.
        #expect(mastil.posiciones(de: Altura(Nota(.mi, .bemol), octava: 3)).isEmpty)
        #expect(mastil.posiciones(de: .fa).allSatisfy { mastil.contiene($0) })
        // Las digitaciones solo usan trastes que tiene.
        let formas = mastil.digitaciones(de: Acorde("Re"), cuerdasMinimas: 3)
        #expect(!formas.isEmpty)
        for forma in formas {
            for (cuerda, traste) in zip(forma.trastes.indices, forma.trastes) {
                if let traste { #expect(mastil.tieneTraste(traste, enCuerda: cuerda), "\(forma.tablatura)") }
            }
        }
        // Y una tablatura con un traste que no tiene no se lee.
        #expect(throws: ErrorDeLecturaDeTeoria.self) { try Digitacion(leyendo: "013", en: mastil) }
        #expect(Digitacion(comprobando: [0, 1, 2], en: mastil) == nil)
        #expect(try Digitacion(leyendo: "024", en: mastil).trastes == [0, 2, 4])
        // Con capo en el 2, el traste 2 desde el capo es el 4 del mástil.
        let conCapo = Mastil(Encordado.dulcemele.conCapo(2), numeroDeTrastes: 13)
        #expect(conCapo.tieneTraste(2, enCuerda: 0) && !conCapo.tieneTraste(1, enCuerda: 0))
    }

    /// La quinta del banjo nace en el 5.º traste: tiene cinco menos que las demás.
    @Test func cuerdaCortaDelBanjo() {
        let mastil = Mastil(.banjo, numeroDeTrastes: 22)
        #expect(mastil.trastes(deCuerda: 0).last == 17)
        #expect(mastil.trastes(deCuerda: 1).last == 22)
        #expect(!mastil.contiene(PosicionEnElMastil(cuerda: 0, traste: 18)))
    }

    /// Los órdenes dobles suenan con sus dos cuerdas: al unísono en la mandolina y en octavas en la guitarra de doce
    /// cuerdas, el buzuki, el charango y la guitarra portuguesa.
    @Test func ordenesEnOctavas() throws {
        let doce = Encordado.guitarraDeDoceCuerdas
        #expect(doce.cuerdasReales == 12 && doce.tieneOrdenesEnOctavas)
        #expect(doce.alturasDelOrden(0) == [Altura(.mi, octava: 2), Altura(.mi, octava: 3)])
        #expect(doce.alturasDelOrden(5) == [Altura(.mi, octava: 4), Altura(.mi, octava: 4)])
        #expect(Encordado.charango.alturasDelOrden(2) == [Altura(.mi, octava: 5), Altura(.mi, octava: 4)])
        #expect(Encordado.buzuki.alturasDelOrden(0) == [Altura(.do, octava: 3), Altura(.do, octava: 4)])
        #expect(Encordado.guitarraPortuguesa.alturasDelOrden(3).count == 2)
        #expect(Encordado.mandolina.alturasDelOrden(0) == [Altura(.sol, octava: 3), Altura(.sol, octava: 3)])
        #expect(!Encordado.mandolina.tieneOrdenesEnOctavas)
        #expect(Encordado.guitarra.alturasDelOrden(0) == [Altura(.mi, octava: 2)])
        #expect(Encordado.guitarra.alturasDelOrden(9).isEmpty)
        let mastil = Mastil(doce, numeroDeTrastes: 12)
        let suenan = try #require(mastil.alturasQueSuenan(en: PosicionEnElMastil(cuerda: 0, traste: 3)))
        #expect(suenan.map(\.midi) == [43, 55])
        #expect(mastil.alturasQueSuenan(en: PosicionEnElMastil(cuerda: 0, traste: 13)) == nil)
        #expect(try Encordado(leyendo: "12 string guitar") == doce)
        #expect(doce.nombre(en: .conPalabras(.ingles)) == "twelve-string guitar")
    }

    /// En la guitarra, nada cambia: todos los trastes en todas las cuerdas.
    @Test func laGuitarraTieneTodos() {
        let mastil = Mastil(.guitarra, numeroDeTrastes: 12)
        for cuerda in 0..<6 { #expect(mastil.trastes(deCuerda: cuerda) == Array(0...12)) }
        #expect(
            mastil.arpegiosDeUnaNotaPorCuerda(de: Acorde("Lam")).first?.posiciones.map(\.traste) == [0, 0, 2, 2, 1, 0])
    }

    /// En el dulcémele, los arpegios y las escalas solo pisan sus trastes.
    @Test func arpegiosYEscalasDelDulcemele() {
        let mastil = Mastil(.dulcemele, numeroDeTrastes: 15)
        let arpegios = mastil.arpegios(de: Acorde("Re")) + mastil.arpegiosDeUnaNotaPorCuerda(de: Acorde("Re"))
        #expect(!arpegios.isEmpty)
        #expect(arpegios.allSatisfy { $0.posiciones.allSatisfy(mastil.contiene) })
        let escalas = mastil.posicionesPorCuerda(de: Escala(.re, .mixolidio))
        #expect(escalas.allSatisfy { $0.posiciones.allSatisfy(mastil.contiene) })
        let disposiciones = mastil.disposiciones(de: Acorde("Re"), .cerrada, cuerdas: [0, 1, 2])
        for forma in disposiciones {
            for (cuerda, traste) in zip(forma.trastes.indices, forma.trastes) {
                if let traste { #expect(mastil.tieneTraste(traste, enCuerda: cuerda), "\(forma.tablatura)") }
            }
        }
    }
}
