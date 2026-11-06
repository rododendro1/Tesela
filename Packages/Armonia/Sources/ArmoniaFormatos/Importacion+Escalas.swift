import ArmoniaNucleo
import ArmoniaPartitura
import ArmoniaTeoria

// MARK: - Las escalas de una pieza

extension PiezaImportada {
    /// Las clases de altura que suenan en la pieza, de la que más dura a la que menos, sin las que suenan menos de
    /// `umbral` del total (las notas de paso sueltas): 0 es Do, 1 Do♯…
    public func clasesDeAltura(umbral: Double = 0.02) -> [Int] {
        var pesos = [Double](repeating: 0, count: 12)
        for nota in notas { pesos[modulo(nota.altura.midi, 12)] += nota.duracion.enRedondas }
        let total = pesos.reduce(0, +)
        guard total > 0 else { return [] }
        let suenan = (0..<12).filter { pesos[$0] > 0 && pesos[$0] / total >= umbral }
        return suenan.sorted { (-pesos[$0], $0) < (-pesos[$1], $1) }
    }

    /// Las escalas que contienen las notas de la pieza, de más a menos probable (las que menos notas añaden); a
    /// igual coste, primero las que empiezan en la tónica de ``tonalidadEstimada``.
    ///
    ///     let pieza = try PiezaImportada(leyendo: datos)   // una melodía en Re dórico
    ///     pieza.escalas().first                             // Re dórico
    public func escalas(umbral: Double = 0.02, tipos: [TipoDeEscala] = TipoDeEscala.occidentales) -> [Escala] {
        let candidatos = Escala.candidatos(clasesDeAltura: clasesDeAltura(umbral: umbral), tipos: tipos)
        let tonica = tonalidadEstimada?.tonica.claseDeAltura
        return candidatos.enumerated()
            .sorted { a, b in
                let claveA = (a.element.coste, a.element.valor.tonica.claseDeAltura == tonica ? 0 : 1, a.offset)
                let claveB = (b.element.coste, b.element.valor.tonica.claseDeAltura == tonica ? 0 : 1, b.offset)
                return claveA < claveB
            }
            .map(\.element.valor)
    }
}
