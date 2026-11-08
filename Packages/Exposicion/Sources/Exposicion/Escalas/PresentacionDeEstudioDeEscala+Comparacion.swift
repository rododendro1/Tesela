import Armonia
import Foundation

extension PresentacionDeEstudioDeEscala {
    /// Los colores de la comparación: lo común, en azul; lo que solo está en la primera, en verde; lo que solo está
    /// en la segunda, en rojo.
    enum ColorDeLaComparacion {
        static let comun = "#1f4e9c"
        static let origen = "#27ae60"
        static let destino = "#c0392b"
        static let fuera = "#bbbbbb"
        static let tonica = "#f39c12"
        static let cambio = "#fdecea"
    }

    /// Dos escalas comparadas nota a nota en una hoja (SVG): los dos pentagramas, una tabla grado a grado con los
    /// grados que cambian sombreados, un reloj con las dos escalas encima y la leyenda de lo común y lo distinto.
    /// Las notas comunes van en azul; las que solo están en la primera, en verde; las de la segunda, en rojo.
    ///
    ///     let hoja = PresentacionDeEstudioDeEscala.comparacionNotaANota(
    ///         Escala(.do), con: Escala(.do, .dorico), en: .compacta(.espanol))
    ///     hoja.contains(">Do mayor → Do dórico</text>")   // true
    public static func comparacionNotaANota(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        let ancho = anchoDeLaHoja
        let margen = margenDeLaHoja
        let util = ancho - 2 * margen
        let datos = comparar(escala, con: otra, en: notacion)
        let comparacion = datos.comparacion
        let nombre = escala.nombre(en: notacion)
        let nombreDeLaOtra = otra.nombre(en: notacion)
        var cuerpo: [String] = []
        var y = margen + 20
        cuerpo.append(texto(nombre + " → " + nombreDeLaOtra, x: margen, y: y, tamano: 20, negrita: true))
        y += 10
        if let distancia = datos.distancia {
            y += 18
            cuerpo.append(texto(distancia, x: margen, y: y, tamano: 12, color: "#666666"))
        }
        y += 16

        // Los dos pentagramas, uno encima del otro, cada uno con su nombre.
        for (cual, color) in [(escala, ColorDeLaComparacion.origen), (otra, ColorDeLaComparacion.destino)] {
            y += 14
            cuerpo.append(texto(cual.nombre(en: notacion), x: margen, y: y, tamano: 13, negrita: true, color: color))
            y += 4
            let pentagrama = PentagramaPresentado(cual, notacion: notacion).svg
            y += incrustar(pentagrama, x: margen, y: y, ancho: util, en: &cuerpo)
            y += 8
        }

        // Grado a grado: una columna por grado, sombreada si cambia.
        y += 8
        y = tablaDeGrados(comparacion, x: margen, y: y, ancho: util, notacion: notacion, en: &cuerpo) + 16

        // El reloj, a la izquierda; a la derecha, la leyenda y los grados que cambian.
        let lado = 220.0
        let alto = relojDeLaComparacion(comparacion, x: margen, y: y, lado: lado, notacion: notacion, en: &cuerpo)
        var lineas = y + 16
        let x = margen + lado + 20
        let leyenda: [(String, String)] = [
            (notacion.texto(\.notasComunes) + ": " + datos.comunes, ColorDeLaComparacion.comun),
            (datos.soloEnOrigen, ColorDeLaComparacion.origen),
            (datos.soloEnDestino, ColorDeLaComparacion.destino),
        ]
        for (linea, color) in leyenda where !linea.isEmpty {
            cuerpo.append(
                "<circle cx=\"\(numero(x + 5))\" cy=\"\(numero(lineas - 4))\" r=\"5\" fill=\"\(color)\"/>")
            cuerpo.append(texto(linea, x: x + 16, y: lineas, tamano: 12))
            lineas += 20
        }
        if !datos.cambios.isEmpty { lineas += 6 }
        for cambio in datos.cambios {
            cuerpo.append(texto(cambio, x: x + 16, y: lineas, tamano: 12, color: "#444444"))
            lineas += 18
        }
        let total = (max(y + alto, lineas) + margen).rounded(.up)
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(numero(ancho))\" height=\"\(numero(total))\" "
            + "viewBox=\"0 0 \(numero(ancho)) \(numero(total))\" font-family=\"Helvetica, Arial, sans-serif\">"
        let fondo = "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }

    /// La tabla grado a grado: una fila con el número de cada grado y otra por escala, con las notas del color de
    /// la comparación y las columnas de los grados que cambian sombreadas. Da dónde termina.
    private static func tablaDeGrados(
        _ comparacion: ComparacionDeEscalas, x: Double, y: Double, ancho: Double, notacion: Notacion,
        en cuerpo: inout [String]
    ) -> Double {
        let origen = comparacion.origen.notas
        let destino = comparacion.destino.notas
        let columnas = max(origen.count, destino.count)
        guard columnas > 0 else { return y }
        let primera = 120.0
        let columna = (ancho - primera) / Double(columnas)
        let fila = 22.0
        let enDestino = Set(destino.map(\.claseDeAltura))
        let enOrigen = Set(origen.map(\.claseDeAltura))
        let cambian = Set(comparacion.cambios.map(\.grado))
        for grado in cambian.sorted() {
            let izquierda = x + primera + Double(grado - 1) * columna
            cuerpo.append(
                "<rect x=\"\(numero(izquierda))\" y=\"\(numero(y))\" width=\"\(numero(columna))\" "
                    + "height=\"\(numero(3 * fila))\" fill=\"\(ColorDeLaComparacion.cambio)\"/>")
        }
        func centrado(_ contenido: String, columna i: Int, fila: Double, color: String, negrita: Bool = false) {
            let centro = x + primera + (Double(i) + 0.5) * columna
            cuerpo.append(
                "<text x=\"\(numero(centro))\" y=\"\(numero(fila))\" font-size=\"12\" text-anchor=\"middle\" "
                    + "fill=\"\(color)\"" + (negrita ? " font-weight=\"bold\"" : "") + ">"
                    + EscrituraXML.escapar(contenido) + "</text>")
        }
        for i in 0..<columnas { centrado(String(i + 1), columna: i, fila: y + 15, color: "#888888") }
        let filas: [(Escala, [Nota], Set<Int>, String)] = [
            (comparacion.origen, origen, enDestino, ColorDeLaComparacion.origen),
            (comparacion.destino, destino, enOrigen, ColorDeLaComparacion.destino),
        ]
        for (n, (escala, notas, enLaOtra, propio)) in filas.enumerated() {
            let base = y + Double(n + 1) * fila + 15
            cuerpo.append(texto(escala.nombre(en: notacion), x: x, y: base, tamano: 12, negrita: true, color: propio))
            for (i, nota) in notas.enumerated() {
                let comun = enLaOtra.contains(nota.claseDeAltura)
                centrado(
                    nota.nombre(en: notacion), columna: i, fila: base,
                    color: comun ? ColorDeLaComparacion.comun : propio, negrita: !comun)
            }
        }
        cuerpo.append(
            "<line x1=\"\(numero(x))\" y1=\"\(numero(y + fila + 3))\" x2=\"\(numero(x + ancho))\" "
                + "y2=\"\(numero(y + fila + 3))\" stroke=\"#dddddd\"/>")
        return y + 3 * fila + 4
    }

    /// Las dos escalas en el mismo reloj cromático: el polígono de la primera, en verde, y el de la segunda, en
    /// rojo y a trazos; cada hora, del color de la comparación, y las tónicas con el borde naranja. Da su alto.
    private static func relojDeLaComparacion(
        _ comparacion: ComparacionDeEscalas, x: Double, y: Double, lado: Double, notacion: Notacion,
        en cuerpo: inout [String]
    ) -> Double {
        let centro = (x: x + lado / 2, y: y + lado / 2)
        let radio = lado / 2 - 34
        func punto(_ clase: Int, _ distancia: Double) -> (x: Double, y: Double) {
            let angulo = (Double(clase) / 12 * 2 - 0.5) * Double.pi
            return (centro.x + distancia * cos(angulo), centro.y + distancia * sin(angulo))
        }
        let origen = comparacion.origen.notas
        let destino = comparacion.destino.notas
        let enOrigen = Set(origen.map(\.claseDeAltura))
        let enDestino = Set(destino.map(\.claseDeAltura))
        let tonicas = [comparacion.origen.tonica.claseDeAltura, comparacion.destino.tonica.claseDeAltura]
        cuerpo.append(
            "<circle cx=\"\(numero(centro.x))\" cy=\"\(numero(centro.y))\" r=\"\(numero(radio))\" fill=\"none\" "
                + "stroke=\"#cccccc\"/>")
        let poligonos = [
            (enOrigen, ColorDeLaComparacion.origen, ""),
            (enDestino, ColorDeLaComparacion.destino, " stroke-dasharray=\"5 3\""),
        ]
        for (clases, color, trazo) in poligonos where clases.count >= 2 {
            let puntos = clases.sorted().map { punto($0, radio) }.map { numero($0.x) + "," + numero($0.y) }
            cuerpo.append(
                "<polygon points=\"\(puntos.joined(separator: " "))\" fill=\"\(color)\" fill-opacity=\"0.1\" "
                    + "stroke=\"\(color)\" stroke-width=\"2\"\(trazo)/>")
        }
        let sencillos = ConjuntoDeClasesDeAltura.nombresDeLasClases(en: notacion)
        var rotulos = Dictionary(uniqueKeysWithValues: sencillos.enumerated().map { ($0.offset, $0.element) })
        for nota in destino + origen { rotulos[nota.claseDeAltura] = nota.nombre(en: notacion) }
        for clase in 0..<12 {
            let dentro = (enOrigen.contains(clase), enDestino.contains(clase))
            let color =
                switch dentro {
                case (true, true): ColorDeLaComparacion.comun
                case (true, false): ColorDeLaComparacion.origen
                case (false, true): ColorDeLaComparacion.destino
                case (false, false): ColorDeLaComparacion.fuera
                }
            let suya = dentro.0 || dentro.1
            let esTonica = tonicas.contains(clase)
            let centroDelPunto = punto(clase, radio)
            cuerpo.append(
                "<circle cx=\"\(numero(centroDelPunto.x))\" cy=\"\(numero(centroDelPunto.y))\" "
                    + "r=\"\(suya ? "7" : "3.5")\" fill=\"\(color)\" "
                    + "stroke=\"\(esTonica ? ColorDeLaComparacion.tonica : "#ffffff")\" "
                    + "stroke-width=\"\(esTonica ? "3" : "1")\"/>")
            let rotulo = punto(clase, radio + 20)
            cuerpo.append(
                "<text x=\"\(numero(rotulo.x))\" y=\"\(numero(rotulo.y))\" font-size=\"11\" text-anchor=\"middle\" "
                    + "dominant-baseline=\"central\" fill=\"\(suya ? color : "#999999")\""
                    + (suya ? " font-weight=\"bold\"" : "") + ">"
                    + EscrituraXML.escapar(rotulos[clase] ?? "") + "</text>")
        }
        return lado
    }
}
