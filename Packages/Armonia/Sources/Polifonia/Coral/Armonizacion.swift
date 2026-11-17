import Elementos
import Teoria

// Armonización de melodías: qué acordes pueden acompañar cada nota y qué sucesión de acordes
// suena mejor en la tonalidad, según la armonía funcional.

// MARK: - Armonizacion

/// Una propuesta de acordes para una melodía: un acorde por nota.
///
///     let propuesta = Tonalidad(.do).armonizar(melodia: ["Mi", "Re", "Do"]).first!.valor
///     propuesta.acordes      // [Do, Sol, Do]
///     propuesta.cifrados     // ["I", "V", "I"]
public struct Armonizacion: Hashable, Sendable, CustomStringConvertible {
    public let tonalidad: Tonalidad
    public let melodia: [Nota]
    public let acordes: [Acorde]

    /// Los acordes leídos en la tonalidad.
    public var analisis: AnalisisArmonico { tonalidad.analizar(acordes) }
    /// "I", "V7/V", "vii°6"…
    public var cifrados: [String] { analisis.cifrados }

    /// La armonización a cuatro voces con la melodía en el soprano (ver ``Coral/init(realizando:soprano:en:)``).
    ///
    /// - Throws: ``ErrorDeRealizacion/otraMelodia`` si las notas del soprano no son las de la melodía, y lo que
    ///   lanza ``Coral/init(realizando:soprano:en:)`` si no hay realización sin faltas.
    public func coral(soprano: [Altura]) throws(ErrorDeRealizacion) -> Coral {
        guard soprano.map(\.nota) == melodia else { throw ErrorDeRealizacion.otraMelodia }
        return try Coral(realizando: acordes, soprano: soprano, en: tonalidad)
    }

    /// "Do Sol Do (I–V–I)".
    public var description: String { texto(en: .compacta(.espanol)) }

    public func texto(en notacion: Notacion) -> String {
        acordes.map { $0.cifrado(en: notacion) }.joined(separator: " ") + " (" + cifrados.joined(separator: "–") + ")"
    }
}

// MARK: - Armonizar

/// Una melodía armonizada y escrita a cuatro voces: lo que da ``Tonalidad/armonizarACuatroVoces(melodia:)``.
public struct CoralArmonizado: Hashable, Sendable {
    /// Los acordes elegidos para cada nota.
    public let armonizacion: Armonizacion
    /// Las cuatro voces, con la melodía en el soprano.
    public let coral: Coral

    /// Una armonización con el coral que la escribe a cuatro voces.
    public init(armonizacion: Armonizacion, coral: Coral) {
        self.armonizacion = armonizacion
        self.coral = coral
    }
}

extension Tonalidad {
    /// Los acordes de la tonalidad que tienen una nota, del más al menos habitual para
    /// armonizarla: los tres principales (I, IV, V) primero, y antes si la nota es su fundamental.
    ///
    ///     Tonalidad(.do).acordes(para: .sol).prefix(3).map(\.valor)   // [Sol, Do, Sol7]
    ///
    /// Son las tríadas de los siete grados (el vii° en primera inversión, como se usa casi siempre;
    /// en menor, también el ii°), el V7, el ii6, las dominantes secundarias del V, el vi, el ii y
    /// el IV (en menor, del iv y del VI) y, en mayor, las séptimas disminuidas de nota común del I y
    /// del V, sobre la nota común en el bajo (Re♯°7/Do). Si ninguno tiene la nota, los del modo homónimo.
    public func acordes(para nota: Nota) -> [Candidato<Acorde>] {
        var candidatos = inventarioDeArmonizacion.filter { $0.acorde.notas.contains(nota) }
        if candidatos.isEmpty {
            candidatos = homonima.inventarioDeArmonizacion.filter {
                $0.acorde.notas.contains(nota) && $0.destino == nil
            }
            .map { (acorde: $0.acorde, coste: $0.coste + pesos.delModoHomonimo, destino: nil as Int?) }
        }
        return
            candidatos
            .map { Candidato($0.acorde, coste: $0.coste + Tonalidad.costeDePapel(nota, en: $0.acorde)) }
            .sorted { $0.coste < $1.coste }
    }

