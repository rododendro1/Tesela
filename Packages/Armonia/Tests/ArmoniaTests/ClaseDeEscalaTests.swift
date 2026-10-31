import XCTest

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

final class ClaseDeEscalaTests: XCTestCase {
    /// Toda escala de otra tradición tiene tradición y clase.
    func testTodasLasTradicionalesTienenClaseYTradicion() {
        for tipo in TipoDeEscala.tradicionales {
            XCTAssertNotNil(tipo.clase, tipo.nombre)
            XCTAssertNotNil(tipo.tradicion, tipo.nombre)
        }
    }

    /// Las occidentales y las escalas propias no tienen clase.
    func testLasOccidentalesYLasPropiasNoTienenClase() {
        for tipo in TipoDeEscala.todos {
            XCTAssertNil(tipo.clase, tipo.nombre)
            XCTAssertNil(tipo.tradicion, tipo.nombre)
        }
        let propia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta])
        XCTAssertNil(propia.clase)
        XCTAssertFalse(propia.esRaga)
    }

    func testLasClasesCoincidenConLasListas() {
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .melakarta).count, 72)
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .thaat).count, TipoDeEscala.thaats.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .dromos).count, TipoDeEscala.dromoi.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .maqam).count, TipoDeEscala.maqamat.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .janya).count, TipoDeEscala.janyas.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(clase: .raga).count, TipoDeEscala.ragasIndostanicos.count)
        XCTAssertEqual(
            TipoDeEscala.tradicionales(clase: .tetracordo).count + TipoDeEscala.tradicionales(clase: .harmonia).count,
            TipoDeEscala.griegasAntiguas.count)
        // Todas las escalas de la India son de una de las cuatro clases indias.
        let indias = TipoDeEscala.tradicionales(tradicion: .india)
        XCTAssertTrue(indias.allSatisfy { [.thaat, .melakarta, .janya, .raga].contains($0.clase) })
        XCTAssertEqual(indias.count, TipoDeEscala.tradicionales.filter { $0.tradicion == .india }.count)
    }

    func testRagasMelakartasYThaats() {
        XCTAssertEqual(TipoDeEscala.melakarta(15)?.clase, .melakarta)
        XCTAssertEqual(TipoDeEscala.melakarta(15)?.tradicion, .india)
        XCTAssertEqual(TipoDeEscala.hitzaz.clase, .dromos)
        XCTAssertEqual(TipoDeEscala.hitzaz.tradicion, .grecia)
        XCTAssertEqual(TipoDeEscala.hiyaz.clase, .maqam)
        // Un melakarta y un janya son ragas; un thaat, no.
        XCTAssertTrue(TipoDeEscala.melakarta(15)?.esRaga ?? false)
        XCTAssertTrue(TipoDeEscala.janyas.allSatisfy(\.esRaga))
        XCTAssertTrue(TipoDeEscala.ragasIndostanicos.allSatisfy(\.esRaga))
        XCTAssertFalse(TipoDeEscala.thaats.contains(where: \.esRaga))
        XCTAssertFalse(TipoDeEscala.hitzaz.esRaga)
    }

    /// Āsāvarī (un thaat) tiene los intervalos de la menor natural, que no tiene clase: se busca por el nombre.
    func testAsavariTieneClaseAunqueSeaIgualALaMenorNatural() {
        XCTAssertEqual(TipoDeEscala.asavari, TipoDeEscala.menorNatural)
        XCTAssertEqual(TipoDeEscala.asavari.clase, .thaat)
        XCTAssertNil(TipoDeEscala.menorNatural.clase)
    }

    func testLosNombresDeLasClasesSeTraducen() {
        let ruso = Notacion.espanolUnicode.conTextos(en: .ruso)
        let griego = Notacion.espanolUnicode.conTextos(en: .griego)
        let frances = Notacion.espanolUnicode.conTextos(en: .frances)
        XCTAssertEqual(ClaseDeEscala.raga.nombre, "raga")
        XCTAssertEqual(ClaseDeEscala.raga.nombre(en: ruso), "рага")
        XCTAssertEqual(ClaseDeEscala.dromos.nombre(en: griego), "δρόμος")
        XCTAssertEqual(ClaseDeEscala.escala.nombre(en: frances), "gamme")
        XCTAssertEqual(ClaseDeEscala.tetracordo.nombre(en: frances), "tétracorde")
        XCTAssertEqual(ClaseDeEscala.maqam.nombre(en: frances), "maqam")
        XCTAssertEqual(ClaseDeEscala.raga.nombre(en: Notacion.espanolUnicode.conTextos(en: .aleman)), "Raga")
        // Cada fichero de idioma da el nombre de todas las clases.
        for clase in ClaseDeEscala.allCases {
            for idioma in Idioma.allCases {
                XCTAssertNotNil(NombresDeEscalas.de(idioma).nombre(de: clase), "\(clase) \(idioma)")
                XCTAssertFalse(
                    clase.nombre(en: Notacion.espanolUnicode.conTextos(en: idioma)).isEmpty, "\(clase) \(idioma)")
            }
        }
    }

    /// Una escala propia con el nombre de una tradicional, pero otros intervalos, no es de esa clase.
    func testUnaEscalaPropiaConNombreDeTradicionalNoTieneClase() {
        let falsa = TipoDeEscala(nombre: "Kāfī", intervalos: [.unisono, .quintaJusta])
        XCTAssertNil(falsa.clase)
        XCTAssertNil(falsa.tradicion)
        XCTAssertEqual(TipoDeEscala.kafi.clase, .thaat)
        let igual = TipoDeEscala(nombre: TipoDeEscala.kafi.nombre, intervalos: TipoDeEscala.kafi.intervalos)
        XCTAssertEqual(igual.clase, .thaat)
    }

    /// El padre de un janya es un melakarta que contiene todas sus notas; Revati no tiene uno único.
    func testElPadreDeUnJanyaEsUnMelakartaCompatible() {
        XCTAssertEqual(TipoDeEscala.mohanam.padre?.numeroDeMelakarta, 28)
        XCTAssertEqual(TipoDeEscala.hindolam.padre?.nombre, "Naṭabhairavī")
        XCTAssertNil(TipoDeEscala.revati.padre)
        for janya in TipoDeEscala.janyas {
            guard let padre = janya.padre, let numero = padre.numeroDeMelakarta else { continue }
            XCTAssertEqual(padre.clase, .melakarta, janya.nombre)
            XCTAssertTrue(janya.melakartasCompatibles.contains(numero), "\(janya.nombre) ↛ \(numero)")
        }
        XCTAssertNil(TipoDeEscala.mayor.padre)
        XCTAssertNil(TipoDeEscala.thaats[0].padre)
    }
}
