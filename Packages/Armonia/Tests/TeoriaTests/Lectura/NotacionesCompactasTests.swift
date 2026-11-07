import Foundation
import Testing

@testable import Elementos
@testable import Teoria

/// Las escrituras compactas de los idiomas que nombran las alteraciones con palabras: la sílaba en mayúscula,
/// el signo y la octava en subíndice (Fa♯, Ré♭, La₄), con los textos del idioma.
@Suite struct NotacionesCompactasTests {
    @Test func nombresDeNotas() {
        #expect(Nota("Reb").nombre(en: .compacta(.frances)) == "Ré♭")
        #expect(Nota("Fa#").nombre(en: .compacta(.catalan)) == "Fa♯")
        #expect(Nota("Sib").nombre(en: .compacta(.portugues)) == "Si♭")
        #expect(Nota("Fa#").nombre(en: .compacta(.ruso)) == "Фа♯")
        #expect(Nota("Fa#").nombre(en: .compacta(.griego)) == "Φα♯")
        #expect(Nota("Do##").nombre(en: .compacta(.italiano)) == "Do𝄪")
        #expect(Nota("Mi").nombre(en: .compacta(.euskera)) == "Mi")
        // Las de palabras no cambian.
        #expect(Nota("Reb").nombre(en: .conPalabras(.frances)) == "ré bémol")
    }

    @Test func lasCompactasEscribenLasDoblesConDobles() throws {
        for idioma in Idioma.allCases where ![.aleman, .hungaro].contains(idioma) {
            #expect(Notacion(escritura: .compacta(idioma)).tipografia == .conDobles, Comment(rawValue: idioma.codigo))
        }
        let conSignos = EscrituraDeNotas.allCases.filter { $0.esCompacta && $0.escrituraDeLaAlteracion == .signos }
        #expect(conSignos.count == 10)
        #expect(Set(conSignos.map(\.tipografia)) == [.conDobles])
        #expect(Nota("Sibb").nombre(en: .espanolCompacto) == "Si𝄫")
        #expect(Nota("Do###").nombre(en: .compacta(.frances)) == "Do𝄪♯")
        #expect(Nota("Fa##").nombre(en: .compacta(.ruso)) == "Фа𝄪")
        #expect(Nota("Re").nombre(en: .espanolCompacto) == "Re")
        #expect(Nota("Sibb").nombre(en: .inglesCompacto) == "B𝄫")
        #expect(Notacion.delIdioma(.espanol) == .espanolCompacto)
        #expect(try Nota(leyendo: "Si𝄫") == Nota("Sibb"))
        // También el nombre, la descripción y lo guardado.
        #expect(Altura("Sibb3").description == "Si𝄫3")
        #expect(Nota("Sibb").nombre == "Si𝄫")
    }

    @Test func alturasConSubindice() {
        #expect(Altura("Fa#4").nombre(en: .compacta(.catalan)) == "Fa♯₄")
        #expect(Altura("Sib3").nombre(en: .compacta(.gallego)) == "Si♭₃")
        #expect(Notacion.compacta(.euskera).octavas == .subindices)
        #expect(Notacion.conPalabras(.euskera).octavas == .cifras)
    }

    @Test func leerEnCompacto() throws {
        #expect(try Nota(leyendo: "Ré♭", en: .compacta(.frances)) == Nota("Reb"))
        #expect(try Nota(leyendo: "ré bémol", en: .compacta(.frances)) == Nota("Reb"))
        #expect(try Nota(leyendo: "Ré♭", en: .conPalabras(.frances)) == Nota("Reb"))
        #expect(try Nota(leyendo: "Фа♯", en: .compacta(.ruso)) == Nota("Fa#"))
        #expect(try Altura(leyendo: "Fa♯₄", en: .compacta(.catalan)) == Altura("Fa#4"))
        #expect(throws: ErrorDeLectura.self) { try Nota(leyendo: "F#", en: .compacta(.italiano)) }
    }

    @Test func cadaIdiomaTieneSuCompacta() {
        for idioma in Idioma.allCases {
            let compacta = EscrituraDeNotas.compacta(idioma)
            #expect(compacta.esCompacta, "\(idioma)")
            #expect(compacta.idioma == idioma)
            #expect(!EscrituraDeNotas.conPalabras(idioma).esCompacta, "\(idioma)")
            #expect(EscrituraDeNotas.allCases.contains(compacta), "\(idioma)")
        }
        #expect(EscrituraDeNotas.allCases.count == 26)
        // La notación de cada idioma sigue siendo la de siempre.
        #expect(Notacion.delIdioma(.catalan) == .conPalabras(.catalan))
        #expect(Notacion.delIdioma(.frances) == .conPalabras(.frances))
        #expect(Notacion.delIdioma(.espanol) == .espanolCompacto)
        // Los textos son los del idioma.
        #expect(Intervalo.terceraMayor.nombre(en: .compacta(.frances)) == "tierce majeure")
        #expect(Acorde("Sol7").nombre(en: .compacta(.italiano)).hasPrefix("Sol"))
    }
}
