import Foundation
import Testing

@testable import ArmoniaElementos
@testable import ArmoniaPartitura
@testable import ArmoniaTeoria

/// Una voz larga en varias líneas y dos voces en un pentagrama.
@Suite struct PentagramaEnLineasTests {
    private func contar(_ trozo: String, en texto: String) -> Int {
        texto.components(separatedBy: trozo).count - 1
    }

    private func veces(_ glifo: Glifo, en svg: String) -> Int { contar("d=\"\(glifo.trazado)\"", en: svg) }

    private func opciones(_ compases: Int?) -> OpcionesDePentagrama {
        var opciones = OpcionesDePentagrama()
        opciones.maquetacion.compasesPorLinea = compases
        return opciones
    }

    /// Hasta dónde llega la línea de arriba de cada pentagrama: lo que mide cada línea.
    private func finales(_ svg: String) -> [String] {
        let patron = "<line x1=\"0\" y1=\"0\" x2=\""
        return svg.components(separatedBy: patron).dropFirst().compactMap { resto in
            let numero = resto.prefix { $0 != "\"" }
            return resto.dropFirst(numero.count).hasPrefix("\" y2=\"0\" stroke-width=\"0.13\"") ? String(numero) : nil
        }
    }

    /// Las x de las cabezas negras (o de otro glifo).
    private func xDeLasNegras(_ svg: String, glifo: Glifo = GlifosSMuFL.negra) -> [String] {
        svg.components(separatedBy: "<path transform=\"translate(").dropFirst().compactMap { resto in
            guard let fin = resto.firstIndex(of: ")"), resto[fin...].hasPrefix(")\" d=\"\(glifo.trazado)\"")
            else { return nil }
            return String(resto[..<fin].prefix { $0 != " " })
        }
    }

    // MARK: Líneas

    /// Doce compases, cuatro por línea: tres líneas del mismo ancho, la cifra del compás solo en la primera y la
    /// barra final solo en la última.
    @Test func unaVozLargaVaEnLineasDelMismoAncho() throws {
        let compas = "Do4:4 Re4:8 Mi4:8 Fa4:4 Sol4:4"
        let voz = try Voz(leyendo: Array(repeating: compas, count: 12).joined(separator: " "))
        let svg = voz.svgPentagrama(titulo: "Larga", opciones: opciones(4))
        #expect(finales(svg).count == 3)
        #expect(veces(GlifosSMuFL.cifraDeCompas4, en: svg) == 2)
        #expect(contar("stroke-width=\"0.5\"", en: svg) == 1)
        #expect(veces(GlifosSMuFL.claveDeSol, en: svg) == 3)
        #expect(veces(GlifosSMuFL.negra, en: svg) == 12 * 5)
        let medidas = finales(svg)
        #expect(medidas.count == 3)
        #expect(Set(medidas).count == 1)
        #expect(svg.hasPrefix("<svg"))
        #expect(contar("<title id=", en: svg) == 1)
    }

    /// Si cabe en una línea, o no se pide, el dibujo es el de siempre.
    @Test func siCabeEnUnaLineaNoCambia() throws {
        let voz = try Voz(leyendo: "Do4:4 Re4:4 Mi4:2 Fa4:1")
        #expect(voz.svgPentagrama(titulo: "Corta", opciones: opciones(4)) == voz.svgPentagrama(titulo: "Corta"))
        #expect(voz.svgPentagrama(titulo: "Corta", opciones: opciones(nil)) == voz.svgPentagrama(titulo: "Corta"))
        #expect(finales(voz.svgPentagrama(titulo: "Corta")).count == 1)
    }

    /// La última línea, si es mucho más corta, no se estira.
    @Test func laUltimaLineaCortaNoSeEstira() throws {
        let compas = "Do4:8 Re4:8 Mi4:8 Fa4:8 Sol4:8 La4:8 Si4:8 Do5:8"
        let voz = try Voz(leyendo: Array(repeating: compas, count: 5).joined(separator: " "))
        let medidas = finales(voz.svgPentagrama(titulo: "Cinco", opciones: opciones(4)))
        #expect(medidas.count == 2)
        #expect((Double(medidas[1]) ?? 0) < (Double(medidas[0]) ?? 0) * 0.75)
    }

    /// Una nota que pasa de una línea a la siguiente se divide y se liga: media ligadura al final de la primera.
    @Test func laNotaQueCruzaLaLineaSeLiga() throws {
        let voz = try Voz(leyendo: "Do4:2 Re4:1 Mi4:2")
        let svg = voz.svgPentagrama(titulo: "Ligada", opciones: opciones(1))
        #expect(finales(svg).count == 2)
        #expect(veces(GlifosSMuFL.blanca, en: svg) == 4)
        #expect(contar("Z\"/>", en: svg) >= 1)
        #expect(contar("<title>Re₄</title>", en: svg) == 2)
    }

