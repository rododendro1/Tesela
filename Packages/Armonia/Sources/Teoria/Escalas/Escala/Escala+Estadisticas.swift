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

    // MARK: Lo que dicen las teorías de escalas

    /// La propiedad de Myhill: cada intervalo genérico tiene exactamente dos tamaños, como en la mayor y las
    /// pentatónicas.
    public let propiedadDeMyhill: Bool
    /// El intervalo, de 1 a 6 semitonos, que la genera en cadena (5 la mayor, una cadena de cuartas o de quintas; 2 la
    /// de tonos enteros), si la genera alguno.
    public let generador: Int?
    /// Bien formada (Carey y Clampitt, 1989): generada y con la propiedad de Myhill, o con todos sus pasos iguales.
    /// Son los «momentos de simetría» (MOS) de Wilson.
    public let bienFormada: Bool
    /// La propiedad de Rothenberg, con sus ambigüedades y contradicciones y su estabilidad.
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
    /// Profunda (Gamer, 1967): cada clase interválica aparece un número de veces distinto, como en la mayor (2 5 4 3 6
    /// 1).
    public let profunda: Bool
    /// La consonancia diádica de Huron (1994) de su vector interválico.
    public let consonanciaDiadica: Double
    /// Las magnitudes de Fourier |f1|…|f6| (Quinn, Amiot): |f5| alta en las diatónicas, |f6| en la de tonos enteros.
    public let magnitudesDeFourier: [Double]
    /// Equilibrada (Milne y otros, 2017): |f1| = 0, sus notas como vectores en el círculo se anulan.
    public let equilibrada: Bool
    /// La distancia a la uniformidad de Tymoczko, en semitonos: 0 si reparte la octava a partes iguales.
    public let distanciaALaUniformidad: Double
    /// Cuántas tríadas mayores, menores, disminuidas y aumentadas caben en sus notas.
    public let triadasContenidas: TriadasContenidas
    /// El análisis de Hanson de su vector interválico: «p⁶m³n⁴s⁵d²t» la mayor.
    public let analisisDeHanson: String
    /// El modo de transposición limitada de Messiaen que es, del 1 (tonos enteros) al 7.
    public let modoDeMessiaen: Int?
    /// Coincide con su inversión (como la mayor y la dórica), en vez de tener una pareja especular (quiral).
    public let simetricaPorInversion: Bool
    /// El número de Forte de su pareja Z, si la tiene.
    public let parejaZ: String?
    /// El número de Forte de las notas que le faltan para las doce.
    public let complemento: String?
    /// Las notas sin quinta justa encima en la escala (Zeitler).
    public let imperfecciones: Int
    /// Unicidad (Balzano): todos sus modos son distintos.
    public let unicidad: Bool
    /// Simplicidad (Balzano): sus notas forman una sola región en la red de terceras.
    public let simplicidad: Bool
    /// Las tríadas por terceras de cada grado (solo en las de siete notas): «», «m», «°», «+», «?».
    public let triadasPorGrados: [String]?
    /// Las cuatríadas por terceras de cada grado (solo en las de siete notas): «maj7», «m7», «7», «ø7»…
    public let cuatriadasPorGrados: [String]?
    /// Si es de seis notas y se completa con una transposición o una inversión suya (Babbitt).
    public let combinatoriedad: CombinatoriedadHexacordal?
    /// La entropía de Shannon, en bits, de su vector interválico.
    public let entropiaIntervalica: Double
    /// Cuántas escalas de su clase salen de mover una nota un semitono (Tymoczko).
    public let parsimonia: Int
    /// El gradus suavitatis de Euler de sus notas afinadas en justa, por su ortografía.
    public let gradoDeSuavidad: Int
    /// La altura de Tenney media de sus intervalos justos.
    public let alturaDeTenney: Double
    /// El límite impar (Partch) de sus intervalos justos.
    public let limiteImpar: Int
    /// La entropía armónica de Erlich media de sus intervalos, en bits.
    public let entropiaArmonica: Double
    /// La rugosidad de Sethares media de sus intervalos, como díadas.
    public let rugosidadMedia: Double
    /// La correlación de sus notas con el perfil de Krumhansl y Kessler de la tonalidad mayor sobre su tónica.
    public let perfilMayor: Double
    /// La correlación con el perfil de la tonalidad menor.
    public let perfilMenor: Double
    /// Tiene sensible: la nota un semitono bajo la tónica.
    public let conSensible: Bool
    /// Se parte en dos tetracordos iguales separados por un tono, como la mayor.
    public let tetracordosIguales: Bool

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

        let c = desdeLaTonica
        let vector = conjunto.vectorIntervalico
        propiedadDeMyhill = MedidasDeEscala.propiedadDeMyhill(c)
        generador = MedidasDeEscala.generador(c)
        bienFormada = generador != nil && (propiedadDeMyhill || Set(pasos).count == 1)
        let rothenberg = MedidasDeEscala.rothenberg(c)
        propiedadDeRothenberg = rothenberg.propiedad
        ambiguedades = rothenberg.ambiguedades
        contradicciones = rothenberg.contradicciones
        estabilidad = rothenberg.estabilidad
        cocienteDeIgualdad = MedidasDeEscala.cocienteDeIgualdad(c, ambiguedades: rothenberg.ambiguedades)
        anchuraDelEspectro = MedidasDeEscala.anchuraDelEspectro(c)
        profunda = Set(vector).count == 6
        consonanciaDiadica = MedidasDeAcorde.consonanciaDiadica(vector)
        magnitudesDeFourier = MedidasDeAcorde.magnitudesDeFourier(c)
        equilibrada = magnitudesDeFourier.first == 0
        distanciaALaUniformidad = MedidasDeAcorde.distanciaALaUniformidad(c)
        triadasContenidas = MedidasDeAcorde.triadasContenidas(Set(c))
        analisisDeHanson = MedidasDeEscala.analisisDeHanson(vector)
        modoDeMessiaen = MedidasDeEscala.modoDeMessiaen(c)
        simetricaPorInversion = conjunto.simetriasPorInversion > 0
        parejaZ = EstadisticasDeAcorde.parejaZ(de: conjunto)
        complemento = conjunto.complemento.numeroDeForte
        imperfecciones = MedidasDeEscala.imperfecciones(c)
        unicidad = conjunto.simetriasPorTransposicion == 1
        simplicidad = MedidasDeEscala.simplicidad(c)
        let armonizacion = MedidasDeEscala.armonizacion(c)
        triadasPorGrados = armonizacion?.triadas
        cuatriadasPorGrados = armonizacion?.cuatriadas
        combinatoriedad = MedidasDeEscala.combinatoriedad(conjunto)
        entropiaIntervalica = MedidasDeEscala.entropiaIntervalica(vector)
        parsimonia = MedidasDeEscala.parsimonia(conjunto)
        let quintasDistintas = Set(quintas)
        gradoDeSuavidad = MedidasDeAcorde.gradoDeSuavidad(pasosDeQuinta: quintasDistintas)
        let razones = MedidasDeAcorde.razonesJustas(pasosDeQuinta: quintasDistintas)
        alturaDeTenney = MedidasDeAcorde.alturaDeTenney(razones)
        limiteImpar = razones.map(\.limiteImpar).max() ?? 1
        entropiaArmonica = MedidasDeEscala.entropiaArmonica(c)
        rugosidadMedia = MedidasDeEscala.rugosidadMedia(c)
        perfilMayor = MedidasDeEscala.correlacion(c, con: MedidasDeEscala.perfilMayor)
        perfilMenor = MedidasDeEscala.correlacion(c, con: MedidasDeEscala.perfilMenor)
        conSensible = c.contains(11)
        tetracordosIguales = MedidasDeEscala.tetracordosIguales(c)
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

extension Escala {
    /// Lo que se mide de la escala (`EstadisticasDeEscala`): su cardinal, su brillo, sus intervalos, su simetría.
    public var estadisticas: EstadisticasDeEscala { EstadisticasDeEscala(self) }
}
