import Elementos

// MARK: - Los bloques de EstadisticasDeAcorde que dependen de las voces

/// Cómo se perciben las voces de un acorde: las fundamentales de Parncutt y de Terhardt, la tensión y la modalidad de
/// Cook y Fujisawa, las rugosidades de Sethares, Vassilakis y Hutchinson y Knopoff, la entropía armónica de Erlich y la
/// fusión tonal de Huron. La disposición de un tipo y la de un acorde con nombre suenan desde el Do central; la de un
/// `Acorde`, en su posición cerrada desde el bajo en la cuarta octava.
public struct PsicoacusticaDeAcorde: Hashable, Sendable {
    /// Sus notas de la más a la menos prominente como fundamental en el modelo de Parncutt (1988): cada nota suma el
    /// peso de las que la apoyan (la quinta 5, la tercera mayor 3, la séptima menor 2, la segunda mayor 1, y ella
    /// misma 10). En Do Mi Sol, Do pesa 18; en La Do Mi Sol, Do (18) le gana a La (17).
    public let prominenciasDeParncutt: [ProminenciaDeFundamental]
    /// La fundamental virtual de Terhardt, como intervalo desde la nota de referencia: puede no ser del acorde.
    public let fundamentalVirtual: Intervalo?
    /// La tensión de Cook y Fujisawa (2006), con tonos puros: alta cuando dos intervalos seguidos son iguales (1 en el
    /// aumentado y en el disminuido), casi 0 en las tríadas mayor y menor.
    public let tensionDeCook: Double
    /// La modalidad de Cook y Fujisawa (2006), con tonos puros: positiva en la tríada mayor (+1,558), negativa en la
    /// menor (−1,558).
    public let modalidadDeCook: Double
    /// La rugosidad sensorial de Sethares (1993), con seis armónicos por voz. Cuanto más alta, más áspero.
    public let rugosidad: Double
    /// La rugosidad de Vassilakis, como la de Sethares.
    public let rugosidadDeVassilakis: Double
    /// La disonancia de Hutchinson y Knopoff, entre 0 y 1.
    public let rugosidadDeHutchinsonKnopoff: Double
    /// La entropía armónica de Erlich media de los intervalos entre voces, en bits: cuanto más baja, más claramente se
    /// oye cada intervalo como una razón sencilla.
    public let entropiaArmonica: Double
    /// La fusión tonal (Huron): la proporción de pares de voces a unísono, octava o quinta.
    public let fusionTonal: Double

    /// La nota más prominente como fundamental en el modelo de Parncutt, como intervalo desde la nota de referencia.
    public var fundamentalDeParncutt: Intervalo? { prominenciasDeParncutt.first?.intervalo }

    /// Las de unas voces de grave a agudo, con la más grave en `graveMidi`, y todas las notas del acorde en pasos de
    /// quinta.
    init(_ voces: [VozMedida], pasosDeQuinta: Set<Int>, graveMidi: Int) {
        prominenciasDeParncutt = Psicoacustica.prominencias(voces)
        fundamentalVirtual = Psicoacustica.fundamentalVirtual(pasosDeQuinta: pasosDeQuinta).map {
            Intervalo.simpleAscendente(pasosDeQuinta: $0)
        }
        (tensionDeCook, modalidadDeCook) = Psicoacustica.tensionYModalidad(voces)
        rugosidad = Psicoacustica.rugosidad(voces, desdeMidi: graveMidi)
        rugosidadDeVassilakis = Psicoacustica.rugosidadDeVassilakis(voces, desdeMidi: graveMidi)
        rugosidadDeHutchinsonKnopoff = Psicoacustica.rugosidadDeHutchinsonKnopoff(voces, desdeMidi: graveMidi)
        entropiaArmonica = Psicoacustica.entropiaArmonica(voces)
        fusionTonal = Psicoacustica.fusionTonal(voces)
    }
}

