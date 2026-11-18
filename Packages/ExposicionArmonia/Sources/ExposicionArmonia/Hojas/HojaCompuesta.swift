import Armonia
import Foundation

// MARK: - Una hoja hecha de secciones

/// Una hoja de estudio hecha de secciones, que se escribe igual en SVG, del ancho de un A4 para imprimir, y en HTML:
/// la de todas las hojas de `HojaDeEstudio`. Arriba van el título, las notas, los nombres originales y los
/// subtítulos, con un dibujo a la derecha si lo lleva; debajo, las secciones, cada una con su título y sus piezas:
/// datos («nombre: valor»), líneas de texto, tablas, listas, el carácter y dibujos.
struct HojaCompuesta {
    /// Un elemento de una lista: una etiqueta delante (el grado, el brillo, el nombre de una escala) y su texto,
    /// resaltado si es el de partida.
    struct Elemento {
        let etiqueta: String?
        let texto: String
        var resaltado = false
    }

    /// Lo que va dentro de una sección.
    enum Pieza {
        /// Un dato por línea, «nombre: valor», partido si no cabe.
        case datos([DatoPresentado])
        /// Líneas de texto sueltas.
        case lineas([String])
        /// Líneas de texto en gris: las notas de una secuencia, los avisos, lo que se mueve en total.
        case apartes([String])
        /// El título de una parte de la sección: una secuencia, un paso de la conducción, una modulación.
        case subtitulo(String)
        /// Una tabla, una fila por elemento, con las columnas alineadas. Una fila de una sola celda en una tabla de
        /// varias columnas es la cabecera de un tramo (una modulación).
        case tabla([[String]])
        /// Una lista, `porFila` elementos en cada línea del SVG (en HTML, como quepan), con la clase de la lista.
        case lista([Elemento], porFila: Int, clase: String?)
        /// Los acordes de los grados, en columnas: el grado, el acorde y su función.
        case grados([(grado: String, acorde: String, funcion: String)])
        /// Lo que dicen las fuentes del carácter (en HTML, con sus palabras entre comillas), lo que mide un estudio y
        /// la sonoridad calculada.
        case caracter([Caracter], medidas: [MedidaDelAfecto], sonoridad: Sonoridad?)
        /// Un dibujo SVG, en `fraccion` del ancho de la sección (de lado a lado con 1).
        case dibujo(String, fraccion: Double)
        /// Varios dibujos con su título (o sin él, si está vacío), `porFila` en cada fila.
        case dibujos([(titulo: String, svg: String)], porFila: Int)

        /// Si no tiene nada que escribir.
        var vacia: Bool {
            switch self {
            case .datos(let datos): datos.isEmpty
            case .lineas(let lineas), .apartes(let lineas): lineas.isEmpty
            case .subtitulo(let texto): texto.isEmpty
            case .tabla(let filas): filas.isEmpty
            case .lista(let elementos, _, _): elementos.isEmpty
            case .grados(let grados): grados.isEmpty
            case .caracter(let caracter, let medidas, let sonoridad):
                caracter.isEmpty && medidas.isEmpty && sonoridad == nil
            case .dibujo(let svg, _): svg.isEmpty
            case .dibujos(let dibujos, _): dibujos.isEmpty
            }
        }
    }

    /// Una sección: su título (ninguno, si está vacío), sus piezas, su clase en HTML y las secciones que van a su
    /// derecha, en una columna de `anchoAlLado` (el reloj, al lado de las estadísticas). Una sección sin piezas, o con
    /// piezas vacías, no se escribe; si es la de la izquierda, las de su lado ocupan su sitio.
    struct Seccion {
        let titulo: String
        let piezas: [Pieza]
        var clase: String? = nil
        var alLado: [Seccion] = []
    }

    let titulo: String
    var subtitulos: [String] = []
    /// Las notas, debajo del título (en HTML, en una lista).
    var notas: [String] = []
    /// Los nombres en su idioma y su escritura: 陽音階 (Yō onkai).
    var originales: [NombreOriginalPresentado] = []
    /// Un dibujo a la derecha del título (en HTML, debajo): el pentagrama de un acorde.
    var dibujoDelEncabezado: String? = nil
    let secciones: [Seccion]

    /// El ancho de la columna de las secciones de al lado y del dibujo del encabezado.
    static let anchoAlLado = 170.0

