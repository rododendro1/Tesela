import Elementos
import Foundation
import Teoria

// Las transformaciones neorriemannianas en el Tonnetz (están en Teoria, en
// `TransformacionNeorriemanniana.swift`): cada una es el giro del triángulo sobre uno de sus lados.

extension Tonnetz.Triada {
    /// El triángulo de una tríada mayor o menor, con la fundamental en la fila 0 (en el punto
    /// (pasos de quinta, 0)); `nil` para otros acordes. Se ignora la inversión.
    public init?(_ acorde: Acorde) {
        guard acorde.tipo == .mayor || acorde.tipo == .menor else { return nil }
        self.init(
            fundamental: PuntoDeLaRed(quintas: acorde.fundamental.pasosDeQuinta, terceras: 0),
            mayor: acorde.tipo == .mayor)
    }

    /// El triángulo vecino por uno de sus lados.
    public func transformar(_ transformacion: TransformacionNeorriemanniana) -> Tonnetz.Triada {
        let quintas = fundamental.quintas
        let terceras = fundamental.terceras
        func triada(_ quintas: Int, _ terceras: Int, _ mayor: Bool) -> Tonnetz.Triada {
            Tonnetz.Triada(fundamental: PuntoDeLaRed(quintas: quintas, terceras: terceras), mayor: mayor)
        }
        switch (transformacion, mayor) {
        case (.p, _): return triada(quintas, terceras, !mayor) // el lado de la quinta
        case (.l, true): return triada(quintas, terceras + 1, false) // el de la tercera menor (Mi–Sol)
        case (.l, false): return triada(quintas, terceras - 1, true)
        case (.r, true): return triada(quintas - 1, terceras + 1, false) // el de la tercera mayor (Do–Mi)
        case (.r, false): return triada(quintas + 1, terceras - 1, true)
        }
    }

    /// Aplica las transformaciones de izquierda a derecha.
    public func transformar(_ secuencia: [TransformacionNeorriemanniana]) -> Tonnetz.Triada {
        secuencia.reduce(self) { $0.transformar($1) }
    }

    /// Las tres tríadas vecinas, por P, L y R.
    public var vecinas: [Tonnetz.Triada] { TransformacionNeorriemanniana.allCases.map(transformar) }
}

extension Tonnetz {
    /// Un recorrido de tríadas mayores y menores por el Tonnetz: cada una, en el triángulo más
    /// cercano a la anterior, de modo que los pasos de P, L o R son triángulos vecinos. `nil` si
    /// algún acorde no es una tríada mayor o menor. `svg()` dibuja el recorrido con flechas.
    ///
    ///     Tonnetz(recorrido: ["Do", "Lam", "Fa", "Rem"])
    public init?(recorrido acordes: [Acorde]) {
        var triadas: [Triada] = []
        for acorde in acordes {
            guard let triada = Triada(acorde) else { return nil }
            guard let anterior = triadas.last else {
                // La primera, como al colocar el acorde solo.
                let puntos = Tonnetz(acorde).puntos
                triadas.append(Triada(fundamental: puntos[0], mayor: triada.mayor))
                continue
            }
            // Las copias del triángulo, desplazadas por (4, −1), que da la misma nota.
            let tercerasDeLaAnterior = anterior.fundamental.terceras
            let copias = ((tercerasDeLaAnterior - 3)...(tercerasDeLaAnterior + 3)).map { terceras in
                Triada(
                    fundamental: PuntoDeLaRed(quintas: triada.fundamental.quintas - 4 * terceras, terceras: terceras),
                    mayor: triada.mayor)
            }
            triadas.append(
                copias.menor(siNoHay: triada) { Tonnetz.separacion(anterior, $0) < Tonnetz.separacion(anterior, $1) })
        }
        var puntos: [PuntoDeLaRed] = []
        for vertice in triadas.flatMap(\.vertices) where !puntos.contains(vertice) { puntos.append(vertice) }
        self.init(puntos: puntos, tieneOrtografia: true, recorrido: triadas)
    }

    /// El recorrido por el camino más corto entre dos tríadas: `Tonnetz(caminoDesde: "Do", hasta: "Mibm")`.
    public init?(caminoDesde origen: Acorde, hasta destino: Acorde) {
        guard let camino = origen.caminoNeorriemanniano(hasta: destino), let inicio = Triada(origen) else {
            return nil
        }
        var triadas = [inicio]
        var actual = inicio
        for paso in camino {
            actual = actual.transformar(paso)
            triadas.append(actual)
        }
        self.init(recorrido: triadas.map(\.acorde))
    }

    /// Distancia al cuadrado entre los centros de dos triángulos, en el dibujo.
    package static func separacion(_ uno: Triada, _ otro: Triada) -> Double {
        let (x1, y1) = uno.centro
        let (x2, y2) = otro.centro
        return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
    }
}

extension Tonnetz.Triada {
    /// El centro del triángulo en el dibujo, con paso 1.
    package var centro: (Double, Double) {
        let xs = vertices.map { Double($0.quintas) + Double($0.terceras) / 2 }
        let ys = vertices.map { -Double($0.terceras) * 0.8660254037844386 }
        return (xs.reduce(0, +) / 3, ys.reduce(0, +) / 3)
    }
}
