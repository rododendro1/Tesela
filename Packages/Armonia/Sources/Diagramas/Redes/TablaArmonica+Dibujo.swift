import Elementos
import Foundation
import Hexagonos
import Teoria

// MARK: - El dibujo de la tabla armónica
//
// `svg` es el índice: coloca la ventana y dibuja, en este orden, los hexágonos, el contorno de la forma, la primera
// nota, los nombres, las tríadas y el recorrido, y por último la leyenda. Cada parte es un método de
// `DibujoDeLaTabla`, que guarda lo que comparten: la geometría, la ventana y los hexágonos marcados.

extension TablaArmonica {
    /// La tabla como imagen SVG: hexágonos con la quinta hacia arriba, las notas rellenas, la
    /// primera (la tónica de una escala o la fundamental de un acorde) con borde naranja, el
    /// contorno de la forma en trazo grueso y un punto donde se tocan los hexágonos de cada
    /// tríada (naranja si es mayor, azul si es menor). Con clases de altura o alturas se marcan
    /// todos los hexágonos que suenan igual dentro de la ventana. En un recorrido, unas flechas rojas
    /// van de tríada en tríada. Encima va un título (el acorde, la escala, las notas, las alturas o
    /// la progresión) y debajo, una leyenda de lo que aparece.
    ///
    /// - Parameters:
    ///   - opciones: la notación de los nombres de las notas, el título (si es `nil`, el que corresponda, y si es
    ///     "", ninguno) y la escala: con 1, 56 píxeles entre los centros de dos hexágonos vecinos, o 72 en un
    ///     recorrido, para que quepan las flechas.
    ///   - margen: cuántos hexágonos se dibujan alrededor de las notas; si es `nil`, uno con
    ///     ortografía y dos en las demás colocaciones, para que se vean las repeticiones.
    ///   - leyenda: si se dibuja la leyenda.
    public func svg(
        opciones: OpcionesDeDiagrama = OpcionesDeDiagrama(), margen: Int? = nil, leyenda: Bool = true
    ) -> String {
        let dibujo = DibujoDeLaTabla(tabla: self, notacion: opciones.notacion, escala: opciones.escala, margen: margen)
        let cuerpo =
            dibujo.hexagonos() + dibujo.contorno() + dibujo.primeraNota() + dibujo.nombres() + dibujo.triadas()
            + dibujo.recorrido()
        return DibujoSVG.componer(
            caja: dibujo.caja, cuerpo: cuerpo,
            titulo: opciones.titulo
                ?? (recorrido.isEmpty
                    ? origen?.titulo(opciones.notacion) ?? ""
                    : DibujoSVG.titulo(deRecorrido: recorrido, opciones.notacion, acordes: acordesDelRecorrido)),
            leyenda: leyenda && !puntos.isEmpty ? dibujo.leyenda() : [], paso: dibujo.paso)
    }
}

/// Lo que comparten las partes del dibujo de una tabla armónica: la geometría de los hexágonos, la ventana y los
/// hexágonos marcados. Cada método dibuja una parte.
private struct DibujoDeLaTabla {
    let tabla: TablaArmonica
    let notacion: Notacion
    /// Los píxeles entre los centros de dos hexágonos vecinos.
    let paso: Double
    let trazado: Trazado
    /// Los hexágonos de la ventana: un rectángulo alrededor de las notas.
    let red: [PuntoDeLaRed]
    /// Los hexágonos de las notas (con clases de altura o alturas, todos los que suenan igual) y los de la primera.
    let marcados: Set<PuntoDeLaRed>
    let principales: Set<PuntoDeLaRed>
    /// Las tríadas completas entre los marcados.
    let triadasMarcadas: [Tonnetz.Triada]
    /// El origen, el ancho y el alto de la imagen.
    let caja: (Double, Double, Double, Double)

    private static let coseno = 0.8660254037844386 // cos 30°

