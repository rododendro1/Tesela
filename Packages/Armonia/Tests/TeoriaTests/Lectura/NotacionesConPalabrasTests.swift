import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las tres modalidades del español y del inglés: con palabras (`.espanolPalabras`, `.inglesPalabras`), ASCII y Unicode.
@Suite struct NotacionesConPalabrasTests {
    @Test func nombresDeNota() {
        let casos: [(String, String, String, String, String, String, String)] = [
            ("Fa#", "Fa sostenido", "Fa#", "Fa♯", "F sharp", "F#", "F♯"),
            ("Sib", "Si bemol", "Sib", "Si♭", "B flat", "Bb", "B♭"),
            ("Dox", "Do doble sostenido", "Do##", "Do𝄪", "C double sharp", "C##", "C𝄪"),
            ("Mibb", "Mi doble bemol", "Mibb", "Mi𝄫", "E double flat", "Ebb", "E𝄫"),
            ("Re", "Re", "Re", "Re", "D", "D", "D"),
        ]
        for (texto, espanol, espanolASCII, espanolCompacto, ingles, inglesASCII, inglesCompacto) in casos {
            let nota = try! Nota(leyendo: texto)
            #expect(nota.nombre(en: .espanolPalabras) == espanol)
            #expect(nota.nombre(en: .espanolASCII) == espanolASCII)
            #expect(nota.nombre(en: .espanolCompacto) == espanolCompacto)
            #expect(nota.nombre(en: .inglesPalabras) == ingles)
            #expect(nota.nombre(en: .inglesASCII) == inglesASCII)
            #expect(nota.nombre(en: .inglesCompacto) == inglesCompacto)
            // Las seis formas se leen, sin indicar la notación y en cualquiera de las seis.
            for escrito in [espanol, espanolASCII, espanolCompacto, ingles, inglesASCII, inglesCompacto] {
                #expect((try? Nota(leyendo: escrito)) == nota, Comment(rawValue: escrito))
                for notacion in [
                    Notacion.espanolPalabras, .espanolASCII, .espanolCompacto, .inglesPalabras, .inglesASCII,
                    .inglesCompacto,
                ] {
                    #expect((try? Nota(leyendo: escrito, en: notacion)) == nota, "\(escrito) \(notacion)")
                }
            }
        }
    }

    @Test func alturas() {
        let fa = Altura("Fa#4")
        #expect(fa.nombre(en: .espanolPalabras) == "Fa sostenido 4")
        #expect(fa.nombre(en: .inglesPalabras) == "F sharp 4")
        #expect((try? Altura(leyendo: "Fa sostenido 4")) == fa)
        #expect((try? Altura(leyendo: "B flat 3")) == Altura("Sib3"))
        #expect((try? Altura(leyendo: "Fa#4", en: .espanolPalabras)) == fa)
        #expect((try? Altura(leyendo: "F sharp 4", en: .inglesPalabras)) == fa)
    }

    /// Con palabras, los cifrados llevan ♯ y ♭ en los dos idiomas.
    @Test func cifrados() {
        let acorde = Acorde("Sib7(b9)/Re")
        #expect(acorde.cifrado(en: .espanolPalabras) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .inglesPalabras) == "B♭7(♭9)/D")
        #expect(acorde.cifrado(en: .espanolCompacto) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .inglesASCII) == "Bb7(b9)/D")
        #expect(Notacion.espanolPalabras.tipografia == .conSimples)
        #expect(Notacion.inglesPalabras.tipografia == .conSimples)
        #expect((try? Acorde(leyendo: acorde.cifrado(en: .inglesPalabras))) == acorde)
    }

