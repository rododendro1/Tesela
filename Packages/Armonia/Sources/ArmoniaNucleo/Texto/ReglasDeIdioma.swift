// MARK: - Reglas de cada idioma
//
// Lo que cambia de un idioma a otro al escribir un nombre de nota: las sílabas (o las letras), lo que
// va entre el nombre y la alteración en palabras, y dónde se pone «doble», «triple» o «cuádruple».
// Están aquí como datos, en un solo `switch`, para que añadir un idioma sea añadir una fila y no
// repasar los `switch` de `NotaNatural`, `Nota`, `Altura` y `Alteracion`.

/// Cómo escribe un idioma los nombres de nota: `Idioma.ruso.reglas.separador` es "-" (фа-диез).
public struct ReglasDeIdioma: Hashable, Sendable {
    /// Dónde va el multiplicador de la alteración: «doble bemol», «bemol bikoitza», «Doppel-Be».
    public enum Multiplicador: Hashable, Sendable {
        /// Delante y separado: «doble bemol», «double sharp», «διπλή ύφεση».
        case delante
        /// Detrás y con el sustantivo invariable: «bemol bikoitza» (euskera).
        case detras
        /// Unido a la palabra: «Doppelkreuz», «Doppel-Be» (alemán).
        case unido
    }

    /// Los siete naturales, de Do a Si, como se escriben en el texto: «do», «C», «ντο», «соль».
    public let naturales: [String]
    /// Entre el nombre y la alteración en palabras: " " en casi todos, "-" en ruso.
    public let separador: String
    public let multiplicador: Multiplicador
    /// Cómo escribe las alteraciones cuando no se piden con palabras: con signos en español e inglés
    /// (que por eso tienen tres escrituras), a la alemana en alemán y con palabras en los demás.
    public let alteraciones: EscrituraDeLaAlteracion
    /// Los signos de sus cifrados: # y b en alemán, ♯ y ♭ en los demás. En español e inglés lo elige la
    /// escritura, porque tienen las dos.
    public let tipografia: Tipografia

    public init(
        naturales: [String], separador: String = " ", multiplicador: Multiplicador = .delante,
        alteraciones: EscrituraDeLaAlteracion = .palabras, tipografia: Tipografia = .unicode
    ) {
        self.naturales = naturales
        self.separador = separador
        self.multiplicador = multiplicador
        self.alteraciones = alteraciones
        self.tipografia = tipografia
    }

    /// Si el idioma tiene las tres escrituras (palabras, ASCII y Unicode), como el español y el inglés.
    public var tieneVariantes: Bool { alteraciones == .signos }
}

extension Idioma {
    /// Las reglas de este idioma. Es el único `switch` sobre `Idioma` de los nombres de nota: un idioma
    /// nuevo solo tiene que añadir aquí su fila.
    public var reglas: ReglasDeIdioma {
        switch self {
        case .espanol:
            return ReglasDeIdioma(naturales: ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"], alteraciones: .signos)
        case .ingles:
            return ReglasDeIdioma(naturales: ["C", "D", "E", "F", "G", "A", "B"], alteraciones: .signos)
        case .catalan, .gallego, .asturiano, .aragones, .italiano:
            return ReglasDeIdioma(naturales: ["do", "re", "mi", "fa", "sol", "la", "si"])
        case .euskera:
            return ReglasDeIdioma(naturales: ["do", "re", "mi", "fa", "sol", "la", "si"], multiplicador: .detras)
        case .portugues: return ReglasDeIdioma(naturales: ["dó", "ré", "mi", "fá", "sol", "lá", "si"])
        case .frances: return ReglasDeIdioma(naturales: ["do", "ré", "mi", "fa", "sol", "la", "si"])
        case .occitano: return ReglasDeIdioma(naturales: ["do", "re", "mi", "fa", "sòl", "la", "si"])
        // En alemán la alteración va dentro del nombre (Fis, Eses), así que el separador no se usa.
        case .aleman:
            return ReglasDeIdioma(
                naturales: ["C", "D", "E", "F", "G", "A", "H"], multiplicador: .unido,
                alteraciones: .alemana, tipografia: .ascii)
        case .griego: return ReglasDeIdioma(naturales: ["ντο", "ρε", "μι", "φα", "σολ", "λα", "σι"])
        case .ruso:
            return ReglasDeIdioma(naturales: ["до", "ре", "ми", "фа", "соль", "ля", "си"], separador: "-")
        }
    }
}

// MARK: - Escritura de la alteración

/// Cómo se escribe la alteración en los nombres de nota de una ``EscrituraDeNotas``.
public enum EscrituraDeLaAlteracion: Hashable, Sendable {
    /// Con palabras: «Fa sostenido», «fa dièse», «фа-диез». En los cifrados, la sílaba y el signo (Fa♯).
    case palabras
    /// Con signos tras la letra o la sílaba, según la ``Tipografia``: Fa♯, Fa#, F♯, F#.
    case signos
    /// Dentro del nombre, a la alemana: Fis, Eses, B (Si♭) y H (Si).
    case alemana
}

extension EscrituraDeNotas {
    /// Cómo escribe las alteraciones: con palabras si se piden así, y si no, lo que diga el idioma.
    public var escrituraDeLaAlteracion: EscrituraDeLaAlteracion {
        conPalabras ? .palabras : idioma.reglas.alteraciones
    }
}
