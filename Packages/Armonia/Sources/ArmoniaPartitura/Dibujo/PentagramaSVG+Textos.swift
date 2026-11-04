import ArmoniaNucleo
import ArmoniaTeoria
import Foundation

// Las líneas de los pentagramas y de la tablatura, las barras del principio y del final, y los textos de encima y de
// debajo.

extension PentagramaSVG {
    /// Las líneas de los pentagramas y de la tablatura y las barras del principio y del final, que no se desplazan
    /// con las notas.
    func lineasDelSistema(
        pentagramas: Int, tablatura: TablaturaColocada?, barrasDeCompas: [Double], final: Double,
        desplazamiento: Double
    ) -> [String] {
        var lineas: [String] = []
        for k in 0..<pentagramas {
            for i in 0..<5 {
                let y = PentagramaSVG.y(deLugar: 8 - 2 * i, pentagrama: k)
                lineas.append(linea(desde: 0, hasta: final, y: y, grosor: "0.13"))
            }
        }
        // Las líneas de la tablatura, cortadas alrededor de los números (que van corridos con las notas), y sus barras.
        if let tablatura {
            for fila in tablatura.lineas {
                var desde = 0.0
                for hueco in fila.huecos.sorted(by: { $0.0 < $1.0 }) {
                    let (a, b) = (hueco.0 + desplazamiento, hueco.1 + desplazamiento)
                    if a > desde { lineas.append(linea(desde: desde, hasta: a, y: fila.y, grosor: "0.13")) }
                    desde = max(desde, b)
                }
                if final > desde { lineas.append(linea(desde: desde, hasta: final, y: fila.y, grosor: "0.13")) }
            }
            for xDeLaBarra in [0, final] + (ritmo != nil && conBarraFinal ? [final - 0.25, final - 0.95] : [])
                + barrasDeCompas.map({ $0 + desplazamiento })
            {
                let grosor = ritmo != nil && conBarraFinal && xDeLaBarra == final - 0.25 ? "0.5" : "0.16"
                lineas.append(
                    elemento("line").con("x1", xDeLaBarra).con("y1", tablatura.arriba).con("x2", xDeLaBarra)
                        .con("y2", tablatura.abajo).con("stroke-width", grosor).vacio)
            }
        }
        // Barra del principio (si hay dos pentagramas, una sola que los une) y barra final.
        let abajoDelSistema = PentagramaSVG.y(deLugar: 0, pentagrama: pentagramas - 1)
        for xDeLaBarra in [0, final] {
            lineas.append(
                elemento("line").con("x1", xDeLaBarra).con("y1", 0).con("x2", xDeLaBarra).con("y2", abajoDelSistema)
                    .con("stroke-width", "0.16").vacio)
        }
        // Con ritmo, al final, la barra doble: fina y gruesa.
        if ritmo != nil && conBarraFinal {
            lineas.append(
                elemento("line").con("x1", final - 0.25).con("y1", 0).con("x2", final - 0.25)
                    .con("y2", abajoDelSistema).con("stroke-width", "0.5").vacio)
            lineas.append(
                elemento("line").con("x1", final - 0.95).con("y1", 0).con("x2", final - 0.95)
                    .con("y2", abajoDelSistema).con("stroke-width", "0.16").vacio)
        }
        return lineas
    }

    /// Un texto centrado en `x`, estirado o encogido a lo que se calcula que mide.
    func textoCentrado(_ texto: String, x: Double, y: Double, cuerpoDeLetra: Double) -> String {
        elemento("text").con("x", x).con("y", y).con("text-anchor", "middle").con("font-size", cuerpoDeLetra)
            .con("lengthAdjust", "spacingAndGlyphs")
            .con(
                "textLength",
                PentagramaSVG.anchoEstimado(
                    texto, cuerpoDeLetra: cuerpoDeLetra, proporcion: opciones.anchoDeLosCaracteres)
            )
            .con("font-family", "sans-serif").conTexto(texto)
    }

    /// Los cifrados, encima, y los nombres, los intervalos, los grados y el bajo cifrado, debajo.
    func textosDelSistema(
        _ maquetacion: Maquetacion, minimoY: Double, maximoY: Double, yDeLosGrados: Double, yDelBajoCifrado: Double
    ) -> [String] {
        var textos: [String] = []
        if let cifrado, let cx = maquetacion.cifradoX {
            let letra = PentagramaSVG.letraDelCifrado
            textos.append(textoCentrado(cifrado, x: cx, y: minimoY - 0.6, cuerpoDeLetra: letra))
        }
        for cifrado in maquetacion.cifrados {
            let letra = PentagramaSVG.letraDelCifrado
            textos.append(textoCentrado(cifrado.texto, x: cifrado.x, y: minimoY - 0.6, cuerpoDeLetra: letra))
        }
        for etiqueta in maquetacion.etiquetas {
            let letra = PentagramaSVG.letraDeLasEtiquetas
            textos.append(textoCentrado(etiqueta.texto, x: etiqueta.x, y: maximoY + 1.6, cuerpoDeLetra: letra))
        }
        let yDeLosIntervalos = maximoY + 1.6 + (opciones.nombresDeLasNotas ? 1.5 : 0)
        for intervalo in maquetacion.intervalos {
            let letra = PentagramaSVG.letraDeLasEtiquetas
            textos.append(textoCentrado(intervalo.texto, x: intervalo.x, y: yDeLosIntervalos, cuerpoDeLetra: letra))
        }
        for grado in maquetacion.grados {
            let letra = PentagramaSVG.letraDeLosGrados
            textos.append(textoCentrado(grado.texto, x: grado.x, y: yDeLosGrados, cuerpoDeLetra: letra))
        }
        for columna in maquetacion.bajoCifrado {
            for (i, cifra) in columna.cifras.enumerated() {
                let y = yDelBajoCifrado + PentagramaSVG.separacionDelBajoCifrado * Double(i)
                let letra = PentagramaSVG.letraDelBajoCifrado
                textos.append(textoCentrado(cifra, x: columna.x, y: y, cuerpoDeLetra: letra))
            }
        }
        return textos
    }
}
