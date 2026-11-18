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

    /// Cuántos caracteres de 11 puntos caben en una línea de ese ancho, por lo que ocupa uno de media en Helvetica.
    static func caracteresPorLinea(_ ancho: Double) -> Int { max(20, Int(ancho / 5.6)) }

    /// El texto en líneas de `caracteres` como mucho, partido entre palabras (una palabra más larga va sola).
    ///
    ///     Hoja.partir("Re Mi Fa Sol", caracteres: 6)   // ["Re Mi", "Fa Sol"]
    static func partir(_ contenido: String, caracteres: Int) -> [String] {
        var lineas: [String] = []
        var actual = ""
        for palabra in contenido.split(separator: " ") {
            if actual.isEmpty {
                actual = String(palabra)
            } else if actual.count + 1 + palabra.count <= caracteres {
                actual += " " + palabra
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
    /// cada hoja de estudio en SVG.
    static func hojaSVG(ancho: Double, alto: Double, _ cuerpo: [String]) -> String {
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
            + "viewBox=\"0 0 \(numero(ancho)) \(numero(alto))\" font-family=\"Helvetica, Arial, sans-serif\">"
        let fondo = "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }

    /// Con un decimal como mucho: «40», «12.5».
    static func numero(_ valor: Double) -> String {
        Redondeo.texto(valor, decimales: 1)
    }
}