    /// Las mejores armonizaciones de una melodía, de menor a mayor coste.
    ///
    ///     let mejor = Tonalidad(.do).armonizar(melodia: ["Do", "Re", "Mi", "Fa", "Re", "Si", "Do"]).first!
    ///     mejor.valor.cifrados   // ["I", "V", "I", "IV", "ii", "V", "I"]
    ///
    /// Cada nota recibe uno de sus ``acordes(para:)``, y la sucesión se puntúa como en la armonía
    /// funcional: tónica, subdominante, dominante y vuelta a la tónica es lo natural; de la
    /// dominante a la subdominante (una retrogresión) cuesta mucho, y una dominante secundaria
    /// tiene que ir a su destino. Se prefiere empezar en la tónica y terminar con una cadencia
    /// auténtica (o, si la última nota no es del I, en la dominante: una semicadencia). Una
    /// séptima en la melodía tiene que bajar por grado conjunto.
    ///
    /// - Parameter propuestas: cuántas armonizaciones distintas devolver como mucho.
    /// - Returns: vacío si la melodía está vacía o alguna nota no tiene acorde.
    public func armonizar(melodia: [Nota], propuestas: Int = 5) -> [Candidato<Armonizacion>] {
        guard propuestas > 0, let problema = ProblemaDeArmonizacion(melodia, en: self) else { return [] }
        let opciones = problema.opciones
        // Para cada nota y cada acorde posible, las mejores sucesiones que terminan en él.
        let caminos = MejoresCaminos.buscar(
            estados: opciones.map(\.count), mejores: propuestas,
            inicio: { opciones[0][$0].coste + problema.costeDeInicio($0) },
            paso: { i, k, j in problema.costeDePaso(i, desde: k, hasta: j) + opciones[i][j].coste },
            final: problema.costeDeFinal)
        var vistas: Set<[Acorde]> = []
        var resultado: [Candidato<Armonizacion>] = []
        for camino in caminos {
            let acordes = problema.acordes(camino.estados)
            guard vistas.insert(acordes).inserted else { continue }
            resultado.append(
                Candidato(
                    Armonizacion(tonalidad: self, melodia: melodia, acordes: acordes),
                    coste: (camino.coste * 100).rounded() / 100))
            if resultado.count == propuestas { break }
        }
        return resultado
    }

