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

/// Un acorde de fuera de la tonalidad que se usa en ella: una dominante secundaria con el acorde al que va, o un
/// acorde prestado del modo homónimo.
public struct AcordeDeFueraPresentado: Hashable, Sendable {
    /// «V7/ii», «♭VImaj7».
    public let grados: String
    /// «La7 – Rem», «La♭maj7».
    public let acordes: String
    public let sonido: Escucha
}

/// Lo que se estudia de una tonalidad (`armonia hoja tonalidad` y la vista de análisis): la armadura, sus
/// relativas, los acordes de cada grado con su función, las cadencias típicas y las modulaciones a los tonos
/// vecinos. No usa SwiftUI, así que se prueba en Linux.
///
///     let cadencias = PresentacionDeTonalidad.cadenciasTipicas(de: Tonalidad(.do), en: .compacta(.espanol))
///     cadencias.first?.acordes   // "Sol7 – Do"
public enum PresentacionDeTonalidad {
    /// «Armadura: Si♭ Mi♭ La♭», o «Armadura: sin alteraciones».
    public static func armadura(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        let signos = tonalidad.notasDeLaArmadura.map { $0.nombre(en: notacion) }.joined(separator: " ")
        return notacion.texto(\.armadura) + ": " + (signos.isEmpty ? notacion.texto(\.sinAlteraciones) : signos)
    }

    /// «Relativa: La menor · Homónima: Do menor».
    public static func relativas(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        notacion.texto(\.relativa) + ": " + tonalidad.relativa.nombre(en: notacion) + " · "
            + notacion.texto(\.homonima) + ": " + tonalidad.homonima.nombre(en: notacion)
    }

