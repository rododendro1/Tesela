import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaDiagramas
@testable import ArmoniaElementos
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria
@testable import ArmoniaTrastes

/// Las notaciones y los textos en catalán, gallego, euskera, portugués, aragonés y asturiano.
@Suite struct NotacionesPeninsularesTests {
    @Test func catalanGallegoEuskera() {
        let casos: [(String, String, String, String)] = [
            ("Fa#", "fa sostingut", "fa sostido", "fa diesa"),
            ("Sib", "si bemoll", "si bemol", "si bemol"),
            ("Dox", "do doble sostingut", "do dobre sostido", "do diesa bikoitza"),
            ("Mibb", "mi doble bemoll", "mi dobre bemol", "mi bemol bikoitza"),
            ("Re", "re", "re", "re"),
        ]
        for (espanol, catalan, gallego, euskera) in casos {
            let nombre = try! Nota(leyendo: espanol)
            #expect(nombre.nombre(en: .conPalabras(.catalan)) == catalan)
            #expect(nombre.nombre(en: .conPalabras(.gallego)) == gallego)
            #expect(nombre.nombre(en: .conPalabras(.euskera)) == euskera)
            // Se leen también sin indicar la notación.
            for texto in [catalan, gallego, euskera] {
                #expect((try? Nota(leyendo: texto)) == nombre, Comment(rawValue: texto))
            }
        }
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.catalan)) == "Re♭")
        #expect(Acorde("Fa#m7").cifrado(en: .conPalabras(.gallego)) == "Fa♯m7")
        #expect(Altura("Fa#3").nombre(en: .conPalabras(.catalan)) == "fa sostingut 3")
        #expect(Altura("fa sostido 3") == Altura("Fa#3"))
        #expect(Altura("si bemol bikoitza 2") == Altura("Sibb2"))
        #expect(Tonalidad("Reb mayor").nombre(en: .conPalabras(.catalan)) == "re bemoll major")
        #expect(Tonalidad("Reb mayor").nombre(en: .conPalabras(.gallego)) == "re bemol maior")
        #expect(Tonalidad("La menor").nombre(en: .conPalabras(.euskera)) == "la minorra")
        #expect(Tonalidad("re bemoll major") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("re bemol maior") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("fa diesa minorra") == Tonalidad("Fa# menor"))
        // Las abreviaturas de los intervalos, como en español; los nombres de los catálogos, traducidos.
        #expect(Notacion.conPalabras(.catalan).idiomaDeLasAbreviaturas == .espanol)
        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.euskera)) == "re doriarra")
        #expect(Escala("Reb dórico").nombre(en: .conPalabras(.catalan)) == "re bemoll dòric")
        #expect(Escala("re bemoll dórico") == Escala("Reb dórico"))
        #expect(Escala("re bemoll dòric") == Escala("Reb dórico"))
        #expect(Escala("fa sostido menor armónica") == Escala("Fa# menor armónica"))
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.gallego)) == "3ª maior")
        #expect(Alteracion(1).nombre(en: .conPalabras(.catalan)) == "sostingut")
        #expect(Alteracion(-2).nombre(en: .conPalabras(.gallego)) == "dobre bemol")
        #expect(Alteracion(2).nombre(en: .conPalabras(.euskera)) == "diesa bikoitza")
        #expect(Alteracion("sostingut") == .sostenido)
        #expect(Alteracion("diesa bikoitza") == .dobleSostenido)
        // Los errores de siempre no cambian.
        #expect((try? Nota(leyendo: "Fa#4")) == nil)
        #expect((try? Altura(leyendo: "Do")) == nil)
    }

    /// Los textos del motor que no son nombres de nota, en catalán, gallego y euskera.
    @Test func textosEnCatalanGallegoEuskera() throws {
        #expect(Notacion.conPalabras(.catalan).textos == .catalan)
        #expect(Notacion.conPalabras(.aleman).textos == .aleman)
        #expect(Notacion.conPalabras(.portugues).textos == .portugues)
        #expect(Notacion.espanolASCII.textos == .espanol)

        let sexta = try Intervalo(leyendo: "-6m")
        #expect(sexta.nombre == "6ª menor descendente")
        #expect(sexta.nombre(en: .conPalabras(.catalan)) == "6a menor descendent")
        #expect(sexta.nombre(en: .conPalabras(.gallego)) == "6ª menor descendente")
        #expect(sexta.nombre(en: .conPalabras(.euskera)) == "beheranzko 6. txikia")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.catalan)) == "3a major")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.euskera)) == "3. handia")
        #expect(CalidadDeIntervalo.aumentada(2).nombre(en: .conPalabras(.euskera)) == "bi aldiz gehitua")
        #expect(CalidadDeIntervalo.disminuida(1).nombre(en: .conPalabras(.catalan)) == "disminuïda")
        #expect(CalidadDeIntervalo.justa.nombre(en: .conPalabras(.gallego)) == "xusta")
        #expect(Consonancia.imperfecta.nombre(en: .conPalabras(.catalan)) == "consonància imperfecta")
        #expect(PapelEnAcorde.fundamental.nombre(en: .conPalabras(.euskera)) == "oinarria")
        #expect(PapelEnAcorde.tension(11).nombre(en: .conPalabras(.catalan)) == "onzena")
        #expect(CalidadDeTriada.disminuida.nombre(en: .conPalabras(.gallego)) == "diminuída")
        #expect(NombreDeGrado.sensible.nombre(en: .conPalabras(.euskera)) == "sentsiblea")
        #expect(FuncionTonal.dominante.nombre(en: .conPalabras(.catalan)) == "dominant")
        #expect(Clave.fa.nombre(en: .conPalabras(.gallego)) == "clave de fa")
        #expect(Clave.sol.nombre(en: .conPalabras(.euskera)) == "sol giltza")
        #expect(Duracion(.negra, puntillos: 1).nombre(en: .conPalabras(.catalan)) == "negra amb punt")
        #expect(Duracion(.corchea, puntillos: 1).nombre(en: .conPalabras(.euskera)) == "kortxea puntuduna")
        #expect(Figura.blanca.nombre(en: .conPalabras(.gallego)) == "branca")
        #expect(CorrespondenciaDeColores.circuloDeQuintas.nombre(en: .conPalabras(.euskera)) == "bosgarrenen zirkulua")
        #expect(Cadencia.Tipo.semicadencia.nombre(en: .conPalabras(.euskera)) == "erdi-kadentzia")
        #expect(FaltaDeConduccion.Tipo.quintasParalelas.nombre(en: .conPalabras(.catalan)) == "Quintes paral·leles")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .conPalabras(.euskera))
                == "I–IV–V7–I do maiorrean")
        #expect(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .conPalabras(.catalan))
                == "i–V7–i en la menor")
        // En alemán.
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.aleman)) == "große Terz")
        // Los catálogos también.
        #expect(Acorde("Sol7").nombre(en: .conPalabras(.euskera)) == "sol dominanteko zazpigarrena, oinarrizko egoera")
        // Todas las traducciones tienen los quince textos, y cada notación toma el de su idioma.
        let t = Traduccion(
            "es", "en", ca: "ca", gl: "gl", ast: "ast", an: "an", eu: "eu", pt: "pt",
            fr: "fr", oc: "oc", it: "it", de: "de", el: "el", ru: "ru", hu: "hu")
        #expect(
            Notacion.allCases.map(t.en) == [
                "es", "es", "es", "en", "en", "en", "ca", "ca", "gl", "gl", "ast", "ast", "an", "an", "eu", "eu", "pt",
                "pt", "fr", "fr", "oc", "oc", "it", "it", "de", "de", "el", "el", "ru", "ru", "hu", "hu",
            ])
        #expect(Idioma.allCases.count == Idioma.allCases.count)
    }

    /// Los nombres de los catálogos (tipos de acorde y de escala, instrumentos, ciclos) en catalán,
    /// gallego y euskera.
    @Test func catalogosEnCatalanGallegoEuskera() {
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.catalan)) == "sèptima de dominant")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.gallego)) == "sétima de dominante")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.euskera)) == "dominanteko zazpigarrena")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .conPalabras(.portugues)) == "sétima de dominante")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.catalan)) == "sol sèptima de dominant, primera inversió")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.gallego)) == "sol sétima de dominante, primeira inversión")
        #expect(Acorde("Do/Re").nombre(en: .conPalabras(.euskera)) == "do maiorra, baxua re dela")
        #expect(Acorde("Do/Re").nombre(en: .conPalabras(.catalan)) == "do major, amb el baix en re")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.aleman)) == "Dominantseptakkord auf G, erste Umkehrung")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.occitano)) == "sòl setena de dominanta, primièra inversion")
        #expect(
            Acorde("Sol7/Si").nombre(en: .conPalabras(.griego))
                == "συγχορδία έβδομης δεσπόζουσας στο σολ, πρώτη αναστροφή")
        #expect(Acorde("Do/Re").nombre(en: .conPalabras(.aleman)) == "Durdreiklang auf C, mit D im Bass")
        // Todos los tipos conocidos tienen nombre propio en cada idioma.
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            #expect(
                !(nombre.catalan.isEmpty || nombre.gallego.isEmpty || nombre.euskera.isEmpty),
                Comment(rawValue: nombre.espanol))
        }

        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.catalan)) == "re dòric")
        #expect(Escala(.la, .menorArmonica).nombre(en: .conPalabras(.gallego)) == "la menor harmónica")
        #expect(Escala("re doriarra") == Escala("Re dórico"))
        #expect(Escala("fa sostingut lidi") == Escala("Fa# lidio"))
        // Los nombres de otras tradiciones son los mismos en todos los idiomas.
        #expect(Escala(.re, .hirajoshi).nombre(en: .conPalabras(.euskera)) == ("re " + TipoDeEscala.hirajoshi.nombre))
        // Cada escala del catálogo tiene nombre en los tres idiomas, y se vuelve a leer igual.
        for tipo in TipoDeEscala.occidentales {
            for idioma in [Idioma.catalan, .gallego, .euskera] {
                #expect(NombresDeEscalas.de(idioma).porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.conPalabras(.catalan), .conPalabras(.gallego), .conPalabras(.euskera)] {
                let nombre = escala.nombre(en: notacion)
                #expect((try? Escala(leyendo: nombre)) == escala, "\(nombre) (\(tipo.nombre))")
            }
        }

        #expect(InstrumentoDePartitura.clarineteEnSib.nombre(en: .conPalabras(.catalan)) == "clarinet en si♭")
        #expect(InstrumentoDePartitura.violin.nombre(en: .conPalabras(.euskera)) == "biolina")
        #expect(InstrumentoDePartitura.saxofonAlto.nombre(en: .conPalabras(.gallego)) == "saxofón alto")
        for instrumento in InstrumentoDePartitura.todos {
            #expect(
                InstrumentoDePartitura.traducciones[instrumento.nombre] != nil, Comment(rawValue: instrumento.nombre))
        }

        #expect(CicloNeorriemanniano.hexatonico.nombre(en: .conPalabras(.catalan)) == "cicle hexatònic")
        #expect(CicloNeorriemanniano.lr.nombre(en: .conPalabras(.euskera)) == "LR zikloa")
        #expect(
            CicloNeorriemanniano.octatonico.nombre(en: .inglesASCII) == CicloNeorriemanniano.octatonico.nombreEnIngles)
    }

    @Test func portugues() throws {
        let casos: [(String, String)] = [
            ("Fa#", "fá sustenido"), ("Sib", "si bemol"), ("Dox", "dó duplo sustenido"),
            ("Mibb", "mi duplo bemol"), ("Re", "ré"), ("La", "lá"), ("Sol", "sol"),
        ]
        for (espanol, portugues) in casos {
            let nombre = try! Nota(leyendo: espanol)
            #expect(nombre.nombre(en: .conPalabras(.portugues)) == portugues)
            // Se lee sin indicar la notación, con o sin tildes.
            #expect((try? Nota(leyendo: portugues)) == nombre, Comment(rawValue: portugues))
            #expect(
                try (Nota(leyendo: portugues, en: .conPalabras(.portugues))) == nombre, Comment(rawValue: portugues))
        }
        #expect((try? Nota(leyendo: "fa sustenido")) == Nota("Fa#"))
        #expect(Nota("Reb").nombreCompacto(en: .conPalabras(.portugues)) == "Ré♭")
        #expect(Acorde("Fa#m7").cifrado(en: .conPalabras(.portugues)) == "Fá♯m7")
        #expect(Altura("Fa#3").nombre(en: .conPalabras(.portugues)) == "fá sustenido 3")
        #expect(Altura("fá sustenido 3") == Altura("Fa#3"))
        #expect(Tonalidad("Sib mayor").nombre(en: .conPalabras(.portugues)) == "si bemol maior")
        #expect(Tonalidad("La menor").nombre(en: .conPalabras(.portugues)) == "lá menor")
        #expect(Tonalidad("si bemol maior") == Tonalidad("Sib mayor"))
        #expect(Tonalidad("fá sustenido menor") == Tonalidad("Fa# menor"))
        #expect(Escala("ré dórico") == Escala("Re dórico"))
        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.portugues)) == "ré dórico")
        #expect(Alteracion(1).nombre(en: .conPalabras(.portugues)) == "sustenido")
        #expect(Alteracion(-2).nombre(en: .conPalabras(.portugues)) == "duplo bemol")
        #expect(Alteracion(0).nombre(en: .conPalabras(.portugues)) == "bequadro")
        #expect(Alteracion(5).nombre(en: .conPalabras(.portugues)) == "5 sustenidos")
        #expect(Alteracion("sustenido") == .sostenido)
        #expect(Alteracion("duplo bemol") == .dobleBemol)
        #expect(Notacion.conPalabras(.portugues).idiomaDeLasAbreviaturas == .espanol)
        #expect(Notacion(escritura: EscrituraDeNotas(idioma: .portugues, ascii: true)) == .conPalabras(.portugues))
        #expect(EstiloDeCifrado(notacion: .conPalabras(.portugues)).notacion == .conPalabras(.portugues))
    }

    /// Las notas, los textos y los catálogos en aragonés y asturiano.
    @Test func aragonesYAsturiano() throws {
        #expect(Nota("Fa#").nombre(en: .conPalabras(.aragones)) == "fa sosteniu")
        #expect(Nota("Sib").nombre(en: .conPalabras(.asturiano)) == "si bemol")
        #expect(Nota("Fa#").nombreCompacto(en: .conPalabras(.asturiano)) == "Fa♯")
        #expect(Nota("fa sosteníu") == Nota("Fa#"))
        #expect(try (Altura(leyendo: "fa sosteniu 3")) == Altura("Fa#3"))
        #expect(Tonalidad("fa sosteníu mayor") == Tonalidad("Fa# mayor"))
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.aragones)) == "3ª mayor")
        #expect(Intervalo.quintaJusta.nombre(en: .conPalabras(.asturiano)) == "5ª xusta")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.asturiano)) == "sol séptima de dominante, primer inversión")
        #expect(Acorde("Sol7/Si").nombre(en: .conPalabras(.aragones)) == "sol séptima de dominant, primera inversión")
        #expect(Escala(.re, .dorico).nombre(en: .conPalabras(.asturiano)) == "re dóricu")
        #expect(Escala(.mi, .frigio).nombre(en: .conPalabras(.aragones)) == "mi frichio")
        #expect((try? Escala(leyendo: "re dóricu")) == Escala(.re, .dorico))
        #expect(Tonalidad(.do).lugar(en: .conPalabras(.asturiano)) == "en do mayor")
        #expect(InstrumentoDePartitura.violonchelo.nombre(en: .conPalabras(.asturiano)) == "violonchelu")
        #expect(try Encordado(leyendo: "baxu") == .bajoElectrico)
        #expect(
            ErrorDeLectura(texto: "", posicion: 0, motivo: .textoVacio).explicacion(en: .conPalabras(.asturiano))
                == "el testu ta baleru")
        // Las escalas del catálogo se vuelven a leer con su nombre en los dos idiomas.
        for tipo in TipoDeEscala.occidentales where !TipoDeEscala.nombresTradicionales.contains(tipo.nombre) {
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.conPalabras(.aragones), .conPalabras(.asturiano)] {
                let nombre = escala.nombre(en: notacion)
                #expect((try? Escala(leyendo: nombre)) == escala, "\(nombre) (\(tipo.nombre))")
            }
        }
    }
}