    /// Armoniza una melodía y la escribe a cuatro voces, con la melodía en el soprano.
    ///
    ///     let armonizada = try Tonalidad(.do).armonizarACuatroVoces(melodia: ["Mi4", "Re4", "Do4"])
    ///     armonizada.armonizacion.cifrados   // ["I", "V", "I"]
    ///     armonizada.coral.esCorrecta        // true
    ///
    /// Elige a la vez los acordes y las disposiciones: entre todas las armonizaciones que se pueden
    /// realizar sin faltas (con las reglas de ``Coral/init(realizando:soprano:en:)``), la que
    /// suma menos coste armónico, como en ``armonizar(melodia:propuestas:)``, y, a igualdad, la que
    /// mueve menos las voces. Por eso no siempre es la primera de `armonizar`: si la mejor sucesión
    /// de acordes obliga a una falta con esa melodía, se queda con otra.
    ///
    /// - Throws: ``ErrorDeRealizacion``: si la melodía está vacía (`sinNotas`), si una nota no tiene acorde
    ///   (`notaSinAcorde`), si se sale de la tesitura del soprano, Do4–Sol5 (`sopranoFueraDeTesitura`), si ningún
    ///   acorde de una nota se puede escribir con ella en el soprano (`sinDisposicion`) o si no hay manera de enlazar
    ///   los acordes sin faltas (`sinEnlaceSinFaltas`).
    public func armonizarACuatroVoces(melodia: [Altura]) throws(ErrorDeRealizacion) -> CoralArmonizado {
        let notas = melodia.map(\.nota)
        guard !notas.isEmpty else { throw ErrorDeRealizacion.sinNotas }
        guard let problema = ProblemaDeArmonizacion(notas, en: self) else {
            throw ErrorDeRealizacion.notaSinAcorde(nota: notas.firstIndex { acordes(para: $0).isEmpty } ?? 0)
        }
        let opciones = problema.opciones
        let sensible = escalaDeReferencia.grado(7)
        // Lo que pesan las voces frente a la armonía: un semitono de movimiento vale poco.
        let pesoDeLasVoces = pesos.pesoDeLasVoces

        // Los estados: un acorde de los posibles para la nota y una de sus disposiciones.
        let estados: [[(acorde: Int, alturas: [Altura], coste: Double)]] = melodia.indices.map { i in
            opciones[i].indices.flatMap { j in
                Coral.disposiciones(de: opciones[i][j].valor, soprano: melodia[i], sensible: sensible)
                    .map { (j, $0.alturas, opciones[i][j].coste + pesoDeLasVoces * $0.coste) }
            }
        }
        if let i = estados.firstIndex(where: \.isEmpty) {
            throw Coral.tesituras[3].contains(melodia[i].midi)
                ? ErrorDeRealizacion.sinDisposicion(acorde: i) : ErrorDeRealizacion.sopranoFueraDeTesitura(acorde: i)
        }
        let mejor = MejoresCaminos.buscar(
            estados: estados.map(\.count),
            inicio: { estados[0][$0].coste + problema.costeDeInicio(estados[0][$0].acorde) },
            paso: { i, a, b in
                let (actual, siguiente) = (estados[i - 1][a], estados[i][b])
                let anterior = problema.enContexto[i - 1][actual.acorde][siguiente.acorde]
                guard
                    let voces = Coral.costeDePaso(
                        de: actual.alturas, a: siguiente.alturas, septima: anterior.acorde.septima,
                        sensible: Cadencia.esDominante(anterior) ? sensible : nil, tonica: self.tonica,
                        notaComun: Coral.notaComun(de: anterior.acorde, a: opciones[i][siguiente.acorde].valor))
                else { return nil }
                return siguiente.coste + pesoDeLasVoces * voces
                    + problema.costeDePaso(i, desde: actual.acorde, hasta: siguiente.acorde)
            },
            final: { a, b in
                problema.costeDeFinal(
                    a.map { estados[melodia.count - 2][$0].acorde }, estados[melodia.count - 1][b].acorde)
            }
        ).first
        guard let camino = mejor else { throw ErrorDeRealizacion.sinEnlaceSinFaltas }
        let elegidos = camino.estados.enumerated().map { estados[$0.offset][$0.element] }
        guard let conduccion = try? Coral(elegidos.map(\.alturas)) else { throw ErrorDeRealizacion.sinEnlaceSinFaltas }
        return CoralArmonizado(
            armonizacion: Armonizacion(
                tonalidad: self, melodia: notas, acordes: problema.acordes(elegidos.map(\.acorde))),
            coral: conduccion)
    }

    // MARK: Auxiliares

    /// Lo que pesa cada cosa (ver ``PesosDeArmonizacion``).
    private var pesos: PesosDeArmonizacion { .habituales }

    /// Los acordes con los que se armoniza, con su coste y, en las dominantes secundarias, el
    /// grado al que tienen que ir.
    package var inventarioDeArmonizacion: [(acorde: Acorde, coste: Double, destino: Int?)] {
        var inventario: [(acorde: Acorde, coste: Double, destino: Int?)] = []
        func anadir(_ acorde: Acorde, _ coste: Double, _ destino: Int? = nil) {
            guard !inventario.contains(where: { $0.acorde == acorde }) else { return }
            inventario.append((acorde, coste, destino))
        }
        for grado in 1...7 {
            let acorde = self.acordeDelGrado(grado)
            // vii° (y en menor ii°) en primera inversión.
            let disminuido = acorde.tipo.estructura.calidadDeTriada == .disminuida
            anadir(disminuido ? acorde.cambiarInversion(1) : acorde, pesos.grado(grado, enMayor: modo == .mayor))
        }
        anadir(acordeDelGrado(5, notas: 4), pesos.septimaDeDominante)
        if modo == .mayor { anadir(acordeDelGrado(2).cambiarInversion(1), pesos.iiEnPrimeraInversion) }
        // Dominantes secundarias.
        for destino in modo == .mayor ? [5, 6, 2, 4] : [4, 6] {
            let raiz = acordeDelGrado(destino).fundamental + .quintaJusta
            let coste = destino == 5 ? pesos.secundariaDelV : pesos.otraSecundaria
            anadir(Acorde(raiz, .mayor), coste, destino)
            anadir(Acorde(raiz, .dominanteSeptima), coste, destino)
        }
        // Séptimas disminuidas de nota común, del I y del V de una tonalidad mayor, sobre la nota común en el bajo,
        // como un pedal: Re♯°7/Do → Do.
        if modo == .mayor {
            for destino in [1, 5] {
                let fundamental = acordeDelGrado(destino).fundamental
                anadir(
                    Acorde(fundamental + .segundaAumentada, .disminuidoSeptima).cambiarInversion(3),
                    pesos.disminuidaDeNotaComun, destino)
            }
        }
        return inventario
    }

