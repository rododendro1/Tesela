import Armonia

/// Una rearmonización como la ofrecen la app y la línea de comandos: qué cambia, la progresión con el cambio y cómo
/// suena el pasaje.
public struct PropuestaDeRearmonizacion: Hashable, Sendable {
    public let rearmonizacion: Rearmonizacion
    /// «Sol7 → Re♭7 (sustituto tritonal)».
    public let descripcion: String
    /// La progresión entera con el cambio, como se escribe en el campo de la progresión.
    public let texto: String
    /// El pasaje que cambia, con el acorde de antes y el de después, para compararlo con el original.
    public let sonido: Escucha
}

/// La parte de «Rearmonizar» que no es dibujo. No usa SwiftUI, así que se prueba en Linux.
public enum PresentacionDeRearmonizacion {
    /// Las propuestas para cada acorde, en el orden de los acordes. La tonalidad, si no se da, es la del análisis
    /// de la progresión; `nil` si no hay acordes.
    ///
    ///     let propuestas = PresentacionDeRearmonizacion.proponer(
    ///         [Acorde("Do"), Acorde("Sol7"), Acorde("Do")], notacion: .espanolUnicode)
    ///     propuestas?.propuestas.first?.descripcion   // "Do → Dom (préstamo modal)"
    public static func proponer(
        _ acordes: [Acorde], en tonalidad: Tonalidad? = nil, notacion: Notacion
    ) -> (tonalidad: Tonalidad, propuestas: [PropuestaDeRearmonizacion])? {
        guard let tonalidad = tonalidad ?? AnalisisArmonico.analizar(acordes)?.tonalidad else { return nil }
        let propuestas = tonalidad.rearmonizaciones(de: acordes).map { rearmonizacion in
            let nuevos = rearmonizacion.aplicar(a: acordes)
            // El pasaje: el acorde de antes, los nuevos y el de después.
            let desde = max(0, rearmonizacion.posicion - 1)
            let hasta = min(nuevos.count, rearmonizacion.posicion + rearmonizacion.acordes.count + 1)
            return PropuestaDeRearmonizacion(
                rearmonizacion: rearmonizacion,
                descripcion: rearmonizacion.descripcion(en: notacion),
                texto: PresentacionDeTransposicion.texto(de: nuevos, notacion: notacion),
                sonido: Escucha.acordes(Array(nuevos[desde..<hasta])).conTonica(tonalidad.tonica))
        }
        return (tonalidad, propuestas)
    }
}

extension AnalisisPresentado {
    /// Las rearmonizaciones de los acordes analizados, en la tonalidad de la partitura.
    public func rearmonizaciones(en notacion: Notacion) -> [PropuestaDeRearmonizacion] {
        PresentacionDeRearmonizacion.proponer(acordes, en: tonalidad, notacion: notacion)?.propuestas ?? []
    }
}
