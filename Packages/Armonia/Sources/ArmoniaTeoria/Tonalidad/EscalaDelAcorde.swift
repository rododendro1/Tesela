import ArmoniaNucleo

// La escala de cada acorde en su contexto: la que sale de la tonalidad y de lo que hace el acorde en ella
// (diatónico, dominante secundaria, préstamo…), como en la teoría acorde-escala del jazz.

extension TipoDeEscala {
    /// Las escalas con las que la teoría acorde-escala del jazz acompaña a un acorde: los modos de la mayor, de
    /// la menor melódica y de la menor armónica, las dos disminuidas y la de tonos enteros. Es donde
    /// `Tonalidad.escalaDelAcorde(_:)` busca cuando el acorde no se explica por la tonalidad.
    public static let paraAcordes: [TipoDeEscala] = [
        .mayor, .dorico, .frigio, .lidio, .mixolidio, .menorNatural, .locrio,
        .menorMelodicaJazz, .doricoSegundaMenor, .lidioAumentado, .lidioDominante, .mixolidioSextaMenor,
        .locrioSegundaNatural, .alterada,
        .menorArmonica, .locrioSextaNatural, .jonicoAumentado, .doricoCuartaAumentada, .frigioDominante,
        .lidioSegundaAumentada, .ultralocrio,
        .disminuida, .disminuidaSemitonoTono, .tonosEnteros,
    ]

    /// Las escalas de ``paraAcordes`` y además las bebop, las pentatónicas y la de blues: entre las que
    /// `Acorde.escalasCompatibles(entre:)` busca por defecto.
    public static let deJazz: [TipoDeEscala] =
        paraAcordes + [.bebopDominante, .bebopMayor, .bebopDorico, .pentatonicaMayor, .pentatonicaMenor, .blues]
}

extension Tonalidad {
    /// La escala para un acorde analizado en esta tonalidad, sobre su fundamental, según lo que hace en ella:
    ///
    /// - **Diatónico**: el modo de la escala de la tonalidad que empieza en el acorde (Rem7 en Do → Re dórico). En
    ///   menor, de la natural; si el acorde tiene el 6.º o el 7.º elevados, de la armónica o de la melódica
    ///   (Mi7 en La menor → Mi frigio dominante).
    /// - **Dominante o sensible secundaria**: el modo de la escala de su destino, mayor o menor armónica según el
    ///   acorde de destino (V7/V en Do → Re mixolidio; V7/ii → La frigio dominante, el mixolidio ♭9 ♭13).
    /// - **Napolitana**: lidio. **Sexta aumentada**: lidio dominante sobre el ♭6̂.
    /// - **Préstamo**: el modo de la homónima (iv en Do → Fa dórico; ♭VI → La♭ lidio); si es un acorde de dominante,
    ///   lidio dominante (♭VII7 → Si♭ lidio dominante).
    /// - **Cromático**: un acorde de dominante, lidio dominante (el sustituto tritonal).
    ///
    /// Si esa escala no tiene todas las notas del acorde (Sol7(♭9) en Do), se elige entre
    /// ``TipoDeEscala/paraAcordes`` la que tiene menos notas fuera de la tonalidad y, a igualdad, menos notas a
    /// evitar (Sol frigio dominante). `nil` si ninguna tiene todas sus notas.
    public func escalaDelAcorde(_ analizado: AcordeAnalizado) -> Escala? {
        let acorde = analizado.acorde
        if let propuesta = escalasPropuestas(para: analizado).first(where: { $0.contiene(acorde: acorde) }) {
            return propuesta
        }
        let contexto = Set((notasPropias + acorde.notas).map(\.claseDeAltura))
        var mejor = ElMejor<Escala, [Int]>(por: { $0.lexicographicallyPrecedes($1) })
        for (puesto, tipo) in TipoDeEscala.paraAcordes.enumerated() {
            let escala = Escala(acorde.fundamental, tipo)
            guard escala.contiene(acorde: acorde) else { continue }
            let fuera = escala.notas.filter { !contexto.contains($0.claseDeAltura) }.count
            mejor.proponer(escala, coste: [fuera, escala.notasAEvitar(sobre: acorde).count, puesto])
        }
        return mejor.valor
    }

    /// La escala para un acorde, analizándolo antes en esta tonalidad (`siguiente` decide, como en
    /// `analizar(_:siguiente:)`, si es una dominante secundaria).
    public func escalaDelAcorde(_ acorde: Acorde, siguiente: Acorde? = nil) -> Escala? {
        escalaDelAcorde(analizar(acorde, siguiente: siguiente))
    }

    /// Las escalas que pide el acorde por lo que hace en la tonalidad, de la más propia a la menos.
    private func escalasPropuestas(para analizado: AcordeAnalizado) -> [Escala] {
        let acorde = analizado.acorde
        let raiz = acorde.fundamental
        let estructura = acorde.estructura
        let esDominante = estructura.tercera == .terceraMayor && estructura.septima == .septimaMenor
        switch analizado.categoria {
        case .diatonico, .cuartaYSextaCadencial:
            return Self.modos(sobre: raiz, de: madres(de: self))
        case .dominanteSecundaria(let grado), .sensibleSecundaria(let grado):
            let destino = self.acorde(grado: grado)
            let mayor = Escala(destino.fundamental, .mayor)
            let armonica = Escala(destino.fundamental, .menorArmonica)
            return Self.modos(sobre: raiz, de: destino.tipo.esMenor ? [armonica] : [mayor, armonica])
        case .sustitutoTritonal:
            return [Escala(raiz, .lidioDominante)]
        case .napolitana:
            return [Escala(raiz, .lidio)]
        case .sextaAumentada:
            return [Escala(tonica + .sextaMenor, .lidioDominante)]
        case .prestamo:
            if esDominante { return [Escala(raiz, .lidioDominante)] }
            return Self.modos(sobre: raiz, de: madres(de: homonima))
        case .cromatico:
            return esDominante ? [Escala(raiz, .lidioDominante)] : []
        }
    }

    /// Las escalas de una tonalidad de las que salen sus acordes: la mayor; en menor, la natural, la armónica y
    /// la melódica.
    private func madres(de tonalidad: Tonalidad) -> [Escala] {
        guard tonalidad.modo == .menor else { return [Escala(tonalidad.tonica, .mayor)] }
        return [.menorNatural, .menorArmonica, .menorMelodicaJazz].map { Escala(tonalidad.tonica, $0) }
    }

    /// El modo de cada madre que empieza en `raiz` (por su nombre o, si no, por su sonido).
    private static func modos(sobre raiz: Nota, de madres: [Escala]) -> [Escala] {
        madres.compactMap { madre in
            let grado =
                madre.grado(de: raiz) ?? madre.notas.firstIndex { $0.esEnarmonica(de: raiz) }.map { $0 + 1 }
            return grado.map { madre.modo(grado: $0) }
        }
    }
}

extension AnalisisArmonico {
    /// La escala de cada acorde en la tonalidad del análisis (`Tonalidad.escalaDelAcorde(_:)`):
    /// en «Rem7 Sol7 Do7M», Re dórico, Sol mixolidio y Do mayor.
    public var escalas: [Escala?] { acordes.map { tonalidad.escalaDelAcorde($0) } }
}
