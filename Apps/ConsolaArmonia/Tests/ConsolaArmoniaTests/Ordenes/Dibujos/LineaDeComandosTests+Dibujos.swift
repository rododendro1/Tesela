import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de los dibujos: el Tonnetz y la tabla armónica.

extension LineaDeComandosTests {
    @Test func tonnetz() {
        for orden in [
            "tonnetz Do Mi Sol", "tonnetz acorde Sol7", "tonnetz escala Re dórico", "tonnetz clases 0 4 7",
            "tonnetz clases 0,3,6,9 --margen 2", "tonnetz C E G --ingles", "tonnetz clases 047",
            "tonnetz clases 3-11", "tonnetz pcs C E G",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tonnetz acorde Do").contains(">Mi</text>"))
        #expect(salida("tonnetz C E G --ingles").contains(">E</text>"))
        for orden in [
            "tonnetz", "tonnetz clases", "tonnetz acorde", "tonnetz escala",
            "tonnetz --color Do", "tonnetz Do --margen 9",
        ] {
            #expect(
                resultado(orden).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tonnetz", "Do", "Hm"]).codigo == 1)
        // --clases lee como `armonia conjunto`: una cifra por clase, así que «0 12» es {0, 1, 2}.
        #expect(salida("tonnetz clases 0 12") == salida("tonnetz clases 0 1 2"))
        #expect(salida("tonnetz clases 3-11") == salida("tonnetz clases 0 3 7"))
        for orden in ["tonnetz clases 0 x", "tonnetz clases [0 4", "tonnetz clases 3-13"] {
            #expect(
                resultado(orden).codigo == 1,
                Comment(rawValue: orden))
        }
        #expect(salida("tonnetz recorrido Do Lam Fa Rem").contains("Do –R→ Lam –L→ Fa –R→ Rem"))
        #expect(salida("tonnetz camino Do Mibm").contains("Do –P→ Dom –R→ Mi♭ –P→ Mi♭m"))
        for orden in [
            "tonnetz recorrido", "tonnetz recorrido Do Sol7", "tonnetz camino Do", "tonnetz camino Do Sol7",
        ] {
            #expect(
                resultado(orden).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func tablaArmonica() {
        for orden in [
            "tabla Do Mi Sol", "tabla Do3 Sol3 Mi4", "tabla acorde Domaj7", "tabla escala Re dórico",
            "tabla clases 0,4,7 --margen 3", "tabla C E G --ingles",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        #expect(salida("tabla Do₃ Sol₃ Mi₄").contains(">Sol₃</text>"))
        #expect(salida("tabla clases 13") == salida("tabla clases 1 3"))
        for orden in ["tabla", "tabla acorde", "tabla clases", "tabla --foo", "tabla Do --margen 7"] {
            #expect(
                resultado(orden).codigo == 2,
                Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.ejecutar(["tabla", "Do4", "Hm4"]).codigo == 1)
        #expect(salida("tabla recorrido Do Lam Fa Rem").contains("<title>Do –R→ Lam –L→ Fa –R→ Rem</title>"))
        #expect(salida("tabla camino Do Mibm").contains("<title>Do –P→ Dom –R→ Mi♭ –P→ Mi♭m</title>"))
        for orden in ["tabla recorrido", "tabla recorrido Do Sol7", "tabla camino Do", "tabla camino Do Sol7"] {
            #expect(
                resultado(orden).codigo == 2,
                Comment(rawValue: orden))
        }
    }

    @Test func tecladoDePiano() {
        let notas = salida("teclado Do mayor")
        #expect(notas.hasPrefix("<svg") && notas.hasSuffix("</svg>\n"), Comment(rawValue: notas))
        #expect(notas.components(separatedBy: "<circle").count - 1 == 8)
        #expect(salida("teclado Do mayor --octavas 2").components(separatedBy: "<circle").count - 1 == 15)
        let derecha = salida("teclado Re mayor --dedos derecha")
        #expect(derecha.contains("Re mayor · Mano derecha"), Comment(rawValue: derecha))
        #expect(salida("keyboard D major --fingers left --ingles").contains("D major · Left hand"))
        #expect(LineaDeComandos.manoDePiano("Right") == .derecha)
        #expect(LineaDeComandos.manoDePiano("arriba") == nil)
        let sinMano = LineaDeComandos.ejecutar(["teclado", "Do", "mayor", "--mano", "arriba"])
        #expect(sinMano.codigo == 2)
    }

    @Test func cuadricula() {
        for orden in [
            "cuadricula Do Mi Sol", "cuadricula Do3 Mi3 Sol3", "cuadricula acorde Sol7",
            "cuadricula escala Re dórico", "cuadricula clases 0 4 7", "cuadricula recorrido Do Lam",
            "cuadricula camino Do Mibm", "cuadricula ciclo hexatonico Do", "cuadricula acorde Sol7 --ejes 2,5",
            "grid chord C --axes 7,4 --ingles",
            "cuadricula escala Re dórico --rejilla 8x8 --origen Do2 --en-tono", "cuadricula --giro 1 --espejo Do",
            "cuadricula --rejilla 25×8 Do",
        ] {
            let svg = salida(orden)
            #expect(svg.hasPrefix("<svg") && svg.hasSuffix("</svg>\n"), Comment(rawValue: orden))
        }
        // Por defecto, 12 × 7 en cuartas, con el contorno y la primera nota.
        let doMayor = salida("cuadricula acorde Do")
        #expect(doMayor.contains(">Do₄<"))
        #expect(doMayor.contains(#"class="contorno""#))
        #expect(doMayor.contains(#"class="primera""#))
        #expect(doMayor.components(separatedBy: #"class="casilla""#).count - 1 == 84)
        // En un Launchpad, 64 casillas; en tono, solo las notas de la escala, desde la tónica.
        let pads = salida("cuadricula escala Re dórico --rejilla 8x8 --en-tono")
        #expect(pads.components(separatedBy: #"class="casilla""#).count - 1 == 64)
        #expect(pads.contains(">Re₂<"))
        #expect(!pads.contains(">Do♯"))
        #expect(salida("cuadricula --origen Do3 Do").contains(">Do₃<"))
        #expect(salida("cuadricula --ejes 1,5 Do") == salida("cuadricula Do"))
        #expect(salida("cuadricula --giro 2 Do") == salida("cuadricula --ejes -1,-5 Do"))
        for orden in [
            "cuadricula", "cuadricula --ejes x Do", "cuadricula --ejes Do", "cuadricula --rejilla 99x1 Do",
            "cuadricula --rejilla ocho Do", "cuadricula --giro 4 Do", "cuadricula --origen", "cuadricula --foo",
            "cuadricula camino Do Sol7",
        ] {
            #expect(
                resultado(orden).codigo == 2,
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
        #expect(salida("ayuda --todo").contains("reloj <escala> [--quintas | --microtonal [--fuente <teórico>]]"))
    }

    @Test func relojDeLaAfinacionPropia() {
        let bayati = salida("reloj Re bayati --microtonal")
        #expect(
            bayati.hasPrefix("<svg") && bayati.contains("· Círculo de su afinación</title>"), Comment(rawValue: bayati))
        #expect(bayati.contains(">Mi𝄳</text>") && bayati.components(separatedBy: "<line").count == 25)
        // Con --fuente, otra de sus afinaciones; --fuente sola ya pide el microtonal.
        let chrysanthos = salida("reloj Re echos protos --microtonal --fuente chrysanthos")
        #expect(chrysanthos.contains(">Mi(−29¢)</text>"), Comment(rawValue: chrysanthos))
        #expect(salida("reloj Re echos protos --fuente chrysanthos") == chrysanthos)
        #expect(salida("clock D bayati --microtonal --ingles").contains("Circle of its tuning</title>"))
        // Sin microtonos, o sin la afinación de ese teórico, es un error de uso.
        let mayor = LineaDeComandos.ejecutar(["reloj", "Re", "mayor", "--microtonal"])
        #expect(
            mayor.codigo == 2 && mayor.error.contains("no tiene afinación propia"), Comment(rawValue: mayor.error))
        let ptolomeo = LineaDeComandos.ejecutar(["reloj", "Re", "bayati", "--fuente", "ptolomeo"])
        #expect(ptolomeo.codigo == 2 && ptolomeo.error.contains("(Ptolomeo)"), Comment(rawValue: ptolomeo.error))
        #expect(LineaDeComandos.ejecutar(["reloj", "Re", "bayati", "--fuente", "nadie"]).codigo == 2)
        // --colores, cada grado del color de sus cents: el Re (200 cents), naranja.
        let colores = salida("reloj Re bayati --colores")
        #expect(colores.contains("<line") && !colores.contains("fill=\"#1f4e9c\" stroke=\"#f39c12"))
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
        #expect(salida("ayuda --todo").contains("pentagrama escala|acorde|arpegio|acordes <…>"))
        #expect(salida("ayuda --todo").contains("pentagrama <qué> --romanos|--dedos|--secuencia|--tab"))
    }

    @Test func pentagramaParaEstudiar() {
        func cuenta(_ trozo: String, _ texto: String) -> Int { texto.components(separatedBy: trozo).count - 1 }
        // Los grados en números romanos, en la tonalidad que mejor explica los acordes o en la de --en.
        let romanos = salida("pentagrama acordes Rem7 Sol7 Do7M --romanos")
        #expect(["ii7", "V7", "Imaj7"].allSatisfy { romanos.contains(">\($0)</text>") }, Comment(rawValue: romanos))
        #expect(salida("pentagrama acordes Do Sol --romanos --en Sol mayor").contains(">IV</text>"))
        let alberti = salida("pentagrama arpegio Do Lam Fa Sol7 --patron alberti --romanos")
        #expect(["I", "vi", "IV", "V7"].allSatisfy { alberti.contains(">\($0)</text>") })
        // Los dedos del piano: Re mayor con la derecha, 1 2 3 1 2 3 4 5.
        let piano = salida("pentagrama escala Re mayor --dedos piano")
        #expect(cuenta(">1</text>", piano) == 2 && cuenta(">5</text>", piano) == 1)
        // Por terceras, en corcheas con su compás; en grupos de tres, en tresillos.
        #expect(salida("pentagrama escala Do mayor --secuencia terceras").contains("Do mayor · por terceras</title>"))
        #expect(salida("staff scale C major --sequence groups-of-3 --ingles").contains("<svg"))
        // En la guitarra: la tablatura, con los trastes y los dedos; el arpegio de Do7, con su Si♭.
        let sol = salida("pentagrama escala Sol mayor --dedos guitarra")
        #expect(sol.contains(">T</text>") && sol.contains(">3</text>"), Comment(rawValue: sol))
        let do7 = salida("pentagrama arpegio Do7 --tab --figura 8")
        #expect(do7.contains("Si♭") && !do7.contains("La♯"), Comment(rawValue: do7))
        let ukelele = salida("pentagrama escala Do mayor --tab --instrumento ukelele --secuencia terceras")
        #expect(ukelele.contains(">A</text>"))
        #expect(salida("staff arpeggio G7 --fingers guitar --ingles").contains(">G7</text>"))
    }

    @Test func pentagramaDeArmonia() {
        func cuenta(_ trozo: String, _ texto: String) -> Int { texto.components(separatedBy: trozo).count - 1 }
        // El bajo cifrado: Fa/La, 6; Sol7/Si, 6 y 5.
        let bajo = salida("pentagrama acordes Do Fa/La Sol7/Si Do --bajo-cifrado")
        #expect(cuenta(">6</text>", bajo) == 2 && cuenta(">5</text>", bajo) == 1, Comment(rawValue: bajo))
        #expect(salida("pentagrama acordes Lam Mi Lam --bajo-cifrado --en La menor").contains(">♯</text>"))
        #expect(salida("pentagrama arpegio Do Sol7/Si --bajo-cifrado").contains(">5</text>"))
        // La octava, la clave, el pentagrama doble y los cambios de clave.
        #expect(salida("pentagrama escala Do mayor --registro 2").contains("<title>Do₂</title>"))
        #expect(salida("pentagrama acorde Do --registro 3").contains("<title>Do₃</title>"))
        let conClave = salida("pentagrama escala Mi mayor --registro 2 --clave sol")
        #expect(conClave != salida("pentagrama escala Mi mayor --registro 2"))
        // El pentagrama doble deja sitio a la izquierda para la llave.
        #expect(salida("pentagrama escala Do mayor --doble").contains("viewBox=\"-1.9 "))
        let cambios = salida("pentagrama escala Do mayor --registro 2 --octavas 3 --cambiar-clave")
        #expect(cambios.contains("scale(0.75)"), Comment(rawValue: cambios))
        #expect(salida("staff scale C major --register 2 --octaves 3 --clef-changes --ingles").contains("scale(0.75)"))
        // Una melodía sobre unos acordes: el Re (de paso) en verde; el Re♯ (cromático en Do mayor), en rojo.
        let melodia = salida("pentagrama melodia Mi4:8 Re4:8 Do4:8 Re♯4:8 Mi4:2 Sol4:1 --sobre Do Sol7 --en Do mayor")
        #expect(cuenta("#2F9E44", melodia) == 1 && cuenta("#C2255C", melodia) == 1, Comment(rawValue: melodia))
        #expect(melodia.contains(">Do</text>") && melodia.contains(">Sol7</text>"))
        #expect(salida("staff melody E4:8 D4:8 C4:2. --over C --ingles").contains("#2F9E44"))
        #expect(salida("pentagrama arpegio Do --tensiones 9 --ajenas").contains("#2F9E44"))
    }

    @Test func pentagramaDeUnBajoCaminante() {
        // En clave de fa, con el cifrado de cada compás; con --tab, con la tablatura del bajo.
        let bajo = salida("pentagrama bajo Rem7 Sol7 Do7M")
        #expect(bajo.hasPrefix("<svg"), Comment(rawValue: String(bajo.prefix(300))))
        #expect(bajo.contains(">Rem7</text>") && bajo.contains(">Sol7</text>"))
        #expect(!bajo.contains(">T</text>"))
        let conTab = salida("pentagrama bajo Rem7 Sol7 Do7M --tab")
        #expect(conTab.contains(">T</text>"), Comment(rawValue: conTab))
        #expect(salida("staff bass Dm7 G7 Cmaj7 --tab --ingles").contains(">Dm7</text>"))
    }
}
