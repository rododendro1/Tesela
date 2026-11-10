import Elementos

// MARK: - Lo que separa a dos acordes

/// Lo que separa a dos acordes: la conducción de voces mínima con sus tres tamaños de Tymoczko, los pasos P, L y R
/// del Tonnetz, la distancia de Lerdahl en una tonalidad y lo que se parecen sus contenidos (`RelacionEntreConjuntos`).
///
///     let relacion = Acorde("Sol7").relacion(con: Acorde("Do"))
///     relacion.conduccion.semitonosMovidos    // 4
///     relacion.distanciaDeLerdahl             // 5, en Do mayor
public struct RelacionEntreAcordes: Hashable, Sendable {
    public let origen: Acorde
    public let destino: Acorde
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
}

extension Acorde {
    /// Lo que lo separa de otro acorde (`RelacionEntreAcordes`), con la distancia de Lerdahl en una tonalidad (por
    /// defecto, la de este acorde: ``tonalidadPropia``).
    public func relacion(con otro: Acorde, en tonalidad: Tonalidad? = nil) -> RelacionEntreAcordes {
        let tonalidad = tonalidad ?? tonalidadPropia
        return RelacionEntreAcordes(
            origen: self, destino: otro, conduccion: conduccionMinima(hasta: otro),
            distanciaEnElTonnetz: caminoNeorriemanniano(hasta: otro, enarmonico: true)?.count, tonalidad: tonalidad,
            distanciaDeLerdahl: tonalidad.distanciaDeLerdahl(de: self, a: otro),
            conjunto: ConjuntoDeClasesDeAltura(notas: notasDesdeElBajo).relacion(
                con: ConjuntoDeClasesDeAltura(notas: otro.notasDesdeElBajo)))
    }
}
