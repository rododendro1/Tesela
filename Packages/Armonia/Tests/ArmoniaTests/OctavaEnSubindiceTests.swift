import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// La octava de las alturas escrita como subíndice (La₄): al escribir, con `Notacion.conOctavas(.subindices)`, y al
/// leer, siempre.
final class OctavaEnSubindiceTests: XCTestCase {
    private let subindices = Notacion.espanolUnicode.conOctavas(.subindices)

    func testEscribirLaOctava() {
        XCTAssertEqual(EscrituraDeLaOctava.cifras.escribir(4), "4")
        XCTAssertEqual(EscrituraDeLaOctava.subindices.escribir(4), "₄")
        XCTAssertEqual(EscrituraDeLaOctava.subindices.escribir(10), "₁₀")
        XCTAssertEqual(EscrituraDeLaOctava.subindices.escribir(-1), "₋₁")
        XCTAssertEqual(EscrituraDeLaOctava.conCifras("Si♭₋₁ y La₁₀"), "Si♭-1 y La10")
    }

    func testLaNotacionGuardaLaEleccion() {
        XCTAssertEqual(Notacion.espanolUnicode.octavas, .cifras)
        XCTAssertEqual(subindices.octavas, .subindices)
        XCTAssertEqual(subindices.conTextos(en: .ingles).octavas, .subindices)
        XCTAssertEqual(subindices.conTextos(en: .ingles).textos, .ingles)
        XCTAssertEqual(subindices.notas, .espanolUnicode)
        XCTAssertNotEqual(subindices, .espanolUnicode)
        XCTAssertEqual(subindices.conOctavas(.cifras), .espanolUnicode)
    }

    func testNombresConSubindice() {
        XCTAssertEqual(Altura(.la, octava: 4).nombre(en: subindices), "La₄")
        XCTAssertEqual(Altura(Nota.fa.sostenido, octava: 3).nombre(en: subindices), "Fa♯₃")
        XCTAssertEqual(Altura(Nota.si.bemol, octava: -1).nombre(en: subindices), "Si♭₋₁")
        XCTAssertEqual(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .inglesASCII.conOctavas(.subindices)), "F#₄")
        XCTAssertEqual(Altura(Nota.fa.sostenido, octava: 4).nombre(en: .frances.conOctavas(.subindices)), "fa dièse ₄")
        XCTAssertEqual(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: subindices), "Fa♯₄")
        XCTAssertEqual(Altura(Nota.fa.sostenido, octava: 4).nombreCompacto(en: .espanol), "Fa♯4")
        // Sin pedirlo, todo sigue con cifras.
        XCTAssertEqual(Altura(.la, octava: 4).nombre(en: .espanolUnicode), "La4")
        XCTAssertEqual(Altura(.la, octava: 4).description, "La4")
    }

    func testLeerSubindices() throws {
        XCTAssertEqual(try Altura(leyendo: "La₄"), Altura(.la, octava: 4))
        XCTAssertEqual(try Altura(leyendo: "Do♯₃"), Altura(Nota.`do`.sostenido, octava: 3))
        XCTAssertEqual(try Altura(leyendo: "Si♭₋₁"), Altura(Nota.si.bemol, octava: -1))
        XCTAssertEqual(try Altura(leyendo: "C#₅"), Altura(Nota.`do`.sostenido, octava: 5))
        XCTAssertEqual(try Altura(leyendo: "ré bémol ₃", en: .frances), Altura(Nota.re.bemol, octava: 3))
        XCTAssertEqual(try Altura(leyendo: "Fis₄", en: .aleman), Altura(Nota.fa.sostenido, octava: 4))
        XCTAssertThrowsError(try Altura(leyendo: "La₄x"))
        XCTAssertThrowsError(try Altura(leyendo: "La"))
    }

    func testIdaYVuelta() throws {
        for notacion in [subindices, .inglesASCII.conOctavas(.subindices), .aleman.conOctavas(.subindices)] {
            for midi in [21, 47, 60, 61, 70, 108] {
                let altura = Altura(midi: midi)
                XCTAssertEqual(try Altura(leyendo: altura.nombre(en: notacion), en: notacion), altura, "\(notacion)")
            }
        }
    }

    func testMelodiasYCorales() throws {
        XCTAssertEqual(try Evento(leyendo: "Mi₄:4").alturas, [Altura(.mi, octava: 4)])
        let coral = try Coral(leyendo: "Do₃ Mi₄ | Re₃ Fa₄")
        XCTAssertEqual(coral, try Coral(leyendo: "Do3 Mi4 | Re3 Fa4"))
        XCTAssertEqual(coral.texto(en: subindices), "Do₃ Mi₄ | Re₃ Fa₄")
        XCTAssertEqual(coral.texto(en: .espanolUnicode), "Do3 Mi4 | Re3 Fa4")
    }
}
