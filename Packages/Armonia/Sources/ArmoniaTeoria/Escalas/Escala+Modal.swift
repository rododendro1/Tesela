import ArmoniaNucleo

// Armonía modal: lo que distingue a cada modo de la escala mayor (su nota característica), los acordes que la
// llevan y la cadencia que lo afirma sin la dominante de la tonalidad.

extension Escala {
    /// Si la escala es uno de los siete modos de la escala mayor (jónico, dórico, frigio, lidio, mixolidio, eólico y
    /// locrio), cuál: de 1 a 7. `nil` si no lo es.
    public var modoDeLaMayor: Int? {
        guard let madre = escalaMadre, madre.madre.tipo == .mayor else { return nil }
        return madre.modo
    }

    /// La nota que distingue al modo del mayor o del menor más parecido: la sensible en jónico, la 6.ª mayor en
    /// dórico, la 2.ª menor en frigio, la 4.ª aumentada en lidio, la 7.ª menor en mixolidio, la 6.ª menor en eólico
    /// y la 5.ª disminuida en locrio. `nil` si la escala no es un modo de la mayor.
    ///
    ///     Escala(.re, .dorico).notaCaracteristica      // Si
    ///     Escala(.fa, .lidio).notaCaracteristica       // Si
    public var notaCaracteristica: Nota? {
        guard let modo = modoDeLaMayor else { return nil }
        let intervalos: [Intervalo] = [
            .septimaMayor, .sextaMayor, .segundaMenor, .cuartaAumentada, .septimaMenor, .sextaMenor, .quintaDisminuida,
        ]
        return tonica + intervalos[modo - 1]
    }

    /// Las tríadas del modo, salvo la de la tónica y las disminuidas, que tienen la nota característica: las que lo
    /// hacen sonar como tal. Vacío si la escala no es un modo de la mayor.
    ///
    ///     Escala(.re, .dorico).acordesCaracteristicos    // [Mim, Sol]
    public var acordesCaracteristicos: [Acorde] {
        guard let caracteristica = notaCaracteristica else { return [] }
        return armonizar().dropFirst().compactMap { $0 }.filter { acorde in
            acorde.notas.contains(caracteristica) && acorde.tipo.estructura.calidadDeTriada != .disminuida
        }
    }

    /// La cadencia propia del modo, de un acorde característico a la tónica: V–I en jónico, IV–i en dórico,
    /// ♭II–i en frigio, II–I en lidio, ♭VII–I en mixolidio, ♭VI–i en eólico y ♭V–i° en locrio. `nil` si la escala no
    /// es un modo de la mayor.
    ///
    ///     Escala(.sol, .mixolidio).cadenciaModal   // [Fa, Sol]
    ///     Escala(.mi, .frigio).cadenciaModal       // [Fa, Mim]
    public var cadenciaModal: [Acorde]? {
        guard let modo = modoDeLaMayor else { return nil }
        let grado = [5, 4, 2, 2, 7, 6, 5][modo - 1]
        guard let caracteristico = acorde(grado: grado), let tonica = acorde(grado: 1) else { return nil }
        return [caracteristico, tonica]
    }
}
