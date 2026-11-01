import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

@Suite struct TraducidoTests {
    @Test func unValorPorIdioma() {
        let numeros = Traducido<[String]>(
            ["uno", "dos"], ["one", "two"], ca: ["un", "dos"], gl: ["un", "dous"],
            ast: ["un", "dos"], an: ["un", "dos"], eu: ["bat", "bi"],
            pt: ["um", "dois"], fr: ["un", "deux"], oc: ["un", "dos"],
            it: ["uno", "due"], de: ["eins", "zwei"], el: ["ένα", "δύο"], ru: ["один", "два"],
            hu: ["egy", "kettő"])
        #expect(numeros.en(.aleman)[1] == "zwei")
        #expect(numeros.texto(en: .griego) == ["ένα", "δύο"])
        #expect(numeros.map(\.count).en(.ruso) == 2)
        #expect(numeros.todos.count == Idioma.allCases.count)
        // Con la notación habitual de cada idioma: ♯ en español, # en inglés.
        let fa = Traduccion(cadaIdioma: { Nota.fa.sostenido.nombre(en: $0) })
        #expect(fa.en(.espanolCompacto) == "Fa♯")
        #expect(fa.en(.inglesASCII) == "F#")
        #expect(fa.en(.aleman) == "Fis")
        #expect(Traduccion(cadaIdioma: { Acorde.nombreDeLaInversion(1, en: $0) }).en(.aleman) == "erste Umkehrung")
    }

    /// Las sílabas y la forma de pegar la alteración son datos, no `switch` repartidos.
    @Test func reglasDeCadaIdioma() {
        #expect(Idioma.ruso.reglas.separador == "-")
        #expect(Idioma.espanol.reglas.separador == " ")
        #expect(Idioma.euskera.reglas.multiplicador == .detras)
        #expect(Idioma.aleman.reglas.multiplicador == .unido)
        #expect(Idioma.frances.reglas.multiplicador == .delante)
        for idioma in Idioma.allCases {
            #expect(idioma.reglas.naturales.count == 7, Comment(rawValue: idioma.codigo))
            #expect(Set(idioma.reglas.naturales).count == 7, Comment(rawValue: idioma.codigo))
            for (i, silaba) in idioma.reglas.naturales.enumerated() {
                #expect(NotaNatural(rawValue: i)?.nombre(en: .delIdioma(idioma)) == silaba)
            }
        }
        #expect(EscrituraDeNotas.alemanCompacto.escrituraDeLaAlteracion == .alemana)
        #expect(EscrituraDeNotas.aleman.escrituraDeLaAlteracion == .palabras)
        #expect(EscrituraDeNotas.espanol.escrituraDeLaAlteracion == .palabras)
        #expect(EscrituraDeNotas.inglesASCII.escrituraDeLaAlteracion == .signos)
    }

    @Test func plantillas() {
        #expect("inversión _".rellenada(con: "7") == "inversión 7")
        #expect("_. Umkehrung".rellenada(con: "8") == "8. Umkehrung")
        #expect("sin hueco".rellenada(con: "7") == "sin hueco")
    }

    @Test func textosHechosConListas() {
        #expect(Duracion(7, 8).nombre(en: .aleman) == "doppelt punktierte Halbe")
        #expect(Duracion(3, 8).nombre(en: .frances) == "noire pointée")
        #expect(TipoDeAcorde("7(b9,#11)").nombre(en: .espanolCompacto) == "acorde 7(♭9,♯11)")
        #expect(TipoDeAcorde("7(b9,#11)").nombre(en: .euskera) == "7(♭9,♯11) akordea")
        #expect(Acorde.nombreDeLaInversion(9, en: .ruso) == "9-е обращение")
    }

    @Test func codigosDeIdioma() {
        for idioma in Idioma.allCases {
            #expect(Idioma(codigo: idioma.codigo) == idioma, Comment(rawValue: idioma.codigo))
        }
        #expect(Set(Idioma.allCases.map(\.codigo)).count == Idioma.allCases.count)
        #expect(Idioma(codigo: "ca-ES") == .catalan)
        #expect(Idioma(codigo: "pt_BR") == .portugues)
        #expect(Idioma(codigo: "AST") == .asturiano)
        #expect(Idioma(codigo: "ja") == nil)
    }

