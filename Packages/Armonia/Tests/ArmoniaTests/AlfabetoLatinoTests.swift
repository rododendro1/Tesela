import Foundation
import Testing

@testable import Armonia
@testable import Elementos
@testable import Teoria

/// El ruso y el griego en el alfabeto latino: la transliteración ISO 9 y la ELOT 743, y las notaciones con
/// `alfabeto: .latino`.
@Suite struct AlfabetoLatinoTests {
    private let ruso = Notacion.conPalabras(.ruso).conAlfabeto(.latino)
    private let griego = Notacion.conPalabras(.griego).conAlfabeto(.latino)

    /// Una letra cirílica o griega.
    private func tieneOtroAlfabeto(_ texto: String) -> Bool {
        texto.unicodeScalars.contains {
            (0x0370...0x03FF).contains($0.value) || (0x1F00...0x1FFF).contains($0.value)
                || (0x0400...0x04FF).contains($0.value)
        }
    }

    @Test func cirilicoISO9() {
        let casos: [(String, String)] = [
            ("фа-диез мажор", "fa-diez mažor"), ("большая терция", "bolʹšaâ terciâ"),
            ("доминантсептаккорд", "dominantseptakkord"), ("щука", "ŝuka"), ("ёж", "ëž"),
            ("Чайковский", "Čajkovskij"), ("Шостакович", "Šostakovič"), ("Хачатурян", "Hačaturân"),
            ("объём", "obʺëm"), ("эхо", "èho"), ("Юрий", "Ûrij"), ("цыган", "cygan"),
        ]
        for (cirilico, latino) in casos { #expect(Transliteracion.latina(cirilico) == latino, "\(cirilico)") }
    }

    @Test func griegoELOT743() {
        let casos: [(String, String)] = [
            ("φα δίεση", "fa díesi"), ("μεγάλη τρίτη", "megáli tríti"), ("θέμα", "théma"), ("Θέμα", "Théma"),
            ("ΘΕΜΑ", "THEMA"), ("χρωματικός", "chromatikós"), ("ψαλτική", "psaltikí"), ("ξένος", "xénos"),
            ("μουσική", "mousikí"), ("Ούτε", "Oúte"), ("μπάσο", "báso"), ("λάμπα", "lámpa"), ("Ντο", "Do"),
            ("πέντε", "pénte"), ("αυτός", "aftós"), ("αύριο", "ávrio"), ("Ευρώπη", "Evrópi"), ("ευθεία", "eftheía"),
            ("άγγελος", "ángelos"), ("αγκάθι", "agkáthi"), ("σφίγξ", "sfínx"), ("ελέγχω", "eléncho"),
            ("Μαΐου", "Maïou"), ("προϋπόθεση", "proÿpóthesi"), ("ς", "s"),
        ]
        for (griego, latino) in casos { #expect(Transliteracion.latina(griego) == latino, "\(griego)") }
    }

    @Test func elRestoNoCambia() {
        for texto in ["Fa♯ dórico", "Fis-Dur", "C7(♭9)/E", "", "fa díesi"] {
            #expect(Transliteracion.latina(texto) == texto)
            #expect(Transliteracion.latina(Transliteracion.latina(texto)) == Transliteracion.latina(texto))
        }
    }

    @Test func notasYTextos() throws {
        #expect(Nota(.fa, .sostenido).nombre(en: ruso) == "fa-diez")
        #expect(Nota(.sol).nombre(en: ruso) == "solʹ")
        #expect(Nota(.sol, .sostenido).nombre(en: .compacta(.ruso).conAlfabeto(.latino)) == "Solʹ♯")
        #expect(Nota(.fa, .sostenido).nombre(en: griego) == "fa díesi")
        #expect(Tonalidad(Nota(.mi, .bemol), .menor).nombre(en: ruso) == "mi-bemolʹ minor")
        #expect(Tonalidad(Nota(.mi, .bemol), .mayor).nombre(en: griego) == "mi ýfesi meízona")
        #expect(Intervalo.terceraMayor.nombre(en: ruso) == "bolʹšaâ terciâ")
        #expect(Intervalo.terceraMayor.nombre(en: griego) == "megáli tríti")
        let acorde = try Acorde(leyendo: "Sol7/Si")
        #expect(acorde.nombre(en: ruso) == "dominantseptakkord ot solʹ, pervoe obraŝenie")
        #expect(acorde.cifrado(en: ruso) == "Solʹ7/Si")
        #expect(Escala(Nota(.re), .dorico).nombre(en: griego) == "re dórios")
        // En los demás idiomas no cambia nada, y con el alfabeto propio, tampoco.
        #expect(Intervalo.terceraMayor.nombre(en: .compacta(.aleman).conAlfabeto(.latino)) == "große Terz")
        #expect(Intervalo.terceraMayor.nombre(en: .conPalabras(.ruso)) == "большая терция")
        // Con las notas en ruso y los textos en español, las notas en el alfabeto latino.
        #expect(acorde.nombre(en: ruso.conTextos(en: .espanol)) == "solʹ séptima de dominante, primera inversión")
        #expect(Nota(.sol).nombre(en: ruso.conTextos(en: .espanol)) == "solʹ")
    }

    @Test func ningunNombreDelCatalogoQuedaEnSuAlfabeto() {
        for notacion in [ruso, griego] {
            for tipo in TipoDeEscala.occidentales + TipoDeEscala.tradicionales {
                #expect(!tieneOtroAlfabeto(Escala(Nota(.do), tipo).nombre(en: notacion)), "\(tipo.nombre)")
            }
            for tipo in TipoDeAcorde.todos {
                #expect(!tieneOtroAlfabeto(tipo.nombre(en: notacion)), "\(tipo)")
            }
            for intervalo in [Intervalo.terceraMenor, .terceraMayor, .quintaJusta, .decimoterceraMayor] {
                #expect(!tieneOtroAlfabeto(intervalo.nombre(en: notacion)))
            }
        }
    }

    @Test func seLeenEnElAlfabetoLatino() throws {
        #expect(try Nota(leyendo: "fa-diez", en: ruso) == Nota(.fa, .sostenido))
        #expect(try Nota(leyendo: "solʹ", en: ruso) == Nota(.sol))
        #expect(try Nota(leyendo: "fa díesi", en: griego) == Nota(.fa, .sostenido))
        #expect(try Escala(leyendo: "fa-diez dorijskij", en: ruso) == Escala(Nota(.fa, .sostenido), .dorico))
        #expect(try Escala(leyendo: "re dórios", en: griego) == Escala(Nota(.re), .dorico))
        // Y lo escrito en su alfabeto, igual.
        #expect(try Nota(leyendo: "фа-диез", en: ruso) == Nota(.fa, .sostenido))
    }

    @Test func seGuardaElAlfabeto() throws {
        let codificador = JSONEncoder()
        codificador.outputFormatting = .sortedKeys
        let latino = try codificador.encode(ruso)
        #expect(try JSONDecoder().decode(Notacion.self, from: latino) == ruso)
        // El alfabeto propio no se guarda, y lo guardado sin alfabeto se lee con el propio.
        let propio = try codificador.encode(Notacion.conPalabras(.ruso))
        #expect(!String(decoding: propio, as: UTF8.self).contains("alfabeto"))
        #expect(try JSONDecoder().decode(Notacion.self, from: propio) == .conPalabras(.ruso))
        #expect(ruso.conTextos(en: .espanol).alfabeto == .latino)
        #expect(ruso.conOctavas(.subindices).alfabeto == .latino)
        #expect(ruso.notas.alfabeto == .latino)
        #expect(ruso.enSuAlfabeto("соль") == "solʹ")
        #expect(Notacion.conPalabras(.ruso).enSuAlfabeto("соль") == "соль")
    }
}
