import Hexagonos

/// Dónde se ha tocado un dibujo SVG que `VistaSVG` muestra entero y centrado en su espacio (como hace un
/// navegador con `preserveAspectRatio` por defecto). No usa SwiftUI, así que se prueba también en Linux.
enum PresentacionSVG {
    /// El `viewBox` del SVG: x, y, ancho y alto. `nil` si no lo tiene o está mal escrito.
    static func caja(de svg: String) -> (x: Double, y: Double, ancho: Double, alto: Double)? {
        guard let inicio = svg.range(of: "viewBox=\""),
            let fin = svg[inicio.upperBound...].firstIndex(of: "\"")
        else { return nil }
        let numeros = svg[inicio.upperBound..<fin]
            .split(whereSeparator: { $0 == " " || $0 == "," })
            .compactMap { Double($0) }
        guard numeros.count == 4, numeros[2] > 0, numeros[3] > 0 else { return nil }
        return (numeros[0], numeros[1], numeros[2], numeros[3])
    }

    /// El punto del dibujo, en las coordenadas de su `viewBox`, que hay bajo `toque` en una vista de
    /// `ancho × alto`. `nil` si el SVG no tiene `viewBox` o el toque cae en el margen que queda alrededor.
    static func punto(en toque: Punto, de svg: String, ancho: Double, alto: Double) -> Punto? {
        guard let marco = caja(de: svg), ancho > 0, alto > 0 else { return nil }
        let escala = min(ancho / marco.ancho, alto / marco.alto)
        let x = marco.x + (toque.x - (ancho - marco.ancho * escala) / 2) / escala
        let y = marco.y + (toque.y - (alto - marco.alto * escala) / 2) / escala
        guard (marco.x...(marco.x + marco.ancho)).contains(x), (marco.y...(marco.y + marco.alto)).contains(y) else {
            return nil
        }
        return Punto(x: x, y: y)
    }
}
