import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de las digitaciones, el capo, la tablatura y las posiciones en el mástil.

extension LineaDeComandosTests {
    func testElCapoYLaTablatura() {
        let conCapo = salida("digitaciones Re --capo 2 --limite 1")
        XCTAssertTrue(conCapo.contains("Capo en el traste 2"), conCapo)
        XCTAssertTrue(conCapo.contains("x32010"), conCapo)
        let tablatura = salida("digitaciones Re La --capo 2 --musicxml")
        XCTAssertTrue(tablatura.hasPrefix("<?xml"), tablatura)
        XCTAssertTrue(tablatura.contains("<capo>2</capo>"))
        XCTAssertTrue(tablatura.contains("<sign>TAB</sign>"))
        XCTAssertEqual(LineaDeComandos.ejecutar(["digitaciones", "Re", "--capo", "13"]).codigo, 2)
    }

    func testPosiciones() {
        let texto = salida("posiciones Sol mayor")
        XCTAssertTrue(texto.hasPrefix("Sol mayor · 3 notas por cuerda\n\n  Trastes 0–5\n"), texto)
        let primera = """
              Trastes 0–5
                Mi  |--2--3--5-
                Si  |--1--3--5-
                Sol |--0--2--4-
                Re  |--0--2--4-
                La  |--0--2--3-
                Mi  |--0--2--3-
            """
        XCTAssertTrue(texto.contains(primera), texto)
        // Siete posiciones, una por grado: cada una, su cabecera y seis cuerdas.
        XCTAssertEqual(texto.components(separatedBy: "Trastes").count - 1, 7)
        let caged = salida("posiciones Do mayor --caged")
        XCTAssertTrue(caged.hasPrefix("Do mayor · CAGED\n\n  Forma C · Trastes 0–4\n"), caged)
        let formas = [
            "Forma A · Trastes 2–6", "Forma G · Trastes 5–9", "Forma E · Trastes 7–11", "Forma D · Trastes 9–13",
        ]
        for forma in formas {
            XCTAssertTrue(caged.contains(forma), forma)
        }
        XCTAssertTrue(salida("posiciones La pentatónica menor").contains(" · 2 notas por cuerda\n"))
        XCTAssertTrue(salida("positions G major --caged --ingles").contains(" · CAGED\n\n  G shape · Frets 0–4\n"))
        XCTAssertTrue(salida("ayuda").contains("posiciones <escala> [--caged]"))
        XCTAssertEqual(
            resultado("posiciones").error,
            "armonia: falta la escala: armonia posiciones Sol mayor\nPrueba «armonia ayuda».\n")
        XCTAssertEqual(resultado("posiciones", "Sol", "chungo").codigo, 1)
    }

    func testDigitacionesDeDoEnLaGuitarra() {
        let texto = salida("digitaciones Do --limite 100")
        XCTAssertTrue(texto.hasPrefix("Do · guitarra\n"), texto)
        XCTAssertTrue(texto.contains("  x32010"), texto)
        XCTAssertTrue(texto.contains("Do Mi Sol Do Mi"), texto)
    }

    func testDigitacionesRespetanElLimite() {
        // Un encabezado y una línea por forma.
        XCTAssertEqual(salida("digitaciones Do --limite 3").split(separator: "\n").count, 4)
        XCTAssertEqual(salida("digitaciones Do").split(separator: "\n").count, 6) // cinco por defecto
    }

    func testDigitacionesEnElUkelele() {
        let texto = salida("digitaciones Do --limite 100 --instrumento ukelele")
        XCTAssertTrue(texto.hasPrefix("Do · ukelele\n"), texto)
        XCTAssertTrue(texto.contains("  0003"), texto)
        XCTAssertTrue(salida("digitaciones Do --instrumento Ukulele").hasPrefix("Do · ukelele\n"))
    }

    func testElInstrumentoPuedeLlevarEspacios() {
        let orden = resultado("digitaciones", "Mi", "--instrumento", "bajo de 5 cuerdas")
        XCTAssertEqual(orden.codigo, 0, orden.error)
        XCTAssertTrue(orden.salida.hasPrefix("Mi · bajo de cinco cuerdas\n"), orden.salida)
    }

    func testLasNotasSeEscribenComoElAcorde() {
        let texto = salida("digitaciones Sib --limite 100")
        XCTAssertTrue(texto.contains("Si♭"), texto)
        XCTAssertFalse(texto.contains("La♯"), texto)
        // Con --ingles, la notación inglesa.
        XCTAssertTrue(salida("digitaciones C --limite 100 --ingles").contains("C E G C E"))
    }

