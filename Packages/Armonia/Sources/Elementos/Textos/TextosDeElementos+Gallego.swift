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
        multiplicidad: "{1} veces ",
        plantillaDescendente: "{1} descendente",
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
        noSePuedeLeer: "Non se pode ler «{1}»",
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "o texto está baleiro",
        caracteresSobrantes: "sobra «{1}»",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "agardábase un nome de nota (Do, Re, Mi… ou C, D, E…)",
        faltaLaOctava: "falta a oitava (por exemplo, Do4)",
        octavaNoValida: "«{1}» non é unha oitava válida",
        faltaElNumeroDeIntervalo: "falta o número do intervalo (por exemplo, 3M)",
        numeroDeIntervaloNoValido: "«{1}» non é un número de intervalo",
        faltaLaCalidad: "falta a calidade do intervalo (J, M, m, A ou d)",
        calidadNoValida: "«{1}» non é unha calidade de intervalo (J, M, m, A ou d)",
        unisonoDisminuido: "non existe o unísono diminuído: de Do a Do♭ hai un unísono aumentado descendente (escríbeo -1A)",
        reglaDeLasJustas: "o unísono, a 4ª, a 5ª e a 8ª son xustas, aumentadas ou diminuídas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª e a 7ª son maiores, menores, aumentadas ou diminuídas",
        intervaloInexistente: { numero, calidad, notacion, regla in "non existe a \(numero)ª \(calidad.nombre(en: .conPalabras(.gallego))): \(regla.texto(en: .gallego))" },
        alteracionNoReconocida: "«{1}» non é unha alteración (agardábase ♯, ♭, 𝄪, 𝄫, #, b, x ou ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» non é unha clase de altura (de 0 a 11, ou t e e para o 10 e o 11) nin un nome de nota",
        numeroDeForteDesconocido: "«{1}» non é un número de Forte (por exemplo, 3-11 ou 4-Z15)",
        faltaElCierre: "falta o «{1}» do final",
        serieNoDodecafonica: "unha serie dodecafónica ten as doce clases de altura, cada unha unha vez",
        faltanEnLaSerie: "faltan {1}",
        repetidasEnLaSerie: "repítense {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» non é ningún dos trece idiomas: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