    /// El código, los nombres y los modos de cada idioma salen de sus `ReglasDeIdioma`.
    @Test func losDatosDeCadaIdioma() {
        #expect(Idioma(rawValue: "euskera") == .euskera)
        #expect(Idioma.aleman.rawValue == "aleman")
        #expect(Idioma.griego.nombrePropio == "Ελληνικά")
        #expect(Idioma.asturiano.codigo == "ast")
        for idioma in Idioma.allCases {
            #expect(idioma.nombres.contains(idioma.nombrePropio.lowercased()), Comment(rawValue: idioma.codigo))
            #expect(idioma.reglas.mayor != idioma.reglas.menor, Comment(rawValue: idioma.codigo))
        }
        #expect(Tonalidad(.la, .menor).nombre(en: .aleman) == "a-Moll")
        #expect(Tonalidad(.do, .mayor).nombre(en: .aleman) == "C-Dur")
        #expect(Tonalidad(.la, .menor).nombre(en: .euskera) == "la minorra")
        #expect(Tonalidad.Modo.mayor.nombre(en: .asturiano) == "mayor")
    }

    @Test func elIdiomaPorSuNombre() {
        for idioma in Idioma.allCases {
            #expect(Idioma(nombre: idioma.codigo) == idioma, Comment(rawValue: idioma.codigo))
            for nombre in idioma.nombres {
                #expect(Idioma(nombre: nombre) == idioma, Comment(rawValue: nombre))
                #expect(nombre == nombre.lowercased(), Comment(rawValue: nombre))
            }
        }
        #expect(Idioma(nombre: "Euskara") == .euskera)
        #expect(Idioma(nombre: "DEUTSCH") == .aleman)
        // Sin tildes ni mayúsculas, aunque la lista solo tenga la forma con tilde.
        #expect(Idioma(nombre: "aleman") == .aleman)
        #expect(Idioma(nombre: "FRANCAIS") == .frances)
        #expect(Idioma(nombre: "ελληνικα") == .griego)
        #expect(Idioma(nombre: "Português") == .portugues)
        #expect(Idioma(nombre: "espanol") == .espanol)
        #expect(Idioma(nombre: "pt-BR") == .portugues)
        #expect(Idioma(nombre: "japonés") == nil)
        #expect(Idioma(codigo: "") == nil)
        // La notación habitual de cada idioma: # en inglés, ♯ en español.
        #expect(Notacion.delIdioma(.ingles) == .inglesASCII)
        #expect(Notacion.delIdioma(.espanol) == .espanolCompacto)
        #expect(Notacion.delIdioma(.griego) == .griego)
        for idioma in Idioma.allCases {
            #expect(Notacion.delIdioma(idioma).idiomaDeLasNotas == idioma)
        }
    }

    /// Quitando las tildes, ningún nombre de idioma se confunde con el de otro, ni se repite en el suyo.
    @Test func losNombresDeIdiomaNoChocanSinTildes() {
        let claves = Idioma.allCases.flatMap { idioma in idioma.nombres.map { ($0.claveDeBusqueda, idioma) } }
        #expect(Set(claves.map(\.0)).count == claves.count, "\(claves)")
    }

    @Test func lasAbreviaturasDeCadaIdioma() {
        #expect(Notacion.catalan.idiomaDeLasAbreviaturas == .espanol)
        #expect(Notacion.occitano.idiomaDeLasAbreviaturas == .espanol)
        #expect(Notacion.frances.idiomaDeLasAbreviaturas == .ingles)
        #expect(Notacion.ruso.idiomaDeLasAbreviaturas == .ingles)
        // Con los textos en otro idioma, mandan los textos.
        #expect(Notacion.ruso.conTextos(en: .gallego).idiomaDeLasAbreviaturas == .espanol)
        for idioma in Idioma.allCases {
            #expect([.espanol, .ingles].contains(idioma.reglas.abreviaturas), Comment(rawValue: idioma.codigo))
        }
    }

    @Test func elPluralDeCadaIdioma() {
        #expect(Idioma.espanol.contar(1, "dedo", "dedos") == "1 dedo")
        #expect(Idioma.espanol.contar(0, "dedo", "dedos") == "0 dedos")
        #expect(Idioma.espanol.contar(-1, "dedo", "dedos") == "-1 dedo")
        #expect(Idioma.frances.contar(0, "doigt", "doigts") == "0 doigt")
        #expect(Idioma.frances.contar(2, "doigt", "doigts") == "2 doigts")
        #expect(Idioma.euskera.contar(5, "hatz") == "5 hatz")
        #expect(Idioma.ruso.contar(1, "a", "b", "c") == "1 a")
        #expect(Idioma.ruso.contar(3, "a", "b", "c") == "3 b")
        #expect(Idioma.ruso.contar(12, "a", "b", "c") == "12 c")
        #expect(Idioma.ruso.contar(21, "a", "b", "c") == "21 a")
        #expect(Idioma.ruso.contar(24, "a", "b", "c") == "24 b")
        #expect(Idioma.ruso.contar(25, "a", "b", "c") == "25 c")
        // Con menos formas de las que pide la regla vale la última, y sin ninguna, el número solo.
        #expect(Idioma.ruso.contar(5, "a", "b") == "5 b")
        #expect(Idioma.ingles.contar(3) == "3")
        #expect(ReglasDeIdioma.Plural.invariable.forma(para: 7) == 0)
    }

