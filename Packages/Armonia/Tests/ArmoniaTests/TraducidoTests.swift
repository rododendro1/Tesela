import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaPartitura
@testable import ArmoniaRepresentaciones
@testable import ArmoniaTeoria

final class TraducidoTests: XCTestCase {
    func testUnValorPorIdioma() {
        let numeros = Traducido<[String]>(
            ["uno", "dos"], ["one", "two"], ca: ["un", "dos"], gl: ["un", "dous"],
            ast: ["un", "dos"], an: ["un", "dos"], eu: ["bat", "bi"],
            pt: ["um", "dois"], fr: ["un", "deux"], oc: ["un", "dos"],
            it: ["uno", "due"], de: ["eins", "zwei"], el: ["ένα", "δύο"], ru: ["один", "два"])
        XCTAssertEqual(numeros.en(.aleman)[1], "zwei")
        XCTAssertEqual(numeros.texto(en: .griego), ["ένα", "δύο"])
        XCTAssertEqual(numeros.map(\.count).en(.ruso), 2)
        XCTAssertEqual(numeros.todos.count, Idioma.allCases.count)
        // Con la notación habitual de cada idioma: ♯ en español, # en inglés.
        let fa = Traduccion(cadaIdioma: { Nota.fa.sostenido.nombre(en: $0) })
        XCTAssertEqual(fa.en(.espanolUnicode), "Fa♯")
        XCTAssertEqual(fa.en(.inglesASCII), "F#")
        XCTAssertEqual(fa.en(.aleman), "Fis")
        XCTAssertEqual(Traduccion(cadaIdioma: { Acorde.nombreDeLaInversion(1, en: $0) }).en(.aleman), "1. Umkehrung")
    }

    /// Las sílabas y la forma de pegar la alteración son datos, no `switch` repartidos.
    func testReglasDeCadaIdioma() {
        XCTAssertEqual(Idioma.ruso.reglas.separador, "-")
        XCTAssertEqual(Idioma.espanol.reglas.separador, " ")
        XCTAssertEqual(Idioma.euskera.reglas.multiplicador, .detras)
        XCTAssertEqual(Idioma.aleman.reglas.multiplicador, .unido)
        XCTAssertEqual(Idioma.frances.reglas.multiplicador, .delante)
        for idioma in Idioma.allCases {
            XCTAssertEqual(idioma.reglas.naturales.count, 7, idioma.codigo)
            XCTAssertEqual(Set(idioma.reglas.naturales).count, 7, idioma.codigo)
            for (i, silaba) in idioma.reglas.naturales.enumerated() {
                XCTAssertEqual(NotaNatural(rawValue: i)?.nombre(en: .delIdioma(idioma)), silaba)
            }
        }
        XCTAssertEqual(EscrituraDeNotas.aleman.escrituraDeLaAlteracion, .alemana)
        XCTAssertEqual(EscrituraDeNotas.espanol.escrituraDeLaAlteracion, .palabras)
        XCTAssertEqual(EscrituraDeNotas.inglesASCII.escrituraDeLaAlteracion, .signos)
    }

    func testPlantillas() {
        XCTAssertEqual("inversión _".rellenada(con: "7"), "inversión 7")
        XCTAssertEqual("_. Umkehrung".rellenada(con: "8"), "8. Umkehrung")
        XCTAssertEqual("sin hueco".rellenada(con: "7"), "sin hueco")
    }

    func testTextosHechosConListas() {
        XCTAssertEqual(Duracion(7, 8).nombre(en: .aleman), "doppelt punktierte Halbe")
        XCTAssertEqual(Duracion(3, 8).nombre(en: .frances), "noire pointée")
        XCTAssertEqual(TipoDeAcorde("7(b9,#11)").nombre(en: .espanolUnicode), "acorde 7(♭9,♯11)")
        XCTAssertEqual(TipoDeAcorde("7(b9,#11)").nombre(en: .euskera), "7(♭9,♯11) akordea")
        XCTAssertEqual(Acorde.nombreDeLaInversion(9, en: .ruso), "9-е обращение")
    }

