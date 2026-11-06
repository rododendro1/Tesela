import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de las formas de escribir lo mismo: las subórdenes de los dibujos y de `hoja`, que se leen también
// como las opciones de antes; `--en` y `--tonalidad`; `--comparar` y `--contra`; `--dedos` y `--registro`; y lo que
// salió de `escala` hacia `hoja` y `escalas`.

extension LineaDeComandosTests {
    @Test func subordenesDeLosDibujos() {
        for orden in ["tonnetz", "tabla", "cuadricula"] {
            #expect(salida(orden + " acorde Sol7") == salida(orden + " --acorde Sol7"), Comment(rawValue: orden))
            #expect(salida(orden + " escala Re dórico") == salida(orden + " --escala Re dórico"))
            #expect(salida(orden + " clases 0 4 7") == salida(orden + " --clases 0 4 7"))
            #expect(salida(orden + " chord G7 --ingles") == salida(orden + " --chord G7 --ingles"))
            #expect(salida(orden + " notas Do Mi Sol") == salida(orden + " Do Mi Sol"))
        }
        #expect(salida("tonnetz recorrido Do Lam Fa") == salida("tonnetz --recorrido Do Lam Fa"))
        #expect(salida("tonnetz camino Do Mibm") == salida("tonnetz --camino Do Mibm"))
        #expect(salida("tabla ciclo octatonico Do") == salida("tabla --ciclo octatonico Do"))
        #expect(salida("tonnetz ACORDE Sol7") == salida("tonnetz acorde Sol7"))
        #expect(salida("cuadricula acorde Sol7 --ejes 2,5") == salida("cuadricula --ejes 2,5 --acorde Sol7"))
        // Una suborden que no es de la orden se lee como unas notas, y falla.
        #expect(resultado("tonnetz", "tonalidad", "Do").codigo != 0)
    }

