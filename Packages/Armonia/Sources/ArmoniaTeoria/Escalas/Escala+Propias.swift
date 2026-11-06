import ArmoniaNucleo

// Las escalas propias, escritas por sus notas («Do Re Mi♭ Fa♯ Sol La Si») o por sus pasos en semitonos
// («Do 2-1-3-1-2-2-1»), y las escalas vecinas: las que salen de mover una nota un semitono.

extension TipoDeEscala {
    /// El tipo con estos intervalos desde la tónica: el del catálogo, si lo hay (con su nombre), o uno propio que se
    /// llama por su número de Forte y sus pasos en semitonos, «7-22 (1-3-1-2-1-3-1)».
    ///
    ///     TipoDeEscala.propio([.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor])
    ///     // pentatónica mayor
    public static func propio(_ intervalos: [Intervalo]) -> TipoDeEscala {
        let candidato = TipoDeEscala(nombre: "", intervalos: intervalos)
        if let conocido = TipoDeEscala.catalogo.first(where: { $0 == candidato }) {
            return conocido
        }
        return TipoDeEscala(nombre: nombrePropio(candidato.intervalos.map(\.semitonos)), intervalos: intervalos)
    }

    /// «7-22 (1-3-1-2-1-3-1)»: el número de Forte del conjunto, si lo tiene, y los pasos de una nota a la siguiente
    /// hasta la octava.
    static func nombrePropio(_ semitonos: [Int]) -> String {
        let pasos = zip(semitonos, semitonos.dropFirst() + [12]).map { String($1 - $0) }.joined(separator: "-")
        let forte = ConjuntoDeClasesDeAltura(semitonos).numeroDeForte
        return [forte, "(" + pasos + ")"].compactMap { $0 }.joined(separator: " ")
    }
}

extension Escala {
    /// Una escala escrita por sus notas: la primera es la tónica, y cada nota se escribe como se da. El tipo es el
    /// del catálogo si coincide con alguno («Re Mi Fa Sol La Si Do» es Re dórico); si no, uno propio. `nil` sin
    /// notas.
    ///
    ///     Escala.propia([.do, .re, Nota("Mi♭"), Nota("Fa♯"), .sol, .la, .si])?.nombre
    ///     // "Do 7-22 (2-1-3-1-2-2-1)"
    public static func propia(_ notas: [Nota]) -> Escala? {
        guard let tonica = notas.first else { return nil }
        return Escala(tonica, .propio(notas.map { tonica.intervalo(hasta: $0) }))
    }

    /// Una escala escrita por sus pasos en semitonos desde la tónica: `[2, 2, 1, 2, 2, 2, 1]` es la mayor. Los
    /// pasos tienen que ser positivos y sumar 12, contando el último, el que vuelve a la tónica (también vale sin
    /// él, si suman menos de 12). Las notas se escriben con las menos alteraciones posibles; `nil` si los pasos no
    /// llevan a la octava.
    ///
    ///     Escala.propia(desde: .do, pasos: [2, 2, 3, 2, 3])?.nombre   // "Do pentatónica mayor"
    public static func propia(desde tonica: Nota, pasos: [Int]) -> Escala? {
        guard !pasos.isEmpty, pasos.allSatisfy({ $0 > 0 }) else { return nil }
        var semitonos = [0]
        for paso in pasos { semitonos.append(semitonos[semitonos.count - 1] + paso) }
        // El último paso puede ser el que vuelve a la octava.
        if semitonos.last == 12 { semitonos.removeLast() }
        guard semitonos.allSatisfy({ $0 < 12 }) else { return nil }
        let clases = semitonos.map { modulo(tonica.claseDeAltura + $0, 12) }
        let escritas = ConjuntoDeClasesDeAltura(clases).notas(con: tonica)
        let notas = clases.compactMap { clase in escritas.first { $0.claseDeAltura == clase } }
        return propia([tonica] + notas.dropFirst())
    }

    /// Los pasos en semitonos de una nota a la siguiente, hasta la tónica de arriba: `[2, 2, 1, 2, 2, 2, 1]` en la
    /// mayor.
    public var pasosEnSemitonos: [Int] {
        let semitonos = tipo.intervalos.map(\.semitonos)
        return zip(semitonos, semitonos.dropFirst() + [12]).map { $1 - $0 }
    }

    /// El número de Forte del conjunto de notas de la escala: «7-35» en las diatónicas, «5-35» en las pentatónicas.
    public var numeroDeForte: String? { ConjuntoDeClasesDeAltura(notas: notas).numeroDeForte }