    func testDigitacionesConDiagrama() {
        let lineas = salida("digitaciones Do --limite 1 --diagrama").split(separator: "\n").map(String.init)
        // Encabezado, la forma y una línea por cuerda.
        XCTAssertEqual(lineas.count, 1 + 1 + 6, lineas.joined(separator: "\n"))
        XCTAssertTrue(lineas.dropFirst(2).allSatisfy { $0.contains("|-") })
        // La cuerda más aguda va arriba.
        XCTAssertTrue(lineas[2].contains("Mi"), lineas[2])
    }

    func testTabSigueSiendoElDiagrama() {
        XCTAssertEqual(salida("digitaciones Do --limite 1 --tab"), salida("digitaciones Do --limite 1 --diagrama"))
    }

    func testVariosAcordesSeparadosPorUnaLineaEnBlanco() {
        let texto = salida("digitaciones Do Sol --limite 1")
        XCTAssertEqual(texto.components(separatedBy: "\n\n").count, 2, texto)
    }

    func testDigitacionesConErrores() {
        let desconocido = resultado("digitaciones", "Do", "--instrumento", "arpa")
        XCTAssertEqual(desconocido.codigo, 2)
        XCTAssertTrue(desconocido.error.contains("instrumento desconocido: «arpa»"), desconocido.error)
        XCTAssertTrue(desconocido.error.contains("guitarra"), desconocido.error)

        XCTAssertEqual(resultado("digitaciones").codigo, 2) // falta el acorde
        XCTAssertEqual(resultado("digitaciones", "Do", "--instrumento").codigo, 2) // falta el valor
        XCTAssertEqual(resultado("digitaciones", "Do", "--limite", "0").codigo, 2)
        XCTAssertEqual(resultado("digitaciones", "Do", "--limite", "muchas").codigo, 2)
        XCTAssertEqual(resultado("digitaciones", "Do", "--traste", "30").codigo, 2)
        XCTAssertEqual(resultado("digitaciones", "Do", "--cejilla").codigo, 2) // opción desconocida
        XCTAssertEqual(resultado("digitaciones", "Do").codigo, 0)

        // Un cifrado que no se lee es un error de lectura (código 1), como en `acorde`.
        let ilegible = resultado("digitaciones", "xyz!")
        XCTAssertEqual(ilegible.codigo, 1)
        XCTAssertFalse(ilegible.error.isEmpty)
    }

    func testDigitacionesIndicanLosDedosYLaCejilla() {
        XCTAssertTrue(salida("digitaciones Do --limite 1").contains("(3 dedos)"))
        let fa = salida("digitaciones Fa --limite 6")
        XCTAssertTrue(fa.contains("133211"), fa)
        XCTAssertTrue(fa.contains("(4 dedos, cejilla en el traste 1)"), fa)
        XCTAssertTrue(salida("digitaciones C --limite 1 --ingles").contains("(3 fingers)"))
        XCTAssertTrue(salida("digitaciones Mim --limite 100").contains("(1 dedo)"))
    }

    func testLaFormaDeManualVaPrimero() {
        // Antes iba por delante una forma en el traste 8.
        XCTAssertTrue(salida("digitaciones Do --limite 1").contains("  x32010"))
        XCTAssertTrue(salida("digitaciones Sol --instrumento ukelele --limite 1").contains("  0232"))
    }

    func testLaQuintaPuedeFaltarPorDefectoYConCompletoNo() {
        XCTAssertTrue(salida("digitaciones Do7 --limite 200").contains("  x32310"))
        XCTAssertFalse(salida("digitaciones Do7 --limite 200 --completo").contains("  x32310"))
    }

    func testElLimiteDeDedos() {
        let texto = salida("digitaciones Mim --dedos 1 --limite 50")
        let formas = texto.split(separator: "\n").dropFirst()
        XCTAssertFalse(formas.isEmpty)
        XCTAssertTrue(formas.allSatisfy { $0.contains("(1 dedo") }, texto)
        for malo in ["0", "5", "muchos"] {
            XCTAssertEqual(resultado("digitaciones", "Mim", "--dedos", malo).codigo, 2, malo)
        }
        XCTAssertEqual(resultado("digitaciones", "Mim", "--dedos").codigo, 2)
    }

    func testLaAyudaHablaDeLasDigitaciones() {
        XCTAssertTrue(salida("ayuda").contains("digitaciones <cifrado>"))
    }
}
