import Armonia

// MARK: - La hoja de estudio en HTML

extension PresentacionDeEstudioDeEscala {
    /// La hoja de estudio de la escala como página HTML: lo mismo que `hojaDeEstudio(de:en:secciones:)`, pero con los
    /// textos en HTML (el nombre, las notas, el origen y las estadísticas en listas de definiciones, los acordes de
    /// los grados y la escalera de brillo en listas) y los dibujos (el pentagrama, el reloj, el círculo microtonal y
    /// los teclados) como SVG dentro. Se adapta al ancho de la pantalla (en una estrecha, las columnas se apilan), sigue
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

        // De cuándo y de dónde es, con las estadísticas: la época, los lugares, los estilos…
        if secciones.contains(.estadisticas), let origen = OrigenDeEscalaPresentado(escala.tipo, en: notacion) {
            let datos = origen.datos(en: notacion).map {
                "<div><dt>" + html($0.nombre) + "</dt><dd>" + html($0.valor) + "</dd></div>"
            }
            cuerpo.append(
                seccionHTML(notacion.texto(\.origen), "<dl>" + datos.joined() + "</dl>", clase: "seccion-origen"))
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
        seccionHTML(seccion.nombre(en: notacion), contenido, clase: "seccion-" + seccion.rawValue)
    }
}

// MARK: - Las piezas de las hojas en HTML
//
// Lo que comparten las hojas de estudio en HTML (la de una escala, la de un acorde, la de una progresión, la de una
// tonalidad y las comparaciones): la página con su estilo, las secciones, las figuras, las tablas y las listas.

extension PresentacionDeEstudioDeEscala {
    /// La cabecera de una hoja: el título y, debajo, cada subtítulo en un párrafo más suave.
    static func encabezadoHTML(_ titulo: String, _ subtitulos: [String] = []) -> String {
        "<header><h1>" + html(titulo) + "</h1>"
            + subtitulos.filter { !$0.isEmpty }.map { "<p class=\"sub\">" + html($0) + "</p>" }.joined()
            + "</header>"
    }

    /// Una sección con su título (ya sin escapar) y su contenido (ya en HTML).
    static func seccionHTML(_ titulo: String, _ contenido: String, clase: String? = nil) -> String {
        "<section" + (clase.map { " class=\"" + $0 + "\"" } ?? "") + "><h2>" + html(titulo) + "</h2>" + contenido
            + "</section>"
    }

    /// Una lista de textos, cada uno escapado.
    static func listaHTML(_ elementos: [String], clase: String? = nil) -> String {
        "<ul" + (clase.map { " class=\"" + $0 + "\"" } ?? "") + ">"
            + elementos.map { "<li>" + html($0) + "</li>" }.joined() + "</ul>"
    }

    /// Una tabla: una fila por elemento, con sus celdas escapadas, y la clase de la fila si la lleva (`cambia`…). Una
    /// fila de una sola celda (la cabecera de un tramo) ocupa todo el ancho. Va dentro de un bloque que se desplaza
    /// de lado si no cabe.
    static func tablaHTML(_ filas: [(celdas: [String], clase: String?)]) -> String {
        let columnas = filas.map(\.celdas.count).max() ?? 1
        let cuerpo = filas.map { fila in
            let celdas =
                fila.celdas.count == 1 && columnas > 1
                ? "<td colspan=\"\(columnas)\">" + html(fila.celdas[0]) + "</td>"
                : fila.celdas.map { "<td>" + html($0) + "</td>" }.joined()
            return "<tr" + (fila.clase.map { " class=\"" + $0 + "\"" } ?? "") + ">" + celdas + "</tr>"
        }
        return "<div class=\"tabla\"><table>" + cuerpo.joined() + "</table></div>"
    }

    /// Un dibujo hecho con las piezas de las hojas en SVG (`texto`, `incrustar`…), de `ancho` × `alto`, como SVG
    /// suelto para una figura.
    static func dibujoSVG(ancho: Double, alto: Double, _ cuerpo: [String]) -> String {
        hojaSVG(ancho: ancho, alto: alto.rounded(.up), cuerpo)
    }

