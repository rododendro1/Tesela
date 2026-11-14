import Armonia
import Testing

@testable import Exposicion

// De cuándo y de dónde es una escala, escrito: lo mismo en la consola, su JSON, la hoja de estudio y la app.
@Suite struct OrigenDeEscalaTests {
    let notacion = Notacion.compacta(.espanol)

    /// La menor húngara: el año de Liszt, el Romanticismo, sus lugares y su estilo.
    @Test func laMenorHungara() throws {
        let origen = try #require(OrigenDeEscalaPresentado(.menorHungara, en: notacion))
        #expect(origen.origen?.anio == 1859)
        #expect(origen.origen?.epoca == "Romanticismo")
        #expect(origen.lugaresDeOrigen.contains("Hungría"))
        #expect(origen.estilos == ["folclore"])
        #expect(origen.escuelas.isEmpty && origen.periodo == nil)
        let datos = origen.datos(en: notacion)
        #expect(datos.first == DatoPresentado(nombre: "Época", valor: "Romanticismo (1859)"))
        #expect(datos.contains { $0.nombre == "Lugares de origen" && $0.valor.contains("Hungría") })
        #expect(!datos.contains { $0.nombre == "Período" })
    }

    /// El dórico: medieval, con sus épocas de uso y la corriente de su estilo de jazz entre paréntesis.
    @Test func elDoricoYSusCorrientes() throws {
        let origen = try #require(OrigenDeEscalaPresentado(.dorico, en: notacion))
        #expect(origen.origen?.anio == nil && origen.origen?.epoca == "Edad Media")
        #expect(origen.epocasDeUso.first == "Barroco" && origen.epocasDeUso.count == 5)
        #expect(origen.estilos.first?.hasPrefix("jazz (") == true)
        let datos = origen.datos(en: notacion)
        #expect(datos.first == DatoPresentado(nombre: "Época", valor: "Edad Media"))
        #expect(datos.contains { $0.nombre == "Épocas de uso" && $0.valor.hasPrefix("Barroco · Clasicismo") })
    }

    /// Las de otras tradiciones: el período, los de uso y la escuela.
    @Test func losPeriodosYLasEscuelas() throws {
        let mela = try #require(TipoDeEscala.melakarta(29))
        let origen = try #require(OrigenDeEscalaPresentado(mela, en: notacion))
        #expect(origen.origen?.anio == 1660 && origen.origen?.epoca == "Barroco")
        #expect(origen.periodo == PeriodoMusical.mela.nombre)
        #expect(origen.periodosDeUso == [PeriodoMusical.bhatkhande.nombre])
        #expect(origen.escuelas == ["Carnática"])
        #expect(origen.datos(en: notacion).map(\.nombre).contains("Escuelas"))
        let rast = try #require(OrigenDeEscalaPresentado(.rastMakami, en: notacion))
        #expect(rast.periodo == PeriodoMusical.cantemir.nombre)
        // En inglés, los rótulos también.
        let ingles = try #require(OrigenDeEscalaPresentado(mela, en: .compacta(.ingles)))
        #expect(ingles.datos(en: .compacta(.ingles)).first?.nombre == "Era")
    }

    /// Una escala propia no tiene origen; la escala presentada lo lleva cuando lo hay.
    @Test func sinOrigen() {
        let propia = TipoDeEscala(nombre: "mía", intervalos: [.unisono, .segundaMenor, .quintaJusta])
        #expect(OrigenDeEscalaPresentado(propia, en: notacion) == nil)
        #expect(EscalaPresentada(Escala(.do, propia), en: notacion).origen == nil)
        #expect(EscalaPresentada(Escala(.re, .dorico), en: notacion).origen?.origen?.epoca == "Edad Media")
    }

    /// La hoja de estudio en HTML lleva el origen con las estadísticas, y no sin ellas.
    @Test func enLaHojaDeEstudio() {
        let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(de: Escala(.la, .menorHungara), en: notacion)
        #expect(hoja.contains("<section class=\"seccion-origen\"><h2>Origen</h2>"))
        #expect(hoja.contains("<dt>Época</dt><dd>Romanticismo (1859)</dd>"))
        let sinEstadisticas = PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(
            de: Escala(.la, .menorHungara), en: notacion, secciones: [.reloj])
        #expect(!sinEstadisticas.contains("seccion-origen"))
    }

    /// Un fragmento lo dice, con lo que abarca, en el JSON y en lo que se mide de él.
    @Test func unFragmentoDiceLoQueAbarca() {
        let tetracordo = Escala(.mi, .tetracordoDiatonico)
        #expect(EscalaPresentada(tetracordo, en: notacion).ambito == "4ª justa")
        #expect(EscalaPresentada(Escala(.do), en: notacion).ambito == nil)
        let datos = PresentacionDeEstudioDeEscala.estadisticas(de: tetracordo, en: notacion)
        #expect(datos.contains(DatoPresentado(nombre: "Fragmento", valor: "4ª justa")))
        #expect(
            !PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.do), en: notacion).map(\.nombre).contains(
                "Fragmento"))
    }

    /// La afinación, escrita: microtonal, justa, en partes iguales; nada en las que no tienen una propia.
    @Test func laAfinacionEscrita() {
        #expect(PresentacionDeEstudioDeEscala.afinacion(de: .bayati, en: notacion) == "microtonal")
        #expect(PresentacionDeEstudioDeEscala.afinacion(de: .kalyan, en: notacion) == "justa")
        #expect(PresentacionDeEstudioDeEscala.afinacion(de: .slendro, en: notacion) == "octava en 5 partes iguales")
        #expect(PresentacionDeEstudioDeEscala.afinacion(de: .mayor, en: notacion) == nil)
        #expect(
            PresentacionDeEstudioDeEscala.afinacion(de: .slendro, en: .compacta(.ingles)) == "octave in 5 equal parts")
        let datos = PresentacionDeEstudioDeEscala.estadisticas(de: Escala(.re, .bayati), en: notacion)
        #expect(datos.contains(DatoPresentado(nombre: "Afinación", valor: "microtonal")))
    }

    /// El nombre en su escritura original: en las de otras tradiciones, con su idioma; en las demás, nada.
    @Test func elNombreOriginal() throws {
        let gong = try #require(EscalaPresentada(Escala(.do, .gong), en: notacion).nombresOriginales)
        #expect(gong.map(\.idioma) == ["zh-Hans", "zh-Hant"])
        #expect(gong.map(\.completo) == ["宫调", "宮調"])
        #expect(gong[1].enUnaLinea == "\u{2068}宮\u{2069} (chino tradicional)")
        let enIngles = try #require(EscalaPresentada(Escala(.re, .hiyaz), en: .compacta(.ingles)).nombresOriginales)
        #expect(enIngles.first?.nombreDelIdioma == "Arabic" && enIngles.first?.derechaAIzquierda == true)
        #expect(EscalaPresentada(Escala(.re, .dorico), en: notacion).nombresOriginales == nil)
        let yo = try #require(EscalaPresentada(Escala(.do, .yo), en: notacion).nombresOriginales)
        #expect(yo.allSatisfy { $0.completo == nil })
    }
}
