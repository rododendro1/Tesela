import Armonia
import Testing

@testable import ExposicionArmonia

// Las piezas de `HojaCompuesta` en SVG y en HTML, y los nombres de antes de las hojas, que siguen.
@Suite struct HojaCompuestaTests {
    let notacion = Notacion.compacta(.espanol)

    @Test func lasPiezas() {
        let sinAncho = "<svg viewBox=\"0 0 100 50\"><rect width=\"1\" height=\"1\"/></svg>"
        let hoja = HojaCompuesta(
            titulo: "Hoja", subtitulos: ["", "Debajo"], notas: ["Do", "Re"],
            originales: NombreOriginalPresentado.de(.saba, en: notacion),
            secciones: [
                .init(titulo: "Una columna", piezas: [.tabla([["a"], ["b"]])]),
                .init(
                    titulo: "Lista",
                    piezas: [
                        .lista(
                            [.init(etiqueta: nil, texto: "uno"), .init(etiqueta: "2", texto: "", resaltado: true)],
                            porFila: 1, clase: nil)
                    ]),
                .init(titulo: "Dibujos", piezas: [.dibujos([("", sinAncho), ("Con título", sinAncho)], porFila: 3)]),
                // Sin piezas a la izquierda, la de al lado ocupa su sitio.
                .init(titulo: "Vacía", piezas: [], alLado: [.init(titulo: "Al lado", piezas: [.lineas(["x"])])]),
                .init(
                    titulo: "Sin nada",
                    piezas: [.subtitulo(""), .grados([]), .caracter([], medidas: [], sonoridad: nil)]),
            ])
        let svg = hoja.svg(en: notacion)
        #expect(svg.contains(">صبا") && svg.contains(">Do Re</text>"))
        #expect(svg.contains(">a</text>") && svg.contains(">uno</text>") && svg.contains(">▸ 2</text>"))
        #expect(svg.contains(">Al lado</text>") && !svg.contains(">Vacía</text>") && !svg.contains(">Sin nada</text>"))
        let html = hoja.html(en: notacion)
        #expect(html.contains("<p class=\"originales\"><span lang=\"ar\" dir=\"rtl\""))
        #expect(html.contains("<ul class=\"notas\"><li>Do</li><li>Re</li></ul>"))
        #expect(html.contains("<tr><td>a</td></tr>") && html.contains("<ul><li>uno</li>"))
        #expect(html.contains("<div class=\"digitaciones\">") && html.contains("<h3>Con título</h3>"))
        #expect(html.contains("<div class=\"columnas\"><section><h2>Al lado</h2>") && !html.contains("Sin nada"))
        #expect(Hoja.anchoPropio(sinAncho) == nil && Hoja.anchoPropio("<svg width=\"30\"/>") == 30)
    }

