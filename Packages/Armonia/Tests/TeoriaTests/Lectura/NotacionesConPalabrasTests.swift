import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las tres modalidades del español y del inglés: con palabras (`.conPalabras(.espanol)`, `.conPalabras(.ingles)`),
/// ASCII y Unicode.
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
            #expect(nota.nombre(en: .conPalabras(.espanol)) == espanol)
            #expect(nota.nombre(en: .ascii(.espanol)) == espanolASCII)
            #expect(nota.nombre(en: .compacta(.espanol)) == espanolCompacto)
            #expect(nota.nombre(en: .conPalabras(.ingles)) == ingles)
            #expect(nota.nombre(en: .ascii(.ingles)) == inglesASCII)
            #expect(nota.nombre(en: .compacta(.ingles)) == inglesCompacto)
            // Las seis formas se leen, sin indicar la notación y en cualquiera de las seis.
            for escrito in [espanol, espanolASCII, espanolCompacto, ingles, inglesASCII, inglesCompacto] {
                #expect((try? Nota(leyendo: escrito)) == nota, Comment(rawValue: escrito))
                for notacion in [
                    Notacion.conPalabras(.espanol), .ascii(.espanol), .compacta(.espanol), .conPalabras(.ingles),
                    .ascii(.ingles),
                    .compacta(.ingles),
                ] {
                    #expect((try? Nota(leyendo: escrito, en: notacion)) == nota, "\(escrito) \(notacion)")
                }
            }
        }
    }

    @Test func alturas() {
        let fa = Altura("Fa#4")
        #expect(fa.nombre(en: .conPalabras(.espanol)) == "Fa sostenido 4")
        #expect(fa.nombre(en: .conPalabras(.ingles)) == "F sharp 4")
        #expect((try? Altura(leyendo: "Fa sostenido 4")) == fa)
        #expect((try? Altura(leyendo: "B flat 3")) == Altura("Sib3"))
        #expect((try? Altura(leyendo: "Fa#4", en: .conPalabras(.espanol))) == fa)
        #expect((try? Altura(leyendo: "F sharp 4", en: .conPalabras(.ingles))) == fa)
    }

    /// Con palabras, los cifrados llevan ♯ y ♭ en los dos idiomas.
    @Test func cifrados() {
        let acorde = Acorde("Sib7(b9)/Re")
        #expect(acorde.cifrado(en: .conPalabras(.espanol)) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .conPalabras(.ingles)) == "B♭7(♭9)/D")
        #expect(acorde.cifrado(en: .compacta(.espanol)) == "Si♭7(♭9)/Re")
        #expect(acorde.cifrado(en: .ascii(.ingles)) == "Bb7(b9)/D")
        #expect(Notacion.conPalabras(.espanol).tipografia == .unicode)
        #expect(Notacion.conPalabras(.ingles).tipografia == .unicode)
        #expect((try? Acorde(leyendo: acorde.cifrado(en: .conPalabras(.ingles)))) == acorde)
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
            for notacion in [Notacion.conPalabras(.espanol), .conPalabras(.ingles)] {
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
            for notacion in [Notacion.conPalabras(.espanol), .conPalabras(.ingles)] {
                #expect(
                    (try? Tonalidad(leyendo: tonalidad.texto(en: notacion))) == tonalidad,
                    Comment(rawValue: tonalidad.texto(en: notacion)))
            }
        }
    }

    /// Las de signos son las de antes: `.compacta(.espanol)` era `.espanol` e `.ascii(.ingles)` era `.ingles`.
    @Test func notacionesHabituales() {
        #expect(Notacion.delIdioma(.espanol) == .compacta(.espanol))
        #expect(Notacion.delIdioma(.ingles) == .ascii(.ingles))
        #expect(EscrituraDeNotas.habitual(.espanol) == .compacta(.espanol))
        #expect(EscrituraDeNotas.habitual(.ingles) == .ascii(.ingles))
        #expect(Notacion.conPalabras(.espanol).idiomaDeLasNotas == .espanol)
        #expect(Notacion.conPalabras(.ingles).idiomaDeLasNotas == .ingles)
        #expect(!Notacion.conPalabras(.espanol).usaASCII)
        #expect(!Notacion.conPalabras(.ingles).usaASCII)
    }
}
