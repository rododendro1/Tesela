// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en español. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let espanol = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "disminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: "{1} veces ",
        plantillaDescendente: "{1} descendente",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "natural",
        palabraSostenido: "sostenido",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sostenidos",
        palabraBemoles: "bemoles",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor no válido",
        noSePuedeLeer: "No se puede leer «{1}»",
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "el texto está vacío",
        caracteresSobrantes: "sobra «{1}»",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "se esperaba un nombre de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta la octava (por ejemplo, Do4)",
        octavaNoValida: "«{1}» no es una octava válida",
        faltaElNumeroDeIntervalo: "falta el número del intervalo (por ejemplo, 3M)",
        numeroDeIntervaloNoValido: "«{1}» no es un número de intervalo",
        faltaLaCalidad: "falta la calidad del intervalo (J, M, m, A o d)",
        calidadNoValida: "«{1}» no es una calidad de intervalo (J, M, m, A o d)",
        unisonoDisminuido: "no existe el unísono disminuido: de Do a Do♭ hay un unísono aumentado descendente (escríbelo -1A)",
        reglaDeLasJustas: "el unísono, la 4ª, la 5ª y la 8ª son justas, aumentadas o disminuidas",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª y la 7ª son mayores, menores, aumentadas o disminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existe la \(numero)ª \(calidad.nombre): \(regla.texto(en: .espanol))" },
        alteracionNoReconocida: "«{1}» no es una alteración (se esperaba ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» no es una clase de altura (de 0 a 11, o t y e para el 10 y el 11) ni un nombre de nota",
        numeroDeForteDesconocido: "«{1}» no es un número de Forte (por ejemplo, 3-11 o 4-Z15)",
        faltaElCierre: "falta el «{1}» del final",
        serieNoDodecafonica: "una serie dodecafónica tiene las doce clases de altura, cada una una vez",
        faltanEnLaSerie: "faltan {1}",
        repetidasEnLaSerie: "se repiten {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» no es ninguno de los trece idiomas: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
