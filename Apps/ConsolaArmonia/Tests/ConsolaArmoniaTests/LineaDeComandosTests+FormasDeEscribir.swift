import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de las formas de escribir lo mismo: las subórdenes de los dibujos, de `hoja` y de `plr`; `--en`;
// `--comparar`; `--dedos` y `--registro`; lo que salió de `escala` hacia `hoja` y `escalas`, y que los nombres de antes
// ya no se leen.

extension LineaDeComandosTests {
    /// Sale con código 2, como una opción o una orden desconocida.
    func noSeLee(_ orden: String, sourceLocation: SourceLocation = #_sourceLocation) {
        let resultado = self.resultado(orden)
        #expect(resultado.codigo == 2, Comment(rawValue: orden), sourceLocation: sourceLocation)
    }

    @Test func subordenesDeLosDibujos() {
        for orden in ["tonnetz", "tabla", "cuadricula"] {
            #expect(salida(orden + " acorde Sol7").hasPrefix("<svg"), Comment(rawValue: orden))
            #expect(salida(orden + " notas Do Mi Sol") == salida(orden + " Do Mi Sol"))
            for antes in ["--acorde Sol7", "--escala Re dórico", "--clases 0 4 7", "--chord G7"] {
                noSeLee(orden + " " + antes)
            }
        }
        noSeLee("tonnetz --recorrido Do Lam Fa")
        noSeLee("tonnetz --camino Do Mibm")
        noSeLee("tabla --ciclo octatonico Do")
        noSeLee("cuadricula --ejes 2,5 --acorde Sol7")
        #expect(salida("tonnetz ACORDE Sol7") == salida("tonnetz acorde Sol7"))
        // Una suborden que no es de la orden se lee como unas notas, y falla.
        #expect(resultado("tonnetz", "tonalidad", "Do").codigo != 0)
    }

    @Test func subordenesDeLaHoja() {
        #expect(salida("sheet chord G7 --ingles") == salida("hoja acorde Sol7 --ingles"))
        #expect(salida("hoja escala Re dórico") == salida("hoja Re dórico"))
        for antes in [
            "hoja --acorde Sol7", "hoja --tonalidad Re mayor", "hoja --acordes Rem7 Sol7 Do",
            "hoja acordes Rem7 Sol7 Do --tonalidad Do mayor", "escala Do mayor --contra Do dórico",
        ] {
            noSeLee(antes)
        }
        let comparacion = salida("hoja Do mayor --comparar Do dórico")
        #expect(comparacion.contains(">Do mayor → Do dórico</text>"))
        #expect(resultado("hoja", "Do", "mayor", "--comparar", "Do", "inventada").codigo != 0)
        #expect(resultado("hoja", "Do", "mayor", "--foo").codigo == 2)
    }

    @Test func laTonalidadConEn() {
        #expect(
            salida("musicxml acordes Do Fa Sol7 Do --in G major")
                == salida("musicxml acordes Do Fa Sol7 Do --en Sol mayor"))
        for antes in [
            "analizar Do Fa Sol7 Do --tonalidad La menor", "analizar Do Fa Sol7 Do --key Do mayor",
            "rearmonizar Do Lam Rem7 Sol7 Do --tonalidad Do mayor",
            "musicxml acordes Do Fa Sol7 Do --tonalidad Sol mayor",
            "musicxml acordes Do Fa Sol7 Do --key G major",
        ] {
            noSeLee(antes)
        }
    }

    @Test func comparar() {
        let analisis = salida("analizar Do Lam Fa Sol7 --comparar Do Rem7 Fa Sol7")
        #expect(analisis.contains("Comparar con Do Rem7 Fa Sol7"))
        #expect(salida("analyze Do Lam Fa Sol7 --compare Do Rem7 Fa Sol7") == analisis)
        noSeLee("analizar Do Lam Fa Sol7 --contra Do Rem7 Fa Sol7")
        noSeLee("hoja acordes Do Lam Fa Sol7 --contra Do Rem7 Fa Sol7")
        noSeLee("acorde Sol7 --contra Do")
        noSeLee("acorde G7 --against C")
    }

    @Test func dedosYRegistro() throws {
        #expect(salida("staff scale C major --register 3") == salida("pentagrama escala Do mayor --registro 3"))
        #expect(
            salida("pentagrama escala Sol mayor --fingers guitar")
                == salida("pentagrama escala Sol mayor --dedos guitarra"))
        #expect(salida("teclado Re mayor --dedos") == salida("teclado Re mayor --dedos piano"))
        #expect(salida("teclado Re mayor --dedos") == salida("teclado Re mayor --dedos derecha"))
        #expect(salida("teclado Re mayor --dedos izquierda") != salida("teclado Re mayor --dedos"))
        let escala = salida("escala Do mayor --dedos")
        #expect(escala.contains("Digitación de piano:"))
        #expect(salida("escala Do mayor --dedos piano") == escala)
        #expect(try json("escala Do mayor --dedos") as? [String: Any] != nil)
        for antes in [
            "pentagrama escala Do mayor --octava 3", "pentagrama escala Do mayor --octave 3",
            "pentagrama escala Do mayor --mano derecha", "pentagrama escala Sol mayor --tab --dedos",
            "pentagrama escala Sol mayor --dedos", "teclado Re mayor --mano derecha", "keyboard D major --hand left",
            "escala Do mayor --piano", "digitaciones Do --tab",
        ] {
            noSeLee(antes)
        }
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

    @Test func lasSubordenesDePlrYElCaminoParsimonioso() {
        #expect(salida("plr camino Do Mibm").hasSuffix("PRP, 3 pasos\n"))
        #expect(salida("plr shortest C Ebm --ingles").hasSuffix("PRP, 3 steps\n"))
        #expect(salida("plr ciclo hexatonico Do").hasSuffix("ciclo hexatónico, 6 tríadas\n"))
        #expect(salida("plr cycle LR cycle C --ingles").hasSuffix("LR cycle, 24 triads\n"))
        #expect(resultado("plr", "camino", "Do").codigo == 2)
        #expect(salida("camino-parsimonioso Sol7 Rem7").hasSuffix("3 pasos\n"))
        #expect(salida("smooth-path G7 Dm7") == salida("camino-parsimonioso Sol7 Rem7"))
        for antes in [
            "plr Do Mibm", "plr Do hexatonico", "plr ciclo Do hexatonico", "conduccion-parsimoniosa Sol7 Rem7",
        ] {
            let codigo = LineaDeComandos.ejecutar(antes.split(separator: " ").map(String.init)).codigo
            #expect(codigo != 0, Comment(rawValue: antes))
        }
    }

    @Test func laAyudaConLosNombresDeAhora() {
        let ayuda = salida("ayuda --todo")
        #expect(!ayuda.contains("--mano"))
        #expect(!ayuda.contains("--tonalidad Sol mayor"))
        #expect(ayuda.contains("teclado <escala> [--dedos]"))
        #expect(ayuda.contains("plr camino <tríada> <tríada>"))
        #expect(ayuda.contains("plr ciclo <ciclo> <tríada>"))
        #expect(ayuda.contains("camino-parsimonioso <acorde> <acorde>"))
        #expect(salida("ayuda --todo --ingles").contains("plr cycle <cycle> <triad>"))
    }
}
