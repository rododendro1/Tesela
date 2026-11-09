import Elementos

// MARK: - Lo que se mide de un acorde

/// Lo que se mide de un acorde por sus notas: cuántas tiene, si se lee por terceras, lo brillante que es, qué
/// intervalos contiene y cuánto se repite. Es el hermano de `EstadisticasDeEscala`. El brillo y la amplitud salen de
/// la ortografía (los pasos de quinta); los intervalos, el número de Forte y la simetría, de las clases de altura.
///
///     let dominante = TipoDeAcorde.dominanteSeptima.estadisticas
///     dominante.cardinal                  // .tetrada
///     dominante.brilloPorQuintas          // 0.75
///     dominante.vectorIntervalico         // [0, 1, 2, 1, 1, 1]
///     dominante.numeroDeForte             // "4-27"
///     TipoDeAcorde.disminuidoSeptima.estadisticas.transposicionesDistintas   // 3
///     AcordeConNombre.petrushka.estadisticas.porTerceras                     // false
public struct EstadisticasDeAcorde: Hashable, Sendable {
    /// Las notas distintas, por su ortografía (las octavas no cuentan).
    public let numeroDeNotas: Int
    public let cardinal: CardinalDeAcorde?
    /// Sus notas se leen por terceras (`TipoDeAcorde`): no en el de Petrushka ni en un cluster.
    public let porTerceras: Bool
    /// Cuántas tensiones (9ª, 11ª, 13ª y sus alteraciones) lleva, si se lee por terceras: 0 en Do7, 1 en Do9, 2 en
    /// Do7(♭9,♯11).
    public let tensiones: Int?
    /// La media de las quintas que hay de la fundamental a cada nota (Sol +1, Mi +4, Si♭ −2): cuanto más alta, más
    /// brillante. La tríada mayor +1,67, la menor −0,67, la séptima de dominante +0,75, la disminuida −4,5. `nil` si
    /// no se lee por terceras, porque entonces no tiene fundamental.
    public let brilloPorQuintas: Double?
    /// Las quintas que van de la nota más bemol a la más sostenida: 4 en la tríada mayor (Do–Mi), 6 en la séptima de
    /// dominante (Si♭–Mi), 9 en la séptima disminuida.
    public let amplitudEnQuintas: Int
    /// Cuántas veces aparece cada clase interválica, del semitono al tritono
    /// (`ConjuntoDeClasesDeAltura.vectorIntervalico`): 0 0 1 1 1 0 en la tríada mayor.
    public let vectorIntervalico: [Int]
    /// Su forma prima (de Forte): [0, 3, 7] en las tríadas mayor y menor.
    public let formaPrima: [Int]
    /// El de su forma prima («3-11» las tríadas mayor y menor), si lo tiene.
    public let numeroDeForte: String?
    /// Las transposiciones con notas distintas: 12 si no es simétrico, 4 el aumentado, 3 el de séptima disminuida.
    public let transposicionesDistintas: Int
    /// Alguna inversión lo deja igual, como la séptima disminuida, el aumentado o el sus4 (Do Fa Sol = Sol Fa Do
    /// invertido). No la tríada mayor ni la séptima de dominante, que invertidas dan la menor y la semidisminuida.
    public let simetricoPorInversion: Bool
    /// Sin semitonos entre ninguna de sus notas (en cualquier octava), como las tríadas y las cuatríadas sin séptima
    /// mayor.
    public let anhemitonico: Bool
    /// Con un tritono entre dos de sus notas, como la séptima de dominante, el disminuido y el de Petrushka.
    public let conTritono: Bool
    /// Los semitonos de la nota más grave a la más aguda de su disposición: 15 en el de Tristán (Fa–Sol♯ de la
    /// octava de arriba). Solo en los acordes con nombre, que guardan una; `nil` en un tipo o un acorde cifrado.
    public let ambito: Int?

    /// Lo que se mide de unas notas, en pasos de quinta desde la fundamental (o desde la más grave, sin tipo).
    init(pasosDeQuinta: Set<Int>, tipo: TipoDeAcorde?, ambito: Int?) {
        numeroDeNotas = pasosDeQuinta.count
        cardinal = CardinalDeAcorde(numeroDeNotas: numeroDeNotas)
        porTerceras = tipo != nil
        tensiones = tipo?.tensiones.count
        brilloPorQuintas = tipo.map { _ in
            pasosDeQuinta.isEmpty ? 0 : Double(pasosDeQuinta.reduce(0, +)) / Double(pasosDeQuinta.count)
        }
        amplitudEnQuintas = (pasosDeQuinta.max() ?? 0) - (pasosDeQuinta.min() ?? 0)
        let conjunto = ConjuntoDeClasesDeAltura(pasosDeQuinta.map { $0 * 7 })
        vectorIntervalico = conjunto.vectorIntervalico
        formaPrima = conjunto.formaPrima
        numeroDeForte = conjunto.numeroDeForte
        transposicionesDistintas = 12 / max(conjunto.simetriasPorTransposicion, 1)
        simetricoPorInversion = conjunto.simetriasPorInversion > 0
        anhemitonico = conjunto.vectorIntervalico.first == 0
        conTritono = (conjunto.vectorIntervalico.last ?? 0) > 0
        self.ambito = ambito
    }

    public init(_ tipo: TipoDeAcorde) { self.init(pasosDeQuinta: tipo.pasosDeQuinta, tipo: tipo, ambito: nil) }

    public init(_ acorde: AcordeConNombre) {
        let semitonos = acorde.intervalos.map(\.semitonos)
        self.init(
            pasosDeQuinta: acorde.pasosDeQuinta, tipo: acorde.tipo,
            ambito: (semitonos.max() ?? 0) - (semitonos.min() ?? 0))
    }

    /// Las del tipo, y con el bajo si es ajeno: Do/Re es una tétrada con la novena abajo.
    public init(_ acorde: Acorde) {
        let bajo = acorde.bajo.pasosDeQuinta - acorde.fundamental.pasosDeQuinta
        self.init(pasosDeQuinta: acorde.tipo.pasosDeQuinta.union([bajo]), tipo: acorde.tipo, ambito: nil)
    }
}

extension TipoDeAcorde {
    /// Lo que se mide del tipo (`EstadisticasDeAcorde`): su cardinal, su brillo, sus intervalos, su simetría.
    public var estadisticas: EstadisticasDeAcorde { EstadisticasDeAcorde(self) }
}

extension AcordeConNombre {
    /// Lo que se mide del acorde (`EstadisticasDeAcorde`), con el ámbito de su disposición.
    public var estadisticas: EstadisticasDeAcorde { EstadisticasDeAcorde(self) }
}

extension Acorde {
    /// Lo que se mide del acorde (`EstadisticasDeAcorde`), con el bajo si es ajeno.
    public var estadisticas: EstadisticasDeAcorde { EstadisticasDeAcorde(self) }
}
