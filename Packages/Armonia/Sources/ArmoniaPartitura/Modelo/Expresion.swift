// Lo que se escribe sobre las notas además de su altura y su duración: la dinámica (p, mf, f…) y las articulaciones
// (staccato, acento, calderón…). Van en cada `Evento` y los formatos de partitura las escriben y las leen; el MIDI
// toca la dinámica como velocidad.
//
// En el texto de un evento van al final, entre llaves y separadas por comas, sin espacios: «Do4:4{f,staccato}»,
// «Re4:2~{acento}», «-:4{calderon}». Los nombres son los mismos en todos los idiomas.

/// La dinámica que se marca en una nota: de *ppp* a *fff*, que valen hasta la siguiente marca, y *sfz* y *fp*, que
/// solo valen en su nota.
///
///     let evento = try Evento(leyendo: "Do4:4{mf}")
///     evento.dinamica                   // .mf
///     Dinamica.mf.velocidadMIDI         // 80
public enum Dinamica: String, CaseIterable, Hashable, Sendable, Codable {
    case ppp, pp, p, mp, mf, f, ff, fff
    /// Sforzando: un acento fuerte en su nota.
    case sfz
    /// Forte-piano: la nota empieza fuerte y baja enseguida a piano.
    case fp

    /// La velocidad MIDI con que suena una nota (de 1 a 127).
    public var velocidadMIDI: Int {
        switch self {
        case .ppp: return 16
        case .pp: return 33
        case .p: return 49
        case .mp: return 64
        case .mf: return 80
        case .f: return 96
        case .ff: return 112
        case .fff: return 127
        case .sfz: return 112
        case .fp: return 96
        }
    }

    /// Si solo vale en su nota (*sfz*, *fp*): después vuelve la dinámica que había.
    public var esDeUnaNota: Bool { self == .sfz || self == .fp }
}

/// Cómo se ataca o se sostiene una nota.
///
///     let evento = try Evento(leyendo: "Sol4:8{staccato,acento}")
///     evento.articulaciones             // [.staccato, .acento]
public enum Articulacion: String, CaseIterable, Hashable, Sendable, Codable {
    /// Picado: más corta de lo que se escribe.
    case staccato
    /// Muy picado: más corta todavía.
    case staccatissimo
    /// Sostenida hasta el final de su valor.
    case tenuto
    /// Acentuada (>).
    case acento
    /// Muy acentuada (^).
    case marcato
    /// Calderón: se sostiene más de lo que se escribe.
    case calderon

    /// Lo que suena de su duración escrita en MIDI: la mitad el staccato y un cuarto el staccatissimo.
    public var proporcionQueSuena: Duracion {
        switch self {
        case .staccato: return Duracion(1, 2)
        case .staccatissimo: return Duracion(1, 4)
        default: return Duracion(1, 1)
        }
    }

    /// Los otros nombres con que se lee, sin tildes: los ingleses y los que llevan tilde.
    static let alias: [String: Articulacion] = [
        "accent": .acento, "fermata": .calderon, "ten": .tenuto, "stacc": .staccato, "marc": .marcato,
    ]
}
