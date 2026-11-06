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

    @Test func lasRelacionesDeUnAcorde() {
        let sol7 = salida("acorde Sol7 --disposiciones --nombres --tonalidades --sustituciones --comparar Do")
        #expect(sol7.hasPrefix(salida("acorde Sol7").dropLast()))
        #expect(sol7.contains("\nDisposición:\n  Cerrada: "))
        #expect(sol7.contains("\n  Drop 2: "))
        #expect(sol7.contains("\n  Sin fundamental (A): "))
        #expect(sol7.contains("\nOtros nombres: "))
        #expect(sol7.contains("\nEn qué tonalidades está:\n  V7 en Do mayor · dominante\n"))
        #expect(sol7.contains("\nSustituciones (Do mayor):\n"))
        #expect(sol7.contains("Sol7 → Re♭7 (sustituto tritonal)"))
        #expect(sol7.contains("\nComparar con Do:\n  Notas comunes: Sol\n"))
        #expect(sol7.hasSuffix(" semitonos\n"))
        // Sin la fundamental: Do6 es Lam7/Do, y Sol7(♭9) sin su Sol es Si°7.
        let do6 = salida("acorde Do6 --nombres")
        #expect(do6.contains("\nOtros nombres: ") && do6.contains("Lam7/Do"))
        #expect(salida("acorde Sol7(b9) --nombres").contains("\nSin la fundamental: Si°7"))
        let enSol = salida("acorde Do --sustituciones --en Sol mayor")
        #expect(enSol.contains("\nSustituciones (Sol mayor):\n"))
        #expect(salida("chord G7 --substitutions --keys --ingles").contains("\nSubstitutions (C major):\n"))
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
        // El recorrido: octavas, sin la octava, desde otra nota, con tensiones, por grados y con aproximaciones.
        #expect(salida("arpegio Do --octavas 2").contains("notas: Do₄ Mi₄ Sol₄ Do₅ Mi₅ Sol₅ Do₆\n"))
        #expect(salida("arpegio Do --sin-octava").contains("notas: Do₄ Mi₄ Sol₄\n"))
        #expect(salida("arpegio Do --desde Mi").contains("notas: Mi₄ Sol₄ Do₅ Mi₅\n"))
        #expect(salida("arpegio Do --desde 5").contains("notas: Sol₄ Do₅ Mi₅ Sol₅\n"))
        #expect(salida("arpegio Do7 --tensiones 9").contains("notas: Do₄ Mi₄ Sol₄ Si♭₄ Re₅ Do₆\n"))
        #expect(salida("arpegio Do --grados 1-5-3-8").contains("(1-5-3-8)\n  notas: Do₄ Sol₄ Mi₄ Do₅\n"))
        #expect(
            salida("arpegio Do --aproximacion abajo --sin-octava").contains("notas: Si₃ Do₄ Re♯₄ Mi₄ Fa♯₄ Sol₄\n"))
        #expect(
            salida("arpeggio C --from E --octaves 2 --no-octave --ingles").contains("notes: E4 G4 C5 E5 G5 C6\n"))
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
    /// `escalas --uso`: solo las habituales de ese uso, en español o en inglés.
    @Test func escalasPorUso() {
        let blues = salida("escalas --uso blues")
        #expect(blues.hasPrefix("habituales · blues (6)\n"), Comment(rawValue: blues))
        #expect(blues.contains("  blues: Do Mi♭ Fa Fa♯ Sol Si♭ · microtonos\n"), Comment(rawValue: blues))
        #expect(!blues.contains("Turquía"))
        #expect(salida("escalas --use blues") == blues)
        let jazz = salida("escalas --uso jazz")
        #expect(jazz.contains("  alterada: "), Comment(rawValue: jazz))
        #expect(!jazz.contains("  menor melódica: "), Comment(rawValue: jazz))
        #expect(salida("escalas --use 20th-century") == salida("escalas --uso siglo-xx"))
        #expect(salida("escalas --uso siglo-xx").contains("  modo 3 de Messiaen: "))
        #expect(salida("scales --use jazz --ingles").hasPrefix("common · jazz ("))
        // Con un texto, busca dentro del uso; con una tradición, no hay ninguna.
        #expect(salida("escalas bebop --uso jazz").hasPrefix("habituales · jazz (5)\n"))
        #expect(resultado("escalas", "--uso", "jazz", "--tradicion", "japon").codigo == 1)
        #expect(resultado("escalas", "--uso", "jaz").error.contains("«jazz»"))
        #expect(resultado("escalas", "--uso").codigo == 2)
    }

    /// `escalas --notas 5`: solo las de cinco notas, de las habituales y de las otras tradiciones.
    @Test func escalasPorNumeroDeNotas() {
        let pentatonicas = salida("escalas --notas 5")
        #expect(pentatonicas.contains("  pentatónica mayor: Do Re Mi Sol La"), Comment(rawValue: pentatonicas))
        #expect(!pentatonicas.contains("  mayor: "), Comment(rawValue: pentatonicas))
        #expect(salida("escalas --notes 5") == pentatonicas)
        #expect(salida("escalas --notas 8 --uso jazz").contains("  bebop dominante: "))
        #expect(resultado("escalas", "--notas", "0").codigo == 2)
        #expect(resultado("escalas", "--notas", "cinco").codigo == 2)
        #expect(resultado("escalas", "--notas").codigo == 2)
        #expect(resultado("escalas", "--notas").error.contains("--notas 5"))
    }

    /// `escalas --orden brillo`, `--sin-semitonos`, `--regulares`: por lo que se mide de cada escala.
    @Test func escalasPorSusEstadisticas() throws {
        let porBrillo = salida("escalas --notas 7 --orden brillo")
        let lidio = try #require(
            porBrillo.range(of: "\n  lidio: Do Re Mi Fa♯ Sol La Si · +3\n"), Comment(rawValue: porBrillo))
        let mayor = try #require(porBrillo.range(of: "\n  mayor: Do Re Mi Fa Sol La Si · +2\n"))
        let locrio = try #require(porBrillo.range(of: "\n  locrio: Do Re♭ Mi♭ Fa Sol♭ La♭ Si♭ · -3\n"))
        #expect(lidio.lowerBound < mayor.lowerBound && mayor.lowerBound < locrio.lowerBound)
        #expect(salida("escalas --notes 7 --sort brightness") == porBrillo)
        // Por notas, de menos a más: las pentatónicas antes que las de siete.
        let porNotas = salida("escalas --orden notas")
        let pentatonica = try #require(porNotas.range(of: "\n  pentatónica mayor: "), Comment(rawValue: porNotas))
        #expect(pentatonica.lowerBound < (porNotas.range(of: "\n  mayor: ")?.lowerBound ?? porNotas.startIndex))
        let sinSemitonos = salida("escalas --sin-semitonos")
        #expect(sinSemitonos.contains("  pentatónica mayor: "), Comment(rawValue: sinSemitonos))
        #expect(!sinSemitonos.contains("  mayor: "))
        let regulares = salida("escalas --regulares --notas 7")
        #expect(regulares.contains("  mayor: "), Comment(rawValue: regulares))
        #expect(!regulares.contains("  menor armónica: "))
        #expect(resultado("escalas", "--orden", "color").codigo == 2)
        #expect(resultado("escalas", "--orden", "color").error.contains("--orden brillo"))
    }

    /// `escalas --comparar`: varias escalas en una tabla, una por fila, con las columnas alineadas.
    @Test func compararEscalas() throws {
        let tabla = salida("escalas --comparar Do mayor, Do lidio")
        let lineas = tabla.split(separator: "\n").map(String.init)
        #expect(lineas.count == 3, Comment(rawValue: tabla))
        let lidio = try #require(lineas.last)
        #expect(lidio.hasPrefix("Do lidio  "), Comment(rawValue: tabla))
        #expect(lidio.contains("  +3  "))
        #expect(lineas[1].contains("  +2  "))
        #expect(lineas[1].contains("7-35"))
        #expect(salida("escalas --compare Do mayor, Do lidio") == tabla)
        #expect(resultado("escalas", "--comparar").codigo == 2)
        #expect(resultado("escalas", "--comparar", "Do", "zzz").codigo != 0)
    }

    /// `escalas --con-intervalo`, `--sin-intervalo`, `--con-paso`: por los intervalos que forman sus notas.
    @Test func escalasPorIntervalos() {
        let conTritono = salida("escalas --con-intervalo tritono")
        #expect(conTritono.contains("  mayor: "), Comment(rawValue: conTritono))
        #expect(!conTritono.contains("  pentatónica mayor: "))
        #expect(salida("escalas --con-intervalo 6") == conTritono)
        let sinTritono = salida("escalas --sin-intervalo tritono")
        #expect(sinTritono.contains("  pentatónica mayor: "), Comment(rawValue: sinTritono))
        #expect(!sinTritono.contains("  mayor: "))
        #expect(salida("escalas --without-interval tritone") == sinTritono)
        let conPaso = salida("escalas --con-paso 3 --notas 7")
        #expect(conPaso.contains("  menor armónica: "), Comment(rawValue: conPaso))
        #expect(!conPaso.contains("  mayor: "))
        #expect(resultado("escalas", "--con-intervalo", "foo").codigo == 2)
        #expect(resultado("escalas", "--con-intervalo", "foo").error.contains("--con-intervalo tritono"))
        #expect(resultado("escalas", "--con-paso", "20").codigo == 2)
    }

    /// `escalas --mapa`: el mapa de brillo en SVG, con la escala que se dé resaltada.
    @Test func mapaDeBrillo() {
        let mapa = salida("escalas --mapa")
        #expect(mapa.hasPrefix("<svg "), Comment(rawValue: String(mapa.prefix(200))))
        #expect(mapa.contains(">Mapa de brillo · Do</text>"))
        #expect(salida("escalas --mapa Re dórico").contains(">Mapa de brillo · Re</text>"))
        #expect(salida("escalas --map --notes 5 --ingles").contains(">Brightness map · C</text>"))
        #expect(resultado("escalas", "--mapa", "--orden", "brillo").codigo == 2)
        #expect(resultado("escalas", "--mapa", "--notas", "0").codigo == 2)
    }

    /// `hoja Re dórico`: la hoja de estudio en SVG; sin escala, un error de uso.
    @Test func hojaDeEstudio() {
        let hoja = salida("hoja Re dórico")
        #expect(hoja.hasPrefix("<svg "), Comment(rawValue: String(hoja.prefix(200))))
        #expect(hoja.contains(">Re dórico</text>"))
        #expect(salida("sheet D dorian --ingles").contains(">D dorian</text>"))
        #expect(resultado("hoja").codigo == 2)
        #expect(resultado("hoja").error.contains("armonia hoja Re mayor"))
        // La de un acorde.
        let sol7 = salida("hoja --acorde Sol7")
        #expect(sol7.hasPrefix("<svg "), Comment(rawValue: String(sol7.prefix(200))))
        #expect(sol7.contains(">Sol7</text>"))
        #expect(sol7.contains(">Digitaciones</text>"))
        #expect(salida("sheet --chord G7 --ingles").contains(">G7</text>"))
        #expect(resultado("hoja", "--acorde").codigo == 2)
        #expect(resultado("hoja", "--acorde").error.contains("armonia hoja --acorde Sol7"))
        #expect(resultado("hoja", "--acorde", "Sol7", "Do").codigo == 2)
        // La de una progresión.
        let progresion = salida("hoja --acordes Rem7 Sol7 Do7M --en Do mayor")
        #expect(progresion.hasPrefix("<svg "), Comment(rawValue: String(progresion.prefix(200))))
        #expect(progresion.contains(">Rem7 – Sol7 – Do"))
        #expect(salida("sheet --chords Dm7 G7 Cmaj7 --ingles").contains(">Dm7 – G7 – C"))
        #expect(resultado("hoja", "--acordes").codigo == 2)
        #expect(resultado("hoja", "--acordes").error.contains("armonia hoja --acordes Rem7 Sol7 Do7M"))
        // Con la conducción de las voces y, con --doce, en las doce tonalidades.
        #expect(progresion.contains(">Conducción de voces · Drop 2</text>"))
        let doce = salida("hoja --acordes Rem7 Sol7 Do7M --doce --en Do mayor")
        #expect(doce.contains(">Lam7 Re7 Solmaj7</text>"), Comment(rawValue: String(doce.prefix(800))))
        #expect(salida("hoja --acordes Rem7 Sol7 Do7M --doce").contains(">Sol mayor</text>"))
        #expect(salida("sheet --chords Dm7 G7 Cmaj7 --all-keys --ingles").contains(">G major</text>"))
        // Con --contra, comparada con otra versión.
        let contra = salida("hoja --acordes Do Lam Rem Sol7 --contra Do La7 Rem7 Sol7")
        #expect(contra.contains(">Cambian 2 de 4 acordes</text>"), Comment(rawValue: String(contra.prefix(800))))
        #expect(contra.contains(">Do – La7 – Rem7 – Sol7</text>"))
        let against = salida("sheet --chords C Am Dm G7 --against C A7 Dm7 G7 --ingles")
        #expect(against.contains(">C – A7 – Dm7 – G7</text>"))
        #expect(resultado("hoja", "--acordes", "Do", "--contra").codigo == 2)
        // La de una tonalidad.
        let re = salida("hoja --tonalidad Re mayor")
        #expect(re.hasPrefix("<svg "), Comment(rawValue: String(re.prefix(200))))
        #expect(re.contains(">Re mayor</text>"))
        #expect(re.contains(">Cadencias típicas</text>"))
        #expect(salida("sheet --key D major --ingles").contains(">D major</text>"))
        #expect(resultado("hoja", "--tonalidad").codigo == 2)
        #expect(resultado("hoja", "--tonalidad", "Re", "mayor", "--raro").codigo == 2)
    }

    /// `escala … --escalera`: de la más oscura a la más brillante, con la de partida señalada.
    @Test func escaleraDeBrillo() {
        let mayor = salida("escala Do mayor --escalera")
        #expect(mayor.contains("\nEscalera de brillo:\n"), Comment(rawValue: mayor))
        let tramo = "\n  +1  Do mixolidio · Mi♭ → Mi\n  +2  Do mayor · Si♭ → Si ←\n  +3  Do lidio · Fa → Fa♯\n"
        #expect(mayor.contains(tramo), Comment(rawValue: mayor))
        let ingles = salida("scale C major --brightness-ladder --ingles")
        #expect(ingles.contains("  +3  C lydian · F → F#"), Comment(rawValue: ingles))
    }

    /// `escala … --estadisticas`: lo que se mide de la escala, un dato por línea.
    @Test func estadisticasDeEscala() {
        let mayor = salida("escala Do mayor --estadisticas")
        #expect(mayor.contains("\nEstadísticas:\n  Número de notas: 7 (heptatónica)\n"), Comment(rawValue: mayor))
        #expect(mayor.contains("\n  Brillo por quintas: +2\n"), Comment(rawValue: mayor))
        #expect(mayor.contains("\n  Vector interválico: [2, 5, 4, 3, 6, 1]\n"), Comment(rawValue: mayor))
        #expect(mayor.hasSuffix("\n  Rasgos: máximamente regular\n"), Comment(rawValue: mayor))
        let ingles = salida("scale C lydian --statistics --ingles")
        #expect(ingles.contains("  Brightness by fifths: +3"), Comment(rawValue: ingles))
    }

    @Test func catalogoDeEscalas() {
        let todas = salida("escalas")
        #expect(todas.hasPrefix("habituales ("), Comment(rawValue: todas))
        #expect(todas.contains("Turquía · makam (27)"), Comment(rawValue: todas))
        #expect(todas.contains("  Bayātī: Do Re♭ Mi♭ Fa Sol La♭ Si♭ · microtonos"))
        let turcas = salida("escalas --tradicion turquia")
        #expect(turcas.hasPrefix("Turquía · makam (27)\n"), Comment(rawValue: turcas))
        #expect(turcas.contains("  Hicaz makamı: Do Re♭ Mi Fa Sol La Si♭ · microtonos"), Comment(rawValue: turcas))
        #expect(!turcas.contains("habituales"))
        // Las tradiciones y las categorías se escriben de varias maneras, en español o en inglés.
        #expect(salida("escalas --tradicion Turquía") == turcas)
        #expect(salida("escalas --tradition turkey") == turcas)
        // Turquía tiene makamlar y çeşni; la categoría se queda con los makamlar.
        let makamlar = salida("escalas --categoria makam")
        #expect(turcas.hasPrefix(makamlar) && !makamlar.contains("çeşni"), Comment(rawValue: makamlar))
        let cesniler = salida("escalas --categoria cesni")
        #expect(cesniler.hasPrefix("Turquía · çeşni (12)\n"), Comment(rawValue: cesniler))
        #expect(cesniler.contains("  Hicaz dörtlüsü: Do Re♭ Mi Fa · microtonos"), Comment(rawValue: cesniler))
        #expect(salida("escalas --categoria çeşni") == cesniler)
        #expect(turcas.hasSuffix(cesniler), Comment(rawValue: turcas))
        let ajnas = salida("escalas --categoria jins")
        #expect(ajnas.hasPrefix("Mundo árabe · jins (9)\n"), Comment(rawValue: ajnas))
        #expect(ajnas.contains("  jins Sīkāh: Do Re♭ Mi♭ · microtonos"), Comment(rawValue: ajnas))
        #expect(salida("escalas --tradicion mundo-arabe").hasPrefix("Mundo árabe · maqām ("))
        let bizantinas = salida("escalas --tradicion bizancio")
        #expect(bizantinas.hasPrefix("Bizancio · échos (9)\n"), Comment(rawValue: bizantinas))
        #expect(bizantinas.contains("  échos prótos: Do Re Mi♭ Fa Sol La Si♭ · microtonos"))
        #expect(salida("escalas --tradition byzantium") == bizantinas)
        let babilonicas = salida("escalas --tradicion mesopotamia")
        #expect(babilonicas.hasPrefix("Mesopotamia · afinación (7)\n"), Comment(rawValue: babilonicas))
        #expect(babilonicas.contains("  išartu: Do Re Mi Fa Sol La Si\n"), Comment(rawValue: babilonicas))
        #expect(babilonicas.contains("  nīd qabli: Do Re♭ Mi♭ Fa Sol La♭ Si♭"), Comment(rawValue: babilonicas))
        #expect(salida("escalas --categoria afinacion").hasPrefix(babilonicas))
        #expect(salida("escalas --categoria afinacion").contains("África · afinación (7)\n"))
        let gregorianos = salida("escalas --tradicion gregoriano")
        #expect(gregorianos.hasPrefix("Canto gregoriano · modo gregoriano (8)\n"), Comment(rawValue: gregorianos))
        #expect(gregorianos.contains("  protus plagalis: Do Re Mi♭ Fa Sol La Si♭\n"), Comment(rawValue: gregorianos))
        #expect(salida("escalas --tradition gregorian") == gregorianos)
        #expect(salida("escalas --tradition southeast-asia").hasPrefix("Sudeste asiático · afinación (3)\n"))
        let murchanas = salida("escalas --categoria murchana")
        #expect(murchanas.hasPrefix("India · mūrchanā (14)\n"), Comment(rawValue: murchanas))
        #expect(
            murchanas.contains("  Uttaramandrā: Do Re Mi♭ Fa Sol La Si♭ · microtonos"), Comment(rawValue: murchanas))
        #expect(salida("escalas --categoria grama").hasPrefix("India · grāma (2)\n"))
        let griegas = salida("escalas --tradicion grecia-antigua --categoria tetracordo")
        #expect(griegas.hasPrefix("Grecia antigua · tetracordo (21)\n"), Comment(rawValue: griegas))
        let arquitas = "  tetracordo diatónico de Arquitas: Do Re♭ Mi♭ Fa · microtonos"
        #expect(griegas.contains(arquitas), Comment(rawValue: griegas))
        let thats = salida("escalas --tradicion india --categoria thaat")
        #expect(thats.hasPrefix("India · thāṭ (10)"), Comment(rawValue: thats))
        // Las categorías indias salen en IAST (thāṭ, mēḷa, rāga), pero se encuentran con o sin diacríticos.
        #expect(salida("escalas --tradicion india --categoria thāṭ") == thats)
        #expect(salida("escalas --tradicion india --categoria that") == thats)
        #expect(salida("escalas --categoria melakarta").hasPrefix("India · mēḷa (72)"))
        #expect(salida("escalas --categoria mēḷa") == salida("escalas --categoria melakarta"))
        #expect(salida("escalas --categoria mela") == salida("escalas --categoria melakarta"))
        #expect(salida("escalas --categoria rāga") == salida("escalas --categoria raga"))
        #expect(salida("escalas --tradition turkey --ingles").hasPrefix("Turkey · makam (27)"))
        // Un texto busca en los nombres, sin tildes.
        let hicaz = salida("escalas hicaz")
        #expect(hicaz.contains("Hicaz makamı") && hicaz.contains("Hicazkâr makamı"), Comment(rawValue: hicaz))
        #expect(!hicaz.contains("Bayātī"))
        #expect(salida("escalas bayati").contains("Bayātī"))
        // Sin ninguna, un error de código 1, como lo que no se lee.
        #expect(resultado("escalas", "zzz").error == "armonia: no hay ninguna escala así\n")
        #expect(resultado("escalas", "zzz").codigo == 1)
        #expect(
            LineaDeComandos.ejecutar(["escalas", "--tradicion", "india", "--categoria", "maqam"]).error
                == "armonia: no hay ninguna escala así\n")
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

    @Test func analizarConEscalas() {
        let analisis = salida("analizar Rem7 Sol7 Do7M --en Do mayor --escalas")
        #expect(analisis.contains("\n    Re dórico — Tensiones: Mi 9 · Sol 11 · Si 13\n"))
        #expect(analisis.contains("\n    Sol mixolidio — Tensiones: La 9 · Mi 13 — A evitar: Do 11\n"))
        #expect(analisis.contains("\n    Do mayor — Tensiones: Re 9 · La 13 — A evitar: Fa 11\n"))
        #expect(analisis.contains("\n      Estructuras superiores: Mim · Sol · Do · Lam\n"))
        // Sin --escalas, como siempre.
        #expect(!salida("analizar Rem7 Sol7 Do7M --en Do mayor").contains("dórico"))
        #expect(salida("analyze Dm7 G7 Cmaj7 --in C major --scales --ingles").contains("    D dorian — Tensions:"))
    }

    @Test func estudiarUnaEscala() {
        let terceras = salida("escala Do mayor --secuencia terceras")
        #expect(terceras.contains("\nSecuencia por terceras:\n  Do₄ Mi₄ Re₄ Fa₄ "), Comment(rawValue: terceras))
        #expect(terceras.hasSuffix(" Do₅\n"))
        let bajando = salida("escala Do mayor --secuencia triadas --bajando --octavas 2")
        #expect(bajando.contains("\n  Do₆ La₅ Fa₅ "), Comment(rawValue: bajando))
        #expect(bajando.hasSuffix(" Do₄\n"))
        #expect(salida("escala Do mayor --secuencia grupos-de-3").contains("Secuencia en grupos de tres:"))
        let piano = salida("escala Do mayor --piano")
        let derecha = "\nDigitación de piano:\n  Mano derecha: Do 1 · Re 2 · Mi 3 · Fa 1 · "
        #expect(piano.contains(derecha), Comment(rawValue: piano))
        #expect(piano.contains("\n  Mano izquierda: Do 5 · Re 4 · "))
        let modos = salida("escala Do mayor --modos")
        let lidioPrimero = "\nModos sobre la misma tónica:\n  Do lidio (+1): 4: Fa → Fa♯\n"
        #expect(modos.contains(lidioPrimero), Comment(rawValue: modos))
        #expect(modos.contains("\n  Do mayor (0)\n"))
        #expect(modos.contains("\nModos con las mismas notas:\n  Do mayor · Re dórico · Mi frigio · "))
        let lidio = salida("escala Do mayor --comparar Do lidio")
        let comunes = "\nComparar con Do lidio:\n  Notas comunes: Do, Re, Mi, Sol, La, Si\n"
        #expect(lidio.contains(comunes), Comment(rawValue: lidio))
        #expect(lidio.contains("\n  Solo en Do mayor: Fa\n  Solo en Do lidio: Fa♯\n  4: Fa → Fa♯\n"))
        // --comparar toma las palabras hasta la siguiente opción; sin notas comunes ni distancia en quintas.
        let lejos = salida("escala Do mayor --comparar Fa# pentatónica mayor --piano")
        #expect(lejos.contains("Notas comunes: ninguna"), Comment(rawValue: lejos))
        #expect(lejos.contains("Mano derecha"))
        #expect(!lejos.contains("alteraciones de diferencia"))
        // --contra: la comparación nota a nota en SVG, con los grados que cambian.
        let dorico = salida("escala Do mayor --contra Do dórico")
        #expect(dorico.hasPrefix("<svg "), Comment(rawValue: dorico))
        #expect(dorico.contains(">Do mayor → Do dórico</text>"))
        #expect(dorico.contains(">3: Mi → Mi♭</text>"))
        #expect(dorico.contains(">7: Si → Si♭</text>"))
        #expect(salida("scale C major --against C dorian --ingles").contains(">C major → C dorian</text>"))
        #expect(resultado("escala", "Do", "mayor", "--contra", "Do", "zzz").codigo != 0)
        // --parecidas: las que comparten más notas, con las que se van y las que llegan.
        let parecidas = salida("escala Do mayor --parecidas")
        #expect(parecidas.contains("\nEscalas parecidas:\n  "), Comment(rawValue: parecidas))
        #expect(parecidas.contains("\n  Do lidio: Notas comunes: 6 · −Fa · +Fa♯\n"))
    }

    @Test func conduccionDeUnaProgresion() {
        let conduccion = salida("analizar Rem7 Sol7 Do7M --conduccion")
        #expect(conduccion.contains("\nConducción de voces (Drop 2):\n  Rem7 → Sol7 · Notas comunes: Re, Fa\n    "))
        #expect(conduccion.contains("\n  Sol7 → Domaj7 · Notas comunes: "), Comment(rawValue: conduccion))
        #expect(conduccion.contains("\n  Movimiento total: "))
        #expect(!salida("analizar Rem7 Sol7 Do7M").contains("Conducción"))
        #expect(salida("analyze Dm7 G7 Cmaj7 --voice-leading --ingles").contains("\nVoice leading (Drop 2):\n"))
    }

    @Test func compararDosProgresiones() {
        let comparacion = salida("analizar Do Lam Rem Sol7 --contra Do La7 Rem7 Sol7")
        let cabecera = "\nComparar con Do La7 Rem7 Sol7 (Do mayor):\n  1. Do · I\n"
        #expect(comparacion.contains(cabecera), Comment(rawValue: comparacion))
        #expect(comparacion.contains("\n  2. Lam → La7 · vi → "))
        #expect(comparacion.contains(" · Notas comunes: La, Mi\n"))
        #expect(comparacion.hasSuffix("\n  Cambian 2 de 4 acordes"))
        #expect(!salida("analizar Do Lam Rem Sol7").contains("Comparar con"))
        #expect(resultado("analizar", "Do", "--contra").codigo == 2)
        #expect(resultado("analizar", "Do", "--contra", "Xx").codigo != 0)
    }

    @Test func modulacionesDesdeUnaTonalidad() {
        let vecinas = salida("tonalidad Do mayor --modulaciones")
        #expect(vecinas.contains("\nModulaciones:\n  La menor · "), Comment(rawValue: vecinas))
        let aSol =
            "\n  Sol mayor · acorde común: Do Fa Sol7 Do Lam Re7 Sol (pivote: Lam = vi en Do mayor = ii en Sol mayor)"
        #expect(vecinas.contains(aSol))
        // Con una tonalidad, todas las maneras de llegar a ella; la directa, al final.
        let aLab = salida("tonalidad Do mayor --modulaciones Lab mayor")
        #expect(aLab.contains("\n  La♭ mayor · séptima disminuida enarmónica: "), Comment(rawValue: aLab))
        #expect(aLab.contains("\n  La♭ mayor · directa: "))
        #expect(salida("key C major --modulations --ingles").contains("\nModulations:\n  A minor · "))
        #expect(!salida("tonalidad Do mayor").contains("Modulaciones"))
        #expect(resultado("tonalidad", "--modulaciones").codigo == 2)
        #expect(resultado("tonalidad", "Do", "mayor", "--modulaciones", "zzz").codigo != 0)
    }

    @Test func bebopYPentatonicasSobreUnAcorde() {
        let do7 = salida("acorde Do7 --bebop --pentatonicas")
        #expect(do7.contains("\nEscalas bebop:\n  "), Comment(rawValue: do7))
        #expect(do7.contains(": nota de paso: Si · Do Si Si♭ La Sol Fa Mi Re\n"))
        #expect(do7.contains("\nPentatónicas:\n  "))
        #expect(!salida("acorde Do7").contains("bebop"))
    }

    @Test func notasGuiaAlAnalizar() {
        let analisis = salida("analizar Rem7 Sol7 Do7M --en Do mayor --escalas")
        #expect(analisis.contains("\n      notas guía: Fa, Do\n"), Comment(rawValue: analisis))
        #expect(analisis.contains("\n      notas guía: Si, Fa\n"))
        let cambia = salida("analizar Do La7 Rem7 --en Do mayor --escalas")
        #expect(cambia.contains("cambian: "), Comment(rawValue: cambia))
    }

    @Test func escalaMadre() {
        #expect(salida("escala Re dórico").contains("\n  modo 2 de Do mayor\n"))
        #expect(salida("escala Do alterada").contains("modo 7 de Re♭ menor melódica de jazz"))
        #expect(!salida("escala Do mayor").contains("modo 1"))
    }

    @Test func escalaConTodosSusAcordes() {
        let escala = salida("escala Do mayor --acordes")
        #expect(escala.contains("\n  Acordes que caben:\n    1 · Do: Do · "), Comment(rawValue: escala))
        #expect(escala.contains("\n    5 · Sol: "))
        #expect(!salida("escala Do mayor").contains("Acordes que caben"))
        #expect(salida("scale C major --chords --ingles").contains("\n  Chords that fit:\n    1 · C: C · "))
    }

    @Test func analizarUnArchivo() throws {
        let analisis = try AnalisisArmonico.analizar(leyendo: "Do Lam Re7 Sol7 Do")
        let esperado = salida("analizar Do Lam Re7 Sol7 Do")
        let midi = try fichero(analisis.partitura().midi(), extension: "mid")
        #expect(salida("analizar --archivo " + midi) == esperado)
        let xml = try fichero(Data(analisis.partitura(duracion: .blanca).musicXML().utf8), extension: "musicxml")
        #expect(salida("analyze --file " + xml) == esperado)
        // Aquí cada acorde dura una blanca: con una ventana de una blanca, sale lo mismo.
        #expect(salida("analizar --archivo \(xml) --ventana 2") == esperado)
        #expect(salida("analizar --archivo \(midi) --en Do mayor").hasPrefix("I–vi–V7/V–V7–I en Do mayor\n"))
    }

    @Test func analizarUnArchivoConErrores() throws {
        func resultado(_ orden: String) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(orden.split(separator: " ").map(String.init))
        }
        #expect(resultado("analizar --archivo").codigo == 2)
        let inexistente = resultado("analizar --archivo /no/existe.mid")
        // Un fichero que no se puede leer es un error de lectura, sin remitir a la ayuda.
        #expect(inexistente.codigo == 1)
        #expect(inexistente.error == "armonia: no se puede leer el fichero «/no/existe.mid»\n")
        #expect(resultado("identificar --escalas --archivo /no/existe.mid").codigo == 1)
        let texto = try fichero(Data("hola".utf8), extension: "mid")
        #expect(resultado("analizar --archivo " + texto).codigo == 1)
        #expect(
            resultado("analizar --archivo " + texto).error == "armonia: El fichero no es MIDI, MusicXML, MEI ni ABC.\n")
        #expect(
            resultado("analizar --archivo \(texto) --ingles").error
                == "armonia: The file is not MIDI, MusicXML, MEI or ABC.\n")
        #expect(resultado("analizar Do Sol --archivo " + texto).codigo == 2)
        #expect(resultado("analizar --archivo \(texto) --ventana 3").codigo == 1)
        let melodia = try fichero(Voz(leyendo: "Do4:4 Re4:4 Mi4:4").partitura().midi(), extension: "mid")
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

    @Test func conjunto() {
        #expect(
            salida("conjunto 0 4 7") == """
                [0, 4, 7]  3-11
                  notas: Do Mi Sol
                  forma normal: [0, 4, 7]
                  forma prima: [0, 3, 7]
                  vector interválico: [0, 0, 1, 1, 1, 0]
                  vector de índice: [1, 0, 1, 0, 2, 0, 0, 2, 1, 0, 0, 2]
                  ejes de simetría: —

                """)
        #expect(salida("conjunto 047") == salida("conjunto Do Mi Sol"))
        #expect(salida("conjunto 4-Z15").hasPrefix("[0, 1, 4, 6]  4-Z15"))
        #expect(salida("conjunto 0 3 7 t").contains("ejes de simetría: 5–11"))
        #expect(salida("set 0 3 6 9 --ingles").contains("axes of symmetry: 0–6 · 1½–7½ · 3–9 · 4½–10½"))
        #expect(LineaDeComandos.ejecutar(["conjunto", "0", "x"]).codigo == 1)
        #expect(LineaDeComandos.ejecutar(["conjunto"]).codigo == 2)
    }

    @Test func serie() {
        let berg = salida("serie Fa Mi Do La Sol Re La♭ Re♭ Mi♭ Sol♭ Si♭ Si")
        #expect(berg.hasPrefix("5 4 0 9 7 2 8 1 3 6 t e\n"))
        #expect(berg.contains("  notas: Fa Mi Do La Sol Re La♭ Do♯ Mi♭ Fa♯ Si♭ Si\n"))
        #expect(berg.contains("  intervalos: 11 8 9 10 7 6 5 2 3 4 1  (de todos los intervalos)\n"))
        #expect(berg.contains("  hexacordos: 6-32 · 6-32\n"))
        #expect(berg.contains("  formas combinatorias: P11 I10 R5 RI4\n"))
        #expect(berg.contains("  24 formas distintas\n"))
        #expect(berg.contains("\n       I5   I4   I0   I9   I7   I2   I8   I1   I3   I6   I10  I11\n"))
        #expect(berg.contains("  P5   5    4    0    9    7    2    8    1    3    6    t    e    R5\n"))
        #expect(berg.hasSuffix("RI10 RI11\n"))
        let lineas = berg.split(separator: "\n", omittingEmptySubsequences: false)
        #expect(lineas.count == 22)
        #expect(salida("row 0 e 7 4 2 9 3 8 t 1 5 6 --ingles").contains("combinatorial forms: P6 I5 R0 RI11"))
        let error = LineaDeComandos.ejecutar(["serie", "0", "1", "2"])
        #expect(error.codigo == 1)
        #expect(error.error.contains("faltan 3, 4, 5, 6, 7, 8, 9, 10, 11"))
        #expect(LineaDeComandos.ejecutar(["serie"]).codigo == 2)
    }

    @Test func identificarEscalas() throws {
        let escalas = salida("identificar Do Mi Sol Si Fa# --escalas")
        #expect(escalas.hasPrefix("Do pentatónica lidia\n"), Comment(rawValue: escalas))
        #expect(escalas.contains(" — además: Re, La\n") || escalas.hasSuffix(" — además: Re, La\n"))
        #expect(escalas.split(separator: "\n").count == 10)
        // Con octava, solo cuentan las notas.
        #expect(salida("identificar Do4 Mi4 Sol4 Si4 Fa#5 --escalas") == escalas)
        // Sin --escalas, los acordes de siempre.
        #expect(salida("identificar Do Mi Sol") == salida("identify C E G"))
        let melodia = try fichero(
            Voz(leyendo: "Re4:4 Mi4:4 Fa4:4 Sol4:4 La4:4 Si4:4 Do5:4 Re5:4").partitura().midi(), extension: "mid")
        let deLaMelodia = salida("identificar --archivo " + melodia)
        #expect(!deLaMelodia.split(separator: "\n")[0].contains("además"), Comment(rawValue: deLaMelodia))
        #expect(deLaMelodia.split(separator: "\n").count == 10)
        let enIngles = salida("identify --file \(melodia) --scales --ingles")
        #expect(enIngles.split(separator: "\n").count == 10 && !enIngles.contains("además"))
        let conNotas = LineaDeComandos.ejecutar(["identificar", "--archivo", melodia, "Do"])
        #expect(conNotas.error.hasPrefix("armonia: con --archivo no se escriben notas\n"))
        let inexistente = LineaDeComandos.ejecutar(["identificar", "--archivo", "/no/existe.mid"])
        #expect(inexistente.codigo == 1)
    }

    @Test func escalaSimetrica() {
        let disminuida = salida("escala Do disminuida semitono-tono --simetria")
        #expect(
            disminuida.contains(
                "\nSimetría:\n  Se repite cada 3 semitonos: 3 transposiciones distintas\n"
                    + "  Empieza igual en: Do, Mi♭, Fa♯, La\n"),
            Comment(rawValue: disminuida))
        #expect(disminuida.contains(": Do7 · Mi♭7 · Fa♯7 · La7"))
        #expect(
            salida("escala Do mayor --simetria").hasSuffix(
                "\nSimetría:\n  Se repite cada 12 semitonos: 12 transposiciones distintas\n"))
        #expect(salida("scale C whole tone --symmetry --ingles").contains("\nSymmetry:\n"))
    }

    @Test func lineasDeNotasGuia() {
        let analisis = salida("analizar Rem7 Sol7 Do7M --notas-guia")
        #expect(
            analisis.hasSuffix(
                "\nLíneas de notas guía:\n  Desde la tercera: Fa₄ Fa₄ Mi₄\n  Desde la séptima: Do₄ Si₃ Si₃\n"),
            Comment(rawValue: analisis))
        #expect(salida("analizar Rem7 Sol7 Do7M --notas-guia --en Do mayor").contains("Desde la tercera: Fa₄"))
        #expect(!salida("analizar Rem7 Sol7 Do7M").contains("notas guía"))
    }

    @Test func escalasPropiasVecinasYEnLasDoceTonalidades() {
        #expect(salida("escala Do 2-2-3-2-3") == salida("escala Do pentatónica mayor"))
        #expect(salida("escala Re Mi Fa Sol La Si Do") == salida("escala Re dórico"))
        let rara = salida("escala Do Reb Re Mi Sol")
        #expect(rara.contains("(1-1-2-3-5)"), Comment(rawValue: rara))
        let vecinas = salida("escala Do mayor --vecinas")
        #expect(vecinas.contains("\nEscalas vecinas:\n"), Comment(rawValue: vecinas))
        #expect(vecinas.contains("\n  Do lidio: Fa → Fa♯\n"))
        #expect(vecinas.contains("\n  Do mixolidio: Si → Si♭\n"))
        let doce = salida("escala Do mayor --doce")
        #expect(doce.contains("\nDo mayor · En las doce tonalidades:\n  Do mayor: Do₄ Re₄ "), Comment(rawValue: doce))
        #expect(doce.contains("\n  Sol mayor: Sol₃ La₃ "))
        #expect(doce.contains("\n  Fa mayor: Fa₄ "))
        let terceras = salida("escala Do mayor --doce --secuencia terceras")
        #expect(terceras.contains("\nDo mayor por terceras · En las doce tonalidades:\n  Do mayor: Do₄ Mi₄ Re₄ "))
        let ingles = salida("scale C major --neighbors --all-keys --ingles")
        #expect(ingles.contains("\n  C lydian: F → F#\n"), Comment(rawValue: ingles))
        #expect(ingles.contains("C major · In all twelve keys:"))
    }

    @Test func acordesEnLasDoceTonalidades() {
        let mayor = salida("escala Do mayor --doce --acordes")
        #expect(mayor.contains("\nDo mayor · Acordes en las doce tonalidades:\n  "), Comment(rawValue: mayor))
        #expect(mayor.contains(" · V7 · "))
        #expect(mayor.contains(" · Re7 · "))
        let triadas = salida("escala La menor armónica --doce --acordes --triadas")
        #expect(triadas.contains("Acordes en las doce tonalidades:"), Comment(rawValue: triadas))
        #expect(triadas.contains(" · Mi · Fa · "))
        // Sin --acordes, solo las notas; y una pentatónica no tiene un acorde en cada grado.
        #expect(!salida("escala Do mayor --doce").contains("Acordes en las doce"))
        #expect(!salida("escala Do pentatónica mayor --doce --acordes").contains("Acordes en las doce"))
        #expect(salida("scale C major --all-keys --chords --ingles").contains("C major · Chords in all twelve keys:"))
    }
}
