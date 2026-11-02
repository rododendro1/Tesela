import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

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
            let nombre = Nota(texto: espanol)!
            #expect(nombre.nombre(en: .catalanPalabras) == catalan)
            #expect(nombre.nombre(en: .gallegoPalabras) == gallego)
            #expect(nombre.nombre(en: .euskeraPalabras) == euskera)
            // Se leen también sin indicar la notación.
            for texto in [catalan, gallego, euskera] {
                #expect(Nota(texto: texto) == nombre, Comment(rawValue: texto))
            }
        }
        #expect(Nota("Reb").nombreCompacto(en: .catalanPalabras) == "Re♭")
        #expect(Acorde("Fa#m7").cifrado(en: .gallegoPalabras) == "Fa♯m7")
        #expect(Altura("Fa#3").nombre(en: .catalanPalabras) == "fa sostingut 3")
        #expect(Altura("fa sostido 3") == Altura("Fa#3"))
        #expect(Altura("si bemol bikoitza 2") == Altura("Sibb2"))
        #expect(Tonalidad("Reb mayor").nombre(en: .catalanPalabras) == "re bemoll major")
        #expect(Tonalidad("Reb mayor").nombre(en: .gallegoPalabras) == "re bemol maior")
        #expect(Tonalidad("La menor").nombre(en: .euskeraPalabras) == "la minorra")
        #expect(Tonalidad("re bemoll major") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("re bemol maior") == Tonalidad("Reb mayor"))
        #expect(Tonalidad("fa diesa minorra") == Tonalidad("Fa# menor"))
        // Las abreviaturas de los intervalos, como en español; los nombres de los catálogos, traducidos.
        #expect(Notacion.catalanPalabras.idiomaDeLasAbreviaturas == .espanol)
        #expect(Escala(.re, .dorico).nombre(en: .euskeraPalabras) == "re doriarra")
        #expect(Escala("Reb dórico").nombre(en: .catalanPalabras) == "re bemoll dòric")
        #expect(Escala("re bemoll dórico") == Escala("Reb dórico"))
        #expect(Escala("re bemoll dòric") == Escala("Reb dórico"))
        #expect(Escala("fa sostido menor armónica") == Escala("Fa# menor armónica"))
        #expect(Intervalo.terceraMayor.nombre(en: .gallegoPalabras) == "3ª maior")
        #expect(Alteracion(1).nombre(en: .catalanPalabras) == "sostingut")
        #expect(Alteracion(-2).nombre(en: .gallegoPalabras) == "dobre bemol")
        #expect(Alteracion(2).nombre(en: .euskeraPalabras) == "diesa bikoitza")
        #expect(Alteracion("sostingut") == .sostenido)
        #expect(Alteracion("diesa bikoitza") == .dobleSostenido)
        // Los errores de siempre no cambian.
        #expect(Nota(texto: "Fa#4") == nil)
        #expect(Altura(texto: "Do") == nil)
    }

    /// Los textos del motor que no son nombres de nota, en catalán, gallego y euskera.
    @Test func textosEnCatalanGallegoEuskera() throws {
        #expect(Notacion.catalanPalabras.textos == .catalan)
        #expect(Notacion.alemanPalabras.textos == .aleman)
        #expect(Notacion.portuguesPalabras.textos == .portugues)
        #expect(Notacion.espanolASCII.textos == .espanol)

        let sexta = try Intervalo(leyendo: "-6m")
        #expect(sexta.nombre == "6ª menor descendente")
        #expect(sexta.nombre(en: .catalanPalabras) == "6a menor descendent")
        #expect(sexta.nombre(en: .gallegoPalabras) == "6ª menor descendente")
        #expect(sexta.nombre(en: .euskeraPalabras) == "beheranzko 6. txikia")
        #expect(Intervalo.terceraMayor.nombre(en: .catalanPalabras) == "3a major")
        #expect(Intervalo.terceraMayor.nombre(en: .euskeraPalabras) == "3. handia")
        #expect(CalidadDeIntervalo.aumentada(2).nombre(en: .euskeraPalabras) == "bi aldiz gehitua")
        #expect(CalidadDeIntervalo.disminuida(1).nombre(en: .catalanPalabras) == "disminuïda")
        #expect(CalidadDeIntervalo.justa.nombre(en: .gallegoPalabras) == "xusta")
        #expect(Consonancia.imperfecta.nombre(en: .catalanPalabras) == "consonància imperfecta")
        #expect(PapelEnAcorde.fundamental.nombre(en: .euskeraPalabras) == "oinarria")
        #expect(PapelEnAcorde.tension(11).nombre(en: .catalanPalabras) == "onzena")
        #expect(CalidadDeTriada.disminuida.nombre(en: .gallegoPalabras) == "diminuída")
        #expect(NombreDeGrado.sensible.nombre(en: .euskeraPalabras) == "sentsiblea")
        #expect(FuncionTonal.dominante.nombre(en: .catalanPalabras) == "dominant")
        #expect(Clave.fa.nombre(en: .gallegoPalabras) == "clave de fa")
        #expect(Clave.sol.nombre(en: .euskeraPalabras) == "sol giltza")
        #expect(Duracion(.negra, puntillos: 1).nombre(en: .catalanPalabras) == "negra amb punt")
        #expect(Duracion(.corchea, puntillos: 1).nombre(en: .euskeraPalabras) == "kortxea puntuduna")
        #expect(Figura.blanca.nombre(en: .gallegoPalabras) == "branca")
        #expect(CorrespondenciaDeColores.circuloDeQuintas.nombre(en: .euskeraPalabras) == "bosgarrenen zirkulua")
        #expect(Cadencia.Tipo.semicadencia.nombre(en: .euskeraPalabras) == "erdi-kadentzia")
        #expect(FaltaDeConduccion.Tipo.quintasParalelas.nombre(en: .catalanPalabras) == "Quintes paral·leles")
        #expect(
            Tonalidad(.do).analizar(["Do", "Fa", "Sol7", "Do"]).nombre(en: .euskeraPalabras)
                == "I–IV–V7–I do maiorrean")
        #expect(
            Tonalidad(.la, .menor).analizar(["Lam", "Mi7", "Lam"]).nombre(en: .catalanPalabras) == "i–V7–i en la menor")
        // En alemán.
        #expect(Intervalo.terceraMayor.nombre(en: .alemanPalabras) == "große Terz")
        // Los catálogos también.
        #expect(Acorde("Sol7").nombre(en: .euskeraPalabras) == "sol dominanteko zazpigarrena, oinarrizko egoera")
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
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .catalanPalabras) == "sèptima de dominant")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .gallegoPalabras) == "sétima de dominante")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .euskeraPalabras) == "dominanteko zazpigarrena")
        #expect(TipoDeAcorde.dominanteSeptima.nombre(en: .portuguesPalabras) == "sétima de dominante")
        #expect(Acorde("Sol7/Si").nombre(en: .catalanPalabras) == "sol sèptima de dominant, primera inversió")
        #expect(Acorde("Sol7/Si").nombre(en: .gallegoPalabras) == "sol sétima de dominante, primeira inversión")
        #expect(Acorde("Do/Re").nombre(en: .euskeraPalabras) == "do maiorra, baxua re dela")
        #expect(Acorde("Do/Re").nombre(en: .catalanPalabras) == "do major, amb el baix en re")
        #expect(Acorde("Sol7/Si").nombre(en: .alemanPalabras) == "Dominantseptakkord auf G, erste Umkehrung")
        #expect(Acorde("Sol7/Si").nombre(en: .occitanoPalabras) == "sòl setena de dominanta, primièra inversion")
        #expect(
            Acorde("Sol7/Si").nombre(en: .griegoPalabras) == "συγχορδία έβδομης δεσπόζουσας στο σολ, πρώτη αναστροφή")
        #expect(Acorde("Do/Re").nombre(en: .alemanPalabras) == "Durdreiklang auf C, mit D im Bass")
        // Todos los tipos conocidos tienen nombre propio en cada idioma.
        for (_, nombre) in TipoDeAcorde.nombresConocidos {
            #expect(
                !(nombre.catalan.isEmpty || nombre.gallego.isEmpty || nombre.euskera.isEmpty),
                Comment(rawValue: nombre.espanol))
        }

        #expect(Escala(.re, .dorico).nombre(en: .catalanPalabras) == "re dòric")
        #expect(Escala(.la, .menorArmonica).nombre(en: .gallegoPalabras) == "la menor harmónica")
        #expect(Escala("re doriarra") == Escala("Re dórico"))
        #expect(Escala("fa sostingut lidi") == Escala("Fa# lidio"))
        // Los nombres de otras tradiciones son los mismos en todos los idiomas.
        #expect(Escala(.re, .hirajoshi).nombre(en: .euskeraPalabras) == ("re " + TipoDeEscala.hirajoshi.nombre))
        // Cada escala del catálogo tiene nombre en los tres idiomas, y se vuelve a leer igual.
        for tipo in TipoDeEscala.todos {
            for idioma in [Idioma.catalan, .gallego, .euskera] {
                #expect(NombresDeEscalas.de(idioma).porTipo[tipo] != nil, "\(idioma): \(tipo.nombre)")
            }
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.catalanPalabras, .gallegoPalabras, .euskeraPalabras] {
                let nombre = escala.nombre(en: notacion)
                #expect(Escala(texto: nombre) == escala, "\(nombre) (\(tipo.nombre))")
            }
        }

        #expect(InstrumentoDePartitura.clarineteEnSib.nombre(en: .catalanPalabras) == "clarinet en si♭")
        #expect(InstrumentoDePartitura.violin.nombre(en: .euskeraPalabras) == "biolina")
        #expect(InstrumentoDePartitura.saxofonAlto.nombre(en: .gallegoPalabras) == "saxofón alto")
        for instrumento in InstrumentoDePartitura.todos {
            #expect(
                InstrumentoDePartitura.traducciones[instrumento.nombre] != nil, Comment(rawValue: instrumento.nombre))
        }

        #expect(CicloNeorriemanniano.hexatonico.nombre(en: .catalanPalabras) == "cicle hexatònic")
        #expect(CicloNeorriemanniano.lr.nombre(en: .euskeraPalabras) == "LR zikloa")
        #expect(
            CicloNeorriemanniano.octatonico.nombre(en: .inglesASCII) == CicloNeorriemanniano.octatonico.nombreEnIngles)
    }

    @Test func portugues() throws {
        let casos: [(String, String)] = [
            ("Fa#", "fá sustenido"), ("Sib", "si bemol"), ("Dox", "dó duplo sustenido"),
            ("Mibb", "mi duplo bemol"), ("Re", "ré"), ("La", "lá"), ("Sol", "sol"),
        ]
        for (espanol, portugues) in casos {
            let nombre = Nota(texto: espanol)!
            #expect(nombre.nombre(en: .portuguesPalabras) == portugues)
            // Se lee sin indicar la notación, con o sin tildes.
            #expect(Nota(texto: portugues) == nombre, Comment(rawValue: portugues))
            #expect(try (Nota(leyendo: portugues, en: .portuguesPalabras)) == nombre, Comment(rawValue: portugues))
        }
        #expect(Nota(texto: "fa sustenido") == Nota("Fa#"))
        #expect(Nota("Reb").nombreCompacto(en: .portuguesPalabras) == "Ré♭")
        #expect(Acorde("Fa#m7").cifrado(en: .portuguesPalabras) == "Fá♯m7")
        #expect(Altura("Fa#3").nombre(en: .portuguesPalabras) == "fá sustenido 3")
        #expect(Altura("fá sustenido 3") == Altura("Fa#3"))
        #expect(Tonalidad("Sib mayor").nombre(en: .portuguesPalabras) == "si bemol maior")
        #expect(Tonalidad("La menor").nombre(en: .portuguesPalabras) == "lá menor")
        #expect(Tonalidad("si bemol maior") == Tonalidad("Sib mayor"))
        #expect(Tonalidad("fá sustenido menor") == Tonalidad("Fa# menor"))
        #expect(Escala("ré dórico") == Escala("Re dórico"))
        #expect(Escala(.re, .dorico).nombre(en: .portuguesPalabras) == "ré dórico")
        #expect(Alteracion(1).nombre(en: .portuguesPalabras) == "sustenido")
        #expect(Alteracion(-2).nombre(en: .portuguesPalabras) == "duplo bemol")
        #expect(Alteracion(0).nombre(en: .portuguesPalabras) == "bequadro")
        #expect(Alteracion(5).nombre(en: .portuguesPalabras) == "5 sustenidos")
        #expect(Alteracion("sustenido") == .sostenido)
        #expect(Alteracion("duplo bemol") == .dobleBemol)
        #expect(Notacion.portuguesPalabras.idiomaDeLasAbreviaturas == .espanol)
        #expect(Notacion(escritura: EscrituraDeNotas(idioma: .portugues, ascii: true)) == .portuguesPalabras)
        #expect(EstiloDeCifrado(notacion: .portuguesPalabras).notacion == .portuguesPalabras)
    }

    /// Las notas, los textos y los catálogos en aragonés y asturiano.
    @Test func aragonesYAsturiano() throws {
        #expect(Nota("Fa#").nombre(en: .aragonesPalabras) == "fa sosteniu")
        #expect(Nota("Sib").nombre(en: .asturianoPalabras) == "si bemol")
        #expect(Nota("Fa#").nombreCompacto(en: .asturianoPalabras) == "Fa♯")
        #expect(Nota("fa sosteníu") == Nota("Fa#"))
        #expect(try (Altura(leyendo: "fa sosteniu 3")) == Altura("Fa#3"))
        #expect(Tonalidad("fa sosteníu mayor") == Tonalidad("Fa# mayor"))
        #expect(Intervalo.terceraMayor.nombre(en: .aragonesPalabras) == "3ª mayor")
        #expect(Intervalo.quintaJusta.nombre(en: .asturianoPalabras) == "5ª xusta")
        #expect(Acorde("Sol7/Si").nombre(en: .asturianoPalabras) == "sol séptima de dominante, primer inversión")
        #expect(Acorde("Sol7/Si").nombre(en: .aragonesPalabras) == "sol séptima de dominant, primera inversión")
        #expect(Escala(.re, .dorico).nombre(en: .asturianoPalabras) == "re dóricu")
        #expect(Escala(.mi, .frigio).nombre(en: .aragonesPalabras) == "mi frichio")
        #expect(Escala(texto: "re dóricu") == Escala(.re, .dorico))
        #expect(Tonalidad(.do).lugar(en: .asturianoPalabras) == "en do mayor")
        #expect(InstrumentoDePartitura.violonchelo.nombre(en: .asturianoPalabras) == "violonchelu")
        #expect(Encordado(nombre: "baxu") == .bajoElectrico)
        #expect(
            ErrorDeLectura(texto: "", posicion: 0, motivo: .textoVacio).explicacion(en: .asturianoPalabras)
                == "el testu ta baleru")
        // Las escalas del catálogo se vuelven a leer con su nombre en los dos idiomas.
        for tipo in TipoDeEscala.todos where !TipoDeEscala.nombresTradicionales.contains(tipo.nombre) {
            let escala = Escala(.re, tipo)
            for notacion in [Notacion.aragonesPalabras, .asturianoPalabras] {
                let nombre = escala.nombre(en: notacion)
                #expect(Escala(texto: nombre) == escala, "\(nombre) (\(tipo.nombre))")
            }
        }
    }
}
