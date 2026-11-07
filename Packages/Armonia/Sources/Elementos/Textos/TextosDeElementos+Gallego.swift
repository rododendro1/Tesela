// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en gallego. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let gallego = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "xusta",
        calidadMayor: "maior",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "diminuída",
        multiplicidadSimple: "",
        multiplicidadDoble: "dobre ",
        multiplicidadTriple: "tripla ",
        multiplicidad: { n in "\(n) veces " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "becadro",
        palabraSostenido: "sostido",
        palabraBemol: "bemol",
        multiplicadores: ["dobre ", "triplo ", "cuádruplo "],
        palabraSostenidos: "sostidos",
        palabraBemoles: "bemois",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor non válido",
        noSePuedeLeer: { texto in "Non se pode ler «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "o texto está baleiro",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "agardábase un nome de nota (Do, Re, Mi… ou C, D, E…)",
        faltaLaOctava: "falta a oitava (por exemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» non é unha oitava válida" },
        faltaElNumeroDeIntervalo: "falta o número do intervalo (por exemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» non é un número de intervalo" },
        faltaLaCalidad: "falta a calidade do intervalo (J, M, m, A ou d)",
        calidadNoValida: { resto in "«\(resto)» non é unha calidade de intervalo (J, M, m, A ou d)" },
        unisonoDisminuido: "non existe o unísono diminuído: de Do a Do♭ hai un unísono aumentado descendente (escríbeo -1A)",
        reglaDeLasJustas: "o unísono, a 4ª, a 5ª e a 8ª son xustas, aumentadas ou diminuídas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª e a 7ª son maiores, menores, aumentadas ou diminuídas",
        intervaloInexistente: { numero, calidad, notacion, regla in "non existe a \(numero)ª \(calidad.nombre(en: .conPalabras(.gallego))): \(regla.gallego)" },
        alteracionNoReconocida: { signo in "«\(signo)» non é unha alteración (agardábase ♯, ♭, 𝄪, 𝄫, #, b, x ou ♮)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "«\(texto)» non é unha clase de altura (de 0 a 11, ou t e e para o 10 e o 11) nin un nome de nota" },
        numeroDeForteDesconocido: { texto in "«\(texto)» non é un número de Forte (por exemplo, 3-11 ou 4-Z15)" },
        faltaElCierre: { signo in "falta o «\(signo)» do final" },
        serieNoDodecafonica: "unha serie dodecafónica ten as doce clases de altura, cada unha unha vez",
        faltanEnLaSerie: { clases in "faltan \(clases)" },
        repetidasEnLaSerie: { clases in "repítense \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "«\(n)» non é ningún dos doce idiomas: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
