import Armonia
import Foundation

/// Dos progresiones comparadas acorde a acorde, en la misma tonalidad: una original y otra (rearmonizada, otra
/// versión…), con lo que cambia en cada posición.
public struct ComparacionDeProgresionesPresentada: Hashable, Sendable {
    public struct PosicionComparada: Hashable, Sendable {
        /// Desde 1.
        public let posicion: Int
        /// El cifrado de la original en esta posición; «–» si es más corta.
        public let original: String
        public let nueva: String
        /// El grado de cada una: «vi → V7/ii», o uno solo si no cambia.
        public let grados: String
        /// «Notas comunes: La, Mi» si el acorde cambia; vacío si no.
        public let comunes: String
        public let cambia: Bool
    }

    /// La tonalidad en que se leen las dos: «Do mayor».
    public let tonalidad: String
    public let filas: [PosicionComparada]
    /// «Cambian 2 de 4 acordes».
    public let resumen: String
    /// La original y, detrás, la otra.
    public let sonido: Escucha
}

extension PresentacionDeAnalisis {
    // MARK: Comparar dos progresiones

    /// Las dos progresiones, posición a posición, leídas en `tonalidad` o, si no se da, en la de la original. `nil`
    /// si alguna está vacía.
    ///
    ///     let comparacion = PresentacionDeAnalisis.comparar(
    ///         [Acorde("Do"), Acorde("Lam"), Acorde("Rem"), Acorde("Sol7")],
    ///         con: [Acorde("Do"), Acorde("La7"), Acorde("Rem7"), Acorde("Sol7")], en: .compacta(.espanol))
    ///     comparacion?.resumen   // "Cambian 2 de 4 acordes"
    public static func comparar(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil, notacion: Notacion
    ) -> ComparacionDeProgresionesPresentada? {
        guard let primero = original.first, !nueva.isEmpty else { return nil }
        let clave = tonalidad ?? (try? AnalisisArmonico.analizar(original))?.tonalidad ?? primero.tonalidadPropia
        let gradosDeLaOriginal = clave.analizar(original).acordes.map(\.cifrado)
        let gradosDeLaNueva = clave.analizar(nueva).acordes.map(\.cifrado)
        var filas: [ComparacionDeProgresionesPresentada.PosicionComparada] = []
        for i in 0..<max(original.count, nueva.count) {
            let antes = i < original.count ? original[i] : nil
            let despues = i < nueva.count ? nueva[i] : nil
            let gradoAntes = i < gradosDeLaOriginal.count ? gradosDeLaOriginal[i] : "–"
            let gradoDespues = i < gradosDeLaNueva.count ? gradosDeLaNueva[i] : "–"
            let cambia = antes != despues
            var comunes = ""
            if cambia, let antes, let despues {
                let suyas = Set(despues.notas.map(\.claseDeAltura))
                let compartidas = antes.notas.filter { suyas.contains($0.claseDeAltura) }
                let lista =
                    compartidas.isEmpty
                    ? notacion.texto(\.ningunaNotaComun)
                    : compartidas.map { $0.nombre(en: notacion) }.joined(separator: ", ")
                comunes = notacion.texto(\.notasComunes) + ": " + lista
            }
            filas.append(
                ComparacionDeProgresionesPresentada.PosicionComparada(
                    posicion: i + 1, original: antes?.cifrado(en: notacion) ?? "–",
                    nueva: despues?.cifrado(en: notacion) ?? "–",
                    grados: gradoAntes == gradoDespues ? gradoAntes : gradoAntes + " → " + gradoDespues,
                    comunes: comunes, cambia: cambia))
        }
        let cambian = filas.filter(\.cambia).count
        return ComparacionDeProgresionesPresentada(
            tonalidad: clave.nombre(en: notacion), filas: filas,
            resumen: notacion.texto { $0.cambianAcordes(cambian, filas.count) },
            sonido: Escucha.acordes(original + nueva).conTonica(clave.tonica))
    }

