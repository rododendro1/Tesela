import Armonia
import Foundation

// MARK: - Una hoja hecha de secciones

/// Una hoja de estudio hecha de secciones, que se escribe igual en SVG, del ancho de un A4 para imprimir, y en HTML:
/// la base de las hojas de `HojaDeEstudio` (la de un ritmo, una progresión con nombre, una serie, un arpegio o un
/// instrumento). Cada sección tiene su título y sus piezas: datos («nombre: valor»), líneas de texto, tablas y dibujos.
struct HojaCompuesta {
    /// Lo que va dentro de una sección.
    enum Pieza {
        /// Un dato por línea, «nombre: valor», partido si no cabe.
        case datos([DatoPresentado])
        /// Líneas de texto sueltas.
        case lineas([String])
        /// Una tabla, una fila por elemento, con las columnas alineadas.
        case tabla([[String]])
        /// Un dibujo SVG, en `fraccion` del ancho de la hoja (de lado a lado con 1).
        case dibujo(String, fraccion: Double)
        /// Varios dibujos con su título, `porFila` en cada fila.
        case dibujos([(titulo: String, svg: String)], porFila: Int)
    }

    /// Una sección: su título y sus piezas. Una sección sin piezas, o con piezas vacías, no se escribe.
    struct Seccion {
        let titulo: String
        let piezas: [Pieza]
    }

    let titulo: String
    let subtitulos: [String]
    let secciones: [Seccion]

    private typealias Hoja = PresentacionDeEstudioDeEscala

    /// Las secciones que tienen algo.
    private var conAlgo: [Seccion] {
        secciones.compactMap { seccion in
            let piezas = seccion.piezas.filter { pieza in
                switch pieza {
                case .datos(let datos): !datos.isEmpty
                case .lineas(let lineas): !lineas.isEmpty
                case .tabla(let filas): !filas.isEmpty
                case .dibujo(let svg, _): !svg.isEmpty
                case .dibujos(let dibujos, _): !dibujos.isEmpty
                }
            }
            return piezas.isEmpty ? nil : Seccion(titulo: seccion.titulo, piezas: piezas)
        }
    }

    /// La hoja en SVG: el título y los subtítulos arriba y las secciones una debajo de otra. El alto es el que ocupa.
    func svg() -> String {
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen + 22
        cuerpo.append(Hoja.texto(titulo, x: margen, y: y, tamano: 22, negrita: true))
        y += 6
        for subtitulo in subtitulos where !subtitulo.isEmpty {
            for linea in Hoja.partir(subtitulo, caracteres: Int(Double(Hoja.caracteresPorLinea(util)) * 0.85)) {
                y += 17
                cuerpo.append(Hoja.texto(linea, x: margen, y: y, tamano: 13, color: "#555555"))
            }
        }
        y += 12
        for seccion in conAlgo {
            cuerpo.append(Hoja.texto(seccion.titulo, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            for pieza in seccion.piezas {
                switch pieza {
                case .datos(let datos):
                    for dato in datos {
                        let partidas = Hoja.partir(
                            dato.nombre + ": " + dato.valor, caracteres: Hoja.caracteresPorLinea(util))
                        for (i, linea) in partidas.enumerated() {
                            cuerpo.append(Hoja.texto(linea, x: margen + (i == 0 ? 0 : 12), y: y, tamano: 11))
                            y += 16
                        }
                    }
                case .lineas(let lineas):
                    for linea in lineas.flatMap({ Hoja.partir($0, caracteres: Hoja.caracteresPorLinea(util)) }) {
                        cuerpo.append(Hoja.texto(linea, x: margen, y: y, tamano: 11))
                        y += 16
                    }
                case .tabla(let filas):
                    let columnas = filas.map(\.count).max() ?? 0
                    let anchos = (0..<columnas).map { c in
                        Double(filas.map { c < $0.count ? $0[c].count : 0 }.max() ?? 0) * 6.2 + 14
                    }
                    for fila in filas {
                        var x = margen
                        for (c, celda) in fila.enumerated() {
                            cuerpo.append(Hoja.texto(celda, x: x, y: y, tamano: 11, negrita: c == 0))
                            x += anchos[c]
                        }
                        y += 16
                    }
                case .dibujo(let svg, let fraccion):
                    y += Hoja.incrustar(svg, x: margen, y: y - 6, ancho: util * fraccion, en: &cuerpo) + 4
                case .dibujos(let dibujos, let porFila):
                    let separacion = 12.0
                    let cada = (util - separacion * Double(porFila - 1)) / Double(porFila)
                    var altoDeLaFila = 0.0
                    for (i, dibujo) in dibujos.enumerated() {
                        let x = margen + Double(i % porFila) * (cada + separacion)
                        cuerpo.append(Hoja.texto(dibujo.titulo, x: x, y: y + 2, tamano: 10, color: "#555555"))
                        let alto = Hoja.incrustar(dibujo.svg, x: x, y: y + 6, ancho: cada, en: &cuerpo) + 18
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
        return Hoja.hojaSVG(ancho: ancho, alto: (y + margen).rounded(.up), cuerpo)
    }

    /// La hoja como página HTML: los datos en listas de definiciones, las tablas en tablas y los dibujos como SVG
    /// dentro.
    func html(en notacion: Notacion) -> String {
        var cuerpo = [Hoja.encabezadoHTML(titulo, subtitulos)]
        for seccion in conAlgo {
            let contenido = seccion.piezas.map { pieza -> String in
                switch pieza {
                case .datos(let datos):
                    let filas = datos.map {
                        "<div><dt>" + Hoja.html($0.nombre) + "</dt><dd>" + Hoja.html($0.valor) + "</dd></div>"
                    }
                    return "<dl>" + filas.joined() + "</dl>"
                case .lineas(let lineas):
                    return lineas.map { "<p>" + Hoja.html($0) + "</p>" }.joined()
                case .tabla(let filas):
                    return Hoja.tablaHTML(filas.map { (celdas: $0, clase: nil) })
                case .dibujo(let svg, let fraccion):
                    return Hoja.figura(svg, clase: fraccion < 1 ? "pequena" : "ancha")
                case .dibujos(let dibujos, let porFila):
                    let figuras = dibujos.map {
                        "<div><h3>" + Hoja.html($0.titulo) + "</h3>" + Hoja.figura($0.svg, clase: "dibujo") + "</div>"
                    }
                    let clase = porFila > 2 ? "digitaciones" : "teclados"
                    return "<div class=\"" + clase + "\">" + figuras.joined() + "</div>"
                }
            }
            cuerpo.append(Hoja.seccionHTML(seccion.titulo, contenido.joined()))
        }
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + titulo, idioma: notacion.textos.codigo, cuerpo)
    }
}
