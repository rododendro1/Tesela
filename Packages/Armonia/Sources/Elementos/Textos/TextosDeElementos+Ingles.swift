// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en inglés. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let ingles = TextosDeElementos(
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

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "\"\(texto)\" is neither a pitch class (0 to 11, or t and e for 10 and 11) nor a note name" },
        numeroDeForteDesconocido: { texto in "\"\(texto)\" is not a Forte number (for example, 3-11 or 4-Z15)" },
        faltaElCierre: { signo in "the closing \"\(signo)\" is missing" },
        serieNoDodecafonica: "a twelve-tone row has all twelve pitch classes, each one once",
        faltanEnLaSerie: { clases in "missing \(clases)" },
        repetidasEnLaSerie: { clases in "repeated \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "\"\(n)\" is none of the twelve languages: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["unison", "second", "third", "fourth", "fifth", "sixth", "seventh", "octave", "ninth", "tenth", "eleventh", "twelfth", "thirteenth", "fourteenth", "double octave"],
        ordinalEnCifras: { n in Intervalo.ordinalInglesEnCifras(n) },
        dosPuntos: ": "
    )
}