    /// Lee una escala propia: unas notas («Do Re Mi♭ Fa♯ Sol La Si») o una tónica y sus pasos («Do 2-1-3-1-2-2-1»).
    static func leerPropia(_ texto: String) -> Escala? {
        let palabras = texto.split(separator: " ").map(String.init)
        guard palabras.count >= 2, let tonica = try? Nota(leyendo: palabras[0]) else { return nil }
        if palabras.count == 2, palabras[1].contains("-") {
            let pasos = palabras[1].split(separator: "-").map { Int($0) }
            guard pasos.allSatisfy({ $0 != nil }) else { return nil }
            return propia(desde: tonica, pasos: pasos.compactMap { $0 })
        }
        guard let notas = try? palabras.map({ try Nota(leyendo: $0) }) else { return nil }
        return propia(notas)
    }
}

// MARK: - Escalas vecinas

/// Una escala que sale de otra moviendo una nota un semitono: Do lidio sale de Do mayor subiendo el Fa a Fa♯.
public struct EscalaVecina: Hashable, Sendable {
    public let escala: Escala
    /// La nota que se mueve, como se escribe en la escala de partida.
    public let desde: Nota
    /// A dónde va, como se escribe en la vecina.
    public let hasta: Nota

    /// La escala vecina a la que se llega moviendo la nota `desde` a `hasta`.
    public init(escala: Escala, desde: Nota, hasta: Nota) {
        self.escala = escala
        self.desde = desde
        self.hasta = hasta
    }
}

extension Escala {
    /// Las escalas del catálogo que salen de esta moviendo una sola nota un semitono, arriba o abajo: de Do mayor,
    /// Do lidio (Fa → Fa♯), Do mixolidio (Si → Si♭), Do menor melódica (Mi → Mi♭), Do mayor armónica (La → La♭)…
    /// Para cada cambio, la escala con la misma tónica si la hay; si no, la más fácil de escribir. En el orden de las
    /// notas, primero bajando.
    public func vecinas(tipos: [TipoDeEscala] = TipoDeEscala.occidentales) -> [EscalaVecina] {
        let clases = Set(notas.map(\.claseDeAltura))
        var resultado: [EscalaVecina] = []
        for nota in notas {
            for semitono in [-1, 1] {
                let nueva = modulo(nota.claseDeAltura + semitono, 12)
                guard !clases.contains(nueva) else { continue }
                let buscadas = clases.subtracting([nota.claseDeAltura]).union([nueva])
                // Las escalas con justo esas notas, iguales al subir y al bajar.
                let exactas = Escala.identificar(clasesDeAltura: Array(buscadas), tipos: tipos).filter {
                    !$0.tipo.esDireccional && Set($0.notas.map(\.claseDeAltura)) == buscadas
                }
                let mismaTonica = exactas.first { $0.tonica.claseDeAltura == tonica.claseDeAltura }
                guard let elegida = mismaTonica ?? exactas.first,
                    let a = elegida.notas.first(where: { $0.claseDeAltura == nueva }),
                    !resultado.contains(where: { $0.escala == elegida })
                else { continue }
                resultado.append(EscalaVecina(escala: elegida, desde: nota, hasta: a))
            }
        }
        return resultado
    }
}

// MARK: - La escalera de brillo

/// Las escalas con la misma tónica ordenadas de la más oscura a la más brillante, cada una a una nota de la
/// siguiente: subir una nota un semitono la hace más brillante y bajarla, más oscura. Desde Do mayor, bajando, Do
/// mixolidio, Do dórico, Do menor natural, Do frigio, Do locrio…; subiendo, Do lidio…
///
///     let escalera = Escala(.do).escaleraDeBrillo()
///     escalera.peldanos[escalera.posicion]   // Do mayor
///     escalera.subidas.first?.de             // la nota que sube del primer peldaño al segundo
public struct EscaleraDeBrillo: Hashable, Sendable {
    /// De la más oscura a la más brillante.
    public let peldanos: [Escala]
    /// Dónde está, en `peldanos`, la escala de partida.
    public let posicion: Int
    /// `subidas[i]` va de `peldanos[i]` a `peldanos[i + 1]`: su escala es la de llegada y sus notas, la que sube
    /// (`de`, como se escribe en `peldanos[i]`) y a dónde (`a`).
    public let subidas: [EscalaVecina]
}

