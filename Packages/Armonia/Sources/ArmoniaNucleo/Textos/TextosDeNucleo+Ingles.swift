// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en inglés. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let ingles = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "perfect",
        calidadMayor: "major",
        calidadMenor: "minor",
        calidadAumentada: "augmented",
        calidadDisminuida: "diminished",
        multiplicidadSimple: "",
        multiplicidadDoble: "doubly ",
        multiplicidadTriple: "triply ",
        multiplicidad: { n in "\(n)× " },
        plantillaDescendente: "descending _",
        consonanciaPerfecta: "perfect consonance",
        consonanciaImperfecta: "imperfect consonance",
        disonancia: "dissonance",

        // Nota.swift
        palabraNatural: "natural",
        palabraSostenido: "sharp",
        palabraBemol: "flat",
        multiplicadores: ["double ", "triple ", "quadruple "],
        palabraSostenidos: "sharps",
        palabraBemoles: "flats",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "\"\(simbolo)\" is not part of any known chord symbol" },
        tensionNoValida: { tension in "\"\(tension)\" is not a valid tension (♭/♯ go with 5, 9, 11 and 13, and add with 2, 4, 6, 9, 11 and 13)" },
        numeroDeAcordeNoValido: { numero in "\"\(numero)\" is not a chord number (5, 6, 7, 9, 11 or 13)" },
        numeroRepetido: { numero in "\"\(numero)\" comes after another number; additional tensions go in parentheses, as in 7(9)" },
        disminuidoYSemidisminuido: "diminished (°) and half-diminished (ø) cannot be combined",
        quintaConCalidad: "a power chord (5) has no third, so it cannot take m, °, ø or +",
        fundamentalNoOmitible: "the root cannot be omitted",
        gradoNoOmitible: { grado in "\"omit\(grado)\" is not valid (3, 5, 7, 9, 11 and 13 can be omitted)" },
        faltaLaFundamental: "the root is missing",
        intervaloSinPapel: { intervalo, notacion in "the \(intervalo.nombre(en: notacion)) has no role in a tertian chord" },
        terceraMayorYMenor: "it has both a major and a minor third (♯9 is written as an augmented 9th, not a minor 3rd)",
        variasSeptimas: "it has more than one seventh",
        septimaDisminuidaFueraDelDisminuido: "the diminished seventh only appears in the diminished chord (with a minor 3rd and a diminished 5th)",
        noEsPorTerceras: "it is not a tertian chord",
        bajoNoValido: { bajo in "\"\(bajo)\" is not a note name for the bass" },
        idiomasMezclados: { nombre in "\"\(nombre)\" is written in a different language from the root: write everything with letters (G7/B) or everything in Spanish (Sol7/Si)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "\"\(nombre)\" is not the mode of a key: a key is major or minor (for other modes, use Escala)" },
        faltaElTipoDeEscala: "the scale type is missing (major, dorian, harmonic minor…)",
        tipoDeEscalaNoReconocido: { nombre in "\"\(nombre)\" is not a known scale type" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Invalid value",
        noSePuedeLeer: { texto in "Cannot read \"\(texto)\"" },
        caracter: { p in " (character \(p + 1))" },
        textoVacio: "the text is empty",
        caracteresSobrantes: { resto in "unexpected \"\(resto)\"" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "expected a note name (C, D, E… or Do, Re, Mi…)",
        faltaLaOctava: "the octave is missing (for example, C4)",
        octavaNoValida: { resto in "\"\(resto)\" is not a valid octave" },
        faltaElNumeroDeIntervalo: "the interval number is missing (for example, M3)",
        numeroDeIntervaloNoValido: { resto in "\"\(resto)\" is not an interval number" },
        faltaLaCalidad: "the interval quality is missing (P, M, m, A or d)",
        calidadNoValida: { resto in "\"\(resto)\" is not an interval quality (P, M, m, A or d)" },
        unisonoDisminuido: "there is no diminished unison: from C to C♭ is a descending augmented unison (write it -A1)",
        reglaDeLasJustas: "unisons, 4ths, 5ths and octaves are perfect, augmented or diminished",
        reglaDeLasMayores: "2nds, 3rds, 6ths and 7ths are major, minor, augmented or diminished",
        intervaloInexistente: { numero, calidad, notacion, regla in "there is no \(calidad.nombre(en: notacion)) \(Intervalo.ordinalEnCifras(numero, en: .ingles)): \(regla.ingles)" },
        alteracionNoReconocida: { signo in "\"\(signo)\" is not an accidental (expected ♯, ♭, 𝄪, 𝄫, #, b, x or ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "\"\(texto)\" is not a duration: expected a note value (1, 2, 4, 8, 16…, dotted: 4.) or a fraction of a whole note (3/8, 1/12)" },
        compasNoValido: { texto in "\"\(texto)\" is not a time signature: expected numerator/denominator with a power-of-2 denominator (4/4, 6/8, 7/8), C or ¢" },
        vocesDistintas: "every chord must have the same number of voices, and at least two",
        contrapuntoDeOtraDuracion: { redondas in "the counterpoint must last as long as the cantus firmus: \(redondas) whole notes, one per note" },
        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["unison", "second", "third", "fourth", "fifth", "sixth", "seventh", "octave", "ninth", "tenth", "eleventh", "twelfth", "thirteenth", "fourteenth", "double octave"],
        ordinalEnCifras: { n in Intervalo.ordinalInglesEnCifras(n) },
        dosPuntos: ": "
    )
}
