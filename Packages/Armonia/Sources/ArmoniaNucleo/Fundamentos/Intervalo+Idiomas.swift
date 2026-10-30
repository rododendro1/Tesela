// MARK: - Idiomas
//
// Las calidades de intervalo, los intervalos y las consonancias en los catorce idiomas de los textos
// (`Notacion.textos`). Las notas y las alteraciones, en `Nota+Idiomas.swift`.

// MARK: - CalidadDeIntervalo

extension CalidadDeIntervalo {
    public var nombre: String { nombre(en: .espanolUnicode) }

    /// "justa", "mayor"… en español; "perfect", "major", "doubly diminished"… en inglés; "reine", "große" en
    /// alemán; "чистая", "большая" en ruso. Van en femenino, como los intervalos.
    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .justa: return TextosDeNucleo.traducidos.map(\.calidadJusta).en(notacion)
        case .mayor: return TextosDeNucleo.traducidos.map(\.calidadMayor).en(notacion)
        case .menor: return TextosDeNucleo.traducidos.map(\.calidadMenor).en(notacion)
        case .aumentada(let n):
            return CalidadDeIntervalo.multiplicidad(n).en(notacion)
                + TextosDeNucleo.traducidos.map(\.calidadAumentada).en(notacion)
        case .disminuida(let n):
            return CalidadDeIntervalo.multiplicidad(n).en(notacion)
                + TextosDeNucleo.traducidos.map(\.calidadDisminuida).en(notacion)
        }
    }

    private static func multiplicidad(_ n: Int) -> Traduccion {
        switch n {
        case 1: return TextosDeNucleo.traducidos.map(\.multiplicidadSimple)
        case 2: return TextosDeNucleo.traducidos.map(\.multiplicidadDoble)
        case 3: return TextosDeNucleo.traducidos.map(\.multiplicidadTriple)
        default: return TextosDeNucleo.traducidos.map { $0.multiplicidad(n) }
        }
    }
}

// MARK: - Intervalo

extension Intervalo {
    /// "3ª mayor", "5ª justa descendente".
    public var nombre: String { nombre(en: .espanolUnicode) }

    /// "3ª mayor" en español; "major third", "descending minor sixth" en inglés; "3a major" en catalán;
    /// "beheranzko 6. txikia" en euskera; "tierce majeure" en francés; "große Terz" en alemán; "большая терция"
    /// en ruso.
    public func nombre(en notacion: Notacion) -> String {
        let idioma = notacion.textos
        let ordinal = Intervalo.ordinal(numero, en: idioma)
        var calidad = self.calidad.nombre(en: notacion)
        if numero == 1 { calidad = Intervalo.enMasculino(calidad, en: idioma) }
        let nombre: String
        switch idioma {
        case .ingles, .aleman, .griego, .ruso:
            nombre = "\(calidad) \(ordinal)"
        case .espanol, .catalan, .gallego, .asturiano, .aragones, .euskera, .portugues, .frances, .occitano,
             .italiano:
            nombre = "\(ordinal) \(calidad)"
        }
        return sentido == .descendente ? Intervalo.plantillaDescendente.en(notacion).rellenada(con: nombre) : nombre
    }

    /// Dónde va «descendente» en cada idioma: delante o detrás del nombre (`_`).
    private static let plantillaDescendente = TextosDeNucleo.traducidos.map(\.plantillaDescendente)

    /// La calidad en masculino, para el unísono, en los idiomas que lo nombran con una palabra masculina:
    /// "unisson augmenté", "unisono aumentato", "unisson aumentat". En los demás, igual.
    private static func enMasculino(_ calidad: String, en idioma: Idioma) -> String {
        switch idioma {
        case .frances:
            return calidad.hasSuffix("ée") ? String(calidad.dropLast()) : calidad
        case .italiano:
            return calidad.hasSuffix("a") ? String(calidad.dropLast()) + "o" : calidad
        case .occitano:
            if calidad.hasSuffix("ada") { return String(calidad.dropLast(3)) + "at" }
            if calidad.hasSuffix("ida") { return String(calidad.dropLast(3)) + "it" }
            if calidad.hasSuffix("a") { return String(calidad.dropLast()) }
            return calidad
        case .espanol, .ingles, .catalan, .gallego, .asturiano, .aragones, .euskera, .portugues, .aleman, .griego,
             .ruso:
            return calidad
        }
    }

