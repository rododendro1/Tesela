import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de lo que comparten todas las órdenes: la ayuda, los nombres, los idiomas, las escrituras y los
// errores de uso. Las de cada grupo de órdenes están en `LineaDeComandosTests+Consultas.swift`, `+Trastes`…, como
// las fuentes.

@Suite final class LineaDeComandosTests {
    /// Los ficheros temporales de la prueba, que se borran al terminar (cada prueba usa una instancia nueva).
    private var temporales: [URL] = []

    deinit {
        for url in temporales { try? FileManager.default.removeItem(at: url) }
    }

    /// Lo que da una orden escrita como en la terminal, con las palabras separadas por espacios: `"acorde Sol7"`.
    func resultado(_ orden: String) -> ResultadoDeOrden {
        LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
    }

    /// La salida de una orden escrita como en la terminal: `"acorde Sol7"`.
    func salida(_ orden: String, sourceLocation: SourceLocation = #_sourceLocation) -> String {
        let resultado = self.resultado(orden)
        #expect(resultado.codigo == 0, Comment(rawValue: resultado.error), sourceLocation: sourceLocation)
        #expect(resultado.error == "", sourceLocation: sourceLocation)
        return resultado.salida
    }

    /// La salida de una orden que comprueba algo (`revisar`, `contrapunto`) y encuentra faltas: sale con código 3.
    func conFaltas(_ orden: String, sourceLocation: SourceLocation = #_sourceLocation) -> String {
        let resultado = self.resultado(orden)
        #expect(resultado.codigo == 3, Comment(rawValue: resultado.error), sourceLocation: sourceLocation)
        #expect(resultado.error == "", sourceLocation: sourceLocation)
        return resultado.salida
    }

