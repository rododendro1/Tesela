import Elementos

// Lo que se sabe de un acorde suelto mirando a los demás: otros nombres de sus mismas notas, en qué tonalidades
// está, cómo se va de él a otro y por qué acordes se puede cambiar.

// MARK: - Otros nombres

extension Acorde {
    /// Otros cifrados de las mismas notas sobre el mismo bajo, del más al menos habitual: Do6 es también Lam7/Do, y
    /// Do°7, Mi♭°7, Fa♯°7 y La°7 (las cuatro fundamentales de un acorde simétrico se dan sin bajo, en estado
    /// fundamental). Solo lecturas con todas las notas, sin suponer ninguna que falte.
    ///
    ///     Acorde("Do6").otrosNombres.first?.cifrado   // "Lam7/Do"
    public var otrosNombres: [Acorde] {
        let clases = notasDesdeElBajo.map(\.claseDeAltura)
        var resultado: [Acorde] = []
        for candidato in Acorde.candidatos(clasesDeAltura: clases) where candidato.notasOmitidas.isEmpty {
            var otro = candidato.valor
            // Un acorde simétrico (Do°7, Do+) se lee igual desde cualquiera de sus notas: sin bajo.
            if otro.tipo == tipo { otro = Acorde(otro.fundamental, otro.tipo) }
            let esElMismo = otro.fundamental.claseDeAltura == fundamental.claseDeAltura && otro.tipo == tipo
            if !esElMismo, !resultado.contains(otro) { resultado.append(otro) }
        }
        return resultado
    }

    /// El acorde que forman sus notas sin la fundamental, o `nil` si quedan menos de tres: Do7M sin Do es Mim, y
    /// Sol7(♭9) sin Sol, Si°7. Es lo que suena cuando el bajo toca la fundamental y la mano, el resto.
    public var sinFundamental: Acorde? {
        let resto = notasDesdeElBajo.filter { $0.claseDeAltura != fundamental.claseDeAltura }
        guard resto.count >= 3 else { return nil }
        return Acorde.identificar(notas: resto).first
    }
}

// MARK: - Tonalidades

extension Acorde {
    /// Las tonalidades mayores y menores (de 7 bemoles a 7 sostenidos) en las que el acorde es diatónico, cada una
    /// con el acorde analizado (su cifrado romano y su función): Rem7 es ii7 en Do mayor, iii7 en Si♭ mayor, vi7 en
    /// Fa mayor… Primero las de menos alteraciones y, a igualdad, la mayor.
    ///
    ///     Acorde("Rem7").tonalidades.map(\.description)
    ///     // ["ii7 en Do mayor", "iv7 en La menor", "vi7 en Fa mayor", …]
    public var tonalidades: [AnalisisArmonico] {
        let todas = Tonalidad.circuloDeQuintas(.mayor) + Tonalidad.circuloDeQuintas(.menor)
        let diatonicas = todas.enumerated().compactMap { indice, tonalidad -> (Int, AnalisisArmonico)? in
            let analizado = tonalidad.analizar(self)
            guard analizado.categoria == .diatonico else { return nil }
            return (indice, AnalisisArmonico(tonalidad: tonalidad, acordes: [analizado]))
        }
        return diatonicas.sorted { a, b in
            (abs(a.1.tonalidad.armadura), a.0) < (abs(b.1.tonalidad.armadura), b.0)
        }.map(\.1)
    }
}

// MARK: - Comparar

/// Dos acordes, uno tras otro: las notas que comparten y cómo va cada voz del primero al segundo con el menor
/// movimiento.
@available(*, deprecated, message: "Usa RelacionEntreAcordes, de Acorde.relacion(con:en:), y su voces(en:)")
public struct ComparacionDeAcordes: Hashable, Sendable {
    public let origen: Acorde
    public let destino: Acorde
    /// Las notas del primero que suenan también en el segundo (por su sonido: Fa♯ y Sol♭ son la misma).
    public let comunes: [Nota]
    /// La disposición del primero y la del segundo, con las voces de grave a agudo.
    public let desde: [Altura]
    public let hasta: [Altura]

    /// Lo que se mueve cada voz, de la más grave a la más aguda, en semitonos: positivo si sube.
    public var movimientos: [Int] { zip(desde, hasta).map { $1.midi - $0.midi } }

    /// La suma de lo que se mueven las voces, sin signo.
    public var movimientoTotal: Int { movimientos.map(abs).reduce(0, +) }
}

extension Acorde {
    /// Este acorde y otro, con sus notas comunes y la conducción de las voces de menor movimiento en la disposición
    /// dada (cerrada, a cuatro voces, si no se dice otra). `nil` si alguno no se puede disponer así.
    @available(*, deprecated, message: "Usa relacion(con:).comunes y relacion(con:).voces(en:)")
    public func comparar(
        con otro: Acorde, disposicion: DisposicionDeAcorde = .cerrada
    ) -> ComparacionDeAcordes? {
        let relacion = relacion(con: otro)
        guard let voces = relacion.voces(en: disposicion) else { return nil }
        return ComparacionDeAcordes(
            origen: self, destino: otro, comunes: relacion.comunes, desde: voces.desde, hasta: voces.hasta)
    }
}

// MARK: - Sustituciones

extension Acorde {
    /// Si es un acorde de dominante: tercera mayor y séptima menor (Sol7, Sol9, Sol13, Sol7(♭9)…).
    public var esDeDominante: Bool {
        guard let tercera, let septima else { return false }
        return Acorde.distancia(fundamental, tercera) == 4 && Acorde.distancia(fundamental, septima) == 10
    }

    /// La tonalidad en la que se lee el acorde suelto: la de la que es dominante si lo es (Sol7, en Do mayor), la
    /// menor de su fundamental si es menor (Lam, en La menor) y si no, la mayor de su fundamental.
    public var tonalidadPropia: Tonalidad {
        if esDeDominante { return Tonalidad(fundamental + .cuartaJusta) }
        return Tonalidad(fundamental, tipo.esMenor ? .menor : .mayor)
    }

    /// Por qué acordes se puede cambiar (o con qué se puede preparar) el acorde suelto en una tonalidad (o en la suya,
    /// ``tonalidadPropia``): las rearmonizaciones de ``Tonalidad/rearmonizaciones(de:en:anterior:)`` y, si es de
    /// dominante, su ii relativo delante (Sol7 → Rem7 Sol7) y el acorde disminuido sobre su tercera, que es él
    /// mismo sin la fundamental y con la novena menor (Sol7 → Si°7).
    ///
    ///     let propuestas = Acorde("Sol7").sustituciones()   // en Do mayor
    ///     propuestas.first { $0.recurso == .sustitutoTritonal }?.acordes   // [Re♭7]
    ///     propuestas.first { $0.recurso == .disminuido }?.acordes          // [Si°7]
    public func sustituciones(en tonalidad: Tonalidad? = nil) -> [Rearmonizacion] {
        var propuestas = (tonalidad ?? tonalidadPropia).rearmonizaciones(de: self)
        if esDeDominante {
            let ii = Acorde(fundamental + .quintaJusta, .menorSeptima)
            propuestas.append(Rearmonizacion(recurso: .iiRelativo, posicion: 0, original: self, acordes: [ii, self]))
            if let tercera {
                let disminuido = Acorde(tercera, .disminuidoSeptima)
                propuestas.append(
                    Rearmonizacion(recurso: .disminuido, posicion: 0, original: self, acordes: [disminuido]))
            }
        }
        return propuestas
    }
}