    /// Un dibujo dentro de la página: el SVG tal cual, sin la declaración XML si la lleva, en su `<figure>`. Ocupa
    /// todo el ancho que tenga, pero no más del doble del suyo, para que un pentagrama corto (un acorde, tres notas
    /// guía) no salga enorme.
    static func figura(_ svg: String, clase: String) -> String {
        guard let raiz = svg.range(of: "<svg") else { return "" }
        let dibujo = svg[raiz.lowerBound...]
        var estilo = ""
        if let cierre = dibujo.firstIndex(of: ">"), let atributo = dibujo[..<cierre].range(of: " width=\""),
            let fin = dibujo[atributo.upperBound...].firstIndex(of: "\""),
            let ancho = Double(dibujo[atributo.upperBound..<fin]), ancho > 0
        {
            estilo = " style=\"max-width:" + numero(2 * ancho) + "px\""
        }
        return "<figure class=\"" + clase + "\"" + estilo + ">" + dibujo + "</figure>"
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
        :root{color-scheme:light dark;--texto:#222;--suave:#555;--fondo:#fff;--linea:#ddd;--resalte:#fff4cc;\
        --origen:#1e8449;--destino:#c0392b;--comun:#1f4e9c}\
        @media (prefers-color-scheme:dark){:root{--texto:#eee;--suave:#aaa;--fondo:#1c1c1e;--linea:#3a3a3c;\
        --resalte:#4a3f1a;--origen:#58d68d;--destino:#f1948a;--comun:#85b4ff}}\
        *{box-sizing:border-box}\
        body{margin:0;background:var(--fondo);color:var(--texto);font:15px/1.45 Helvetica,Arial,sans-serif}\
        main{max-width:595pt;margin:0 auto;padding:24px 16px}\
        h1{font-size:22pt;margin:0 0 4px}\
        h2{font-size:14pt;margin:24px 0 8px}\
        h3{font-size:11pt;margin:12px 0 2px}\
        p{margin:2px 0}\
        .sub{color:var(--suave)}\
        ul,ol{margin:0;padding:0;list-style:none}\
        li{padding:2px 0}\
        .notas{display:flex;flex-wrap:wrap;gap:0 .6em;color:var(--suave);font-size:13pt}\
        figure{margin:0 0 8px;background:#fff;color:#222;border-radius:8px}\
        figure svg{display:block;width:100%;height:auto}\
        .columnas{display:grid;grid-template-columns:1fr 170pt;gap:0 24px}\
        .columnas>section:only-child{grid-column:1/-1}\
        .reloj{max-width:220pt;margin:0 auto 8px}\
        .pequena{max-width:240pt}\
        dl{margin:0}\
        dl div{display:flex;gap:.5em;padding:3px 0;border-bottom:1px solid var(--linea)}\
        dt{flex:0 0 45%;color:var(--suave)}\
        dd{margin:0}\
        .tabla{overflow-x:auto}\
        table{border-collapse:collapse;width:100%}\
        td{padding:3px 12px 3px 0;border-bottom:1px solid var(--linea);vertical-align:top}\
        tr.tramo td{font-weight:bold;color:var(--suave);padding-top:10px}\
        tr.cambia td{background:var(--resalte);color:var(--destino);font-weight:bold}\
        .origen{color:var(--origen)}.destino{color:var(--destino)}.comun{color:var(--comun)}\
        .teclados{display:grid;grid-template-columns:1fr 1fr;gap:15px}\
        .digitaciones{display:grid;grid-template-columns:repeat(auto-fill,minmax(90px,1fr));gap:8px}\
        .acordes{display:grid;grid-template-columns:repeat(auto-fill,minmax(11em,1fr));gap:4px 12px}\
        .grados{display:grid;grid-template-columns:repeat(auto-fill,minmax(5.5em,1fr));gap:8px}\
        .grados li{display:flex;flex-direction:column}\
        .grados small{color:var(--suave)}\
        .grado,.brillo{display:inline-block;color:var(--suave)}.grado{min-width:4.5em}.brillo{min-width:2.5em}\
        .escalera li{padding:2px 6px;border-radius:4px}\
        .escalera li[aria-current]{background:var(--resalte)}\
        .grados-comparados td{text-align:center}.grados-comparados td:first-child{text-align:left}\
        .grados-comparados .propia{font-weight:bold}.grados-comparados .cambio{background:var(--resalte)}\
        .comparacion{display:grid;grid-template-columns:220pt 1fr;gap:16px;align-items:start}\
        .leyenda li{display:flex;gap:.5em;align-items:baseline}\
        .punto{display:inline-block;width:10px;height:10px;border-radius:50%;flex:none;background:currentColor}\
        @media (max-width:560px){.columnas,.teclados,.comparacion{grid-template-columns:1fr}}\
        @media print{@page{size:A4;margin:40pt}:root{--texto:#222;--suave:#555;--fondo:#fff;--linea:#ddd;\
        --resalte:#fff4cc;--origen:#1e8449;--destino:#c0392b;--comun:#1f4e9c}main{max-width:none;padding:0}\
        section{break-inside:avoid}}
        """
}

// MARK: - La comparación de dos escalas en HTML

extension PresentacionDeEstudioDeEscala {
    /// Dos escalas comparadas nota a nota como página HTML: lo mismo que `comparacionNotaANota(_:con:en:)` (los dos
    /// pentagramas, la tabla grado a grado con los que cambian resaltados, el reloj con las dos escalas encima y la
    /// leyenda), con los textos en HTML. Lo común va en azul; lo que solo está en la primera, en verde; lo de la
    /// segunda, en rojo. `armonia hoja Do mayor --comparar Do dórico --html` la escribe.
    ///
    ///     let hoja = PresentacionDeEstudioDeEscala.comparacionNotaANotaHTML(
    ///         Escala(.do), con: Escala(.do, .dorico), en: .compacta(.espanol))
    ///     hoja.contains("<h1>Do mayor → Do dórico</h1>")   // true
    public static func comparacionNotaANotaHTML(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        let datos = comparar(escala, con: otra, en: notacion)
        let comparacion = datos.relacion
        let titulo = escala.nombre(en: notacion) + " → " + otra.nombre(en: notacion)
        var cuerpo = [encabezadoHTML(titulo, [datos.distancia ?? ""])]

        // Los dos pentagramas, cada uno con su nombre, del color de su escala.
        for (cual, clase) in [(escala, "origen"), (otra, "destino")] {
            cuerpo.append("<h2 class=\"" + clase + "\">" + html(cual.nombre(en: notacion)) + "</h2>")
            cuerpo.append(figura(PentagramaPresentado(cual, en: notacion).svg, clase: "pentagrama"))
        }

        // Grado a grado: los números y una fila por escala, con los grados que cambian resaltados.
        let origen = comparacion.origen.notas
        let destino = comparacion.destino.notas
        let enOrigen = Set(origen.map(\.claseDeAltura))
        let enDestino = Set(destino.map(\.claseDeAltura))
        let cambian = Set(comparacion.cambios.map(\.grado))
        let columnas = max(origen.count, destino.count)
        func celda(_ grado: Int, _ contenido: String, clase: String) -> String {
            let todas = cambian.contains(grado) ? clase + " cambio" : clase
            return "<td class=\"" + todas + "\">" + html(contenido) + "</td>"
        }
        var filas = [
            "<tr><td></td>" + (1...max(columnas, 1)).map { celda($0, String($0), clase: "sub") }.joined() + "</tr>"
        ]
        let escalas: [(Escala, [Nota], Set<Int>, String)] = [
            (comparacion.origen, origen, enDestino, "origen"), (comparacion.destino, destino, enOrigen, "destino"),
        ]
        for (cual, notas, enLaOtra, propia) in escalas {
            let celdas = notas.enumerated().map { i, nota in
                let comun = enLaOtra.contains(nota.claseDeAltura)
                return celda(i + 1, nota.nombre(en: notacion), clase: comun ? "comun" : propia + " propia")
            }
            filas.append(
                "<tr><td class=\"" + propia + "\"><strong>" + html(cual.nombre(en: notacion)) + "</strong></td>"
                    + celdas.joined() + "</tr>")
        }
        cuerpo.append("<div class=\"tabla\"><table class=\"grados-comparados\">" + filas.joined() + "</table></div>")

        // El reloj con las dos escalas y, al lado, la leyenda y los grados que cambian.
        var reloj: [String] = []
        let lado = relojDeLaComparacion(comparacion, x: 0, y: 0, lado: 220, notacion: notacion, en: &reloj)
        let leyenda = [
            (notacion.texto(\.notasComunes) + ": " + datos.comunes, "comun"),
            (datos.soloEnOrigen, "origen"), (datos.soloEnDestino, "destino"),
        ].filter { !$0.0.isEmpty }.map { texto, clase in
            "<li><span class=\"punto " + clase + "\"></span>" + html(texto) + "</li>"
        }
        let costado = "<div><ul class=\"leyenda\">" + leyenda.joined() + "</ul>" + listaHTML(datos.cambios) + "</div>"
        cuerpo.append(
            "<div class=\"comparacion\">" + figura(dibujoSVG(ancho: lado, alto: lado, reloj), clase: "reloj") + costado
                + "</div>")
        return paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + titulo, idioma: notacion.textos.codigo, cuerpo)
    }
}
