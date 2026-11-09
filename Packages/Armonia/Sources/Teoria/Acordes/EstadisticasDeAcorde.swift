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
    /// La consonancia diádica agregada de Huron (1994): la suma, sobre el vector interválico, de lo consonante que es
    /// cada clase de intervalo (la quinta +1,24, la tercera menor +0,594, el semitono −1,428…). Cuanto más alta, más
    /// consonante: 2,22 las tríadas mayor y menor, 1,779 la séptima de dominante, 1,47 la séptima disminuida.
    public let consonanciaDiadica: Double
    /// Su grupo en la clasificación de Hindemith (`GrupoDeHindemith`).
    public let grupoDeHindemith: GrupoDeHindemith
    /// La fundamental según Hindemith, como intervalo desde la nota de referencia (la fundamental del tipo, o la nota
    /// más grave si no se lee por terceras): la del mejor intervalo de la disposición, la quinta antes que la cuarta,
    /// la tercera mayor… En la semidisminuida es la tercera (Mi♭ en Dom7(♭5), que suena como Mi♭m6). `nil` en los
    /// grupos indeterminados (V y VI).
    public let fundamentalDeHindemith: Intervalo?
    /// Los semitonos entre cada voz y la de encima, de grave a agudo, en la disposición: 4 3 en la tríada mayor
    /// cerrada, 6 4 5 en el de Tristán (Fa Si Re♯ Sol♯). La de un tipo es la de sus `intervalos`, y la de un `Acorde`,
    /// su posición cerrada desde el bajo.
    public let intervalosEntreVoces: [Int]
    /// El gradus suavitatis de Euler (1739), sin contar las octavas: 1 una nota, 3 la quinta, 7 las tríadas mayor y
    /// menor, 11 la séptima de dominante. Cuanto más bajo, más suave.
    public let gradoDeSuavidad: Int
    /// Las magnitudes de sus coeficientes de Fourier, de |f1| a |f6| (Quinn 2006; Amiot 2016): cuánto se parece al
    /// cluster cromático, al tritono, al aumentado, a la séptima disminuida, a la escala diatónica y a la de tonos
    /// enteros. La tríada mayor tiene |f3| y |f5| altos; el aumentado, |f3| = 3.
    public let magnitudesDeFourier: [Double]
    /// Sus notas de la más a la menos prominente como fundamental en el modelo de Parncutt (1988): cada nota suma el
    /// peso de las que la apoyan (la quinta 5, la tercera mayor 3, la séptima menor 2, la segunda mayor 1, y ella
    /// misma 10). En Do Mi Sol, Do pesa 18; en La Do Mi Sol, Do (18) le gana a La (17).
    public let prominenciasDeParncutt: [ProminenciaDeFundamental]
    /// La distancia, en semitonos, al acorde perfectamente repartido más cercano de su mismo número de notas
    /// (Tymoczko 2011): 0 el aumentado y la séptima disminuida, 0,816 las tríadas mayor y menor.
    public let distanciaALaUniformidad: Double
    /// Las tríadas mayores, menores, disminuidas y aumentadas que caben en sus notas: la novena de dominante tiene una
    /// mayor (Do Mi Sol), una menor (Sol Si♭ Re) y una disminuida (Mi Sol Si♭).
    public let triadasContenidas: TriadasContenidas
    /// La tensión de Cook y Fujisawa (2006), con tonos puros: alta cuando dos intervalos seguidos son iguales (1 en el
    /// aumentado y en el disminuido), casi 0 en las tríadas mayor y menor.
    public let tensionDeCook: Double
    /// La modalidad de Cook y Fujisawa (2006), con tonos puros: positiva en la tríada mayor (+1,558), negativa en la
    /// menor (−1,558).
    public let modalidadDeCook: Double
    /// La rugosidad sensorial de Sethares (1993), con seis armónicos por voz, en la disposición: la de un tipo y la de
    /// un acorde con nombre suenan desde el Do central; la de un `Acorde`, en su posición cerrada desde el bajo en la
    /// cuarta octava. Cuanto más alta, más áspero.
    public let rugosidad: Double

    /// La altura de Tenney media de los intervalos justos entre cada par de notas: log₂(n·d). Cuanto más baja, más
    /// sencillas sus razones.
    public let alturaDeTenney: Double
    /// El límite impar (Partch): la mayor parte impar de los intervalos justos entre sus notas. 5 la tríada mayor, 45 la
    /// séptima de dominante, por su tritono (45/32).
    public let limiteImpar: Int
    /// El límite primo (Partch) de sus intervalos justos: 2, 3 o 5.
    public let limitePrimo: Int
    /// La armonicidad de Gill y Purves: el porcentaje medio de armónicos que comparten sus notas dos a dos.
    public let armonicidad: Double
    /// La entropía armónica de Erlich media de los intervalos entre voces, en bits: cuanto más baja, más claramente se
    /// oye cada intervalo como una razón sencilla.
    public let entropiaArmonica: Double
    /// La fundamental virtual de Terhardt, como intervalo desde la nota de referencia: puede no ser del acorde.
    public let fundamentalVirtual: Intervalo?
    /// La fusión tonal (Huron): la proporción de pares de voces a unísono, octava o quinta.
    public let fusionTonal: Double
    /// La rugosidad de Vassilakis de la disposición, como la de Sethares.
    public let rugosidadDeVassilakis: Double
    /// La disonancia de Hutchinson y Knopoff de la disposición, entre 0 y 1.
    public let rugosidadDeHutchinsonKnopoff: Double
    /// El número de Forte del conjunto en relación Z con el suyo (el mismo vector interválico sin ser la misma clase),
    /// si lo tiene: 4-Z29 para 4-Z15.
    public let parejaZ: String?
    /// El número de Forte de las notas que le faltan para las doce.
    public let complemento: String?
    /// La disposición de sus voces: cerrada, drop 2, drop 3 o drop 2 + 4; `nil` si es otra abierta.
    public let disposicion: DisposicionDeAcorde?
    /// Si sus intervalos entre voces no crecen de grave a agudo, como en la serie armónica (los anchos abajo).
    public let respetaLaSerieArmonica: Bool

    /// Lo que se mide de unas notas, en pasos de quinta desde la fundamental (o desde la más grave, sin tipo), con su
    /// disposición de grave a agudo.
    init(pasosDeQuinta: Set<Int>, tipo: TipoDeAcorde?, voces: [VozMedida], ambito: Int?, graveMidi: Int = 60) {
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
        consonanciaDiadica = MedidasDeAcorde.consonanciaDiadica(conjunto.vectorIntervalico)
        let ordenadas = voces.sorted { $0.semitonos < $1.semitonos }
        let fundamental = MedidasDeAcorde.fundamentalDeHindemith(ordenadas)
        let grupo = MedidasDeAcorde.grupoDeHindemith(
            pasosDeQuinta: pasosDeQuinta, fundamental: fundamental, bajo: ordenadas.first?.pasosDeQuinta)
        grupoDeHindemith = grupo
        fundamentalDeHindemith =
            grupo.indeterminado ? nil : fundamental.map { Intervalo.simpleAscendente(pasosDeQuinta: $0) }
        intervalosEntreVoces = zip(ordenadas, ordenadas.dropFirst()).map { $1.semitonos - $0.semitonos }
        gradoDeSuavidad = MedidasDeAcorde.gradoDeSuavidad(pasosDeQuinta: pasosDeQuinta)
        magnitudesDeFourier = MedidasDeAcorde.magnitudesDeFourier(conjunto.clases)
        prominenciasDeParncutt = MedidasDeAcorde.prominencias(ordenadas)
        distanciaALaUniformidad = MedidasDeAcorde.distanciaALaUniformidad(conjunto.clases)
        triadasContenidas = MedidasDeAcorde.triadasContenidas(Set(conjunto.clases))
        (tensionDeCook, modalidadDeCook) = MedidasDeAcorde.tensionYModalidad(ordenadas)
        rugosidad = MedidasDeAcorde.rugosidad(ordenadas, desdeMidi: graveMidi)
        let razones = MedidasDeAcorde.razonesJustas(pasosDeQuinta: pasosDeQuinta)
        alturaDeTenney = MedidasDeAcorde.alturaDeTenney(razones)
        limiteImpar = razones.map(\.limiteImpar).max() ?? 1
        limitePrimo = MedidasDeAcorde.limitePrimo(pasosDeQuinta: pasosDeQuinta)
        armonicidad = MedidasDeAcorde.armonicidad(razones)
        entropiaArmonica = MedidasDeAcorde.entropiaArmonica(ordenadas)
        fundamentalVirtual = MedidasDeAcorde.fundamentalVirtual(pasosDeQuinta: pasosDeQuinta).map {
            Intervalo.simpleAscendente(pasosDeQuinta: $0)
        }
        fusionTonal = MedidasDeAcorde.fusionTonal(ordenadas)
        rugosidadDeVassilakis = MedidasDeAcorde.rugosidadDeVassilakis(ordenadas, desdeMidi: graveMidi)
        rugosidadDeHutchinsonKnopoff = MedidasDeAcorde.rugosidadDeHutchinsonKnopoff(ordenadas, desdeMidi: graveMidi)
        parejaZ = Self.parejaZ(de: conjunto)
        complemento = conjunto.complemento.numeroDeForte
        disposicion = MedidasDeAcorde.disposicion(ordenadas.map(\.semitonos))
        respetaLaSerieArmonica = zip(intervalosEntreVoces, intervalosEntreVoces.dropFirst()).allSatisfy { $0 >= $1 }
    }

    /// La nota más prominente como fundamental en el modelo de Parncutt, como intervalo desde la nota de referencia.
    public var fundamentalDeParncutt: Intervalo? { prominenciasDeParncutt.first?.intervalo }

    public init(_ tipo: TipoDeAcorde) {
        self.init(
            pasosDeQuinta: tipo.pasosDeQuinta, tipo: tipo, voces: Self.voces(tipo.intervalos), ambito: nil)
    }

    public init(_ acorde: AcordeConNombre) {
        let semitonos = acorde.intervalos.map(\.semitonos)
        self.init(
            pasosDeQuinta: acorde.pasosDeQuinta, tipo: acorde.tipo, voces: Self.voces(acorde.intervalos),
            ambito: (semitonos.max() ?? 0) - (semitonos.min() ?? 0))
    }

    /// Las del tipo, y con el bajo si es ajeno: Do/Re es una tétrada con la novena abajo. La disposición es la
    /// posición cerrada desde el bajo.
    public init(_ acorde: Acorde) {
        let referencia = acorde.fundamental.pasosDeQuinta
        let bajo = acorde.bajo.pasosDeQuinta - referencia
        let alturas = acorde.posicionCerrada()
        let grave = alturas.first?.midi ?? 0
        let voces = alturas.map {
            VozMedida(pasosDeQuinta: $0.nota.pasosDeQuinta - referencia, semitonos: $0.midi - grave)
        }
        self.init(
            pasosDeQuinta: acorde.tipo.pasosDeQuinta.union([bajo]), tipo: acorde.tipo, voces: voces, ambito: nil,
            graveMidi: grave)
    }

    /// El número de Forte del conjunto con su mismo vector interválico y otra forma prima, si lo hay.
    private static func parejaZ(de conjunto: ConjuntoDeClasesDeAltura) -> String? {
        guard conjunto.numeroDeForte?.contains("Z") == true else { return nil }
        let vector = conjunto.vectorIntervalico
        return ConjuntoDeClasesDeAltura.tablaForte.first { prima, _ in
            prima.count == conjunto.cardinalidad && prima != conjunto.formaPrima
                && ConjuntoDeClasesDeAltura(prima).vectorIntervalico == vector
        }?.value
    }

    /// Las voces de unos intervalos desde la nota de referencia, sin repetir la misma altura.
    private static func voces(_ intervalos: [Intervalo]) -> [VozMedida] {
        var vistas = Set<Int>()
        return intervalos.compactMap { intervalo in
            guard vistas.insert(intervalo.semitonos).inserted else { return nil }
            return VozMedida(pasosDeQuinta: intervalo.pasosDeQuintaConSigno, semitonos: intervalo.semitonos)
        }
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
