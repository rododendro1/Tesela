import ArmoniaElementos
import ArmoniaTeoria
import Foundation

extension Tonnetz {
    /// Un ciclo neorriemanniano dibujado como recorrido: la banda de triángulos de la tríada de
    /// partida a la misma tríada, con los nombres de `Acorde.ciclo(_:)`. `nil` si el acorde no
    /// es una tríada mayor o menor.
    ///
    ///     Tonnetz(ciclo: .hexatonico, desde: "Do")
    public init?(ciclo: CicloNeorriemanniano, desde acorde: Acorde) {
        guard let acordes = acorde.ciclo(ciclo), let colocado = Tonnetz(recorrido: [acorde]) else { return nil }
        // La banda, recta: cada triángulo, el vecino del anterior.
        var triadas = colocado.recorrido
        guard var actual = triadas.last else { return nil }
        for i in 0..<ciclo.longitud {
            actual = actual.transformar(ciclo.transformaciones[i % 2])
            triadas.append(actual)
        }
        var puntos: [PuntoDeLaRed] = []
        var nombres: [PuntoDeLaRed: Nota] = [:]
        for (triada, acordeDelCiclo) in zip(triadas, acordes) {
            for vertice in triada.vertices {
                if !puntos.contains(vertice) { puntos.append(vertice) }
                if nombres[vertice] == nil {
                    nombres[vertice] = acordeDelCiclo.notas.first { $0.claseDeAltura == vertice.claseDeAltura }
                }
            }
        }
        self.init(puntos: puntos, tieneOrtografia: true, recorrido: triadas)
        self.nombres = nombres
        self.acordesDelRecorrido = acordes
        self.origen = .ciclo(ciclo, acorde)
    }

    /// La nota que se escribe en un punto: la suya o, en un ciclo, la de la tríada que lo toca;
    /// en los puntos de alrededor, la enarmónica con menos alteraciones (y, entre Fa♯ y Sol♭, la
    /// del punto con nombre más cercano).
    package func nombre(de punto: PuntoDeLaRed) -> Nota {
        guard !nombres.isEmpty else { return punto.nota }
        if let nota = nombres[punto] { return nota }
        func distancia(_ otro: PuntoDeLaRed) -> Double {
            let dx = Double(otro.quintas - punto.quintas) + Double(otro.terceras - punto.terceras) / 2
            let dy = Double(otro.terceras - punto.terceras) * 0.8660254037844386
            return dx * dx + dy * dy
        }
        guard
            let cercano = puntos.min(by: {
                (distancia($0), $0.terceras, $0.quintas) < (distancia($1), $1.terceras, $1.quintas)
            }),
            let notaCercana = nombres[cercano]
        else { return punto.nota }
        let cerca = notaCercana.pasosDeQuinta - cercano.pasosDeQuinta
        let opciones = (-3...3).map { Nota(pasosDeQuinta: punto.pasosDeQuinta + 12 * $0) }
        return opciones.menor(siNoHay: punto.nota) {
            (abs($0.alteracion.semitonos), abs($0.pasosDeQuinta - punto.pasosDeQuinta - cerca))
                < (abs($1.alteracion.semitonos), abs($1.pasosDeQuinta - punto.pasosDeQuinta - cerca))
        }
    }
}
