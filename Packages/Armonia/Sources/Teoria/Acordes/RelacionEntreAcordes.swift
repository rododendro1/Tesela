import Elementos

// MARK: - Lo que separa a dos acordes

/// Lo que separa a dos acordes: las notas que comparten, la conducción de voces mínima con sus tres tamaños de
/// Tymoczko, los pasos P, L y R del Tonnetz, la distancia de Lerdahl en una tonalidad y lo que se parecen sus
/// contenidos (`RelacionEntreConjuntos`). ``voces(en:)`` da cómo va cada voz en una disposición.
///
///     let relacion = Acorde("Sol7").relacion(con: Acorde("Do"))
///     relacion.comunes                        // [Sol]
///     relacion.conduccion.semitonosMovidos    // 4
///     relacion.distanciaDeLerdahl             // 5, en Do mayor
///     relacion.voces()?.movimientos           // lo que sube (+) o baja (−) cada voz, en semitonos
public struct RelacionEntreAcordes: Hashable, Sendable {
    public let origen: Acorde
    public let destino: Acorde
    /// Las notas del primero que suenan también en el segundo (por su sonido: Fa♯ y Sol♭ son la misma).
    public let comunes: [Nota]
    /// La conducción con menos semitonos: su ``ConduccionMinima/semitonosMovidos`` es la norma del taxista de
    /// Tymoczko, y tiene también la euclídea y la del máximo.
    public let conduccion: ConduccionMinima
    /// Las transformaciones P, L y R que van de uno a otro por el Tonnetz, si los dos son tríadas mayores o menores.
    public let distanciaEnElTonnetz: Int?
    /// La tonalidad en la que se mide la distancia de Lerdahl.
    public let tonalidad: Tonalidad
    /// La distancia de Lerdahl del primero al segundo en esa tonalidad (``Tonalidad/distanciaDeLerdahl(de:a:)``).
    public let distanciaDeLerdahl: Int
    /// Lo que se parecen sus clases de altura: Fourier, Isaacson, Morris y Forte.
    public let conjunto: RelacionEntreConjuntos

    /// Las voces de los dos acordes en una disposición, de grave a agudo, con la conducción de menor movimiento.
    public struct Voces: Hashable, Sendable {
        /// La disposición del primero y la del segundo, con las voces de grave a agudo.
        public let desde: [Altura]
        public let hasta: [Altura]

        /// Lo que se mueve cada voz, de la más grave a la más aguda, en semitonos: positivo si sube.
        public var movimientos: [Int] { zip(desde, hasta).map { $1.midi - $0.midi } }

        /// La suma de lo que se mueven las voces, sin signo.
        public var movimientoTotal: Int { movimientos.map(abs).reduce(0, +) }
    }

    /// Cómo va cada voz del primero al segundo con el menor movimiento en la disposición dada (cerrada, a cuatro
    /// voces, si no se dice otra). `nil` si alguno no se puede disponer así.
    public func voces(en disposicion: DisposicionDeAcorde = .cerrada) -> Voces? {
        guard let voces = disposicion.conducir([origen, destino]), voces.count == 2 else { return nil }
        return Voces(desde: voces[0], hasta: voces[1])
    }
}

extension Acorde {
    /// Lo que lo separa de otro acorde (`RelacionEntreAcordes`), con la distancia de Lerdahl en una tonalidad (por
    /// defecto, la de este acorde: ``tonalidadPropia``).
    public func relacion(con otro: Acorde, en tonalidad: Tonalidad? = nil) -> RelacionEntreAcordes {
        let tonalidad = tonalidad ?? tonalidadPropia
        let suyas = Set(otro.notas.map(\.claseDeAltura))
        var comunes: [Nota] = []
        for nota in notas where suyas.contains(nota.claseDeAltura) && !comunes.contains(nota) { comunes.append(nota) }
        return RelacionEntreAcordes(
            origen: self, destino: otro, comunes: comunes, conduccion: conduccionMinima(hasta: otro),
            distanciaEnElTonnetz: caminoNeorriemanniano(hasta: otro, enarmonico: true)?.count, tonalidad: tonalidad,
            distanciaDeLerdahl: tonalidad.distanciaDeLerdahl(de: self, a: otro),
            conjunto: ConjuntoDeClasesDeAltura(notas: notasDesdeElBajo).relacion(
                con: ConjuntoDeClasesDeAltura(notas: otro.notasDesdeElBajo)))
    }
}
