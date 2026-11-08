import Armonia
import Foundation

/// Una parte de la hoja de estudio de una escala, para elegir cuáles lleva: el nombre y las notas van siempre.
public enum SeccionDeLaHoja: String, CaseIterable, Hashable, Sendable {
    case pentagrama, estadisticas, reloj, teclados, acordes, escalera

    /// Su título, en la notación: «Pentagrama», «Reloj de la escala», «Digitación de piano»…
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .pentagrama: notacion.texto(\.pentagrama)
        case .estadisticas: notacion.texto(\.estadisticas)
        case .reloj: notacion.texto(\.relojDeLaEscala)
        case .teclados: notacion.texto(\.digitacionDePiano)
        case .acordes: notacion.texto(\.acordesDeLaEscala)
        case .escalera: notacion.texto(\.escaleraDeBrillo)
        }
    }
}

extension PresentacionDeEstudioDeEscala {
    // MARK: La hoja de estudio

    /// Ancho de la hoja (el de un A4 en puntos) y su margen.
    static let anchoDeLaHoja = 595.0
    static let margenDeLaHoja = 40.0

    /// Una hoja de estudio de la escala, para imprimir: un SVG del ancho de un A4 con el nombre y las notas, el
    /// pentagrama, el teclado de piano con los dedos de cada mano, el reloj, las estadísticas, los acordes de sus
    /// grados y la escalera de brillo, o solo las `secciones` que se pidan. El alto es el que ocupa.
    /// `armonia grabar hoja Do mayor` la pasa a PDF.
    ///
    ///     let hoja = PresentacionDeEstudioDeEscala.hojaDeEstudio(
    ///         de: Escala(.re, .dorico), en: .compacta(.espanol))
    ///     hoja.hasPrefix("<svg")   // true
    public static func hojaDeEstudio(
        de escala: Escala, en notacion: Notacion, secciones: Set<SeccionDeLaHoja> = Set(SeccionDeLaHoja.allCases)
    ) -> String {
        let ancho = anchoDeLaHoja
        let margen = margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen

        // El nombre y las notas.
        y += 22
        cuerpo.append(texto(escala.nombre(en: notacion), x: margen, y: y, tamano: 24, negrita: true))
        y += 20
        let notas = escala.notas.map { $0.nombre(en: notacion) }.joined(separator: " ")
        cuerpo.append(texto(notas, x: margen, y: y, tamano: 13, color: "#555555"))
        y += 16

        // El pentagrama, de lado a lado.
        if secciones.contains(.pentagrama) {
            let pentagrama = PentagramaPresentado(escala, notacion: notacion).svg
            y += incrustar(pentagrama, x: margen, y: y, ancho: util, en: &cuerpo) + 12
        }

        // Las estadísticas, a la izquierda, y el reloj, a la derecha (o solo uno de los dos).
        if secciones.contains(.estadisticas) || secciones.contains(.reloj) {
            let ladoDelReloj = 170.0
            y += 4
            var lineas = y
            if secciones.contains(.estadisticas) {
                cuerpo.append(texto(notacion.texto(\.estadisticas), x: margen, y: y + 12, tamano: 14, negrita: true))
                lineas += 32
                for dato in estadisticas(de: escala, en: notacion) {
                    cuerpo.append(texto(dato.nombre + ": " + dato.valor, x: margen, y: lineas, tamano: 11))
                    lineas += 16
                }
            }
            var altoDelReloj = 0.0
            if secciones.contains(.reloj) {
                let reloj = self.reloj(de: escala, en: notacion)
                let x = secciones.contains(.estadisticas) ? ancho - margen - ladoDelReloj : margen
                altoDelReloj = incrustar(reloj, x: x, y: y, ancho: ladoDelReloj, en: &cuerpo)
            }
            y = max(lineas, y + altoDelReloj) + 12
        }

        // El teclado de cada mano, uno al lado del otro.
        if secciones.contains(.teclados) {
            let separacion = 15.0
            let anchoDelTeclado = (util - separacion) / 2
            var altoDeLosTeclados = 0.0
            for (i, mano) in Mano.allCases.enumerated() {
                let teclado = self.teclado(de: escala, mano: mano, en: notacion)
                let x = margen + Double(i) * (anchoDelTeclado + separacion)
                let alto = incrustar(teclado, x: x, y: y, ancho: anchoDelTeclado, en: &cuerpo)
                altoDeLosTeclados = max(altoDeLosTeclados, alto)
            }
            y += altoDeLosTeclados + 16
        }

        // Los acordes de cada grado, si los forma.
        if secciones.contains(.acordes), let acordes = DatosDeEscala(escala, notacion: notacion).acordes {
            cuerpo.append(texto(notacion.texto(\.acordesDeLaEscala), x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            for fila in filas(acordes.map { $0.grado + " " + $0.cifrado }, porFila: 4) {
                cuerpo.append(texto(fila, x: margen, y: y, tamano: 11))
                y += 16
            }
            y += 8
        }

        // La escalera de brillo, de la más oscura a la más brillante.
        let peldanos = secciones.contains(.escalera) ? escaleraDeBrillo(de: escala, en: notacion) : []
        if peldanos.count > 1 {
            cuerpo.append(texto(notacion.texto(\.escaleraDeBrillo), x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            let escritos = peldanos.map { ($0.esLaDePartida ? "▸ " : "") + $0.brillo + " " + $0.nombre }
            for fila in filas(escritos, porFila: 3) {
                cuerpo.append(texto(fila, x: margen, y: y, tamano: 11))
                y += 16
            }
        }
        let alto = (y + margen).rounded(.up)
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
            + "viewBox=\"0 0 \(numero(ancho)) \(numero(alto))\" font-family=\"Helvetica, Arial, sans-serif\">"
        let fondo = "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }

    /// Los elementos de una lista en filas de `porFila`, separados por « · ».
    private static func filas(_ elementos: [String], porFila: Int) -> [String] {
        stride(from: 0, to: elementos.count, by: porFila).map {
            elementos[$0..<min($0 + porFila, elementos.count)].joined(separator: " · ")
        }
    }

    static func texto(
        _ contenido: String, x: Double, y: Double, tamano: Double, negrita: Bool = false, color: String = "#222222"
    ) -> String {
        "<text x=\"\(numero(x))\" y=\"\(numero(y))\" font-size=\"\(numero(tamano))\" fill=\"\(color)\""
            + (negrita ? " font-weight=\"bold\"" : "") + ">" + EscrituraXML.escapar(contenido) + "</text>"
    }

    /// Mete un SVG dentro de la hoja, en `x`, `y` y con ese ancho, como un `<svg>` anidado con su `viewBox`; da el
    /// alto que ocupa (0 si no se puede leer).
    static func incrustar(_ svg: String, x: Double, y: Double, ancho: Double, en cuerpo: inout [String]) -> Double {
        guard let raiz = svg.range(of: "<svg"),
            let finDeLaRaiz = svg[raiz.upperBound...].firstIndex(of: ">"),
            let cierre = svg.range(of: "</svg>", options: .backwards),
            let caja = cajaDeVision(svg)
        else { return 0 }
        let alto = ancho * caja.alto / caja.ancho
        let dentro = svg[svg.index(after: finDeLaRaiz)..<cierre.lowerBound]
        cuerpo.append(
            "<svg x=\"\(numero(x))\" y=\"\(numero(y))\" width=\"\(numero(ancho))\" height=\"\(numero(alto))\" "
                + "viewBox=\"\(caja.texto)\">" + dentro + "</svg>")
        return alto
    }

    /// El ancho y el alto de un SVG por su `viewBox`, para mostrar la hoja con su proporción; `nil` si no lo tiene.
    ///
    ///     PresentacionDeEstudioDeEscala.tamano(deUnSVG: "<svg viewBox=\"0 0 595 800\"></svg>")?.alto   // 800
    public static func tamano(deUnSVG svg: String) -> (ancho: Double, alto: Double)? {
        cajaDeVision(svg).map { ($0.ancho, $0.alto) }
    }

    /// El `viewBox` de un SVG: su texto, su ancho y su alto.
    private static func cajaDeVision(_ svg: String) -> (texto: String, ancho: Double, alto: Double)? {
        guard let inicio = svg.range(of: "viewBox=\""),
            let fin = svg[inicio.upperBound...].firstIndex(of: "\"")
        else { return nil }
        let texto = String(svg[inicio.upperBound..<fin])
        let numeros = texto.split(whereSeparator: { $0 == " " || $0 == "," }).compactMap { Double($0) }
        guard numeros.count == 4, numeros[2] > 0, numeros[3] > 0 else { return nil }
        return (texto, numeros[2], numeros[3])
    }

    /// Con un decimal como mucho: «40», «12.5».
    static func numero(_ valor: Double) -> String {
        let redondeado = (valor * 10).rounded() / 10
        return redondeado == redondeado.rounded() ? String(Int(redondeado)) : String(redondeado)
    }
}
