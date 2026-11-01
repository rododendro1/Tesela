import XCTest

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

final class CategoriaTradicionalTests: XCTestCase {
    /// Toda escala de otra tradición tiene tradición y categoría.
    func testTodasLasTradicionalesTienenClaseYTradicion() {
        for tipo in TipoDeEscala.tradicionales {
            XCTAssertNotNil(tipo.categoria, tipo.nombre)
            XCTAssertNotNil(tipo.tradicion, tipo.nombre)
        }
    }

    /// Las occidentales y las escalas propias no tienen categoría.
    func testLasOccidentalesYLasPropiasNoTienenClase() {
        for tipo in TipoDeEscala.todos {
            XCTAssertNil(tipo.categoria, tipo.nombre)
            XCTAssertNil(tipo.tradicion, tipo.nombre)
        }
        let propia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .quintaJusta])
        XCTAssertNil(propia.categoria)
        XCTAssertFalse(propia.esRaga)
    }

    func testLasClasesCoincidenConLasListas() {
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .melakarta).count, 72)
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .thaat).count, TipoDeEscala.thaats.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .dromos).count, TipoDeEscala.dromoi.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .maqam).count, TipoDeEscala.maqamat.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .janya).count, TipoDeEscala.janyas.count)
        XCTAssertEqual(TipoDeEscala.tradicionales(categoria: .raga).count, TipoDeEscala.ragasIndostanicos.count)
        let tetracordos = TipoDeEscala.tradicionales(categoria: .tetracordo)
        let harmoniai = TipoDeEscala.tradicionales(categoria: .harmonia)
        XCTAssertEqual(tetracordos.count + harmoniai.count, TipoDeEscala.griegasAntiguas.count)
        // Todas las escalas de la India son de una de las cuatro categorías indias.
        let indias = TipoDeEscala.tradicionales(tradicion: .india)
        XCTAssertTrue(indias.allSatisfy { [.thaat, .melakarta, .janya, .raga].contains($0.categoria) })
        XCTAssertEqual(indias.count, TipoDeEscala.tradicionales.filter { $0.tradicion == .india }.count)
    }

    func testRagasMelakartasYThaats() {
        XCTAssertEqual(TipoDeEscala.melakarta(15)?.categoria, .melakarta)
        XCTAssertEqual(TipoDeEscala.melakarta(15)?.tradicion, .india)
        XCTAssertEqual(TipoDeEscala.hitzaz.categoria, .dromos)
        XCTAssertEqual(TipoDeEscala.hitzaz.tradicion, .grecia)
        XCTAssertEqual(TipoDeEscala.hiyaz.categoria, .maqam)
        // Un melakarta y un janya son ragas; un thaat, no.
        XCTAssertTrue(TipoDeEscala.melakarta(15)?.esRaga ?? false)
        XCTAssertTrue(TipoDeEscala.janyas.allSatisfy(\.esRaga))
        XCTAssertTrue(TipoDeEscala.ragasIndostanicos.allSatisfy(\.esRaga))
        XCTAssertFalse(TipoDeEscala.thaats.contains(where: \.esRaga))
        XCTAssertFalse(TipoDeEscala.hitzaz.esRaga)
    }

    /// Āsāvarī (un thaat) tiene los intervalos de la menor natural, que no tiene categoría: se busca por el nombre.
    func testAsavariTieneClaseAunqueSeaIgualALaMenorNatural() {
        XCTAssertEqual(TipoDeEscala.asavari, TipoDeEscala.menorNatural)
        XCTAssertEqual(TipoDeEscala.asavari.categoria, .thaat)
        XCTAssertNil(TipoDeEscala.menorNatural.categoria)
    }

    func testLosNombresDeLasClasesSeTraducen() {
        let ruso = Notacion.espanolUnicode.conTextos(en: .ruso)
        let griego = Notacion.espanolUnicode.conTextos(en: .griego)
        let frances = Notacion.espanolUnicode.conTextos(en: .frances)
        XCTAssertEqual(CategoriaTradicional.raga.nombre, "raga")
        XCTAssertEqual(CategoriaTradicional.raga.nombre(en: ruso), "рага")
        XCTAssertEqual(CategoriaTradicional.dromos.nombre(en: griego), "δρόμος")
        XCTAssertEqual(CategoriaTradicional.escala.nombre(en: frances), "gamme")
        XCTAssertEqual(CategoriaTradicional.tetracordo.nombre(en: frances), "tétracorde")
        XCTAssertEqual(CategoriaTradicional.maqam.nombre(en: frances), "maqam")
        XCTAssertEqual(CategoriaTradicional.raga.nombre(en: Notacion.espanolUnicode.conTextos(en: .aleman)), "Raga")
        // Cada fichero de idioma da el nombre de todas las categorías.
        for categoria in CategoriaTradicional.allCases {
            for idioma in Idioma.allCases {
                XCTAssertNotNil(NombresDeEscalas.de(idioma).nombre(de: categoria), "\(categoria) \(idioma)")
                XCTAssertFalse(
                    categoria.nombre(en: Notacion.espanolUnicode.conTextos(en: idioma)).isEmpty,
                    "\(categoria) \(idioma)")
            }
        }
    }

    /// Una escala propia con el nombre de una tradicional, pero otros intervalos, no es de esa categoría.
    func testUnaEscalaPropiaConNombreDeTradicionalNoTieneClase() {
        let falsa = TipoDeEscala(nombre: "Kāfī", intervalos: [.unisono, .quintaJusta])
        XCTAssertNil(falsa.categoria)
        XCTAssertNil(falsa.tradicion)
        XCTAssertEqual(TipoDeEscala.kafi.categoria, .thaat)
        let igual = TipoDeEscala(nombre: TipoDeEscala.kafi.nombre, intervalos: TipoDeEscala.kafi.intervalos)
        XCTAssertEqual(igual.categoria, .thaat)
    }

    /// El padre de un janya es un melakarta que contiene todas sus notas; Revati no tiene uno único.
    func testElPadreDeUnJanyaEsUnMelakartaCompatible() {
        XCTAssertEqual(TipoDeEscala.mohanam.padre?.numeroDeMelakarta, 28)
        XCTAssertEqual(TipoDeEscala.hindolam.padre?.nombre, "Naṭabhairavī")
        XCTAssertNil(TipoDeEscala.revati.padre)
        for janya in TipoDeEscala.janyas {
            guard let padre = janya.padre, let numero = padre.numeroDeMelakarta else { continue }
            XCTAssertEqual(padre.categoria, .melakarta, janya.nombre)
            XCTAssertTrue(janya.melakartasCompatibles.contains(numero), "\(janya.nombre) ↛ \(numero)")
        }
        XCTAssertNil(TipoDeEscala.mayor.padre)
        XCTAssertNil(TipoDeEscala.thaats[0].padre)
    }
}
