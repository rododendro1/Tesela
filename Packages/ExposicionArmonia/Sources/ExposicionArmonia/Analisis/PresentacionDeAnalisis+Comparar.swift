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

    /// Las dos progresiones en una hoja, para `HojaDeEstudio.comparacion(_:con:en:disposicion:notacion:formato:)`:
    /// los cifrados de las dos, la segunda en rojo; el pentagrama de cada una, con una disposición de cada acorde, y la
    /// tabla posición a posición, con lo que cambia en rojo y resaltado. `nil` si alguna está vacía.
    static func hojaDeLaComparacion(
        _ original: [Acorde], con nueva: [Acorde], en tonalidad: Tonalidad? = nil,
        disposicion: DisposicionDeAcorde = .drop2, notacion: Notacion
    ) -> HojaCompuesta? {
        guard let comparacion = comparar(original, con: nueva, en: tonalidad, notacion: notacion) else { return nil }
        let filas = comparacion.filas.map { fila in
            let acordes = fila.cambia ? fila.original + " → " + fila.nueva : fila.original
            let tono: HojaCompuesta.Tono? = fila.cambia ? .destino : nil
            return [String(fila.posicion), acordes, fila.grados, fila.comunes].enumerated().map { i, celda in
                HojaCompuesta.Celda(texto: celda, tono: tono, negrita: fila.cambia && i == 1, resaltada: fila.cambia)
            }
        }
        return HojaCompuesta(
            titulo: HojaDeEstudio.cifrados(original, en: notacion),
            otroTitulo: HojaDeEstudio.cifrados(nueva, en: notacion), subtitulos: [comparacion.tonalidad],
            secciones: [
                .init(
                    titulo: "",
                    piezas: HojaDeEstudio.pentagrama(original, disposicion, en: notacion)
                        + HojaDeEstudio.pentagrama(nueva, disposicion, en: notacion)),
                .init(titulo: "", piezas: [.tablaMarcada(filas), .destacado([comparacion.resumen])]),
            ])
    }
}
