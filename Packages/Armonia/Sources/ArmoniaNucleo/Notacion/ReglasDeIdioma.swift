// MARK: - Reglas de cada idioma
//
// Lo que cambia de un idioma a otro y no es una traducción: su código y cómo se llama, las sílabas (o las
// letras) de las notas, lo que va entre el nombre y la alteración en palabras, dónde se pone «doble»,
// «triple» o «cuádruple», cómo se nombran los modos de una tonalidad, qué abreviaturas de intervalo usa y cómo
// forma el plural. Están aquí como datos, en un solo `switch`, para que añadir un idioma sea añadir una fila y no
// repasar los `switch` de `NotaNatural`, `Nota`, `Altura`, `Alteracion`, `Tonalidad` y `Notacion`. Las filas se
// calculan una sola vez (`Idioma.reglas` las lee de una tabla).

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

    /// Qué forma del nombre va con cada número: «1 semitono», «3 semitonos»; «1 полутон», «3 полутона»,
    /// «5 полутонов».
    public enum Plural: Hashable, Sendable {
        /// Singular con 1 y plural con los demás, también con 0: «0 semitonos» (español, inglés, alemán…).
        case unoYLosDemas
        /// Singular con 0 y 1, y plural desde 2: «0 demi-ton», «1 demi-ton», «2 demi-tons» (francés).
        case ceroYUno
        /// Una sola forma con cualquier número: «1 tonuerdi», «5 tonuerdi» (euskera).
        case invariable
        /// Tres formas, según en qué acabe el número: «1, 21… полутон», «2–4, 22–24… полутона», «0, 5–20,
        /// 25… полутонов» (ruso).
        case eslavo

        /// Cuál de las formas va con `n`: 0 es el singular, 1 el plural y, en `.eslavo`, 2 el plural de
        /// «muchos».
        public func forma(para n: Int) -> Int {
            let n = abs(n)
            switch self {
            case .unoYLosDemas: return n == 1 ? 0 : 1
            case .ceroYUno: return n <= 1 ? 0 : 1
            case .invariable: return 0
            case .eslavo:
                let (decena, unidad) = (n % 100, n % 10)
                if (11...14).contains(decena) { return 2 }
                switch unidad {
                case 1: return 0
                case 2...4: return 1
                default: return 2
                }
            }
        }

        /// El número con la forma que le toca: `Plural.unoYLosDemas.contar(3, ["semitono", "semitonos"])` es
        /// «3 semitonos». Se dan tantas formas como use la regla (una, dos o tres); si faltan, vale la última.
        public func contar(_ n: Int, _ formas: [String]) -> String {
            guard let ultima = formas.last else { return String(n) }
            let indice = forma(para: n)
            return "\(n) \(indice < formas.count ? formas[indice] : ultima)"
        }
    }

    /// El código ISO 639 del idioma: «es», «ast», «eu».
    public let codigo: String
    /// Cómo se llama el idioma en el propio idioma: «Euskara», «Deutsch», «Ελληνικά».
    public let nombrePropio: String
    /// Cómo se escribe el nombre del idioma, en minúsculas: en español y en el propio idioma («alemán»,
    /// «deutsch»). `Idioma(nombre:)` los compara sin tildes, así que no hace falta repetirlos sin ellas, y si los dos
    /// solo se distinguen por las tildes («portugués», «português») basta con uno. La ñ sí cuenta, y por eso el
    /// español lleva también «espanol».
    public let nombres: [String]
    /// Los siete naturales, de Do a Si, como se escriben en el texto: «do», «C», «ντο», «соль».
    public let naturales: [String]
    /// Entre el nombre y la alteración en palabras: " " en casi todos, "-" en ruso.
    public let separador: String
    /// Dónde va «doble» en las alteraciones dobles: delante («doble bemol»), detrás («bemol bikoitza») o unido
    /// («Doppelkreuz»).
    public let multiplicador: Multiplicador
    /// Cómo escribe las alteraciones cuando no se piden con palabras: con signos en español e inglés
    /// (que por eso tienen tres escrituras), a la alemana en alemán (que tiene dos: con palabras y compacta) y con
    /// palabras en los demás.
    public let alteraciones: EscrituraDeLaAlteracion
    /// Los signos de sus cifrados: # y b en alemán, ♯ y ♭ en los demás. En español e inglés lo elige la
    /// escritura, porque tienen las dos.
    public let tipografia: Tipografia
    /// El modo mayor de una tonalidad: «mayor», «Dur», «maiorra».
    public let mayor: String
    /// El modo menor de una tonalidad: «menor», «Moll», «minorra».
    public let menor: String
    /// Entre la tónica y el modo: " " en casi todos, "-" en alemán (C-Dur).
    public let separadorDelModo: String
    /// Si la tónica de una tonalidad menor va en minúscula, como en alemán (a-Moll).
    public let menorEnMinuscula: Bool
    /// El idioma de las abreviaturas de los intervalos (5J, P5), que solo están en español e inglés: el español
    /// en los idiomas de la península (también el portugués y el euskera) y en occitano, el inglés en los demás.
    public let abreviaturas: Idioma
    /// Cómo forma el plural: «1 semitono, 3 semitonos», «0 demi-ton», «5 tonuerdi», «5 полутонов».
    public let plural: Plural

    /// Los datos de un idioma. Los que llevan valor por omisión son los de la mayoría.
    public init(
        codigo: String, nombrePropio: String, nombres: [String],
        naturales: [String], separador: String = " ", multiplicador: Multiplicador = .delante,
        alteraciones: EscrituraDeLaAlteracion = .palabras, tipografia: Tipografia = .unicode,
        mayor: String, menor: String, separadorDelModo: String = " ", menorEnMinuscula: Bool = false,
        abreviaturas: Idioma = .ingles, plural: Plural = .unoYLosDemas
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
        self.abreviaturas = abreviaturas
        self.plural = plural
    }

    /// Si el idioma tiene las tres escrituras (palabras, ASCII y compacta), como el español y el inglés.
    public var tieneVariantes: Bool { alteraciones == .signos }
}

