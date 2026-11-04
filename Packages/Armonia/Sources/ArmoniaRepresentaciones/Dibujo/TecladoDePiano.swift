import ArmoniaNucleo
import Foundation

/// Un trozo de teclado de piano, de una tecla blanca a otra, para dibujar en SVG las notas de una escala o de un
/// acorde y, si se dan, los dedos con que se tocan.
///
///     let teclado = TecladoDePiano(cubriendo: Escala(.do).alturas(octava: 4))
///     teclado.desde...teclado.hasta   // 60...72: de Do4 a Do5
///     let svg = teclado.svg(marcadas: [60: "1", 62: "2", 64: "3"], opciones: .init(titulo: "Do mayor"))
public struct TecladoDePiano: Hashable, Sendable {
    /// La tecla blanca más grave y la más aguda, en MIDI.
    public let desde: Int
    public let hasta: Int

    /// De la tecla blanca más cercana a `desde` por abajo a la más cercana a `hasta` por arriba.
    public init(desde: Int, hasta: Int) {
        var desde = desde
        var hasta = max(desde, hasta)
        if TecladoDePiano.esNegra(desde) { desde -= 1 }
        if TecladoDePiano.esNegra(hasta) { hasta += 1 }
        self.desde = desde
        self.hasta = hasta
    }

    /// Un teclado que abarca todas las alturas dadas; una octava desde el Do central si no se da ninguna.
    public init(cubriendo alturas: [Altura]) {
        let midis = alturas.map(\.midi)
        self.init(desde: midis.min() ?? 60, hasta: midis.max() ?? 72)
    }

    /// Si la tecla es negra: Do♯, Re♯, Fa♯, Sol♯ y La♯.
    public static func esNegra(_ midi: Int) -> Bool { [1, 3, 6, 8, 10].contains(modulo(midi, 12)) }

    /// Las teclas blancas, de la grave a la aguda.
    public var blancas: [Int] { (desde...hasta).filter { !TecladoDePiano.esNegra($0) } }

    /// Las teclas negras entre la primera blanca y la última.
    public var negras: [Int] { (desde...hasta).filter(TecladoDePiano.esNegra) }

    // MARK: Medidas

    static let anchoDeBlanca = 24.0
    static let altoDeBlanca = 100.0
    static let anchoDeNegra = 14.0
    static let altoDeNegra = 62.0
    static let margen = 8.0
    static let altoDelTitulo = 24.0

    /// Dónde empieza una tecla, desde el borde izquierdo del teclado.
    func x(de midi: Int) -> Double {
        let anteriores = Double((desde..<midi).filter { !TecladoDePiano.esNegra($0) }.count)
        guard TecladoDePiano.esNegra(midi) else { return anteriores * TecladoDePiano.anchoDeBlanca }
        return anteriores * TecladoDePiano.anchoDeBlanca - TecladoDePiano.anchoDeNegra / 2
    }

    // MARK: Dibujo

    /// El teclado en SVG. Las teclas `marcadas` llevan un círculo azul, con su rótulo (el dedo, el grado) o, si no lo
    /// tiene, el nombre de la nota en `opciones.notacion`, como se marcó (sin él con `nombresDeLasNotas` en `false`);
    /// las de `primeras` (la tónica, la fundamental), con el borde naranja. Encima, el título de `opciones`, si lo hay;
    /// `opciones.escala` cambia el tamaño.
    public func svg(
        marcadas: MarcasDeDiagrama = [], primeras: Set<Int> = [], opciones: OpcionesDeDiagrama = OpcionesDeDiagrama()
    ) -> String {
        let titulo = opciones.titulo ?? ""
        let alto = TecladoDePiano.altoDeBlanca
        let ancho = Double(blancas.count) * TecladoDePiano.anchoDeBlanca
        let margen = TecladoDePiano.margen
        let arriba = titulo.isEmpty ? 0 : TecladoDePiano.altoDelTitulo
        let total = (ancho + 2 * margen, alto + 2 * margen + arriba)
        var svg =
            ElementoSVG("svg").con("xmlns", "http://www.w3.org/2000/svg")
            .con("viewBox", "0 0 \(NumerosSVG.unDecimal.texto(total.0)) \(NumerosSVG.unDecimal.texto(total.1))")
            .con("width", total.0 * opciones.escala).con("height", total.1 * opciones.escala)
            .con("font-family", "sans-serif").apertura + "\n"
        if !titulo.isEmpty { svg += "  " + ElementoSVG("title").conTexto(titulo) + "\n" }
        svg += "  " + ElementoSVG("rect").con("width", total.0).con("height", total.1).con("fill", "#ffffff").vacio
        svg += "\n"
        if !titulo.isEmpty {
            svg +=
                "  "
                + ElementoSVG("text").con("x", margen).con("y", margen + arriba / 2).con("dominant-baseline", "central")
                .con("font-size", 14.0).con("font-weight", "600").con("fill", "#222222").conTexto(titulo) + "\n"
        }
        let y = margen + arriba
        // Primero las blancas y encima las negras, cada una con su marca.
        for midi in blancas + negras {
            let negra = TecladoDePiano.esNegra(midi)
            let anchoDeTecla = negra ? TecladoDePiano.anchoDeNegra : TecladoDePiano.anchoDeBlanca
            let altoDeTecla = negra ? TecladoDePiano.altoDeNegra : alto
            let x = margen + self.x(de: midi)
            svg +=
                "  "
                + ElementoSVG("rect").con("x", x).con("y", y).con("width", anchoDeTecla).con("height", altoDeTecla)
                .con("fill", negra ? "#222222" : "#ffffff").con("stroke", "#444444").vacio + "\n"
            guard marcadas.contains(midi) else { continue }
            let cx = x + anchoDeTecla / 2
            let cy = y + altoDeTecla - (negra ? 10 : 14)
            let primera = primeras.contains(midi)
            svg +=
                "  "
                + ElementoSVG("circle").con("cx", cx).con("cy", cy).con("r", negra ? 6.5 : 9)
                .con("fill", DibujoSVG.Color.nota).con("stroke", primera ? DibujoSVG.Color.primera : "#ffffff")
                .con("stroke-width", primera ? 2.5 : 1).vacio + "\n"
            guard
                let rotulo = marcadas.rotulo(de: midi)
                    ?? (opciones.nombresDeLasNotas ? opciones.nombre(de: midi, en: marcadas) : nil)
            else { continue }
            svg +=
                "  "
                + ElementoSVG("text").con("x", cx).con("y", cy).con("text-anchor", "middle")
                .con("dominant-baseline", "central").con("font-size", negra ? 8.0 : 10.0).con("fill", "#ffffff")
                .conTexto(rotulo) + "\n"
        }
        return svg + "</svg>\n"
    }
}
