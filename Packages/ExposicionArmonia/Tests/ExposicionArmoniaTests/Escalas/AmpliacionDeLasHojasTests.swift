import Armonia
import Testing

@testable import ExposicionArmonia

// Lo que llevan las hojas de estudio además de lo de siempre: el origen, el carácter y los nombres originales de la
// escala, el mástil y las secuencias; el teclado y otros instrumentos en la del acorde; el coral en la de una
// progresión, y las dominantes secundarias y los acordes prestados en la de una tonalidad.
@Suite struct AmpliacionDeLasHojasTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func partirEnLineas() {
        #expect(Hoja.partir("Re Mi Fa Sol", ancho: 30, tamano: 10) == ["Re Mi", "Fa Sol"])
        #expect(
            Hoja.partir("Supercalifragilístico y más", ancho: 30, tamano: 10) == ["Supercalifragilístico", "y más"])
        #expect(Hoja.partir("", ancho: 100, tamano: 10).isEmpty)
        // En negrita ocupa un poco más: lo que cabe justo deja de caber.
        #expect(Hoja.partir("Re Mi", ancho: 26.2, tamano: 10) == ["Re Mi"])
        #expect(Hoja.partir("Re Mi", ancho: 26.2, tamano: 10, negrita: true) == ["Re", "Mi"])
    }

    @Test func anchoDelTexto() {
        #expect(Hoja.anchoDelTexto("Re", tamano: 10) == 12.78)
        // Una «i» ocupa menos que una «m»; una acentuada, como la suya sin acento.
        #expect(Hoja.anchoDelTexto("i", tamano: 10) < Hoja.anchoDelTexto("m", tamano: 10))
        #expect(Hoja.anchoDelTexto("é", tamano: 10) == Hoja.anchoDelTexto("e", tamano: 10))
        #expect(Hoja.anchoDelTexto("e\u{301}", tamano: 10) == Hoja.anchoDelTexto("e", tamano: 10))
        // Las alteraciones, las rayas, las flechas, los índices de octava y la escritura de Asia oriental.
        #expect(Hoja.anchoDelTexto("♭♯𝄪", tamano: 10) == 18)
        #expect(Hoja.anchoDelTexto("·•", tamano: 10) == 5.56)
        #expect(Hoja.anchoDelTexto("–—", tamano: 10) == 15.56)
        #expect(Hoja.anchoDelTexto("→…", tamano: 10) == 20)
        #expect(Hoja.anchoDelTexto("₄", tamano: 10) == 4)
        #expect(Hoja.anchoDelTexto("陽音", tamano: 10) == 20)
        #expect(Hoja.anchoDelTexto("ص", tamano: 10) == 5.56)
    }

    @Test func origenCaracterYNombresOriginalesDeLaEscala() {
        let saba = HojaDeEstudio.escala(Escala(.re, .saba), en: notacion)
        #expect(saba.contains(">صبا</text>"))
        #expect(saba.contains(">Origen</text>"))
        #expect(saba.contains(">Carácter</text>"))
        #expect(saba.contains("triste"))
        // Sin estadísticas, tampoco el origen ni el carácter.
        let corta = HojaDeEstudio.escala(Escala(.re, .saba), secciones: [.pentagrama], en: notacion)
        #expect(!corta.contains(">Origen</text>") && !corta.contains(">Carácter</text>"))
        // Los datos largos se parten, con las líneas que siguen metidas; una sección sin datos no se escribe.
        let largo = DatoPresentado(nombre: "Dato", valor: String(repeating: "palabra ", count: 30))
        let hoja = HojaCompuesta(
            titulo: "Hoja",
            secciones: [
                .init(titulo: "Título", piezas: [.datos([largo])]), .init(titulo: "Vacía", piezas: [.datos([])]),
            ]
        ).svg(en: notacion)
        #expect(hoja.contains("x=\"52\"") && hoja.contains(">Título</text>") && !hoja.contains(">Vacía</text>"))
    }

    @Test func elMastilYLasSecuencias() {
        let dibujos = PresentacionDeEstudioDeEscala.mastilDeLaHoja(de: Escala(.sol), en: notacion)
        #expect(dibujos.count == 6)
        #expect(dibujos.first?.titulo == "Mástil de guitarra, trastes 0 a 12")
        #expect(dibujos.dropFirst().allSatisfy { $0.titulo.hasPrefix("Forma ") })
        // La tónica, en naranja; el Fa♯, escrito como en la escala.
        #expect(dibujos[0].svg.contains(DibujoDeLaHoja.tonica) && dibujos[0].svg.contains(">Fa♯</text>"))
        // Una pentatónica, en sus cinco formas; un ukelele (con el Sol agudo), el mástil entero y sus cajas de cuatro
        // trastes, una por nota de la escala en la cuerda de Do.
        let pentatonica = PresentacionDeEstudioDeEscala.mastilDeLaHoja(
            de: Escala(.la, .pentatonicaMenor), en: notacion)
        #expect(pentatonica.count == 6)
        let ukelele = PresentacionDeEstudioDeEscala.mastilDeLaHoja(
            de: Escala(.do), mastil: Mastil(.ukelele, numeroDeTrastes: 15), en: notacion)
        #expect(ukelele.count == 8 && ukelele[0].titulo.contains("ukelele"))
        #expect(ukelele[1].titulo == "Trastes 0–3")
        // El bajo: tres notas por cuerda.
        let bajo = PresentacionDeEstudioDeEscala.mastilDeLaHoja(
            de: Escala(.do), mastil: Mastil(.bajoElectrico, numeroDeTrastes: 15), en: notacion)
        #expect(bajo.count > 1 && !bajo[1].titulo.hasPrefix("Forma "))
        // Un trozo que no empieza al aire no lleva cejuela.
        let trozo = PresentacionDeEstudioDeEscala.mastilSVG(
            [PosicionEnElMastil(cuerda: 0, traste: 5)], en: Mastil(), trastes: 5...8, escala: Escala(.la),
            notacion: notacion)
        #expect(!trozo.contains("stroke-width=\"3\"") && trozo.contains(">La</text>"))

        let secuencias = PresentacionDeEstudioDeEscala.secuenciasDeLaHoja(de: Escala(.do), en: notacion)
        #expect(secuencias.map(\.titulo) == ["Do mayor por terceras", "Do mayor en grupos de cuatro"])

        let hoja = HojaDeEstudio.escala(Escala(.sol), secciones: [.mastil, .secuencias], en: notacion)
        #expect(hoja.contains(">Posiciones en el mástil</text>") && hoja.contains(">Secuencias</text>"))
        #expect(!hoja.contains(">Estadísticas</text>"))
        let html = HojaDeEstudio.escala(Escala(.sol), secciones: [.mastil, .secuencias], en: notacion, formato: .html)
        #expect(html.contains("<h2>Posiciones en el mástil</h2>") && html.contains("<h2>Secuencias</h2>"))
        #expect(html.contains("<h3>Forma G · Trastes 0–4</h3>"))
        #expect(SeccionDeLaHoja.mastil.nombre(en: notacion) == "Posiciones en el mástil")
        #expect(SeccionDeLaHoja.secuencias.nombre(en: .compacta(.ingles)) == "Sequences")
    }

    @Test func elTecladoYOtroInstrumentoEnLaHojaDelAcorde() {
        let teclado = PresentacionDeRelacionesDeAcorde.teclado(de: Acorde("Sol7"), en: notacion)
        #expect(teclado.contains(">Sol7</text>") && teclado.contains(">Fa</text>"))
        let hoja = HojaDeEstudio.acorde(Acorde("Sol7"), mastil: Mastil(.ukelele, numeroDeTrastes: 12), en: notacion)
        #expect(hoja.contains(">Teclado</text>") && hoja.contains(">Digitaciones · ukelele</text>"))
        let html = HojaDeEstudio.acorde(Acorde("Sol7"), en: notacion, formato: .html)
        #expect(html.contains("<h2>Teclado</h2>") && html.contains("<h2>Digitaciones · guitarra</h2>"))
    }

    @Test func elCoralEnLaHojaDeUnaProgresion() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: notacion)
        let coral = PresentacionDeAnalisis.coralDeLaHoja(analisis, en: notacion)
        #expect(coral.filas.map(\.grado) == ["I", "IV", "V7", "I"])
        #expect(coral.pentagrama != nil && coral.avisos == ["Sin faltas de conducción."])
        let hoja = HojaDeEstudio.analisis(analisis, en: notacion)
        #expect(hoja.contains(">Coral</text>") && hoja.contains(">Sin faltas de conducción.</text>"))
        let html = HojaDeEstudio.analisis(analisis, en: notacion, formato: .html)
        #expect(html.contains("<h2>Coral</h2>"))
        // Si no se puede escribir a cuatro voces, por qué.
        let imposible = try PresentacionDeAnalisis.analizar("Do13(♯11)", notacion: notacion)
        let sinCoral = PresentacionDeAnalisis.coralDeLaHoja(imposible, en: notacion)
        #expect(sinCoral.filas.isEmpty && sinCoral.pentagrama == nil && sinCoral.avisos.count == 2)
    }

    @Test func dominantesSecundariasYAcordesPrestados() {
        let dominantes = PresentacionDeTonalidad.dominantesSecundarias(de: Tonalidad(.do), en: notacion)
        #expect(dominantes.map(\.grados) == ["V7/ii", "V7/iii", "V7/IV", "V7/V", "V7/vi"])
        #expect(dominantes.first?.acordes == "La7 – Rem")
        let prestados = PresentacionDeTonalidad.acordesPrestados(de: Tonalidad(.do), en: notacion)
        #expect(prestados.map(\.grados) == ["i7", "iiø7", "♭IIImaj7", "iv7", "v7", "♭VImaj7", "♭VII7"])
        #expect(prestados.last?.acordes == "Si♭7")
        let enMenor = PresentacionDeTonalidad.acordesPrestados(de: Tonalidad(.la, .menor), en: notacion)
        #expect(enMenor.map(\.acordes).contains("Remaj7"))
        let hoja = HojaDeEstudio.tonalidad(Tonalidad(.do), en: notacion)
        #expect(hoja.contains(">Dominante secundaria</text>") && hoja.contains(">Préstamo modal</text>"))
        #expect(hoja.contains(">La♭maj7</text>"))
        let html = HojaDeEstudio.tonalidad(Tonalidad(.do), en: notacion, formato: .html)
        #expect(html.contains("<h2>Dominante secundaria</h2>") && html.contains("V7/vi"))
    }
}
