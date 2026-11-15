import Elementos

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

    /// La escala que pide el cifrado de un acorde, sin tonalidad, como en la teoría acorde-escala del jazz
    /// (Levine 1995): 7M, 6, 6/9 y la tríada mayor → jónico; 7M(♯11) → lidio; 7, 9, 13 y 7sus4 → mixolidio;
    /// 7(♯11) → lidio dominante; 7(♭13) → mixolidio ♭6; 7alt → alterada; 7(♭9) y 7(♯9) → disminuida
    /// semitono-tono (la alterada no tiene la 5.ª justa); +7 → tonos enteros; m, m7, m9 y m11 → dórico; m6 y m(7M) → menor melódica; ø7 → locrio ♮2;
    /// °7 → disminuida tono-semitono; + y +7M → lidio aumentado. `nil` si el cifrado no pide ninguna (una tríada
    /// disminuida, un sus4 sin 7.ª, una quinta sola).
    public static func delCifrado(_ estructura: EstructuraDeAcorde) -> TipoDeEscala? {
        let tercera = estructura.tercera?.semitonos
        let quintas = Set(estructura.quintasDelAcorde.map(\.semitonos))
        let septima = estructura.septima?.semitonos
        let tensiones = Set(estructura.tensiones.map { modulo($0.semitonos, 12) })
        let sus4 = estructura.suspension?.semitonos == 5
        switch (tercera, septima) {
        case (4?, 10?):
            if quintas == [8] && tensiones.isEmpty { return .tonosEnteros }
            // La alterada no tiene la 5.ª justa: con ella, la ♯9 sola pide la disminuida semitono-tono.
            if tensiones.contains(3) && quintas == [7] && !tensiones.contains(8) { return .disminuidaSemitonoTono }
            if tensiones.contains(3) || quintas.contains(8) && quintas.contains(6) { return .alterada }
            if tensiones.contains(1) { return tensiones.contains(8) ? .alterada : .disminuidaSemitonoTono }
            if tensiones.contains(6) || quintas == [6] { return .lidioDominante }
            if tensiones.contains(8) { return .mixolidioSextaMenor }
            return .mixolidio
        case (4?, 11?), (4?, nil):
            if quintas.contains(8) { return .lidioAumentado }
            return tensiones.contains(6) ? .lidio : .mayor
        case (nil, 10?) where sus4:
            return .mixolidio
        case (3?, 9?) where quintas == [6]:
            return .disminuida
        case (3?, 10?) where quintas == [6]:
            return .locrioSegundaNatural
        case (3?, _) where quintas.contains(6):
            return nil
        case (3?, 11?):
            return .menorMelodicaJazz
        case (3?, nil):
            return estructura.sexta == nil ? .dorico : .menorMelodicaJazz
        case (3?, 10?):
            return .dorico
        default:
            return nil
        }
    }
}

extension Acorde {
    /// Las escalas que sirven para el acorde (``Escala/esCompatible(con:)``), de la que mejor le va a la que peor:
    /// primero la que pide el cifrado (``TipoDeEscala/delCifrado(_:)``); después, la que menos alteraciones
    /// añade que el cifrado no pide (``alteracionesNoPedidas(en:)``), la que menos notas a evitar tiene, la de
    /// siete notas antes que otra y, a igualdad, la que va antes en `escalas`. Es el criterio de
    /// ``escalasCompatibles(entre:)``, de ``Tonalidad/escalaDelAcorde(_:)`` cuando la tonalidad no basta (que
    /// antes mira cuántas notas saca de ella) y de ``Arpegio/nota(delGrado:)``.
    package func ordenar(_ escalas: [Escala], coste previo: (Escala) -> Int = { _ in 0 }) -> [Escala] {
        let delCifrado = TipoDeEscala.delCifrado(estructura)
        let costes = escalas.enumerated().map { puesto, escala in
            [
                previo(escala), escala.tipo == delCifrado ? 0 : 1, alteracionesNoPedidas(en: escala).count,
                escala.notasAEvitar(sobre: self).count, escala.notas.count == 7 ? 0 : 1, puesto,
            ]
        }
        return escalas.indices.sorted { costes[$0].lexicographicallyPrecedes(costes[$1]) }.map { escalas[$0] }
    }

    /// Las notas de la escala que alteran el acorde sin que lo pida su cifrado: la ♭9; la ♯9 si el acorde tiene
    /// 3.ª mayor; y la ♯11 y la ♭13 si tiene 5.ª justa (en ø7 y °7 son la 5.ª del acorde, o la chocan). Do lidio
    /// dominante añade a Do7 la ♯11, y Do mixolidio, nada.
    package func alteracionesNoPedidas(en escala: Escala) -> [NotaSobreElAcorde] {
        let tercera = estructura.tercera?.semitonos
        let quintaJusta = estructura.quintasDelAcorde.contains { $0.semitonos == 7 }
        return escala.notas(sobre: self).filter { nota in
            guard nota.papel != .delAcorde, nota.papel != .dePaso else { return false }
            switch modulo(nota.nota.claseDeAltura - fundamental.claseDeAltura, 12) {
            case 1: return true
            case 3: return tercera == 4
            case 6, 8: return quintaJusta
            default: return false
            }
        }
    }
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
    /// Si esa escala no tiene todas las notas del acorde (Sol7(♭9) en Do), se elige, entre las de
    /// ``TipoDeEscala/paraAcordes`` que no chocan con él (``Escala/esCompatible(con:)``), la que tiene menos notas
    /// fuera de la tonalidad y, a igualdad, la primera en el orden de ``Acorde/escalasCompatibles(entre:)`` (Sol
    /// frigio dominante; sin tonalidad, Sol7(♭9) da la disminuida semitono-tono). `nil` si ninguna sirve.
    public func escalaDelAcorde(_ analizado: AcordeAnalizado) -> Escala? {
        let acorde = analizado.acorde
        if let propuesta = escalasPropuestas(para: analizado).first(where: { $0.contiene(acorde: acorde) }) {
            return propuesta
        }
        let contexto = Set((notasPropias + acorde.notasDesdeElBajo).map(\.claseDeAltura))
        let compatibles = TipoDeEscala.paraAcordes.map { Escala(acorde.fundamental, $0) }.filter {
            $0.esCompatible(con: acorde)
        }
        return acorde.ordenar(compatibles) { escala in
            escala.notas.filter { !contexto.contains($0.claseDeAltura) }.count
        }.first
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
