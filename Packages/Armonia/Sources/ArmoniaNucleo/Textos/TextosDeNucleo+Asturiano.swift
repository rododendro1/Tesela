// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let asturiano = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "xusta",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "menguada",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegaes " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonancia perfeuta",
        consonanciaImperfecta: "consonancia imperfeuta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "becuadru",
        palabraSostenido: "sosteníu",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sosteníos",
        palabraBemoles: "bemoles",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor non válidu",
        noSePuedeLeer: { texto in "Nun se pue lleer «\(texto)»" },
        caracter: { p in " (caráuter \(p + 1))" },
        textoVacio: "el testu ta baleru",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "esperábase un nome de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta la octava (por exemplu, Do4)",
        octavaNoValida: { resto in "«\(resto)» nun ye una octava válida" },
        faltaElNumeroDeIntervalo: "falta\'l númberu del intervalu (por exemplu, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» nun ye un númberu d\'intervalu" },
        faltaLaCalidad: "falta la calidá del intervalu (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» nun ye una calidá d\'intervalu (J, M, m, A o d)" },
        unisonoDisminuido: "nun esiste l\'unísonu menguáu: de Do a Do♭ hai un unísonu aumentáu descendente (escríbilu -1A)",
        reglaDeLasJustas: "l\'unísonu, la 4ª, la 5ª y la 8ª son xustes, aumentaes o menguaes",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª y la 7ª son mayores, menores, aumentaes o menguaes",
        intervaloInexistente: { numero, calidad, notacion, regla in "nun esiste la \(numero)ª \(calidad.nombre(en: .asturianoPalabras)): \(regla.asturiano)" },
        alteracionNoReconocida: { signo in "«\(signo)» nun ye una alteración (esperábase ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "«\(texto)» nun ye una clase d'altura (de 0 a 11, o t y e pal 10 y l'11) nin un nome de nota" },
        numeroDeForteDesconocido: { texto in "«\(texto)» nun ye un númberu de Forte (por exemplu, 3-11 o 4-Z15)" },
        faltaElCierre: { signo in "falta'l «\(signo)» del final" },
        serieNoDodecafonica: "una serie dodecafónica tien les doce clases d'altura, cada una una vegada",
        faltanEnLaSerie: { clases in "falten \(clases)" },
        repetidasEnLaSerie: { clases in "repítense \(clases)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