    /// La nota resaltada (contada en la voz entera) se pinta en su línea, también la parte ligada que pasa a la
    /// siguiente.
    @Test func laResaltadaVaEnSuLinea() throws {
        let voz = try Voz(leyendo: "Do4:2 Re4:1 Mi4:2")
        var opciones = opciones(1)
        opciones.marcas.resaltada = 2
        let mi = voz.svgPentagrama(titulo: "Mi", opciones: opciones)
        #expect(contar("fill=\"\(opciones.colores.resaltado)\"", en: mi) == 1)
        opciones.marcas.resaltada = 1
        let re = voz.svgPentagrama(titulo: "Re", opciones: opciones)
        #expect(contar("fill=\"\(opciones.colores.resaltado)\"", en: re) == 2)
        opciones.marcas.resaltada = 0
        let silencio = try Voz(leyendo: "Do4:1 -:1 Mi4:1").svgPentagrama(titulo: "Do", opciones: opciones)
        #expect(contar("fill=\"\(opciones.colores.resaltado)\"", en: silencio) == 1)
    }

    /// Los acordes, los grados, los dedos y la tablatura pasan a la línea de su evento, y la anacrusa va en la
    /// primera.
    @Test func loDeCadaEventoPasaASuLinea() throws {
        let voz = try Voz(leyendo: "Sol3:4 Do4:1 Re4:1 Mi4:1", anacrusa: .negra)
        var opciones = opciones(1)
        opciones.marcas.intervalosDeLasNotas = true
        let tablatura = Tablatura(numeroDeCuerdas: 6, pulsaciones: [3: [Tablatura.Pulsacion(cuerda: 3, traste: 5)]])
        let svg = voz.svgPentagrama(
            titulo: "Anotada", acordes: [1: Acorde("Do"), 3: Acorde("Sol")], grados: [1: "I", 3: "V"],
            bajoCifrado: [2: ["6"]], dedos: [2: [3]], tablatura: tablatura, opciones: opciones)
        #expect(finales(svg).count == 3)
        #expect(svg.contains(">Do</text>"))
        #expect(svg.contains(">Sol</text>"))
        #expect(svg.contains(">V</text>"))
        #expect(svg.contains(">6</text>"))
        #expect(svg.contains(">5</text>"))
    }

    /// Los microtonos de una nota ligada siguen en la línea siguiente.
    @Test func losMicrotonosPasanALaLineaSiguiente() throws {
        let voz = try Voz(leyendo: "Do4:2 Mi♭4(50¢):1 Re4:2")
        let svg = voz.svgPentagrama(titulo: "Maqam", opciones: opciones(1))
        let unaLinea = voz.svgPentagrama(titulo: "Maqam")
        #expect(finales(svg).count == 2)
        #expect(contar("(+50¢)</title>", en: svg) == 2)
        #expect(contar("(+50¢)</title>", en: unaLinea) == 2)
        #expect(veces(GlifosSMuFL.medioBemol, en: svg) >= 1)
    }

    // MARK: Dos voces