    /// Un fichero temporal con esos datos, que se borra al terminar la prueba.
    func fichero(_ datos: Data, extension sufijo: String) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(
            "armonia-\(UUID().uuidString).\(sufijo)")
        try datos.write(to: url)
        temporales.append(url)
        return url.path
    }

    /// La ayuda en un idioma, como la da `armonia ayuda --idioma …`.
    func ayudaEn(_ idioma: Idioma) -> String {
        LineaDeComandos.ayuda(en: .delIdioma(idioma))
    }

    /// El resultado de una orden con los argumentos tal cual (un valor puede llevar espacios).
    func resultado(_ argumentos: String...) -> ResultadoDeOrden {
        LineaDeComandos.ejecutar(argumentos)
    }

    @Test func ayuda() {
        for orden in ["", "ayuda", "--help", "help"] {
            #expect(salida(orden).hasPrefix("armonia: teoría musical"), Comment(rawValue: orden))
        }
    }

    /// Los nombres de órdenes y opciones, en español y en inglés; los de antes ya no se aceptan.
    @Test func nombresDeOrdenesYOpciones() {
        let coral = "Do3 Sol3 Mi4 Do5, Re3 La3 Fa4 Re5"
        #expect(conFaltas("revisar " + coral) == conFaltas("check " + coral))
        #expect(salida("camino-parsimonioso Sol7 Rem7") == salida("smooth-path Sol7 Rem7"))
        for orden in ["tonnetz", "tabla"] {
            #expect(salida(orden + " sequence Do Lam Fa Rem") == salida(orden + " recorrido Do Lam Fa Rem"))
            #expect(LineaDeComandos.ejecutar([orden, "--path", "Do", "Lam"]).codigo != 0)
        }
        for antigua in ["voces", "voices", "camino", "path"] {
            #expect(LineaDeComandos.ejecutar([antigua, "Do", "Fa"]).codigo != 0, Comment(rawValue: antigua))
        }
        let programa = LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--programa", "40"])
        #expect(programa.codigo == 0, Comment(rawValue: programa.error))
        #expect(programa.datos != nil)
        #expect(programa.datos == LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--program", "40"]).datos)
        #expect(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--instrumento", "40"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["musicxml", "melodia", "Do4:4", "--programa", "40"]).codigo == 2)
        #expect(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4", "--programa", "200"]).codigo == 2)

        let ayuda = salida("ayuda --todo")
        let help = salida("help --all --ingles")
        for nombre in ["revisar <acordes>", "camino-parsimonioso <acorde>", "--programa 0…127"] {
            #expect(ayuda.contains(nombre), Comment(rawValue: nombre))
        }
        for nombre in ["check <chords>", "smooth-path <chord>", "sequence <triads>", "--program 0…127"] {
            #expect(help.contains(nombre), Comment(rawValue: nombre))
        }
        for antiguo in ["voces <acordes>", "camino <acorde>", "--instrumento 0…127"] {
            #expect(!ayuda.contains(antiguo), Comment(rawValue: antiguo))
        }
    }

    @Test func octavasEnSubindice() {
        // En las compactas (la de siempre, Fa♯) la octava sale en subíndice, y con cifras en las demás; --cifras y
        // --subindices la fijan. Se lee igual con subíndices que con cifras.
        #expect(salida("transponer 2M Do3 Mi4 Sol4 Do5 | Sol2 Re4 Sol4 Si4") == "Re₃ Fa♯₄ La₄ Re₅ | La₂ Mi₄ La₄ Do♯₅\n")
        #expect(
            salida("transponer 2M Do₃ Mi₄ Sol₄ Do₅ | Sol₂ Re₄ Sol₄ Si₄ --cifras")
                == "Re3 Fa♯4 La4 Re5 | La2 Mi4 La4 Do♯5\n")
        #expect(salida("transponer 2M Do3 --ingles") == "D3\n")
        #expect(salida("transponer 2M Do3 --ingles --subindices") == "D₃\n")
        #expect(salida("transponer 2M Do3 --digits") == salida("transponer 2M Do3 --cifras"))
        #expect(salida("ayuda --todo").contains("--cifras"))
        #expect(salida("intervalo Do₄ Mi₅") == salida("intervalo Do4 Mi5"))
        #expect(salida("ayuda --todo").contains("--subindices"))
        #expect(salida("help --all --english").contains("--subscripts"))
    }

    @Test func ingles() {
        #expect(
            salida("acorde G7/B --ingles").hasPrefix(
                "G7/B: dominant seventh\n  notes: G B D F  (bass B, first inversion)"))
        #expect(
            salida("analizar C Am D7 G7 C --ingles").hasPrefix("I–vi–V7/V–V7–I in C major\n  C         I         tonic")
        )
        #expect(salida("revisar C3 E4 G4 C5, G2 D4 G4 B4 --ingles") == "No voice-leading errors.\n")
        #expect(salida("tonalidad D major --ingles").contains("key signature: F# C# (2 sharps)"))
    }

    @Test func laTablaDeOrdenes() {
        // Cada nombre lleva a una sola orden, en minúsculas, y cada orden tiene su ayuda.
        let nombres = LineaDeComandos.ordenes.flatMap(\.nombres)
        #expect(Set(nombres).count == nombres.count)
        for nombre in nombres { #expect(nombre == nombre.lowercased(), Comment(rawValue: nombre)) }
        for orden in LineaDeComandos.ordenes { #expect(!orden.ayuda.isEmpty, Comment(rawValue: orden.nombres[0])) }
        #expect(LineaDeComandos.ordenesDeLaAyuda.count == 70)
        // Los nombres no distinguen mayúsculas.
        #expect(salida("ACORDE Do") == salida("acorde Do"))
    }

    /// Lo que sigue a «armonia ayuda» en la línea que remite a la ayuda de un error de uso: « acorde» con la orden
    /// `acorde`, y nada si la orden no existe o el error es de una opción general.
    static func ayudaDe(_ orden: String) -> String {
        // Las opciones generales se leen antes que la orden: sus errores remiten a la ayuda completa.
        if orden.contains("--escritura") { return "" }
        let nombre = String(orden.split(separator: " ")[0])
        return LineaDeComandos.orden(llamada: nombre) == nil ? "" : " " + nombre
    }

    /// Órdenes que terminan en un error de uso.
    private static let ordenesMalEscritas = [
        "foo", "acorde", "identificar", "intervalo C", "escala", "tonalidad", "analizar", "analizar C --en",
        "armonizar", "armonizar C --en", "armonizar C --propuestas 0", "realizar", "realizar C --en",
        "revisar", "conduccion-minima G7", "digitaciones", "digitaciones C --instrumento arpa",
        "digitaciones C --limite 0",
        "digitaciones C --dedos 9", "digitaciones C --traste 99", "digitaciones C --capo", "vecinos",
        "vecinos C7 --voces 3", "camino-parsimonioso G7", "plr", "plr G7 P", "musicxml", "musicxml coral",
        "musicxml melodia C4:4 --foo 1", "midi acordes C --cifrados", "tonnetz", "tonnetz clases", "conjunto",
        "serie",
        "tonnetz camino C", "tabla ciclo C", "tabla --margen 9 C", "contrapunto", "contrapunto D4 A4",
        "cuadricula", "cuadricula --ejes x C", "cuadricula --rejilla 0x8 C",
        "contrapunto D4 / A4 --especie 6", "contrapunto D4 / ", "acorde Do --escritura foo",
        "arpegio", "arpegio Do --patron zigzag", "arpegio Do --patron", "arpegio Do --octavas 0",
        "arpegio Do --octavas", "arpegio Do --desde Fa", "arpegio Do --desde 4", "arpegio Do --grados 1-x",
        "arpegio Do --tensiones 10", "arpegio Do --aproximacion lejos", "musicxml acordes Do --enlazar",
        "posiciones", "posiciones Do mayor --foo", "musicxml acordes C --ventana 1",
        "musicxml melodia C4:4 --archivo coral.mid", "transponer", "transponer 2M", "rearmonizar",
        "digitaciones C --capo 13", "completado", "completado tcsh", "completado bash zsh", "manual extra",
        "acorde Do --comparar", "acorde Do --en", "acorde Do --foo", "acorde --nombres",
        "escalas --tradicion marte", "escalas --categoria foo", "musicxml escala", "midi escala Re bayati --clave fa",
        "escala Do mayor --secuencia foo", "escala Do mayor --secuencia", "escala Do mayor --comparar",
        "hoja Do mayor --comparar",
        "escala Do mayor --octavas 9", "escala Do mayor --foo", "escala --dedos",
        "teclado", "teclado Do mayor --mano derecha", "teclado Do mayor --octavas 9",
        "teclado Do mayor --foo", "identificar --archivo coral.mid Do", "identificar --archivo", "identificar --foo Do",
        "identificar --escalas", "posiciones Do mayor --secuencia foo", "posiciones Do mayor --secuencia",
        "posiciones Do mayor --formas", "reloj", "reloj Do mayor --foo", "hoja", "hoja Do mayor --foo",
        "hoja acordes", "hoja acordes Do --en", "hoja acorde", "hoja acorde Sol7 Do",
        "posiciones Do mayor --instrumento arpa",
        "posiciones Do mayor --instrumento", "posiciones Do mayor --capo 13", "posiciones Do mayor --capo",
        "posiciones --arpegio", "posiciones --arpegio Do --foo", "pentagrama", "pentagrama nube Do",
        "pentagrama escala", "pentagrama escala Do mayor --octavas 9", "pentagrama acorde Do --foo",
        "pentagrama arpegio Do --patron foo", "pentagrama arpegio Do --figura", "pentagrama acordes",
        "pentagrama escala Do mayor --en", "pentagrama escala Do mayor --mano foo", "pentagrama escala Do mayor --mano",
        "pentagrama escala Do mayor --secuencia foo", "pentagrama escala Do mayor --tab --instrumento arpa",
        "pentagrama arpegio Do --tab --instrumento", "pentagrama acordes Do Sol --foo",
        "pentagrama escala Do --registro 9",
        "pentagrama escala Do --clave luna", "pentagrama escala Do --clave", "pentagrama melodia",
        "pentagrama melodia Do4:4 --sobre", "pentagrama melodia Do4:4 --foo", "pentagrama bajo",
        "pentagrama bajo Do --foo",
        "grabar", "grabar coral C --motor foo", "grabar coral C --formato gif", "grabar acorde C", "grabar nube C",
        "grabar pentagrama acorde C --motor verovio", "motores de mas", "guido", "guido melodia",
    ]

    /// Con --ingles no se cuela nada en español: ni en la salida, ni en los errores, ni en la ayuda.
    @Test func conInglesNadaEnEspanol() {
        let enEspanol = [
            "«", "»", "á", "é", "í", "ó", "ú", "ñ", "notas", "acordes", "paso", "dedo", "cejilla",
            "guitarra", "tríada", "Prueba", "falta",
        ]
        func comprobar(_ texto: String, _ orden: String, sourceLocation: SourceLocation = #_sourceLocation) {
            for palabra in enEspanol where texto.contains(palabra) {
                Issue.record("«\(palabra)» en la salida de «\(orden)»:\n\(texto)", sourceLocation: sourceLocation)
            }
        }
        for orden in [
            "help", "acorde C/E", "acorde G7/B", "identificar C E Bb", "intervalo C4 E5", "escala Re dórico",
            "tonalidad Re mayor", "tonalidad Mib mayor", "tonalidad Do mayor", "analizar C Am D7 G7 C",
            "analizar C F G7 C Am D7 G", "armonizar E4 F4 D4 C4", "armonizar C6 B5 C6", "realizar C F G7 C",
            "realizar C7(9,13)",
            "revisar C3 E4 G4 C5, G2 D4 G4 B4", "plr C PLR", "plr shortest C C", "plr cycle hexatonico C",
            "camino-parsimonioso G7 Dm7", "vecinos G7", "digitaciones F --diagrama",
            "digitaciones C --instrumento ukelele",
            "digitaciones C --instrumento bajo --dedos 1 --traste 0", "counterpoint C4 D4 E4 C4 / G4 A4 G4 C5",
            "arpeggio C7", "arpeggio C --pattern alberti", "transpose M2 C Am F G7", "reharmonize C Am Dm7 G7 C",
            "digitaciones C --capo 2", "arpeggio C --from E --tensions 9 --octaves 2 --no-octave --approach above",
            "arpeggio C7 --degrees 1-5-3-8 --approach enclosure",
            "set 0 4 7", "set C E G", "set 4-Z15", "row 0 e 7 4 2 9 3 8 t 1 5 6",
            "chord G7 --voicings --names --keys --substitutions --compare C", "chord C --substitutions --in G major",
            "scale C major --sequence thirds --descending --octaves 2 --fingers --modes --compare C lydian",
            "chord C7 --bebop --pentatonics", "analyze Dm7 G7 Cmaj7 --in C major --scales",
            "identify C E G B F# --scales", "scale C half whole diminished --symmetry",
            "analyze Dm7 G7 Cmaj7 --guide-tones", "positions A minor pentatonic --shapes",
            "positions C major --sequence thirds --caged --descending", "keyboard D major --fingers right --octaves 2",
            "scale C major --neighbors --all-keys --sequence thirds", "clock C diminished --fifths",
            "positions C major --instrument bass --capo 2", "positions D major --instrument dadgad",
            "scale C 2-2-3-2-3", "scale C lydian --statistics",
            "scale A harmonic minor --all-keys --chords --triads", "positions --arpeggio Am --sweep --up-and-down",
            "positions --arpeggio C7 --caged --instrument bass --capo 1", "engines",
        ] {
            let resultado = LineaDeComandos.ejecutar((orden + " --ingles").split(separator: " ").map(String.init))
            // 3: `check` y `counterpoint` encuentran faltas.
            #expect(resultado.codigo == 0 || resultado.codigo == 3, "\(orden): \(resultado.error)")
            comprobar(resultado.salida, orden)
        }
        for orden in Self.ordenesMalEscritas {
            let resultado = LineaDeComandos.ejecutar((orden + " --ingles").split(separator: " ").map(String.init))
            #expect(resultado.codigo == 2, Comment(rawValue: orden))
            #expect(
                resultado.error.hasSuffix("Try \"armonia help\(Self.ayudaDe(orden))\".\n"),
                "\(orden): \(resultado.error)")
            comprobar(resultado.error, orden)
        }
    }

    @Test func ayudaEnIngles() {
        for orden in ["--ingles", "ayuda --ingles", "help --english"] {
            #expect(salida(orden).hasPrefix("armonia: music theory"), Comment(rawValue: orden))
        }
        #expect(salida("help --all --ingles").contains("fingerings <symbol>"))
        #expect(LineaDeComandos.ayuda(en: .espanolCompacto).hasPrefix("armonia: teoría musical"))
    }

    @Test func idiomas() {
        #expect(
            salida("acorde Sol7/Si --idioma eu") == """
                Sol7/Si: dominanteko zazpigarrena
                  notak: sol si re fa  (baxua si, lehen inbertsioa)
                  sol oinarria · si hirugarrena · re bosgarrena · fa zazpigarrena

                """)
        #expect(salida("acorde Sol7/Si --idioma ca").contains("notes: sol si re fa  (baix si, primera inversió)"))
        #expect(salida("acorde Sol7/Si --idioma galego").contains("sol fundamental · si terceira"))
        #expect(salida("tonalidad Mib mayor --idioma gl").contains("(3 bemois)"))
        #expect(salida("--idioma en acorde C/G") == salida("acorde C/G --ingles"))
        #expect(salida("acorde Do --language es") == salida("acorde Do"))
        // La ayuda, en los quince idiomas.
        #expect(salida("ayuda --todo --idioma ca").hasPrefix("armonia: "))
        #expect(salida("ayuda --todo --idioma ca") == (ayudaEn(.catalan) + "\n"))
        #expect(salida("ayuda --todo --idioma gl") == (ayudaEn(.gallego) + "\n"))
        #expect(salida("ayuda --todo --idioma eu") == (ayudaEn(.euskera) + "\n"))
        #expect(salida("ayuda --todo --idioma pt") == (ayudaEn(.portugues) + "\n"))
        #expect(salida("ayuda --todo --idioma fr") == (ayudaEn(.frances) + "\n"))
        #expect(salida("ayuda --todo --idioma italiano") == (ayudaEn(.italiano) + "\n"))
        #expect(salida("ayuda --todo --idioma de") == (ayudaEn(.aleman) + "\n"))
        #expect(salida("ayuda --todo --idioma oc") == (ayudaEn(.occitano) + "\n"))
        #expect(salida("ayuda --todo --idioma ru") == (ayudaEn(.ruso) + "\n"))
        #expect(salida("ayuda --todo --idioma hu") == (ayudaEn(.hungaro) + "\n"))
        #expect(salida("ayuda --todo --idioma magyar").hasPrefix("armonia: zeneelmélet a parancssorban."))
        #expect(salida("tonalidad Mib mayor --idioma hu").contains("Esz-dúr"))
        #expect(salida("ayuda --todo --idioma el") == (ayudaEn(.griego) + "\n"))
        #expect(salida("ayuda --todo --idioma an") == (ayudaEn(.aragones) + "\n"))
        #expect(salida("ayuda --todo --idioma asturianu") == (ayudaEn(.asturiano) + "\n"))
        #expect(ayudaEn(.asturiano).hasPrefix("armonia: teoría musical dende la llinia"))
        #expect(ayudaEn(.aleman).hasPrefix("armonia: Musiktheorie"))
        #expect(ayudaEn(.ruso).contains("armonia chord G7/B"))
        #expect(ayudaEn(.occitano).contains("armonia acorde Sol7/Si"))
        // Una distinta por idioma, y la de cada idioma es la del mapa.
        #expect(Set(Idioma.allCases.map { ayudaEn($0) }).count == Idioma.allCases.count)
        #expect(Set(Idioma.allCases.map { ayudaEn($0) }) == Set(LineaDeComandos.ayudas.values))
        #expect(salida("acorde Sol7/Si --idioma fr").hasPrefix("Sol7/Si: septième de dominante\n"))
        #expect(salida("acorde Sol7/Si --idioma it").contains("(basso si, primo rivolto)"))
        #expect(salida("tonalidad Mib mayor --idioma pt").contains("(3 bemóis)"))
        #expect(salida("escala Re dórico --idioma fr").hasPrefix("ré dorien"))
        #expect(salida("help --idioma en").hasPrefix("armonia: music theory"))
        #expect(salida("acorde Sol7/Si --idioma ca").hasPrefix("Sol7/Si: sèptima de dominant\n"))
        #expect(salida("escala Re dórico --idioma eu").hasPrefix("re doriarra"))
        // Los errores de lectura los traduce el motor.
        #expect(resultado("acorde", "Do7(b3)", "--idioma", "eu").error.hasPrefix("armonia: Ezin da «Do7(b3)» irakurri"))
        #expect(
            resultado("digitaciones", "C", "--limite", "0", "--idioma", "eu").error
                == "armonia: muga 1etik 200era bitarteko zenbaki bat da: --limite 5\nProbatu «armonia ayuda digitaciones».\n"
        )
        #expect(resultado("acorde", "Do", "--idioma", "xx").codigo == 2)
        #expect(
            resultado("acorde", "Do", "--idioma", "xx").error
                .hasPrefix(
                    "armonia: idioma desconocido: «xx» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru o hu)"))
        #expect(salida("acorde Sol7/Si --idioma de").hasPrefix("G7/H: Dominantseptakkord\n"))
        #expect(salida("acorde Sol7/Si --idioma ru").hasPrefix("Соль7/Си: доминантсептаккорд\n"))
        #expect(salida("escala Re dórico --idioma el").hasPrefix("ρε δώριος"))
        #expect(salida("escala Re dórico --idioma ast").hasPrefix("re dóricu"))
        #expect(salida("acorde Sol7/Si --idioma an").contains("(baixo si, primera inversión)"))
        #expect(salida("digitaciones C --instrumento baxu --idioma ast").contains("baxu"))
        #expect(
            resultado("acorde", "Do", "--idioma").error
                == "armonia: falta el valor de --idioma\nPrueba «armonia ayuda».\n")
        // Notas y textos por separado.
        #expect(salida("acorde Sol7/Si --idioma en --textos es").hasPrefix("G7/B: séptima de dominante\n"))
        #expect(salida("acorde Sol7/Si --textos fr").hasPrefix("Sol7/Si: septième de dominante\n"))
        #expect(salida("ayuda --todo --idioma fr --textos es").contains("--textos"))
        #expect(resultado("acorde", "Do", "--textos", "xx").codigo == 2)
        #expect(resultado("acorde", "Do", "--textos").codigo == 2)
    }

    /// --escritura elige, en español e inglés, entre palabras, # y b o ♯ y ♭.
    @Test func escritura() {
        #expect(salida("acorde Sib7").hasPrefix("Si♭7: séptima de dominante\n  notas: Si♭ Re Fa La♭"))
        #expect(
            salida("acorde Sib7 --escritura palabras")
                .hasPrefix("Si♭7: séptima de dominante\n  notas: Si bemol Re Fa La bemol"))
        #expect(salida("acorde Sib7 --escritura ascii").hasPrefix("Sib7: séptima de dominante\n  notas: Sib Re Fa Lab"))
        #expect(
            salida("acorde Bb7 --ingles --writing words").hasPrefix("B♭7: dominant seventh\n  notes: B flat D F A flat")
        )
        #expect(
            salida("acorde Bb7 --ingles --escritura unicode").hasPrefix("B♭7: dominant seventh\n  notes: B♭ D F A♭"))
        #expect(salida("acorde Bb7 --ingles --escritura ASCII") == salida("acorde Bb7 --ingles"))
        #expect(salida("acorde Bb7 --ingles --escritura compacto") == salida("acorde Bb7 --ingles --escritura unicode"))
        // En alemán, compacta (Fis) o con palabras (F Kreuz).
        #expect(salida("escala Fa# dórico --idioma de").hasPrefix("Fis dorisch\n  Noten: Fis Gis A H"))
        #expect(salida("escala Fa# dórico --idioma de --escritura compacto") == salida("escala Fa# dórico --idioma de"))
        #expect(
            salida("escala Fa# dórico --idioma de --escritura palabras")
                .hasPrefix("F Kreuz dorisch\n  Noten: F Kreuz G Kreuz A H"))
        // La octava, en subíndice en las compactas salvo con --cifras.
        #expect(salida("transponer 2M Mi4") == "Fa♯₄\n")
        #expect(salida("transponer 2M Mi4 --idioma de") == "Fa♯₄\n")
        #expect(salida("transponer 2M Mi4 --ingles --escritura compacto --subindices") == "F♯₄\n")
        #expect(
            salida("acorde Sib7 --idioma en --escritura palabras --textos es")
                .hasPrefix("B♭7: séptima de dominante\n  notas: B flat D F A flat"))
        #expect(
            resultado("acorde", "Do", "--escritura", "foo").error
                .hasPrefix(
                    "armonia: escritura no válida: «foo» (palabras o compacto; ascii o unicode, solo con es y en)"))
        // En los idiomas con palabras, la compacta escribe la sílaba en mayúscula con el signo.
        #expect(salida("escala Re mayor --idioma fr --escritura compacto").hasPrefix("Ré majeur"))
        #expect(salida("escala Re mayor --idioma fr --escritura compacto").contains("Fa♯"))
        #expect(salida("transponer 2M Mi4 --idioma ca --escritura compacto --subindices") == "Fa♯₄\n")
        #expect(salida("acorde Do --idioma ca --escritura palabras") == salida("acorde Do --idioma ca"))
        #expect(resultado("acorde", "Do", "--idioma", "ca", "--escritura", "ascii").codigo == 2)
        #expect(resultado("acorde", "Do", "--escritura").codigo == 2)
        #expect(salida("ayuda --todo").contains("--escritura"))
        #expect(salida("help --all --ingles").contains("--writing"))
    }

    /// Con --idioma ca, gl, eu, pt, fr, it, de, el o ru, los errores de uso no dejan nada en español (el
    /// occitano no entra: también dice «las» y «los»).
    @Test func erroresEnCatalanGallegoEuskera() {
        let enEspanol = ["Prueba", "hace falta", "hacen falta", "desconocid", " es un", " sin ", " las ", " los "]
        for (idioma, antes, despues) in [
            ("ca", "Prova «armonia ayuda", "».\n"), ("gl", "Proba «armonia ayuda", "».\n"),
            ("eu", "Probatu «armonia ayuda", "».\n"), ("pt", "Experimente «armonia ayuda", "».\n"),
            ("fr", "Essayez « armonia ayuda", " ».\n"), ("it", "Prova «armonia ayuda", "».\n"),
            ("de", "Versuche „armonia help", "“.\n"), ("ru", "Попробуй «armonia help", "».\n"),
            ("el", "Δοκίμασε «armonia help", "».\n"),
        ] {
            for orden in Self.ordenesMalEscritas {
                let ayuda = antes + Self.ayudaDe(orden) + despues
                let resultado = LineaDeComandos.ejecutar(
                    (orden + " --idioma " + idioma).split(separator: " ").map(String.init))
                #expect(resultado.codigo == 2, "\(orden) \(idioma)")
                #expect(resultado.error.hasSuffix(ayuda), "\(orden) \(idioma): \(resultado.error)")
                for palabra in enEspanol where resultado.error.contains(palabra) {
                    Issue.record("«\(palabra)» en «\(orden) --idioma \(idioma)»: \(resultado.error)")
                }
            }
        }
    }

    @Test func erroresEnIngles() {
        let error = resultado("digitaciones", "C", "--limite", "0", "--ingles").error
        #expect(
            error == "armonia: the limit is a number from 1 to 200: --limit 5\nTry \"armonia help digitaciones\".\n")
        #expect(
            resultado("digitaciones", "C", "--limite", "0").error
                == "armonia: el límite es un número de 1 a 200: --limite 5\nPrueba «armonia ayuda digitaciones».\n")
        #expect(salida("digitaciones C --limite 1 --ingles").hasPrefix("C · guitar\n"))
        #expect(salida("tonalidad F major --ingles").contains("(1 flat)"))
        #expect(salida("tonalidad Fa mayor").contains("(1 bemol)"))
        #expect(salida("tonalidad Mib mayor").contains("(3 bemoles)"))
    }

    @Test func errores() {
        let lectura = LineaDeComandos.ejecutar(["acorde", "Hm"])
        #expect(lectura.codigo == 1)
        #expect(lectura.salida == "")
        #expect(lectura.error.hasPrefix("armonia: No se puede leer «Hm»"))
        #expect(LineaDeComandos.ejecutar(["acorde", "Hm", "--ingles"]).error.hasPrefix("armonia: Cannot read"))

        for orden in [
            ["foo"], ["intervalo", "Do"], ["acorde"], ["analizar"], ["analizar", "Do", "--en"], ["revisar"],
        ] {
            let resultado = LineaDeComandos.ejecutar(orden)
            #expect(resultado.codigo == 2, "\(orden)")
            let ayuda = orden == ["foo"] ? "" : " " + orden[0]
            #expect(resultado.error.hasSuffix("Prueba «armonia ayuda\(ayuda)».\n"), "\(orden): \(resultado.error)")
        }
        #expect(LineaDeComandos.ejecutar(["revisar", "Do3", "Mi4,", "Sol2"]).codigo == 1)
    }
}