extension Escala {
    /// Las vecinas con la misma tónica que suben una nota un semitono (más brillantes) o la bajan (más oscuras),
    /// de las más habituales a las menos (en el orden de `tipos`).
    public func vecinasPorBrillo(
        tipos: [TipoDeEscala] = TipoDeEscala.occidentales
    ) -> (masOscuras: [EscalaVecina], masBrillantes: [EscalaVecina]) {
        let indice = Dictionary(tipos.enumerated().map { ($0.element.nombre, $0.offset) }, uniquingKeysWith: min)
        let propias = vecinas(tipos: tipos).filter { $0.escala.tonica.claseDeAltura == tonica.claseDeAltura }
            .sorted { (indice[$0.escala.tipo.nombre] ?? .max) < (indice[$1.escala.tipo.nombre] ?? .max) }
        let sube = { (vecina: EscalaVecina) in modulo(vecina.hasta.claseDeAltura - vecina.desde.claseDeAltura, 12) == 1
        }
        return (propias.filter { !sube($0) }, propias.filter(sube))
    }

    /// Desde esta escala, la más habitual de las vecinas más oscuras, y de esa la suya, hasta que no queda ninguna
    /// nueva; y lo mismo hacia las más brillantes. Como mucho `maximo` peldaños a cada lado.
    public func escaleraDeBrillo(tipos: [TipoDeEscala] = TipoDeEscala.occidentales, maximo: Int = 12)
        -> EscaleraDeBrillo
    {
        func clases(_ escala: Escala) -> Set<Int> { Set(escala.notas.map(\.claseDeAltura)) }
        var vistas: Set<Set<Int>> = [clases(self)]
        // Hacia abajo: cada peldaño, con la bajada que lleva a él.
        var abajo: [(escala: Escala, bajada: EscalaVecina)] = []
        var actual = self
        while abajo.count < maximo,
            let siguiente = actual.vecinasPorBrillo(tipos: tipos).masOscuras.first(where: {
                !vistas.contains(clases($0.escala))
            })
        {
            vistas.insert(clases(siguiente.escala))
            abajo.append((siguiente.escala, siguiente))
            actual = siguiente.escala
        }
        var arriba: [EscalaVecina] = []
        actual = self
        while arriba.count < maximo,
            let siguiente = actual.vecinasPorBrillo(tipos: tipos).masBrillantes.first(where: {
                !vistas.contains(clases($0.escala))
            })
        {
            vistas.insert(clases(siguiente.escala))
            arriba.append(siguiente)
            actual = siguiente.escala
        }
        // De la más oscura a esta: cada bajada, vuelta del revés, es una subida.
        let oscuras = abajo.reversed().map(\.escala)
        var subidas: [EscalaVecina] = []
        for (i, peldano) in abajo.enumerated().reversed() {
            let llegada = i == 0 ? self : abajo[i - 1].escala
            subidas.append(EscalaVecina(escala: llegada, desde: peldano.bajada.hasta, hasta: peldano.bajada.desde))
        }
        return EscaleraDeBrillo(
            peldanos: oscuras + [self] + arriba.map(\.escala), posicion: oscuras.count, subidas: subidas + arriba)
    }
}

/// Las escalas del catálogo con el mismo número de notas, de la más oscura a la más brillante, y qué pares están a
/// una nota de distancia: la de `oscura` sube una nota un semitono y es la de `brillante`.
///
///     let mapa = Escala.mapaDeBrillo()
///     mapa.escalas.first?.tipo.nombre   // la más oscura de las de siete notas
public struct MapaDeBrillo: Hashable, Sendable {
    /// Un par de escalas vecinas: sus posiciones en `escalas` y la nota que sube de una a la otra.
    public struct Enlace: Hashable, Sendable {
        public let oscura: Int
        public let brillante: Int
        /// La nota que sube, como se escribe en la oscura.
        public let desde: Nota
        /// A dónde, como se escribe en la brillante.
        public let hasta: Nota
    }

    /// De la más oscura a la más brillante (por `brilloPorQuintas`), sin dos con las mismas notas.
    public let escalas: [Escala]
    public let enlaces: [Enlace]
}

