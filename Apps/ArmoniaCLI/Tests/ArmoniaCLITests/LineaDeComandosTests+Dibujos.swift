import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de los dibujos: el Tonnetz y la tabla armónica.

extension LineaDeComandosTests {
    @Test func tonnetz() {
        for orden in [
            "tonnetz Do Mi Sol", "tonnetz --acorde Sol7", "tonnetz --escala Re dórico", "tonnetz --clases 0 4 7",
            "tonnetz --clases 0,3,6,9 --margen 2", "tonnetz C E G --ingles", "tonnetz --clases 047",
            "tonnetz --clases 3-11", "tonnetz --pcs C E G",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tonnetz --acorde Do").contains(">Mi</text>"))
        #expect(salida("tonnetz C E G --ingles").contains(">E</text>"))
        for orden in [
            "tonnetz", "tonnetz --clases", "tonnetz --acorde", "tonnetz --escala",
            "tonnetz --color Do", "tonnetz Do --margen 9",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tonnetz", "Do", "Hm"]).codigo == 1)
        // --clases lee como `armonia conjunto`: una cifra por clase, así que «0 12» es {0, 1, 2}.
        #expect(salida("tonnetz --clases 0 12") == salida("tonnetz --clases 0 1 2"))
        #expect(salida("tonnetz --clases 3-11") == salida("tonnetz --clases 0 3 7"))
        for orden in ["tonnetz --clases 0 x", "tonnetz --clases [0 4", "tonnetz --clases 3-13"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 1,
                Comment(rawValue: orden))
        }
        #expect(salida("tonnetz --recorrido Do Lam Fa Rem").contains("Do –R→ Lam –L→ Fa –R→ Rem"))
        #expect(salida("tonnetz --camino Do Mibm").contains("Do –P→ Dom –R→ Mi♭ –P→ Mi♭m"))
        for orden in [
            "tonnetz --recorrido", "tonnetz --recorrido Do Sol7", "tonnetz --camino Do", "tonnetz --camino Do Sol7",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func tablaArmonica() {
        for orden in [
            "tabla Do Mi Sol", "tabla Do3 Sol3 Mi4", "tabla --acorde Domaj7", "tabla --escala Re dórico",
            "tabla --clases 0,4,7 --margen 3", "tabla C E G --ingles",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tabla Do₃ Sol₃ Mi₄").contains(">Sol₃</text>"))
        #expect(salida("tabla --clases 13") == salida("tabla --clases 1 3"))
        for orden in ["tabla", "tabla --acorde", "tabla --clases", "tabla --foo", "tabla Do --margen 7"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tabla", "Do4", "Hm4"]).codigo == 1)
        #expect(salida("tabla --recorrido Do Lam Fa Rem").contains("<title>Do –R→ Lam –L→ Fa –R→ Rem</title>"))
        #expect(salida("tabla --camino Do Mibm").contains("<title>Do –P→ Dom –R→ Mi♭ –P→ Mi♭m</title>"))
        for orden in ["tabla --recorrido", "tabla --recorrido Do Sol7", "tabla --camino Do", "tabla --camino Do Sol7"] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func tecladoDePiano() {
        let notas = salida("teclado Do mayor")
        #expect(notas.hasPrefix("<svg") && notas.hasSuffix("</svg>\n"), Comment(rawValue: notas))
        #expect(notas.components(separatedBy: "<circle").count - 1 == 8)
        #expect(salida("teclado Do mayor --octavas 2").components(separatedBy: "<circle").count - 1 == 15)
        let derecha = salida("teclado Re mayor --mano derecha")
        #expect(derecha.contains("Re mayor · Mano derecha"), Comment(rawValue: derecha))
        #expect(salida("keyboard D major --hand left --ingles").contains("D major · Left hand"))
        #expect(LineaDeComandos.manoDePiano("Right") == .derecha)
        #expect(LineaDeComandos.manoDePiano("arriba") == nil)
        let sinMano = LineaDeComandos.ejecutar(["teclado", "Do", "mayor", "--mano", "arriba"])
        #expect(sinMano.codigo == 2)
    }

    @Test func cuadricula() {
        for orden in [
            "cuadricula Do Mi Sol", "cuadricula Do3 Mi3 Sol3", "cuadricula --acorde Sol7",
            "cuadricula --escala Re dórico", "cuadricula --clases 0 4 7", "cuadricula --recorrido Do Lam",
            "cuadricula --camino Do Mibm", "cuadricula --ciclo hexatonico Do", "cuadricula --ejes 2,5 --acorde Sol7",
            "grid --axes 7,4 --chord C --ingles",
            "cuadricula --rejilla 8x8 --origen Do2 --en-tono --escala Re dórico", "cuadricula --giro 1 --espejo Do",
            "cuadricula --rejilla 25×8 Do",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        // Por defecto, 12 × 7 en cuartas, con el contorno y la primera nota.
        let doMayor = salida("cuadricula --acorde Do")
        #expect(doMayor.contains(">Do₄<"))
        #expect(doMayor.contains(#"class="contorno""#))
        #expect(doMayor.contains(#"class="primera""#))
        #expect(doMayor.components(separatedBy: #"class="casilla""#).count - 1 == 84)
        // En un Launchpad, 64 casillas; en tono, solo las notas de la escala, desde la tónica.
        let pads = salida("cuadricula --rejilla 8x8 --en-tono --escala Re dórico")
        #expect(pads.components(separatedBy: #"class="casilla""#).count - 1 == 64)
        #expect(pads.contains(">Re₂<"))
        #expect(!pads.contains(">Do♯"))
        #expect(salida("cuadricula --origen Do3 Do").contains(">Do₃<"))
        #expect(salida("cuadricula --ejes 1,5 Do") == salida("cuadricula Do"))
        #expect(salida("cuadricula --giro 2 Do") == salida("cuadricula --ejes -1,-5 Do"))
        for orden in [
            "cuadricula", "cuadricula --ejes x Do", "cuadricula --ejes Do", "cuadricula --rejilla 99x1 Do",
            "cuadricula --rejilla ocho Do", "cuadricula --giro 4 Do", "cuadricula --origen", "cuadricula --foo",
            "cuadricula --camino Do Sol7",
        ] {
            #expect(
                LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["cuadricula", "--origen", "Hm", "Do"]).codigo == 1)
    }

    @Test func relojDeLaEscala() {
        let cromatico = salida("reloj Re mayor")
        #expect(cromatico.hasPrefix("<svg") && cromatico.hasSuffix("</svg>\n"), Comment(rawValue: cromatico))
        #expect(cromatico.contains("<title>Re mayor · Círculo cromático</title>"))
        #expect(cromatico.components(separatedBy: "<circle").count - 1 == 13)
        #expect(cromatico.contains("<polygon"))
        #expect(cromatico.contains(">Fa♯</text>"))
        let quintas = salida("reloj Do disminuida semitono-tono --quintas")
        #expect(quintas.contains("Círculo de quintas</title>"), Comment(rawValue: quintas))
        #expect(quintas != salida("reloj Do disminuida semitono-tono"))
        #expect(salida("clock C major --fifths --ingles").contains("<title>C major · Circle of fifths</title>"))
        #expect(salida("ayuda").contains("reloj <escala> [--quintas]"))
    }

    @Test func pentagrama() {
        func cuenta(_ trozo: String, _ texto: String) -> Int { texto.components(separatedBy: trozo).count - 1 }
        for orden in [
            "pentagrama escala Re dórico", "pentagrama acorde Sol7", "pentagrama arpegio Do7 --patron alberti",
            "pentagrama acordes Rem7 Sol7 Do7M", "staff scale D dorian --ingles", "staff chord G7 --ingles",
            "staff arpeggio C Am --figure 16 --ingles", "staff chords Dm7 G7 Cmaj7 --ingles",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        // Dos octavas: quince notas, tres tónicas en color y, en dórico, cuatro semitonos (Mi–Fa, Si–Do).
        let dorico = salida("pentagrama escala Re dórico --octavas 2 --tonica --semitonos --nombres")
        #expect(cuenta("<title>", dorico) == 15)
        #expect(cuenta("fill=\"#1971C2\"", dorico) == 3)
        #expect(dorico.contains(">Re₄</text>"))
        #expect(salida("pentagrama escala La menor melódica --bajando").contains("<title>Sol₅</title>"))
        // El cifrado y los intervalos del acorde.
        let sol9 = salida("pentagrama acorde Sol9 --intervalos")
        #expect(sol9.contains(">Sol9</text>") && sol9.contains(">1 3 5 ♭7 9</text>"))
        // Una progresión arpegiada con ritmo: el cifrado de cada acorde y la cifra del compás.
        let alberti = salida("pentagrama arpegio Do Lam Fa Sol7 --patron alberti")
        #expect(["Do", "Lam", "Fa", "Sol7"].allSatisfy { alberti.contains(">\($0)</text>") })
        #expect(salida("pentagrama arpegio Do7 --tresillos").contains("<svg"))
        // Con la armadura de Fa mayor, el Si♭ de Do7 no lleva bemol delante.
        #expect(salida("pentagrama arpegio Do7 --en Fa mayor") != salida("pentagrama arpegio Do7"))
        #expect(salida("pentagrama acordes Rem7 Sol7 Do7M").contains(">Rem7</text>"))
        #expect(salida("ayuda").contains("pentagrama escala|acorde|arpegio|acordes <…>"))
    }
}
