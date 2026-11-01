import Armonia
import Foundation
import Testing

@testable import ArmoniaUI

@Suite struct NotacionTests {
    @Test func cadaNotacionTieneTituloYClaveDistintos() {
        let todas = Notacion.allCases
        #expect(Set(todas.map(\.titulo)).count == todas.count)
        #expect(Set(todas.map(\.clave)).count == todas.count)
    }

    /// La clave de cada notación es el nombre de su constante, y el título, el idioma con un ejemplo.
    @Test func lasClavesSonLosCasos() {
        #expect(Notacion.desde(clave: "espanol") == .espanol)
        #expect(Notacion.desde(clave: "espanolUnicode") == .espanolUnicode)
        #expect(Notacion.desde(clave: "inglesASCII") == .inglesASCII)
        #expect(Notacion.desde(clave: "inglesASCII+catalan") == Notacion.inglesASCII.conTextos(en: .catalan))
        #expect(Notacion.espanol.clave == "espanol")
        #expect(Notacion.ingles.clave == "ingles")
        #expect(Notacion.espanol.titulo == "Español (Fa sostenido)")
        #expect(Notacion.ingles.titulo == "English (F sharp)")
        #expect(Notacion.espanolASCII.titulo == "Español (Fa#)")
        #expect(Notacion.inglesASCII.titulo == "English (F#)")
        #expect(Notacion.aleman.titulo == "Deutsch (Fis)")
        #expect(Notacion.espanolASCII.clave == "espanolASCII")
        #expect(Notacion.catalan.clave == "catalan")
    }

    @Test func laClaveVuelveALaNotacion() {
        for notacion in Notacion.allCases {
            #expect(Notacion.desde(clave: notacion.clave) == notacion)
        }
    }

    /// La octava en subíndice se guarda aparte: la clave de la notación no cambia.
    @Test func octavasEnSubindice() {
        let conSubindices = Notacion.desde(clave: "ruso+espanol", octavasEnSubindice: true)
        #expect(conSubindices == Notacion.ruso.conTextos(en: .espanol).conOctavas(.subindices))
        #expect(conSubindices.clave == "ruso+espanol")
        #expect(Notacion.desde(clave: "espanolUnicode", octavasEnSubindice: false) == .espanolUnicode)
        let la4 = Altura(Nota.la, octava: 4)
        #expect(la4.nombre(en: .desde(clave: "espanolUnicode", octavasEnSubindice: true)) == "La₄")
    }

    @Test func notasYTextosPorSeparado() {
        let rusoEnEspanol = Notacion.ruso.conTextos(en: .espanol)
        #expect(rusoEnEspanol.clave == "ruso+espanol")
        #expect(Notacion.desde(clave: "ruso+espanol") == rusoEnEspanol)
        #expect(rusoEnEspanol.titulo == "Русский (фа-диез) · Español")
        #expect(rusoEnEspanol.idiomaElegidoParaLosTextos == .espanol)
        #expect(Notacion.ruso.idiomaElegidoParaLosTextos == nil)
        // Cambiar las notas conserva los textos, y quitar los textos deja las notas.
        #expect(rusoEnEspanol.conNotas(.griego) == Notacion.griego.conTextos(en: .espanol))
        #expect(Notacion.ruso.conNotas(.griego) == .griego)
        #expect(rusoEnEspanol.conTextosElegidos(nil) == .ruso)
        #expect(Notacion.inglesASCII.conTextosElegidos(.catalan).clave == "inglesASCII+catalan")
        // Una parte desconocida no rompe nada.
        #expect(Notacion.desde(clave: "ruso+klingon") == .ruso)
        #expect(Notacion.desde(clave: "klingon+espanol") == .espanolUnicode)
        #expect(Set(Idioma.allCases.map(\.clave)).count == Idioma.allCases.count)
    }

    @Test func unaClaveDesconocidaDaElEspanol() {
        #expect(Notacion.desde(clave: "") == .espanolUnicode)
        #expect(Notacion.desde(clave: "klingon") == .espanolUnicode)
        // Un ajuste antiguo guardado como índice no rompe nada.
        #expect(Notacion.desde(clave: "3") == .espanolUnicode)
    }

    @Test func elMensajeDeUnErrorAjenoEsSuDescripcion() {
        struct Falla: LocalizedError { var errorDescription: String? { "falla de prueba" } }
        #expect(Notacion.espanolUnicode.mensaje(de: Falla()) == "falla de prueba")
    }

    @Test func elMensajeDeUnErrorDeLecturaNoEstaVacio() throws {
        do {
            _ = try Acorde(leyendo: "xyz!")
            Issue.record("«xyz!» no es un cifrado")
        } catch {
            #expect(!(Notacion.espanolUnicode.mensaje(de: error).isEmpty))
            #expect(!(Notacion.inglesASCII.mensaje(de: error).isEmpty))
        }
    }
}