    func testCodigosDeIdioma() {
        for idioma in Idioma.allCases {
            XCTAssertEqual(Idioma(codigo: idioma.codigo), idioma, idioma.codigo)
        }
        XCTAssertEqual(Set(Idioma.allCases.map(\.codigo)).count, Idioma.allCases.count)
        XCTAssertEqual(Idioma(codigo: "ca-ES"), .catalan)
        XCTAssertEqual(Idioma(codigo: "pt_BR"), .portugues)
        XCTAssertEqual(Idioma(codigo: "AST"), .asturiano)
        XCTAssertNil(Idioma(codigo: "ja"))
    }

    /// El código, los nombres y los modos de cada idioma salen de sus `ReglasDeIdioma`.
    func testLosDatosDeCadaIdioma() {
        XCTAssertEqual(Idioma(rawValue: "euskera"), .euskera)
        XCTAssertEqual(Idioma.aleman.rawValue, "aleman")
        XCTAssertEqual(Idioma.griego.nombrePropio, "Ελληνικά")
        XCTAssertEqual(Idioma.asturiano.codigo, "ast")
        for idioma in Idioma.allCases {
            XCTAssertTrue(idioma.nombres.contains(idioma.nombrePropio.lowercased()), idioma.codigo)
            XCTAssertNotEqual(idioma.reglas.mayor, idioma.reglas.menor, idioma.codigo)
        }
        XCTAssertEqual(Tonalidad(.la, .menor).nombre(en: .aleman), "a-Moll")
        XCTAssertEqual(Tonalidad(.do, .mayor).nombre(en: .aleman), "C-Dur")
        XCTAssertEqual(Tonalidad(.la, .menor).nombre(en: .euskera), "la minorra")
        XCTAssertEqual(Tonalidad.Modo.mayor.nombre(en: .asturiano), "mayor")
    }

    func testElIdiomaPorSuNombre() {
        for idioma in Idioma.allCases {
            XCTAssertEqual(Idioma(nombre: idioma.codigo), idioma, idioma.codigo)
            for nombre in idioma.nombres {
                XCTAssertEqual(Idioma(nombre: nombre), idioma, nombre)
                XCTAssertEqual(nombre, nombre.lowercased(), nombre)
            }
        }
        XCTAssertEqual(Idioma(nombre: "Euskara"), .euskera)
        XCTAssertEqual(Idioma(nombre: "DEUTSCH"), .aleman)
        XCTAssertEqual(Idioma(nombre: "pt-BR"), .portugues)
        XCTAssertNil(Idioma(nombre: "japonés"))
        XCTAssertNil(Idioma(codigo: ""))
        // La notación habitual de cada idioma: # en inglés, ♯ en español.
        XCTAssertEqual(Notacion.delIdioma(.ingles), .inglesASCII)
        XCTAssertEqual(Notacion.delIdioma(.espanol), .espanolUnicode)
        XCTAssertEqual(Notacion.delIdioma(.griego), .griego)
        for idioma in Idioma.allCases {
            XCTAssertEqual(Notacion.delIdioma(idioma).idiomaDeLasNotas, idioma)
        }
    }

