// La búsqueda de los caminos de menor coste por una sucesión de pasos (el algoritmo de Viterbi, con los k mejores de
// cada estado): la usan el armonizador (``Tonalidad/armonizar(melodia:propuestas:)`` y
// ``Tonalidad/armonizarACuatroVoces(melodia:)``) y la realización del coral (``Coral/init(realizando:soprano:en:)``).

/// Los caminos de menor coste que pasan por un estado de cada paso.
///
///     // Dos pasos de dos estados; cambiar de estado cuesta 1.
///     let caminos = MejoresCaminos.buscar(estados: [2, 2], inicio: { Double($0) }, paso: { _, a, b in a == b ? 0 : 1 })
///     caminos.first?.estados   // [0, 0]
package enum MejoresCaminos {
    /// Un camino: su coste y el estado que elige en cada paso.
    package typealias Camino = (coste: Double, estados: [Int])

    /// Los mejores caminos, de menor a mayor coste: como mucho `mejores` por cada estado del último paso. Entre dos
    /// caminos que cuestan lo mismo va antes el que viene de estados con un índice menor.
    ///
    /// - Parameters:
    ///   - estados: cuántos estados tiene cada paso.
    ///   - mejores: cuántos caminos se guardan por estado.
    ///   - inicio: lo que cuesta empezar en un estado del primer paso; `nil` si no se puede.
    ///   - paso: lo que cuesta ir del estado `desde` del paso `i - 1` al estado `hasta` del paso `i`; `nil` si no se
    ///     puede.
    ///   - final: lo que cuesta terminar en el estado `ultimo` del último paso viniendo del `penultimo` (`nil` si
    ///     solo hay un paso). Se suma al llegar, antes de quedarse con los mejores.
    /// - Returns: vacío si no hay pasos, si algún paso no tiene estados o si ningún camino llega al final.
    package static func buscar(
        estados: [Int], mejores: Int = 1, inicio: (Int) -> Double?,
        paso: (_ i: Int, _ desde: Int, _ hasta: Int) -> Double?,
        final: (_ penultimo: Int?, _ ultimo: Int) -> Double = { _, _ in 0 }
    ) -> [Camino] {
        let n = estados.count
        guard n > 0, mejores > 0, estados.allSatisfy({ $0 > 0 }) else { return [] }
        var caminos: [[Camino]] = (0..<estados[0]).map { j in
            inicio(j).map { [($0 + (n == 1 ? final(nil, j) : 0), [j])] } ?? []
        }
        for i in 1..<max(1, n) {
            caminos = (0..<estados[i]).map { b in
                var llegadas: [Camino] = []
                for (a, anteriores) in caminos.enumerated() where !anteriores.isEmpty {
                    guard let coste = paso(i, a, b) else { continue }
                    let total = coste + (i == n - 1 ? final(a, b) : 0)
                    for camino in anteriores { llegadas.append((camino.coste + total, camino.estados + [b])) }
                }
                return Array(llegadas.sorted { $0.coste < $1.coste }.prefix(mejores))
            }
        }
        return caminos.flatMap { $0 }.sorted { $0.coste < $1.coste }
    }
}