    /// Lo que cuesta que la nota sea una u otra del acorde: mejor la fundamental.
    private static func costeDePapel(_ nota: Nota, en acorde: Acorde) -> Double {
        let pesos = PesosDeArmonizacion.habituales
        switch acorde.papel(de: nota) {
        case .fundamental?: return pesos.notaFundamental
        case .quinta?: return pesos.notaQuinta
        case .tercera?: return pesos.notaTercera
        default: return pesos.otraNota
        }
    }

    fileprivate func costeDeInicio(_ a: AcordeAnalizado) -> Double {
        if a.grado == 1 && a.categoria == .diatonico { return pesos.inicioEnLaTonica }
        return a.grado == 5 && a.categoria == .diatonico ? pesos.inicioEnLaDominante : pesos.otroInicio
    }

    /// Lo que cuesta ir de un acorde al siguiente, según sus funciones.
    fileprivate func costeDePaso(
        _ a: AcordeAnalizado, _ b: AcordeAnalizado, destino: Int?,
        melodia: (Nota, Nota)
    ) -> Double {
        var coste = 0.0
        // Una séptima en la melodía baja por grado conjunto.
        if a.acorde.papel(de: melodia.0) == .septima {
            let paso = modulo(melodia.0.claseDeAltura - melodia.1.claseDeAltura, 12)
            if !(1...2).contains(paso) { coste += pesos.septimaDeLaMelodiaSinResolver }
        }
        if let destino {
            let llega = b.grado == destino && b.acorde.fundamental == acordeDelGrado(destino).fundamental
            return coste + (llega ? 0 : pesos.sinIrASuDestino)
        }
        if a.acorde.notas == b.acorde.notas {
            return coste + (a.acorde == b.acorde ? pesos.mismoAcorde : pesos.mismasNotas)
        }
        // V7 → V: la séptima se queda sin resolver.
        if a.acorde.septima != nil, b.acorde.fundamental == a.acorde.fundamental {
            return coste + pesos.septimaQueNoResuelve
        }
        switch (a.funcion, b.funcion) {
        case (.dominante?, .tonica?):
            switch b.grado {
            case 1: return coste + pesos.dominanteAlI
            case 6: return coste + pesos.cadenciaRota
            default: return coste + pesos.dominanteAOtraTonica
            }
        case (.dominante?, .subdominante?): return coste + pesos.retrogresion
        case (.dominante?, .dominante?):
            return coste + (a.grado == 5 && b.grado == 5 ? pesos.delVAlV : pesos.dominanteADominante)
        case (.subdominante?, .dominante?): return coste + pesos.subdominanteADominante
        case (.subdominante?, .subdominante?):
            return coste + (a.grado == 4 && b.grado == 2 ? pesos.delIVAlII : pesos.subdominanteASubdominante)
        case (.subdominante?, .tonica?): return coste + (b.grado == 1 ? pesos.plagal : pesos.subdominanteAOtraTonica)
        case (.tonica?, .tonica?):
            if a.grado == 1 { return coste + (b.grado == 6 ? pesos.delIAlVI : pesos.delIAOtraTonica) }
            return coste + (a.grado == 3 && b.grado == 6 ? pesos.delIIIAlVI : pesos.tonicaATonica)
        default: return coste + pesos.otroPaso
        }
    }

