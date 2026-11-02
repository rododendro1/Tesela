import ArmoniaNucleo

// Armonía negativa: el reflejo de las notas sobre el eje que está entre la tónica y la dominante (entre Mi♭ y Mi en
// Do), que cambia el mayor por el menor y la dominante por la subdominante menor.

extension Tonalidad {
    /// El reflejo de una nota sobre el eje entre la tónica y la dominante, escrito en la línea de quintas: en Do, Do
    /// ↔ Sol, Mi ↔ Mi♭, Si ↔ La♭, Re ↔ Fa, La ↔ Si♭. Es el mismo en mayor y en menor.
    ///
    ///     Tonalidad(.do).negativa(.mi)   // Mi♭
    ///     Tonalidad(.do).negativa(.si)   // La♭
    public func negativa(_ nota: Nota) -> Nota {
        Nota(pasosDeQuinta: 2 * tonica.pasosDeQuinta + 1 - nota.pasosDeQuinta)
    }

    /// El acorde negativo: el que forman los reflejos de sus notas (ver ``negativa(_:)``), leído en estado
    /// fundamental si se puede. El mayor se vuelve menor y la dominante, subdominante menor: en Do, Do → Dom, Fa →
    /// Solm, Sol7 → Reø7 (o Fam6, que tiene las mismas notas). `nil` si los reflejos no forman un acorde conocido.
    ///
    ///     Tonalidad(.do).negativo(Acorde("Do"))    // Dom
    ///     Tonalidad(.do).negativo(Acorde("Lam"))   // Mi♭
    public func negativo(_ acorde: Acorde) -> Acorde? {
        let notas = (acorde.notas + [acorde.bajo]).map(negativa)
        var unicas: [Nota] = []
        for nota in notas where !unicas.contains(nota) { unicas.append(nota) }
        // De las lecturas con cada nota en el bajo, la más probable en estado fundamental; si no hay, la primera.
        var mejor: Candidato<Acorde>?
        for i in unicas.indices {
            let orden = [unicas[i]] + unicas.enumerated().filter { $0.offset != i }.map(\.element)
            let candidatos = Acorde.candidatos(orden).filter { $0.valor.inversion == 0 && $0.valor.omitidas.isEmpty }
            if let primero = candidatos.first, primero.coste < (mejor?.coste ?? .infinity) { mejor = primero }
        }
        return mejor?.valor ?? Acorde.identificar(unicas).first
    }

    /// Los acordes negativos de una progresión (ver ``negativo(_:)``): Rem7 Sol7 Do7M en Do da la progresión
    /// negativa, que va de la subdominante menor a la tónica menor.
    public func negativos(_ acordes: [Acorde]) -> [Acorde?] { acordes.map(negativo) }
}
