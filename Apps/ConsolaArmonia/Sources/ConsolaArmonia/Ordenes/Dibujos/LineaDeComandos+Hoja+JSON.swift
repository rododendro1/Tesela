import Armonia
import ExposicionArmonia
import Foundation

// MARK: - La hoja de estudio en JSON, para el servidor MCP

extension LineaDeComandos {
    /// `hoja … --json`: la misma hoja que da `hoja …`, en SVG y en HTML a la vez, con su título, sus secciones y el
    /// número de páginas A4 que ocupa al imprimirla. Así el servidor MCP la puede dar entera, para guardarla o
    /// enseñarla sin pedirla dos veces.
    static func hojaJSON(_ textos: [String], _ notacion: Notacion) throws -> HojaPresentadaJSON {
        // El formato lo elige el JSON: lleva los dos.
        var argumentos = Argumentos(textos)
        _ = try argumentos.pideElFormato("html")
        let base = argumentos.restantes
        let svg = try hoja(base, notacion).salida
        let html = try hoja(base + ["--formato", "html"], notacion).salida
        return HojaPresentadaJSON(svg: svg, html: html)
    }
}

/// Lo que da `hoja … --json`.
struct HojaPresentadaJSON: Encodable, Sendable {
    /// El título de la página HTML: «Hoja de estudio · Sol7».
    let titulo: String
    /// Los títulos de sus secciones, en orden: «Pentagrama», «Origen», «Estadísticas»…
    let secciones: [String]
    /// Las páginas A4 que ocupa en SVG (y en el PDF de `grabar hoja`).
    let paginas: Int
    /// La hoja en SVG, para imprimir.
    let svg: String
    /// La hoja como página HTML, que se adapta a la pantalla y sigue el modo oscuro.
    let html: String

    init(svg: String, html: String) {
        self.svg = svg
        self.html = html
        paginas = HojaDeEstudio.paginas(deUnSVG: svg).count
        titulo = Self.textos(de: "title", en: html).first ?? ""
        secciones = Self.textos(de: "h2", en: html)
    }

    /// El texto de cada `<etiqueta …>…</etiqueta>` del HTML, sin las etiquetas de dentro y con las entidades de XML
    /// escritas como caracteres; los `<title>` de dentro de los dibujos no cuentan, porque solo se busca hasta el
    /// primer `<svg` en el título.
    private static func textos(de etiqueta: String, en html: String) -> [String] {
        var resultado: [String] = []
        var resto = html[...]
        if etiqueta == "title", let dibujo = resto.range(of: "<svg") { resto = resto[..<dibujo.lowerBound] }
        while let apertura = resto.range(of: "<" + etiqueta),
            let fin = resto[apertura.upperBound...].range(of: ">"),
            let cierre = resto[fin.upperBound...].range(of: "</" + etiqueta + ">")
        {
            let dentro = String(resto[fin.upperBound..<cierre.lowerBound])
            resultado.append(desescapar(sinEtiquetas(dentro)).trimmingCharacters(in: .whitespacesAndNewlines))
            resto = resto[cierre.upperBound...]
        }
        return resultado
    }

    private static func sinEtiquetas(_ texto: String) -> String {
        var limpio = ""
        var dentro = false
        for caracter in texto {
            if caracter == "<" {
                dentro = true
            } else if caracter == ">" {
                dentro = false
            } else if !dentro {
                limpio.append(caracter)
            }
        }
        return limpio
    }

    private static func desescapar(_ texto: String) -> String {
        texto.replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&amp;", with: "&")
    }
}