    func testAlteracionesYOrdinalesEnCadaIdioma() {
        // Las alteraciones con varios signos.
        XCTAssertEqual(Alteracion(4).nombre(en: .aleman), "Vierfachkreuz")
        XCTAssertEqual(Alteracion(-4).nombre(en: .aleman), "Vierfach-Be")
        XCTAssertEqual(Alteracion(-3).nombre(en: .ruso), "тройной бемоль")
        XCTAssertEqual(Nota(.si, Alteracion(-3)).nombre(en: .ruso), "си-тройной бемоль")
        XCTAssertEqual(Nota(.si, Alteracion(-2)).nombre(en: .ruso), "си-дубль-бемоль")
        XCTAssertEqual(Alteracion(5).nombre, "5 sostenidos")
        XCTAssertEqual(Alteracion(-5).nombre(en: .inglesASCII), "5 flats")
        XCTAssertEqual(Alteracion(4).nombre(en: .euskera), "diesa laukoitza")
        XCTAssertEqual(Alteracion(3).nombre(en: .gallego), "triplo sostido")
        // Las tipografías de cada escritura.
        XCTAssertEqual(EscrituraDeNotas.allCases.filter(\.usaASCII), [.espanolASCII, .inglesASCII, .aleman])
        for escritura in EscrituraDeNotas.allCases {
            XCTAssertEqual(escritura.usaASCII, escritura.tipografia == .ascii)
        }
        // Los ordinales: con palabras hasta la doble octava, y luego en cifras.
        XCTAssertEqual(Intervalo.ordinal(3, en: .frances), "tierce")
        XCTAssertEqual(Intervalo.ordinal(16, en: .frances), "16e")
        XCTAssertEqual(Intervalo.ordinal(15, en: .aleman), "Doppeloktave")
        XCTAssertEqual(Intervalo.ordinal(3, en: .espanol), "3ª")
        XCTAssertEqual(Intervalo.ordinal(3, en: .catalan), "3a")
        XCTAssertEqual(Intervalo.ordinal(3, en: .euskera), "3.")
        // Cada idioma nombra los quince intervalos con palabras, o ninguno.
        for idioma in Idioma.traducidos {
            XCTAssertTrue([0, 15].contains(TextosDeNucleo.en(idioma: idioma, \.ordinales).count), "\(idioma)")
        }
        XCTAssertEqual(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .frances), "unisson augmenté")
        XCTAssertEqual(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .italiano), "unisono aumentato")
        XCTAssertEqual(Intervalo(numero: 1, calidad: .aumentada(1))!.nombre(en: .occitano), "unisson aumentat")
        XCTAssertEqual((-Intervalo.terceraMayor).nombre(en: .aragones), "3ª mayor descendent")
        XCTAssertEqual((-Intervalo.terceraMayor).nombre(en: .euskera), "beheranzko 3. handia")
        XCTAssertEqual(Intervalo(numero: 4, calidad: .aumentada(3))!.nombre(en: .gallego), "4ª tripla aumentada")
    }

    /// Los textos que llevan un número o un nombre dentro, en cada idioma, también con los casos que
    /// las apps casi no usan (una tensión, el número de una voz, un acorde sin nombre…).
    func testLosTextosConHuecosEnCadaIdioma() {
        for textos in TextosDeNucleo.traducidos.todos {
            XCTAssertTrue(textos.multiplicidad(5).contains("5"))
        }
        for textos in TextosDeTeoria.traducidos.todos {
            XCTAssertNotEqual(textos.papelTension(9), textos.papelTension(11))
            XCTAssertTrue(textos.vozNumero(3).contains("3"))
            XCTAssertFalse(textos.acordeDesconocido(true, "X", "X").isEmpty)
            XCTAssertFalse(textos.acordeDesconocido(false, "X", "X").isEmpty)
            XCTAssertTrue(textos.enLaVoz("X").contains("X"))
        }
        XCTAssertEqual(TextosDeTeoria.traducidos.en(.aleman).enLaVoz("Stimme 2"), "in Stimme 2")
        for textos in TextosDePartitura.traducidos.todos {
            XCTAssertTrue(textos.especieConElContrapuntoDebajo(3).contains("3"))
        }
        for textos in TextosDeRepresentaciones.traducidos.todos {
            XCTAssertTrue(textos.cicloDesde("Z", "Y").contains("Z"))
            XCTAssertNotEqual(textos.semitonos(1), textos.semitonos(2))
        }
    }
}
