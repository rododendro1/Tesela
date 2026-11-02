import Armonia
import Foundation
import Testing

@testable import ArmoniaCLI

// Las pruebas de las consultas: acordes, notas, arpegios, escalas, tonalidades y análisis.

extension LineaDeComandosTests {
    @Test func acorde() {
        #expect(
            salida("acorde Sol7/Si") == """
                Sol7/Si: séptima de dominante
                  notas: Sol Si Re Fa  (bajo Si, primera inversión)
                  Sol fundamental · Si tercera · Re quinta · Fa séptima

                """)
        #expect(salida("acorde Do Lam").components(separatedBy: "\n\n").count == 2)
        #expect(salida("acorde Do/Re").contains("bajo ajeno al acorde"))
        #expect(salida("acorde Do/Sol").contains("(bajo Sol, segunda inversión)"))
        #expect(salida("acorde Sol7/Fa").contains("(bajo Fa, tercera inversión)"))
        #expect(salida("acorde C/G --ingles").contains("(bass G, second inversion)"))
    }

    @Test func identificar() {
        #expect(salida("identificar Do Mi Sol Sib").hasPrefix("Do7  séptima de dominante\n"))
        // Con octavas cuenta el bajo.
        #expect(salida("identificar Mi3 Sol3 Do4").hasPrefix("Do/Mi  mayor\n"))
        #expect(salida("identificar Do Mi Sib").contains("Do7  séptima de dominante  (sin Sol)"))
    }

    @Test func arpegio() {
        let do7 = salida("arpegio Do7")
        #expect(do7.hasPrefix("Arpegio de "), Comment(rawValue: do7))
        #expect(do7.contains("(ascendente)\n  notas: Do₄ Mi₄ Sol₄ Si♭₄ Do₅\n"), Comment(rawValue: do7))
        // Las escalas que encajan con el acorde: Do7 → Do mixolidio.
        #expect(do7.contains("  escalas: ") && do7.contains("mixolidio"), Comment(rawValue: do7))
        #expect(salida("arpegio Do --patron alberti").contains("notas: Do₄ Sol₄ Mi₄ Sol₄\n"))
        #expect(
            salida("arpegio Do --patron ida-y-vuelta").contains(
                "(de ida y vuelta)\n  notas: Do₄ Mi₄ Sol₄ Do₅ Sol₄ Mi₄ Do₄\n"))
        #expect(salida("arpeggio C7 --pattern descending --ingles").contains("notes: C5 Bb4 G4 E4 C4"))
        #expect(salida("arpegio Do Fa").components(separatedBy: "\n\n").count == 2)
        #expect(LineaDeComandos.patronDeArpegio("bajo de Alberti") == .alberti)
        #expect(LineaDeComandos.patronDeArpegio("up-down") == .idaYVuelta)
        #expect(LineaDeComandos.patronDeArpegio("Ascending") == .ascendente)
        #expect(LineaDeComandos.patronDeArpegio("aufwärts") == .ascendente)
        #expect(LineaDeComandos.patronDeArpegio("baja-y-sube") == .bajaYSube)
        #expect(LineaDeComandos.patronDeArpegio("brisé") == .quebrado)
        #expect(LineaDeComandos.patronDeArpegio("zigzag") == nil)
    }

    @Test func transponer() {
        #expect(salida("transponer 2M Do Lam Re7 Sol7") == "Re Sim Mi7 La7\n")
        // A una tónica, por el camino más corto: de Do a Re, una segunda arriba.
        #expect(salida("transponer Re Do Lam Fa Sol7") == "Re Sim Sol La7\n")
        #expect(salida("transpose -m3 C Am F G7 --ingles") == "A F#m D E7\n")
        // Lo que no son acordes se transporta como notas: un coral.
        #expect(salida("transponer 2M Do₃ Mi₄ Sol₄ Do₅ | Sol₂ Re₄ Sol₄ Si₄") == "Re₃ Fa♯₄ La₄ Re₅ | La₂ Mi₄ La₄ Do♯₅\n")
        #expect(LineaDeComandos.ejecutar(["transponer", "2M"]).codigo == 2)
    }

    @Test func rearmonizar() {
        let propuestas = salida("rearmonizar Do Lam Rem7 Sol7 Do")
        #expect(propuestas.hasPrefix("Do mayor\n"), Comment(rawValue: propuestas))
        #expect(propuestas.contains("  4. Sol7 → Re♭7 (sustituto tritonal)\n"), Comment(rawValue: propuestas))
        #expect(propuestas.contains("  2. Lam → Mi7 Lam (dominante secundaria)\n"), Comment(rawValue: propuestas))
        let enIngles = salida("reharmonize C Am Dm7 G7 C --ingles")
        #expect(enIngles.contains("G7 → Db7 (tritone substitution)"), Comment(rawValue: enIngles))
        #expect(salida("rearmonizar Lam Rem Mi7 Lam --en La menor").hasPrefix("La menor\n"))
    }

    @Test func intervaloEscalaYTonalidad() {
        #expect(salida("intervalo Do4 Mi5") == "10ª mayor (10M, 16 semitonos)\n")
        #expect(salida("intervalo Fa Si") == "4ª aumentada (4A, 6 semitonos)\n")
        #expect(salida("escala Re dórico").contains("notas: Re Mi Fa Sol La Si Do"))
        #expect(salida("escala Re dórico").contains("i7 Rem7 · ii7 Mim7"))
        // Sin acordes cuando la escala no es heptatónica.
        #expect(!(salida("escala Do pentatónica mayor").contains("acordes")))
        // Las escalas con microtonos dan también su versión microtonal y los cents de cada grado.
        let bayati = salida("escala Re bayati")
        #expect(bayati.contains("notas: Re Mi♭ Fa Sol La Si♭ Do"), Comment(rawValue: bayati))
        #expect(bayati.contains("microtonos: Re Mi𝄳 Fa Sol La Si♭ Do"), Comment(rawValue: bayati))
        #expect(bayati.contains("¢: 0 150 300 500 700 800 1000"), Comment(rawValue: bayati))
        #expect(!bayati.contains("↓"))
        let rast = salida("escala Sol rast makami")
        #expect(rast.contains("microtonos: Sol La Si⁻¹ Do Re Mi Fa♯⁻¹"), Comment(rawValue: rast))
        #expect(rast.contains("¢: 0 204 385 498 702 906 1087"), Comment(rawValue: rast))
        #expect(rast.contains("microtonos ↓: Sol La Si⁻¹ Do Re Mi Fa"), Comment(rawValue: rast))
        #expect(!(salida("escala Re dórico").contains("microtonos")))
        #expect(salida("tonalidad Mib mayor").contains("armadura: Si♭ Mi♭ La♭ (3 bemoles)"))
        #expect(salida("tonalidad Sol mayor").contains("armadura: Fa♯ (1 sostenido)"))
        #expect(salida("tonalidad La menor").contains("relativa: Do mayor · homónima: La mayor"))
        #expect(salida("tonalidad La menor").contains("V7 Mi7"))
    }

    /// `escalas`: el catálogo, por tradición y categoría, con filtros y búsqueda.
    @Test func catalogoDeEscalas() {
        let todas = salida("escalas")
        #expect(todas.hasPrefix("habituales ("), Comment(rawValue: todas))
        #expect(todas.contains("turquia · makam (23)"), Comment(rawValue: todas))
        #expect(todas.contains("  Bayātī: Do Re♭ Mi♭ Fa Sol La♭ Si♭ · microtonos"))
        let turcas = salida("escalas --tradicion turquia")
        #expect(turcas.hasPrefix("turquia · makam (23)\n"), Comment(rawValue: turcas))
        #expect(turcas.contains("  Hicaz makamı: Do Re♭ Mi Fa Sol La Si♭ · microtonos"), Comment(rawValue: turcas))
        #expect(!turcas.contains("habituales"))
        // Las tradiciones y las categorías se escriben de varias maneras, en español o en inglés.
        #expect(salida("escalas --tradicion Turquía") == turcas)
        #expect(salida("escalas --tradition turkey") == turcas)
        #expect(salida("escalas --categoria makam") == turcas)
        #expect(salida("escalas --tradicion mundo-arabe").hasPrefix("mundo-arabe · maqam ("))
        let bizantinas = salida("escalas --tradicion bizancio")
        #expect(bizantinas.hasPrefix("bizancio · echos (9)\n"), Comment(rawValue: bizantinas))
        #expect(bizantinas.contains("  echos prótos: Do Re Mi♭ Fa Sol La Si♭ · microtonos"))
        #expect(salida("escalas --tradition byzantium") == bizantinas)
        let thats = salida("escalas --tradicion india --categoria thaat")
        #expect(thats.hasPrefix("india · thāṭ (10)"), Comment(rawValue: thats))
        // Las categorías indias salen en IAST (thāṭ, mēḷa, rāga), pero se encuentran con o sin diacríticos.
        #expect(salida("escalas --tradicion india --categoria thāṭ") == thats)
        #expect(salida("escalas --tradicion india --categoria that") == thats)
        #expect(salida("escalas --categoria melakarta").hasPrefix("india · mēḷa (72)"))
        #expect(salida("escalas --categoria mēḷa") == salida("escalas --categoria melakarta"))
        #expect(salida("escalas --categoria mela") == salida("escalas --categoria melakarta"))
        #expect(salida("escalas --categoria rāga") == salida("escalas --categoria raga"))
        #expect(salida("escalas --tradition turkey --ingles").hasPrefix("turkey · makam (23)"))
        // Un texto busca en los nombres, sin tildes.
        let hicaz = salida("escalas hicaz")
        #expect(hicaz.contains("Hicaz makamı") && hicaz.contains("Hicazkâr makamı"), Comment(rawValue: hicaz))
        #expect(!hicaz.contains("Bayātī"))
        #expect(salida("escalas bayati").contains("Bayātī"))
        #expect(salida("escalas zzz") == "no hay ninguna escala así\n")
        #expect(salida("escalas --tradicion india --categoria maqam") == "no hay ninguna escala así\n")
        for orden in ["escalas --tradicion marte", "escalas --categoria foo", "escalas --tradicion", "escalas --foo"] {
            #expect(LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init)).codigo == 2)
        }
        #expect(LineaDeComandos.ejecutar(["escalas", "--tradicion", "marte"]).error.contains("«marte»"))
    }

    @Test func analizar() {
        #expect(
            salida("analizar Do Lam Re7 Sol7 Do") == """
                I–vi–V7/V–V7–I en Do mayor
                  Do        I         tónica
                  Lam       vi        tónica
                  Re7       V7/V      dominante
                  Sol7      V7        dominante
                  Do        I         tónica
                Cadencia auténtica V7–I (acordes 4 → 5)

                """)
        #expect(salida("analizar Lam Rem Mi7 La --en La menor").hasPrefix("i–iv–V7–I en La menor\n"))
        #expect(salida("analizar Do Lam Fa Sol").hasSuffix("Semicadencia IV–V (acordes 3 → 4)\n"))
    }

    @Test func analizarUnArchivo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let esperado = salida("analizar Do Lam Re7 Sol7 Do")
        let midi = try fichero(analisis.midi(), extension: "mid")
        #expect(salida("analizar --archivo " + midi) == esperado)
        let xml = try fichero(Data(analisis.musicXML().utf8), extension: "musicxml")
        #expect(salida("analyze --file " + xml) == esperado)
        // Cada acorde dura una blanca: con una ventana de una blanca, sale lo mismo.
        #expect(salida("analizar --archivo \(xml) --ventana 2") == esperado)
        #expect(salida("analizar --archivo \(midi) --en Do mayor").hasPrefix("I–vi–V7/V–V7–I en Do mayor\n"))
    }

    @Test func analizarUnArchivoConErrores() throws {
        func resultado(_ orden: String) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        }
        #expect(resultado("analizar --archivo").codigo == 2)
        let inexistente = resultado("analizar --archivo /no/existe.mid")
        #expect(inexistente.codigo == 2)
        #expect(inexistente.error.hasPrefix("armonia: no se puede leer el fichero «/no/existe.mid»\n"))
        let texto = try fichero(Data("hola".utf8), extension: "mid")
        #expect(resultado("analizar --archivo " + texto).codigo == 1)
        #expect(resultado("analizar --archivo " + texto).error == "El fichero no es MIDI, MusicXML, MEI ni ABC.\n")
        #expect(
            resultado("analizar --archivo \(texto) --ingles").error == "The file is not MIDI, MusicXML, MEI or ABC.\n")
        #expect(resultado("analizar Do Sol --archivo " + texto).codigo == 2)
        #expect(resultado("analizar --archivo \(texto) --ventana 3").codigo == 1)
        let melodia = try fichero(Voz(leyendo: "Do4:4 Re4:4 Mi4:4").midi(), extension: "mid")
        #expect(
            resultado("analizar --archivo " + melodia).error.hasPrefix("armonia: el fichero no tiene ningún acorde\n"))
    }

    @Test func analizarModulaciones() {
        #expect(
            salida("analizar Do Fa Sol7 Do Lam Re7 Sol") == """
                I–IV–V7–I en Do mayor → ii–V7–I en Sol mayor
                  Do        I         tónica
                  Fa        IV        subdominante
                  Sol7      V7        dominante
                  Do        I         tónica
                De Do mayor a Sol mayor en el acorde 5 (pivote: Lam = vi en Do mayor = ii en Sol mayor)
                  Lam       ii        subdominante
                  Re7       V7        dominante
                  Sol       I         tónica
                Cadencia auténtica V7–I (acordes 3 → 4)
                Cadencia auténtica V7–I (acordes 6 → 7)

                """)
        #expect(
            salida("analyze C G C F Dm E7 Am --ingles")
                .contains("From C major to A minor at chord 5 (pivot: Dm = ii in C major = iv in A minor)"))
        // Con la tonalidad dada no se buscan modulaciones.
        #expect(!(salida("analizar Do Fa Sol7 Do Lam Re7 Sol --en Do mayor").contains("De Do mayor a")))
    }
}
