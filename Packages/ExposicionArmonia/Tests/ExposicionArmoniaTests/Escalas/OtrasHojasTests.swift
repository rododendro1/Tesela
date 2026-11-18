import Armonia
import Testing

@testable import ExposicionArmonia

// Las hojas de `HojaDeEstudio`: un ritmo, una progresión con nombre, una serie, un arpegio y un instrumento, en SVG y
// en HTML.
@Suite struct OtrasHojasTests {
    let notacion = Notacion.compacta(.espanol)

    private func esSVG(_ hoja: String) -> Bool {
        hoja.hasPrefix("<svg") && hoja.hasSuffix("</svg>")
            && hoja.components(separatedBy: "<svg").count == hoja.components(separatedBy: "</svg>").count
    }

    @Test func laDeUnRitmo() {
        let hoja = HojaDeEstudio.ritmo(.tresillo, en: notacion)
        #expect(esSVG(hoja) && hoja.contains(">tresillo</text>"))
        #expect(hoja.contains(">Ritmos parecidos</text>") && hoja.contains(">Estadísticas</text>"))
        // El collar: un punto por pulso y el polígono de los tres golpes.
        let collar = HojaDeEstudio.collar("x..x..x.")
        #expect(collar.components(separatedBy: "<circle").count - 1 == 9)
        #expect(collar.contains("<polygon"))
        #expect(!HojaDeEstudio.collar("x...").contains("<polygon"))
        // La rejilla: una casilla por pulso, y una raya por grupo.
        let rejilla = HojaDeEstudio.rejilla("x.o.", agrupacion: [2, 2])
        #expect(rejilla.components(separatedBy: "<rect").count - 1 == 4)
        #expect(rejilla.components(separatedBy: "stroke-width=\"2.5\"").count - 1 == 2)
        let html = HojaDeEstudio.ritmo(.claveDeSon, en: notacion, formato: .html)
        #expect(html.hasPrefix("<!doctype html>") && html.contains("<h1>clave de son</h1>"))
        #expect(html.contains("<h2>Información</h2>") && html.contains("<dl>"))
    }

    @Test func laDeUnaProgresionConNombre() {
        let hoja = HojaDeEstudio.progresion(.andaluza, sobre: .la, en: notacion)
        #expect(esSVG(hoja) && hoja.contains(">Coral</text>") && hoja.contains(">En las doce tonalidades</text>"))
        #expect(hoja.contains(">La menor</text>") && hoja.contains(">Lam Sol Fa Mi</text>"))
        let html = HojaDeEstudio.progresion(.andaluza, en: notacion, formato: .html)
        #expect(html.contains("<h2>Coral</h2>") && html.contains("<table>"))
    }

    @Test func laDeUnaSerie() throws {
        let serie = try SerieDodecafonica(leyendo: PresentacionDeSerie.ejemplo)
        let hoja = HojaDeEstudio.serie(serie, en: notacion)
        #expect(esSVG(hoja) && hoja.contains(">Matriz</text>") && hoja.contains(">P5</text>"))
        #expect(hoja.contains(">RI5</text>") && hoja.contains(">Pentagrama · P5</text>"))
        let html = HojaDeEstudio.serie(serie, en: notacion, formato: .html)
        #expect(html.contains("<h2>Matriz</h2>") && html.contains("class=\"pequena\""))
    }

    @Test func laDeUnArpegio() {
        let hoja = HojaDeEstudio.arpegio(Acorde("Sol7"), en: notacion)
        #expect(esSVG(hoja) && hoja.contains(">Arpegio · Sol7</text>") && hoja.contains(">1J 3M 5J 7m</text>"))
        #expect(hoja.contains(">Forma E · Trastes 2–6</text>"))
        // En el bajo, por posiciones.
        let bajo = HojaDeEstudio.arpegio(
            Acorde("Lam"), mastil: Mastil(.bajoElectrico, numeroDeTrastes: 15), en: notacion, formato: .html)
        #expect(bajo.contains("<h2>Posiciones en el mástil</h2>") && bajo.contains("class=\"teclados\""))
        #expect(!bajo.contains("Forma E"))
    }

    @Test func laDeUnInstrumento() {
        let hoja = HojaDeEstudio.instrumento(.guitarra, en: notacion)
        #expect(esSVG(hoja) && hoja.contains(">Mástil de guitarra, trastes 0 a 12</text>"))
        #expect(hoja.contains(">Sol7</text>") && hoja.contains(">Sobre el instrumento</text>"))
        let html = HojaDeEstudio.instrumento(.ukelele, en: notacion, formato: .html)
        #expect(html.contains("<h2>Digitaciones</h2>") && html.contains("class=\"digitaciones\""))
    }
}
