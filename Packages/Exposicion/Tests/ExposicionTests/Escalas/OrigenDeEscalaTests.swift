import Armonia
import Testing

@testable import Exposicion

// De cuándo y de dónde es una escala, escrito: lo mismo en la consola, su JSON, la hoja de estudio y la app.
@Suite struct OrigenDeEscalaTests {
    let notacion = Notacion.compacta(.espanol)

    /// La menor húngara: el año de Liszt, el Romanticismo, sus lugares y su estilo.
    @Test func laMenorHungara() throws {
        let origen = try #require(OrigenDeEscalaPresentado(.menorHungara, en: notacion))
        #expect(origen.anio == 1859)
        #expect(origen.epoca == "Romanticismo")
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
        #expect(origen.anio == nil && origen.epoca == "Edad Media")
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
        #expect(origen.anio == 1660 && origen.epoca == "Barroco")
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
        #expect(EscalaPresentada(Escala(.re, .dorico), en: notacion).origen?.epoca == "Edad Media")
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
}
