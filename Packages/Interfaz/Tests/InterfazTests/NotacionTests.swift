import Armonia
import Foundation
import Testing

@testable import Interfaz

@Suite struct NotacionTests {
    @Test func cadaNotacionTieneTituloYClaveDistintos() {
        let todas = Notacion.allCases + Notacion.deOtrasTradicionesDelSelector
        #expect(Set(todas.map(\.titulo)).count == todas.count)
        #expect(Set(todas.map(\.clave)).count == todas.count)
    }

    /// La clave de cada notación es el nombre de su constante, y el título, el idioma con un ejemplo.
    @Test func lasClavesSonLosCasos() {
        #expect(Notacion.desde(clave: "espanol") == .conPalabras(.espanol))
        #expect(Notacion.desde(clave: "espanolCompacto") == .compacta(.espanol))
        // Sin tocar el ajuste, la octava va como la escriba la notación.
        #expect(Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: nil).octavas == .subindices)
        #expect(Notacion.desde(clave: "espanol", octavasEnSubindice: nil).octavas == .cifras)
        #expect(Notacion.desde(clave: "inglesASCII") == .ascii(.ingles))
        #expect(Notacion.compacta(.espanol).clave == "espanolCompacto")
        #expect(Notacion.compacta(.ingles).clave == "inglesCompacto")
        #expect(Notacion.desde(clave: "inglesASCII+catalan") == Notacion.ascii(.ingles).conTextos(en: .catalan))
        #expect(Notacion.conPalabras(.espanol).clave == "espanol")
        #expect(Notacion.conPalabras(.ingles).clave == "ingles")
        #expect(Notacion.conPalabras(.espanol).titulo == "Español (Fa sostenido)")
        #expect(Notacion.conPalabras(.ingles).titulo == "English (F sharp)")
        #expect(Notacion.ascii(.espanol).titulo == "Español (Fa#)")
        #expect(Notacion.ascii(.ingles).titulo == "English (F#)")
        #expect(Notacion.conPalabras(.aleman).titulo == "Deutsch (F Kreuz)")
        #expect(Notacion.compacta(.aleman).titulo == "Deutsch (Fis)")
        #expect(Notacion.conPalabras(.aleman).clave == "alemanPalabras")
        #expect(Notacion.desde(clave: "alemanPalabras") == .conPalabras(.aleman))
        #expect(Notacion.desde(clave: "alemanCompacto+espanol") == Notacion.compacta(.aleman).conTextos(en: .espanol))
        #expect(Notacion.compacta(.aleman).clave == "alemanCompacto")
        #expect(Notacion.desde(clave: "alemanCompacto") == .compacta(.aleman))
        #expect(Notacion.ascii(.espanol).clave == "espanolASCII")
        #expect(Notacion.conPalabras(.catalan).clave == "catalan")
        // Las de los idiomas que se quitaron vuelven al español con ♯ y ♭, y sus textos, a los de las notas.
        for clave in ["occitano", "asturianoCompacto", "aragones"] {
            #expect(Notacion.desde(clave: clave) == .compacta(.espanol), Comment(rawValue: clave))
        }
        #expect(Notacion.desde(clave: "inglesASCII+occitano") == .ascii(.ingles))
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
            Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: false)
                == .compacta(.espanol).conOctavas(.cifras))
        #expect(Notacion.desde(clave: "espanolCompacto", octavasEnSubindice: true) == .compacta(.espanol))
        #expect(Notacion.desde(clave: "espanolCompacto") == .compacta(.espanol))
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
        #expect(Notacion.ascii(.ingles).conTextosElegidos(.catalan).clave == "inglesASCII+catalan")
        // Una parte desconocida no rompe nada.
        #expect(Notacion.desde(clave: "ruso+klingon") == .conPalabras(.ruso))
        #expect(Notacion.desde(clave: "klingon+espanol") == .compacta(.espanol))
        #expect(Set(Idioma.allCases.map(\.clave)).count == Idioma.allCases.count)
    }

    /// En ruso y en griego, la grafía que no es la original se guarda detrás de la clave: «ruso@transliterada».
    @Test func grafia() {
        let ruso = Notacion.conPalabras(.ruso).conGrafia(.transliterada)
        #expect(ruso.clave == "ruso@transliterada")
        #expect(Notacion.desde(clave: "ruso@transliterada") == ruso)
        #expect(Notacion.desde(clave: "ruso@latino") == ruso)
        #expect(Notacion.desde(clave: "ruso@klingon") == .conPalabras(.ruso))
        #expect(EscrituraDeNotas.compacta(.aleman).titulo == "Deutsch (Fis)")
        #expect(ruso.titulo == "Russkij (fa-diez)")
        #expect(ruso.admiteOtraGrafia)
        let ascii = Notacion.compacta(.ruso).conGrafia(.ascii)
        #expect(ascii.clave == "rusoCompacto@ascii")
        #expect(ascii.titulo == "Russkiy (Fa#)")
        #expect(Notacion.desde(clave: ascii.clave) == ascii)
        let griegoEnEspanol = Notacion.conPalabras(.griego).conTextos(en: .espanol).conGrafia(.transliterada)
        #expect(Notacion.desde(clave: griegoEnEspanol.clave) == griegoEnEspanol)
        #expect(griegoEnEspanol.titulo == "Elliniká (fa díesi) · Español")
        #expect(Notacion.compacta(.espanol).conTextos(en: .ruso).admiteOtraGrafia)
        // Cambiar las notas o los textos conserva la grafía; en un idioma que ya es latino, no se guarda.
        #expect(ruso.conNotas(.conPalabras(.griego)) == Notacion.conPalabras(.griego).conGrafia(.transliterada))
        #expect(ruso.conTextosElegidos(.espanol).grafia == .transliterada)
        #expect(!Notacion.compacta(.aleman).admiteOtraGrafia)
        #expect(Notacion.compacta(.aleman).conGrafia(.transliterada).clave == Notacion.compacta(.aleman).clave)
        #expect(ruso.texto(\.alfabetoLatino) == "Latinskij alfavit")
        // Al pasar a una de otra tradición, la grafía es la suya, y al volver a un idioma, la original.
        let bizantino = ruso.conNotas(Notacion.sistema(.bizantino, grafia: .original)!)
        #expect(bizantino.grafia == .original)
        #expect(bizantino.conNotas(.conPalabras(.ruso)) == .conPalabras(.ruso))
    }

    @Test func unaClaveDesconocidaDaElEspanol() {
        #expect(Notacion.desde(clave: "") == .compacta(.espanol))
        #expect(Notacion.desde(clave: "klingon") == .compacta(.espanol))
        // Las claves que se leían hasta la 0.3.7 («espanolUnicode», «aleman») ya no son de ninguna notación.
        #expect(Notacion.desde(clave: "espanolUnicode") == .compacta(.espanol))
        #expect(Notacion.desde(clave: "aleman") == .compacta(.espanol))
        // Un ajuste antiguo guardado como índice no rompe nada.
        #expect(Notacion.desde(clave: "3") == .compacta(.espanol))
    }

    @Test func elMensajeDeUnErrorAjenoEsSuDescripcion() {
        struct Falla: LocalizedError { var errorDescription: String? { "falla de prueba" } }
        #expect(Notacion.compacta(.espanol).mensaje(de: Falla()) == "falla de prueba")
    }

    @Test func elMensajeDeUnErrorDeLecturaNoEstaVacio() throws {
        do {
            _ = try Acorde(leyendo: "xyz!")
            Issue.record("«xyz!» no es un cifrado")
        } catch {
            #expect(!(Notacion.compacta(.espanol).mensaje(de: error).isEmpty))
            #expect(!(Notacion.ascii(.ingles).mensaje(de: error).isEmpty))
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
            !Notacion.deOtrasTradicionesDelSelector.contains {
                $0.clave == "guidonianoOriginal" || $0.clave == "japonesASCII"
            })
        #expect(Notacion.deOtrasTradicionesDelSelector.count == 22)
    }
}
