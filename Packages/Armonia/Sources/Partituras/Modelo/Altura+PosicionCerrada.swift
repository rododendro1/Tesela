import Elementos

extension Altura {
    /// Las notas apiladas en posición cerrada: la primera, en la primera octava en que su MIDI
    /// llegue a `minimo`, y cada una, en la primera octava por encima de la anterior.
    package static func posicionCerrada(_ notas: [Nota], desde minimo: Int) -> [Altura] {
        var alturas: [Altura] = []
        for nota in notas {
            let limite = alturas.last.map { $0.midi + 1 } ?? minimo
            var octava = 0
            while Altura(nota, octava: octava).midi < limite { octava += 1 }
            alturas.append(Altura(nota, octava: octava))
        }
        return alturas
    }
}
