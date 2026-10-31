import XCTest

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las tres modalidades del español y del inglés: con palabras (`.espanol`, `.ingles`), ASCII y Unicode.
final class NotacionesConPalabrasTests: XCTestCase {
    func testNombresDeNota() {
        let casos: [(String, String, String, String, String, String, String)] = [
            ("Fa#", "Fa sostenido", "Fa#", "Fa♯", "F sharp", "F#", "F♯"),
            ("Sib", "Si bemol", "Sib", "Si♭", "B flat", "Bb", "B♭"),
            ("Dox", "Do doble sostenido", "Do##", "Do♯♯", "C double sharp", "C##", "C♯♯"),
            ("Mibb", "Mi doble bemol", "Mibb", "Mi♭♭", "E double flat", "Ebb", "E♭♭"),
            ("Re", "Re", "Re", "Re", "D", "D", "D"),
        ]
        for (texto, espanol, espanolASCII, espanolUnicode, ingles, inglesASCII, inglesUnicode) in casos {
            let nota = Nota(texto: texto)!
            XCTAssertEqual(nota.nombre(en: .espanol), espanol)
            XCTAssertEqual(nota.nombre(en: .espanolASCII), espanolASCII)
            XCTAssertEqual(nota.nombre(en: .espanolUnicode), espanolUnicode)
            XCTAssertEqual(nota.nombre(en: .ingles), ingles)
            XCTAssertEqual(nota.nombre(en: .inglesASCII), inglesASCII)
            XCTAssertEqual(nota.nombre(en: .inglesUnicode), inglesUnicode)
            // Las seis formas se leen, sin indicar la notación y en cualquiera de las seis.
            for escrito in [espanol, espanolASCII, espanolUnicode, ingles, inglesASCII, inglesUnicode] {
                XCTAssertEqual(Nota(texto: escrito), nota, escrito)
                for notacion in [
                    Notacion.espanol, .espanolASCII, .espanolUnicode, .ingles, .inglesASCII, .inglesUnicode,
                ] {
                    XCTAssertEqual(try? Nota(leyendo: escrito, en: notacion), nota, "\(escrito) \(notacion)")
                }
            }
        }
    }

    func testAlturas() {
        let fa = Altura("Fa#4")
        XCTAssertEqual(fa.nombre(en: .espanol), "Fa sostenido 4")
        XCTAssertEqual(fa.nombre(en: .ingles), "F sharp 4")
        XCTAssertEqual(Altura(texto: "Fa sostenido 4"), fa)
        XCTAssertEqual(Altura(texto: "B flat 3"), Altura("Sib3"))
        XCTAssertEqual(try? Altura(leyendo: "Fa#4", en: .espanol), fa)
        XCTAssertEqual(try? Altura(leyendo: "F sharp 4", en: .ingles), fa)
    }

    /// Con palabras, los cifrados llevan ♯ y ♭ en los dos idiomas.
    func testCifrados() {
        let acorde = Acorde("Sib7(b9)/Re")
        XCTAssertEqual(acorde.cifrado(en: .espanol), "Si♭7(♭9)/Re")
        XCTAssertEqual(acorde.cifrado(en: .ingles), "B♭7(♭9)/D")
        XCTAssertEqual(acorde.cifrado(en: .espanolUnicode), "Si♭7(♭9)/Re")
        XCTAssertEqual(acorde.cifrado(en: .inglesASCII), "Bb7(b9)/D")
        XCTAssertEqual(Notacion.espanol.tipografia, .unicode)
        XCTAssertEqual(Notacion.ingles.tipografia, .unicode)
        XCTAssertEqual(Acorde(texto: acorde.cifrado(en: .ingles)), acorde)
    }

