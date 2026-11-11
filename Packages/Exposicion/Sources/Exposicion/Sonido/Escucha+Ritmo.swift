import Armonia

extension Escucha {
    /// El tempo de los ritmos del catálogo, si no se da otro: negra a 90.
    public static let tempoDeRitmo = Tempo(90)

    /// Un ritmo del catálogo, `vueltas` veces seguidas: cada golpe fuerte (`x`) es un Do3 y cada débil (`o`), un
    /// Sol4, cortos y en su pulso; los pulsos en silencio no suenan. El pulso es la figura de `ritmo.unidad` al
    /// `tempo` dado.
    ///
    ///     let clave = Escucha.ritmo(.claveDeSon, vueltas: 1, tempo: Tempo(60))
    ///     clave.notas.map(\.inicio)   // [0, 0.75, 1.5, 2.5, 3]
    public static func ritmo(_ ritmo: RitmoConNombre, vueltas: Int = 2, tempo: Tempo = tempoDeRitmo) -> Escucha {
        let pulso = 60 / tempo.negrasPorMinuto * 4 / Double(ritmo.unidad)
        var notas: [NotaMIDI] = []
        for vuelta in 0..<max(vueltas, 0) {
            for (i, golpe) in ritmo.golpes.enumerated() {
                guard let golpe else { continue }
                let inicio = Double(vuelta * ritmo.pulsos + i) * pulso
                notas.append(NotaMIDI(midi: golpe == .fuerte ? 48 : 67, inicio: inicio, duracion: pulso * 0.8))
            }
        }
        return Escucha(notas: notas)
    }
}