    init(tabla: TablaArmonica, notacion: Notacion, escala: Double, margen: Int?) {
        self.tabla = tabla
        self.notacion = notacion
        let paso = (tabla.recorrido.isEmpty ? 56 : 72) * escala
        self.paso = paso
        let margen = Double(margen ?? (tabla.colocacion == .notas ? 1 : 2))
        let trazado = TablaArmonica.trazado(paso: paso)
        self.trazado = trazado
        let centro = { trazado.centro(de: TablaArmonica.coordenada(de: $0)) }

        // La ventana.
        let coseno = DibujoDeLaTabla.coseno
        let base = tabla.puntos.isEmpty ? [PuntoDeLaRed(quintas: 0, terceras: 0)] : tabla.puntos
        let xs = base.map { centro($0).x }.extremosOSi(noHay: 0...0)
        let ys = base.map { centro($0).y }.extremosOSi(noHay: 0...0)
        let minX = xs.lowerBound - margen * coseno * paso - paso * 0.1
        let maxX = xs.upperBound + margen * coseno * paso + paso * 0.1
        let minY = ys.lowerBound - margen * paso - paso * 0.1
        let maxY = ys.upperBound + margen * paso + paso * 0.1
        var red: [PuntoDeLaRed] = []
        let columnas = Int((minX / (coseno * paso)).rounded(.up))...Int((maxX / (coseno * paso)).rounded(.down))
        for b in columnas {
            // y = −(a + b/2)·paso entre minY y maxY.
            let desde = Int((-maxY / paso - Double(b) / 2).rounded(.up))
            let hasta = Int((-minY / paso - Double(b) / 2).rounded(.down))
            if desde <= hasta { for a in desde...hasta { red.append(PuntoDeLaRed(quintas: a, terceras: b)) } }
        }
        self.red = red

        let clave: ((PuntoDeLaRed) -> Int)?
        switch tabla.colocacion {
        case .notas: clave = nil
        case .clasesDeAltura: clave = { $0.claseDeAltura }
        case .alturas: clave = { TablaArmonica.midi(de: $0) }
        }
        (marcados, principales) = DibujoSVG.marcar(tabla.puntos, en: red, clave: clave)
        triadasMarcadas = DibujoSVG.triadas(en: red, marcados: marcados)

        let radio = trazado.tamano.x // del centro a un vértice
        let borde = paso * 0.08
        caja = (
            minX - radio - borde, minY - paso / 2 - borde, maxX - minX + 2 * (radio + borde),
            maxY - minY + paso + 2 * borde
        )
    }

    private func x(_ p: PuntoDeLaRed) -> Double { trazado.centro(de: TablaArmonica.coordenada(de: p)).x }
    private func y(_ p: PuntoDeLaRed) -> Double { trazado.centro(de: TablaArmonica.coordenada(de: p)).y }
    /// Los seis vértices, empezando por el de la derecha (0°) y en sentido horario en pantalla.
    private func vertices(_ p: PuntoDeLaRed) -> [(Double, Double)] {
        trazado.vertices(de: TablaArmonica.coordenada(de: p)).map { ($0.x, $0.y) }
    }
    /// El vértice a `angulo` grados (un múltiplo de 60°).
    private func vertice(_ p: PuntoDeLaRed, _ angulo: Double) -> (Double, Double) {
        vertices(p)[modulo(Int(angulo) / 60, 6)]
    }

    /// Los hexágonos (de lados horizontales arriba y abajo).
    func hexagonos() -> String {
        var svg = ""
        for punto in red {
            let marcado = marcados.contains(punto)
            let esquinas = vertices(punto)
            svg +=
                "  "
                + ElementoSVG("polygon").con("points", puntos: esquinas.map { ($0.0, $0.1) })
                .con("fill", marcado ? DibujoSVG.Color.nota : "#f4f4f4").con("stroke", marcado ? "#ffffff" : "#bbbbbb")
                .con("stroke-width", marcado ? "1.5" : "1").vacio + "\n"
        }
        return svg
    }

    /// El contorno de la forma: los lados entre un hexágono marcado y uno que no lo está.
    func contorno() -> String {
        // El vecino en la dirección θ comparte el lado entre los vértices θ − 30° y θ + 30°.
        let direcciones: [((Int, Int), Double)] = [
            ((1, 0), 270), ((0, 1), 330), ((-1, 1), 30),
            ((-1, 0), 90), ((0, -1), 150), ((1, -1), 210),
        ]
        var svg = ""
        for punto in red where marcados.contains(punto) {
            for (desplazamiento, angulo) in direcciones {
                let vecino = PuntoDeLaRed(
                    quintas: punto.quintas + desplazamiento.0, terceras: punto.terceras + desplazamiento.1)
                guard !marcados.contains(vecino) else { continue }
                let (x1, y1) = vertice(punto, angulo - 30)
                let (x2, y2) = vertice(punto, angulo + 30)
                svg +=
                    "  "
                    + ElementoSVG("line").con("x1", x1).con("y1", y1).con("x2", x2).con("y2", y2)
                    .con("stroke", "#111111").con("stroke-width", "3").con("stroke-linecap", "round").vacio + "\n"
            }
        }
        return svg
    }

    /// La primera nota, con borde naranja.
    func primeraNota() -> String {
        let f = DibujoSVG.f
        var svg = ""
        for punto in red where principales.contains(punto) {
            let esquinas = vertices(punto)
            let transformacion =
                "translate(\(f(x(punto))) \(f(y(punto)))) scale(0.86) translate(\(f(-x(punto))) \(f(-y(punto))))"
            svg +=
                "  "
                + ElementoSVG("polygon").con("points", puntos: esquinas.map { ($0.0, $0.1) }).con("fill", "none")
                .con("stroke", DibujoSVG.Color.primera).con("stroke-width", "3.5").con("transform", transformacion)
                .vacio + "\n"
        }
        return svg
    }

