import Armonia

// MARK: - La hoja de estudio en HTML

extension PresentacionDeEstudioDeEscala {
    /// La hoja de estudio de la escala como página HTML: lo mismo que `hojaDeEstudio(de:en:secciones:)`, pero con los
    /// textos en HTML (el nombre, las notas, las estadísticas en una lista de definiciones, los acordes de los grados
    /// y la escalera de brillo en listas) y los dibujos (el pentagrama, el reloj, el círculo microtonal y los
    /// teclados) como SVG dentro. Se adapta al ancho de la pantalla (en una estrecha, las columnas se apilan), sigue
    /// el modo oscuro del sistema y se imprime en A4. Una sola página, sin nada de fuera.
    /// `armonia hoja Do mayor --html` la escribe.
    ///
    ///     let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudioHTML(
    ///         de: Escala(.re, .dorico), en: .compacta(.espanol))
    ///     hoja.hasPrefix("<!doctype html>")   // true
    public static func hojaDeEstudioHTML(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases)
    ) -> String {
        let nombre = escala.nombre(en: notacion)
        var cuerpo: [String] = []

        // El nombre y las notas.
        cuerpo.append("<header>")
        cuerpo.append("<h1>" + html(nombre) + "</h1>")
        let notas = escala.notas.map { "<li>" + html($0.nombre(en: notacion)) + "</li>" }.joined()
        cuerpo.append("<ul class=\"notas\">" + notas + "</ul>")
        cuerpo.append("</header>")

        // El pentagrama, de lado a lado.
        if secciones.contains(.pentagrama) {
            cuerpo.append(
                seccion(
                    .pentagrama, en: notacion,
                    figura(PentagramaPresentado(escala, en: notacion).svg, clase: "ancha")))
        }

        // Las estadísticas y el reloj (con el círculo microtonal, si tiene microtonos), en dos columnas.
        var columnas: [String] = []
        if secciones.contains(.estadisticas) {
            let datos = estadisticas(de: escala, en: notacion).map {
                "<div><dt>" + html($0.nombre) + "</dt><dd>" + html($0.valor) + "</dd></div>"
            }
            columnas.append(seccion(.estadisticas, en: notacion, "<dl>" + datos.joined() + "</dl>"))
        }
        if secciones.contains(.reloj) {
            var relojes = [figura(reloj(de: escala, en: notacion), clase: "reloj")]
            if let microtonal = relojMicrotonal(de: escala, en: notacion) {
                relojes.append(figura(microtonal, clase: "reloj"))
            }
            columnas.append(seccion(.reloj, en: notacion, relojes.joined()))
        }
        if !columnas.isEmpty {
            cuerpo.append("<div class=\"columnas\">" + columnas.joined() + "</div>")
        }

        // El teclado de cada mano, uno al lado del otro.
        if secciones.contains(.teclados) {
            let teclados = Mano.allCases.map { figura(teclado(de: escala, mano: $0, en: notacion), clase: "teclado") }
            cuerpo.append(
                seccion(.teclados, en: notacion, "<div class=\"teclados\">" + teclados.joined() + "</div>"))
        }

        // Los acordes de cada grado, si los forma.
        if secciones.contains(.acordes), let acordes = EscalaPresentada(escala, en: notacion).acordes {
            let filas = acordes.map {
                "<li><span class=\"grado\">" + html($0.grado) + "</span> " + html($0.cifrado) + "</li>"
            }
            cuerpo.append(seccion(.acordes, en: notacion, "<ul class=\"acordes\">" + filas.joined() + "</ul>"))
        }

        // La escalera de brillo, de la más oscura a la más brillante, con la de partida resaltada.
        let peldanos = secciones.contains(.escalera) ? escaleraDeBrillo(de: escala, en: notacion) : []
        if peldanos.count > 1 {
            let filas = peldanos.map { peldano in
                let texto = "<span class=\"brillo\">" + html(peldano.brillo) + "</span> " + html(peldano.nombre)
                return peldano.esLaDePartida
                    ? "<li aria-current=\"true\"><strong>" + texto + "</strong></li>"
                    : "<li>" + texto + "</li>"
            }
            cuerpo.append(seccion(.escalera, en: notacion, "<ol class=\"escalera\">" + filas.joined() + "</ol>"))
        }

        let titulo = notacion.texto(\.hojaDeEstudio) + " · " + nombre
        return paginaHTML(titulo: titulo, idioma: notacion.textos.codigo, cuerpo)
    }

    /// Una sección de la hoja, con su título.
    private static func seccion(_ seccion: SeccionDeLaHoja, en notacion: Notacion, _ contenido: String) -> String {
        "<section class=\"seccion-" + seccion.rawValue + "\"><h2>" + html(seccion.nombre(en: notacion)) + "</h2>"
            + contenido + "</section>"
    }

    /// Un dibujo dentro de la página: el SVG tal cual, sin la declaración XML si la lleva, en su `<figure>`.
    static func figura(_ svg: String, clase: String) -> String {
        guard let raiz = svg.range(of: "<svg") else { return "" }
        return "<figure class=\"" + clase + "\">" + svg[raiz.lowerBound...] + "</figure>"
    }

    /// El texto escapado para ir dentro del HTML.
    static func html(_ texto: String) -> String {
        EscrituraXML.escapar(texto)
    }

    /// La página entera: la cabecera con el título, el idioma y la hoja de estilo, y `cuerpo` dentro, una línea por
    /// elemento.
    static func paginaHTML(titulo: String, idioma: String, _ cuerpo: [String]) -> String {
        let cabecera = [
            "<!doctype html>",
            "<html lang=\"" + html(idioma) + "\">",
            "<head>",
            "<meta charset=\"utf-8\">",
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
            "<title>" + html(titulo) + "</title>",
            "<style>" + estiloDeLaHoja + "</style>",
            "</head>",
            "<body>",
            "<main>",
        ]
        return (cabecera + cuerpo + ["</main>", "</body>", "</html>"]).joined(separator: "\n")
    }

    /// La hoja de estilo: el ancho de un A4 como mucho, las columnas que se apilan en una pantalla estrecha, el modo
    /// oscuro (los dibujos, que son de fondo claro, van sobre una tarjeta blanca) y la impresión en A4.
    static let estiloDeLaHoja = """
        :root{color-scheme:light dark;--texto:#222;--suave:#555;--fondo:#fff;--linea:#ddd;--resalte:#fff4cc}\
        @media (prefers-color-scheme:dark){:root{--texto:#eee;--suave:#aaa;--fondo:#1c1c1e;--linea:#3a3a3c;\
        --resalte:#4a3f1a}}\
        *{box-sizing:border-box}\
        body{margin:0;background:var(--fondo);color:var(--texto);font:15px/1.45 Helvetica,Arial,sans-serif}\
        main{max-width:595pt;margin:0 auto;padding:24px 16px}\
        h1{font-size:24pt;margin:0 0 4px}\
        h2{font-size:14pt;margin:24px 0 8px}\
        ul,ol{margin:0;padding:0;list-style:none}\
        .notas{display:flex;flex-wrap:wrap;gap:0 .6em;color:var(--suave);font-size:13pt}\
        figure{margin:0;background:#fff;color:#222;border-radius:8px}\
        figure svg{display:block;width:100%;height:auto}\
        .columnas{display:grid;grid-template-columns:1fr 170pt;gap:0 24px}\
        .columnas>section:only-child{grid-column:1/-1}\
        .reloj{max-width:220pt;margin:0 auto 8px}\
        dl{margin:0}\
        dl div{display:flex;gap:.5em;padding:3px 0;border-bottom:1px solid var(--linea)}\
        dt{flex:0 0 45%;color:var(--suave)}\
        dd{margin:0}\
        .teclados{display:grid;grid-template-columns:1fr 1fr;gap:15px}\
        .acordes{display:grid;grid-template-columns:repeat(auto-fill,minmax(11em,1fr));gap:4px 12px}\
        .grado,.brillo{display:inline-block;color:var(--suave)}.grado{min-width:4.5em}.brillo{min-width:2.5em}\
        .escalera li{padding:2px 6px;border-radius:4px}\
        .escalera li[aria-current]{background:var(--resalte)}\
        @media (max-width:560px){.columnas,.teclados{grid-template-columns:1fr}}\
        @media print{@page{size:A4;margin:40pt}:root{--texto:#222;--suave:#555;--fondo:#fff;--linea:#ddd;\
        --resalte:#fff4cc}main{max-width:none;padding:0}section{break-inside:avoid}}
        """
}
