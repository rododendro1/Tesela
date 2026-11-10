import Elementos

// MARK: - Lo que se mide de una escala

/// Lo que se mide de una escala por sus notas: cuántas tiene, lo brillante que es, qué intervalos contiene, cómo se
/// reparten y cuánto se repite. Salvo el brillo por quintas, que usa la ortografía, todo sale de las clases de altura
/// (los doce semitonos): en una escala con microtonos es una aproximación, y `aproximada` lo dice.
///
///     let mayor = Escala(.do, .mayor).estadisticas
///     mayor.cardinal              // .heptatonica
///     mayor.brilloPorQuintas      // 2.0 (lidio 3, locrio −3)
///     mayor.vectorIntervalico     // [2, 5, 4, 3, 6, 1]
///     mayor.maximamenteRegular    // true
public struct EstadisticasDeEscala: Hashable, Sendable {
    /// Las notas por octava, en la forma ascendente.
    public let numeroDeNotas: Int
    public let cardinal: CardinalDeEscala?
    /// El de `Escala.brillo`: los semitonos que suben (+) o bajan (−) sus grados respecto a la mayor. Solo en las de
    /// siete notas.
    public let brillo: Int?
    /// La media de las quintas que hay de la tónica a cada nota (Sol +1, Fa −1, Fa♯ +6): cuanto más alta, más
    /// brillante. Vale para cualquier número de notas: la mayor y la pentatónica mayor 2, el lidio 3, el dórico 0, la
    /// pentatónica menor −1, el locrio −3. En las de siete notas, una por letra, es `brillo + 2`.
    public let brilloPorQuintas: Double
    /// Los semitonos de cada paso, de la tónica a la octava: 2 2 1 2 2 2 1 en la mayor.
    public let pasos: [Int]
    /// Cuántas veces aparece cada clase interválica, del semitono al tritono
    /// (`ConjuntoDeClasesDeAltura.vectorIntervalico`): 2 5 4 3 6 1 en la mayor.
    public let vectorIntervalico: [Int]
    /// Sin semitonos entre ninguna de sus notas, como las pentatónicas y la de tonos enteros.
    public let anhemitonica: Bool
    /// Con dos semitonos seguidos (Si–Do–Re♭), como la cromática y las bebop.
    public let cohemitonica: Bool
    /// Las transposiciones con notas distintas: 12 si no es simétrica, 3 la disminuida, 2 la de tonos enteros.
    public let transposicionesDistintas: Int
    /// El de su forma prima («7-35» la mayor), si lo tiene.
    public let numeroDeForte: String?
    /// Sus notas están repartidas tan por igual como se puede: cada intervalo genérico (de segunda, de tercera…)
    /// tiene a lo sumo dos tamaños seguidos, como en la mayor, las pentatónicas, la de tonos enteros y la disminuida.
    public let maximamenteRegular: Bool
    /// La escala tiene microtonos, y lo medido en semitonos es su aproximación a los doce.
    public let aproximada: Bool

    // Lo que hace falta para las medidas de las teorías, que se calculan al pedirlas.
    /// Sus clases de altura desde la tónica, de menor a mayor.
    let clases: [Int]
    /// Sus notas en quintas desde la tónica, sin repetir.
    let quintas: Set<Int>
    let conjuntoDeClases: ConjuntoDeClasesDeAltura

    // MARK: Lo que dicen las teorías de escalas

    /// Lo que dice la teoría de conjuntos de sus clases de altura (`MedidasDeConjunto`): Huron, Fourier, Hanson,
    /// Messiaen, Forte, Zeitler, Balzano, Babbitt y la parsimonia de Tymoczko.
    public var conjunto: MedidasDeConjunto { conjuntoDeClases.medidas }

    /// Lo que dice la afinación justa de sus notas, por su ortografía (`MedidasDeAfinacionJusta`).
    public var afinacion: MedidasDeAfinacionJusta { MedidasDeAfinacionJusta(pasosDeQuinta: quintas) }

