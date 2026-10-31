import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las rearmonizaciones: sustituto tritonal, dominantes secundarias, préstamo modal y sustitutos diatónicos.
final class RearmonizacionTests: XCTestCase {
    private let progresion = [Acorde("Do"), Acorde("Lam"), Acorde("Rem7"), Acorde("Sol7"), Acorde("Do")]

    private func propuestas(_ recurso: Rearmonizacion.Recurso, en posicion: Int) -> [[Acorde]] {
        Tonalidad(.do).rearmonizaciones(de: progresion)
            .filter { $0.recurso == recurso && $0.posicion == posicion }.map(\.acordes)
    }

    func testElSustitutoTritonal() {
        XCTAssertEqual(propuestas(.sustitutoTritonal, en: 3), [[Acorde(Nota.re.bemol, .dominanteSeptima)]])
        // Solo las séptimas de dominante.
        XCTAssertEqual(propuestas(.sustitutoTritonal, en: 2), [])
        // Con la ortografía más sencilla: el de Re♭7 es Sol7, no La𝄫7.
        XCTAssertEqual(Tonalidad.aUnTritono(de: Nota.re.bemol), .sol)
        XCTAssertEqual(Tonalidad.aUnTritono(de: .sol), Nota.re.bemol)
    }

    func testLasDominantesSecundarias() {
        XCTAssertEqual(propuestas(.dominanteSecundaria, en: 1), [[Acorde("Mi7"), Acorde("Lam")]])
        XCTAssertEqual(propuestas(.dominanteSecundaria, en: 2), [[Acorde("La7"), Acorde("Rem7")]])
        // El Do final ya viene de Sol7: no se repite su dominante.
        XCTAssertEqual(propuestas(.dominanteSecundaria, en: 4), [])
        // Un acorde disminuido no se prepara así.
        let disminuido = Tonalidad(.do).rearmonizaciones(de: Acorde(.si, .disminuido))
        XCTAssertTrue(disminuido.allSatisfy { $0.recurso != .dominanteSecundaria })
    }

    func testElPrestamoModal() {
        XCTAssertEqual(propuestas(.prestamoModal, en: 0), [[Acorde("Dom")]])
        XCTAssertEqual(propuestas(.prestamoModal, en: 1), [[Acorde(Nota.la.bemol, .mayor)]])
        XCTAssertEqual(propuestas(.prestamoModal, en: 2), [[Acorde(.re, .semidisminuido)]])
        // En lugar de la dominante, el ♭VII.
        XCTAssertEqual(propuestas(.prestamoModal, en: 3), [[Acorde(Nota.si.bemol, .dominanteSeptima)]])
        // En menor se toma del mayor: la tercera de picardía.
        let enLaMenor = Tonalidad(.la, .menor).rearmonizaciones(de: [Acorde("Lam"), Acorde("Rem"), Acorde("Mi7")])
        XCTAssertTrue(enLaMenor.contains { $0.recurso == .prestamoModal && $0.acordes == [Acorde("La")] })
        XCTAssertTrue(enLaMenor.contains { $0.recurso == .prestamoModal && $0.acordes == [Acorde("Re")] })
        XCTAssertFalse(enLaMenor.contains { $0.recurso == .prestamoModal && $0.posicion == 2 })
    }

    func testLosSustitutosDiatonicos() {
        XCTAssertEqual(propuestas(.sustitutoDiatonico, en: 0), [[Acorde("Lam")]])
        XCTAssertEqual(propuestas(.sustitutoDiatonico, en: 2), [[Acorde(.fa, .mayorSeptimaMayor)]])
        XCTAssertEqual(propuestas(.sustitutoDiatonico, en: 3), [[Acorde(.si, .semidisminuido)]])
        // Un acorde ajeno a la tonalidad no tiene ni préstamo ni sustituto diatónico.
        let ajeno = Tonalidad(.do).rearmonizaciones(de: Acorde("Fa#"))
        XCTAssertTrue(ajeno.allSatisfy { $0.recurso == .dominanteSecundaria })
    }

    func testAplicarYDescribir() throws {
        let tritonal = try XCTUnwrap(
            Tonalidad(.do).rearmonizaciones(de: progresion).first { $0.recurso == .sustitutoTritonal })
        XCTAssertEqual(tritonal.aplicar(a: progresion).map(\.cifrado), ["Do", "Lam", "Rem7", "Re♭7", "Do"])
        XCTAssertEqual(tritonal.descripcion(en: .espanolUnicode), "Sol7 → Re♭7 (sustituto tritonal)")
        XCTAssertEqual(tritonal.descripcion(en: .inglesASCII), "G7 → Db7 (tritone substitution)")
        let secundaria = try XCTUnwrap(
            Tonalidad(.do).rearmonizaciones(de: progresion).first { $0.recurso == .dominanteSecundaria })
        XCTAssertEqual(secundaria.aplicar(a: progresion).count, progresion.count + 1)
        XCTAssertEqual(tritonal.aplicar(a: []), [])
        for idioma in Idioma.traducidos {
            let notacion = Notacion.espanolUnicode.conTextos(en: idioma)
            let nombres = Rearmonizacion.Recurso.allCases.map { $0.nombre(en: notacion) }
            XCTAssertEqual(Set(nombres).count, nombres.count, "\(idioma)")
        }
    }

    func testTransportarElCamino() {
        XCTAssertEqual(Nota.do.intervaloMasCorto(hasta: .re), .segundaMayor)
        XCTAssertEqual(Nota.do.intervaloMasCorto(hasta: .la).semitonosConSigno, -3)
        XCTAssertEqual(Nota.do.intervaloMasCorto(hasta: Nota.fa.sostenido).semitonosConSigno, 6)
        XCTAssertEqual((Nota.do + Nota.do.intervaloMasCorto(hasta: .la)), .la)
        let coral = Coral([[Altura(.do, octava: 3), Altura(.mi, octava: 4)]])
        XCTAssertEqual(coral?.transponer(.segundaMayor).acordes.first?.map(\.midi), [50, 66])
        XCTAssertEqual(coral?.texto(en: .espanolUnicode), "Do3 Mi4")
    }
}
