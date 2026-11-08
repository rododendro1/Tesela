import Armonia
import Foundation

extension PresentacionDeAnalisis {
    // MARK: La hoja de estudio de una progresión

    /// Una hoja de estudio de la progresión, para imprimir: un SVG del ancho de un A4 con los acordes y su
    /// tonalidad, el pentagrama con una disposición de cada uno (la `disposicion`, o cerrada si no se puede), el
    /// análisis (grado, función y escala de cada acorde, con las modulaciones), la conducción de las voces, las
    /// cadencias y las líneas de notas guía con su pentagrama. El alto es el que ocupa. `armonia grabar hoja
    /// --acordes …` la pasa a PDF.
    ///
    ///     let analisis = try PresentacionDeAnalisis.analizar("Rem7 Sol7 Do7M", notacion: .compacta(.espanol))
    ///     let hoja = PresentacionDeAnalisis.hojaDeEstudio(analisis, en: .compacta(.espanol))
    ///     hoja.hasPrefix("<svg")   // true
    public static func hojaDeEstudio(
        _ analisis: AnalisisPresentado, disposicion: DisposicionDeAcorde = .drop2, en notacion: Notacion
    ) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen

        // Los acordes y la tonalidad.
        let cifrados = analisis.acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – ")
        y += 22
        cuerpo.append(Hoja.texto(cifrados, x: margen, y: y, tamano: 22, negrita: true))
        y += 20
        cuerpo.append(Hoja.texto(analisis.titulo, x: margen, y: y, tamano: 13, color: "#555555"))
        y += 16

        // El pentagrama con una disposición de cada acorde, la que se pide o, si no se puede, cerrada.
        let dispuesta =
            PresentacionDeDisposiciones.progresion(analisis.acordes, disposicion, en: notacion)
            ?? PresentacionDeDisposiciones.progresion(analisis.acordes, .cerrada, en: notacion)
        if let dispuesta {
            y += Hoja.incrustar(dispuesta.pentagrama.svg, x: margen, y: y, ancho: util, en: &cuerpo) + 12
        }

        // El análisis: cifrado, grado, función y escala, con la modulación que abre cada tramo.
        cuerpo.append(Hoja.texto(notacion.texto(\.analisis), x: margen, y: y + 12, tamano: 14, negrita: true))
        y += 32
        let columnas = [margen, margen + 90, margen + 180, margen + 300]
        for tramo in analisis.tramos {
            if let cabecera = tramo.cabecera {
                cuerpo.append(Hoja.texto(cabecera, x: margen, y: y, tamano: 11, negrita: true, color: "#555555"))
                y += 16
            }
            for fila in tramo.filas {
                let celdas = [fila.cifrado, fila.grado, fila.funcion, fila.escala?.nombre ?? ""]
                for (x, celda) in zip(columnas, celdas) where !celda.isEmpty {
                    cuerpo.append(Hoja.texto(celda, x: x, y: y, tamano: 11))
                }
                y += 16
            }
        }
        y += 8

        // La conducción de las voces, paso a paso, en la misma disposición que el pentagrama.
        if let voces = conduccion(analisis.acordes, disposicion: disposicion, en: notacion) {
            let titulo = notacion.texto(\.conduccionDeVoces) + " · " + voces.disposicion
            cuerpo.append(Hoja.texto(titulo, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            for paso in voces.pasos {
                let encabezado = paso.titulo + " · " + paso.comunes
                cuerpo.append(Hoja.texto(encabezado, x: margen, y: y, tamano: 11, negrita: true))
                y += 15
                cuerpo.append(Hoja.texto(paso.voces.joined(separator: " · "), x: margen + 12, y: y, tamano: 10))
                y += 17
            }
            cuerpo.append(Hoja.texto(voces.movimientoTotal, x: margen, y: y, tamano: 11, color: "#555555"))
            y += 24
        }

        // Las cadencias, si las hay.
        if !analisis.cadencias.isEmpty {
            cuerpo.append(Hoja.texto(notacion.texto(\.cadencias), x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            for cadencia in analisis.cadencias {
                cuerpo.append(Hoja.texto(cadencia, x: margen, y: y, tamano: 11))
                y += 16
            }
            y += 8
        }

        // Las líneas de notas guía, cada una con sus notas y su pentagrama.
        let lineas = PresentacionDeEstudioDeEscala.lineasDeNotasGuia(
            analisis.acordes, tonalidad: analisis.tonalidad, en: notacion)
        if !lineas.isEmpty {
            let titulo = notacion.texto(\.lineasDeNotasGuia)
            cuerpo.append(Hoja.texto(titulo, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
            for linea in lineas {
                cuerpo.append(Hoja.texto(linea.titulo + ": " + linea.notas, x: margen, y: y, tamano: 11))
                y += 6
                y += Hoja.incrustar(linea.pentagrama.svg, x: margen, y: y, ancho: util, en: &cuerpo) + 10
            }
        }
        let alto = (y + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: alto, cuerpo)
    }
}
