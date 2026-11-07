import ArmoniaElementos
import ArmoniaTeoria

// Arpegios en el mástil: dónde están las notas de un acorde y cómo se tocan por posiciones, en franjas de pocos
// trastes que la mano abarca sin moverse.

/// Un arpegio tocado en una posición del mástil: las notas del acorde dentro de una franja de trastes, de la más
/// grave a la más aguda, que es el orden en que se tocan al subir.
///
///     let posiciones = Mastil(.guitarra, numeroDeTrastes: 12).arpegios(de: Acorde("Lam"))
///     posiciones.map(\.rangoDeTrastes)        // [0...3, 4...7, 9...12]
///     posiciones[0].alturas            // Mi2 La2 Do3 Mi3 La3 Do4 Mi4
public struct ArpegioEnElMastil: Hashable, Sendable {
    public let mastil: Mastil
    /// Los trastes que abarca la mano (el 0 es la cuerda al aire).
    public let rangoDeTrastes: ClosedRange<Int>
    /// Las notas, de la más grave a la más aguda; las que suenan igual en dos cuerdas (un unísono), una vez.
    public let posiciones: [PosicionEnElMastil]
    /// La forma CAGED de la posición, si es una de ``Mastil/arpegiosCAGED(de:ancho:)``.
    public let forma: FormaCAGED?
    /// El acorde que se arpegia, si se sabe: el que se dio a ``Mastil/arpegios(de:ancho:)``,
    /// ``Mastil/arpegiosCAGED(de:ancho:)`` o ``Mastil/arpegiosDeUnaNotaPorCuerda(de:alcance:)``. Con él,
    /// ``partitura(de:titulo:ritmo:)`` escribe sus notas y lo cifra.
    public let acorde: Acorde?

    /// Un arpegio en esa franja de trastes, con sus notas de la más grave a la más aguda.
    public init(
        mastil: Mastil, rangoDeTrastes: ClosedRange<Int>, posiciones: [PosicionEnElMastil], forma: FormaCAGED? = nil,
        acorde: Acorde? = nil
    ) {
        self.mastil = mastil
        self.rangoDeTrastes = rangoDeTrastes
        self.posiciones = posiciones
        self.forma = forma
        self.acorde = acorde
    }

    /// Las alturas en el orden en que se tocan.
    public var alturas: [Altura] { posiciones.map { mastil.altura(en: $0) } }

    /// El dedo de la mano que pisa cada nota, en el orden de `posiciones`: 0 en las cuerdas al aire y, en las
    /// demás, el índice (1) en el traste más bajo que se pisa y un dedo por traste hasta el meñique (4), que toma
    /// también los que quedan más arriba.
    public var dedos: [Int] {
        guard let base = posiciones.map(\.traste).filter({ $0 > 0 }).min() else { return posiciones.map { _ in 0 } }
        return posiciones.map { $0.traste == 0 ? 0 : min(4, $0.traste - base + 1) }
    }
}

extension Mastil {
    /// Todas las posiciones de las notas de un acorde, en un rango de trastes si se indica.
    public func posiciones(de acorde: Acorde, en rango: ClosedRange<Int>? = nil) -> [PosicionEnElMastil] {
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
        let fundamental = acorde.fundamental.claseDeAltura
        var inicios: [Int] = []
        // Las dos cuerdas más graves, que no siempre son las primeras (el Sol agudo del ukelele).
        for alAire in encordado.afinacion.sorted(by: { $0.midi < $1.midi }).prefix(2) {
            for traste in 0...numeroDeTrastes where Mastil.clase(alAire.midi + traste) == fundamental {
                let inicio = max(0, min(traste - 1, numeroDeTrastes - (ancho - 1)))
                if !inicios.contains(inicio) { inicios.append(inicio) }
            }
        }
        return inicios.sorted().compactMap { inicio in
            arpegio(de: acorde, en: inicio...min(numeroDeTrastes, inicio + ancho - 1), forma: nil)
        }
    }

