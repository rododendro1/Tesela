import Foundation
import Testing

@testable import Armonia
@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las tres modalidades del español y del inglés: con palabras (`.espanol`, `.ingles`), ASCII y Unicode.
@Suite struct NotacionesConPalabrasTests {
    @Test func nombresDeNota() {
        let casos: [(String, String, String, String, String, String, String)] = [
            ("Fa#", "Fa sostenido", "Fa#", "Fa♯", "F sharp", "F#", "F♯"),
            ("Sib", "Si bemol", "Sib", "Si♭", "B flat", "Bb", "B♭"),
            ("Dox", "Do doble sostenido", "Do##", "Do♯♯", "C double sharp", "C##", "C♯♯"),
            ("Mibb", "Mi doble bemol", "Mibb", "Mi♭♭", "E double flat", "Ebb", "E♭♭"),
            ("Re", "Re", "Re", "Re", "D", "D", "D"),
        ]
        for (texto, espanol, espanolASCII, espanolUnicode, ingles, inglesASCII, inglesUnicode) in casos {
            let nota = Nota(texto: texto)!
            #expect(nota.nombre(en: .espanol) == espanol)
            #expect(nota.nombre(en: .espanolASCII) == espanolASCII)
            #expect(nota.nombre(en: .espanolUnicode) == espanolUnicode)
            #expect(nota.nombre(en: .ingles) == ingles)
            #expect(nota.nombre(en: .inglesASCII) == inglesASCII)
            #expect(nota.nombre(en: .inglesUnicode) == inglesUnicode)
            // Las seis formas se leen, sin indicar la notación y en cualquiera de las seis.
            for escrito in [espanol, espanolASCII, espanolUnicode, ingles, inglesASCII, inglesUnicode] {
                #expect(Nota(texto: escrito) == nota, Comment(rawValue: escrito))
                for notacion in [
                    Notacion.espanol, .espanolASCII, .espanolUnicode, .ingles, .inglesASCII, .inglesUnicode,
                ] {
                    #expect((try? Nota(leyendo: escrito, en: notacion)) == nota, "\(escrito) \(notacion)")
                }
            }
        }
    }

    @Test func alturas() {
        let fa = Altura("Fa#4")
        #expect(fa.nombre(en: .espanol) == "Fa sostenido 4")
        #expect(fa.nombre(en: .ingles) == "F sharp 4")
        #expect(Altura(texto: "Fa sostenido 4") == fa)
        #expect(Altura(texto: "B flat 3") == Altura("Sib3"))
        #expect((try? Altura(leyendo: "Fa#4", en: .espanol)) == fa)
        #expect((try? Altura(leyendo: "F sharp 4", en: .ingles)) == fa)
    }

    /// Con palabras, los cifrados llevan ♯ y ♭ en los dos idiomas.
    @Test func cifrados() {
        let acorde = Acorde("Sib7(b9)/Re")
        #expect(acorde.cifrado(en: .espanol) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .ingles) == "B♭7(♭9)/D")
        #expect(acorde.cifrado(en: .espanolUnicode) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .inglesASCII) == "Bb7(b9)/D")
        #expect(Notacion.espanol.tipografia == .unicode)
        #expect(Notacion.ingles.tipografia == .unicode)
        #expect(Acorde(texto: acorde.cifrado(en: .ingles)) == acorde)
    }

    /// Los cifrados se leen con la fundamental y el bajo en palabras, separadas de la nota por un espacio.
    @Test func cifradosConPalabras() {
        #expect(Acorde(texto: "Fa sostenido m7") == Acorde("Fa#m7"))
        #expect(Acorde(texto: "Fa sostenido") == Acorde("Fa#"))
        #expect(Acorde(texto: "B flat 7(b9)") == Acorde("Bb7(b9)"))
        #expect(Acorde(texto: "B flat7") == Acorde("Bb7"))
        #expect(Acorde(texto: "Mi doble bemol maj7") == Acorde("Mibbmaj7"))
        #expect(Acorde(texto: "C double sharp") == Acorde("C##"))
        #expect(Acorde(texto: "Si bemol/Re") == Acorde("Sib/Re"))
        #expect(Acorde(texto: "Sol7/Fa sostenido") == Acorde("Sol7/Fa#"))
        #expect(Acorde(texto: "D7/F sharp") == Acorde("D7/F#"))
        #expect(Acorde(texto: "la bemol m") == Acorde("Labm"))
        // La palabra tiene que terminar, y va en el idioma de la nota, como el bajo.
        #expect(Acorde(texto: "Fa sostenidom7") == nil)
        #expect(Acorde(texto: "Fa sharp m7") == nil)
        #expect(Acorde(texto: "Sol7/F sharp") == nil)
        // Lo de siempre sigue igual.
        #expect(Acorde(texto: "Faug")?.fundamental == Nota("F"))
        // Ida y vuelta: la fundamental y el bajo con palabras, y el tipo como siempre.
        let acordes: [Acorde] = ["Fa#m7", "Sib7(b9)/Re", "Mibmaj7", "Do#°7", "Lab/Do"]
        for acorde in acordes {
            for notacion in [Notacion.espanol, .ingles] {
                let bajo = acorde.bajo == acorde.fundamental ? "" : "/" + acorde.bajo.nombre(en: notacion)
                let escrito = acorde.fundamental.nombre(en: notacion) + " " + acorde.tipo.cifrado + bajo
                #expect(Acorde(texto: escrito) == acorde, Comment(rawValue: escrito))
            }
        }
    }

    @Test func escalasYTonalidades() {
        #expect(Escala(texto: "Fa sostenido dórico") == Escala("Fa# dórico"))
        #expect(Escala(texto: "F sharp dorian") == Escala("Fa# dórico"))
        #expect(Escala(texto: "B double flat lydian") == Escala("Sibb lidio"))
        #expect(Tonalidad(texto: "Fa sostenido mayor") == Tonalidad("Fa# mayor"))
        #expect(Tonalidad(texto: "E flat minor") == Tonalidad("Mib menor"))
        // «B» sola en alemán sigue siendo Si♭.
        #expect(Escala(texto: "B dorisch") == Escala("Sib dórico"))
        for tonalidad in [Tonalidad("Fa# mayor"), Tonalidad("Mib menor"), Tonalidad("Do mayor")] {
            for notacion in [Notacion.espanol, .ingles] {
                #expect(
                    Tonalidad(texto: tonalidad.texto(en: notacion)) == tonalidad,
                    Comment(rawValue: tonalidad.texto(en: notacion)))
            }
        }
    }

    /// Las de signos son las de antes: `.espanolUnicode` era `.espanol` e `.inglesASCII` era `.ingles`.
    @Test func notacionesHabituales() {
        #expect(Notacion.delIdioma(.espanol) == .espanolUnicode)
        #expect(Notacion.delIdioma(.ingles) == .inglesASCII)
        #expect(EscrituraDeNotas(idioma: .espanol, ascii: false) == .espanolUnicode)
        #expect(EscrituraDeNotas(idioma: .ingles, ascii: true) == .inglesASCII)
        #expect(Notacion.espanol.idiomaDeLasNotas == .espanol)
        #expect(Notacion.ingles.idiomaDeLasNotas == .ingles)
        #expect(!Notacion.espanol.usaASCII)
        #expect(!Notacion.ingles.usaASCII)
    }
}
