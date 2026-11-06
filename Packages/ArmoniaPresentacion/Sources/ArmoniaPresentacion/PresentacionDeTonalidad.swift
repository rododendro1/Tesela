import Armonia
import Foundation

/// Una cadencia típica de una tonalidad: su nombre, sus grados y sus acordes.
public struct CadenciaPresentada: Hashable, Sendable {
    /// «cadencia auténtica».
    public let nombre: String
    /// «V7–I».
    public let grados: String
    /// «Sol7 – Do».
    public let acordes: String
    public let sonido: Escucha
}

/// Lo que se estudia de una tonalidad (`armonia hoja --tonalidad` y la vista de análisis): la armadura, sus
/// relativas, los acordes de cada grado con su función, las cadencias típicas y las modulaciones a los tonos
/// vecinos. No usa SwiftUI, así que se prueba en Linux.
///
///     let cadencias = PresentacionDeTonalidad.cadenciasTipicas(de: Tonalidad(.do), notacion: .espanolCompacto)
///     cadencias.first?.acordes   // "Sol7 – Do"
public enum PresentacionDeTonalidad {
    /// «Armadura: Si♭ Mi♭ La♭», o «Armadura: sin alteraciones».
    public static func armadura(de tonalidad: Tonalidad, notacion: Notacion) -> String {
        let signos = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }.joined(separator: " ")
        return notacion.texto(\.armadura) + ": " + (signos.isEmpty ? notacion.texto(\.sinAlteraciones) : signos)
    }

    /// «Relativa: La menor · Homónima: Do menor».
    public static func relativas(de tonalidad: Tonalidad, notacion: Notacion) -> String {
        notacion.texto(\.relativa) + ": " + tonalidad.relativa.nombre(en: notacion) + " · "
            + notacion.texto(\.homonima) + ": " + tonalidad.homonima.nombre(en: notacion)
    }

    /// Las cuatro cadencias de manual en la tonalidad: auténtica (V7–I), plagal (IV–I), rota (V7–vi) y
    /// semicadencia (ii–V; en menor, iv–V), con el nombre que les da el análisis.
    public static func cadenciasTipicas(de tonalidad: Tonalidad, notacion: Notacion) -> [CadenciaPresentada] {
        let romanos =
            tonalidad.modo == .mayor
            ? ["V7 I", "IV I", "V7 vi", "ii V"] : ["V7 i", "iv i", "V7 VI", "iv V"]
        return romanos.compactMap { texto in
            guard let acordes = try? tonalidad.acordes(romanos: texto), acordes.count == 2,
                let cadencia = tonalidad.analizar(acordes).cadencias.first
            else { return nil }
            return CadenciaPresentada(
                nombre: cadencia.nombre(en: notacion),
                grados: texto.split(separator: " ").joined(separator: "–"),
                acordes: acordes.map { $0.cifrado(en: notacion) }.joined(separator: " – "),
                sonido: Escucha.acordes(acordes).conTonica(tonalidad.tonica))
        }
    }

    /// La hoja de estudio de la tonalidad, para imprimir: un SVG del ancho de un A4 con la armadura y las relativas,
    /// el pentagrama de su escala, los acordes de cada grado (cuatríadas) con su función, las cadencias típicas y
    /// las modulaciones a los tonos vecinos.
    ///
    ///     let hoja = PresentacionDeTonalidad.hojaDeEstudio(de: Tonalidad(.re), notacion: .espanolCompacto)
    ///     hoja.contains(">Re mayor</text>")   // true
    public static func hojaDeEstudio(de tonalidad: Tonalidad, notacion: Notacion) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen + 22
        cuerpo.append(Hoja.texto(tonalidad.nombre(en: notacion), x: margen, y: y, tamano: 22, negrita: true))
        y += 22
        cuerpo.append(Hoja.texto(armadura(de: tonalidad, notacion: notacion), x: margen, y: y, tamano: 12))
        y += 18
        cuerpo.append(
            Hoja.texto(relativas(de: tonalidad, notacion: notacion), x: margen, y: y, tamano: 12, color: "#555555"))
        y += 12

        // La escala de la tonalidad en el pentagrama.
        let pentagrama = PentagramaPresentado(tonalidad.escala, notacion: notacion).svg
        y += Hoja.incrustar(pentagrama, x: margen, y: y, ancho: util, en: &cuerpo) + 8

        // Los acordes de cada grado, en columnas: el cifrado romano, el acorde y su función.
        func seccion(_ titulo: String) {
            cuerpo.append(Hoja.texto(titulo, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
        }
        seccion(notacion.texto(\.acordesDeLaEscala))
        let acordes = tonalidad.armonizar(cuatriadas: true)
        let analizados = tonalidad.analizar(acordes).acordes
        let columna = util / Double(max(acordes.count, 1))
        for (i, acorde) in acordes.enumerated() {
            let x = margen + Double(i) * columna
            let funcion = i < analizados.count ? analizados[i].funcion?.nombre(en: notacion) ?? "" : ""
            let romano = tonalidad.cifradoRomano(grado: i + 1, cuatriada: true)
            cuerpo.append(Hoja.texto(romano, x: x, y: y, tamano: 12, negrita: true))
            cuerpo.append(Hoja.texto(acorde.cifrado(en: notacion), x: x, y: y + 16, tamano: 12))
            cuerpo.append(Hoja.texto(funcion, x: x, y: y + 31, tamano: 9, color: "#666666"))
        }
        y += 48

        // Las cadencias típicas.
        seccion(notacion.texto(\.cadenciasTipicas))
        for cadencia in cadenciasTipicas(de: tonalidad, notacion: notacion) {
            cuerpo.append(Hoja.texto(cadencia.nombre, x: margen, y: y, tamano: 11, negrita: true))
            cuerpo.append(Hoja.texto(cadencia.grados, x: margen + 190, y: y, tamano: 11))
            cuerpo.append(Hoja.texto(cadencia.acordes, x: margen + 270, y: y, tamano: 11))
            y += 17
        }
        y += 8

        // Las modulaciones a los tonos vecinos, cada una con la progresión y el pivote.
        seccion(notacion.texto(\.modulaciones))
        for modulacion in PresentacionDeModulaciones.modulaciones(desde: tonalidad, notacion: notacion) {
            let titulo = modulacion.destino + " · " + modulacion.tecnica
            cuerpo.append(Hoja.texto(titulo, x: margen, y: y, tamano: 11, negrita: true))
            y += 15
            cuerpo.append(Hoja.texto(modulacion.acordes, x: margen + 12, y: y, tamano: 11))
            y += 15
            if let pivote = modulacion.pivote {
                cuerpo.append(Hoja.texto(pivote, x: margen + 12, y: y, tamano: 10, color: "#666666"))
                y += 15
            }
            y += 4
        }

        let alto = (y + margen).rounded(.up)
        let cabecera =
            "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(Hoja.numero(ancho))\" height=\"\(Hoja.numero(alto))\" "
            + "viewBox=\"0 0 \(Hoja.numero(ancho)) \(Hoja.numero(alto))\" font-family=\"Helvetica, Arial, sans-serif\">"
        let fondo = "<rect width=\"100%\" height=\"100%\" fill=\"#ffffff\"/>"
        return ([cabecera, fondo] + cuerpo + ["</svg>"]).joined(separator: "\n")
    }
}