extension Escala {
    /// El mapa de brillo de las escalas de `numeroDeNotas` notas del catálogo sobre `tonica`: ordenadas por su brillo
    /// por quintas y enlazadas cuando una sale de la otra subiendo una nota un semitono. Deja fuera las que tienen
    /// microtonos y, de las que tienen las mismas notas, todas menos la primera de `tipos`.
    public static func mapaDeBrillo(
        tonica: Nota = .do, numeroDeNotas: Int = 7, tipos: [TipoDeEscala] = TipoDeEscala.occidentales
    ) -> MapaDeBrillo {
        var elegidas: [(escala: Escala, clases: Set<Int>, brillo: Double)] = []
        var vistas: Set<Set<Int>> = []
        for tipo in tipos where tipo.numeroDeNotas == numeroDeNotas {
            let escala = Escala(tonica, tipo)
            let estadisticas = escala.estadisticas
            let clases = Set(escala.notas.map(\.claseDeAltura))
            guard !estadisticas.aproximada, clases.count == numeroDeNotas, vistas.insert(clases).inserted else {
                continue
            }
            elegidas.append((escala, clases, estadisticas.brilloPorQuintas))
        }
        // De la más oscura a la más brillante; a igual brillo, en el orden del catálogo.
        let ordenadas = elegidas.enumerated().sorted {
            $0.element.brillo != $1.element.brillo ? $0.element.brillo < $1.element.brillo : $0.offset < $1.offset
        }.map(\.element)
        var enlaces: [MapaDeBrillo.Enlace] = []
        for i in ordenadas.indices {
            for j in ordenadas.indices where j > i {
                let soloEnI = ordenadas[i].clases.subtracting(ordenadas[j].clases)
                let soloEnJ = ordenadas[j].clases.subtracting(ordenadas[i].clases)
                guard soloEnI.count == 1, soloEnJ.count == 1, let a = soloEnI.first, let b = soloEnJ.first else {
                    continue
                }
                let (oscura, brillante): (Int, Int)
                switch modulo(b - a, 12) {
                case 1: (oscura, brillante) = (i, j)
                case 11: (oscura, brillante) = (j, i)
                default: continue
                }
                let baja = ordenadas[oscura]
                let sube = ordenadas[brillante]
                guard let de = baja.escala.notas.first(where: { !sube.clases.contains($0.claseDeAltura) }),
                    let hasta = sube.escala.notas.first(where: { !baja.clases.contains($0.claseDeAltura) })
                else { continue }
                enlaces.append(MapaDeBrillo.Enlace(oscura: oscura, brillante: brillante, desde: de, hasta: hasta))
            }
        }
        return MapaDeBrillo(escalas: ordenadas.map(\.escala), enlaces: enlaces)
    }
}

// MARK: - Las escalas más parecidas

/// Una escala cercana a otra: las notas que comparten, las que se van y las que llegan.
public struct EscalaParecida: Hashable, Sendable {
    public let escala: Escala
    /// Las notas de la escala de partida que también están en esta, como las escribe la de partida.
    public let comunes: [Nota]
    /// Las notas de la escala de partida que no están en esta.
    public let quitadas: [Nota]
    /// Las notas de esta que no están en la de partida.
    public let anadidas: [Nota]

    /// Cuántas notas hay que cambiar, quitar o añadir para pasar de una a otra.
    public var diferencia: Int { quitadas.count + anadidas.count }
}

extension Escala {
    /// Las escalas del catálogo, en cualquier tónica y con cualquier número de notas, que comparten más notas con
    /// esta, de la que menos cambia a la que más: primero las que quitan o añaden una sola nota, luego las que
    /// cambian una, y así. Sin las que tienen las mismas notas (sus modos). Para cada juego de notas, la escala con la
    /// misma tónica si la hay; si no, la más habitual (en el orden de `tipos`) con la tónica más fácil de escribir.
    ///
    ///     let parecidas = Escala(.do).masParecidas()
    ///     parecidas.contains { $0.escala == Escala(.do, .lidio) }   // true
    public func masParecidas(tipos: [TipoDeEscala] = TipoDeEscala.occidentales, limite: Int = 16) -> [EscalaParecida] {
        let propias = Set(notas.map(\.claseDeAltura))
        let candidatas = tipos.filter { !$0.esDireccional }.flatMap { Escala(tonica, $0).enLasDoceTonalidades }
        // Primero las de la misma tónica, para que ganen a sus modos en otras tónicas.
        let ordenadas =
            candidatas.filter { $0.tonica.claseDeAltura == tonica.claseDeAltura }
            + candidatas.filter { $0.tonica.claseDeAltura != tonica.claseDeAltura }
        var vistas: Set<Set<Int>> = [propias]
        var resultado: [EscalaParecida] = []
        for escala in ordenadas {
            let suyas = Set(escala.notas.map(\.claseDeAltura))
            guard !vistas.contains(suyas), !propias.isDisjoint(with: suyas) else { continue }
            vistas.insert(suyas)
            resultado.append(
                EscalaParecida(
                    escala: escala, comunes: notas.filter { suyas.contains($0.claseDeAltura) },
                    quitadas: notas.filter { !suyas.contains($0.claseDeAltura) },
                    anadidas: escala.notas.filter { !propias.contains($0.claseDeAltura) }))
        }
        let posicion = Dictionary(uniqueKeysWithValues: resultado.enumerated().map { ($0.element.escala, $0.offset) })
        return Array(
            resultado.sorted {
                ($0.diferencia, -$0.comunes.count, posicion[$0.escala] ?? 0)
                    < ($1.diferencia, -$1.comunes.count, posicion[$1.escala] ?? 0)
            }
            .prefix(limite))
    }
}
