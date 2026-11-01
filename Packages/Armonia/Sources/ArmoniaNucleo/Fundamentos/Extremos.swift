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

    /// Los extremos, o `vacio` si no hay ningún valor; sin `??`, para que la rama que no se da no cuente como una
    /// función sin probar.
    package func extremos(siNoHay vacio: ClosedRange<Element>) -> ClosedRange<Element> {
        guard let extremos else { return vacio }
        return extremos
    }
}

extension Sequence {
    /// El menor elemento según `antes`, o `valor` si no hay ninguno: el `min(by:) ?? valor` de una colección que
    /// nunca está vacía.
    package func menor(siNoHay valor: Element, por antes: (Element, Element) throws -> Bool) rethrows -> Element {
        guard let menor = try self.min(by: antes) else { return valor }
        return menor
    }
}
