import Armonia
import Foundation
import Testing

@testable import ConsolaArmonia

// Las pruebas de lo que ayuda a usar la herramienta: la versión, la ayuda de cada orden, lo que se quiso escribir
// ante una errata, la entrada estándar y la salida binaria en la terminal.

extension LineaDeComandosTests {
    @Test func version() {
        for orden in ["--version", "version", "versión", "--version --ingles", "versión --inglés"] {
            #expect(salida(orden) == "armonia \(LineaDeComandos.version)\n", Comment(rawValue: orden))
        }
        #expect(LineaDeComandos.version.split(separator: ".").count == 3)
        #expect(salida("ayuda --todo").contains("--version"))
    }

    /// Las órdenes y las opciones se leen con tildes o sin ellas, y en inglés también con la ortografía británica.
    @Test func conTildesOSinEllas() {
        #expect(salida("cuadrícula Do Mi Sol") == salida("cuadricula Do Mi Sol"))
        #expect(salida("conducción-mínima Do Fa") == salida("conduccion-minima Do Fa"))
        #expect(salida("escala Do mayor --estadísticas") == salida("escala Do mayor --estadisticas"))
        #expect(salida("escala Do mayor --tríadas --inglés") == salida("escala Do mayor --triadas --ingles"))
        #expect(salida("neighbours C") == salida("neighbors C"))
        #expect(salida("escala Do mayor --neighbours") == salida("escala Do mayor --vecinas"))
    }

