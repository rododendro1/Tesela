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

    /// Dos escalas comparadas nota a nota en SVG, para `HojaDeEstudio.comparacion(_:con:en:formato:)`: los dos
    /// pentagramas, una tabla grado a grado con los grados que cambian sombreados, un reloj con las dos escalas encima
    /// y la leyenda de lo común y lo distinto.
    static func comparacionSVG(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        let ancho = Hoja.ancho
        let margen = Hoja.margen
        let util = ancho - 2 * margen
        let datos = ComparacionDeEscalasPresentada(escala, con: otra, en: notacion)
        let comparacion = datos.relacion
        let nombre = escala.nombre(en: notacion)
        let nombreDeLaOtra = otra.nombre(en: notacion)
        var cuerpo: [String] = []
        var y = margen + 20
        cuerpo.append(Hoja.texto(nombre + " → " + nombreDeLaOtra, x: margen, y: y, tamano: 20, negrita: true))
        y += 10
        if let distancia = datos.distancia {
            y += 18
            cuerpo.append(Hoja.texto(distancia, x: margen, y: y, tamano: 12, color: "#666666"))
        }
        y += 16

        // Los dos pentagramas, uno encima del otro, cada uno con su nombre.
        for (cual, color) in [(escala, ColorDeLaComparacion.origen), (otra, ColorDeLaComparacion.destino)] {
            y += 14
            cuerpo.append(
                Hoja.texto(cual.nombre(en: notacion), x: margen, y: y, tamano: 13, negrita: true, color: color))
            y += 4
            let pentagrama = PentagramaPresentado(cual, en: notacion).svg
            y += Hoja.incrustar(pentagrama, x: margen, y: y, ancho: util, en: &cuerpo)
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
                "<circle cx=\"\(Hoja.numero(x + 5))\" cy=\"\(Hoja.numero(lineas - 4))\" r=\"5\" fill=\"\(color)\"/>")
            cuerpo.append(Hoja.texto(linea, x: x + 16, y: lineas, tamano: 12))
            lineas += 20
        }
        if !datos.cambios.isEmpty { lineas += 6 }
        for cambio in datos.cambios {
            cuerpo.append(Hoja.texto(cambio, x: x + 16, y: lineas, tamano: 12, color: "#444444"))
            lineas += 18
        }
        let total = (max(y + alto, lineas) + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: total, cuerpo)
    }

    /// La tabla grado a grado: una fila con el número de cada grado y otra por escala, con las notas del color de
    /// la comparación y las columnas de los grados que cambian sombreadas. Da dónde termina.
    private static func tablaDeGrados(
        _ comparacion: RelacionEntreEscalas, x: Double, y: Double, ancho: Double, notacion: Notacion,
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
                "<rect x=\"\(Hoja.numero(izquierda))\" y=\"\(Hoja.numero(y))\" width=\"\(Hoja.numero(columna))\" "
                    + "height=\"\(Hoja.numero(3 * fila))\" fill=\"\(ColorDeLaComparacion.cambio)\"/>")
        }
        func centrado(_ contenido: String, columna i: Int, fila: Double, color: String, negrita: Bool = false) {
            let centro = x + primera + (Double(i) + 0.5) * columna
            cuerpo.append(
                "<text x=\"\(Hoja.numero(centro))\" y=\"\(Hoja.numero(fila))\" font-size=\"12\" text-anchor=\"middle\" "
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
            cuerpo.append(
                Hoja.texto(escala.nombre(en: notacion), x: x, y: base, tamano: 12, negrita: true, color: propio))
            for (i, nota) in notas.enumerated() {
                let comun = enLaOtra.contains(nota.claseDeAltura)
                centrado(
                    nota.nombre(en: notacion), columna: i, fila: base,
                    color: comun ? ColorDeLaComparacion.comun : propio, negrita: !comun)
            }
        }
        cuerpo.append(
            "<line x1=\"\(Hoja.numero(x))\" y1=\"\(Hoja.numero(y + fila + 3))\" x2=\"\(Hoja.numero(x + ancho))\" "
                + "y2=\"\(Hoja.numero(y + fila + 3))\" stroke=\"#dddddd\"/>")
        return y + 3 * fila + 4
    }

    /// Las dos escalas en el mismo reloj cromático: el polígono de la primera, en verde, y el de la segunda, en
    /// rojo y a trazos; cada hora, del color de la comparación, y las tónicas con el borde naranja. Da su alto.
    static func relojDeLaComparacion(
        _ comparacion: RelacionEntreEscalas, x: Double, y: Double, lado: Double, notacion: Notacion,
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
            "<circle cx=\"\(Hoja.numero(centro.x))\" cy=\"\(Hoja.numero(centro.y))\" r=\"\(Hoja.numero(radio))\" fill=\"none\" "
                + "stroke=\"#cccccc\"/>")
        let poligonos = [
            (enOrigen, ColorDeLaComparacion.origen, ""),
            (enDestino, ColorDeLaComparacion.destino, " stroke-dasharray=\"5 3\""),
        ]
        for (clases, color, trazo) in poligonos where clases.count >= 2 {
            let puntos = clases.sorted().map { punto($0, radio) }.map { Hoja.numero($0.x) + "," + Hoja.numero($0.y) }
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
                "<circle cx=\"\(Hoja.numero(centroDelPunto.x))\" cy=\"\(Hoja.numero(centroDelPunto.y))\" "
                    + "r=\"\(suya ? "7" : "3.5")\" fill=\"\(color)\" "
                    + "stroke=\"\(esTonica ? ColorDeLaComparacion.tonica : "#ffffff")\" "
                    + "stroke-width=\"\(esTonica ? "3" : "1")\"/>")
            let rotulo = punto(clase, radio + 20)
            cuerpo.append(
                "<text x=\"\(Hoja.numero(rotulo.x))\" y=\"\(Hoja.numero(rotulo.y))\" font-size=\"11\" text-anchor=\"middle\" "
                    + "dominant-baseline=\"central\" fill=\"\(suya ? color : "#999999")\""
                    + (suya ? " font-weight=\"bold\"" : "") + ">"
                    + EscrituraXML.escapar(rotulos[clase] ?? "") + "</text>")
        }
        return lado
    }
}