    /// Los cifrados se leen con la fundamental y el bajo en palabras, separadas de la nota por un espacio.
    @Test func cifradosConPalabras() {
        #expect((try? Acorde(leyendo: "Fa sostenido m7")) == Acorde("Fa#m7"))
        #expect((try? Acorde(leyendo: "Fa sostenido")) == Acorde("Fa#"))
        #expect((try? Acorde(leyendo: "B flat 7(b9)")) == Acorde("Bb7(b9)"))
        #expect((try? Acorde(leyendo: "B flat7")) == Acorde("Bb7"))
        #expect((try? Acorde(leyendo: "Mi doble bemol maj7")) == Acorde("Mibbmaj7"))
        #expect((try? Acorde(leyendo: "C double sharp")) == Acorde("C##"))
        #expect((try? Acorde(leyendo: "Si bemol/Re")) == Acorde("Sib/Re"))
        #expect((try? Acorde(leyendo: "Sol7/Fa sostenido")) == Acorde("Sol7/Fa#"))
        #expect((try? Acorde(leyendo: "D7/F sharp")) == Acorde("D7/F#"))
        #expect((try? Acorde(leyendo: "la bemol m")) == Acorde("Labm"))
        // La palabra tiene que terminar, y va en el idioma de la nota, como el bajo.
        #expect((try? Acorde(leyendo: "Fa sostenidom7")) == nil)
        #expect((try? Acorde(leyendo: "Fa sharp m7")) == nil)
        #expect((try? Acorde(leyendo: "Sol7/F sharp")) == nil)
        // Lo de siempre sigue igual.
        #expect((try? Acorde(leyendo: "Faug"))?.fundamental == Nota("F"))
        // Ida y vuelta: la fundamental y el bajo con palabras, y el tipo como siempre.
        let acordes: [Acorde] = ["Fa#m7", "Sib7(b9)/Re", "Mibmaj7", "Do#°7", "Lab/Do"]
        for acorde in acordes {
            for notacion in [Notacion.espanolPalabras, .inglesPalabras] {
                let bajo = acorde.bajo == acorde.fundamental ? "" : "/" + acorde.bajo.nombre(en: notacion)
                let escrito = acorde.fundamental.nombre(en: notacion) + " " + acorde.tipo.cifrado + bajo
                #expect((try? Acorde(leyendo: escrito)) == acorde, Comment(rawValue: escrito))
            }
        }
    }

    @Test func escalasYTonalidades() {
        #expect((try? Escala(leyendo: "Fa sostenido dórico")) == Escala("Fa# dórico"))
        #expect((try? Escala(leyendo: "F sharp dorian")) == Escala("Fa# dórico"))
        #expect((try? Escala(leyendo: "B double flat lydian")) == Escala("Sibb lidio"))
        #expect((try? Tonalidad(leyendo: "Fa sostenido mayor")) == Tonalidad("Fa# mayor"))
        #expect((try? Tonalidad(leyendo: "E flat minor")) == Tonalidad("Mib menor"))
        // «B» sola en alemán sigue siendo Si♭.
        #expect((try? Escala(leyendo: "B dorisch")) == Escala("Sib dórico"))
        for tonalidad in [Tonalidad("Fa# mayor"), Tonalidad("Mib menor"), Tonalidad("Do mayor")] {
            for notacion in [Notacion.espanolPalabras, .inglesPalabras] {
                #expect(
                    (try? Tonalidad(leyendo: tonalidad.texto(en: notacion))) == tonalidad,
                    Comment(rawValue: tonalidad.texto(en: notacion)))
            }
        }
    }

    /// Las de signos son las de antes: `.espanolCompacto` era `.espanol` e `.inglesASCII` era `.ingles`.
    @Test func notacionesHabituales() {
        #expect(Notacion.delIdioma(.espanol) == .espanolCompacto)
        #expect(Notacion.delIdioma(.ingles) == .inglesASCII)
        #expect(EscrituraDeNotas(idioma: .espanol, ascii: false) == .espanolCompacto)
        #expect(EscrituraDeNotas(idioma: .ingles, ascii: true) == .inglesASCII)
        #expect(Notacion.espanolPalabras.idiomaDeLasNotas == .espanol)
        #expect(Notacion.inglesPalabras.idiomaDeLasNotas == .ingles)
        #expect(!Notacion.espanolPalabras.usaASCII)
        #expect(!Notacion.inglesPalabras.usaASCII)
    }
}
