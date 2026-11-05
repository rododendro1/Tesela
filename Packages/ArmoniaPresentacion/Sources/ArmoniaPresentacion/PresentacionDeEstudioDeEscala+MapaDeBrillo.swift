import Armonia
import Foundation

extension PresentacionDeEstudioDeEscala {
    // MARK: El mapa de brillo

    /// El mapa de brillo del catálogo (`Escala.mapaDeBrillo`) en SVG: una columna por cada brillo por quintas, de la
    /// más oscura (a la izquierda) a la más brillante, con una caja por escala y una línea entre las que están a una
    /// nota de distancia. La escala `resaltada`, si es del mapa, va en otro color, y el mapa es el de su tónica.
    ///
    ///     let mapa = PresentacionDeEstudioDeEscala.mapaDeBrillo(notacion: .espanolCompacto)
    ///     mapa.hasPrefix("<svg")   // true
    public static func mapaDeBrillo(
        numeroDeNotas: Int = 7, resaltada: Escala? = nil, notacion: Notacion
    ) -> String {
        let tonica = resaltada?.tonica ?? .do
        let mapa = Escala.mapaDeBrillo(tonica: tonica, numeroDeNotas: numeroDeNotas)
        let margen = 20.0
        let anchoDeCaja = 170.0
        let altoDeCaja = 22.0
        let entreColumnas = 40.0
        let entreFilas = 8.0
        let arriba = 82.0

        // Las columnas, una por brillo (con dos decimales), y la fila de cada escala en la suya.
        let brillos = mapa.escalas.map { ($0.estadisticas.brilloPorQuintas * 100).rounded() / 100 }
        let columnas = Array(Set(brillos)).sorted()
        var filasPorColumna = [Double: Int]()
        var cajas: [(x: Double, y: Double)] = []
        for brillo in brillos {
            let columna = Double(columnas.firstIndex(of: brillo) ?? 0)
            let fila = filasPorColumna[brillo, default: 0]
            filasPorColumna[brillo] = fila + 1
            cajas.append(
                (margen + columna * (anchoDeCaja + entreColumnas), arriba + Double(fila) * (altoDeCaja + entreFilas)))
        }
        let numeroDeColumnas = Double(max(columnas.count, 1))
        let ancho = 2 * margen + numeroDeColumnas * anchoDeCaja + (numeroDeColumnas - 1) * entreColumnas
        let filas = Double(filasPorColumna.values.max() ?? 0)
        let alto = arriba + filas * (altoDeCaja + entreFilas) + margen

        var cuerpo: [String] = []
        let titulo = notacion.texto(\.mapaDeBrillo) + " · " + tonica.nombre(en: notacion)
        cuerpo.append(texto(titulo, x: margen, y: margen + 18, tamano: 18, negrita: true))
        for (i, brillo) in columnas.enumerated() {
            let x = margen + Double(i) * (anchoDeCaja + entreColumnas)
            cuerpo.append(texto(conSigno(brillo), x: x, y: arriba - 12, tamano: 13, negrita: true, color: "#555555"))
        }
        // Las líneas, debajo de las cajas: de la derecha de la oscura a la izquierda de la brillante.
        for enlace in mapa.enlaces {
            let desde = cajas[enlace.oscura]
            let hasta = cajas[enlace.brillante]
            let cambio = enlace.de.nombre(en: notacion) + " → " + enlace.a.nombre(en: notacion)
            cuerpo.append(
                "<line x1=\"\(numero(desde.x + anchoDeCaja))\" y1=\"\(numero(desde.y + altoDeCaja / 2))\" "
                    + "x2=\"\(numero(hasta.x))\" y2=\"\(numero(hasta.y + altoDeCaja / 2))\" stroke=\"#9aa5b1\" "
                    + "stroke-width=\"1\"><title>\(EscrituraXML.escapar(cambio))</title></line>")
        }
        let notasResaltadas = resaltada.map { Set($0.notas.map(\.claseDeAltura)) }
        for (escala, caja) in zip(mapa.escalas, cajas) {
            let esLaResaltada = notasResaltadas == Set(escala.notas.map(\.claseDeAltura))
            let relleno = esLaResaltada ? "#ffe8a3" : "#f4f4f4"
            let borde = esLaResaltada ? "#c9a227" : "#bbbbbb"
            let notas = escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
            cuerpo.append(
                "<g><title>\(EscrituraXML.escapar(escala.nombre(en: notacion) + ": " + notas))</title>"
                    + "<rect x=\"\(numero(caja.x))\" y=\"\(numero(caja.y))\" width=\"\(numero(anchoDeCaja))\" "
                    + "height=\"\(numero(altoDeCaja))\" rx=\"4\" fill=\"\(relleno)\" stroke=\"\(borde)\"/>"
                    + texto(escala.tipo.nombre(en: notacion), x: caja.x + 8, y: caja.y + 15, tamano: 11) + "</g>")
        }
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
            + "viewBox=\"0 0 \(numero(ancho)) \(numero(alto))\" font-family=\"Helvetica, Arial, sans-serif\">"
        let fondo = "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }
}