    /// Las dos progresiones en una hoja SVG, para `HojaDeEstudio.comparacion(_:con:en:disposicion:notacion:formato:)`:
    /// el pentagrama de cada una, con una disposición de cada acorde, y la tabla posición a posición, con lo que cambia
    /// en rojo.
    static func comparacionSVG(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> String? {
        guard let comparacion = comparar(original, con: nueva, en: tonalidad, notacion: notacion) else { return nil }
        let ancho = Hoja.ancho
        let margen = Hoja.margen
        let util = ancho - 2 * margen
        let rojo = "#c0392b"
        var cuerpo: [String] = []
        var y = margen + 22
        cuerpo.append(
            Hoja.texto(HojaDeEstudio.cifrados(original, en: notacion), x: margen, y: y, tamano: 18, negrita: true))
        y += 22
        cuerpo.append(
            Hoja.texto(
                HojaDeEstudio.cifrados(nueva, en: notacion), x: margen, y: y, tamano: 18, negrita: true, color: rojo))
        y += 20
        cuerpo.append(Hoja.texto(comparacion.tonalidad, x: margen, y: y, tamano: 13, color: "#555555"))
        y += 10

        // El pentagrama de cada una.
        for acordes in [original, nueva] {
            if let svg = pentagrama(acordes, disposicion, en: notacion) {
                y += Hoja.incrustar(svg, x: margen, y: y, ancho: util, en: &cuerpo) + 6
            }
        }

        // Posición a posición.
        y += 16
        let columnas = [margen, margen + 30, margen + 150, margen + 270]
        for fila in comparacion.filas {
            let color = fila.cambia ? rojo : "#222222"
            let acordes = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
            let celdas = [String(fila.posicion), acordes, fila.grados, fila.comunes]
            for (i, celda) in celdas.enumerated() where !celda.isEmpty {
                let negrita = fila.cambia && i == 1
                cuerpo.append(Hoja.texto(celda, x: columnas[i], y: y, tamano: 11, negrita: negrita, color: color))
            }
            y += 17
        }
        y += 6
        cuerpo.append(Hoja.texto(comparacion.resumen, x: margen, y: y, tamano: 12, negrita: true))
        y += 12

        let alto = (y + margen).rounded(.up)
        return Hoja.hojaSVG(ancho: ancho, alto: alto, cuerpo)
    }

    /// Las dos progresiones comparadas como página HTML: lo mismo que `comparacionSVG`, con lo que cambia
    /// resaltado. `nil` si alguna está vacía.
    static func comparacionHTML(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> String? {
        guard let comparacion = comparar(original, con: nueva, en: tonalidad, notacion: notacion) else { return nil }
        let antes = HojaDeEstudio.cifrados(original, en: notacion)
        let despues = HojaDeEstudio.cifrados(nueva, en: notacion)
        var cuerpo = [
            "<header><h1>" + Hoja.html(antes) + "</h1><h1 class=\"destino\">" + Hoja.html(despues) + "</h1>"
                + "<p class=\"sub\">" + Hoja.html(comparacion.tonalidad) + "</p></header>"
        ]
        for acordes in [original, nueva] {
            if let svg = pentagrama(acordes, disposicion, en: notacion) {
                cuerpo.append(Hoja.figura(svg, clase: "pentagrama"))
            }
        }
        let filas = comparacion.filas.map { fila in
            let acordes = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
            return (
                celdas: [String(fila.posicion), acordes, fila.grados, fila.comunes], clase: fila.cambia ? "cambia" : nil
            )
        }
        cuerpo.append(Hoja.tablaHTML(filas))
        cuerpo.append("<p><strong>" + Hoja.html(comparacion.resumen) + "</strong></p>")
        let titulo = notacion.texto(\.hojaDeEstudio) + " · " + antes + " → " + despues
        return Hoja.paginaHTML(titulo: titulo, idioma: notacion.textos.codigo, cuerpo)
    }

    /// El pentagrama de los acordes con una disposición de cada uno: la pedida o, si no se puede, cerrada.
    private static func pentagrama(
        _ acordes: [Acorde], _ disposicion: DisposicionDeAcorde, en notacion: Notacion
    ) -> String? {
        let dispuesta =
            PresentacionDeDisposiciones.progresion(acordes, disposicion, en: notacion)
            ?? PresentacionDeDisposiciones.progresion(acordes, .cerrada, en: notacion)
        return dispuesta?.pentagrama.svg
    }
}