    @Test func lasPiezasDeLasComparaciones() {
        let hoja = HojaCompuesta(
            titulo: "Una", otroTitulo: "Otra",
            secciones: [
                .init(titulo: "Origen", piezas: [.leyenda([("común", .comun), ("suave", .suave)])], tono: .origen),
                .init(
                    titulo: "",
                    piezas: [
                        .tablaMarcada([
                            [.init(texto: "1"), .init(texto: "Re", tono: .destino, negrita: true, resaltada: true)],
                            [.init(texto: "2", resaltada: true), .init(texto: "Mi", resaltada: true)],
                        ]), .destacado(["Resumen"]),
                    ], alLado: [.init(titulo: "Al lado", piezas: [.lineas(["x"])])], anchoAlLado: 200),
            ])
        let svg = hoja.svg(en: notacion)
        #expect(svg.contains("fill=\"#c0392b\" font-weight=\"bold\">Otra</text>"))
        #expect(svg.contains("fill=\"#27ae60\" font-weight=\"bold\">Origen</text>"))
        #expect(svg.contains("<circle") && svg.contains(">común</text>") && svg.contains("fill=\"#888888\""))
        #expect(svg.contains("fill=\"#fdecea\"") && svg.contains("font-weight=\"bold\">Resumen</text>"))
        let html = hoja.html(en: notacion)
        #expect(html.contains("<h1 class=\"destino\">Otra</h1>") && html.contains("<h2 class=\"origen\">Origen</h2>"))
        #expect(html.contains("<span class=\"punto comun\"></span>común") && html.contains("punto sub"))
        #expect(html.contains("<td class=\"destino negrita resaltada\">Re</td>"))
        #expect(html.contains("<tr class=\"cambia\"><td>2</td>"))
        #expect(html.contains("style=\"grid-template-columns:1fr 200pt\""))
        #expect(
            html.contains("<p><strong>Resumen</strong></p>") && html.contains("<title>Hoja de estudio · Una → Otra"))
    }

    @Test func lasCeldasQueNoCabenSeParten() {
        let larga = Array(repeating: "palabra", count: 40).joined(separator: " ")
        let svg = HojaCompuesta(titulo: "Tabla", secciones: [.init(titulo: "", piezas: [.tabla([["a", larga]])])])
            .svg(en: notacion)
        let lineas = svg.components(separatedBy: ">palabra palabra").count - 1
        #expect(lineas > 3)
    }

    @Test func lasPaginas() throws {
        // Muchas líneas no caben en una página: pasan a las siguientes, cada una con su número abajo.
        let lineas = (1...120).map { "Línea \($0)" }
        let hoja = HojaCompuesta(
            titulo: "Larga",
            secciones: [
                .init(titulo: "Primera", piezas: [.lineas(Array(lineas.prefix(21)))]),
                .init(titulo: "Segunda", piezas: [.lineas(Array(lineas.prefix(21)))]),
                .init(titulo: "Larga", piezas: [.lineas(lineas)]),
                .init(titulo: "Tabla", piezas: [.tabla([["Tramo"], ["a", "b"]])]),
            ])
        let svg = hoja.svg(en: notacion)
        let paginas = HojaDeEstudio.paginas(deUnSVG: svg)
        #expect(paginas.count == 5)
        #expect(svg.contains("data-paginas=\"5\"") && svg.contains("height=\"4210\""))
        #expect(svg.contains(">1 / 5</text>") && svg.contains(">5 / 5</text>"))
        #expect(
            paginas[1].contains("viewBox=\"0 842 595 842\"") && paginas[1].contains(" width=\"595pt\" height=\"842pt\"")
        )
        #expect(!paginas[1].contains("data-paginas") && paginas[1].hasSuffix("</svg>"))
        // La segunda sección, de menos de media página, no cabe entera debajo de la primera: empieza en la segunda
        // página. La larga sí se parte.
        func dondeEmpieza(_ texto: String) throws -> Double {
            let antes = try #require(svg.range(of: ">" + texto + "</text>")).lowerBound
            let traslado = try #require(svg[..<antes].range(of: "translate(0,", options: .backwards))
            return try #require(Double(svg[traslado.upperBound...].prefix { $0 != ")" }))
        }
        #expect(try dondeEmpieza("Segunda") == 842 + Hoja.margen)
        // La cabecera de un tramo no se queda sola al final de una página.
        #expect(try dondeEmpieza("Tramo") == dondeEmpieza("a"))
        // Una hoja corta es una página, sin número; un SVG que no es una hoja sale tal cual.
        let corta = HojaCompuesta(titulo: "Corta", secciones: []).svg(en: notacion)
        #expect(corta.contains("data-paginas=\"1\"") && !corta.contains(" / 1<"))
        let sola = try #require(HojaDeEstudio.paginas(deUnSVG: corta).first)
        #expect(HojaDeEstudio.paginas(deUnSVG: corta).count == 1 && sola.contains("viewBox=\"0 0 595 842\""))
        #expect(HojaDeEstudio.paginas(deUnSVG: "<svg viewBox=\"0 0 10 10\"/>") == ["<svg viewBox=\"0 0 10 10\"/>"])
    }

    @Test func losNombresDeAntes() throws {
        // Los nombres de antes, que siguen como obsoletos, dan lo mismo que `HojaDeEstudio`.
        let analisis = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", notacion: notacion)
        func comoAntes<T: HojasDeAntes>(_ tipo: T.Type) -> [String?] { tipo.todas(notacion, analisis) }
        let antes =
            comoAntes(PresentacionDeEstudioDeEscala.self) + comoAntes(PresentacionDeRelacionesDeAcorde.self)
            + comoAntes(PresentacionDeAnalisis.self) + comoAntes(PresentacionDeTonalidad.self)
        let ahora: [String?] = [
            HojaDeEstudio.escala(Escala(.re, .dorico), en: notacion),
            HojaDeEstudio.escala(Escala(.re, .dorico), en: notacion, formato: .html),
            HojaDeEstudio.comparacion(Escala(.do), con: Escala(.do, .dorico), en: notacion),
            HojaDeEstudio.comparacion(Escala(.do), con: Escala(.do, .dorico), en: notacion, formato: .html),
            "\(HojaDeEstudio.tamano(deUnSVG: "<svg viewBox=\"0 0 595 800\"></svg>").map { $0.alto } ?? 0)",
            HojaDeEstudio.acorde(Acorde("Sol7"), en: notacion),
            HojaDeEstudio.acorde(Acorde("Sol7"), en: notacion, formato: .html),
            HojaDeEstudio.analisis(analisis, en: notacion),
            HojaDeEstudio.analisis(analisis, en: notacion, formato: .html),
            HojaDeEstudio.enLasDoceTonalidades(analisis.acordes, tonalidad: Tonalidad(.do), en: notacion),
            HojaDeEstudio.enLasDoceTonalidades(
                analisis.acordes, tonalidad: Tonalidad(.do), en: notacion, formato: .html),
            HojaDeEstudio.comparacion(analisis.acordes, con: [Acorde("Do")], notacion: notacion),
            HojaDeEstudio.comparacion(analisis.acordes, con: [Acorde("Do")], notacion: notacion, formato: .html),
            HojaDeEstudio.tonalidad(Tonalidad(.re), en: notacion),
            HojaDeEstudio.tonalidad(Tonalidad(.re), en: notacion, formato: .html),
        ]
        #expect(antes == ahora)
    }
}

