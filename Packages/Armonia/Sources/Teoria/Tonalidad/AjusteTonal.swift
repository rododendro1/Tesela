import Elementos

// MARK: - Cómo encaja un acorde en una tonalidad

/// Lo que se parece un acorde a una tonalidad según el perfil de Krumhansl y Kessler (1982): la correlación de sus
/// notas con el perfil de la tonalidad, de −1 a 1.
public struct AjusteTonal: Hashable, Sendable {
    public let tonalidad: Tonalidad
    public let correlacion: Double
}

extension Tonalidad {
    /// La correlación de las notas del acorde con el perfil de Krumhansl y Kessler de esta tonalidad: cuanto más
    /// cerca de 1, más suena a ella.
    ///
    ///     Tonalidad(.do).ajuste(de: Acorde("Do"))    // 0.834
    public func ajuste(de acorde: Acorde) -> Double {
        let tonica = self.tonica.claseDeAltura
        let clases = Set(acorde.notasDesdeElBajo.map { modulo($0.claseDeAltura - tonica, 12) })
        return MedidasDeEscala.correlacion(
            Array(clases), con: modo == .mayor ? MedidasDeEscala.perfilMayor : MedidasDeEscala.perfilMenor)
    }

    /// La función que hacen sus notas en esta tonalidad, aunque no sea uno de sus grados: la tónica (la tónica, la
    /// mediante y la superdominante), la subdominante (la subdominante, la superdominante y la submediante) o la
    /// dominante (la sensible, la dominante y el tritono de la sensible y la subdominante), sumando lo que pesa
    /// cada una y lo que pesa su fundamental. A igualdad, la dominante si tiene el tritono y, si no, la tónica antes
    /// que la subdominante. `nil` si ninguna de sus notas dice nada (Fa♯ mayor en Do).
    ///
    ///     Tonalidad(.do).funcionProbable(de: Acorde("Lam"))    // .tonica
    ///     Tonalidad(.do).funcionProbable(de: Acorde("Fam"))    // .subdominante
    ///     Tonalidad(.do).funcionProbable(de: Acorde("Re♭7"))   // .dominante
    public func funcionProbable(de acorde: Acorde) -> FuncionTonal? {
        let tonica = self.tonica.claseDeAltura
        let grados = Set(acorde.notasDesdeElBajo.map { modulo($0.claseDeAltura - tonica, 12) })
        let raiz = modulo(acorde.fundamental.claseDeAltura - tonica, 12)
        let mediante = modo == .mayor ? 4 : 3
        let submediante = modo == .mayor ? 9 : 8
        let tritono = grados.contains(5) && grados.contains(11)
        func peso(_ notas: [Int: Int], fundamentales: Set<Int>) -> Int {
            var total = notas.reduce(0) { $0 + (grados.contains($1.key) ? $1.value : 0) }
            if fundamentales.contains(raiz) { total += 2 }
            return total
        }
        let tonicaPeso = peso([0: 2, mediante: 2, 7: 1], fundamentales: [0, mediante, submediante])
        let subdominantePeso = peso([5: 2, submediante: 2, 2: 1], fundamentales: [5, 2])
        let dominantePeso = peso([11: 2, 2: 1, 7: 1], fundamentales: [7, 11]) + (tritono ? 2 : 0)
        let mejor = max(tonicaPeso, subdominantePeso, dominantePeso)
        guard mejor > 0 else { return nil }
        if dominantePeso == mejor && tritono { return .dominante }
        if tonicaPeso == mejor { return .tonica }
        return subdominantePeso == mejor ? .subdominante : .dominante
    }

    /// Las 24 tonalidades, mayores y menores, con la escritura de menos alteraciones: primero las mayores.
    public static var todas: [Tonalidad] {
        var vistas = Set<[Int]>()
        return (circuloDeQuintas(.mayor) + circuloDeQuintas(.menor)).map(\.enarmonicaMasSimple)
            .sorted { abs($0.armadura) < abs($1.armadura) }
            .filter { vistas.insert([$0.tonica.claseDeAltura, $0.modo == .mayor ? 0 : 1]).inserted }
    }
}

extension Acorde {
    /// Las 24 tonalidades por lo bien que encaja en ellas el acorde (`AjusteTonal`), de la que más a la que menos;
    /// a igualdad, la de menos alteraciones y la mayor antes que la menor.
    ///
    ///     Acorde("Sol7").ajustesTonales.first?.tonalidad   // Sol mayor
    public var ajustesTonales: [AjusteTonal] {
        let ajustes = Tonalidad.todas.map { AjusteTonal(tonalidad: $0, correlacion: $0.ajuste(de: self)) }
        return ajustes.enumerated().sorted { a, b in
            a.element.correlacion != b.element.correlacion
                ? a.element.correlacion > b.element.correlacion : a.offset < b.offset
        }.map(\.element)
    }

    /// Las escalas de todo el catálogo, sobre su fundamental, que contienen sus notas, de las que tienen menos notas
    /// a evitar a las que más (``escalasCompatibles(entre:)`` con ``TipoDeEscala/catalogo``).
    public var escalasDelCatalogo: [Escala] { escalasCompatibles(entre: TipoDeEscala.catalogo) }
}