    /// Las secciones que tienen algo, sin las piezas vacías.
    private var conAlgo: [Seccion] {
        func filtrada(_ seccion: Seccion) -> Seccion {
            Seccion(
                titulo: seccion.titulo, piezas: seccion.piezas.filter { !$0.vacia }, clase: seccion.clase,
                alLado: seccion.alLado.map(filtrada).filter { !$0.piezas.isEmpty })
        }
        return secciones.map(filtrada).filter { !$0.piezas.isEmpty || !$0.alLado.isEmpty }
    }

    // MARK: En SVG

    /// La hoja en SVG: el encabezado arriba y las secciones una debajo de otra. El alto es el que ocupa.
    func svg(en notacion: Notacion) -> String {
        let margen = Hoja.margen
        let util = Hoja.ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen + 22
        // A la derecha, el dibujo del encabezado; el texto, partido para que no se meta en él.
        var altoDelDibujo = 0.0
        if let dibujo = dibujoDelEncabezado {
            let lado = Self.anchoAlLado
            altoDelDibujo = Hoja.incrustar(dibujo, x: margen + util - lado, y: margen, ancho: lado, en: &cuerpo)
        }
        let anchoDelTexto = dibujoDelEncabezado == nil ? util : util - Self.anchoAlLado - 12
        cuerpo.append(Hoja.texto(titulo, x: margen, y: y, tamano: 22, negrita: true))
        y += 6
        let originales = originales.map { $0.texto + ($0.lectura.map { " (" + $0 + ")" } ?? "") }
        let debajo = [notas.joined(separator: " "), originales.joined(separator: " · ")] + subtitulos
        for subtitulo in debajo where !subtitulo.isEmpty {
            let caben = Int(Double(Hoja.caracteresPorLinea(anchoDelTexto)) * 0.85)
            for linea in Hoja.partir(subtitulo, caracteres: caben) {
                y += 17
                cuerpo.append(Hoja.texto(linea, x: margen, y: y, tamano: 13, color: "#555555"))
            }
        }
        y = max(y, margen + altoDelDibujo) + 12
        for seccion in conAlgo {
            let arriba = y
            var izquierda = y
            if !seccion.piezas.isEmpty {
                let ancho = seccion.alLado.isEmpty ? util : util - Self.anchoAlLado - 12
                escribir(seccion, x: margen, ancho: ancho, y: &izquierda, en: &cuerpo, notacion)
            }
            var derecha = arriba
            let x = seccion.piezas.isEmpty ? margen : margen + util - Self.anchoAlLado
            for alLado in seccion.alLado {
                escribir(alLado, x: x, ancho: Self.anchoAlLado, y: &derecha, en: &cuerpo, notacion)
            }
            y = max(izquierda, derecha)
        }
        return Hoja.hojaSVG(ancho: Hoja.ancho, alto: (y + margen).rounded(.up), cuerpo)
    }

