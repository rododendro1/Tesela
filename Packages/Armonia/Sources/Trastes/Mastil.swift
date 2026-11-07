import Elementos
import Teoria

/// Un sitio del mástil: una cuerda y un traste (0 = cuerda al aire).
public struct PosicionEnElMastil: Hashable, Sendable, Comparable, CustomStringConvertible {
    /// Índice de la cuerda en `Encordado.afinacion`: 0 es la de arriba (el Mi grave de la guitarra, la 6.ª). El
    /// número tradicional, en el que la 1.ª es la de abajo, lo da `Encordado.numeroTradicional(deCuerda:)`.
    public let cuerda: Int
    public let traste: Int

    /// Esa cuerda (0 es la más grave) en ese traste (0 al aire).
    public init(cuerda: Int, traste: Int) {
        self.cuerda = cuerda
        self.traste = traste
    }

    public static func < (a: PosicionEnElMastil, b: PosicionEnElMastil) -> Bool {
        (a.traste, a.cuerda) < (b.traste, b.cuerda)
    }

    /// «cuerda 1 desde arriba, traste 3»: sin el encordado no se sabe cuántas cuerdas hay, así que cuenta desde
    /// la de arriba y no con la numeración tradicional.
    public var description: String { "cuerda \(cuerda + 1) desde arriba, traste \(traste)" }
}

/// El mástil de un instrumento: un `Encordado` y su número de trastes.
///
///     let mastil = Mastil(.guitarra)
///     mastil.altura(en: PosicionEnElMastil(cuerda: 1, traste: 3))     // Do3
///     mastil.posiciones(de: .mi).count                      // dónde suena Mi, en cualquier octava
public struct Mastil: Hashable, Sendable {
    public let encordado: Encordado
    /// Cuántos trastes tiene (sin contar la cuerda al aire).
    public let numeroDeTrastes: Int

    /// - Parameter numeroDeTrastes: cuántos trastes tiene. Un número negativo se toma como 0 (solo cuerdas al
    ///   aire).
    public init(_ encordado: Encordado = .guitarra, numeroDeTrastes: Int = 24) {
        self.encordado = encordado
        self.numeroDeTrastes = max(0, numeroDeTrastes)
    }

    /// ¿Existe esta posición en el mástil?
    public func contiene(_ posicion: PosicionEnElMastil) -> Bool {
        encordado.afinacion.indices.contains(posicion.cuerda) && (0...numeroDeTrastes).contains(posicion.traste)
    }

    /// Número MIDI de una posición, o `nil` si no está en el mástil.
    public func midiSiExiste(en posicion: PosicionEnElMastil) -> Int? {
        contiene(posicion) ? encordado.afinacion[posicion.cuerda].midi + posicion.traste : nil
    }

    /// Número MIDI de una posición. Detiene el programa si la posición no está en el mástil (un error de
    /// quien llama, como salirse de un array): si viene de fuera, usa `midiSiExiste(en:)` o `contiene(_:)`.
    public func midi(en posicion: PosicionEnElMastil) -> Int {
        guard let midi = midiSiExiste(en: posicion) else {
            preconditionFailure("Posición fuera del mástil: \(posicion)")
        }
        return midi
    }

    /// La altura de una posición, o `nil` si no está en el mástil. La ortografía es la de `Altura(midi:)`, con
    /// sostenidos; con bemoles o con otra ventana, `alturaSiExiste(en:ventana:)`.
    public func alturaSiExiste(en posicion: PosicionEnElMastil) -> Altura? {
        midiSiExiste(en: posicion).map { Altura(midi: $0) }
    }

    /// La altura de una posición (con la misma ortografía que `alturaSiExiste(en:)`). Detiene el programa si
    /// la posición no está en el mástil: si viene de fuera, usa `alturaSiExiste(en:)`.
    public func altura(en posicion: PosicionEnElMastil) -> Altura {
        Altura(midi: midi(en: posicion))
    }

    /// La altura de una posición, o `nil` si no está en el mástil, escrita con la nota de su clase que hay en la
    /// ventana: con `.centrada(en: "Fa")`, en la cuerda más grave de la guitarra el traste 1 es Fa y el 2, Sol♭.
    public func alturaSiExiste(en posicion: PosicionEnElMastil, ventana: VentanaDeQuintas) -> Altura? {
        midiSiExiste(en: posicion).map { Altura(midi: $0, ventana: ventana) }
    }

    /// La altura de una posición, escrita con la nota de su clase que hay en la ventana. Detiene el programa si la
    /// posición no está en el mástil: si viene de fuera, usa `alturaSiExiste(en:ventana:)`.
    public func altura(en posicion: PosicionEnElMastil, ventana: VentanaDeQuintas) -> Altura {
        Altura(midi: midi(en: posicion), ventana: ventana)
    }

    /// Todas las posiciones donde suena exactamente esa altura (misma octava).
    public func posiciones(de altura: Altura) -> [PosicionEnElMastil] {
        var resultado: [PosicionEnElMastil] = []
        for (cuerda, alAire) in encordado.afinacion.enumerated() {
            let traste = altura.midi - alAire.midi
            if (0...numeroDeTrastes).contains(traste) {
                resultado.append(PosicionEnElMastil(cuerda: cuerda, traste: traste))
            }
        }
        return resultado.sorted()
    }

    /// Todas las posiciones donde suena esa nota en cualquier octava. Los enarmónicos suenan igual:
    /// Fa♯ y Sol♭ dan las mismas posiciones.
    public func posiciones(de nota: Nota) -> [PosicionEnElMastil] {
        posiciones(deClases: [nota.claseDeAltura])
    }

    /// Las posiciones de todas las notas de una escala, en un rango de trastes si se indica.
    public func posiciones(de escala: Escala, en rango: ClosedRange<Int>? = nil) -> [PosicionEnElMastil] {
        let todas = posiciones(deClases: Set(escala.notas.map(\.claseDeAltura)))
        guard let rango else { return todas }
        return todas.filter { rango.contains($0.traste) }
    }

    /// Las posiciones cuya clase de altura (0…11) está en el conjunto.
    public func posiciones(deClases clases: Set<Int>) -> [PosicionEnElMastil] {
        var resultado: [PosicionEnElMastil] = []
        for (cuerda, alAire) in encordado.afinacion.enumerated() {
            for traste in 0...numeroDeTrastes where clases.contains(Mastil.clase(alAire.midi + traste)) {
                resultado.append(PosicionEnElMastil(cuerda: cuerda, traste: traste))
            }
        }
        return resultado.sorted()
    }

    /// Clase de altura 0…11 de un número MIDI (también para negativos).
    static func clase(_ midi: Int) -> Int { ((midi % 12) + 12) % 12 }
}
