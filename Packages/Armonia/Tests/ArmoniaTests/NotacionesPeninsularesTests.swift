import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

/// Las notaciones y los textos en catalán, gallego, euskera, portugués, aragonés y asturiano.
final class NotacionesPeninsularesTests: XCTestCase {
    func testCatalanGallegoEuskera() {
        let casos: [(String, String, String, String)] = [
            ("Fa#", "fa sostingut", "fa sostido", "fa diesa"),
            ("Sib", "si bemoll", "si bemol", "si bemol"),
            ("Dox", "do doble sostingut", "do dobre sostido", "do diesa bikoitza"),
            ("Mibb", "mi doble bemoll", "mi dobre bemol", "mi bemol bikoitza"),
            ("Re", "re", "re", "re"),
        ]
        for (espanol, catalan, gallego, euskera) in casos {
            let nombre = Nota(texto: espanol)!
            XCTAssertEqual(nombre.nombre(en: .catalan), catalan)
            XCTAssertEqual(nombre.nombre(en: .gallego), gallego)
            XCTAssertEqual(nombre.nombre(en: .euskera), euskera)
            // Se leen también sin indicar la notación.
            for texto in [catalan, gallego, euskera] {
                XCTAssertEqual(Nota(texto: texto), nombre, texto)
            }
        }
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .catalan), "Re♭")
        XCTAssertEqual(Acorde("Fa#m7").cifrado(en: .gallego), "Fa♯m7")
        XCTAssertEqual(Altura("Fa#3").nombre(en: .catalan), "fa sostingut 3")
        XCTAssertEqual(Altura("fa sostido 3"), Altura("Fa#3"))
        XCTAssertEqual(Altura("si bemol bikoitza 2"), Altura("Sibb2"))
        XCTAssertEqual(Tonalidad("Reb mayor").nombre(en: .catalan), "re bemoll major")
        XCTAssertEqual(Tonalidad("Reb mayor").nombre(en: .gallego), "re bemol maior")
        XCTAssertEqual(Tonalidad("La menor").nombre(en: .euskera), "la minorra")
        XCTAssertEqual(Tonalidad("re bemoll major"), Tonalidad("Reb mayor"))
        XCTAssertEqual(Tonalidad("re bemol maior"), Tonalidad("Reb mayor"))
        XCTAssertEqual(Tonalidad("fa diesa minorra"), Tonalidad("Fa# menor"))
        // Las abreviaturas de los intervalos, como en español; los nombres de los catálogos, traducidos.
        XCTAssertEqual(Notacion.catalan.idiomaDeLasAbreviaturas, .espanol)
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .euskera), "re doriarra")
        XCTAssertEqual(Escala("Reb dórico").nombre(en: .catalan), "re bemoll dòric")
        XCTAssertEqual(Escala("re bemoll dórico"), Escala("Reb dórico"))
        XCTAssertEqual(Escala("re bemoll dòric"), Escala("Reb dórico"))
        XCTAssertEqual(Escala("fa sostido menor armónica"), Escala("Fa# menor armónica"))
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .gallego), "3ª maior")
        XCTAssertEqual(Alteracion(1).nombre(en: .catalan), "sostingut")
        XCTAssertEqual(Alteracion(-2).nombre(en: .gallego), "dobre bemol")
        XCTAssertEqual(Alteracion(2).nombre(en: .euskera), "diesa bikoitza")
        XCTAssertEqual(Alteracion("sostingut"), .sostenido)
        XCTAssertEqual(Alteracion("diesa bikoitza"), .dobleSostenido)
        // Los errores de siempre no cambian.
        XCTAssertNil(Nota(texto: "Fa#4"))
        XCTAssertNil(Altura(texto: "Do"))
    }

    /// Los textos del motor que no son nombres de nota, en catalán, gallego y euskera.
    func testTextosEnCatalanGallegoEuskera() throws {
        XCTAssertEqual(Notacion.catalan.textos, .catalan)
        XCTAssertEqual(Notacion.aleman.textos, .aleman)
        XCTAssertEqual(Notacion.portugues.textos, .portugues)
        XCTAssertEqual(Notacion.espanolASCII.textos, .espanol)

        let sexta = try Intervalo(leyendo: "-6m")
        XCTAssertEqual(sexta.nombre, "6ª menor descendente")
        XCTAssertEqual(sexta.nombre(en: .catalan), "6a menor descendent")
        XCTAssertEqual(sexta.nombre(en: .gallego), "6ª menor descendente")
        XCTAssertEqual(sexta.nombre(en: .euskera), "beheranzko 6. txikia")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .catalan), "3a major")
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .euskera), "3. handia")
        XCTAssertEqual(CalidadDeIntervalo.aumentada(2).nombre(en: .euskera), "bi aldiz gehitua")
        XCTAssertEqual(CalidadDeIntervalo.disminuida(1).nombre(en: .catalan), "disminuïda")
        XCTAssertEqual(CalidadDeIntervalo.justa.nombre(en: .gallego), "xusta")
        XCTAssertEqual(Consonancia.imperfecta.nombre(en: .catalan), "consonància imperfecta")
        XCTAssertEqual(PapelEnAcorde.fundamental.nombre(en: .euskera), "oinarria")
        XCTAssertEqual(PapelEnAcorde.tension(11).nombre(en: .catalan), "onzena")
        XCTAssertEqual(CalidadDeTriada.disminuida.nombre(en: .gallego), "diminuída")
        XCTAssertEqual(NombreDeGrado.sensible.nombre(en: .euskera), "sentsiblea")
        XCTAssertEqual(FuncionTonal.dominante.nombre(en: .catalan), "dominant")
        XCTAssertEqual(Clave.fa.nombre(en: .gallego), "clave de fa")
        XCTAssertEqual(Clave.sol.nombre(en: .euskera), "sol giltza")
        XCTAssertEqual(Duracion(.negra, puntillos: 1).nombre(en: .catalan), "negra amb punt")
        XCTAssertEqual(Duracion(.corchea, puntillos: 1).nombre(en: .euskera), "kortxea puntuduna")
        XCTAssertEqual(Figura.blanca.nombre(en: .gallego), "branca")
        XCTAssertEqual(CorrespondenciaDeColores.circuloDeQuintas.nombre(en: .euskera), "bosgarrenen zirkulua")
        XCTAssertEqual(Cadencia.Tipo.semicadencia.nombre(en: .euskera), "erdi-kadentzia")
        XCTAssertEqual(FaltaDeConduccion.Tipo.quintasParalelas.nombre(en: .catalan), "Quintes paral·leles")
        XCTAssertEqual(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .euskera), "I–IV–V7–I do maiorrean")
        XCTAssertEqual(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .catalan),
            "i–V7–i en la menor")
        // En alemán.
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .aleman), "große Terz")
        // Los catálogos también.
        XCTAssertEqual(Acorde("Sol7").nombre(en: .euskera), "sol dominanteko zazpigarrena, oinarrizko egoera")
        // Todas las traducciones tienen los catorce textos, y cada notación toma el de su idioma.
        let t = Traduccion(
            "es", "en", ca: "ca", gl: "gl", ast: "ast", an: "an", eu: "eu", pt: "pt",
            fr: "fr", oc: "oc", it: "it", de: "de", el: "el", ru: "ru")
        XCTAssertEqual(
            Notacion.allCases.map(t.en),
            [
                "es", "es", "es", "en", "en", "en", "ca", "gl", "ast", "an", "eu", "pt", "fr", "oc", "it", "de", "el",
                "ru",
            ])
        XCTAssertEqual(Idioma.traducidos.count, Idioma.allCases.count)
    }

    /// Los nombres de los catálogos (tipos de acorde y de escala, instrumentos, ciclos) en catalán,
    /// gallego y euskera.
    func testCatalogosEnCatalanGallegoEuskera() {
        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .catalan), "sèptima de dominant")
        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .gallego), "sétima de dominante")
        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .euskera), "dominanteko zazpigarrena")
        XCTAssertEqual(TipoDeAcorde.dominanteSeptima.nombre(en: .portugues), "sétima de dominante")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .catalan), "sol sèptima de dominant, primera inversió")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .gallego), "sol sétima de dominante, primeira inversión")
        XCTAssertEqual(Acorde("Do/Re").nombre(en: .euskera), "do maiorra, baxua re dela")
        XCTAssertEqual(Acorde("Do/Re").nombre(en: .catalan), "do major, amb el baix en re")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .aleman), "Dominantseptakkord auf G, erste Umkehrung")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .occitano), "sòl setena de dominanta, primièra inversion")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .griego), "συγχορδία έβδομης δεσπόζουσας στο σολ, πρώτη αναστροφή")
        XCTAssertEqual(Acorde("Do/Re").nombre(en: .aleman), "Durdreiklang auf C, mit D im Bass")
        // Todos los tipos conocidos tienen nombre propio en cada idioma.
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            XCTAssertFalse(nombre.catalan.isEmpty || nombre.gallego.isEmpty || nombre.euskera.isEmpty, nombre.espanol)
        }

        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .catalan), "re dòric")
        XCTAssertEqual(Escala(.la, .menorArmonica).nombre(en: .gallego), "la menor harmónica")
        XCTAssertEqual(Escala("re doriarra"), Escala("Re dórico"))
        XCTAssertEqual(Escala("fa sostingut lidi"), Escala("Fa# lidio"))
        // Los nombres de otras tradiciones son los mismos en todos los idiomas.
        XCTAssertEqual(Escala(.re, .hirajoshi).nombre(en: .euskera), "re " + TipoDeEscala.hirajoshi.nombre)
        // Cada escala del catálogo tiene nombre en los tres idiomas, y se vuelve a leer igual.
        for tipo in TipoDeEscala.todos {
            for idioma in [Idioma.catalan, .gallego, .euskera] {
                XCTAssertNotNil(NombresDeEscalas.de(idioma).porTipo[tipo], "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.catalan, .gallego, .euskera] {
                let nombre = escala.nombre(en: notacion)
                XCTAssertEqual(Escala(texto: nombre), escala, "\(nombre) (\(tipo.nombre))")
            }
        }

        XCTAssertEqual(InstrumentoDePartitura.clarineteEnSib.nombre(en: .catalan), "clarinet en si♭")
        XCTAssertEqual(InstrumentoDePartitura.violin.nombre(en: .euskera), "biolina")
        XCTAssertEqual(InstrumentoDePartitura.saxofonAlto.nombre(en: .gallego), "saxofón alto")
        for instrumento in InstrumentoDePartitura.todos {
            XCTAssertNotNil(InstrumentoDePartitura.nombresPeninsulares[instrumento.nombre], instrumento.nombre)
        }

        XCTAssertEqual(CicloNeorriemanniano.hexatonico.nombre(en: .catalan), "cicle hexatònic")
        XCTAssertEqual(CicloNeorriemanniano.lr.nombre(en: .euskera), "LR zikloa")
        XCTAssertEqual(
            CicloNeorriemanniano.octatonico.nombre(en: .inglesASCII), CicloNeorriemanniano.octatonico.nombreEnIngles)
    }

    func testPortugues() {
        let casos: [(String, String)] = [
            ("Fa#", "fá sustenido"), ("Sib", "si bemol"), ("Dox", "dó duplo sustenido"),
            ("Mibb", "mi duplo bemol"), ("Re", "ré"), ("La", "lá"), ("Sol", "sol"),
        ]
        for (espanol, portugues) in casos {
            let nombre = Nota(texto: espanol)!
            XCTAssertEqual(nombre.nombre(en: .portugues), portugues)
            // Se lee sin indicar la notación, con o sin tildes.
            XCTAssertEqual(Nota(texto: portugues), nombre, portugues)
            XCTAssertEqual(try Nota(leyendo: portugues, en: .portugues), nombre, portugues)
        }
        XCTAssertEqual(Nota(texto: "fa sustenido"), Nota("Fa#"))
        XCTAssertEqual(Nota("Reb").nombreCompacto(en: .portugues), "Ré♭")
        XCTAssertEqual(Acorde("Fa#m7").cifrado(en: .portugues), "Fá♯m7")
        XCTAssertEqual(Altura("Fa#3").nombre(en: .portugues), "fá sustenido 3")
        XCTAssertEqual(Altura("fá sustenido 3"), Altura("Fa#3"))
        XCTAssertEqual(Tonalidad("Sib mayor").nombre(en: .portugues), "si bemol maior")
        XCTAssertEqual(Tonalidad("La menor").nombre(en: .portugues), "lá menor")
        XCTAssertEqual(Tonalidad("si bemol maior"), Tonalidad("Sib mayor"))
        XCTAssertEqual(Tonalidad("fá sustenido menor"), Tonalidad("Fa# menor"))
        XCTAssertEqual(Escala("ré dórico"), Escala("Re dórico"))
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .portugues), "ré dórico")
        XCTAssertEqual(Alteracion(1).nombre(en: .portugues), "sustenido")
        XCTAssertEqual(Alteracion(-2).nombre(en: .portugues), "duplo bemol")
        XCTAssertEqual(Alteracion(0).nombre(en: .portugues), "bequadro")
        XCTAssertEqual(Alteracion(5).nombre(en: .portugues), "5 sustenidos")
        XCTAssertEqual(Alteracion("sustenido"), .sostenido)
        XCTAssertEqual(Alteracion("duplo bemol"), .dobleBemol)
        XCTAssertEqual(Notacion.portugues.idiomaDeLasAbreviaturas, .espanol)
        XCTAssertEqual(Notacion(escritura: EscrituraDeNotas(idioma: .portugues, ascii: true)), .portugues)
        XCTAssertEqual(EstiloDeCifrado(notacion: .portugues).notacion, .portugues)
    }

    /// Las notas, los textos y los catálogos en aragonés y asturiano.
    func testAragonesYAsturiano() throws {
        XCTAssertEqual(Nota("Fa#").nombre(en: .aragones), "fa sosteniu")
        XCTAssertEqual(Nota("Sib").nombre(en: .asturiano), "si bemol")
        XCTAssertEqual(Nota("Fa#").nombreCompacto(en: .asturiano), "Fa♯")
        XCTAssertEqual(Nota("fa sosteníu"), Nota("Fa#"))
        XCTAssertEqual(try Altura(leyendo: "fa sosteniu 3"), Altura("Fa#3"))
        XCTAssertEqual(Tonalidad("fa sosteníu mayor"), Tonalidad("Fa# mayor"))
        XCTAssertEqual(Intervalo.terceraMayor.nombre(en: .aragones), "3ª mayor")
        XCTAssertEqual(Intervalo.quintaJusta.nombre(en: .asturiano), "5ª xusta")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .asturiano), "sol séptima de dominante, primer inversión")
        XCTAssertEqual(Acorde("Sol7/Si").nombre(en: .aragones), "sol séptima de dominant, primera inversión")
        XCTAssertEqual(Escala(.re, .dorico).nombre(en: .asturiano), "re dóricu")
        XCTAssertEqual(Escala(.mi, .frigio).nombre(en: .aragones), "mi frichio")
        XCTAssertEqual(Escala(texto: "re dóricu"), Escala(.re, .dorico))
        XCTAssertEqual(Tonalidad(.do).lugar(en: .asturiano), "en do mayor")
        XCTAssertEqual(InstrumentoDePartitura.violonchelo.nombre(en: .asturiano), "violonchelu")
        XCTAssertEqual(Encordado(nombre: "baxu"), .bajoElectrico)
        XCTAssertEqual(
            ErrorDeLectura(texto: "", posicion: 0, motivo: .textoVacio).explicacion(en: .asturiano),
            "el testu ta baleru")
        // Las escalas del catálogo se vuelven a leer con su nombre en los dos idiomas.
        for tipo in TipoDeEscala.todos where !TipoDeEscala.nombresTradicionales.contains(tipo.nombre) {
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.aragones, .asturiano] {
                let nombre = escala.nombre(en: notacion)
                XCTAssertEqual(Escala(texto: nombre), escala, "\(nombre) (\(tipo.nombre))")
            }
        }
    }
}