    @Test func subordenesDeLaHoja() {
        #expect(salida("hoja acorde Sol7") == salida("hoja --acorde Sol7"))
        #expect(salida("sheet chord G7 --ingles") == salida("hoja --acorde Sol7 --ingles"))
        #expect(salida("hoja tonalidad Re mayor") == salida("hoja --tonalidad Re mayor"))
        #expect(salida("hoja acordes Rem7 Sol7 Do") == salida("hoja --acordes Rem7 Sol7 Do"))
        #expect(salida("hoja escala Re dórico") == salida("hoja Re dórico"))
        // `--tonalidad` tras los acordes es la de los acordes, como `--en`.
        #expect(
            salida("hoja acordes Rem7 Sol7 Do --tonalidad Do mayor")
                == salida("hoja acordes Rem7 Sol7 Do --en Do mayor"))
        // La comparación nota a nota de dos escalas, que antes daba `escala … --contra`.
        let comparacion = salida("hoja Do mayor --comparar Do dórico")
        #expect(comparacion.contains(">Do mayor → Do dórico</text>"))
        #expect(salida("escala Do mayor --contra Do dórico") == comparacion)
        #expect(resultado("hoja", "Do", "mayor", "--comparar", "Do", "inventada").codigo != 0)
        #expect(resultado("hoja", "Do", "mayor", "--foo").codigo == 2)
    }

    @Test func laTonalidadConEnOConTonalidad() {
        #expect(salida("analizar Do Fa Sol7 Do --tonalidad La menor") == salida("analizar Do Fa Sol7 Do --en La menor"))
        #expect(salida("realizar Do Fa Sol7 Do --key Do mayor") == salida("realizar Do Fa Sol7 Do --en Do mayor"))
        #expect(
            salida("rearmonizar Do Lam Rem7 Sol7 Do --tonalidad Do mayor") == salida("rearmonizar Do Lam Rem7 Sol7 Do"))
        for (otra, nombre) in [("--en", "Sol mayor"), ("--in", "G major"), ("--key", "G major")] {
            let partitura = salida("musicxml acordes Do Fa Sol7 Do \(otra) \(nombre)")
            #expect(
                partitura == salida("musicxml acordes Do Fa Sol7 Do --tonalidad Sol mayor"), Comment(rawValue: otra))
        }
    }

    @Test func compararYContra() {
        let analisis = salida("analizar Do Lam Fa Sol7 --comparar Do Rem7 Fa Sol7")
        #expect(analisis.contains("Comparar con Do Rem7 Fa Sol7"))
        #expect(salida("analizar Do Lam Fa Sol7 --contra Do Rem7 Fa Sol7") == analisis)
        #expect(salida("analyze Do Lam Fa Sol7 --compare Do Rem7 Fa Sol7") == analisis)
        let hoja = salida("hoja acordes Do Lam Fa Sol7 --comparar Do Rem7 Fa Sol7")
        #expect(salida("hoja --acordes Do Lam Fa Sol7 --contra Do Rem7 Fa Sol7") == hoja)
        #expect(salida("acorde Sol7 --contra Do") == salida("acorde Sol7 --comparar Do"))
    }

    @Test func dedosYRegistro() throws {
        #expect(salida("pentagrama escala Do mayor --registro 3") == salida("pentagrama escala Do mayor --octava 3"))
        #expect(salida("staff scale C major --register 3") == salida("pentagrama escala Do mayor --octave 3"))
        #expect(
            salida("pentagrama escala Do mayor --dedos piano") == salida("pentagrama escala Do mayor --mano derecha"))
        #expect(
            salida("pentagrama escala Sol mayor --dedos guitarra")
                == salida("pentagrama escala Sol mayor --tab --dedos"))
        #expect(
            salida("pentagrama escala Sol mayor --fingers guitar")
                == salida("pentagrama escala Sol mayor --tab --dedos"))
        #expect(salida("teclado Re mayor --dedos") == salida("teclado Re mayor --mano derecha"))
        #expect(salida("teclado Re mayor --dedos piano") == salida("teclado Re mayor --mano derecha"))
        #expect(salida("teclado Re mayor --dedos izquierda") == salida("teclado Re mayor --mano izquierda"))
        let escala = salida("escala Do mayor --dedos")
        #expect(escala.contains("Digitación de piano:"))
        #expect(salida("escala Do mayor --piano") == escala)
        #expect(salida("escala Do mayor --dedos piano") == escala)
        #expect(try json("escala Do mayor --dedos") as? [String: Any] != nil)
    }

    @Test func lasEscalasQueSalenDeUna() {
        let parecidas = salida("escalas --parecidas Re dórico")
        #expect(parecidas.hasPrefix("Escalas parecidas:\n"))
        #expect(salida("escala Re dórico --parecidas").hasSuffix(parecidas))
        let vecinas = salida("escalas --vecinas Re dórico")
        #expect(vecinas.hasPrefix("Escalas vecinas:\n"))
        #expect(salida("escala Re dórico --vecinas").hasSuffix(vecinas))
        let escalera = salida("escalas --escalera Re dórico")
        #expect(salida("escala Re dórico --escalera").hasSuffix(escalera))
        #expect(salida("escalas --vecinas Re dórico --escalera Re dórico") == vecinas + escalera)
        #expect(resultado("escalas", "--vecinas", "Re", "dórico", "--foo").codigo == 2)
        #expect(resultado("escalas", "--vecinas").codigo == 2)
    }

    @Test func seLeeEnLaNotacionElegida() {
        #expect(salida("escala re dorian --idioma oc") == salida("escala Re dórico --idioma oc"))
        #expect(salida("acorde B7/D --idioma de") == salida("acorde Sib7/Re --idioma de"))
        #expect(salida("acorde Do7 --idioma de") == salida("acorde C7 --idioma de"))
        #expect(salida("tonalidad B-Dur --idioma de") == salida("tonalidad Sib mayor --idioma de"))
        #expect(salida("acorde Rém7 --idioma fr") == salida("acorde Rem7 --idioma fr"))
    }
}
