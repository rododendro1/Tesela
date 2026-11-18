import Armonia
import Testing

@testable import ExposicionArmonia

// Lo que llevan las hojas de estudio además de lo de siempre: el origen, el carácter y los nombres originales de la
// escala, el mástil y las secuencias; el teclado y otros instrumentos en la del acorde; el coral en la de una
// progresión, y las dominantes secundarias y los acordes prestados en la de una tonalidad.
@Suite struct AmpliacionDeLasHojasTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func partirEnLineas() {
        let partir = PresentacionDeEstudioDeEscala.partir
        #expect(partir("Re Mi Fa Sol", 6) == ["Re Mi", "Fa Sol"])
        #expect(partir("Supercalifragilístico y más", 5) == ["Supercalifragilístico", "y más"])
        #expect(partir("", 10).isEmpty)
        #expect(PresentacionDeEstudioDeEscala.caracteresPorLinea(56) == 20)
        #expect(PresentacionDeEstudioDeEscala.caracteresPorLinea(560) == 100)
    }

    @Test func origenCaracterYNombresOriginalesDeLaEscala() {
        let saba = PresentacionDeEstudioDeEscala.hojaDeEstudio(de: Escala(.re, .saba), en: notacion)
        #expect(saba.contains(">صبا</text>"))
        #expect(saba.contains(">Origen</text>"))
        #expect(saba.contains(">Carácter</text>"))
        #expect(saba.contains("triste"))
        // Sin estadísticas, tampoco el origen ni el carácter.
        let corta = PresentacionDeEstudioDeEscala.hojaDeEstudio(
            de: Escala(.re, .saba), en: notacion, secciones: [.pentagrama])
        #expect(!corta.contains(">Origen</text>") && !corta.contains(">Carácter</text>"))
        // Los datos largos se parten, con las líneas que siguen metidas.
        var cuerpo: [String] = []
        var y = 0.0
        let largo = DatoPresentado(nombre: "Dato", valor: String(repeating: "palabra ", count: 30))
        PresentacionDeEstudioDeEscala.seccionDeDatos("Título", [largo], x: 40, ancho: 200, y: &y, en: &cuerpo)
        #expect(cuerpo.count > 3 && cuerpo.contains { $0.contains("x=\"52\"") })
        cuerpo = []
        PresentacionDeEstudioDeEscala.seccionDeDatos("Título", [], x: 40, ancho: 200, y: &y, en: &cuerpo)
        #expect(cuerpo.isEmpty)
    }

    @Test func elMastilYLasSecuencias() {
        let dibujos = PresentacionDeEstudioDeEscala.mastilDeLaHoja(de: Escala(.sol), en: notacion)
        #expect(dibujos.count == 6)
        #expect(dibujos.first?.titulo == "Mástil de guitarra, trastes 0 a 12")
        #expect(dibujos.dropFirst().allSatisfy { $0.titulo.hasPrefix("Forma ") })
        // La tónica, en naranja; el Fa♯, escrito como en la escala.
        #expect(dibujos[0].svg.contains(DibujoDeLaHoja.tonica) && dibujos[0].svg.contains(">Fa♯</text>"))
        // Una pentatónica, en sus cinco formas; un ukelele (con el Sol agudo), solo el mástil entero.
        let pentatonica = PresentacionDeEstudioDeEscala.mastilDeLaHoja(
            de: Escala(.la, .pentatonicaMenor), en: notacion)
        #expect(pentatonica.count == 6)
        let ukelele = PresentacionDeEstudioDeEscala.mastilDeLaHoja(
            de: Escala(.do), mastil: Mastil(.ukelele, numeroDeTrastes: 15), en: notacion)
        #expect(ukelele.count == 1 && ukelele[0].titulo.contains("ukelele"))
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

        let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudio(
            de: Escala(.sol), en: notacion, secciones: [.mastil, .secuencias])
        #expect(hoja.contains(">Posiciones en el mástil</text>") && hoja.contains(">Secuencias</text>"))
        #expect(!hoja.contains(">Estadísticas</text>"))
        let html = PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(
            de: Escala(.sol), en: notacion, secciones: [.mastil, .secuencias])
        #expect(html.contains("<h2>Posiciones en el mástil</h2>") && html.contains("<h2>Secuencias</h2>"))
        #expect(html.contains("<h3>Forma G · Trastes 0–4</h3>"))
        #expect(SeccionDeLaHoja.mastil.nombre(en: notacion) == "Posiciones en el mástil")
        #expect(SeccionDeLaHoja.secuencias.nombre(en: .compacta(.ingles)) == "Sequences")
    }

    @Test func elTecladoYOtroInstrumentoEnLaHojaDelAcorde() {
        let teclado = PresentacionDeRelacionesDeAcorde.teclado(de: Acorde("Sol7"), en: notacion)
        #expect(teclado.contains(">Sol7</text>") && teclado.contains(">Fa</text>"))
        let hoja = PresentacionDeRelacionesDeAcorde.hojaDeEstudio(
            de: Acorde("Sol7"), mastil: Mastil(.ukelele, numeroDeTrastes: 12), en: notacion)
        #expect(hoja.contains(">Teclado</text>") && hoja.contains(">Digitaciones · ukelele</text>"))
        let html = PresentacionDeRelacionesDeAcorde.hojaDeEstudioHTML(de: Acorde("Sol7"), en: notacion)
        #expect(html.contains("<h2>Teclado</h2>") && html.contains("<h2>Digitaciones · guitarra</h2>"))
    }

    @Test func elCoralEnLaHojaDeUnaProgresion() throws {
        let analisis = try PresentacionDeAnalisis.analizar("Do Fa Sol7 Do", notacion: notacion)
        let coral = PresentacionDeAnalisis.coralDeLaHoja(analisis, en: notacion)
        #expect(coral.filas.map(\.grado) == ["I", "IV", "V7", "I"])
        #expect(coral.pentagrama != nil && coral.avisos == ["Sin faltas de conducción."])
        let hoja = PresentacionDeAnalisis.hojaDeEstudio(analisis, en: notacion)
        #expect(hoja.contains(">Coral</text>") && hoja.contains(">Sin faltas de conducción.</text>"))
        let html = PresentacionDeAnalisis.hojaDeEstudioHTML(analisis, en: notacion)
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
        let hoja = PresentacionDeTonalidad.hojaDeEstudio(de: Tonalidad(.do), en: notacion)
        #expect(hoja.contains(">Dominante secundaria</text>") && hoja.contains(">Préstamo modal</text>"))
        #expect(hoja.contains(">La♭maj7</text>"))
        let html = PresentacionDeTonalidad.hojaDeEstudioHTML(de: Tonalidad(.do), en: notacion)
        #expect(html.contains("<h2>Dominante secundaria</h2>") && html.contains("V7/vi"))
    }
}
