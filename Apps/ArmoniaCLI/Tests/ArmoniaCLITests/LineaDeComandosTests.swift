import Armonia
import Foundation
import XCTest

@testable import ArmoniaCLI

// Las pruebas de lo que comparten todas las órdenes: la ayuda, los nombres, los idiomas, las escrituras y los
// errores de uso. Las de cada grupo de órdenes están en `LineaDeComandosTests+Consultas.swift`, `+Trastes`…, como
// las fuentes.

final class LineaDeComandosTests: XCTestCase {
    /// La salida de una orden escrita como en la terminal: `"acorde Sol7"`.
    func salida(_ orden: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let resultado = LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        XCTAssertEqual(resultado.codigo, 0, resultado.error, file: file, line: line)
        XCTAssertEqual(resultado.error, "", file: file, line: line)
        return resultado.salida
    }

    /// Un fichero temporal con esos datos, que se borra al terminar la prueba.
    func fichero(_ datos: Data, extension sufijo: String) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(
            "armonia-\(UUID().uuidString).\(sufijo)")
        try datos.write(to: url)
        addTeardownBlock { try? FileManager.default.removeItem(at: url) }
        return url.path
    }

    /// El resultado de una orden con los argumentos tal cual (un valor puede llevar espacios).
    func resultado(_ argumentos: String...) -> ResultadoDeOrden {
        LineaDeComandos.ejecutar(argumentos)
    }

    func testAyuda() {
        for orden in ["", "ayuda", "--help", "help"] {
            XCTAssertTrue(salida(orden).hasPrefix("armonia: teoría musical"), orden)
        }
    }

    /// Los nombres de órdenes y opciones, en español y en inglés; los de antes ya no se aceptan.
    func testNombresDeOrdenesYOpciones() {
        let coral = "Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5"
        XCTAssertEqual(salida("revisar " + coral), salida("check " + coral))
        XCTAssertEqual(salida("conduccion-parsimoniosa Sol7 Rem7"), salida("smooth-path Sol7 Rem7"))
        for orden in ["tonnetz", "tabla"] {
            XCTAssertEqual(salida(orden + " --sequence Do Lam Fa Rem"), salida(orden + " --recorrido Do Lam Fa Rem"))
            XCTAssertNotEqual(LineaDeComandos.ejecutar([orden, "--path", "Do", "Lam"]).codigo, 0)
        }
        for antigua in ["voces", "voices", "camino", "path"] {
            XCTAssertNotEqual(LineaDeComandos.ejecutar([antigua, "Do", "Fa"]).codigo, 0, antigua)
        }
        let programa = LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--programa", "40"])
        XCTAssertEqual(programa.codigo, 0, programa.error)
        XCTAssertNotNil(programa.datos)
        XCTAssertEqual(programa.datos, LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--program", "40"]).datos)
        XCTAssertEqual(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--instrumento", "40"]).codigo, 2)
        XCTAssertEqual(LineaDeComandos.ejecutar(["musicxml", "melodia", "Do4:4", "--programa", "40"]).codigo, 2)
        XCTAssertEqual(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--programa", "200"]).codigo, 2)

        let ayuda = salida("ayuda")
        let help = salida("help --ingles")
        for nombre in ["revisar <acordes>", "conduccion-parsimoniosa <acorde>", "--programa 0…127"] {
            XCTAssertTrue(ayuda.contains(nombre), nombre)
        }
        for nombre in ["check <chords>", "smooth-path <chord>", "--sequence <triads>", "--program 0…127"] {
            XCTAssertTrue(help.contains(nombre), nombre)
        }
        for antiguo in ["voces <acordes>", "camino <acorde>", "--instrumento 0…127"] {
            XCTAssertFalse(ayuda.contains(antiguo), antiguo)
        }
    }

    func testOctavasEnSubindice() {
        // Con --subindices, la octava sale en subíndice; se lee igual con subíndices que con cifras.
        XCTAssertEqual(
            salida("transponer 2M Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4 --subindices"),
            "Re₃ Fa♯₄ La₄ Re₅ | La₂ Mi₄ La₄ Do♯₅\n")
        XCTAssertEqual(
            salida("transponer 2M Do₃ Mi₄ Sol₄ Do₅ | Sol₂ Re₄ Sol₄ Si₄"), "Re3 Fa♯4 La4 Re5 | La2 Mi4 La4 Do♯5\n")
        XCTAssertEqual(salida("intervalo Do₄ Mi₅"), salida("intervalo Do4 Mi5"))
        XCTAssertTrue(salida("ayuda").contains("--subindices"))
        XCTAssertTrue(salida("help --english").contains("--subscripts"))
    }

    func testIngles() {
        XCTAssertTrue(
            salida("acorde G7/B --ingles").hasPrefix(
                "G7/B: dominant seventh\n  notes: G B D F  (bass B, first inversion)"))
        XCTAssertTrue(
            salida("analizar C Am D7 G7 C --ingles").hasPrefix("I–vi–V7/V–V7–I in C major\n  C         I         tonic")
        )
        XCTAssertEqual(salida("revisar C3 E4 G4 C5, G2 D4 G4 B4 --ingles"), "No voice-leading errors.\n")
        XCTAssertTrue(salida("tonalidad D major --ingles").contains("key signature: F# C# (2 sharps)"))
    }

    func testLaTablaDeOrdenes() {
        // Cada nombre lleva a una sola orden, en minúsculas, y cada orden tiene su ayuda.
        let nombres = LineaDeComandos.ordenes.flatMap(\.nombres)
        XCTAssertEqual(Set(nombres).count, nombres.count)
        for nombre in nombres { XCTAssertEqual(nombre, nombre.lowercased(), nombre) }
        for orden in LineaDeComandos.ordenes { XCTAssertFalse(orden.ayuda.isEmpty, orden.nombres[0]) }
        XCTAssertEqual(LineaDeComandos.ordenesDeLaAyuda.count, 36)
        // Los nombres no distinguen mayúsculas.
        XCTAssertEqual(salida("ACORDE Do"), salida("acorde Do"))
    }

    /// Órdenes que terminan en un error de uso.
    private static let ordenesMalEscritas = [
        "foo", "acorde", "identificar", "intervalo C", "escala", "tonalidad", "analizar", "analizar C --en",
        "armonizar", "armonizar C --en", "armonizar C --propuestas 0", "realizar", "realizar C --en",
        "revisar", "conduccion-minima G7", "digitaciones", "digitaciones C --instrumento arpa",
        "digitaciones C --limite 0",
        "digitaciones C --dedos 9", "digitaciones C --traste 99", "digitaciones C --capo", "vecinos",
        "vecinos C7 --voces 3", "conduccion-parsimoniosa G7", "plr", "plr G7 P", "musicxml", "musicxml coral",
        "musicxml melodia C4:4 --foo 1", "midi acordes C --cifrados", "tonnetz", "tonnetz --clases 13",
        "tonnetz --camino C", "tabla --ciclo C", "tabla --margen 9 C", "contrapunto", "contrapunto D4 A4",
        "contrapunto D4 / A4 --especie 6", "contrapunto D4 / ", "acorde Do --escritura foo",
        "arpegio", "arpegio Do --patron zigzag", "arpegio Do --patron", "arpegio Do --octavas 2",
        "posiciones", "posiciones Do mayor --foo", "musicxml acordes C --ventana 1",
        "musicxml melodia C4:4 --archivo coral.mid", "transponer", "transponer 2M", "rearmonizar",
        "digitaciones C --capo 13",
    ]

    /// Con --ingles no se cuela nada en español: ni en la salida, ni en los errores, ni en la ayuda.
    func testConInglesNadaEnEspanol() {
        let enEspanol = [
            "«", "»", "á", "é", "í", "ó", "ú", "ñ", "notas", "acordes", "paso", "dedo", "cejilla",
            "guitarra", "tríada", "Prueba", "falta",
        ]
        func comprobar(_ texto: String, _ orden: String, file: StaticString = #filePath, line: UInt = #line) {
            for palabra in enEspanol where texto.contains(palabra) {
                XCTFail("«\(palabra)» en la salida de «\(orden)»:\n\(texto)", file: file, line: line)
            }
        }
        for orden in [
            "help", "acorde C/E", "acorde G7/B", "identificar C E Bb", "intervalo C4 E5", "escala Re dórico",
            "tonalidad Re mayor", "tonalidad Mib mayor", "tonalidad Do mayor", "analizar C Am D7 G7 C",
            "analizar C F G7 C Am D7 G", "armonizar E4 F4 D4 C4", "armonizar C6 B5 C6", "realizar C F G7 C",
            "realizar C7(9,13)",
            "revisar C3 E4 G4 C5, G2 D4 G4 B4", "plr C PLR", "plr C C", "plr C hexatonico",
            "conduccion-parsimoniosa G7 Dm7", "vecinos G7", "digitaciones F --diagrama",
            "digitaciones C --instrumento ukelele",
            "digitaciones C --instrumento bajo --dedos 1 --traste 0", "counterpoint C4 D4 E4 C4 / G4 A4 G4 C5",
            "arpeggio C7", "arpeggio C --pattern alberti", "transpose M2 C Am F G7", "reharmonize C Am Dm7 G7 C",
            "digitaciones C --capo 2",
        ] {
            let resultado = LineaDeComandos.ejecutar((orden + " --ingles").split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 0, "\(orden): \(resultado.error)")
            comprobar(resultado.salida, orden)
        }
        for orden in Self.ordenesMalEscritas {
            let resultado = LineaDeComandos.ejecutar((orden + " --ingles").split(separator: " ").map(String.init))
            XCTAssertEqual(resultado.codigo, 2, orden)
            XCTAssertTrue(resultado.error.hasSuffix("Try \"armonia help\".\n"), "\(orden): \(resultado.error)")
            comprobar(resultado.error, orden)
        }
    }

    func testAyudaEnIngles() {
        for orden in ["--ingles", "ayuda --ingles", "help --english"] {
            XCTAssertTrue(salida(orden).hasPrefix("armonia: music theory"), orden)
        }
        XCTAssertTrue(salida("help --ingles").contains("fingerings <symbol>"))
        XCTAssertTrue(LineaDeComandos.ayuda(en: .espanolUnicode).hasPrefix("armonia: teoría musical"))
    }

    func testIdiomas() {
        XCTAssertEqual(
            salida("acorde Sol7/Si --idioma eu"),
            """
            Sol7/Si: dominanteko zazpigarrena
              notak: sol si re fa  (baxua si, lehen inbertsioa)
              sol oinarria · si hirugarrena · re bosgarrena · fa zazpigarrena

            """)
        XCTAssertTrue(salida("acorde Sol7/Si --idioma ca").contains("notes: sol si re fa  (baix si, primera inversió)"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma galego").contains("sol fundamental · si terceira"))
        XCTAssertTrue(salida("tonalidad Mib mayor --idioma gl").contains("(3 bemois)"))
        XCTAssertEqual(salida("--idioma en acorde C/G"), salida("acorde C/G --ingles"))
        XCTAssertEqual(salida("acorde Do --language es"), salida("acorde Do"))
        // La ayuda, en los catorce idiomas.
        XCTAssertTrue(salida("ayuda --idioma ca").hasPrefix("armonia: "))
        XCTAssertEqual(salida("ayuda --idioma ca"), LineaDeComandos.ajuda + "\n")
        XCTAssertEqual(salida("ayuda --idioma gl"), LineaDeComandos.axuda + "\n")
        XCTAssertEqual(salida("ayuda --idioma eu"), LineaDeComandos.laguntza + "\n")
        XCTAssertEqual(salida("ayuda --idioma pt"), LineaDeComandos.ajudaEmPortugues + "\n")
        XCTAssertEqual(salida("ayuda --idioma fr"), LineaDeComandos.aide + "\n")
        XCTAssertEqual(salida("ayuda --idioma italiano"), LineaDeComandos.aiuto + "\n")
        XCTAssertEqual(salida("ayuda --idioma de"), LineaDeComandos.hilfe + "\n")
        XCTAssertEqual(salida("ayuda --idioma oc"), LineaDeComandos.ajudaEnOccitan + "\n")
        XCTAssertEqual(salida("ayuda --idioma ru"), LineaDeComandos.spravka + "\n")
        XCTAssertEqual(salida("ayuda --idioma el"), LineaDeComandos.voitheia + "\n")
        XCTAssertEqual(salida("ayuda --idioma an"), LineaDeComandos.aduya + "\n")
        XCTAssertEqual(salida("ayuda --idioma asturianu"), LineaDeComandos.ayudaEnAsturianu + "\n")
        XCTAssertTrue(LineaDeComandos.ayudaEnAsturianu.hasPrefix("armonia: teoría musical dende la llinia"))
        XCTAssertTrue(LineaDeComandos.hilfe.hasPrefix("armonia: Musiktheorie"))
        XCTAssertTrue(LineaDeComandos.spravka.contains("armonia chord G7/B"))
        XCTAssertTrue(LineaDeComandos.ajudaEnOccitan.contains("armonia acorde Sol7/Si"))
        typealias L = LineaDeComandos
        let ayudas: [String] = [
            L.ayuda, L.help, L.ajuda, L.axuda, L.laguntza, L.ajudaEmPortugues, L.aide, L.aiuto,
            L.hilfe, L.ajudaEnOccitan, L.spravka, L.voitheia, L.aduya, L.ayudaEnAsturianu,
        ]
        // Una por idioma, y las constantes con nombre son las del mapa.
        XCTAssertEqual(Set(ayudas).count, LineaDeComandos.ayudas.count)
        XCTAssertEqual(Set(ayudas), Set(LineaDeComandos.ayudas.values))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma fr").hasPrefix("Sol7/Si: septième de dominante\n"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma it").contains("(basso si, primo rivolto)"))
        XCTAssertTrue(salida("tonalidad Mib mayor --idioma pt").contains("(3 bemóis)"))
        XCTAssertTrue(salida("escala Re dórico --idioma fr").hasPrefix("ré dorien"))
        XCTAssertTrue(salida("help --idioma en").hasPrefix("armonia: music theory"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma ca").hasPrefix("Sol7/Si: sèptima de dominant\n"))
        XCTAssertTrue(salida("escala Re dórico --idioma eu").hasPrefix("re doriarra"))
        // Los errores de lectura los traduce el motor.
        XCTAssertTrue(resultado("acorde", "Do7(b3)", "--idioma", "eu").error.hasPrefix("Ezin da «Do7(b3)» irakurri"))
        XCTAssertEqual(
            resultado("digitaciones", "C", "--limite", "0", "--idioma", "eu").error,
            "armonia: muga 1etik 200era bitarteko zenbaki bat da: --limite 5\nProbatu «armonia ayuda».\n")
        XCTAssertEqual(resultado("acorde", "Do", "--idioma", "xx").codigo, 2)
        XCTAssertTrue(
            resultado("acorde", "Do", "--idioma", "xx").error
                .hasPrefix(
                    "armonia: idioma desconocido: «xx» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el o ru)"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma de").hasPrefix("G7/H: Dominantseptakkord\n"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma ru").hasPrefix("Соль7/Си: доминантсептаккорд\n"))
        XCTAssertTrue(salida("escala Re dórico --idioma el").hasPrefix("ρε δώριος"))
        XCTAssertTrue(salida("escala Re dórico --idioma ast").hasPrefix("re dóricu"))
        XCTAssertTrue(salida("acorde Sol7/Si --idioma an").contains("(baixo si, primera inversión)"))
        XCTAssertTrue(salida("digitaciones C --instrumento baxu --idioma ast").contains("baxu"))
        XCTAssertEqual(
            resultado("acorde", "Do", "--idioma").error,
            "armonia: falta el valor de --idioma\nPrueba «armonia ayuda».\n")
        // Notas y textos por separado.
        XCTAssertTrue(salida("acorde Sol7/Si --idioma en --textos es").hasPrefix("G7/B: séptima de dominante\n"))
        XCTAssertTrue(salida("acorde Sol7/Si --textos fr").hasPrefix("Sol7/Si: septième de dominante\n"))
        XCTAssertTrue(salida("ayuda --idioma fr --textos es").contains("--textos"))
        XCTAssertEqual(resultado("acorde", "Do", "--textos", "xx").codigo, 2)
        XCTAssertEqual(resultado("acorde", "Do", "--textos").codigo, 2)
    }

    /// --escritura elige, en español e inglés, entre palabras, # y b o ♯ y ♭.
    func testEscritura() {
        XCTAssertTrue(salida("acorde Sib7").hasPrefix("Si♭7: séptima de dominante\n  notas: Si♭ Re Fa La♭"))
        XCTAssertTrue(
            salida("acorde Sib7 --escritura palabras")
                .hasPrefix("Si♭7: séptima de dominante\n  notas: Si bemol Re Fa La bemol"))
        XCTAssertTrue(
            salida("acorde Sib7 --escritura ascii").hasPrefix("Sib7: séptima de dominante\n  notas: Sib Re Fa Lab"))
        XCTAssertTrue(
            salida("acorde Bb7 --ingles --writing words").hasPrefix("B♭7: dominant seventh\n  notes: B flat D F A flat")
        )
        XCTAssertTrue(
            salida("acorde Bb7 --ingles --escritura unicode").hasPrefix("B♭7: dominant seventh\n  notes: B♭ D F A♭"))
        XCTAssertEqual(salida("acorde Bb7 --ingles --escritura ASCII"), salida("acorde Bb7 --ingles"))
        XCTAssertTrue(
            salida("acorde Sib7 --idioma en --escritura palabras --textos es")
                .hasPrefix("B♭7: séptima de dominante\n  notas: B flat D F A flat"))
        XCTAssertTrue(
            resultado("acorde", "Do", "--escritura", "foo").error
                .hasPrefix("armonia: escritura no válida: «foo» (palabras, ascii o unicode; solo con es y en)"))
        XCTAssertEqual(resultado("acorde", "Do", "--idioma", "ca", "--escritura", "palabras").codigo, 2)
        XCTAssertEqual(resultado("acorde", "Do", "--escritura").codigo, 2)
        XCTAssertTrue(salida("ayuda").contains("--escritura"))
        XCTAssertTrue(salida("help --ingles").contains("--writing"))
    }

    /// Con --idioma ca, gl, eu, pt, fr, it, de, el o ru, los errores de uso no dejan nada en español (el
    /// occitano no entra: también dice «las» y «los»).
    func testErroresEnCatalanGallegoEuskera() {
        let enEspanol = ["Prueba", "hace falta", "hacen falta", "desconocid", " es un", " sin ", " las ", " los "]
        for (idioma, ayuda) in [
            ("ca", "Prova «armonia ayuda».\n"), ("gl", "Proba «armonia ayuda».\n"),
            ("eu", "Probatu «armonia ayuda».\n"), ("pt", "Experimente «armonia ayuda».\n"),
            ("fr", "Essayez « armonia ayuda ».\n"), ("it", "Prova «armonia ayuda».\n"),
            ("de", "Versuche „armonia help“.\n"), ("ru", "Попробуй «armonia help».\n"),
            ("el", "Δοκίμασε «armonia help».\n"),
        ] {
            for orden in Self.ordenesMalEscritas {
                let resultado = LineaDeComandos.ejecutar(
                    (orden + " --idioma " + idioma).split(separator: " ").map(String.init))
                XCTAssertEqual(resultado.codigo, 2, "\(orden) \(idioma)")
                XCTAssertTrue(resultado.error.hasSuffix(ayuda), "\(orden) \(idioma): \(resultado.error)")
                for palabra in enEspanol where resultado.error.contains(palabra) {
                    XCTFail("«\(palabra)» en «\(orden) --idioma \(idioma)»: \(resultado.error)")
                }
            }
        }
    }

    func testErroresEnIngles() {
        let error = resultado("digitaciones", "C", "--limite", "0", "--ingles").error
        XCTAssertEqual(error, "armonia: the limit is a number from 1 to 200: --limit 5\nTry \"armonia help\".\n")
        XCTAssertEqual(
            resultado("digitaciones", "C", "--limite", "0").error,
            "armonia: el límite es un número de 1 a 200: --limite 5\nPrueba «armonia ayuda».\n")
        XCTAssertTrue(salida("digitaciones C --limite 1 --ingles").hasPrefix("C · guitar\n"))
        XCTAssertTrue(salida("tonalidad F major --ingles").contains("(1 flat)"))
        XCTAssertTrue(salida("tonalidad Fa mayor").contains("(1 bemol)"))
        XCTAssertTrue(salida("tonalidad Mib mayor").contains("(3 bemoles)"))
    }

    func testErrores() {
        let lectura = LineaDeComandos.ejecutar(["acorde", "Hm"])
        XCTAssertEqual(lectura.codigo, 1)
        XCTAssertEqual(lectura.salida, "")
        XCTAssertTrue(lectura.error.hasPrefix("No se puede leer «Hm»"))
        XCTAssertTrue(LineaDeComandos.ejecutar(["acorde", "Hm", "--ingles"]).error.hasPrefix("Cannot read"))

        for orden in [
            ["foo"], ["intervalo", "Do"], ["acorde"], ["analizar"], ["analizar", "Do", "--en"], ["revisar"],
        ] {
            let resultado = LineaDeComandos.ejecutar(orden)
            XCTAssertEqual(resultado.codigo, 2, "\(orden)")
            XCTAssertTrue(resultado.error.hasSuffix("Prueba «armonia ayuda».\n"), "\(orden)")
        }
        XCTAssertEqual(LineaDeComandos.ejecutar(["revisar", "Do3", "Mi4,", "Sol2"]).codigo, 1)
    }
}