    /// Lo que dicen de ella sus intervalos genéricos (`IntervalosGenericosDeEscala`): Myhill, la buena formación,
    /// Rothenberg y Carey.
    public var intervalosGenericos: IntervalosGenericosDeEscala { IntervalosGenericosDeEscala(clases, pasos: pasos) }

    /// Lo que dice de ella la armonía tonal (`MedidasTonalesDeEscala`): sus acordes por grados, el perfil de
    /// Krumhansl y Kessler, la sensible y los tetracordos.
    public var tonal: MedidasTonalesDeEscala { MedidasTonalesDeEscala(clases) }

    /// Cómo se perciben sus intervalos (`PsicoacusticaDeEscala`): la entropía armónica y la rugosidad media.
    public var psicoacustica: PsicoacusticaDeEscala { PsicoacusticaDeEscala(clases) }

    public init(_ escala: Escala) {
        let tipo = escala.tipo
        numeroDeNotas = tipo.numeroDeNotas
        cardinal = tipo.cardinal
        brillo = escala.brillo
        let quintas = escala.notas.map { $0.pasosDeQuinta - escala.tonica.pasosDeQuinta }
        brilloPorQuintas = quintas.isEmpty ? 0 : Double(quintas.reduce(0, +)) / Double(quintas.count)
        let conjunto = escala.conjuntoDeClasesDeAltura
        let desdeLaTonica = conjunto.clases.map { modulo($0 - escala.tonica.claseDeAltura, 12) }.sorted()
        let pasos = zip(desdeLaTonica, desdeLaTonica.dropFirst() + [12]).map { $1 - $0 }
        self.pasos = pasos
        vectorIntervalico = conjunto.vectorIntervalico
        anhemitonica = conjunto.vectorIntervalico.first == 0
        cohemitonica = pasos.indices.contains { pasos[$0] == 1 && pasos[($0 + 1) % pasos.count] == 1 }
        transposicionesDistintas = escala.transposicionesDistintas
        numeroDeForte = conjunto.numeroDeForte
        maximamenteRegular = Self.esMaximamenteRegular(desdeLaTonica)
        aproximada = escala.notasMicrotonales() != nil

        clases = desdeLaTonica
        self.quintas = Set(quintas)
        conjuntoDeClases = conjunto
    }

    /// Para cada intervalo genérico `k`, los tamaños de los `k` pasos seguidos, desde cada nota, se separan a lo
    /// sumo en un semitono (Clough y Douthett, 1991).
    static func esMaximamenteRegular(_ clases: [Int]) -> Bool {
        let n = clases.count
        guard n > 1 else { return true }
        return (1..<n).allSatisfy { k in
            let tamanos = (0..<n).map { i in modulo(clases[(i + k) % n] - clases[i], 12) }
            return (tamanos.max() ?? 0) - (tamanos.min() ?? 0) <= 1
        }
    }
}

/// Lo que dicen de una escala sus intervalos genéricos (de segunda, de tercera…, contados por grados): la propiedad
/// de Myhill, el generador y la buena formación, la propiedad de Rothenberg y el cociente de igualdad de Carey.
public struct IntervalosGenericosDeEscala: Hashable, Sendable {
    /// La propiedad de Myhill: cada intervalo genérico tiene exactamente dos tamaños, como en la mayor y las
    /// pentatónicas.
    public let propiedadDeMyhill: Bool
    /// El intervalo, de 1 a 6 semitonos, que la genera en cadena (5 la mayor, una cadena de cuartas o de quintas; 2 la
    /// de tonos enteros), si la genera alguno.
    public let generador: Int?
    /// Bien formada (Carey y Clampitt, 1989): generada y con la propiedad de Myhill, o con todos sus pasos iguales.
    /// Son los «momentos de simetría» (MOS) de Wilson.
    public let bienFormada: Bool
    /// La propiedad de Rothenberg: estrictamente propia, propia o impropia.
    public let propiedadDeRothenberg: PropiedadDeRothenberg
    /// Los pares de intervalos de clases genéricas distintas con el mismo tamaño (la segunda aumentada y la tercera
    /// menor de la menor armónica).
    public let ambiguedades: Int
    /// Los pares de intervalos en que el de menos grados es mayor.
    public let contradicciones: Int
    /// La estabilidad de Rothenberg: la proporción de intervalos cuyo tamaño no comparte ninguna otra clase genérica.
    public let estabilidad: Double
    /// El cociente de igualdad, a la manera de Carey: 1 menos la proporción de ambigüedades.
    public let cocienteDeIgualdad: Double
    /// La anchura media del espectro de cada intervalo genérico, en semitonos.
    public let anchuraDelEspectro: Double