    /// Una sección en SVG, desde `x` y en `ancho`: su título y sus piezas.
    private func escribir(
        _ seccion: Seccion, x: Double, ancho: Double, y: inout Double, en cuerpo: inout [String],
        _ notacion: Notacion
    ) {
        if !seccion.titulo.isEmpty {
            cuerpo.append(Hoja.texto(seccion.titulo, x: x, y: y + 12, tamano: 14, negrita: true))
            y += 32
        } else {
            y += 6
        }
        let caben = Hoja.caracteresPorLinea(ancho)
        func lineas(_ lineas: [String], color: String = "#222222") {
            for linea in lineas.flatMap({ Hoja.partir($0, caracteres: caben) }) {
                cuerpo.append(Hoja.texto(linea, x: x, y: y, tamano: 11, color: color))
                y += 16
            }
        }
        func datos(_ datos: [DatoPresentado]) {
            for dato in datos {
                for (i, linea) in Hoja.partir(dato.nombre + ": " + dato.valor, caracteres: caben).enumerated() {
                    // Las líneas que siguen a la primera, un poco metidas, para que se vea dónde empieza cada dato.
                    cuerpo.append(Hoja.texto(linea, x: x + (i == 0 ? 0 : 12), y: y, tamano: 11))
                    y += 16
                }
            }
        }
        for pieza in seccion.piezas {
            switch pieza {
            case .datos(let lista):
                datos(lista)
            case .caracter(let caracter, let medidas, let sonoridad):
                datos(Hoja.filasDelCaracter(caracter, medidas: medidas, sonoridad: sonoridad, en: notacion))
            case .lineas(let lista):
                lineas(lista)
            case .apartes(let lista):
                lineas(lista, color: "#555555")
            case .subtitulo(let texto):
                y += 4
                cuerpo.append(Hoja.texto(texto, x: x, y: y, tamano: 11, negrita: true))
                y += 15
            case .tabla(let filas):
                let columnas = filas.map(\.count).max() ?? 0
                // Las cabeceras de los tramos, que ocupan toda la fila, no cuentan para el ancho de las columnas.
                let medidas = filas.filter { $0.count > 1 || columnas == 1 }
                let anchos = (0..<columnas).map { c in
                    Double(medidas.map { c < $0.count ? $0[c].count : 0 }.max() ?? 0) * 6.2 + 14
                }
                for fila in filas {
                    if fila.count == 1 && columnas > 1 {
                        cuerpo.append(Hoja.texto(fila[0], x: x, y: y, tamano: 11, negrita: true, color: "#555555"))
                    } else {
                        var columna = x
                        for (c, celda) in fila.enumerated() {
                            cuerpo.append(Hoja.texto(celda, x: columna, y: y, tamano: 11, negrita: c == 0))
                            columna += anchos[c]
                        }
                    }
                    y += 16
                }
            case .lista(let elementos, let porFila, _):
                // En una lista de uno por línea, el texto tras una raya: «Sol mixolidio — Tensiones: La 9».
                let separador = porFila == 1 ? " — " : " "
                let escritos = elementos.map { elemento in
                    (elemento.resaltado ? "▸ " : "")
                        + [elemento.etiqueta, elemento.texto].compactMap { $0 }
                        .filter { !$0.isEmpty }.joined(separator: separador)
                }
                let filas = stride(from: 0, to: escritos.count, by: max(porFila, 1)).map {
                    escritos[$0..<min($0 + max(porFila, 1), escritos.count)].joined(separator: " · ")
                }
                lineas(filas)
            case .grados(let grados):
                let columna = ancho / Double(max(grados.count, 1))
                for (i, grado) in grados.enumerated() {
                    let izquierda = x + Double(i) * columna
                    cuerpo.append(Hoja.texto(grado.grado, x: izquierda, y: y, tamano: 12, negrita: true))
                    cuerpo.append(Hoja.texto(grado.acorde, x: izquierda, y: y + 16, tamano: 12))
                    cuerpo.append(Hoja.texto(grado.funcion, x: izquierda, y: y + 31, tamano: 9, color: "#666666"))
                }
                y += 48
            case .dibujo(let svg, let fraccion):
                // No más del doble de su ancho, como en HTML, para que un pentagrama corto no salga enorme.
                let natural = Hoja.anchoPropio(svg).map { 2 * $0 } ?? ancho
                y += Hoja.incrustar(svg, x: x, y: y - 6, ancho: min(ancho * fraccion, natural), en: &cuerpo) + 4
            case .dibujos(let dibujos, let porFila):
                let separacion = 12.0
                let cada = (ancho - separacion * Double(porFila - 1)) / Double(porFila)
                var altoDeLaFila = 0.0
                for (i, dibujo) in dibujos.enumerated() {
                    let izquierda = x + Double(i % porFila) * (cada + separacion)
                    cuerpo.append(Hoja.texto(dibujo.titulo, x: izquierda, y: y + 2, tamano: 10, color: "#555555"))
                    let alto = Hoja.incrustar(dibujo.svg, x: izquierda, y: y + 6, ancho: cada, en: &cuerpo) + 18
                    altoDeLaFila = max(altoDeLaFila, alto)
                    if i % porFila == porFila - 1 || i == dibujos.count - 1 {
                        y += altoDeLaFila
                        altoDeLaFila = 0
                    }
                }
            }
        }
        y += 10
    }

    // MARK: En HTML

