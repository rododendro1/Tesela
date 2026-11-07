import Armonia

/// Lo que se sabe de un acorde suelto aparte de sus notas: cómo más se llama, en qué tonalidades está y por qué se
/// puede cambiar.
public struct RelacionesPresentadas: Hashable, Sendable {
    /// Los otros cifrados de las mismas notas: «Lam7/Do» para Do6.
    public let otrosNombres: [String]
    /// El acorde que queda sin la fundamental, si es otro: «Si°7» para Sol7(♭9).
    public let sinFundamental: String?
    /// Cada tonalidad en que el acorde es diatónico, con su grado y su función: «ii7 en Do mayor · Subdominante».
    public let tonalidades: [String]
    /// La tonalidad en que se proponen las sustituciones.
    public let tonalidad: Tonalidad
    public let sustituciones: [PropuestaDeRearmonizacion]
}

/// Dos acordes comparados: sus notas comunes y cómo se mueve cada voz de uno al otro.
public struct ComparacionPresentada: Hashable, Sendable {
    public let comparacion: ComparacionDeAcordes
    /// «Do, Mi, Sol», o «ninguna».
    public let comunes: String
    /// Una por voz, de grave a agudo: «Sol₃ → Do₄ (+5)».
    public let voces: [String]
    /// «Movimiento total: 7 semitonos».
    public let movimiento: String
    /// Los dos acordes, uno detrás de otro.
    public let sonido: Escucha
}

/// Las relaciones de un acorde y la comparación de dos de la vista de acordes y de `armonia acorde`. No usa SwiftUI,
/// así que se prueba en Linux.
///
///     let relaciones = PresentacionDeRelacionesDeAcorde.relaciones(de: Acorde("Do6"), notacion: .espanolCompacto)
///     relaciones.otrosNombres.contains("Lam7/Do")   // true
public enum PresentacionDeRelacionesDeAcorde {
    /// Los otros nombres, el acorde sin la fundamental, las tonalidades y las sustituciones en la tonalidad dada o,
    /// si no, en la del acorde (``Acorde/tonalidadPropia``).
    public static func relaciones(
        de acorde: Acorde, en tonalidad: Tonalidad? = nil, notacion: Notacion
    ) -> RelacionesPresentadas {
        let tonalidad = tonalidad ?? acorde.tonalidadPropia
        let tonalidades = acorde.tonalidades.map { analisis in
            [analisis.nombre(en: notacion), analisis.acordes[0].funcion?.nombre(en: notacion)]
                .compactMap { $0 }.joined(separator: " · ")
        }
        let sustituciones = acorde.sustituciones(en: tonalidad).map { rearmonizacion in
            PropuestaDeRearmonizacion(
                rearmonizacion: rearmonizacion, descripcion: rearmonizacion.descripcion(en: notacion),
                texto: PresentacionDeTransposicion.texto(de: rearmonizacion.acordes, en: notacion),
                sonido: Escucha.acordes([acorde] + rearmonizacion.acordes).conTonica(tonalidad.tonica))
        }
        return RelacionesPresentadas(
            otrosNombres: acorde.otrosNombres.map { $0.cifrado(en: notacion) },
            sinFundamental: acorde.sinFundamental.map { $0.cifrado(en: notacion) },
            tonalidades: tonalidades, tonalidad: tonalidad, sustituciones: sustituciones)
    }

    /// Un acorde y otro con la conducción de menor movimiento en la disposición dada. `nil` si alguno no se puede
    /// disponer así.
    ///
    ///     let comparacion = PresentacionDeRelacionesDeAcorde.comparar(
    ///         Acorde("Sol7"), con: Acorde("Do"), en: .espanolCompacto)
    ///     comparacion?.comunes   // "Sol"
    public static func comparar(
        _ acorde: Acorde, con otro: Acorde, disposicion: DisposicionDeAcorde = .cerrada, en notacion: Notacion
    ) -> ComparacionPresentada? {
        guard let comparacion = acorde.comparar(con: otro, disposicion: disposicion) else { return nil }
        let comunes = comparacion.comunes.map { $0.nombre(en: notacion) }
        let voces = zip(comparacion.desde, comparacion.hasta).map { desde, hasta in
            let paso = hasta.midi - desde.midi
            let signo = paso > 0 ? "+" : ""
            return desde.nombre(en: notacion) + " → " + hasta.nombre(en: notacion) + " (\(signo)\(paso))"
        }
        let total = comparacion.movimientoTotal
        return ComparacionPresentada(
            comparacion: comparacion,
            comunes: comunes.isEmpty ? notacion.texto(\.ningunaNotaComun) : comunes.joined(separator: ", "),
            voces: voces, movimiento: notacion.texto { $0.movimientoTotal(total) },
            sonido: .coral([comparacion.desde, comparacion.hasta], duracion: 1.5))
    }
}
