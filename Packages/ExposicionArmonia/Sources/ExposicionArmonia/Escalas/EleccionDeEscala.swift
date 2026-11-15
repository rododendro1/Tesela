import Armonia

/// La escala que se elige en la pestaña de escalas: una de las doce tónicas y un tipo del catálogo, por su índice, o
/// una escrita (por sus notas o por sus pasos), que manda si se lee.
///
///     var eleccion = EleccionDeEscala()
///     eleccion.escala                         // Do mayor
///     eleccion.elegir(Escala(.re, .dorico))   // tónica Re, tipo dórico
///     eleccion.propia = "Do Re Mi Fa# Sol La Si"
///     eleccion.escala                         // la escrita
public struct EleccionDeEscala: Hashable, Sendable {
    /// Las escalas habituales y, después, las de otras tradiciones. Se elige por índice porque dos escalas con las
    /// mismas notas son iguales (`==`) aunque se llamen distinto.
    public static let catalogo = TipoDeEscala.occidentales + TipoDeEscala.tradicionales
    /// Los índices del catálogo de las escalas habituales.
    public static let habituales = 0..<TipoDeEscala.occidentales.count
    /// Los índices del catálogo de las escalas de otras tradiciones.
    public static let deOtrasTradiciones = TipoDeEscala.occidentales.count..<catalogo.count

    /// Las doce tónicas, de Do a Si, con la grafía habitual de una tonalidad: Re♭, Mi♭, La♭ y Si♭ con bemoles y Fa♯
    /// con sostenido. (`Altura(midi:)` daría Do♯, Re♯, Sol♯ y La♯, con dobles sostenidos en la escala.) Se indican por
    /// su posición en la línea de quintas.
    public static let tonicas: [Nota] = [0, -5, 2, -3, 4, -1, 6, 1, -4, 3, -2, 5].map { Nota(pasosDeQuinta: $0) }

    /// El índice de la tónica en `tonicas`.
    public var tonica: Int
    /// El índice del tipo en `catalogo`.
    public var tipo: Int
    /// Una escala escrita, por sus notas o por sus pasos; si se lee, manda sobre la tónica y el tipo.
    public var propia: String

    public init(tonica: Int = 0, tipo: Int = 0, propia: String = "") {
        self.tonica = tonica
        self.tipo = tipo
        self.propia = propia
    }

    /// La escala elegida: la escrita, si se lee; si no, la de la tónica y el tipo.
    public var escala: Escala {
        if !propia.isEmpty, let leida = try? Escala(leyendo: propia) { return leida }
        let nota = Self.tonicas[min(max(tonica, 0), Self.tonicas.count - 1)]
        return Escala(nota, Self.catalogo[min(max(tipo, 0), Self.catalogo.count - 1)])
    }

    /// Elige una escala pedida desde otra parte (las compatibles con un acorde, un modo…): su tónica y su tipo, el
    /// del mismo nombre o, si no, el primero con las mismas notas, sin la escrita.
    public mutating func elegir(_ pedida: Escala) {
        propia = ""
        if let indice = Self.tonicas.firstIndex(where: { $0.claseDeAltura == pedida.tonica.claseDeAltura }) {
            tonica = indice
        }
        let nombre = pedida.tipo.nombre(en: .compacta(.espanol))
        if let indice = Self.catalogo.firstIndex(where: { $0.nombre(en: .compacta(.espanol)) == nombre })
            ?? Self.catalogo.firstIndex(of: pedida.tipo)
        {
            tipo = indice
        }
    }

    /// El nombre del tipo de un índice del catálogo, para elegirlo.
    public static func nombreDelTipo(_ indice: Int, en notacion: Notacion) -> String {
        catalogo[indice].nombre(en: notacion)
    }
}
