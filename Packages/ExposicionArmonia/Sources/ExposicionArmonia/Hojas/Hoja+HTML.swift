import Armonia

// MARK: - Las piezas de las hojas en HTML
//
// Lo que comparten las hojas de estudio en HTML: la página con su estilo, las secciones, las figuras, las tablas y las
// listas.

extension Hoja {
    /// Una sección con su título (sin escapar; sin título, si está vacío), del color de su `tono` si lo lleva (la
    /// clase `origen`, `destino`…), y su contenido (ya en HTML).
    static func seccionHTML(_ titulo: String, _ contenido: String, clase: String? = nil, tono: String? = nil) -> String
    {
        "<section" + (clase.map { " class=\"" + $0 + "\"" } ?? "") + ">"
            + (titulo.isEmpty
                ? "" : "<h2" + (tono.map { " class=\"" + $0 + "\"" } ?? "") + ">" + html(titulo) + "</h2>")
            + contenido + "</section>"
    }

    /// El carácter: una línea por fuente, con sus palabras entre comillas y su cita; las fuentes que no coinciden, lo
    /// que mide un estudio y la sonoridad calculada. Vacío si no hay nada que decir.
    static func caracterHTML(
        _ caracter: [Caracter], medidas: [MedidaDelAfecto] = [], sonoridad: Sonoridad? = nil, en notacion: Notacion
    ) -> String {
        let fuentes = caracter.map { CaracterPresentado($0, en: notacion) }.map { fuente in
            "<li>" + html(fuente.descripcion) + (fuente.texto.map { " <q>" + html($0) + "</q>" } ?? "")
                + " <small>" + html(fuente.cita) + "</small></li>"
        }
        func fila(_ nombre: String, _ valor: String) -> String {
            "<div><dt>" + html(nombre) + "</dt><dd>" + html(valor) + "</dd></div>"
        }
        var filas: [String] = []
        if let pares = CaracterPresentado.discrepancias(caracter, en: notacion) {
            filas.append(fila(notacion.texto(\.fuentesQueNoCoinciden), pares.joined(separator: "; ")))
        }
        for medida in medidas {
            filas.append(
                fila(notacion.texto(\.afectoMedido), MedidaDelAfectoPresentada(medida, en: notacion).enUnaLinea))
        }
        if let sonoridad { filas.append(fila(notacion.texto(\.sonoridadCalculada), sonoridad.nombre(en: notacion))) }
        let lista = fuentes.isEmpty ? "" : "<ul class=\"caracter\">" + fuentes.joined() + "</ul>"
        return lista + (filas.isEmpty ? "" : "<dl>" + filas.joined() + "</dl>")
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
        let estilo = anchoPropio(svg).map { " style=\"max-width:" + numero(2 * $0) + "px\"" } ?? ""
        return "<figure class=\"" + clase + "\"" + estilo + ">" + dibujo + "</figure>"
    }

    /// El texto escapado para ir dentro del HTML.
    static func html(_ texto: String) -> String {
        EscrituraXML.escapar(texto)
    }

    /// Un nombre original con su idioma (`lang`, que escoge los glifos y la voz) y su dirección (`dir`), y la lectura,
    /// si la tiene, detrás: `<span lang="ja">陽音階</span> <small>Yō onkai</small>`.
    static func nombreOriginalHTML(_ original: NombreOriginalPresentado) -> String {
        "<span lang=\"" + html(original.idioma) + "\"" + (original.derechaAIzquierda ? " dir=\"rtl\"" : "")
            + " title=\"" + html(original.nombreDelIdioma) + "\">" + html(original.texto) + "</span>"
            + (original.lectura.map { " <small>" + html($0) + "</small>" } ?? "")
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
        ul.caracter{margin:0 0 8px;padding-left:1.2em}ul.caracter small{color:var(--suave)}\
        ul,ol{margin:0;padding:0;list-style:none}\
        li{padding:2px 0}\
        .originales{font-size:16pt;color:var(--suave);margin:0 0 4px}.originales small{font-size:10pt}\
        :lang(ar),:lang(fa){font-family:"Geeza Pro","Noto Naskh Arabic","Noto Sans Arabic",serif}\
        :lang(hi),:lang(sa){font-family:"Kohinoor Devanagari","Devanagari Sangam MN","Noto Sans Devanagari",sans-serif}\
        :lang(te){font-family:"Kohinoor Telugu","Telugu Sangam MN","Noto Sans Telugu",sans-serif}\
        :lang(kn){font-family:"Kannada Sangam MN","Noto Sans Kannada",sans-serif}\
        :lang(ta){font-family:"Tamil Sangam MN","Noto Sans Tamil",sans-serif}\
        :lang(zh){font-family:"PingFang TC","Noto Sans CJK TC","Noto Sans TC",sans-serif}\
        :lang(zh-Hans){font-family:"PingFang SC","Noto Sans CJK SC","Noto Sans SC",sans-serif}\
        :lang(ja){font-family:"Hiragino Sans","Noto Sans CJK JP","Noto Sans JP",sans-serif}\
        :lang(ko){font-family:"Apple SD Gothic Neo","Noto Sans CJK KR","Noto Sans KR",sans-serif}\
        :lang(am){font-family:Kefa,"Noto Sans Ethiopic",sans-serif}\
        :lang(th){font-family:Thonburi,"Noto Sans Thai",sans-serif}\
        :lang(km){font-family:"Khmer Sangam MN","Noto Sans Khmer",sans-serif}\
        :lang(he),:lang(yi){font-family:"Arial Hebrew","Noto Sans Hebrew",sans-serif}\
        :lang(my){font-family:"Myanmar Sangam MN","Noto Sans Myanmar",sans-serif}\
        :lang(grc){font-family:"Noto Serif","Times New Roman",serif}\
        .notas{display:flex;flex-wrap:wrap;gap:0 .6em;color:var(--suave);font-size:13pt}\
        figure{margin:0 0 8px;background:#fff;color:#222;border-radius:8px}\
        figure svg{display:block;width:100%;height:auto}\
        .columnas{display:grid;grid-template-columns:1fr 170pt;gap:0 24px}\
        .columnas>section:only-child{grid-column:1/-1}\
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
        .etiqueta{font-weight:bold}.acordes .etiqueta,.escalera .etiqueta{display:inline-block;font-weight:normal;\
        color:var(--suave);min-width:2.5em}.acordes .etiqueta{min-width:4.5em}\
        .escalera li{padding:2px 6px;border-radius:4px}\
        .escalera li[aria-current]{background:var(--resalte)}\
        td.negrita{font-weight:bold}td.resaltada{background:var(--resalte)}\
        .leyenda li{display:flex;gap:.5em;align-items:baseline}\
        .punto{display:inline-block;width:10px;height:10px;border-radius:50%;flex:none;background:currentColor}\
        @media (max-width:560px){.columnas,.teclados{grid-template-columns:1fr!important}}\
        @media print{@page{size:A4;margin:40pt}:root{--texto:#222;--suave:#555;--fondo:#fff;--linea:#ddd;\
        --resalte:#fff4cc;--origen:#1e8449;--destino:#c0392b;--comun:#1f4e9c}main{max-width:none;padding:0}\
        section{break-inside:avoid}}
        """
}
