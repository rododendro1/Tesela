import Elementos
import Teoria

// Lo que comparten las partituras de un coral (Polifonia) y de una progresión (Formatos): el último acorde, alargado
// hasta la barra, y lo que se anota encima y debajo de cada uno.

extension Compas {
    /// Las duraciones, con la última alargada para que acaben en la barra.
    package func hastaLaBarra(_ duraciones: [Duracion]) -> [Duracion] {
        guard let ultima = duraciones.last else { return duraciones }
        let total = duraciones.reduce(Duracion.cero, +)
        let enCompases = total / duracion
        let resto = total - duracion * (enCompases.numerador / enCompases.denominador)
        return resto.esCero ? duraciones : Array(duraciones.dropLast()) + [ultima + duracion - resto]
    }

    /// Lo que dura el último de `cuantos` acordes de `figura` para que acabe en la barra.
    package func hastaLaBarra(_ figura: Duracion, _ cuantos: Int) -> Duracion {
        hastaLaBarra(Array(repeating: figura, count: max(0, cuantos))).last ?? figura
    }
}

/// Lo que se anota en un coral o en una progresión, por el punto en que empieza cada acorde (contado desde el
/// principio): el acorde que se cifra encima de la voz más aguda y el análisis que se escribe debajo de la más grave.
package struct AnotacionesDeAcordes {
    /// La de la armadura.
    package var tonalidad: Tonalidad?
    /// La que se escribe al principio, debajo del bajo, si se analiza.
    package var tonalidadDelAnalisis: Tonalidad?
    package var cifrados: [Duracion: Acorde] = [:]
    package var analisis: [Duracion: AcordeAnalizado] = [:]

    package init() {}
}