    /// La hoja como página HTML: los datos en listas de definiciones, las tablas en tablas, las listas en listas y los
    /// dibujos como SVG dentro; las secciones de al lado, en una segunda columna.
    func html(en notacion: Notacion) -> String {
        var cabecera = "<header><h1>" + Hoja.html(titulo) + "</h1>"
        if !originales.isEmpty {
            cabecera +=
                "<p class=\"originales\">" + originales.map(Hoja.nombreOriginalHTML).joined(separator: " · ") + "</p>"
        }
        if !notas.isEmpty {
            cabecera += "<ul class=\"notas\">" + notas.map { "<li>" + Hoja.html($0) + "</li>" }.joined() + "</ul>"
        }
        cabecera += subtitulos.filter { !$0.isEmpty }.map { "<p class=\"sub\">" + Hoja.html($0) + "</p>" }.joined()
        var cuerpo = [cabecera + "</header>"]
        if let dibujo = dibujoDelEncabezado { cuerpo.append(Hoja.figura(dibujo, clase: "pequena")) }
        for seccion in conAlgo {
            if seccion.alLado.isEmpty {
                cuerpo.append(html(seccion, en: notacion))
            } else {
                let columnas = (seccion.piezas.isEmpty ? [] : [seccion]) + seccion.alLado
                cuerpo.append(
                    "<div class=\"columnas\">" + columnas.map { html($0, en: notacion) }.joined() + "</div>")
            }
        }
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + titulo, idioma: notacion.textos.codigo, cuerpo)
    }

    /// Una sección en HTML, con su título y su clase.
    private func html(_ seccion: Seccion, en notacion: Notacion) -> String {
        let contenido = seccion.piezas.map { pieza -> String in
            switch pieza {
            case .datos(let datos):
                let filas = datos.map {
                    "<div><dt>" + Hoja.html($0.nombre) + "</dt><dd>" + Hoja.html($0.valor) + "</dd></div>"
                }
                return "<dl>" + filas.joined() + "</dl>"
            case .caracter(let caracter, let medidas, let sonoridad):
                return Hoja.caracterHTML(caracter, medidas: medidas, sonoridad: sonoridad, en: notacion)
            case .lineas(let lineas):
                return lineas.map { "<p>" + Hoja.html($0) + "</p>" }.joined()
            case .apartes(let lineas):
                return lineas.map { "<p class=\"sub\">" + Hoja.html($0) + "</p>" }.joined()
            case .subtitulo(let texto):
                return "<h3>" + Hoja.html(texto) + "</h3>"
            case .tabla(let filas):
                let columnas = filas.map(\.count).max() ?? 0
                return Hoja.tablaHTML(filas.map { (celdas: $0, clase: $0.count == 1 && columnas > 1 ? "tramo" : nil) })
            case .lista(let elementos, _, let clase):
                let filas = elementos.map { elemento in
                    let texto =
                        (elemento.etiqueta.map { "<span class=\"etiqueta\">" + Hoja.html($0) + "</span> " } ?? "")
                        + Hoja.html(elemento.texto)
                    return elemento.resaltado
                        ? "<li aria-current=\"true\"><strong>" + texto + "</strong></li>" : "<li>" + texto + "</li>"
                }
                return "<ul" + (clase.map { " class=\"" + $0 + "\"" } ?? "") + ">" + filas.joined() + "</ul>"
            case .grados(let grados):
                let filas = grados.map {
                    "<li><strong>" + Hoja.html($0.grado) + "</strong><span>" + Hoja.html($0.acorde) + "</span><small>"
                        + Hoja.html($0.funcion) + "</small></li>"
                }
                return "<ul class=\"grados\">" + filas.joined() + "</ul>"
            case .dibujo(let svg, let fraccion):
                return Hoja.figura(svg, clase: fraccion < 1 ? "pequena" : "ancha")
            case .dibujos(let dibujos, let porFila):
                let figuras = dibujos.map {
                    ($0.titulo.isEmpty ? "" : "<h3>" + Hoja.html($0.titulo) + "</h3>")
                        + Hoja.figura($0.svg, clase: porFila == 1 ? "ancha" : "dibujo")
                }
                guard porFila > 1 else { return figuras.joined() }
                let clase = porFila > 2 ? "digitaciones" : "teclados"
                return "<div class=\"" + clase + "\">" + figuras.map { "<div>" + $0 + "</div>" }.joined() + "</div>"
            }
        }
        return Hoja.seccionHTML(seccion.titulo, contenido.joined(), clase: seccion.clase)
    }
}