    /// Las cuatro cadencias de manual en la tonalidad: auténtica (V7–I), plagal (IV–I), rota (V7–vi) y
    /// semicadencia (ii–V; en menor, iv–V), con el nombre que les da el análisis.
    public static func cadenciasTipicas(de tonalidad: Tonalidad, en notacion: Notacion) -> [CadenciaPresentada] {
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

    /// Las dominantes secundarias de la tonalidad: la séptima de dominante de cada grado que forma una tríada mayor o
    /// menor, salvo la tónica (V7/ii, V7/iii, V7/IV, V7/V y V7/vi en mayor), con el acorde al que va.
    ///
    ///     let dominantes = PresentacionDeTonalidad.dominantesSecundarias(de: Tonalidad(.do), en: .compacta(.espanol))
    ///     dominantes.first?.acordes   // "La7 – Rem"
    public static func dominantesSecundarias(
        de tonalidad: Tonalidad, en notacion: Notacion
    ) -> [AcordeDeFueraPresentado] {
        (2...7).compactMap { grado in
            guard let acorde = tonalidad.acorde(grado: grado), acorde.tipo == .mayor || acorde.tipo == .menor,
                let romano = tonalidad.romano(grado: grado)
            else { return nil }
            let dominante = Acorde(acorde.fundamental + .quintaJusta, .dominanteSeptima)
            return AcordeDeFueraPresentado(
                grados: "V7/" + romano.description,
                acordes: dominante.cifrado(en: notacion) + " – " + acorde.cifrado(en: notacion),
                sonido: Escucha.acordes([dominante, acorde]).conTonica(tonalidad.tonica))
        }
    }

    /// Los acordes prestados del modo homónimo: los de sus grados (cuatríadas) que no son los de la tonalidad. En
    /// mayor, los del menor natural, con su grado alterado respecto al mayor (iiø7, ♭IIImaj7, iv7, v7, ♭VImaj7,
    /// ♭VII7…); en menor, los del mayor.
    ///
    ///     let prestados = PresentacionDeTonalidad.acordesPrestados(de: Tonalidad(.do), en: .compacta(.espanol))
    ///     prestados.map(\.grados).contains("♭VImaj7")   // true
    public static func acordesPrestados(de tonalidad: Tonalidad, en notacion: Notacion) -> [AcordeDeFueraPresentado] {
        let homonima = tonalidad.homonima
        return (1...7).compactMap { grado in
            // En mayor, del menor natural (`escala`), no del armónico, que tiene la misma dominante.
            let delGrado =
                tonalidad.modo == .mayor
                ? homonima.escala.acorde(grado: grado, deNotas: 4) : homonima.acorde(grado: grado, deNotas: 4)
            guard let prestado = delGrado,
                prestado != tonalidad.acorde(grado: grado, deNotas: 4),
                let romano =
                    tonalidad.modo == .mayor
                    ? homonima.escala.romano(grado: grado, deNotas: 4, referencia: .mayor)
                    : homonima.romano(grado: grado, deNotas: 4)
            else { return nil }
            return AcordeDeFueraPresentado(
                grados: romano.description, acordes: prestado.cifrado(en: notacion),
                sonido: Escucha.acordes([prestado]).conTonica(tonalidad.tonica))
        }
    }

    /// La hoja de estudio de la tonalidad, para imprimir: un SVG del ancho de un A4 con la armadura y las relativas,
    /// el pentagrama de su escala, los acordes de cada grado (cuatríadas) con su función, las cadencias típicas, las
    /// modulaciones a los tonos vecinos, las dominantes secundarias, los acordes prestados del modo homónimo y lo
    /// que dicen las fuentes de su carácter.
    ///
    ///     let hoja = PresentacionDeTonalidad.hojaDeEstudio(de: Tonalidad(.re), en: .compacta(.espanol))
    ///     hoja.contains(">Re mayor</text>")   // true
    public static func hojaDeEstudio(de tonalidad: Tonalidad, en notacion: Notacion) -> String {
        typealias Hoja = PresentacionDeEstudioDeEscala
        let ancho = Hoja.anchoDeLaHoja
        let margen = Hoja.margenDeLaHoja
        let util = ancho - 2 * margen
        var cuerpo: [String] = []
        var y = margen + 22
        cuerpo.append(Hoja.texto(tonalidad.nombre(en: notacion), x: margen, y: y, tamano: 22, negrita: true))
        y += 22
        cuerpo.append(Hoja.texto(armadura(de: tonalidad, en: notacion), x: margen, y: y, tamano: 12))
        y += 18
        cuerpo.append(
            Hoja.texto(relativas(de: tonalidad, en: notacion), x: margen, y: y, tamano: 12, color: "#555555"))
        y += 12

        // La escala de la tonalidad en el pentagrama.
        let pentagrama = PentagramaPresentado(tonalidad.escala, en: notacion).svg
        y += Hoja.incrustar(pentagrama, x: margen, y: y, ancho: util, en: &cuerpo) + 8

        // Los acordes de cada grado, en columnas: el cifrado romano, el acorde y su función.
        func seccion(_ titulo: String) {
            cuerpo.append(Hoja.texto(titulo, x: margen, y: y + 12, tamano: 14, negrita: true))
            y += 32
        }
        seccion(notacion.texto(\.acordesDeLaEscala))
        let acordes = tonalidad.acordesDeLosGrados(deNotas: 4).compactMap { $0 }
        let analizados = tonalidad.analizar(acordes).acordes
        let columna = util / Double(max(acordes.count, 1))
        for (i, acorde) in acordes.enumerated() {
            let x = margen + Double(i) * columna
            let funcion = i < analizados.count ? analizados[i].funcion?.nombre(en: notacion) ?? "" : ""
            let romano = tonalidad.romano(grado: i + 1, deNotas: 4)?.description ?? ""
            cuerpo.append(Hoja.texto(romano, x: x, y: y, tamano: 12, negrita: true))
            cuerpo.append(Hoja.texto(acorde.cifrado(en: notacion), x: x, y: y + 16, tamano: 12))
            cuerpo.append(Hoja.texto(funcion, x: x, y: y + 31, tamano: 9, color: "#666666"))
        }
        y += 48

        // Las cadencias típicas.
        seccion(notacion.texto(\.cadenciasTipicas))
        for cadencia in cadenciasTipicas(de: tonalidad, en: notacion) {
            cuerpo.append(Hoja.texto(cadencia.nombre, x: margen, y: y, tamano: 11, negrita: true))
            cuerpo.append(Hoja.texto(cadencia.grados, x: margen + 190, y: y, tamano: 11))
            cuerpo.append(Hoja.texto(cadencia.acordes, x: margen + 270, y: y, tamano: 11))
            y += 17
        }
        y += 8

        // Las modulaciones a los tonos vecinos, cada una con la progresión y el pivote.
        seccion(notacion.texto(\.modulaciones))
        for modulacion in PresentacionDeModulaciones.modulaciones(desde: tonalidad, en: notacion) {
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

        // Las dominantes secundarias, cada una con el acorde al que va, y los acordes prestados del modo homónimo.
        for (titulo, deFuera) in acordesDeFuera(de: tonalidad, en: notacion) where !deFuera.isEmpty {
            y += 4
            seccion(titulo)
            for acorde in deFuera {
                cuerpo.append(Hoja.texto(acorde.grados, x: margen, y: y, tamano: 11, negrita: true))
                cuerpo.append(Hoja.texto(acorde.acordes, x: margen + 90, y: y, tamano: 11))
                y += 17
            }
        }

        // Lo que dicen las fuentes de su carácter, como en la hoja en HTML.
        y += 4
        Hoja.seccionDeDatos(
            notacion.texto(\.caracterDeLaFuente), Hoja.caracter(de: tonalidad, en: notacion), x: margen, ancho: util,
            y: &y, en: &cuerpo)

        let alto = (y + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: alto, cuerpo)
    }

    /// Las dos listas de acordes de fuera de la hoja, con su título: las dominantes secundarias y los prestados.
    static func acordesDeFuera(
        de tonalidad: Tonalidad, en notacion: Notacion
    ) -> [(titulo: String, acordes: [AcordeDeFueraPresentado])] {
        [
            (
                titulo(Rearmonizacion.Recurso.dominanteSecundaria, notacion),
                dominantesSecundarias(de: tonalidad, en: notacion)
            ),
            (titulo(Rearmonizacion.Recurso.prestamoModal, notacion), acordesPrestados(de: tonalidad, en: notacion)),
        ]
    }

    /// El nombre del recurso como título, con la primera en mayúscula: «Dominante secundaria».
    private static func titulo(_ recurso: Rearmonizacion.Recurso, _ notacion: Notacion) -> String {
        let nombre = recurso.nombre(en: notacion)
        return nombre.prefix(1).uppercased() + nombre.dropFirst()
    }
}