    /// Los de unas clases de altura desde la tónica, con sus pasos.
    init(_ clases: [Int], pasos: [Int]) {
        propiedadDeMyhill = MedidasDeEscala.propiedadDeMyhill(clases)
        generador = MedidasDeEscala.generador(clases)
        bienFormada = generador != nil && (propiedadDeMyhill || Set(pasos).count == 1)
        let rothenberg = MedidasDeEscala.rothenberg(clases)
        propiedadDeRothenberg = rothenberg.propiedad
        ambiguedades = rothenberg.ambiguedades
        contradicciones = rothenberg.contradicciones
        estabilidad = rothenberg.estabilidad
        cocienteDeIgualdad = MedidasDeEscala.cocienteDeIgualdad(clases, ambiguedades: rothenberg.ambiguedades)
        anchuraDelEspectro = MedidasDeEscala.anchuraDelEspectro(clases)
    }
}

/// Lo que dice de una escala la armonía tonal: sus tríadas y cuatríadas por grados, cuánto se parece a una tonalidad
/// mayor o menor, si tiene sensible y si se parte en dos tetracordos iguales.
public struct MedidasTonalesDeEscala: Hashable, Sendable {
    /// Las tríadas por terceras de cada grado (solo en las de siete notas): «», «m», «°», «+», «?».
    public let triadasPorGrados: [String]?
    /// Las cuatríadas por terceras de cada grado (solo en las de siete notas): «maj7», «m7», «7», «ø7»…
    public let cuatriadasPorGrados: [String]?
    /// La correlación de sus notas con el perfil de Krumhansl y Kessler de la tonalidad mayor sobre su tónica.
    public let perfilMayor: Double
    /// La correlación con el perfil de la tonalidad menor.
    public let perfilMenor: Double
    /// Tiene sensible: la nota un semitono bajo la tónica.
    public let conSensible: Bool
    /// Se parte en dos tetracordos iguales separados por un tono, como la mayor.
    public let tetracordosIguales: Bool

    /// Las de unas clases de altura desde la tónica.
    init(_ clases: [Int]) {
        let armonizacion = MedidasDeEscala.armonizacion(clases)
        triadasPorGrados = armonizacion?.triadas
        cuatriadasPorGrados = armonizacion?.cuatriadas
        perfilMayor = MedidasDeEscala.correlacion(clases, con: MedidasDeEscala.perfilMayor)
        perfilMenor = MedidasDeEscala.correlacion(clases, con: MedidasDeEscala.perfilMenor)
        conSensible = clases.contains(11)
        tetracordosIguales = MedidasDeEscala.tetracordosIguales(clases)
    }
}

/// Cómo se perciben los intervalos de una escala, cada par de notas como una díada.
public struct PsicoacusticaDeEscala: Hashable, Sendable {
    /// La entropía armónica de Erlich media de sus intervalos, en bits.
    public let entropiaArmonica: Double
    /// La rugosidad de Sethares media de sus intervalos, como díadas desde el Do central.
    public let rugosidadMedia: Double

    /// Las de unas clases de altura desde la tónica.
    init(_ clases: [Int]) {
        entropiaArmonica = MedidasDeEscala.entropiaArmonica(clases)
        rugosidadMedia = MedidasDeEscala.rugosidadMedia(clases)
    }
}

extension Escala {
    /// Lo que se mide de la escala (`EstadisticasDeEscala`): su cardinal, su brillo, sus intervalos, su simetría.
    public var estadisticas: EstadisticasDeEscala { EstadisticasDeEscala(self) }
}