// MARK: - La comparación de dos escalas en HTML

extension PresentacionDeEstudioDeEscala {
    /// Dos escalas comparadas nota a nota como página HTML: lo mismo que `comparacionSVG(_:con:en:)`, con los textos
    /// en HTML y los grados que cambian resaltados.
    static func comparacionHTML(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> String {
        let datos = ComparacionDeEscalasPresentada(escala, con: otra, en: notacion)
        let comparacion = datos.relacion
        let titulo = escala.nombre(en: notacion) + " → " + otra.nombre(en: notacion)
        var cuerpo = [Hoja.encabezadoHTML(titulo, [datos.distancia ?? ""])]

        // Los dos pentagramas, cada uno con su nombre, del color de su escala.
        for (cual, clase) in [(escala, "origen"), (otra, "destino")] {
            cuerpo.append("<h2 class=\"" + clase + "\">" + Hoja.html(cual.nombre(en: notacion)) + "</h2>")
            cuerpo.append(Hoja.figura(PentagramaPresentado(cual, en: notacion).svg, clase: "pentagrama"))
        }

        // Grado a grado: los números y una fila por escala, con los grados que cambian resaltados.
        let origen = comparacion.origen.notas
        let destino = comparacion.destino.notas
        let enOrigen = Set(origen.map(\.claseDeAltura))
        let enDestino = Set(destino.map(\.claseDeAltura))
        let cambian = Set(comparacion.cambios.map(\.grado))
        let columnas = max(origen.count, destino.count)
        func celda(_ grado: Int, _ contenido: String, clase: String) -> String {
            let todas = cambian.contains(grado) ? clase + " cambio" : clase
            return "<td class=\"" + todas + "\">" + Hoja.html(contenido) + "</td>"
        }
        var filas = [
            "<tr><td></td>" + (1...max(columnas, 1)).map { celda($0, String($0), clase: "sub") }.joined() + "</tr>"
        ]
        let escalas: [(Escala, [Nota], Set<Int>, String)] = [
            (comparacion.origen, origen, enDestino, "origen"), (comparacion.destino, destino, enOrigen, "destino"),
        ]
        for (cual, notas, enLaOtra, propia) in escalas {
            let celdas = notas.enumerated().map { i, nota in
                let comun = enLaOtra.contains(nota.claseDeAltura)
                return celda(i + 1, nota.nombre(en: notacion), clase: comun ? "comun" : propia + " propia")
            }
            filas.append(
                "<tr><td class=\"" + propia + "\"><strong>" + Hoja.html(cual.nombre(en: notacion)) + "</strong></td>"
                    + celdas.joined() + "</tr>")
        }
        cuerpo.append("<div class=\"tabla\"><table class=\"grados-comparados\">" + filas.joined() + "</table></div>")

        // El reloj con las dos escalas y, al lado, la leyenda y los grados que cambian.
        var reloj: [String] = []
        let lado = relojDeLaComparacion(comparacion, x: 0, y: 0, lado: 220, notacion: notacion, en: &reloj)
        let leyenda = [
            (notacion.texto(\.notasComunes) + ": " + datos.comunes, "comun"),
            (datos.soloEnOrigen, "origen"), (datos.soloEnDestino, "destino"),
        ].filter { !$0.0.isEmpty }.map { texto, clase in
            "<li><span class=\"punto " + clase + "\"></span>" + Hoja.html(texto) + "</li>"
        }
        let costado =
            "<div><ul class=\"leyenda\">" + leyenda.joined() + "</ul>" + Hoja.listaHTML(datos.cambios) + "</div>"
        cuerpo.append(
            "<div class=\"comparacion\">" + Hoja.figura(Hoja.dibujoSVG(ancho: lado, alto: lado, reloj), clase: "reloj")
                + costado
                + "</div>")
        return Hoja.paginaHTML(
            titulo: notacion.texto(\.hojaDeEstudio) + " · " + titulo, idioma: notacion.textos.codigo, cuerpo)
    }
}
