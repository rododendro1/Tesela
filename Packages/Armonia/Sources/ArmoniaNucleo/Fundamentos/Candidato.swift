// MARK: - Candidato

/// Una lectura posible de unos datos, con su coste: un acorde para unas notas, una tonalidad
/// para una melodía… Cuanto menor es el coste, más probable es la lectura, y las listas de
/// candidatos se devuelven ordenadas de menor a mayor coste.
///
///     let c = Acorde.candidatos([.do, .mi, "Sib"]).first!
///     c.valor.cifrado   // "Do7"
///     c.coste           // 1.0 (falta la quinta)
///     c.omitidas        // [Sol]
public struct Candidato<Valor: Hashable & Sendable>: Hashable, Sendable {
    public let valor: Valor
    /// Cuanto menor, más probable (0 = la lectura más habitual posible).
    public let coste: Double
    /// Notas que la lectura supone aunque falten. Solo tiene sentido en acordes (ver `omitidas`).
    package let notasOmitidas: [Nota]

    package init(_ valor: Valor, coste: Double, notasOmitidas: [Nota] = []) {
        self.valor = valor
        self.coste = coste
        self.notasOmitidas = notasOmitidas
    }
}

// MARK: - ElMejor

/// El candidato de menor coste de una búsqueda, para los bucles que prueban opciones una a una. A igual
/// coste se queda el primero.
///
///     var mejor = ElMejor<Acorde, Double>()
///     for (acorde, coste) in opciones { mejor.proponer(acorde, coste: coste) }
///     mejor.valor    // el de menor coste, o nil si no hubo ninguno
///
/// Con un coste que no es `Comparable`, como una tupla, se da la comparación: `ElMejor<…, (Int, Int)>(por: <)`.
package struct ElMejor<Valor, Coste> {
    private let menor: (Coste, Coste) -> Bool
    /// El mejor hasta ahora; `nil` si no se ha propuesto ninguno.
    package private(set) var valor: Valor?
    package private(set) var coste: Coste?

    package init(por menor: @escaping (Coste, Coste) -> Bool) { self.menor = menor }

    /// Si un candidato con este coste sería el nuevo mejor.
    package func mejora(_ coste: Coste) -> Bool { self.coste.map { menor(coste, $0) } ?? true }

    /// Se queda con el candidato si mejora al mejor; el valor solo se calcula entonces.
    package mutating func proponer(_ valor: @autoclosure () -> Valor, coste: Coste) {
        guard mejora(coste) else { return }
        self.valor = valor()
        self.coste = coste
    }
}

extension ElMejor where Coste: Comparable {
    package init() { self.init(por: <) }
}