/// Llama a los nombres de antes a través de un protocolo, para probarlos sin avisos de obsoleto.
protocol HojasDeAntes {
    static func todas(_ notacion: Notacion, _ analisis: AnalisisPresentado) -> [String?]
}

protocol HojaDeEscalaDeAntes {
    static func hojaDeEstudio(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja>, mastil: Mastil
    ) -> String
    static func hojaDeEstudioHTML(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja>, mastil: Mastil
    ) -> String
    static func comparacionNotaANota(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String
    static func comparacionNotaANotaHTML(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String
    static func tamano(deUnSVG svg: String) -> (ancho: Double, alto: Double)?
}

extension PresentacionDeEstudioDeEscala: HojaDeEscalaDeAntes, HojasDeAntes {
    static func todas(_ notacion: Notacion, _ analisis: AnalisisPresentado) -> [String?] {
        func antes<T: HojaDeEscalaDeAntes>(_ tipo: T.Type) -> [String?] {
            let todas = Set(SeccionDeLaHoja.allCases)
            let mastil = Mastil(.guitarra, numeroDeTrastes: 15)
            return [
                tipo.hojaDeEstudio(de: Escala(.re, .dorico), en: notacion, secciones: todas, mastil: mastil),
                tipo.hojaDeEstudioHTML(de: Escala(.re, .dorico), en: notacion, secciones: todas, mastil: mastil),
                tipo.comparacionNotaANota(Escala(.do), con: Escala(.do, .dorico), en: notacion),
                tipo.comparacionNotaANotaHTML(Escala(.do), con: Escala(.do, .dorico), en: notacion),
                "\(tipo.tamano(deUnSVG: "<svg viewBox=\"0 0 595 800\"></svg>").map { $0.alto } ?? 0)",
            ]
        }
        return antes(Self.self)
    }
}

protocol HojaDeAcordeDeAntes {
    static func hojaDeEstudio(de acorde: Acorde, mastil: Mastil, en notacion: Notacion) -> String
    static func hojaDeEstudioHTML(de acorde: Acorde, mastil: Mastil, en notacion: Notacion) -> String
}

extension PresentacionDeRelacionesDeAcorde: HojaDeAcordeDeAntes, HojasDeAntes {
    static func todas(_ notacion: Notacion, _ analisis: AnalisisPresentado) -> [String?] {
        func antes<T: HojaDeAcordeDeAntes>(_ tipo: T.Type) -> [String?] {
            let mastil = Mastil(.guitarra, numeroDeTrastes: 12)
            return [
                tipo.hojaDeEstudio(de: Acorde("Sol7"), mastil: mastil, en: notacion),
                tipo.hojaDeEstudioHTML(de: Acorde("Sol7"), mastil: mastil, en: notacion),
            ]
        }
        return antes(Self.self)
    }
}