    /// El nombre de cada hexágono: la nota, la clase de altura o la altura.
    func nombres() -> String {
        // Los nombres de las alturas dadas, por número MIDI.
        let dadas = Dictionary(
            tabla.alturas.map { ($0.midi, $0.nombreCompacto(en: notacion)) },
            uniquingKeysWith: { uno, _ in uno })
        // Los demás hexágonos se escriben como en la ventana de quintas de las alturas dadas.
        let ventanaDeLasAlturas = VentanaDeQuintas(conteniendo: tabla.alturas.map(\.nota)) ?? .sostenidos
        let rotulos = tabla.comoTonnetz
        func nombre(_ p: PuntoDeLaRed) -> String {
            switch tabla.colocacion {
            case .notas: return rotulos.nombre(de: p).nombreCompacto(en: notacion)
            case .clasesDeAltura: return String(p.claseDeAltura)
            case .alturas:
                let midi = TablaArmonica.midi(de: p)
                if let nombre = dadas[midi] { return nombre }
                let altura = Altura(midi: midi, ventana: ventanaDeLasAlturas)
                return altura.nombreCompacto(en: notacion)
            }
        }
        var svg = ""
        for punto in red {
            let marcado = marcados.contains(punto)
            let texto = nombre(punto)
            let tamano = paso * (texto.count > 4 ? 0.2 : texto.count > 3 ? 0.23 : 0.27)
            svg +=
                "  "
                + ElementoSVG("text").con("x", x(punto)).con("y", y(punto)).con("text-anchor", "middle")
                .con("dominant-baseline", "central").con("font-size", tamano).con(
                    "fill", marcado ? "#ffffff" : "#888888"
                )
                .con("font-weight", "bold", si: marcado).conTexto(texto) + "\n"
        }
        return svg
    }

    /// El vértice común de los tres hexágonos de una tríada.
    private func centro(de triada: Tonnetz.Triada) -> (Double, Double) {
        (triada.vertices.map(x).reduce(0, +) / 3, triada.vertices.map(y).reduce(0, +) / 3)
    }

    /// Las tríadas: un punto en el vértice común de sus tres hexágonos.
    func triadas() -> String {
        var svg = ""
        for triada in triadasMarcadas {
            let (cx, cy) = centro(de: triada)
            svg +=
                "  "
                + ElementoSVG("circle").con("cx", cx).con("cy", cy)
                .con("r", paso * (tabla.recorrido.isEmpty ? 0.1 : 0.075))
                .con("fill", triada.mayor ? DibujoSVG.Color.mayor : DibujoSVG.Color.menor).con("stroke", "#111111")
                .con("stroke-width", "1.5").vacio + "\n"
        }
        return svg
    }

    /// El recorrido: flechas entre los vértices comunes de las tríadas.
    func recorrido() -> String {
        DibujoSVG.flechas(
            tabla.recorrido,
            centro: { triada in
                let (cx, cy) = centro(de: triada)
                return (cx / paso, cy / paso)
            }, paso: paso)
    }

    /// La leyenda: solo lo que aparece.
    func leyenda() -> [EntradaDeLeyenda] {
        var entradas: [EntradaDeLeyenda] = []
        func entrada(_ muestra: EntradaDeLeyenda.Muestra, _ texto: String) {
            entradas.append(EntradaDeLeyenda(muestra: muestra, texto: texto))
        }
        let colocacion = tabla.colocacion
        let nota: DibujoSVG.Texto =
            colocacion == .notas ? .nota : colocacion == .clasesDeAltura ? .claseDeAltura : .altura
        entrada(.hexagono(relleno: DibujoSVG.Color.nota, borde: DibujoSVG.Color.nota), nota.en(notacion))
        let primera =
            !tabla.recorrido.isEmpty
            ? DibujoSVG.Texto.fundamentalDelPrimerAcorde.en(notacion)
            : (tabla.origen ?? .notas([])).primera(notacion)
        entrada(.hexagono(relleno: DibujoSVG.Color.nota, borde: DibujoSVG.Color.primera), primera)
        entrada(.linea("#111111", grosor: 3), DibujoSVG.Texto.contorno.en(notacion))
        if triadasMarcadas.contains(where: \.mayor) {
            entrada(
                .circulo(relleno: DibujoSVG.Color.mayor, borde: "#111111"), DibujoSVG.Texto.triadaMayor.en(notacion))
        }
        if triadasMarcadas.contains(where: { !$0.mayor }) {
            entrada(
                .circulo(relleno: DibujoSVG.Color.menor, borde: "#111111"), DibujoSVG.Texto.triadaMenor.en(notacion))
        }
        if !tabla.recorrido.isEmpty { entrada(.flecha, DibujoSVG.Texto.pasoDelRecorrido.en(notacion)) }
        return entradas
    }
}
