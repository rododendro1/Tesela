import ArmoniaNucleo
import ArmoniaTeoria

// Arpegios en el mástil: dónde están las notas de un acorde y cómo se tocan por posiciones, en franjas de pocos
// trastes que la mano abarca sin moverse.

/// Un arpegio tocado en una posición del mástil: las notas del acorde dentro de una franja de trastes, de la más
/// grave a la más aguda, que es el orden en que se tocan al subir.
///
///     let posiciones = Mastil(.guitarra, trastes: 12).arpegios(de: Acorde("Lam"))
///     posiciones.map(\.trastes)        // [0...3, 4...7, 9...12]
///     posiciones[0].alturas            // Mi2 La2 Do3 Mi3 La3 Do4 Mi4
public struct ArpegioEnElMastil: Hashable, Sendable {
    public let mastil: Mastil
    /// Los trastes que abarca la mano (el 0 es la cuerda al aire).
    public let trastes: ClosedRange<Int>
    /// Las notas, de la más grave a la más aguda; las que suenan igual en dos cuerdas (un unísono), una vez.
    public let posiciones: [PosicionEnElMastil]

    public init(mastil: Mastil, trastes: ClosedRange<Int>, posiciones: [PosicionEnElMastil]) {
        self.mastil = mastil
        self.trastes = trastes
        self.posiciones = posiciones
    }

    /// Las alturas en el orden en que se tocan.
    public var alturas: [Altura] { posiciones.map { mastil.altura(en: $0) } }
}

extension Mastil {
    /// Todas las posiciones de las notas de un acorde, en un rango de trastes si se indica.
    public func posiciones(de acorde: Acorde, trastes rango: ClosedRange<Int>? = nil) -> [PosicionEnElMastil] {
        let todas = posiciones(deClases: Set(acorde.notas.map(\.claseDeAltura)))
        guard let rango else { return todas }
        return todas.filter { rango.contains($0.traste) }
    }

    /// El arpegio de un acorde en cada posición del mástil, de la más baja a la más alta.
    ///
    /// Cada posición es una franja de `ancho` trastes que empieza un traste por debajo de la fundamental en una de
    /// las dos cuerdas más graves (donde se apoya la mano para tocar el arpegio desde su fundamental). Solo se dan
    /// las franjas en las que están todas las notas del acorde.
    public func arpegios(de acorde: Acorde, ancho: Int = 4) -> [ArpegioEnElMastil] {
        let ancho = max(1, ancho)
        let clases = Set(acorde.notas.map(\.claseDeAltura))
        let fundamental = acorde.fundamental.claseDeAltura
        var inicios: [Int] = []
        // Las dos cuerdas más graves, que no siempre son las primeras (el Sol agudo del ukelele).
        for alAire in encordado.cuerdas.sorted(by: { $0.midi < $1.midi }).prefix(2) {
            for traste in 0...trastes where Mastil.clase(alAire.midi + traste) == fundamental {
                let inicio = max(0, min(traste - 1, trastes - (ancho - 1)))
                if !inicios.contains(inicio) { inicios.append(inicio) }
            }
        }
        let todas = posiciones(deClases: clases)
        return inicios.sorted().compactMap { inicio in
            let franja = inicio...min(trastes, inicio + ancho - 1)
            let ordenadas = todas.filter { franja.contains($0.traste) }
                .sorted { (midi(en: $0), $0.cuerda) < (midi(en: $1), $1.cuerda) }
            var unicas: [PosicionEnElMastil] = []
            for posicion in ordenadas where unicas.last.map({ midi(en: $0) != midi(en: posicion) }) ?? true {
                unicas.append(posicion)
            }
            guard Set(unicas.map { Mastil.clase(midi(en: $0)) }) == clases else { return nil }
            return ArpegioEnElMastil(mastil: self, trastes: franja, posiciones: unicas)
        }
    }
}
