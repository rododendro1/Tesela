import Foundation
import Testing

@testable import ArmoniaNucleo
@testable import ArmoniaTeoria

/// Las escrituras compactas de los idiomas que nombran las alteraciones con palabras: la sílaba en mayúscula,
/// el signo y la octava en subíndice (Fa♯, Ré♭, La₄), con los textos del idioma.
@Suite struct NotacionesCompactasTests {
    @Test func nombresDeNotas() {
        #expect(Nota("Reb").nombre(en: .francesCompacto) == "Ré♭")
        #expect(Nota("Fa#").nombre(en: .catalanCompacto) == "Fa♯")
        #expect(Nota("Sib").nombre(en: .portuguesCompacto) == "Si♭")
        #expect(Nota("Fa#").nombre(en: .rusoCompacto) == "Фа♯")
        #expect(Nota("Fa#").nombre(en: .griegoCompacto) == "Φα♯")
        #expect(Nota("Do##").nombre(en: .italianoCompacto) == "Do♯♯")
        #expect(Nota("Mi").nombre(en: .euskeraCompacto) == "Mi")
        // Las de palabras no cambian.
        #expect(Nota("Reb").nombre(en: .frances) == "ré bémol")
    }

    @Test func alturasConSubindice() {
        #expect(Altura("Fa#4").nombre(en: .catalanCompacto) == "Fa♯₄")
        #expect(Altura("Sib3").nombre(en: .gallegoCompacto) == "Si♭₃")
        #expect(Notacion.occitanoCompacto.octavas == .subindices)
        #expect(Notacion.occitano.octavas == .cifras)
    }

    @Test func leerEnCompacto() throws {
        #expect(try Nota(leyendo: "Ré♭", en: .francesCompacto) == Nota("Reb"))
        #expect(try Nota(leyendo: "ré bémol", en: .francesCompacto) == Nota("Reb"))
        #expect(try Nota(leyendo: "Ré♭", en: .frances) == Nota("Reb"))
        #expect(try Nota(leyendo: "Фа♯", en: .rusoCompacto) == Nota("Fa#"))
        #expect(try Altura(leyendo: "Fa♯₄", en: .catalanCompacto) == Altura("Fa#4"))
        #expect(throws: ErrorDeLectura.self) { try Nota(leyendo: "F#", en: .italianoCompacto) }
    }

    @Test func cadaIdiomaTieneSuCompacta() {
        for idioma in Idioma.allCases {
            let compacta = EscrituraDeNotas.compacta(idioma)
            #expect(compacta.esCompacta, "\(idioma)")
            #expect(compacta.idioma == idioma)
            #expect(!EscrituraDeNotas.conPalabras(idioma).esCompacta, "\(idioma)")
            #expect(EscrituraDeNotas.allCases.contains(compacta), "\(idioma)")
        }
        #expect(EscrituraDeNotas.allCases.count == 32)
        // La notación de cada idioma sigue siendo la de siempre.
        #expect(Notacion.delIdioma(.catalan) == .catalan)
        #expect(Notacion.delIdioma(.frances) == .frances)
        #expect(Notacion.delIdioma(.espanol) == .espanolCompacto)
        // Los textos son los del idioma.
        #expect(Intervalo.terceraMayor.nombre(en: .francesCompacto) == "tierce majeure")
        #expect(Acorde("Sol7").nombre(en: .italianoCompacto).hasPrefix("Sol"))
    }
}