    /// Lo que cuesta terminar así: lo mejor, una cadencia auténtica; si la última nota no es del
    /// I, una semicadencia.
    fileprivate func costeDeFinal(
        _ ultimo: AcordeAnalizado, penultimo: AcordeAnalizado?, destino: Int?,
        melodia: [Nota]
    ) -> Double {
        if destino != nil { return pesos.finalSinDestino }
        if Cadencia.esTonica(ultimo) && ultimo.acorde.inversion == 0 {
            guard let penultimo else { return pesos.cadenciaAutentica }
            return Cadencia.esDominante(penultimo) ? pesos.cadenciaAutentica : pesos.finalEnElISinDominante
        }
        let iTieneLaNota = acordeDelGrado(1).notas.contains(melodia[melodia.count - 1])
        if ultimo.grado == 5 && ultimo.categoria == .diatonico && ultimo.acorde.tipo == .mayor {
            return iTieneLaNota ? pesos.semicadenciaPudiendoIrAlI : pesos.semicadencia
        }
        return pesos.otroFinal
    }
}

// MARK: - El problema

/// Lo que comparten las dos armonizaciones antes de buscar: los acordes posibles de cada nota, cómo se lee cada uno
/// solo y antes de cada acorde de la nota siguiente, y el destino de las dominantes secundarias; y los costes
/// armónicos de empezar, de cada paso y de terminar, por los índices de esos acordes.
private struct ProblemaDeArmonizacion {
    let tonalidad: Tonalidad
    let melodia: [Nota]
    /// Los acordes posibles de cada nota, con su coste (``Tonalidad/acordes(para:)``).
    let opciones: [[Candidato<Acorde>]]
    /// Cada acorde posible leído solo.
    let lecturas: [[AcordeAnalizado]]
    /// Cómo se lee cada acorde posible de cada nota antes de cada uno de la nota siguiente
    /// (`[nota][acorde][siguiente]`): una dominante secundaria lo es si va a su destino, y una séptima disminuida de
    /// nota común, si adorna al acorde siguiente. Sin el siguiente, Re♯°7 se lee como la sensible del iii; antes del
    /// Do, como la disminuida que lo adorna.
    let enContexto: [[[AcordeAnalizado]]]
    /// El grado al que tiene que ir cada acorde posible de cada nota, si es una dominante secundaria.
    let destinos: [[Int?]]

    /// `nil` si la melodía está vacía o alguna nota no tiene acorde.
    init?(_ melodia: [Nota], en tonalidad: Tonalidad) {
        let opciones = melodia.map { tonalidad.acordes(para: $0) }
        guard !melodia.isEmpty, opciones.allSatisfy({ !$0.isEmpty }) else { return nil }
        let porAcorde = Dictionary(
            tonalidad.inventarioDeArmonizacion.map { ($0.acorde, $0.destino) }, uniquingKeysWith: { a, _ in a })
        self.tonalidad = tonalidad
        self.melodia = melodia
        self.opciones = opciones
        lecturas = opciones.map { $0.map { tonalidad.analizar($0.valor) } }
        enContexto = opciones.indices.dropLast().map { i in
            opciones[i].map { acorde in opciones[i + 1].map { tonalidad.analizar(acorde.valor, siguiente: $0.valor) } }
        }
        destinos = opciones.map { $0.map { porAcorde[$0.valor] ?? nil } }
    }

    /// Los acordes de unos índices, uno por nota.
    func acordes(_ indices: [Int]) -> [Acorde] {
        indices.enumerated().map { opciones[$0.offset][$0.element].valor }
    }

    /// Lo que cuesta empezar con el acorde `j` de la primera nota.
    func costeDeInicio(_ j: Int) -> Double { tonalidad.costeDeInicio(lecturas[0][j]) }

    /// Lo que cuesta ir del acorde `k` de la nota `i - 1` al `j` de la nota `i`, según sus funciones.
    func costeDePaso(_ i: Int, desde k: Int, hasta j: Int) -> Double {
        tonalidad.costeDePaso(
            enContexto[i - 1][k][j], lecturas[i][j], destino: destinos[i - 1][k], melodia: (melodia[i - 1], melodia[i]))
    }

    /// Lo que cuesta terminar en el acorde `j` de la última nota, viniendo del `k` de la penúltima (`nil` si solo hay
    /// una).
    func costeDeFinal(_ k: Int?, _ j: Int) -> Double {
        let n = melodia.count
        return tonalidad.costeDeFinal(
            lecturas[n - 1][j], penultimo: k.map { enContexto[n - 2][$0][j] },
            destino: k.flatMap { destinos[n - 2][$0] },
            melodia: melodia)
    }
}
