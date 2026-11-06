import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Lo común a los dibujos SVG del Tonnetz y de la tabla armónica: los colores, qué puntos se
// marcan, las tríadas que se rellenan, los textos de la leyenda, el título encima, la leyenda
// debajo y el fondo. Cada elemento se escribe con `ElementoSVG`, que escapa el texto y da formato a los números.

/// Lo que se dibuja: de dónde salen las notas, para ponerle título al dibujo.
package enum OrigenDelDibujo: Hashable, Sendable {
    case notas([Nota])
    case acorde(Acorde)
    case escala(Escala)
    case conjunto(ConjuntoDeClasesDeAltura)
    case alturas([Altura])
    case ciclo(CicloNeorriemanniano, Acorde)

    /// "Domaj7", "Re dórico", "Do · Mi · Sol", "Conjunto [0, 4, 7]", "Do3 · Sol3 · Mi4".
    package func titulo(_ notacion: Notacion) -> String {
        switch self {
        case .notas(let notas): return notas.map { $0.nombreCompacto(en: notacion) }.joined(separator: " · ")
        case .acorde(let acorde): return acorde.cifrado(en: notacion)
        case .escala(let escala): return escala.nombre(en: notacion)
        case .conjunto(let conjunto):
            return TextosDeRepresentaciones.en(notacion, \.conjunto)
                + conjunto.description
        case .alturas(let alturas):
            return alturas.map { $0.nombreCompacto(en: notacion) }.joined(separator: " · ")
        case .ciclo(let ciclo, let acorde):
            let nombre = ciclo.nombre(en: notacion)
            let cifrado = acorde.cifrado(en: notacion)
            let titulo = TextosDeRepresentaciones.en(notacion) { $0.cicloDesde(nombre, cifrado) }
            return titulo.conMayusculaInicial
        }
    }

    /// "tónica", "fundamental" o "primera nota".
    package func primera(_ notacion: Notacion) -> String {
        switch self {
        case .escala: return NombreDeGrado.tonica.nombre(en: notacion)
        case .acorde: return PapelEnAcorde.fundamental.nombre(en: notacion)
        case .conjunto:
            return TextosDeRepresentaciones.en(notacion, \.primeraClase)
        default:
            return TextosDeRepresentaciones.en(notacion, \.primeraNota)
        }
    }
}

/// Una entrada de la leyenda: una muestra y su texto.
package struct EntradaDeLeyenda {
    package enum Muestra {
        case triangulo(String) // relleno
        case hexagono(relleno: String, borde: String)
        case circulo(relleno: String, borde: String)
        case linea(String, grosor: Double)
        case flecha
    }
    package let muestra: Muestra
    package let texto: String
}