/// Lo que dice la disposición de las voces de un acorde: el grupo y la fundamental de Hindemith, los intervalos entre
/// voces y su forma (cerrada, drop 2…). La de un tipo es la de sus `intervalos`, y la de un `Acorde`, su posición
/// cerrada desde el bajo.
public struct DisposicionDeVoces: Hashable, Sendable {
    /// Su grupo en la clasificación de Hindemith (`GrupoDeHindemith`).
    public let grupoDeHindemith: GrupoDeHindemith
    /// La fundamental según Hindemith, como intervalo desde la nota de referencia (la fundamental del tipo, o la nota
    /// más grave si no se lee por terceras): la del mejor intervalo de la disposición, la quinta antes que la cuarta,
    /// la tercera mayor… En la semidisminuida es la tercera (Mi♭ en Dom7(♭5), que suena como Mi♭m6). `nil` en los
    /// grupos indeterminados (V y VI).
    public let fundamentalDeHindemith: Intervalo?
    /// Los semitonos entre cada voz y la de encima, de grave a agudo: 4 3 en la tríada mayor cerrada, 6 4 5 en el de
    /// Tristán (Fa Si Re♯ Sol♯).
    public let intervalosEntreVoces: [Int]
    /// Cerrada, drop 2, drop 3 o drop 2 + 4; `nil` si es otra abierta.
    public let disposicion: DisposicionDeAcorde?
    /// Sus intervalos entre voces no crecen de grave a agudo, como en la serie armónica (los anchos abajo).
    public let respetaLaSerieArmonica: Bool

    /// La de unas voces de grave a agudo, con todas las notas del acorde en pasos de quinta.
    init(_ voces: [VozMedida], pasosDeQuinta: Set<Int>) {
        let fundamental = Hindemith.fundamentalDeHindemith(voces)
        grupoDeHindemith = Hindemith.grupoDeHindemith(
            pasosDeQuinta: pasosDeQuinta, fundamental: fundamental, bajo: voces.first?.pasosDeQuinta)
        fundamentalDeHindemith =
            grupoDeHindemith.indeterminado ? nil : fundamental.map { Intervalo.simpleAscendente(pasosDeQuinta: $0) }
        intervalosEntreVoces = zip(voces, voces.dropFirst()).map { $1.semitonos - $0.semitonos }
        disposicion = Self.disposicion(voces.map(\.semitonos))
        respetaLaSerieArmonica = zip(intervalosEntreVoces, intervalosEntreVoces.dropFirst()).allSatisfy { $0 >= $1 }
    }

    /// La disposición de las voces, en semitonos desde la grave: cerrada si caben en una octava; drop 2, drop 3 o drop
    /// 2 + 4 si lo son de una cerrada (subiendo una octava la voz o las dos voces graves, quedan cerradas y en el
    /// segundo, tercero o segundo y cuarto lugar desde arriba); `nil` en cualquier otra abierta.
    static func disposicion(_ semitonos: [Int]) -> DisposicionDeAcorde? {
        let voces = semitonos.sorted()
        func cerrada(_ alturas: [Int]) -> Bool { (alturas.max() ?? 0) - (alturas.min() ?? 0) < 12 }
        guard voces.count >= 2 else { return .cerrada }
        if cerrada(voces) { return .cerrada }
        guard voces.count >= 4 else { return nil }
        // El lugar desde arriba (1 la más aguda) de cada voz subida, si queda cerrada.
        func lugares(subiendo cuantas: Int) -> [Int]? {
            let subidas = voces.prefix(cuantas).map { $0 + 12 }
            let todas = (subidas + voces.dropFirst(cuantas)).sorted(by: >)
            guard cerrada(todas), Set(todas).count == todas.count else { return nil }
            return subidas.compactMap { todas.firstIndex(of: $0).map { $0 + 1 } }.sorted()
        }
        if let lugar = lugares(subiendo: 1) {
            if lugar == [2] { return .drop2 }
            if lugar == [3] { return .drop3 }
        }
        if lugares(subiendo: 2) == [2, 4] { return .drop24 }
        return nil
    }
}
