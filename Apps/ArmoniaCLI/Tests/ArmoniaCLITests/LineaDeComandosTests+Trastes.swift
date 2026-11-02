import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de las digitaciones, el capo, la tablatura y las posiciones en el mástil.

extension LineaDeComandosTests {
    @Test func elCapoYLaTablatura() {
        let conCapo = salida("digitaciones Re --capo 2 --limite 1")
        #expect(conCapo.contains("Capo en el traste 2"), Comment(rawValue: conCapo))
        #expect(conCapo.contains("x32010"), Comment(rawValue: conCapo))
        let tablatura = salida("digitaciones Re La --capo 2 --musicxml")
        #expect(tablatura.hasPrefix("<?xml"), Comment(rawValue: tablatura))
        #expect(tablatura.contains("<capo>2</capo>"))
        #expect(tablatura.contains("<sign>TAB</sign>"))
        #expect(LineaDeComandos.ejecutar(["digitaciones", "Re", "--capo", "13"]).codigo == 2)
    }

    @Test func posiciones() {
        let texto = salida("posiciones Sol mayor")
        #expect(texto.hasPrefix("Sol mayor · 3 notas por cuerda\n\n  Trastes 0–5\n"), Comment(rawValue: texto))
        let primera = """
              Trastes 0–5
                Mi  |--2--3--5-
                Si  |--1--3--5-
                Sol |--0--2--4-
                Re  |--0--2--4-
                La  |--0--2--3-
                Mi  |--0--2--3-
            """
        #expect(texto.contains(primera), Comment(rawValue: texto))
        // Siete posiciones, una por grado: cada una, su cabecera y seis cuerdas.
        #expect((texto.components(separatedBy: "Trastes").count - 1) == 7)
        let caged = salida("posiciones Do mayor --caged")
        #expect(caged.hasPrefix("Do mayor · CAGED\n\n  Forma C · Trastes 0–4\n"), Comment(rawValue: caged))
        let formas = [
            "Forma A · Trastes 2–6", "Forma G · Trastes 5–9", "Forma E · Trastes 7–11", "Forma D · Trastes 9–13",
        ]
        for forma in formas {
            #expect(caged.contains(forma), Comment(rawValue: forma))
        }
        #expect(salida("posiciones La pentatónica menor").contains(" · 2 notas por cuerda\n"))
        #expect(salida("positions G major --caged --ingles").contains(" · CAGED\n\n  G shape · Frets 0–4\n"))
        #expect(salida("ayuda").contains("posiciones <escala> [--caged]"))
        #expect(
            resultado("posiciones").error
                == "armonia: falta la escala: armonia posiciones Sol mayor\nPrueba «armonia ayuda».\n")
        #expect(resultado("posiciones", "Sol", "chungo").codigo == 1)
    }

    @Test func digitacionesDeDoEnLaGuitarra() {
        let texto = salida("digitaciones Do --limite 100")
        #expect(texto.hasPrefix("Do · guitarra\n"), Comment(rawValue: texto))
        #expect(texto.contains("  x32010"), Comment(rawValue: texto))
        #expect(texto.contains("Do Mi Sol Do Mi"), Comment(rawValue: texto))
    }

    @Test func digitacionesRespetanElLimite() {
        // Un encabezado y una línea por forma.
        #expect(salida("digitaciones Do --limite 3").split(separator: "\n").count == 4)
        #expect(salida("digitaciones Do").split(separator: "\n").count == 6) // cinco por defecto
    }

    @Test func digitacionesEnElUkelele() {
        let texto = salida("digitaciones Do --limite 100 --instrumento ukelele")
        #expect(texto.hasPrefix("Do · ukelele\n"), Comment(rawValue: texto))
        #expect(texto.contains("  0003"), Comment(rawValue: texto))
        #expect(salida("digitaciones Do --instrumento Ukulele").hasPrefix("Do · ukelele\n"))
    }

    @Test func elInstrumentoPuedeLlevarEspacios() {
        let orden = resultado("digitaciones", "Mi", "--instrumento", "bajo de 5 cuerdas")
        #expect(orden.codigo == 0, Comment(rawValue: orden.error))
        #expect(orden.salida.hasPrefix("Mi · bajo de cinco cuerdas\n"), Comment(rawValue: orden.salida))
    }

    @Test func lasNotasSeEscribenComoElAcorde() {
        let texto = salida("digitaciones Sib --limite 100")
        #expect(texto.contains("Si♭"), Comment(rawValue: texto))
        #expect(!texto.contains("La♯"), Comment(rawValue: texto))
        // Con --ingles, la notación inglesa.
        #expect(salida("digitaciones C --limite 100 --ingles").contains("C E G C E"))
    }

    @Test func digitacionesConDiagrama() {
        let lineas = salida("digitaciones Do --limite 1 --diagrama").split(separator: "\n").map(String.init)
        // Encabezado, la forma y una línea por cuerda.
        #expect(lineas.count == (1 + 1 + 6), Comment(rawValue: lineas.joined(separator: "\n")))
        #expect(lineas.dropFirst(2).allSatisfy { $0.contains("|-") })
        // La cuerda más aguda va arriba.
        #expect(lineas[2].contains("Mi"), Comment(rawValue: lineas[2]))
    }

    @Test func tabSigueSiendoElDiagrama() {
        #expect(salida("digitaciones Do --limite 1 --tab") == salida("digitaciones Do --limite 1 --diagrama"))
    }

    @Test func variosAcordesSeparadosPorUnaLineaEnBlanco() {
        let texto = salida("digitaciones Do Sol --limite 1")
        #expect(texto.components(separatedBy: "\n\n").count == 2, Comment(rawValue: texto))
    }

    @Test func digitacionesConErrores() {
        let desconocido = resultado("digitaciones", "Do", "--instrumento", "arpa")
        #expect(desconocido.codigo == 2)
        #expect(desconocido.error.contains("instrumento desconocido: «arpa»"), Comment(rawValue: desconocido.error))
        #expect(desconocido.error.contains("guitarra"), Comment(rawValue: desconocido.error))

        #expect(resultado("digitaciones").codigo == 2) // falta el acorde
        #expect(resultado("digitaciones", "Do", "--instrumento").codigo == 2) // falta el valor
        #expect(resultado("digitaciones", "Do", "--limite", "0").codigo == 2)
        #expect(resultado("digitaciones", "Do", "--limite", "muchas").codigo == 2)
        #expect(resultado("digitaciones", "Do", "--traste", "30").codigo == 2)
        #expect(resultado("digitaciones", "Do", "--cejilla").codigo == 2) // opción desconocida
        #expect(resultado("digitaciones", "Do").codigo == 0)

        // Un cifrado que no se lee es un error de lectura (código 1), como en `acorde`.
        let ilegible = resultado("digitaciones", "xyz!")
        #expect(ilegible.codigo == 1)
        #expect(!ilegible.error.isEmpty)
    }

    @Test func digitacionesIndicanLosDedosYLaCejilla() {
        #expect(salida("digitaciones Do --limite 1").contains("(3 dedos)"))
        let fa = salida("digitaciones Fa --limite 6")
        #expect(fa.contains("133211"), Comment(rawValue: fa))
        #expect(fa.contains("(4 dedos, cejilla en el traste 1)"), Comment(rawValue: fa))
        #expect(salida("digitaciones C --limite 1 --ingles").contains("(3 fingers)"))
        #expect(salida("digitaciones Mim --limite 100").contains("(1 dedo)"))
    }

    @Test func laFormaDeManualVaPrimero() {
        // Antes iba por delante una forma en el traste 8.
        #expect(salida("digitaciones Do --limite 1").contains("  x32010"))
        #expect(salida("digitaciones Sol --instrumento ukelele --limite 1").contains("  0232"))
    }

    @Test func laQuintaPuedeFaltarPorDefectoYConCompletoNo() {
        #expect(salida("digitaciones Do7 --limite 200").contains("  x32310"))
        #expect(!(salida("digitaciones Do7 --limite 200 --completo").contains("  x32310")))
    }

    @Test func elLimiteDeDedos() {
        let texto = salida("digitaciones Mim --dedos 1 --limite 50")
        let formas = texto.split(separator: "\n").dropFirst()
        #expect(!formas.isEmpty)
        #expect(formas.allSatisfy { $0.contains("(1 dedo") }, Comment(rawValue: texto))
        for malo in ["0", "5", "muchos"] {
            #expect(resultado("digitaciones", "Mim", "--dedos", malo).codigo == 2, Comment(rawValue: malo))
        }
        #expect(resultado("digitaciones", "Mim", "--dedos").codigo == 2)
    }

    @Test func laAyudaHablaDeLasDigitaciones() {
        #expect(salida("ayuda").contains("digitaciones <cifrado>"))
    }
}
