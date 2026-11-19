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

    /// Dos escalas comparadas nota a nota, para `HojaDeEstudio.comparacion(_:con:en:formato:)`: los dos pentagramas,
    /// cada uno con el nombre de su escala en su color; una tabla grado a grado, con las notas comunes en azul, las de
    /// cada una en su color y en negrita y los grados que cambian resaltados; la leyenda de lo común y lo distinto, con
    /// los grados que cambian, y al lado un reloj con las dos escalas encima.
    static func hojaDeLaComparacion(_ escala: Escala, con otra: Escala, en notacion: Notacion) -> HojaCompuesta {
        typealias Celda = HojaCompuesta.Celda
        let datos = ComparacionDeEscalasPresentada(escala, con: otra, en: notacion)
        let comparacion = datos.relacion
        let origen = comparacion.origen.notas
        let destino = comparacion.destino.notas
        let cambian = Set(comparacion.cambios.map(\.grado))
        let columnas = max(origen.count, destino.count, 1)
        // Grado a grado: los números y una fila por escala.
        var filas = [
            [Celda(texto: "")]
                + (1...columnas).map { Celda(texto: String($0), tono: .suave, resaltada: cambian.contains($0)) }
        ]
        let escalas: [(Escala, [Nota], [Nota], HojaCompuesta.Tono)] = [
            (comparacion.origen, origen, destino, .origen), (comparacion.destino, destino, origen, .destino),
        ]
        for (cual, notas, deLaOtra, tono) in escalas {
            let enLaOtra = Set(deLaOtra.map(\.claseDeAltura))
            filas.append(
                [Celda(texto: cual.nombre(en: notacion), tono: tono, negrita: true)]
                    + notas.enumerated().map { i, nota in
                        let comun = enLaOtra.contains(nota.claseDeAltura)
                        return Celda(
                            texto: nota.nombre(en: notacion), tono: comun ? .comun : tono, negrita: !comun,
                            resaltada: cambian.contains(i + 1))
                    })
        }
        // El reloj, con las dos escalas.
        let lado = 220.0
        var reloj: [String] = []
        _ = relojDeLaComparacion(comparacion, x: 0, y: 0, lado: lado, notacion: notacion, en: &reloj)
        let leyenda: [(texto: String, tono: HojaCompuesta.Tono)] = [
            (notacion.texto(\.notasComunes) + ": " + datos.comunes, .comun), (datos.soloEnOrigen, .origen),
            (datos.soloEnDestino, .destino),
        ].filter { !$0.texto.isEmpty }
        let pentagramas = [(escala, HojaCompuesta.Tono.origen), (otra, .destino)].map { cual, tono in
            HojaCompuesta.Seccion(
                titulo: cual.nombre(en: notacion),
                piezas: [.dibujo(PentagramaPresentado(cual, en: notacion).svg, fraccion: 1)], tono: tono)
        }
        return HojaCompuesta(
            titulo: escala.nombre(en: notacion) + " → " + otra.nombre(en: notacion),
            subtitulos: [datos.distancia ?? ""],
            secciones: pentagramas + [
                .init(titulo: "", piezas: [.tablaMarcada(filas)]),
                .init(
                    titulo: "", piezas: [.leyenda(leyenda), .apartes(datos.cambios)],
                    alLado: [
                        .init(
                            titulo: "", piezas: [.dibujo(Hoja.dibujoSVG(ancho: lado, alto: lado, reloj), fraccion: 1)])
                    ], anchoAlLado: lado),
            ])
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
