import Armonia
import Foundation
import Testing

@testable import Interfaz

@Suite struct NotacionTests {
    @Test func cadaNotacionTieneTituloYClaveDistintos() {
        let todas = Notacion.allCases + Notacion.deOtrasTradiciones
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
        #expect(Notacion.espanolCompacto.clave == "espanolCompacto")
        #expect(Notacion.inglesCompacto.clave == "inglesCompacto")
        #expect(Notacion.desde(clave: "inglesASCII+catalan") == Notacion.inglesASCII.conTextos(en: .catalan))
        #expect(Notacion.espanolPalabras.clave == "espanol")
        #expect(Notacion.inglesPalabras.clave == "ingles")
        #expect(Notacion.espanolPalabras.titulo == "Español (Fa sostenido)")
        #expect(Notacion.inglesPalabras.titulo == "English (F sharp)")
        #expect(Notacion.espanolASCII.titulo == "Español (Fa#)")
        #expect(Notacion.inglesASCII.titulo == "English (F#)")
        #expect(Notacion.conPalabras(.aleman).titulo == "Deutsch (F Kreuz)")
        #expect(Notacion.compacta(.aleman).titulo == "Deutsch (Fis)")
        #expect(Notacion.conPalabras(.aleman).clave == "alemanPalabras")
        #expect(Notacion.desde(clave: "alemanPalabras") == .conPalabras(.aleman))
        #expect(Notacion.desde(clave: "alemanCompacto+espanol") == Notacion.compacta(.aleman).conTextos(en: .espanol))
        #expect(Notacion.compacta(.aleman).clave == "alemanCompacto")
        #expect(Notacion.desde(clave: "alemanCompacto") == .compacta(.aleman))
        #expect(Notacion.espanolASCII.clave == "espanolASCII")
        #expect(Notacion.conPalabras(.catalan).clave == "catalan")
        #expect(Notacion.compacta(.frances).clave == "francesCompacto")
        #expect(Notacion.desde(clave: "rusoCompacto+espanol") == Notacion.compacta(.ruso).conTextos(en: .espanol))
        #expect(Notacion.conPalabras(.frances).titulo == "Français (fa dièse)")
        #expect(Notacion.compacta(.frances).titulo == "Français (Fa♯)")
        #expect(Notacion.compacta(.ruso).titulo == "Русский (Фа♯)")
    }

    @Test func laClaveVuelveALaNotacion() {
        for notacion in Notacion.allCases {
            #expect(Notacion.desde(clave: notacion.clave) == notacion)
        }
    }

    /// La octava en subíndice se guarda aparte: la clave de la notación no cambia.
    @Test func octavasEnSubindice() {
        let conSubindices = Notacion.desde(clave: "ruso+espanol", octavasEnSubindice: true)
        #expect(conSubindices == Notacion.conPalabras(.ruso).conTextos(en: .espanol).conOctavas(.subindices))
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
        let rusoEnEspanol = Notacion.conPalabras(.ruso).conTextos(en: .espanol)
        #expect(rusoEnEspanol.clave == "ruso+espanol")
        #expect(Notacion.desde(clave: "ruso+espanol") == rusoEnEspanol)
        #expect(rusoEnEspanol.titulo == "Русский (фа-диез) · Español")
        #expect(rusoEnEspanol.idiomaElegidoParaLosTextos == .espanol)
        #expect(Notacion.conPalabras(.ruso).idiomaElegidoParaLosTextos == nil)
        // Cambiar las notas conserva los textos, y quitar los textos deja las notas.
        #expect(rusoEnEspanol.conNotas(.conPalabras(.griego)) == Notacion.conPalabras(.griego).conTextos(en: .espanol))
        #expect(Notacion.conPalabras(.ruso).conNotas(.conPalabras(.griego)) == .conPalabras(.griego))
        #expect(rusoEnEspanol.conTextosElegidos(nil) == .conPalabras(.ruso))
        #expect(Notacion.inglesASCII.conTextosElegidos(.catalan).clave == "inglesASCII+catalan")
        // Una parte desconocida no rompe nada.
        #expect(Notacion.desde(clave: "ruso+klingon") == .conPalabras(.ruso))
        #expect(Notacion.desde(clave: "klingon+espanol") == .espanolCompacto)
        #expect(Set(Idioma.allCases.map(\.clave)).count == Idioma.allCases.count)
    }

    @Test func unaClaveDesconocidaDaElEspanol() {
        #expect(Notacion.desde(clave: "") == .espanolCompacto)
        #expect(Notacion.desde(clave: "klingon") == .espanolCompacto)
        // Las claves que se leían hasta la 0.3.7 («espanolUnicode», «aleman») ya no son de ninguna notación.
        #expect(Notacion.desde(clave: "espanolUnicode") == .espanolCompacto)
        #expect(Notacion.desde(clave: "aleman") == .espanolCompacto)
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

    /// Las de otras tradiciones se guardan con su sistema y su grafía, y conservan el idioma de los textos.
    @Test func lasDeOtrasTradiciones() throws {
        let bizantino = try #require(Notacion.sistema(.bizantino))
        #expect(bizantino.clave == "bizantino")
        #expect(bizantino.titulo == "Βυζαντινή (Ga♯)")
        let original = try #require(Notacion.sistema(.bizantino, grafia: .original))
        #expect(original.clave == "bizantinoOriginal")
        #expect(original.titulo == "Βυζαντινή (Γα♯)")
        #expect(Notacion.desde(clave: "bizantinoOriginal") == original)
        #expect(Notacion.desde(clave: "luChinosASCII").sistemaDeNombres == .luChinos)
        // Al elegirla, los textos siguen en el idioma que se leía, y al volver a un idioma, también.
        let enEuskera = Notacion.conPalabras(.euskera).conNotas(bizantino)
        #expect(enEuskera.textos == .euskera)
        #expect(enEuskera.sistemaDeNombres == .bizantino)
        #expect(Notacion.desde(clave: enEuskera.clave) == enEuskera)
        #expect(enEuskera.conNotas(.conPalabras(.euskera)) == .conPalabras(.euskera))
        // Sin las grafías que escriben igual las notas con una alteración: el ut de Guido no tiene otra escritura, y
        // el japonés en ASCII solo cambia en las dobles (jū-ei).
        #expect(
            !Notacion.deOtrasTradiciones.contains { $0.clave == "guidonianoOriginal" || $0.clave == "japonesASCII" })
        #expect(Notacion.deOtrasTradiciones.count == 22)
    }
}
