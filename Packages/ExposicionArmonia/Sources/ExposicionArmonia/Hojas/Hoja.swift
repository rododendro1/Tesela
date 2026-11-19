import Armonia
import Foundation

// MARK: - Las piezas de las hojas

/// Las piezas con que se escriben las hojas de estudio, en SVG y en HTML: los textos, los dibujos incrustados, la
/// hoja entera, las secciones, las tablas, las figuras y la página con su estilo. Las usan `HojaCompuesta` y los
/// dibujos de las hojas (el reloj, el teclado, el mástil, las comparaciones…).
enum Hoja {
    /// Ancho de la hoja (el de un A4 en puntos) y su margen.
    static let ancho = 595.0
    static let margen = 40.0
    /// El alto de una página A4, en puntos.
    static let altoDeLaPagina = 842.0

    /// Lo que ocupa cada carácter imprimible de ASCII (del espacio a «~») en Helvetica, en milésimas del tamaño: las
    /// métricas de la fuente (su AFM).
    private static let anchosDeHelvetica: [Int] = [
        278, 278, 355, 556, 556, 889, 667, 191, 333, 333, 389, 584, 278, 333, 278, 278,
        556, 556, 556, 556, 556, 556, 556, 556, 556, 556, 278, 278, 584, 584, 584, 556,
        1015, 667, 667, 722, 722, 667, 611, 778, 722, 278, 500, 667, 556, 833, 722, 778,
        667, 778, 722, 667, 611, 722, 667, 944, 667, 667, 611, 278, 278, 278, 469, 556,
        333, 556, 556, 500, 556, 556, 278, 556, 556, 222, 222, 500, 222, 833, 556, 556,
        556, 556, 333, 500, 278, 556, 500, 722, 500, 500, 500, 334, 260, 334, 584,
    ]

    /// Lo que ocupa un texto de `tamano` puntos en Helvetica (un poco más en negrita), para partirlo y alinear las
    /// columnas: cada letra con su ancho (una acentuada, como la suya sin acento); las alteraciones, las flechas y
    /// las rayas, con el suyo, y la escritura de Asia oriental, a cuadratín.
    ///
    ///     Hoja.anchoDelTexto("Re", tamano: 10)   // 12.78
    static func anchoDelTexto(_ contenido: String, tamano: Double, negrita: Bool = false) -> Double {
        var milesimas = 0
        for escalar in contenido.unicodeScalars {
            milesimas += anchoDelCaracter(escalar)
        }
        return Double(milesimas) * tamano / 1000 * (negrita ? 1.07 : 1)
    }

    /// Lo que ocupa un carácter, en milésimas del tamaño.
    private static func anchoDelCaracter(_ escalar: Unicode.Scalar) -> Int {
        let valor = escalar.value
        if (32...126).contains(valor) { return anchosDeHelvetica[Int(valor) - 32] }
        switch valor {
        case 0x300...0x36F, 0x200B...0x200F: return 0 // Los acentos que se combinan y los invisibles.
        case 0xB7, 0x2022: return 278 // ·, •
        case 0x2013: return 556 // –
        case 0x2014, 0x2192, 0x2190, 0x2194, 0x2026: return 1000 // —, →, ←, ↔, …
        case 0x266D...0x266F, 0x1D12A...0x1D12B, 0x1D10B...0x1D10C: return 600 // ♭ ♮ ♯, 𝄪 𝄫
        case 0x2070...0x209F: return 400 // Los superíndices y los subíndices de las octavas.
        case 0x1100...0x11FF, 0x2E80...0x9FFF, 0xAC00...0xD7AF, 0xF900...0xFAFF, 0xFF00...0xFF60: return 1000
        default: break
        }
        // Una letra acentuada, como la suya sin acento: «é» como «e».
        if let base = String(escalar).decomposedStringWithCanonicalMapping.unicodeScalars.first,
            base != escalar, (32...126).contains(base.value)
        {
            return anchosDeHelvetica[Int(base.value) - 32]
        }
        return 556
    }

