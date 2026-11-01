extension Sequence where Element: Comparable {
    /// El menor y el mayor de los valores, de una pasada: `[3, 1, 2].extremos` es `1...3`; `nil` si no hay
    /// ninguno. Sustituye a los `min()!` y `max()!` de una colección que no puede estar vacía.
    package var extremos: ClosedRange<Element>? {
        var iterador = makeIterator()
        guard let primero = iterador.next() else { return nil }
        var (menor, mayor) = (primero, primero)
        while let valor = iterador.next() {
            if valor < menor { menor = valor }
            if valor > mayor { mayor = valor }
        }
        return menor...mayor
    }
}