    /// Los cifrados se leen con la fundamental y el bajo en palabras, separadas de la nota por un espacio.
    func testCifradosConPalabras() {
        XCTAssertEqual(Acorde(texto: "Fa sostenido m7"), Acorde("Fa#m7"))
        XCTAssertEqual(Acorde(texto: "Fa sostenido"), Acorde("Fa#"))
        XCTAssertEqual(Acorde(texto: "B flat 7(b9)"), Acorde("Bb7(b9)"))
        XCTAssertEqual(Acorde(texto: "B flat7"), Acorde("Bb7"))
        XCTAssertEqual(Acorde(texto: "Mi doble bemol maj7"), Acorde("Mibbmaj7"))
        XCTAssertEqual(Acorde(texto: "C double sharp"), Acorde("C##"))
        XCTAssertEqual(Acorde(texto: "Si bemol/Re"), Acorde("Sib/Re"))
        XCTAssertEqual(Acorde(texto: "Sol7/Fa sostenido"), Acorde("Sol7/Fa#"))
        XCTAssertEqual(Acorde(texto: "D7/F sharp"), Acorde("D7/F#"))
        XCTAssertEqual(Acorde(texto: "la bemol m"), Acorde("Labm"))
        // La palabra tiene que terminar, y va en el idioma de la nota, como el bajo.
        XCTAssertNil(Acorde(texto: "Fa sostenidom7"))
        XCTAssertNil(Acorde(texto: "Fa sharp m7"))
        XCTAssertNil(Acorde(texto: "Sol7/F sharp"))
        // Lo de siempre sigue igual.
        XCTAssertEqual(Acorde(texto: "Faug")?.fundamental, Nota("F"))
        // Ida y vuelta: la fundamental y el bajo con palabras, y el tipo como siempre.
        let acordes: [Acorde] = ["Fa#m7", "Sib7(b9)/Re", "Mibmaj7", "Do#°7", "Lab/Do"]
        for acorde in acordes {
            for notacion in [Notacion.espanol, .ingles] {
                let bajo = acorde.bajo == acorde.fundamental ? "" : "/" + acorde.bajo.nombre(en: notacion)
                let escrito = acorde.fundamental.nombre(en: notacion) + " " + acorde.tipo.cifrado + bajo
                XCTAssertEqual(Acorde(texto: escrito), acorde, escrito)
            }
        }
    }

    func testEscalasYTonalidades() {
        XCTAssertEqual(Escala(texto: "Fa sostenido dórico"), Escala("Fa# dórico"))
        XCTAssertEqual(Escala(texto: "F sharp dorian"), Escala("Fa# dórico"))
        XCTAssertEqual(Escala(texto: "B double flat lydian"), Escala("Sibb lidio"))
        XCTAssertEqual(Tonalidad(texto: "Fa sostenido mayor"), Tonalidad("Fa# mayor"))
        XCTAssertEqual(Tonalidad(texto: "E flat minor"), Tonalidad("Mib menor"))
        // «B» sola en alemán sigue siendo Si♭.
        XCTAssertEqual(Escala(texto: "B dorisch"), Escala("Sib dórico"))
        for tonalidad in [Tonalidad("Fa# mayor"), Tonalidad("Mib menor"), Tonalidad("Do mayor")] {
            for notacion in [Notacion.espanol, .ingles] {
                XCTAssertEqual(
                    Tonalidad(texto: tonalidad.texto(en: notacion)), tonalidad, tonalidad.texto(en: notacion))
            }
        }
    }

    /// Las de signos son las de antes: `.espanolUnicode` era `.espanol` e `.inglesASCII` era `.ingles`.
    func testNotacionesHabituales() {
        XCTAssertEqual(Notacion.delIdioma(.espanol), .espanolUnicode)
        XCTAssertEqual(Notacion.delIdioma(.ingles), .inglesASCII)
        XCTAssertEqual(EscrituraDeNotas(idioma: .espanol, ascii: false), .espanolUnicode)
        XCTAssertEqual(EscrituraDeNotas(idioma: .ingles, ascii: true), .inglesASCII)
        XCTAssertEqual(Notacion.espanol.idiomaDeLasNotas, .espanol)
        XCTAssertEqual(Notacion.ingles.idiomaDeLasNotas, .ingles)
        XCTAssertFalse(Notacion.espanol.usaASCII)
        XCTAssertFalse(Notacion.ingles.usaASCII)
    }
}
