import Elementos
import Teoria

// Lo que mide el dibujo de un pentagrama: el ancho que piden los cifrados y los nombres de un acorde, y las medidas
// verticales, con las filas de etiquetas y el bajo cifrado de debajo.

extension PentagramaSVG {
    /// Dónde acaba el pentagrama y cuánto se desplazan las notas para que quepan los textos.
    struct AjusteAlTexto {
        let desplazamiento: Double
        let final: Double
    }

    /// Un cifrado o los nombres de un acorde pueden ser más anchos que el acorde: el pentagrama se alarga a la
    /// derecha y, si el texto sobresale por la izquierda, las notas se desplazan.
    func ajusteAlTexto(_ maquetacion: Maquetacion, final: Double) -> AjusteAlTexto {
        let anchoDelTexto = anchoDeLosTextos(maquetacion)
        let centroDelTexto = maquetacion.cifradoX ?? 0
        let desplazamiento = max(0, anchoDelTexto / 2 + 0.2 - centroDelTexto)
        return AjusteAlTexto(
            desplazamiento: desplazamiento,
            final: max(final + desplazamiento, centroDelTexto + desplazamiento + anchoDelTexto / 2 + 0.6, finalMinimo))
    }

    /// Lo que mide el texto más ancho de encima o de debajo del acorde: el cifrado y, si hay una sola columna, su
    /// primera etiqueta o su primer intervalo.
    func anchoDeLosTextos(_ maquetacion: Maquetacion) -> Double {
        let proporcion = opciones.maquetacion.anchoDeLosCaracteres
        func ancho(_ texto: String, cuerpoDeLetra: Double) -> Double {
            PentagramaSVG.anchoEstimado(texto, cuerpoDeLetra: cuerpoDeLetra, proporcion: proporcion)
        }
        let delCifrado = [cifrado, cifrados[0]].compactMap { $0 }.map {
            ancho($0, cuerpoDeLetra: PentagramaSVG.letraDelCifrado)
        }
        let deLasEtiquetas =
            columnas.count == 1
            ? (maquetacion.etiquetas.prefix(1) + maquetacion.intervalos.prefix(1)).map {
                ancho($0.texto, cuerpoDeLetra: PentagramaSVG.letraDeLasEtiquetas)
            } : []
        return (delCifrado + deLasEtiquetas).max() ?? 0
    }

    /// Las medidas verticales del dibujo, del punto más alto al más bajo.
    struct MedidasVerticales {
        /// Lo más alto y lo más bajo de las claves, las alteraciones y las notas.
        let minimoY: Double
        let maximoY: Double
        /// Donde empieza el dibujo, con sitio para el cifrado si lo hay.
        let cima: Double
        /// Donde acaba, debajo de la última fila de textos.
        let fondo: Double
        let yDeLosGrados: Double
        let yDelBajoCifrado: Double
    }

    /// Debajo, una fila por cada clase de etiqueta: los nombres y los intervalos (los grados van en la suya).
    func filasDeEtiquetas(_ maquetacion: Maquetacion) -> Int {
        (opciones.marcas.nombresDeLasNotas ? 1 : 0) + (maquetacion.intervalos.isEmpty ? 0 : 1)
    }

    /// Las medidas verticales: encima, el cifrado; debajo, las filas de etiquetas, los grados y el bajo cifrado, con
    /// las cifras una encima de otra.
    func medidasVerticales(_ maquetacion: Maquetacion, minimoY: Double, maximoY: Double) -> MedidasVerticales {
        let cima = cifrado == nil && maquetacion.cifrados.isEmpty ? minimoY - 0.4 : minimoY - 2.6
        let filas = filasDeEtiquetas(maquetacion)
        let yDeLosGrados = maximoY + (filas == 0 ? 2.0 : 2.0 + 1.5 * Double(filas))
        // El bajo cifrado, debajo de los grados (o donde irían).
        let yDelBajoCifrado = maquetacion.grados.isEmpty ? yDeLosGrados - 0.2 : yDeLosGrados + 1.6
        let cifrasPorColumna = maquetacion.bajoCifrado.map(\.cifras.count).max() ?? 0
        let fondo: Double
        if cifrasPorColumna > 0 {
            fondo = yDelBajoCifrado + PentagramaSVG.separacionDelBajoCifrado * Double(cifrasPorColumna - 1) + 0.6
        } else if !maquetacion.grados.isEmpty {
            fondo = yDeLosGrados + 0.6
        } else {
            fondo = filas == 0 ? maximoY + 0.4 : maximoY + 2.4 + 1.5 * Double(filas - 1)
        }
        return MedidasVerticales(
            minimoY: minimoY, maximoY: maximoY, cima: cima, fondo: fondo, yDeLosGrados: yDeLosGrados,
            yDelBajoCifrado: yDelBajoCifrado)
    }
}