extension Idioma {
    /// Los datos de este idioma, calculados una sola vez: se leen en cada nombre de nota.
    public var reglas: ReglasDeIdioma { Self.tablaDeReglas.texto(en: self) }

    /// El número con la forma del nombre que le toca en este idioma: `Idioma.ruso.contar(5, "полутон",
    /// "полутона", "полутонов")` es «5 полутонов», y `Idioma.espanol.contar(1, "dedo", "dedos")`, «1 dedo».
    public func contar(_ n: Int, _ formas: String...) -> String { reglas.plural.contar(n, formas) }

    private static let tablaDeReglas = Traducido<ReglasDeIdioma>(porIdioma: { $0.reglasCalculadas })

    /// Las filas de cada idioma. Es el único `switch` sobre `Idioma` de sus datos y de los nombres de nota: un
    /// idioma nuevo solo tiene que añadir aquí su fila.
    private var reglasCalculadas: ReglasDeIdioma {
        let silabas = ["do", "re", "mi", "fa", "sol", "la", "si"]
        switch self {
        case .espanol:
            return ReglasDeIdioma(
                codigo: "es", nombrePropio: "Español", nombres: ["español", "espanol", "castellano"],
                naturales: ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si"], alteraciones: .signos,
                mayor: "mayor", menor: "menor", abreviaturas: .espanol)
        case .ingles:
            return ReglasDeIdioma(
                codigo: "en", nombrePropio: "English", nombres: ["inglés", "english"],
                naturales: ["C", "D", "E", "F", "G", "A", "B"], alteraciones: .signos,
                mayor: "major", menor: "minor")
        case .catalan:
            return ReglasDeIdioma(
                codigo: "ca", nombrePropio: "Català", nombres: ["catalán", "català"],
                naturales: silabas, mayor: "major", menor: "menor", abreviaturas: .espanol)
        case .gallego:
            return ReglasDeIdioma(
                codigo: "gl", nombrePropio: "Galego", nombres: ["gallego", "galego"],
                naturales: silabas, mayor: "maior", menor: "menor", abreviaturas: .espanol)
        case .asturiano:
            return ReglasDeIdioma(
                codigo: "ast", nombrePropio: "Asturianu", nombres: ["asturiano", "asturianu"],
                naturales: silabas, mayor: "mayor", menor: "menor", abreviaturas: .espanol)
        case .aragones:
            return ReglasDeIdioma(
                codigo: "an", nombrePropio: "Aragonés", nombres: ["aragonés"],
                naturales: silabas, mayor: "mayor", menor: "menor", abreviaturas: .espanol)
        case .euskera:
            return ReglasDeIdioma(
                codigo: "eu", nombrePropio: "Euskara", nombres: ["euskera", "euskara"],
                naturales: silabas, multiplicador: .detras, mayor: "maiorra", menor: "minorra",
                abreviaturas: .espanol, plural: .invariable)
        case .portugues:
            return ReglasDeIdioma(
                codigo: "pt", nombrePropio: "Português", nombres: ["português"],
                naturales: ["dó", "ré", "mi", "fá", "sol", "lá", "si"], mayor: "maior", menor: "menor",
                abreviaturas: .espanol)
        case .frances:
            return ReglasDeIdioma(
                codigo: "fr", nombrePropio: "Français", nombres: ["francés", "français"],
                naturales: ["do", "ré", "mi", "fa", "sol", "la", "si"], mayor: "majeur", menor: "mineur",
                plural: .ceroYUno)
        case .occitano:
            return ReglasDeIdioma(
                codigo: "oc", nombrePropio: "Occitan", nombres: ["occitano", "occitan"],
                naturales: ["do", "re", "mi", "fa", "sòl", "la", "si"], mayor: "major", menor: "menor",
                abreviaturas: .espanol)
        case .italiano:
            return ReglasDeIdioma(
                codigo: "it", nombrePropio: "Italiano", nombres: ["italiano"],
                naturales: silabas, mayor: "maggiore", menor: "minore")
        // En alemán la alteración va dentro del nombre (Fis, Eses), así que el separador no se usa.
        case .aleman:
            return ReglasDeIdioma(
                codigo: "de", nombrePropio: "Deutsch", nombres: ["alemán", "deutsch"],
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
                mayor: "мажор", menor: "минор", plural: .eslavo)
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
