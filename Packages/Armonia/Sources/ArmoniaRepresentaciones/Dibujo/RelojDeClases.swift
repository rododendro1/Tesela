import ArmoniaNucleo
import Foundation

/// Un conjunto de clases de altura (las notas de una escala o de un acorde) dibujado en un reloj de doce horas: el
/// círculo cromático (Do arriba, de semitono en semitono) o el de quintas (Do, Sol, Re…). Las notas del conjunto se
/// unen en un polígono, que deja ver la forma de la escala: una escala simétrica da un polígono que gira sobre sí
/// mismo, y la diatónica, siete horas seguidas en el de quintas.
///
///     let reloj = RelojDeClases(clases: [0, 2, 4, 5, 7, 9, 11], tonica: 0, orden: .quintas)
///     reloj.horas   // [0, 1, 2, 3, 4, 5, 11]: de Fa a Si, seguidas
///     let svg = reloj.svg(rotulos: [0: "Do", 7: "Sol"], titulo: "Do mayor")
public struct RelojDeClases: Hashable, Sendable {
    /// Cómo se reparten las doce clases por las horas del reloj.
    public enum Orden: String, Hashable, Sendable, CaseIterable {
        /// De semitono en semitono: Do, Do♯, Re…
        case cromatico
        /// De quinta en quinta: Do, Sol, Re…
        case quintas
    }

    /// Las clases del conjunto, de 0 (Do) a 11 (Si).
    public let clases: Set<Int>
    /// La que lleva el borde naranja (la tónica de la escala, la fundamental del acorde), si hay.
    public let tonica: Int?
    public let orden: Orden

    public init(clases: [Int], tonica: Int? = nil, orden: Orden = .cromatico) {
        self.clases = Set(clases.map { modulo($0, 12) })
        self.tonica = tonica.map { modulo($0, 12) }
        self.orden = orden
    }

    /// La hora del reloj en que cae una clase: la misma en el cromático; en el de quintas, Sol (7) a la una.
    public static func hora(de clase: Int, en orden: Orden) -> Int {
        orden == .cromatico ? modulo(clase, 12) : modulo(clase * 7, 12)
    }

    /// Las horas de las notas del conjunto, ordenadas.
    public var horas: [Int] { clases.map { RelojDeClases.hora(de: $0, en: orden) }.sorted() }

    // MARK: Dibujo

    static let lado = 260.0
    static let radio = 92.0
    static let altoDelTitulo = 24.0

    /// El punto de una hora, con las doce arriba y en el sentido de las agujas.
    static func punto(hora: Int, radio: Double, centro: (x: Double, y: Double)) -> (x: Double, y: Double) {
        let angulo = (Double(hora) / 12 * 2 - 0.5) * Double.pi
        return (centro.x + radio * cos(angulo), centro.y + radio * sin(angulo))
    }

    /// El reloj en SVG: las doce horas con su rótulo (el nombre de la nota, o su número si no se da), el polígono de
    /// las notas del conjunto y, encima, el título, si lo hay.
    public func svg(rotulos: [Int: String] = [:], titulo: String = "") -> String {
        let arriba = titulo.isEmpty ? 0 : RelojDeClases.altoDelTitulo
        let ancho = RelojDeClases.lado
        let alto = RelojDeClases.lado + arriba
        let centro = (x: ancho / 2, y: arriba + RelojDeClases.lado / 2)
        var svg =
            ElementoSVG("svg").con("xmlns", "http://www.w3.org/2000/svg")
            .con("viewBox", "0 0 \(NumerosSVG.unDecimal.texto(ancho)) \(NumerosSVG.unDecimal.texto(alto))")
            .con("width", ancho).con("height", alto).con("font-family", "sans-serif").apertura + "\n"
        if !titulo.isEmpty { svg += "  " + ElementoSVG("title").conTexto(titulo) + "\n" }
        svg += "  " + ElementoSVG("rect").con("width", ancho).con("height", alto).con("fill", "#ffffff").vacio + "\n"
        if !titulo.isEmpty {
            svg +=
                "  "
                + ElementoSVG("text").con("x", 8.0).con("y", arriba / 2).con("dominant-baseline", "central")
                .con("font-size", 14.0).con("font-weight", "600").con("fill", "#222222").conTexto(titulo) + "\n"
        }
        svg +=
            "  "
            + ElementoSVG("circle").con("cx", centro.x).con("cy", centro.y).con("r", RelojDeClases.radio)
            .con("fill", "none").con("stroke", "#cccccc").vacio + "\n"
        // El polígono, de hora en hora, debajo de los puntos.
        let vertices = horas.map { RelojDeClases.punto(hora: $0, radio: RelojDeClases.radio, centro: centro) }
        if vertices.count >= 2 {
            svg +=
                "  "
                + ElementoSVG("polygon").con("points", puntos: vertices).con("fill", DibujoSVG.Color.nota)
                .con("fill-opacity", "0.18").con("stroke", DibujoSVG.Color.nota).con("stroke-width", 2.0).vacio
                + "\n"
        }
        for clase in 0..<12 {
            let hora = RelojDeClases.hora(de: clase, en: orden)
            let punto = RelojDeClases.punto(hora: hora, radio: RelojDeClases.radio, centro: centro)
            let dentro = clases.contains(clase)
            let primera = tonica == clase
            svg +=
                "  "
                + ElementoSVG("circle").con("cx", punto.x).con("cy", punto.y).con("r", dentro ? 7.0 : 3.5)
                .con("fill", dentro ? DibujoSVG.Color.nota : "#bbbbbb")
                .con("stroke", primera ? DibujoSVG.Color.primera : "#ffffff").con("stroke-width", primera ? 3.0 : 1.0)
                .vacio + "\n"
            let rotulo = RelojDeClases.punto(hora: hora, radio: RelojDeClases.radio + 22, centro: centro)
            svg +=
                "  "
                + ElementoSVG("text").con("x", rotulo.x).con("y", rotulo.y).con("text-anchor", "middle")
                .con("dominant-baseline", "central").con("font-size", 12.0)
                .con("font-weight", dentro ? "600" : "400").con("fill", dentro ? "#222222" : "#999999")
                .conTexto(rotulos[clase] ?? String(clase)) + "\n"
        }
        return svg + "</svg>\n"
    }
}
