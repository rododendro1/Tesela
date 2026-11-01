import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las rearmonizaciones: sustituto tritonal, dominantes secundarias, préstamo modal y sustitutos diatónicos.
@Suite struct RearmonizacionTests {
    private let progresion = [Acorde("Do"), Acorde("Lam"), Acorde("Rem7"), Acorde("Sol7"), Acorde("Do")]

    private func propuestas(_ recurso: Rearmonizacion.Recurso, en posicion: Int) -> [[Acorde]] {
        Tonalidad(.do).rearmonizaciones(de: progresion)
            .filter { $0.recurso == recurso && $0.posicion == posicion }.map(\.acordes)
    }

    @Test func elSustitutoTritonal() {
        #expect(propuestas(.sustitutoTritonal, en: 3) == [[Acorde(Nota.re.bemol, .dominanteSeptima)]])
        // Solo las séptimas de dominante.
        #expect(propuestas(.sustitutoTritonal, en: 2) == [])
        // Con la ortografía más sencilla: el de Re♭7 es Sol7, no La𝄫7.
        #expect(Tonalidad.aUnTritono(de: Nota.re.bemol) == .sol)
        #expect(Tonalidad.aUnTritono(de: .sol) == Nota.re.bemol)
    }

    @Test func lasDominantesSecundarias() {
        #expect(propuestas(.dominanteSecundaria, en: 1) == [[Acorde("Mi7"), Acorde("Lam")]])
        #expect(propuestas(.dominanteSecundaria, en: 2) == [[Acorde("La7"), Acorde("Rem7")]])
        // El Do final ya viene de Sol7: no se repite su dominante.
        #expect(propuestas(.dominanteSecundaria, en: 4) == [])
        // Un acorde disminuido no se prepara así.
        let disminuido = Tonalidad(.do).rearmonizaciones(de: Acorde(.si, .disminuido))
        #expect(disminuido.allSatisfy { $0.recurso != .dominanteSecundaria })
    }

    @Test func elPrestamoModal() {
        #expect(propuestas(.prestamoModal, en: 0) == [[Acorde("Dom")]])
        #expect(propuestas(.prestamoModal, en: 1) == [[Acorde(Nota.la.bemol, .mayor)]])
        #expect(propuestas(.prestamoModal, en: 2) == [[Acorde(.re, .semidisminuido)]])
        // En lugar de la dominante, el ♭VII.
        #expect(propuestas(.prestamoModal, en: 3) == [[Acorde(Nota.si.bemol, .dominanteSeptima)]])
        // En menor se toma del mayor: la tercera de picardía.
        let enLaMenor = Tonalidad(.la, .menor).rearmonizaciones(de: [Acorde("Lam"), Acorde("Rem"), Acorde("Mi7")])
        #expect(enLaMenor.contains { $0.recurso == .prestamoModal && $0.acordes == [Acorde("La")] })
        #expect(enLaMenor.contains { $0.recurso == .prestamoModal && $0.acordes == [Acorde("Re")] })
        #expect(!(enLaMenor.contains { $0.recurso == .prestamoModal && $0.posicion == 2 }))
    }

    @Test func losSustitutosDiatonicos() {
        #expect(propuestas(.sustitutoDiatonico, en: 0) == [[Acorde("Lam")]])
        #expect(propuestas(.sustitutoDiatonico, en: 2) == [[Acorde(.fa, .mayorSeptimaMayor)]])
        #expect(propuestas(.sustitutoDiatonico, en: 3) == [[Acorde(.si, .semidisminuido)]])
        // Un acorde ajeno a la tonalidad no tiene ni préstamo ni sustituto diatónico.
        let ajeno = Tonalidad(.do).rearmonizaciones(de: Acorde("Fa#"))
        #expect(ajeno.allSatisfy { $0.recurso == .dominanteSecundaria })
    }

    @Test func aplicarYDescribir() throws {
        let tritonal = try #require(
            Tonalidad(.do).rearmonizaciones(de: progresion).first { $0.recurso == .sustitutoTritonal })
        #expect(tritonal.aplicar(a: progresion).map(\.cifrado) == ["Do", "Lam", "Rem7", "Re♭7", "Do"])
        #expect(tritonal.descripcion(en: .espanolCompacto) == "Sol7 → Re♭7 (sustituto tritonal)")
        #expect(tritonal.descripcion(en: .inglesASCII) == "G7 → Db7 (tritone substitution)")
        let secundaria = try #require(
            Tonalidad(.do).rearmonizaciones(de: progresion).first { $0.recurso == .dominanteSecundaria })
        #expect(secundaria.aplicar(a: progresion).count == (progresion.count + 1))
        #expect(tritonal.aplicar(a: []) == [])
        for idioma in Idioma.allCases {
            let notacion = Notacion.espanolCompacto.conTextos(en: idioma)
            let nombres = Rearmonizacion.Recurso.allCases.map { $0.nombre(en: notacion) }
            #expect(Set(nombres).count == nombres.count, "\(idioma)")
        }
    }

    @Test func transportarElCamino() {
        #expect(Nota.do.intervaloMasCorto(hasta: .re) == .segundaMayor)
        #expect(Nota.do.intervaloMasCorto(hasta: .la).semitonosConSigno == -3)
        #expect(Nota.do.intervaloMasCorto(hasta: Nota.fa.sostenido).semitonosConSigno == 6)
        #expect((Nota.do + Nota.do.intervaloMasCorto(hasta: .la)) == .la)
        let coral = Coral([[Altura(.do, octava: 3), Altura(.mi, octava: 4)]])
        #expect(coral?.transponer(.segundaMayor).acordes.first?.map(\.midi) == [50, 66])
        #expect(coral?.texto(en: .espanolCompacto) == "Do₃ Mi₄")
    }
}
