// MARK: - Reglas de cada idioma
//
// Lo que cambia de un idioma a otro y no es una traducción: su código y cómo se llama, las sílabas (o las
// letras) de las notas, lo que va entre el nombre y la alteración en palabras, dónde se pone «doble»,
// «triple» o «cuádruple» y cómo se nombran los modos de una tonalidad. Están aquí como datos, en un solo
// `switch`, para que añadir un idioma sea añadir una fila y no repasar los `switch` de `NotaNatural`,
// `Nota`, `Altura`, `Alteracion` y `Tonalidad`.

/// Los datos de un idioma: `Idioma.ruso.reglas.separador` es "-" (фа-диез) y `Idioma.euskera.reglas.codigo`,
/// "eu".
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

    /// El código ISO 639 del idioma: «es», «ast», «eu».
    public let codigo: String
    /// Cómo se llama el idioma en el propio idioma: «Euskara», «Deutsch», «Ελληνικά».
    public let nombrePropio: String
    /// Cómo se escribe el nombre del idioma, en minúsculas: en español, con y sin tildes, y en el propio
    /// idioma («alemán», «aleman», «deutsch»).
    public let nombres: [String]
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
    /// Los modos de una tonalidad: «mayor» y «menor», «Dur» y «Moll», «maiorra» y «minorra».
    public let mayor: String
    public let menor: String
    /// Entre la tónica y el modo: " " en casi todos, "-" en alemán (C-Dur).
    public let separadorDelModo: String
    /// Si la tónica de una tonalidad menor va en minúscula, como en alemán (a-Moll).
    public let menorEnMinuscula: Bool

    public init(
        codigo: String, nombrePropio: String, nombres: [String],
        naturales: [String], separador: String = " ", multiplicador: Multiplicador = .delante,
        alteraciones: EscrituraDeLaAlteracion = .palabras, tipografia: Tipografia = .unicode,
        mayor: String, menor: String, separadorDelModo: String = " ", menorEnMinuscula: Bool = false
    ) {
        self.codigo = codigo
        self.nombrePropio = nombrePropio
        self.nombres = nombres
        self.naturales = naturales
        self.separador = separador
        self.multiplicador = multiplicador
        self.alteraciones = alteraciones
        self.tipografia = tipografia
        self.mayor = mayor
        self.menor = menor
        self.separadorDelModo = separadorDelModo
        self.menorEnMinuscula = menorEnMinuscula
    }

    /// Si el idioma tiene las tres escrituras (palabras, ASCII y Unicode), como el español y el inglés.
    public var tieneVariantes: Bool { alteraciones == .signos }
}

extension Idioma {
    /// Los datos de este idioma. Es el único `switch` sobre `Idioma` de sus datos y de los nombres de nota:
    /// un idioma nuevo solo tiene que añadir aquí su fila.
    public var reglas: ReglasDeIdioma {
        let silabas = ["do", "re", "mi", "fa", "sol", "la", "si"]
        switch self {
        case .espanol:
            return ReglasDeIdioma(
                codigo: "es", nombrePropio: "Español", nombres: ["espanol", "español", "castellano"],
                naturales: ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"], alteraciones: .signos,
                mayor: "mayor", menor: "menor")
        case .ingles:
            return ReglasDeIdioma(
                codigo: "en", nombrePropio: "English", nombres: ["ingles", "inglés", "english"],
                naturales: ["C", "D", "E", "F", "G", "A", "B"], alteraciones: .signos,
                mayor: "major", menor: "minor")
        case .catalan:
            return ReglasDeIdioma(
                codigo: "ca", nombrePropio: "Català", nombres: ["catalan", "catalán", "català"],
                naturales: silabas, mayor: "major", menor: "menor")
        case .gallego:
            return ReglasDeIdioma(
                codigo: "gl", nombrePropio: "Galego", nombres: ["gallego", "galego"],
                naturales: silabas, mayor: "maior", menor: "menor")
        case .asturiano:
            return ReglasDeIdioma(
                codigo: "ast", nombrePropio: "Asturianu", nombres: ["asturiano", "asturianu"],
                naturales: silabas, mayor: "mayor", menor: "menor")
        case .aragones:
            return ReglasDeIdioma(
                codigo: "an", nombrePropio: "Aragonés", nombres: ["aragones", "aragonés"],
                naturales: silabas, mayor: "mayor", menor: "menor")
        case .euskera:
            return ReglasDeIdioma(
                codigo: "eu", nombrePropio: "Euskara", nombres: ["euskera", "euskara"],
                naturales: silabas, multiplicador: .detras, mayor: "maiorra", menor: "minorra")
        case .portugues:
            return ReglasDeIdioma(
                codigo: "pt", nombrePropio: "Português", nombres: ["portugues", "portugués", "português"],
                naturales: ["dó", "ré", "mi", "fá", "sol", "lá", "si"], mayor: "maior", menor: "menor")
        case .frances:
            return ReglasDeIdioma(
                codigo: "fr", nombrePropio: "Français", nombres: ["frances", "francés", "français", "francais"],
                naturales: ["do", "ré", "mi", "fa", "sol", "la", "si"], mayor: "majeur", menor: "mineur")
        case .occitano:
            return ReglasDeIdioma(
                codigo: "oc", nombrePropio: "Occitan", nombres: ["occitano", "occitan"],
                naturales: ["do", "re", "mi", "fa", "sòl", "la", "si"], mayor: "major", menor: "menor")
        case .italiano:
            return ReglasDeIdioma(
                codigo: "it", nombrePropio: "Italiano", nombres: ["italiano"],
                naturales: silabas, mayor: "maggiore", menor: "minore")
        // En alemán la alteración va dentro del nombre (Fis, Eses), así que el separador no se usa.
        case .aleman:
            return ReglasDeIdioma(
                codigo: "de", nombrePropio: "Deutsch", nombres: ["aleman", "alemán", "deutsch"],
                naturales: ["C", "D", "E", "F", "G", "A", "H"], multiplicador: .unido,
                alteraciones: .alemana, tipografia: .ascii,
                mayor: "Dur", menor: "Moll", separadorDelModo: "-", menorEnMinuscula: true)
        case .griego:
            return ReglasDeIdioma(
                codigo: "el", nombrePropio: "Ελληνικά", nombres: ["griego", "ελληνικά"],
                naturales: ["ντο", "ρε", "μι", "φα", "σολ", "λα", "σι"], mayor: "μείζονα", menor: "ελάσσονα")
        case .ruso:
            return ReglasDeIdioma(
                codigo: "ru", nombrePropio: "Русский", nombres: ["ruso", "русский"],
                naturales: ["до", "ре", "ми", "фа", "соль", "ля", "си"], separador: "-",
                mayor: "мажор", menor: "минор")
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
