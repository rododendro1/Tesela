import Armonia

// Lo que se consulta de un acorde o de unas notas, sin darle forma: lo mismo para el texto de `armonia`, para su salida
// `--json` y para las apps, así que se calcula en un solo sitio. Los nombres van en la notación pedida y, al lado, lo
// que no depende de ella (las clases de altura: 0 = Do … 11 = Si).
//
// Son `Codable`, y sus nombres son las claves del JSON de `armonia … --json`: en español, sin tildes y siempre las
// mismas, sea cual sea el idioma. Cambiar uno rompe a quien lee ese JSON. Lo que es `nil` no sale en el JSON.

/// Un acorde: su cifrado, su nombre, sus notas y el papel de cada una.
///
///     let datos = AcordePresentado(Acorde("Sol7/Si"), en: .compacta(.espanol))
///     datos.inversion   // 1
public struct AcordePresentado: Hashable, Sendable, Codable {
    /// Una nota del acorde con su papel: «Si tercera».
    public struct Componente: Hashable, Sendable, Codable {
        public let nota: String
        public let papel: String
    }

    public let cifrado: String
    public let nombre: String
    public let fundamental: String
    public let bajo: String
    /// 0 en estado fundamental, 1 en primera inversión…; `nil` si el bajo no es nota del acorde.
    public let inversion: Int?
    public let notas: [String]
    public let clases: [Int]
    public let componentes: [Componente]

    /// Los datos del acorde, escritos en la notación.
    public init(_ acorde: Acorde, en notacion: Notacion) {
        cifrado = acorde.cifrado(en: notacion)
        nombre = acorde.tipo.nombre(en: notacion)
        fundamental = acorde.fundamental.nombre(en: notacion)
        bajo = acorde.bajo.nombre(en: notacion)
        inversion = acorde.inversion
        notas = acorde.notas.map { $0.nombre(en: notacion) }
        clases = acorde.notas.map(\.claseDeAltura)
        componentes = acorde.componentes.map {
            Componente(nota: $0.nota.nombre(en: notacion), papel: $0.papel.nombre(en: notacion))
        }
    }

    /// Si el bajo no es la fundamental: un acorde invertido o con un bajo ajeno a él.
    public var tieneOtroBajo: Bool { bajo != fundamental }
}

/// Un acorde que pueden formar unas notas, con las suyas que faltan.
public struct CandidatoPresentado: Hashable, Sendable, Codable {
    public let cifrado: String
    public let nombre: String
    /// Las notas del acorde que no están entre las tocadas.
    public let omitidas: [String]

    public init(_ candidato: Candidato<Acorde>, en notacion: Notacion) {
        cifrado = candidato.valor.cifrado(en: notacion)
        nombre = candidato.valor.tipo.nombre(en: notacion)
        omitidas = candidato.omitidas.map { $0.nombre(en: notacion) }
    }

    /// Los acordes que pueden formar unas notas escritas, del más probable al menos y como mucho `limite`; ninguno
    /// si no forman ninguno. Si todas llevan octava («Si2 Re4 Sol4»), cuenta cuál es el bajo; si no, solo las notas.
    ///
    ///     let candidatos = try CandidatoPresentado.identificar(["Do", "Mi", "Sol", "Sib"], en: .compacta(.espanol))
    ///     candidatos[0].cifrado   // "Do7"
    public static func identificar(
        _ textos: [String], limite: Int = 5, en notacion: Notacion
    ) throws -> [CandidatoPresentado] {
        let candidatos: [Candidato<Acorde>]
        if let alturas = try? textos.map({ try Altura(leyendo: $0) }) {
            candidatos = Acorde.candidatos(alturas: alturas)
        } else {
            candidatos = Acorde.candidatos(notas: try textos.map { try Nota(leyendo: $0) })
        }
        return candidatos.prefix(limite).map { CandidatoPresentado($0, en: notacion) }
    }
}
