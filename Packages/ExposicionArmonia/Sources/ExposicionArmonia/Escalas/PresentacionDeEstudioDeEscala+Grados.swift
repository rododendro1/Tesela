import Armonia

// Lo que se pide de los grados de una escala en `armonia escala … --tensiones-disponibles` y `--cuartas`, y los
// ajnas de `--tetracordos`: lo mismo para el texto y para `--json`. Sus nombres son las claves del JSON.

/// La cuatríada de un grado con sus tensiones disponibles (`Escala.tensionesDisponibles(grado:)`).
public struct TensionesDelGradoPresentadas: Hashable, Sendable, Codable {
    /// Del 1 en adelante.
    public let grado: Int
    /// «Rem7».
    public let acorde: String
    /// Cada tensión con su cifra: «Mi 9», «Sol 11», «Si 13».
    public let tensiones: [String]
}

/// El acorde por cuartas de un grado (`Escala.acordesDeLosGrados(deNotas:por:)`): sus notas en el orden en que se
/// apilan y su cifrado, si forman un tipo conocido.
public struct AcordePorCuartasPresentado: Hashable, Sendable, Codable {
    /// Del 1 en adelante.
    public let grado: Int
    /// «Mi», «La», «Re», «Sol»; vacío si al grado le falta una 4.ª.
    public let notas: [String]
    /// «Mi7sus4»; `nil` si las notas no forman un tipo conocido.
    public let cifrado: String?
}

/// Un jins o un çeşni de un maqām o un makam (`TipoDeEscala.ajnas`): su nombre, el grado en que empieza y sus notas.
public struct FragmentoDeLaEscalaPresentado: Hashable, Sendable, Codable {
    public let nombre: String
    /// La nota en que empieza: «Re».
    public let desde: String
    public let notas: [String]
}

/// Los ajnas o çeşni de una escala, con la obra que los da.
public struct AjnasPresentados: Hashable, Sendable, Codable {
    /// «Touma 1996: 43».
    public let fuente: String
    public let fragmentos: [FragmentoDeLaEscalaPresentado]
}

extension PresentacionDeEstudioDeEscala {
    /// La cuatríada de cada grado que la tiene, con sus tensiones disponibles, la tabla de Berklee.
    ///
    ///     let grados = PresentacionDeEstudioDeEscala.tensionesDisponibles(de: Escala(.do), en: .compacta(.espanol))
    ///     grados[1].tensiones   // ["Mi 9", "Sol 11", "Si 13"]
    public static func tensionesDisponibles(
        de escala: Escala, en notacion: Notacion
    ) -> [TensionesDelGradoPresentadas] {
        escala.gradosArmonizados.compactMap { grado in
            guard let acorde = grado.acorde else { return nil }
            return TensionesDelGradoPresentadas(
                grado: grado.grado, acorde: acorde.cifrado(en: notacion),
                tensiones: grado.tensiones.map { $0.nota.nombre(en: notacion) + " " + $0.cifra })
        }
    }

    /// Los acordes de cuatro notas por cuartas de cada grado, la armonía cuartal del jazz modal.
    ///
    ///     let grados = PresentacionDeEstudioDeEscala.acordesPorCuartas(
    ///         de: Escala(.re, .dorico), en: .compacta(.espanol))
    ///     grados[1].notas   // ["Mi", "La", "Re", "Sol"]
    public static func acordesPorCuartas(de escala: Escala, en notacion: Notacion) -> [AcordePorCuartasPresentado] {
        escala.acordesDeLosGrados(deNotas: 4, por: .cuartas).enumerated().map { i, acorde in
            AcordePorCuartasPresentado(
                grado: i + 1,
                notas: (escala.notasApiladas(grado: i + 1, deNotas: 4, por: .cuartas) ?? []).map {
                    $0.nombre(en: notacion)
                },
                cifrado: acorde?.cifrado(en: notacion))
        }
    }

    /// Los ajnas o çeşni que da su teoría a un maqām o un makam; `nil` si la escala no tiene.
    public static func ajnas(de escala: Escala, en notacion: Notacion) -> AjnasPresentados? {
        guard let fuente = escala.tipo.fuenteDeLosAjnas else { return nil }
        return AjnasPresentados(
            fuente: fuente.cita,
            fragmentos: escala.tipo.ajnas.map {
                FragmentoDeLaEscalaPresentado(
                    nombre: $0.fragmento.nombre(en: notacion), desde: escala.grado($0.grado).nombre(en: notacion),
                    notas: escala.notas(de: $0).map { $0.nombre(en: notacion) })
            })
    }
}