    /// El nombre del n-ésimo intervalo: "third", "tierce", "Terz", "терция"… hasta la doble octava, y después en
    /// cifras ("16th", "16e"). En los idiomas que escriben los intervalos con número, en cifras: "3ª", "3a", "3.".
    package static func ordinal(_ n: Int, en idioma: Idioma) -> String {
        if let nombres = ordinales[idioma], (1...nombres.count).contains(n) { return nombres[n - 1] }
        return ordinalEnCifras(n, en: idioma)
    }

    /// "1ª", "21st", "16e", "16.", "16-я", "16η"…
    package static func ordinalEnCifras(_ n: Int, en idioma: Idioma) -> String {
        switch idioma {
        case .ingles:
            let sufijo: String
            switch (n % 100, n % 10) {
            case (11...13, _): sufijo = "th"
            case (_, 1): sufijo = "st"
            case (_, 2): sufijo = "nd"
            case (_, 3): sufijo = "rd"
            default: sufijo = "th"
            }
            return "\(n)\(sufijo)"
        case .frances: return "\(n)e"
        case .euskera, .aleman: return "\(n)."
        case .griego: return "\(n)η"
        case .ruso: return "\(n)-я"
        case .catalan, .occitano: return "\(n)a"
        case .espanol, .gallego, .asturiano, .aragones, .portugues, .italiano: return "\(n)ª"
        }
    }

    /// Los nombres de los intervalos del unísono a la doble octava, en los idiomas que los nombran con palabras.
    /// Todos son femeninos, como sus calidades, salvo el unísono en francés, occitano y italiano.
    private static let ordinales: [Idioma: [String]] = [
        .ingles: ["unison", "second", "third", "fourth", "fifth", "sixth", "seventh", "octave", "ninth", "tenth",
                  "eleventh", "twelfth", "thirteenth", "fourteenth", "double octave"],
        .frances: ["unisson", "seconde", "tierce", "quarte", "quinte", "sixte", "septième", "octave", "neuvième",
                   "dixième", "onzième", "douzième", "treizième", "quatorzième", "double octave"],
        .italiano: ["unisono", "seconda", "terza", "quarta", "quinta", "sesta", "settima", "ottava", "nona",
                    "decima", "undicesima", "dodicesima", "tredicesima", "quattordicesima", "doppia ottava"],
        .aleman: ["Prime", "Sekunde", "Terz", "Quarte", "Quinte", "Sexte", "Septime", "Oktave", "None", "Dezime",
                  "Undezime", "Duodezime", "Tredezime", "Quartdezime", "Doppeloktave"],
        .occitano: ["unisson", "segonda", "tèrça", "quarta", "quinta", "sexta", "setena", "octava", "novena",
                    "desena", "onzena", "dotzena", "tretzena", "catorzena", "doble octava"],
        .ruso: ["прима", "секунда", "терция", "кварта", "квинта", "секста", "септима", "октава", "нона", "децима",
                "ундецима", "дуодецима", "терцдецима", "квартдецима", "двойная октава"],
        .griego: ["πρώτη", "δεύτερη", "τρίτη", "τέταρτη", "πέμπτη", "έκτη", "έβδομη", "όγδοη", "ένατη", "δέκατη",
                  "ενδέκατη", "δωδέκατη", "δέκατη τρίτη", "δέκατη τέταρτη", "διπλή όγδοη"],
    ]
}

// MARK: - Consonancia

extension Consonancia {
    public var nombre: String { nombre(en: .espanolUnicode) }

    public func nombre(en notacion: Notacion) -> String {
        switch self {
        case .perfecta:
            return TextosDeNucleo.traducidos.map(\.consonanciaPerfecta).en(notacion)
        case .imperfecta:
            return TextosDeNucleo.traducidos.map(\.consonanciaImperfecta).en(notacion)
        case .disonancia:
            return TextosDeNucleo.traducidos.map(\.disonancia).en(notacion)
        }
    }
}