    /// El arpegio de un acorde en las cinco formas del sistema CAGED, de la más baja a la más alta: en cada una,
    /// las notas del acorde dentro de la franja de la escala mayor de su fundamental en esa forma
    /// (``posicionesCAGED(de:ancho:)``). Solo para la guitarra afinada como siempre; en otro instrumento, vacío.
    ///
    ///     Mastil(.guitarra, numeroDeTrastes: 15).arpegiosCAGED(de: Acorde("Do")).map(\.forma)   // [C, A, G, E, D]
    public func arpegiosCAGED(de acorde: Acorde, ancho: Int = 5) -> [ArpegioEnElMastil] {
        posicionesCAGED(de: Escala(acorde.fundamental, .mayor), ancho: ancho).compactMap {
            arpegio(de: acorde, en: $0.rangoDeTrastes, forma: $0.forma)
        }
    }

    /// El arpegio de un acorde con una sola nota en cada cuerda, de la grave a la aguda, como se toca con barrido
    /// (*sweep picking*): uno por cada nota del acorde en la cuerda más grave, de la más baja a la más alta, si las
    /// cuerdas siguientes encuentran nota sin que la mano tenga que abrirse más de `alcance` trastes.
    ///
    ///     Mastil(.guitarra, numeroDeTrastes: 15).arpegiosDeUnaNotaPorCuerda(de: Acorde("Lam"))[0].alturas
    ///     // Mi2 La2 Mi3 La3 Do4 Mi4: el La menor al aire, de la 6.ª cuerda a la 1.ª
    ///
    /// Vacío si las cuerdas no van de grave a aguda (un ukelele con el Sol agudo, por ejemplo).
    public func arpegiosDeUnaNotaPorCuerda(de acorde: Acorde, alcance: Int = 5) -> [ArpegioEnElMastil] {
        let clases = Set(acorde.notas.map(\.claseDeAltura))
        let cuerdas = encordado.afinacion.map(\.midi)
        guard !clases.isEmpty, !encordado.esReentrante, let grave = cuerdas.first else { return [] }
        var resultado: [ArpegioEnElMastil] = []
        for inicio in 0...numeroDeTrastes where clases.contains(Mastil.clase(grave + inicio)) {
            var posiciones = [PosicionEnElMastil(cuerda: 0, traste: inicio)]
            var altura = grave + inicio
            for (cuerda, alAire) in cuerdas.enumerated().dropFirst() {
                // La nota siguiente del acorde que se puede pisar en esta cuerda.
                altura += 1
                while !clases.contains(Mastil.clase(altura)) || altura < alAire { altura += 1 }
                posiciones.append(PosicionEnElMastil(cuerda: cuerda, traste: altura - alAire))
            }
            let usados = posiciones.map(\.traste)
            // La mano abarca de la nota pisada más baja a la más alta; las cuerdas al aire no cuentan.
            guard let menor = usados.min(), let mayor = usados.max(), mayor <= numeroDeTrastes,
                usados.allSatisfy({ $0 == 0 || mayor - $0 < max(1, alcance) })
            else { continue }
            resultado.append(
                ArpegioEnElMastil(
                    mastil: self, rangoDeTrastes: menor...mayor, posiciones: posiciones, acorde: acorde))
        }
        return resultado
    }

    /// Las notas del acorde dentro de una franja, de la más grave a la más aguda y sin unísonos, o `nil` si falta
    /// alguna.
    private func arpegio(de acorde: Acorde, en franja: ClosedRange<Int>, forma: FormaCAGED?) -> ArpegioEnElMastil? {
        let clases = Set(acorde.notas.map(\.claseDeAltura))
        let ordenadas = posiciones(deClases: clases).filter { franja.contains($0.traste) }
            .sorted { (midi(en: $0), $0.cuerda) < (midi(en: $1), $1.cuerda) }
        var unicas: [PosicionEnElMastil] = []
        for posicion in ordenadas where unicas.last.map({ midi(en: $0) != midi(en: posicion) }) ?? true {
            unicas.append(posicion)
        }
        guard Set(unicas.map { Mastil.clase(midi(en: $0)) }) == clases else { return nil }
        return ArpegioEnElMastil(
            mastil: self, rangoDeTrastes: franja, posiciones: unicas, forma: forma, acorde: acorde)
    }
}