    /// Soprano y contralto en un pentagrama: un solo pentagrama, las plicas de cada voz hacia su lado y lo que suena
    /// a la vez en la misma vertical.
    @Test func dosVocesEnUnPentagrama() throws {
        let soprano = try Voz(leyendo: "Mi5:4 Re5:4 Do5:2")
        let contralto = try Voz(leyendo: "Do5:4 Si4:4 Sol4:2")
        let svg = soprano.svgPentagrama(junto: contralto, titulo: "Dos voces")
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 5)
        #expect(veces(GlifosSMuFL.claveDeSol, en: svg) == 1)
        #expect(veces(GlifosSMuFL.negra, en: svg) == 4)
        #expect(veces(GlifosSMuFL.blanca, en: svg) == 2)
        let xs = xDeLasNegras(svg)
        #expect(xs.count == 4)
        #expect(Set(xs).count == 2)
        #expect(contar("<title id=", en: svg) == 1)
        // Las de arriba con la plica a la derecha de la cabeza; las de abajo, a la izquierda.
        #expect(svg.contains("Mi₅"))
        #expect(svg.contains("Sol₄"))
    }

    /// Con ritmos distintos, las notas que empiezan a la vez siguen en la misma vertical, y los silencios de cada
    /// voz van por encima o por debajo.
    @Test func dosVocesConRitmosDistintos() throws {
        let arriba = try Voz(leyendo: "Sol5:2 -:4 Mi5:4")
        let abajo = try Voz(leyendo: "Do5:8 Re5:8 Mi5:8 Fa5:8 -:2")
        let svg = arriba.svgPentagrama(junto: abajo, titulo: "Ritmos")
        #expect(veces(GlifosSMuFL.silencioDeNegra, en: svg) == 1)
        #expect(veces(GlifosSMuFL.silencioDeBlanca, en: svg) == 1)
        #expect(veces(GlifosSMuFL.negra, en: svg) == 5)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 5)
        // La negra de Mi5 de arriba y el silencio de blanca de abajo empiezan en la segunda mitad; la blanca de
        // arriba y la primera corchea, al principio.
        let xs = xDeLasNegras(svg)
        #expect(xs.count == 5)
    }

    /// Si las dos voces suenan a una segunda o al unísono, la cabeza de la de abajo se aparta a la derecha.
    @Test func lasCabezasQueChocanSeApartan() throws {
        let arriba = try Voz(leyendo: "Re5:2 Do5:2")
        let abajo = try Voz(leyendo: "Do5:2 Do5:2")
        let svg = arriba.svgPentagrama(junto: abajo, titulo: "Juntas")
        let xs = xDeLasNegras(svg, glifo: GlifosSMuFL.blanca)
        #expect(xs.count == 4)
        #expect(Set(xs).count == 4)
        let separadas = try Voz(leyendo: "Mi5:2 Re5:2").svgPentagrama(junto: abajo, titulo: "Separadas")
        #expect(Set(xDeLasNegras(separadas, glifo: GlifosSMuFL.blanca)).count == 3)
        var lineas = OpcionesDePentagrama()
        lineas.maquetacion.compasesPorLinea = 1
        let estiradas = try Voz(leyendo: "Re5:2 Do5:2 Mi5:1").svgPentagrama(
            junto: try Voz(leyendo: "Do5:2 Do5:2 Do5:1"), titulo: "Estiradas", opciones: lineas)
        #expect(Set(xDeLasNegras(estiradas, glifo: GlifosSMuFL.blanca)).count == 4)
    }

    /// Dos voces en varias líneas: las dos se parten igual, y si una es más larga sigue sola.
    @Test func dosVocesEnLineas() throws {
        let arriba = try Voz(leyendo: "Mi5:1 Re5:1 Do5:1")
        let abajo = try Voz(leyendo: "Do5:1 Si4:1 La4:1 Sol4:1")
        let svg = arriba.svgPentagrama(junto: abajo, titulo: "Largas", opciones: opciones(2))
        #expect(finales(svg).count == 2)
        #expect(contar("stroke-width=\"0.13\"", en: svg) == 10)
        #expect(veces(GlifosSMuFL.redonda, en: svg) == 7)
        #expect(veces(GlifosSMuFL.cifraDeCompas4, en: svg) == 2)
        #expect(contar("stroke-width=\"0.5\"", en: svg) == 1)
        let medidas = finales(svg)
        #expect(medidas.count == 2)
        #expect(Set(medidas).count == 1)
        let alReves = abajo.svgPentagrama(junto: arriba, titulo: "Largas", opciones: opciones(3))
        #expect(finales(alReves).count == 2)
    }

    /// Los acordes van encima de la voz de arriba; los nombres de las notas, solo en ella.
    @Test func dosVocesConAcordesYNombres() throws {
        let arriba = try Voz(leyendo: "Mi5:2 Re5:2")
        let abajo = try Voz(leyendo: "Do5:2 Si4:2")
        var opciones = OpcionesDePentagrama(marcas: .init(nombresDeLasNotas: true))
        opciones.marcas.resaltada = 1
        let svg = arriba.svgPentagrama(
            junto: abajo, titulo: "Cifrada", acordes: [0: Acorde("Do")], opciones: opciones)
        let sinNombres = arriba.svgPentagrama(junto: abajo, titulo: "Cifrada", acordes: [0: Acorde("Do")])
        #expect(svg.contains(">Do</text>"))
        // Dos nombres más (los de la voz de arriba), no cuatro.
        #expect(contar("</text>", en: svg) == contar("</text>", en: sinNombres) + 2)
        #expect(contar("fill=\"\(opciones.colores.resaltado)\"", en: svg) == 1)
    }

    /// El dibujo de varias líneas sin ninguna no da nada roto.
    @Test func sinLineasNoHayNada() {
        let svg = PentagramaSVG.svg([], titulo: "Nada", tamano: 10)
        #expect(svg.contains("viewBox=\"0 0 0 0\""))
    }
}
