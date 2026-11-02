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
        #expect(Notacion.desde(clave: "espanol") == .espanolPalabras)
        #expect(Notacion.desde(clave: "espanolCompacto") == .espanolCompacto)
        // Sin tocar el ajuste, la octava va como la escriba la notación.
        #expect(Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: nil).octavas == .subindices)
        #expect(Notacion.desde(clave: "espanol", octavasEnSubindice: nil).octavas == .cifras)
        #expect(Notacion.desde(clave: "inglesASCII") == .inglesASCII)
        // Las claves de antes de las notaciones compactas se siguen leyendo.
        #expect(Notacion.desde(clave: "espanolUnicode") == .espanolCompacto)
        #expect(Notacion.desde(clave: "inglesUnicode+catalan") == Notacion.inglesCompacto.conTextos(en: .catalan))
        #expect(Notacion.espanolCompacto.clave == "espanolCompacto")
        #expect(Notacion.inglesCompacto.clave == "inglesCompacto")
        #expect(Notacion.desde(clave: "inglesASCII+catalan") == Notacion.inglesASCII.conTextos(en: .catalan))
        #expect(Notacion.espanolPalabras.clave == "espanol")
        #expect(Notacion.inglesPalabras.clave == "ingles")
        #expect(Notacion.espanolPalabras.titulo == "Español (Fa sostenido)")
        #expect(Notacion.inglesPalabras.titulo == "English (F sharp)")
        #expect(Notacion.espanolASCII.titulo == "Español (Fa#)")
        #expect(Notacion.inglesASCII.titulo == "English (F#)")
        #expect(Notacion.alemanPalabras.titulo == "Deutsch (F Kreuz)")
        #expect(Notacion.alemanCompacto.titulo == "Deutsch (Fis)")
        #expect(Notacion.alemanPalabras.clave == "alemanPalabras")
        #expect(Notacion.desde(clave: "alemanPalabras") == .alemanPalabras)
        // «aleman» era Fis antes de la 0.3.0, y se sigue leyendo así.
        #expect(Notacion.desde(clave: "aleman") == .alemanCompacto)
        #expect(Notacion.desde(clave: "aleman+espanol") == Notacion.alemanCompacto.conTextos(en: .espanol))
        #expect(Notacion.alemanCompacto.clave == "alemanCompacto")
        #expect(Notacion.desde(clave: "alemanCompacto") == .alemanCompacto)
        #expect(Notacion.espanolASCII.clave == "espanolASCII")
        #expect(Notacion.catalanPalabras.clave == "catalan")
        #expect(Notacion.francesCompacto.clave == "francesCompacto")
        #expect(Notacion.desde(clave: "rusoCompacto+espanol") == Notacion.rusoCompacto.conTextos(en: .espanol))
        #expect(Notacion.francesPalabras.titulo == "Français (fa dièse)")
        #expect(Notacion.francesCompacto.titulo == "Français (Fa♯)")
        #expect(Notacion.rusoCompacto.titulo == "Русский (Фа♯)")
    }

    @Test func laClaveVuelveALaNotacion() {
        for notacion in Notacion.allCases {
            #expect(Notacion.desde(clave: notacion.clave) == notacion)
        }
    }

    /// La octava en subíndice se guarda aparte: la clave de la notación no cambia.
    @Test func octavasEnSubindice() {
        let conSubindices = Notacion.desde(clave: "ruso+espanol", octavasEnSubindice: true)
        #expect(conSubindices == Notacion.rusoPalabras.conTextos(en: .espanol).conOctavas(.subindices))
        #expect(conSubindices.clave == "ruso+espanol")
        // Si se ha tocado, manda el ajuste, también en las compactas.
        #expect(
            Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: false) == .espanolCompacto.conOctavas(.cifras))
        #expect(Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: true) == .espanolCompacto)
        #expect(Notacion.desde(clave: "espanolCompacto") == .espanolCompacto)
        let la4 = Altura(Nota.la, octava: 4)
        #expect(la4.nombre(en: .desde(clave: "espanolCompacto", octavasEnSubindice: true)) == "La₄")
    }

    @Test func notasYTextosPorSeparado() {
        let rusoEnEspanol = Notacion.rusoPalabras.conTextos(en: .espanol)
        #expect(rusoEnEspanol.clave == "ruso+espanol")
        #expect(Notacion.desde(clave: "ruso+espanol") == rusoEnEspanol)
        #expect(rusoEnEspanol.titulo == "Русский (фа-диез) · Español")
        #expect(rusoEnEspanol.idiomaElegidoParaLosTextos == .espanol)
        #expect(Notacion.rusoPalabras.idiomaElegidoParaLosTextos == nil)
        // Cambiar las notas conserva los textos, y quitar los textos deja las notas.
        #expect(rusoEnEspanol.conNotas(.griegoPalabras) == Notacion.griegoPalabras.conTextos(en: .espanol))
        #expect(Notacion.rusoPalabras.conNotas(.griegoPalabras) == .griegoPalabras)
        #expect(rusoEnEspanol.conTextosElegidos(nil) == .rusoPalabras)
        #expect(Notacion.inglesASCII.conTextosElegidos(.catalan).clave == "inglesASCII+catalan")
        // Una parte desconocida no rompe nada.
        #expect(Notacion.desde(clave: "ruso+klingon") == .rusoPalabras)
        #expect(Notacion.desde(clave: "klingon+espanol") == .espanolCompacto)
        #expect(Set(Idioma.allCases.map(\.clave)).count == Idioma.allCases.count)
    }

    @Test func unaClaveDesconocidaDaElEspanol() {
        #expect(Notacion.desde(clave: "") == .espanolCompacto)
        #expect(Notacion.desde(clave: "klingon") == .espanolCompacto)
        // Un ajuste antiguo guardado como índice no rompe nada.
        #expect(Notacion.desde(clave: "3") == .espanolCompacto)
    }

    @Test func elMensajeDeUnErrorAjenoEsSuDescripcion() {
        struct Falla: LocalizedError { var errorDescription: String? { "falla de prueba" } }
        #expect(Notacion.espanolCompacto.mensaje(de: Falla()) == "falla de prueba")
    }

    @Test func elMensajeDeUnErrorDeLecturaNoEstaVacio() throws {
        do {
            _ = try Acorde(leyendo: "xyz!")
            Issue.record("«xyz!» no es un cifrado")
        } catch {
            #expect(!(Notacion.espanolCompacto.mensaje(de: error).isEmpty))
            #expect(!(Notacion.inglesASCII.mensaje(de: error).isEmpty))
        }
    }
}