    /// `ayuda <orden>` y `<orden> --help` dan solo las entradas de esa orden, en el idioma de los textos.
    @Test func ayudaDeUnaOrden() {
        let acorde = salida("ayuda acorde")
        #expect(acorde.hasPrefix("  acorde <cifrado>…"))
        #expect(acorde.contains("armonia acorde Sol7/Si"))
        #expect(!acorde.contains("identificar"))
        for orden in ["acorde --help", "acorde -h", "acorde Do --ayuda", "help chord", "--help acorde", "AYUDA Acorde"]
        {
            #expect(salida(orden) == acorde, Comment(rawValue: orden))
        }
        #expect(salida("ayuda chord --ingles").hasPrefix("  chord <symbol>…"))
        // Una orden con varias entradas las da todas.
        #expect(salida("ayuda tonnetz").contains("tonnetz acorde"))
        // La ayuda de la ayuda y la de la versión.
        #expect(salida("ayuda ayuda").hasPrefix("  ayuda [<orden>]"))
        #expect(salida("ayuda --version").contains("la versión de armonia"))
        // Cada entrada de la ayuda completa está en la de su orden.
        let completa = salida("ayuda --todo")
        for orden in LineaDeComandos.ordenes {
            #expect(completa.contains(salida("ayuda " + orden.nombres[0])), Comment(rawValue: orden.nombres[0]))
        }
        let desconocida = resultado("ayuda", "acrode")
        #expect(desconocida.codigo == 2)
        #expect(
            desconocida.error
                == "armonia: orden desconocida: «acrode»\n¿Querías decir «acorde»?\nPrueba «armonia ayuda».\n")
    }

    /// Una orden o una opción desconocida propone la que más se le parece, y los errores de uso de una orden remiten
    /// a su ayuda.
    @Test func loQueSeQuisoEscribir() {
        #expect(resultado("acordee", "Do").error.contains("¿Querías decir «acorde»?\n"))
        #expect(resultado("identifcar", "Do", "Mi").error.contains("«identificar»"))
        #expect(resultado("tonal", "Do", "mayor").error.contains("«tonalidad»"))
        #expect(
            resultado("chrod", "G7", "--ingles").error
                == "armonia: unknown command: \"chrod\"\nDid you mean \"chord\"?\nTry \"armonia help\".\n")
        #expect(resultado("acordee", "--idioma", "eu").error.contains("«acorde» esan nahi zenuen?"))
        // Lejos de todas, no se propone nada.
        #expect(resultado("foo").error == "armonia: orden desconocida: «foo»\nPrueba «armonia ayuda».\n")
        // Las opciones, entre las de la orden.
        #expect(
            resultado("digitaciones", "Sol7", "--limte", "3").error
                == "armonia: opción desconocida: «--limte»\n¿Querías decir «--limite»?\nPrueba «armonia ayuda digitaciones».\n"
        )
        #expect(resultado("arpegio", "Do7", "--patorn", "alberti").error.contains("«--patron»"))
        #expect(resultado("acorde", "Do", "--jsno").error.contains("«--json»"))
        #expect(LineaDeComandos.propuesta(para: "acorde", entre: ["acorde", "arpegio"]) == nil)
        #expect(LineaDeComandos.distancia("acrode", "acorde") == 1)
        #expect(LineaDeComandos.distancia("", "abc") == 3)
        // Con el nombre que se escribió: «chord», no «acorde».
        #expect(resultado("chord", "--ingles").error.hasSuffix("Try \"armonia help chord\".\n"))
    }

    /// Los errores de lectura empiezan por «armonia:» como los de uso; un guion con una letra es una opción, salvo
    /// que sea un intervalo descendente.
    @Test func mensajesComoLosDemas() {
        let lectura = resultado("acorde", "Xx")
        #expect(lectura.codigo == 1)
        #expect(lectura.error.hasPrefix("armonia: No se puede leer «Xx»"))
        let corta = resultado("acorde", "Do", "-q", "x")
        #expect(corta.codigo == 2)
        #expect(corta.error.hasPrefix("armonia: opción desconocida: «-q»\n"))
        #expect(resultado("tonalidad", "Do", "mayor", "--foo").error.hasPrefix("armonia: opción desconocida: «--foo»"))
        #expect(resultado("intervalo", "Do", "-x").codigo == 2)
        #expect(salida("transponer -m3 Do Fa") == "La Re\n")
        #expect(Argumentos.pareceUnaOpcion("-o"))
        #expect(Argumentos.pareceUnaOpcion("--limite"))
        #expect(!Argumentos.pareceUnaOpcion("-P5"))
        #expect(!Argumentos.pareceUnaOpcion("-2M"))
        #expect(!Argumentos.pareceUnaOpcion("-"))
    }

    /// Una orden que da un fichero binario no lo escribe en la terminal: lo dice, en el idioma de los textos.
    @Test func salidaBinariaEnLaTerminal() {
        let enLaTerminal = LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4"], salidaEsTerminal: true)
        #expect(enLaTerminal.codigo == 2)
        #expect(enLaTerminal.datos == nil)
        #expect(
            enLaTerminal.error
                == "armonia: la salida es un fichero binario (MIDI, PDF o PNG); guárdala con > fichero\n")
        let ingles = LineaDeComandos.ejecutar(["midi", "melodia", "C4:4", "--ingles"], salidaEsTerminal: true)
        #expect(ingles.error.hasPrefix("armonia: the output is a binary file"))
        #expect(LineaDeComandos.ejecutar(["midi", "melodia", "Do4:4"]).datos != nil)
        // El texto sí sale.
        #expect(LineaDeComandos.ejecutar(["acorde", "Do"], salidaEsTerminal: true).codigo == 0)
    }

    /// `-` toma las palabras de la entrada estándar; sin argumentos y sin la terminal, también.
    @Test func entradaEstandar() {
        func con(_ entrada: String, _ argumentos: [String], terminal: Bool = false) -> ResultadoDeOrden {
            LineaDeComandos.ejecutar(argumentos, entrada: { Data(entrada.utf8) }, entradaEsTerminal: terminal)
        }
        let identificar = salida("identificar Do Mi Sol")
        #expect(con("Do Mi Sol\n", ["identificar"]).salida == identificar)
        #expect(con("Do\nMi\n  Sol", ["identificar", "-"]).salida == identificar)
        #expect(con("Do Mi Sol", ["identificar", "-"], terminal: true).salida == identificar)
        // En lugar de `-`, antes de las opciones como --en, que se lleva todo lo que lo sigue.
        // Con opciones detrás hace falta `-`: no se sabe si una palabra es un argumento o el valor de una opción.
        #expect(con("Do Lam", ["analizar", "--en", "Do", "mayor"]).codigo == 2)
        #expect(
            con("Do Lam", ["analizar", "-", "--en", "Do", "mayor"]).salida == salida("analizar Do Lam --en Do mayor"))
        #expect(con("Do Mi Sol", ["identificar", "--json"]).salida == salida("identificar Do Mi Sol --json"))
        // Con la terminal, o con argumentos, no se lee nada.
        #expect(con("Do Mi Sol", ["identificar"], terminal: true).codigo == 2)
        #expect(con("Fa La Do", ["identificar", "Do", "Mi", "Sol"]).salida == identificar)
        // Las órdenes que no leen nada no esperan a la entrada.
        let leida = LockIsolatedFlag()
        let entrada: @Sendable () -> Data = {
            leida.marcar()
            return Data()
        }
        _ = LineaDeComandos.ejecutar(["motores"], entrada: entrada, entradaEsTerminal: false)
        #expect(!leida.marcada)
        // Una entrada vacía es como no escribir nada.
        #expect(con("", ["identificar"]).codigo == 2)
    }

    /// `escalas` busca por el nombre: con unas notas, remite a `identificar --escalas`.
    /// `escala` da la línea de las referencias de una escala, y `--bibtex`, solo sus obras en BibTeX; una sintética de siete
    /// notas tiene a Busoni, y una hexatónica alterada, ninguna.
    @Test func referenciasDeUnaEscala() {
        #expect(
            salida("escala Re bayati").contains(
                "\n  referencias: Maqam World; Touma 1996; Farraj & Abu Shumays 2019; Rechberger 2008\n"))
        #expect(salida("escala Re bayati --ingles").contains("\n  references: Maqam World;"))
        #expect(
            salida("escala Re dórico").contains("\n  referencias: Powers et al. 2001; Levine 1995; Rechberger 2008\n"))
        #expect(salida("escala Re lidio ♯2").contains("\n  referencias: Busoni 1916\n"))
        #expect(!salida("escala Re jónico sin 4ª").contains("referencias"))
        let bib = salida("escala Re bayati --bibtex")
        #expect(bib.hasPrefix("@online{maqamWorld,\n"))
        #expect(bib.contains("@book{touma1996,\n  author = {Touma, Habib Hassan},"))
        #expect(salida("escala Re dórico --bibtex").hasPrefix("@incollection{powers2001,\n"))
        #expect(salida("escala Re lidio ♯2 --bibtex").hasPrefix("@book{busoni1916,\n"))
        #expect(salida("escala Re jónico sin 4ª --bibtex").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    @Test func escalasConNotas() {
        let conNotas = resultado("escalas", "Do", "Mi", "Sol", "La")
        #expect(conNotas.codigo == 1)
        #expect(
            conNotas.error
                == "armonia: no hay ninguna escala con ese nombre; para buscarla por sus notas: "
                + "armonia identificar --escalas Do Mi Sol La\n")
        #expect(resultado("escalas", "C", "E", "G", "--ingles").error.contains("armonia identify --scales C E G"))
        #expect(salida("identificar --escalas Do Mi Sol La").contains("pentatónica"))
    }

    /// `grabar midi …` explica que midi ya escribe la partitura y cómo se graba.
    @Test func grabarUnaPartitura() {
        for orden in ["midi", "musicxml", "lilypond"] {
            let error = resultado("grabar", orden, "Do", "Re").error
            #expect(error.hasPrefix("armonia: «armonia \(orden)» ya escribe la partitura"), Comment(rawValue: error))
            #expect(error.contains("armonia grabar melodia Do4:4 Re4:4 > melodia.pdf"))
        }
        #expect(resultado("engrave", "midi", "C", "--ingles").error.contains("armonia engrave melody C4:4 D4:4"))
    }

    /// `--archivo -` lee el fichero de la entrada estándar.
    @Test func archivoDeLaEntrada() throws {
        let midi = try Voz(leyendo: "Do4:4 Re4:4 Mi4:4").partitura().midi()
        let ruta = try fichero(midi, extension: "mid")
        for orden in [["identificar", "--archivo"], ["musicxml", "melodia", "--archivo"], ["analizar", "--archivo"]] {
            let conEntrada = LineaDeComandos.ejecutar(orden + ["-"], entrada: { midi }, entradaEsTerminal: false)
            #expect(conEntrada == LineaDeComandos.ejecutar(orden + [ruta]), "\(orden)")
        }
        let acordes = try AnalisisArmonico.analizar(leyendo: "Do Fa Sol7 Do").partitura().midi()
        let analisis = LineaDeComandos.ejecutar(
            ["analizar", "--file", "-"], entrada: { acordes }, entradaEsTerminal: false)
        #expect(analisis.salida.hasPrefix("I–IV–V7–I en Do mayor"), Comment(rawValue: analisis.error))
        // Sin entrada estándar, `-` es un fichero que no se puede leer.
        #expect(resultado("analizar", "--archivo", "-").error.hasPrefix("armonia: no se puede leer el fichero «-»"))
    }

    /// Los valores de `--idioma`, `--textos` y `--escritura` también proponen el más parecido.
    @Test func idiomaYEscrituraParecidos() {
        #expect(resultado("acorde", "Do", "--idioma", "eus").error.contains("¿Querías decir «eu»?"))
        #expect(resultado("acorde", "Do", "--idioma", "deutch").error.contains("«deutsch»"))
        #expect(resultado("acorde", "Do", "--textos", "catalam").error.contains("«catalán»"))
        #expect(resultado("acorde", "Do", "--escritura", "palabra").error.contains("«palabras»"))
        #expect(
            resultado("acorde", "Do", "--escritura", "unicod", "--ingles").error.contains("Did you mean \"unicode\"?"))
        #expect(!resultado("acorde", "Do", "--idioma", "xyzzy").error.contains("¿Querías"))
    }

    /// `progresiones` da cada progresión del catálogo con su cifrado y sus acordes sobre Do; con un texto, las que lo
    /// tienen en el nombre en algún idioma, y con `--en`, sobre otra tónica.
    @Test func progresiones() {
        let todas = salida("progresiones").split(separator: "\n")
        #expect(todas.count == ProgresionConNombre.catalogo.count)
        #expect(todas.contains("monte: V7/IV IV V7/V V · Do7 Fa Re7 Sol"))
        #expect(todas.contains("cadencia andaluza: i VII VI V · Dom Si♭ La♭ Sol"))
        #expect(salida("progresiones andaluza --en La") == "cadencia andaluza: i VII VI V · Lam Sol Fa Mi\n")
        #expect(salida("progresiones andaluza --en La menor") == salida("progresiones andaluza --en La"))
        // El nombre exacto da solo esa; si no, todas las que lo contienen.
        #expect(salida("progressions ii-V-I --in Bb --ingles") == "ii–V–I: ii7 V7 Imaj7 · Cm7 F7 Bbmaj7\n")
        #expect(salida("progresiones cadencia").split(separator: "\n").count == 11)
        #expect(salida("progresiones Trugschluss --idioma de") == "Trugschluss: V7 vi · G7 Am\n")
        #expect(resultado("progresiones", "zzz").error.contains("no hay ninguna progresión así"))
        #expect(resultado("progresiones", "blues", "--en").error.contains("falta la tonalidad tras --en"))
    }

    /// `acordes` da cada acorde del catálogo con sus notas sobre Do y su cifrado, si se lee por terceras; con un
    /// texto, los que lo tienen en el nombre en algún idioma, y con `--sobre`, sobre otra nota.
    @Test func acordesDelCatalogo() {
        let todos = salida("acordes").split(separator: "\n")
        #expect(todos.count == AcordeConNombre.catalogo.count)
        #expect(todos.contains("séptima de dominante (Do7): Do Mi Sol Si♭"))
        #expect(salida("acordes tristan --sobre Fa") == "acorde de Tristán: Fa Si Re♯ Sol♯\n")
        #expect(salida("chords dominant seventh --over G --ingles") == "dominant seventh (G7): G B D F\n")
        #expect(salida("acordes sexta aumentada").split(separator: "\n").count == 4)
        #expect(resultado("acordes", "zzz").error.contains("no hay ningún acorde así"))
    }

    /// `acordes` filtra por el número de notas (o su cardinal), el estilo, si se lee por terceras y los intervalos;
    /// ordena por brillo o por notas, y da la tabla de estadísticas o el resumen del catálogo.
    @Test func acordesPorSusEstadisticas() {
        let tetradas = salida("acordes --notas 4").split(separator: "\n")
        #expect(tetradas.count == AcordeConNombre.todos(numeroDeNotas: 4).count)
        #expect(salida("acordes --notas tétrada") == salida("acordes --notas 4"))
        #expect(salida("chords --notes tetrad --ingles") == salida("acordes --notas 4 --ingles"))
        #expect(salida("acordes --notas 2") == "quinta (acorde de potencia) (Do5): Do Sol\n")
        #expect(salida("acordes --no-por-terceras").contains("acorde de Petrushka"))
        #expect(!salida("acordes --por-terceras").contains("acorde de Petrushka"))
        #expect(salida("acordes --uso jazz --notas 4") == "acorde por cuartas: Do Fa Si♭ Mi♭\n")
        #expect(!salida("acordes --sin-semitonos").contains("séptima mayor (Domaj7)"))
        #expect(salida("acordes --sin-intervalo tritono --notas 3").contains("mayor (Do): Do Mi Sol"))
        #expect(!salida("acordes --con-intervalo tritono --notas 3").contains("mayor (Do): Do Mi Sol"))
        // Del más brillante al más oscuro: la séptima disminuida, la última de las tétradas por terceras.
        let porBrillo = salida("acordes --orden brillo --notas 4 --por-terceras").split(separator: "\n")
        #expect(porBrillo.last == "séptima disminuida (Do°7): Do Mi♭ Sol♭ Si𝄫")
        // La tabla: una fila por acorde, más la de los encabezados.
        let tabla = salida("acordes --estadisticas --notas 3").split(separator: "\n")
        #expect(tabla.count == AcordeConNombre.todos(numeroDeNotas: 3).count + 1)
        #expect(tabla[0].hasPrefix("Acorde"))
        #expect(tabla[1].contains("3-11"))
        // El resumen.
        let resumen = salida("acordes --resumen")
        #expect(resumen.hasPrefix("Acordes: \(AcordeConNombre.catalogo.count)\n"))
        #expect(resumen.contains("  4 (tétrada): \(AcordeConNombre.todos(numeroDeNotas: 4).count)\n"))
        #expect(resumen.contains("No se lee por terceras: "))
        #expect(salida("chords --summary --ingles").contains("  3 (triad): "))
        #expect(resultado("acordes", "--notas", "veinte").error.contains("--notas 5"))
    }

    /// `acorde --estadisticas` da lo que se mide de cada acorde.
    @Test func estadisticasDeUnAcorde() {
        let sol7 = salida("acorde Sol7 --estadisticas")
        #expect(sol7.contains("Estadísticas:\n  Número de notas: 4 (tétrada)\n"))
        #expect(sol7.contains("  Número de Forte: 4-27\n"))
        #expect(sol7.contains("  Rasgos: anhemitónico (sin semitonos) · con tritono\n"))
        #expect(salida("acorde Do/Re --estadisticas").contains("Número de notas: 4 (tétrada)"))
        #expect(salida("chord C --statistics --ingles").contains("Number of notes: 3 (triad)"))
        // Las medidas de la teoría: Huron, Hindemith, Parncutt, Euler, Cook, Sethares…
        #expect(sol7.contains("  Consonancia diádica (Huron): 1.779\n"))
        #expect(sol7.contains("  Grupo de Hindemith: II a\n  Fundamental (Hindemith): Sol\n"))
        #expect(sol7.contains("  Intervalos entre voces (semitonos): 4 3 3\n"))
        #expect(sol7.contains("  Gradus suavitatis (Euler): 11\n"))
        #expect(sol7.contains("  Tríadas contenidas: M 1 · m 0 · ° 1 · + 0\n"))
        let json = salida("acorde Sol7 --estadisticas --json")
        #expect(json.contains("\"grupoDeHindemith\":\"II a\""))
        #expect(json.contains("\"consonanciaDiadica\":1.779"))
        #expect(sol7.contains("  Límite impar (Partch): 45\n"))
        #expect(sol7.contains("  Fundamental virtual (Terhardt): Sol\n"))
        #expect(sol7.contains("  Disposición: Cerrada · intervalos anchos abajo (serie armónica)\n"))
        #expect(json.contains("\"limiteImpar\":45"))
        #expect(json.contains("\"complemento\":\"8-27\""))
        // `acordes --orden consonancia`: de la más consonante a la menos.
        #expect(salida("acordes --orden consonancia --notas 3").hasPrefix("mayor (Do): Do Mi Sol\n"))
        #expect(
            salida("chords --sort consonance --notes 3 --ingles")
                == salida("acordes --orden consonancia --notas 3 --ingles"))
        #expect(resultado("acordes", "--orden", "consonante").error.contains("--orden consonancia"))
    }

    /// `tradiciones` da cada tradición con sus categorías (salvo la occidental, que no tiene: sus escalas son las
    /// habituales, por estilos con `escalas --uso`); con una, sus escalas.
    @Test func tradiciones() throws {
        let todas = salida("tradiciones")
        let lineas = todas.split(separator: "\n")
        #expect(lineas.count == Tradicion.allCases.count - 1)
        #expect(lineas.contains("Japón (japon): escala 13"))
        #expect(lineas.contains("Turquía (turquia): makam 27 · çeşni 12"))
        #expect(salida("traditions --ingles").contains("Japan (japan): scale 13"))
        #expect(salida("tradiciones --idioma eu").contains("Japonia (japon)"))
        // Lo que dice cada línea suma lo que da `escalas --tradicion`.
        #expect(salida("tradiciones japon") == salida("escalas --tradicion japon"))
        #expect(salida("tradiciones india --categoria thaat") == salida("escalas --tradicion india --categoria thaat"))
        #expect(salida("tradiciones japon").hasPrefix("Japón · escala (13)\n"))
        // Una errata en la tradición o en la categoría propone la más parecida.
        #expect(resultado("tradiciones", "japn").error.contains("¿Querías decir «japon»?"))
        #expect(resultado("escalas", "--categoria", "maqm").error.contains("«maqam»"))
        // `--fuente`: las escalas de un teórico, por su clave o por su nombre en español o en inglés.
        let dePtolomeo = salida("escalas --fuente ptolomeo")
        #expect(dePtolomeo.hasPrefix("Grecia antigua · tetracordo (7)\n"))
        #expect(!dePtolomeo.contains("Habituales"))
        #expect(salida("escalas --fuente Ptolomeo") == dePtolomeo)
        #expect(salida("escalas --source ptolemy") == dePtolomeo)
        #expect(salida("scales --source ptolemy --ingles").hasPrefix("Ancient Greece · tetrachord (7)\n"))
        #expect(salida("escalas --fuente glareano --tradicion gregoriano").contains("ionicus"))
        #expect(salida("escalas --fuente guido --categoria hexacordo").hasPrefix("Canto gregoriano · hexacordo (3)\n"))
        #expect(resultado("escalas", "--fuente", "ptolomeu").error.contains("«ptolomeo»"))
        // Y las que afinó: Zarlino no definió las escalas del Renacimiento, pero las midió.
        #expect(salida("escalas --fuente zarlino").hasPrefix("Renacimiento · "))
        #expect(salida("escalas --fuente chrysanthos").contains("(6)"))
        #expect(resultado("escalas", "--fuente", "pitagoras").codigo == 2)
        #expect(resultado("tradiciones", "--foo").codigo == 2)
        // En JSON, las claves de --tradicion y --categoria y los números.
        let json = try #require(try json("tradiciones") as? [[String: Any]])
        let japon = try #require(json.first { $0["clave"] as? String == "japon" })
        #expect(japon["nombre"] as? String == "Japón")
        #expect(japon["escalas"] as? Int == 13)
        let india = try #require(json.first { $0["clave"] as? String == "india" })
        let categorias = try #require(india["categorias"] as? [[String: Any]])
        #expect(categorias.contains { $0["clave"] as? String == "melakarta" && $0["escalas"] as? Int == 72 })
        #expect(LineaDeComandos.ejecutar(["tradiciones", "japon", "--json"]).codigo == 2)
        // El nombre de cada tradición, en los trece idiomas.
        for tradicion in Tradicion.allCases {
            let nombres = Idioma.allCases.map { tradicion.nombre(en: .delIdioma($0)) }
            #expect(nombres.allSatisfy { !$0.isEmpty })
        }
        #expect(Tradicion.mundoArabe.nombre == "Mundo árabe")
        #expect(Tradicion.japon.nombre(en: .delIdioma(.ruso)) == "Япония")
    }

    @Test func arpegioEnJSON() throws {
        let arpegios = try #require(try json("arpegio Do7 Lam --patron alberti") as? [[String: Any]])
        #expect(arpegios.count == 2)
        let do7 = arpegios[0]
        #expect(do7["acorde"] as? String == "Do7")
        #expect(do7["recorrido"] as? String == "bajo de Alberti")
        #expect(do7["midi"] as? [Int] == [60, 70, 64, 70])
        #expect((do7["notas"] as? [String])?.first == "Do₄")
        #expect((do7["escalas"] as? [String])?.contains("Do mixolidio") == true)
        let grados = try #require(try json("arpegio Do --grados 1-5-3-8") as? [[String: Any]])
        #expect(grados[0]["recorrido"] as? String == "1-5-3-8")
        #expect(LineaDeComandos.ejecutar(["arpegio", "Do7", "--patron", "foo", "--json"]).codigo == 2)
    }

    @Test func intervaloEnJSON() throws {
        let decima = try #require(try json("intervalo Do4 Mi5") as? [String: Any])
        #expect(decima["semitonos"] as? Int == 16)
        #expect(decima["numero"] as? Int == 10)
        #expect(decima["abreviatura"] as? String == "10M")
        #expect(decima["descendente"] as? Bool == false)
        #expect(LineaDeComandos.ejecutar(["intervalo", "Do", "--json"]).codigo == 2)
    }

    @Test func tonalidadEnJSON() throws {
        let mib = try #require(try json("tonalidad Mib mayor") as? [String: Any])
        #expect(mib["nombre"] as? String == "Mi♭ mayor")
        #expect(mib["modo"] as? String == "mayor")
        #expect(mib["armadura"] as? Int == -3)
        #expect(mib["alteraciones"] as? [String] == ["Si♭", "Mi♭", "La♭"])
        #expect(mib["relativa"] as? String == "Do menor")
        #expect((mib["clases"] as? [Int])?.first == 3)
        let acordes = try #require(mib["acordes"] as? [[String: String]])
        #expect(acordes.count == 7)
        #expect(acordes[4] == ["grado": "V7", "cifrado": "Si♭7"])
        // El modo no se traduce.
        let menor = try #require(try json("tonalidad A minor --ingles") as? [String: Any])
        #expect(menor["modo"] as? String == "menor")
        #expect(menor["nombre"] as? String == "A minor")
    }

    @Test func digitacionesEnJSON() throws {
        let acordes = try #require(try json("digitaciones Do Sol7 --limite 2") as? [[String: Any]])
        #expect(acordes.count == 2)
        #expect(acordes[0]["instrumento"] as? String == "guitarra")
        #expect(acordes[0]["capo"] as? Int == 0)
        let formas = try #require(acordes[0]["formas"] as? [[String: Any]])
        #expect(formas.count == 2)
        #expect(formas[0]["tablatura"] as? String == "x32010")
        #expect(formas[0]["trastes"] as? [Any?] != nil)
        let trastes = try #require(formas[0]["trastes"] as? [Any])
        #expect(trastes.first is NSNull)
        #expect(trastes.dropFirst().compactMap { $0 as? Int } == [3, 2, 0, 1, 0])
        #expect(formas[0]["notas"] as? [String] == ["Do", "Mi", "Sol", "Do", "Mi"])
        // Las mismas formas que el texto.
        #expect(salida("digitaciones Do --limite 2").contains("x32010"))
        let ukelele = try #require(
            try json("digitaciones C --instrument ukulele --capo 2 --ingles") as? [[String: Any]])
        #expect(ukelele[0]["capo"] as? Int == 2)
        #expect(ukelele[0]["instrumento"] as? String == "ukulele")
        #expect(LineaDeComandos.ejecutar(["digitaciones", "Do", "--limite", "0", "--json"]).codigo == 2)
    }
}

/// Una marca que se puede poner desde un cierre que no es `Sendable`.
private final class LockIsolatedFlag: @unchecked Sendable {
    private(set) var marcada = false
    func marcar() { marcada = true }
}