    /// El texto en líneas que no pasan de `ancho` puntos con letra de `tamano`, partido entre palabras (una palabra
    /// más larga va sola).
    ///
    ///     Hoja.partir("Re Mi Fa Sol", ancho: 30, tamano: 10)   // ["Re Mi", "Fa Sol"]
    static func partir(_ contenido: String, ancho: Double, tamano: Double, negrita: Bool = false) -> [String] {
        var lineas: [String] = []
        var actual = ""
        for palabra in contenido.split(separator: " ") {
            let junta = actual + " " + palabra
            if actual.isEmpty {
                actual = String(palabra)
            } else if anchoDelTexto(junta, tamano: tamano, negrita: negrita) <= ancho {
                actual = junta
            } else {
                lineas.append(actual)
                actual = String(palabra)
            }
        }
        if !actual.isEmpty { lineas.append(actual) }
        return lineas
    }

    /// Un texto de la hoja en `x` e `y` (su línea de base), de `tamano` puntos.
    static func texto(
        _ contenido: String, x: Double, y: Double, tamano: Double, negrita: Bool = false, color: String = "#222222"
    ) -> String {
        "<text x=\"\(numero(x))\" y=\"\(numero(y))\" font-size=\"\(numero(tamano))\" fill=\"\(color)\""
            + (negrita ? " font-weight=\"bold\"" : "") + ">" + EscrituraXML.escapar(contenido) + "</text>"
    }

    /// Mete un SVG dentro de la hoja, en `x`, `y` y con ese ancho, como un `<svg>` anidado con su `viewBox`; da el
    /// alto que ocupa (0 si no se puede leer).
    static func incrustar(_ svg: String, x: Double, y: Double, ancho: Double, en cuerpo: inout [String]) -> Double {
        guard let raiz = svg.range(of: "<svg"),
            let finDeLaRaiz = svg[raiz.upperBound...].firstIndex(of: ">"),
            let cierre = svg.range(of: "</svg>", options: .backwards),
            let caja = cajaDeVision(svg)
        else { return 0 }
        let alto = ancho * caja.alto / caja.ancho
        let dentro = svg[svg.index(after: finDeLaRaiz)..<cierre.lowerBound]
        cuerpo.append(
            "<svg x=\"\(numero(x))\" y=\"\(numero(y))\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
                + "viewBox=\"\(caja.texto)\">" + dentro + "</svg>")
        return alto
    }

    /// El `viewBox` de un SVG: su texto, su ancho y su alto.
    static func cajaDeVision(_ svg: String) -> (texto: String, ancho: Double, alto: Double)? {
        guard let inicio = svg.range(of: "viewBox=\""),
            let fin = svg[inicio.upperBound...].firstIndex(of: "\"")
        else { return nil }
        let texto = String(svg[inicio.upperBound..<fin])
        let numeros = texto.split(whereSeparator: { $0 == " " || $0 == "," }).compactMap { Double($0) }
        guard numeros.count == 4, numeros[2] > 0, numeros[3] > 0 else { return nil }
        return (texto, numeros[2], numeros[3])
    }

    /// El ancho que dice tener un SVG en su atributo `width` (el de un pentagrama, por ejemplo); `nil` si no lo dice.
    static func anchoPropio(_ svg: String) -> Double? {
        guard let raiz = svg.range(of: "<svg"), let cierre = svg[raiz.upperBound...].firstIndex(of: ">"),
            let atributo = svg[raiz.upperBound..<cierre].range(of: " width=\""),
            let fin = svg[atributo.upperBound...].firstIndex(of: "\""),
            let ancho = Double(svg[atributo.upperBound..<fin]), ancho > 0
        else { return nil }
        return ancho
    }

    /// Un SVG de `ancho` × `alto` puntos con fondo blanco y `cuerpo` dentro, una línea por elemento: lo que acaba
    /// cada hoja de estudio en SVG. Con `paginas`, la raíz dice en `data-paginas` cuántas páginas A4 lleva.
    static func hojaSVG(ancho: Double, alto: Double, _ cuerpo: [String], paginas: Int? = nil) -> String {
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
            + "viewBox=\"0 0 \(numero(ancho)) \(numero(alto))\" font-family=\"Helvetica, Arial, sans-serif\""
            + (paginas.map { " data-paginas=\"\($0)\"" } ?? "") + ">"
        // El fondo, con su tamaño, para que siga ahí al recortar una página con otro `viewBox`.
        let fondo = "<rect width=\"\(numero(ancho))\" height=\"\(numero(alto))\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }

    /// Con un decimal como mucho: «40», «12.5».
    static func numero(_ valor: Double) -> String {
        Redondeo.texto(valor, decimales: 1)
    }
}