    @Test func lasReglasSonLasMismasEnCadaLlamada() {
        let codigos = Traducido(porIdioma: { $0.codigo })
        #expect(codigos.texto(en: .asturiano) == "ast")
        for idioma in Idioma.allCases {
            #expect(idioma.reglas == idioma.reglas, Comment(rawValue: idioma.codigo))
            #expect(codigos.texto(en: idioma) == idioma.codigo)
        }
    }

    @Test func alteracionesYOrdinalesEnCadaIdioma() {
        // Las alteraciones con varios signos.
        #expect(Alteracion(4).nombre(en: .aleman) == "Vierfachkreuz")
        #expect(Alteracion(-4).nombre(en: .aleman) == "Vierfach-Be")
        #expect(Alteracion(-3).nombre(en: .ruso) == "тройной бемоль")
        #expect(Nota(.si, Alteracion(-3)).nombre(en: .ruso) == "си-тройной бемоль")
        #expect(Nota(.si, Alteracion(-2)).nombre(en: .ruso) == "си-дубль-бемоль")
        #expect(Alteracion(5).nombre == "5 sostenidos")
        #expect(Alteracion(-5).nombre(en: .inglesASCII) == "5 flats")
        #expect(Alteracion(4).nombre(en: .euskera) == "diesa laukoitza")
        #expect(Alteracion(3).nombre(en: .gallego) == "triplo sostido")
        // Las tipografías de cada escritura.
        #expect(
            EscrituraDeNotas.allCases.filter(\.usaASCII) == [
                .espanolASCII, .inglesASCII, .aleman, .alemanCompacto, .hungaro, .hungaroCompacto,
            ])
        #expect(
            EscrituraDeNotas.allCases.filter(\.esCompacta) == [
                .espanolCompacto, .inglesCompacto, .alemanCompacto, .hungaroCompacto,
            ])
        for escritura in EscrituraDeNotas.allCases {
            #expect(escritura.usaASCII == (escritura.tipografia == .ascii))
        }
        // Los ordinales: con palabras hasta la doble octava, y luego en cifras.
        #expect(Intervalo.ordinal(3, en: .frances) == "tierce")
        #expect(Intervalo.ordinal(16, en: .frances) == "16e")
        #expect(Intervalo.ordinal(15, en: .aleman) == "Doppeloktave")
        #expect(Intervalo.ordinal(3, en: .espanol) == "3ª")
        #expect(Intervalo.ordinal(3, en: .catalan) == "3a")
        #expect(Intervalo.ordinal(3, en: .euskera) == "3.")
        // Cada idioma nombra los quince intervalos con palabras, o ninguno.
        for idioma in Idioma.allCases {
            #expect([0, 15].contains(TextosDeNucleo.en(idioma: idioma, \.ordinales).count), "\(idioma)")
        }
        #expect(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .frances) == "unisson augmenté")
        #expect(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .italiano) == "unisono aumentato")
        #expect(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .occitano) == "unisson aumentat")
        #expect((-Intervalo.terceraMayor).nombre(en: .aragones) == "3ª mayor descendent")
        #expect((-Intervalo.terceraMayor).nombre(en: .euskera) == "beheranzko 3. handia")
        #expect(Intervalo(numero: 4, calidad: .aumentada(3))!.nombre(en: .gallego) == "4ª tripla aumentada")
    }

    /// Los textos que llevan un número o un nombre dentro, en cada idioma, también con los casos que
    /// las apps casi no usan (una tensión, el número de una voz, un acorde sin nombre…).
    @Test func losTextosConHuecosEnCadaIdioma() {
        for textos in TextosDeNucleo.traducidos.todos {
            #expect(textos.multiplicidad(5).contains("5"))
        }
        for textos in TextosDeTeoria.traducidos.todos {
            #expect(textos.papelTension(9) != textos.papelTension(11))
            #expect(textos.vozNumero(3).contains("3"))
            #expect(!(textos.acordeDesconocido(true, "X", "X").isEmpty))
            #expect(!(textos.acordeDesconocido(false, "X", "X").isEmpty))
            #expect(textos.enLaVoz("X").contains("X"))
        }
        #expect(TextosDeTeoria.traducidos.en(.aleman).enLaVoz("Stimme 2") == "in Stimme 2")
        for textos in TextosDePartitura.traducidos.todos {
            #expect(textos.especieConElContrapuntoDebajo(3).contains("3"))
        }
        for textos in TextosDeRepresentaciones.traducidos.todos {
            #expect(textos.cicloDesde("Z", "Y").contains("Z"))
            #expect(textos.semitonos(1) != textos.semitonos(2))
        }
    }
}