package enum DibujoSVG {
    /// Los colores de los dos dibujos.
    package enum Color {
        /// Las notas del conjunto.
        package static let nota = "#1f4e9c"
        /// Tríadas mayores y menores.
        package static let mayor = "#f6b26b"
        package static let menor = "#8fb8e8"
        /// Las flechas de un recorrido.
        package static let flecha = "#c0392b"
        /// El borde de la primera nota (tónica o fundamental).
        package static let primera = "#f39c12"
    }

    /// Los textos de la leyenda, en los quince idiomas de los textos (`Traduccion`).
    package enum Texto {
        case nota, claseDeAltura, altura, intervalos, contorno, triadaMayor, triadaMenor, pasoDelRecorrido
        case fundamentalDelPrimerAcorde

        package func en(_ notacion: Notacion) -> String { traduccion.en(notacion) }

        private var traduccion: Traduccion {
            switch self {
            case .nota: return TextosDeRepresentaciones.traduccion(\.leyendaNota)
            case .claseDeAltura:
                return TextosDeRepresentaciones.traduccion(\.leyendaClaseDeAltura)
            case .altura:
                return TextosDeRepresentaciones.traduccion(\.leyendaAltura)
            case .intervalos:
                return TextosDeRepresentaciones.traduccion(\.leyendaIntervalos)
            case .contorno:
                return TextosDeRepresentaciones.traduccion(\.leyendaContorno)
            case .triadaMayor:
                return TextosDeRepresentaciones.traduccion(\.leyendaTriadaMayor)
            case .triadaMenor:
                return TextosDeRepresentaciones.traduccion(\.leyendaTriadaMenor)
            case .pasoDelRecorrido:
                return TextosDeRepresentaciones.traduccion(\.leyendaPasoDelRecorrido)
            case .fundamentalDelPrimerAcorde:
                return TextosDeRepresentaciones.traduccion(\.leyendaFundamentalDelPrimerAcorde)
            }
        }
    }

    /// Un número con un decimal, como todos los de estos dibujos.
    package static func f(_ v: Double) -> String { NumerosSVG.unDecimal.texto(v) }

    /// Los puntos de la ventana que se marcan y, entre ellos, los de la primera nota. Sin `clave`,
    /// los puntos mismos; con ella (la clase de altura o el número MIDI), todos los de la ventana
    /// que suenan como alguno de ellos.
    package static func marcar(
        _ puntos: [PuntoDeLaRed], en red: [PuntoDeLaRed],
        clave: ((PuntoDeLaRed) -> Int)?
    ) -> (marcados: Set<PuntoDeLaRed>, primeros: Set<PuntoDeLaRed>) {
        guard let clave = clave else { return (Set(puntos), puntos.first.map { [$0] } ?? []) }
        let claves = Set(puntos.map(clave))
        let primera = puntos.first.map(clave)
        return (Set(red.filter { claves.contains(clave($0)) }), Set(red.filter { clave($0) == primera }))
    }

    /// Las tríadas mayores y menores con los tres vértices marcados y dentro de la ventana, en el
    /// orden de la red (y, en cada punto, primero la mayor).
    package static func triadas(en red: [PuntoDeLaRed], marcados: Set<PuntoDeLaRed>) -> [Tonnetz.Triada] {
        let enRed = Set(red)
        return red.flatMap { punto in
            [true, false].compactMap { mayor -> Tonnetz.Triada? in
                let triada = Tonnetz.Triada(fundamental: punto, mayor: mayor)
                return triada.vertices.allSatisfy { enRed.contains($0) && marcados.contains($0) } ? triada : nil
            }
        }
    }

    /// Envuelve el cuerpo de un dibujo, que ocupa la caja (x, y, ancho, alto), con el fondo, el
    /// título encima y la leyenda debajo (en varias filas si no cabe).
    package static func componer(
        caja: (x: Double, y: Double, ancho: Double, alto: Double), cuerpo: String,
        titulo: String, leyenda: [EntradaDeLeyenda], paso: Double
    ) -> String {
        let tamanoDelTitulo = paso * 0.3
        let tamanoDeLeyenda = paso * 0.2
        let margen = paso * 0.15
        let altoDelTitulo = titulo.isEmpty ? 0 : tamanoDelTitulo * 1.8
        // Anchura aproximada de un texto, para repartir la leyenda.
        func anchoDe(_ texto: String, _ tamano: Double) -> Double { Double(texto.count) * tamano * 0.56 }
        let muestra = tamanoDeLeyenda * 1.6
        let entradas = leyenda.map {
            (
                entrada: $0,
                ancho: muestra + tamanoDeLeyenda * 0.5 + anchoDe($0.texto, tamanoDeLeyenda) + tamanoDeLeyenda * 1.4
            )
        }
        let ancho = max(
            caja.ancho, anchoDe(titulo, tamanoDelTitulo) * 1.12 + 2 * margen,
            (entradas.map(\.ancho).max() ?? 0) + 2 * margen)
        // Las filas de la leyenda.
        var filas: [[(entrada: EntradaDeLeyenda, ancho: Double)]] = []
        for entrada in entradas {
            if let ultima = filas.last, ultima.reduce(0, { $0 + $1.ancho }) + entrada.ancho <= ancho - 2 * margen {
                filas[filas.count - 1].append(entrada)
            } else {
                filas.append([entrada])
            }
        }
        let altoDeFila = tamanoDeLeyenda * 1.9
        let altoDeLeyenda = filas.isEmpty ? 0 : Double(filas.count) * altoDeFila + margen
        let izquierda = caja.x - (ancho - caja.ancho) / 2
        let arriba = caja.y - altoDelTitulo
        let alto = caja.alto + altoDelTitulo + altoDeLeyenda

        var svg =
            ElementoSVG("svg").con("xmlns", "http://www.w3.org/2000/svg")
            .con("viewBox", [izquierda, arriba, ancho, alto].map(f).joined(separator: " "))
            .con("width", ancho).con("height", alto).con("font-family", "sans-serif").apertura + "\n"
        if !titulo.isEmpty { svg += "  " + ElementoSVG("title").conTexto(titulo) + "\n" }
        svg +=
            "  "
            + ElementoSVG("rect").con("x", izquierda).con("y", arriba).con("width", ancho).con("height", alto)
            .con("fill", "#ffffff").vacio + "\n"
        if !titulo.isEmpty {
            svg +=
                "  "
                + ElementoSVG("text").con("x", izquierda + margen).con("y", arriba + altoDelTitulo / 2 + margen / 2)
                .con("dominant-baseline", "central").con("font-size", tamanoDelTitulo).con("font-weight", "600")
                .con("fill", "#222222").conTexto(titulo) + "\n"
        }
        svg += cuerpo
        // La leyenda.
        var y = caja.y + caja.alto + margen / 2 + altoDeFila / 2
        let medioLado = tamanoDeLeyenda * 0.75 // medio lado de la muestra
        for fila in filas {
            var x = izquierda + margen
            for (entrada, anchoDeEntrada) in fila {
                let cx = x + muestra / 2
                let linea = ElementoSVG("line").con("x1", cx - medioLado).con("y1", y).con("x2", cx + medioLado)
                    .con("y2", y)
                let dibujo: String
                switch entrada.muestra {
                case .triangulo(let color):
                    dibujo =
                        ElementoSVG("polygon")
                        .con(
                            "points",
                            puntos: [
                                (cx - medioLado, y + medioLado * 0.8), (cx + medioLado, y + medioLado * 0.8),
                                (cx, y - medioLado * 0.9),
                            ]
                        )
                        .con("fill", color).con("fill-opacity", "0.8").con("stroke", "#333333").con("stroke-width", "1")
                        .vacio
                case .hexagono(let relleno, let borde):
                    let radio = medioLado * 1.05
                    let esquinas = stride(from: 0.0, to: 360, by: 60).map { grados -> (x: Double, y: Double) in
                        let angulo = grados * .pi / 180
                        return (cx + radio * cos(angulo), y + radio * sin(angulo))
                    }
                    dibujo =
                        ElementoSVG("polygon").con("points", puntos: esquinas).con("fill", relleno).con("stroke", borde)
                        .con("stroke-width", "2").vacio
                case .circulo(let relleno, let borde):
                    dibujo =
                        ElementoSVG("circle").con("cx", cx).con("cy", y).con("r", medioLado * 0.8).con("fill", relleno)
                        .con("stroke", borde).con("stroke-width", "1.5").vacio
                case .linea(let color, let grosor):
                    dibujo = linea.con("stroke", color).con("stroke-width", grosor).vacio
                case .flecha:
                    dibujo =
                        linea.con("stroke", Color.flecha).con("stroke-width", "2.5").con("marker-end", "url(#flecha)")
                        .vacio
                }
                let texto = ElementoSVG("text").con("x", x + muestra + tamanoDeLeyenda * 0.5).con("y", y)
                    .con("dominant-baseline", "central").con("font-size", tamanoDeLeyenda).con("fill", "#444444")
                    .conTexto(entrada.texto)
                svg += "  " + ElementoSVG("g").con("class", "leyenda").conHijos(dibujo + texto) + "\n"
                x += anchoDeEntrada
            }
            y += altoDeFila
        }
        return svg + "</svg>\n"
    }

    /// El título de un recorrido: "Do –R→ Lam –L→ Fa", con la secuencia más corta de P, L y R
    /// entre tríadas que no son vecinas; vacío si no hay recorrido.
    /// Con `acordes`, los nombres de las tríadas son esos (los de un ciclo, que no siempre
    /// coinciden con la posición del triángulo).
    package static func titulo(
        deRecorrido recorrido: [Tonnetz.Triada], _ notacion: Notacion,
        acordes: [Acorde] = []
    ) -> String {
        guard !recorrido.isEmpty else { return "" }
        let nombres = acordes.count == recorrido.count ? acordes : recorrido.map(\.acorde)
        var titulo = nombres[0].cifrado(en: notacion)
        for (i, (uno, otro)) in zip(recorrido, recorrido.dropFirst()).enumerated() {
            let pasos = uno.acorde.caminoNeorriemanniano(hasta: otro.acorde) ?? []
            titulo +=
                (pasos.isEmpty ? " – " : " –\(pasos.map(\.rawValue).joined())→ ") + nombres[i + 1].cifrado(en: notacion)
        }
        return titulo
    }

    /// Las flechas de un recorrido, de tríada en tríada, con un punto en la primera. `centro` da
    /// dónde se dibuja cada tríada en unidades de `paso` (el centro del triángulo en el Tonnetz,
    /// el vértice común de los tres hexágonos en la tabla armónica).
    package static func flechas(
        _ recorrido: [Tonnetz.Triada], centro: (Tonnetz.Triada) -> (Double, Double), paso: Double
    ) -> String {
        var svg = ""
        if !recorrido.isEmpty {
            let punta = ElementoSVG("path").con("d", "M0,0 L10,5 L0,10 z").con("fill", Color.flecha).vacio
            let marcador = ElementoSVG("marker").con("id", "flecha").con("viewBox", "0 0 10 10").con("refX", "9")
                .con("refY", "5").con("markerWidth", "5").con("markerHeight", "5").con("orient", "auto")
            svg += "  " + ElementoSVG("defs").conHijos(marcador.conHijos(punta)) + "\n"
            let (xInicial, yInicial) = centro(recorrido[0])
            svg +=
                "  "
                + ElementoSVG("circle").con("cx", xInicial * paso).con("cy", yInicial * paso).con("r", paso * 0.07)
                .con("fill", Color.flecha).vacio + "\n"
        }
        // Las flechas entre los mismos dos triángulos (de ida o de vuelta) se separan: se curvan
        // hacia lados distintos de la línea entre sus centros, cada una un poco más que la anterior.
        let pasos = zip(recorrido, recorrido.dropFirst()).filter { $0.0 != $0.1 }
        func par(_ uno: Tonnetz.Triada, _ otro: Tonnetz.Triada) -> [Tonnetz.Triada] {
            func clave(_ triada: Tonnetz.Triada) -> (Int, Int, Int) {
                (triada.fundamental.quintas, triada.fundamental.terceras, triada.mayor ? 0 : 1)
            }
            return clave(uno) < clave(otro) ? [uno, otro] : [otro, uno]
        }
        var veces: [[Tonnetz.Triada]: Int] = [:]
        for (uno, otro) in pasos { veces[par(uno, otro), default: 0] += 1 }
        var dibujadas: [[Tonnetz.Triada]: Int] = [:]
        for (uno, otro) in pasos {
            let clave = par(uno, otro)
            let yaDibujadas = dibujadas[clave, default: 0]
            dibujadas[clave] = yaDibujadas + 1
            // El desplazamiento, perpendicular al sentido del par (no al de la flecha), para que la
            // ida y la vuelta caigan en lados opuestos.
            let (px1, py1) = centro(clave[0])
            let (px2, py2) = centro(clave[1])
            let largoDelPar = ((px2 - px1) * (px2 - px1) + (py2 - py1) * (py2 - py1)).squareRoot()
            let separacion = (Double(yaDibujadas) - Double(veces[clave, default: 1] - 1) / 2) * 0.12
            let (nx, ny) = (-(py2 - py1) / largoDelPar, (px2 - px1) / largoDelPar)
            // Los extremos, algo apartados de los centros y entre sí; el punto de control, más.
            let (x1, y1) = (centro(uno).0 + nx * separacion * 0.6, centro(uno).1 + ny * separacion * 0.6)
            let (x2, y2) = (centro(otro).0 + nx * separacion * 0.6, centro(otro).1 + ny * separacion * 0.6)
            let largo = ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)).squareRoot()
            let recorte = min(0.1, largo / 4) / largo
            let (ax, ay) = (x1 + (x2 - x1) * recorte, y1 + (y2 - y1) * recorte)
            let (bx, by) = (x2 - (x2 - x1) * recorte, y2 - (y2 - y1) * recorte)
            let trazo: ElementoSVG
            if separacion == 0 {
                trazo = ElementoSVG("line").con("x1", ax * paso).con("y1", ay * paso).con("x2", bx * paso)
                    .con("y2", by * paso)
            } else {
                let (cx, cy) = ((ax + bx) / 2 + nx * separacion * 1.4, (ay + by) / 2 + ny * separacion * 1.4)
                trazo = ElementoSVG("path")
                    .con(
                        "d",
                        "M\(f(ax * paso)),\(f(ay * paso)) Q\(f(cx * paso)),\(f(cy * paso)) \(f(bx * paso)),\(f(by * paso))"
                    )
                    .con("fill", "none")
            }
            svg +=
                "  "
                + trazo.con("stroke", Color.flecha).con("stroke-width", veces[clave]! > 1 ? "2.2" : "3")
                .con("marker-end", "url(#flecha)").vacio + "\n"
        }
        return svg
    }
}