protocol HojaDeAnalisisDeAntes {
    static func hojaDeEstudio(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String
    static func hojaDeEstudioHTML(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String
    static func hojaEnLasDoceTonalidades(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String
    static func hojaEnLasDoceTonalidadesHTML(
        _ acordes: [Acorde], tonalidad: Tonalidad, disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String
    static func hojaDeLaComparacion(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad?, disposicion: DisposicionDeAcorde,
        notacion: Notacion
    ) -> String?
    static func hojaDeLaComparacionHTML(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad?, disposicion: DisposicionDeAcorde,
        notacion: Notacion
    ) -> String?
}

extension PresentacionDeAnalisis: HojaDeAnalisisDeAntes, HojasDeAntes {
    static func todas(_ notacion: Notacion, _ analisis: AnalisisPresentado) -> [String?] {
        func antes<T: HojaDeAnalisisDeAntes>(_ tipo: T.Type) -> [String?] {
            let acordes = analisis.acordes
            return [
                tipo.hojaDeEstudio(analisis, disposicion: .drop2, en: notacion),
                tipo.hojaDeEstudioHTML(analisis, disposicion: .drop2, en: notacion),
                tipo.hojaEnLasDoceTonalidades(acordes, tonalidad: Tonalidad(.do), disposicion: .drop2, en: notacion),
                tipo.hojaEnLasDoceTonalidadesHTML(
                    acordes, tonalidad: Tonalidad(.do), disposicion: .drop2, en: notacion),
                tipo.hojaDeLaComparacion(
                    acordes, con: [Acorde("Do")], en: nil, disposicion: .drop2, notacion: notacion),
                tipo.hojaDeLaComparacionHTML(
                    acordes, con: [Acorde("Do")], en: nil, disposicion: .drop2, notacion: notacion),
            ]
        }
        return antes(Self.self)
    }
}

protocol HojaDeTonalidadDeAntes {
    static func hojaDeEstudio(de tonalidad: Tonalidad, en notacion: Notacion) -> String
    static func hojaDeEstudioHTML(de tonalidad: Tonalidad, en notacion: Notacion) -> String
}

extension PresentacionDeTonalidad: HojaDeTonalidadDeAntes, HojasDeAntes {
    static func todas(_ notacion: Notacion, _ analisis: AnalisisPresentado) -> [String?] {
        func antes<T: HojaDeTonalidadDeAntes>(_ tipo: T.Type) -> [String?] {
            [
                tipo.hojaDeEstudio(de: Tonalidad(.re), en: notacion),
                tipo.hojaDeEstudioHTML(de: Tonalidad(.re), en: notacion),
            ]
        }
        return antes(Self.self)
    }
}

// Qué es una hoja de estudio, de las que las apps pasan a PDF.
@Suite struct EsUnaHojaTests {
    @Test func unaHojaSeReconocePorSusPaginas() {
        let notacion = Notacion.compacta(.espanol)
        #expect(HojaDeEstudio.esUnaHoja(HojaDeEstudio.ritmo(.tresillo, en: notacion)))
        #expect(HojaDeEstudio.esUnaHoja(HojaDeEstudio.escala(Escala(.re, .dorico), en: notacion)))
        #expect(!HojaDeEstudio.esUnaHoja("<svg viewBox=\"0 0 10 10\"></svg>"))
        #expect(!HojaDeEstudio.esUnaHoja(HojaDeEstudio.ritmo(.tresillo, en: notacion, formato: .html)))
        // Un dibujo que no es una hoja (el pentagrama de un acorde) no se pasa a PDF.
        #expect(!PentagramaPresentado(Acorde("Sol7"), en: notacion).fichero.esUnaHojaEnSVG)
        #expect(FicheroParaExportar.svg(HojaDeEstudio.ritmo(.tresillo, en: notacion), nombre: "x").esUnaHojaEnSVG)
        #expect(!FicheroParaExportar.html(HojaDeEstudio.ritmo(.tresillo, en: notacion), nombre: "x").esUnaHojaEnSVG)
    }
}
