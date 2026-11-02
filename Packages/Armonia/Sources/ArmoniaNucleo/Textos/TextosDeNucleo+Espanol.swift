// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en español. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let espanol = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "disminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) veces " },
        plantillaDescendente: "_ descendente",
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
        noSePuedeLeer: { texto in "No se puede leer «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "el texto está vacío",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "se esperaba un nombre de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta la octava (por ejemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» no es una octava válida" },
        faltaElNumeroDeIntervalo: "falta el número del intervalo (por ejemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no es un número de intervalo" },
        faltaLaCalidad: "falta la calidad del intervalo (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» no es una calidad de intervalo (J, M, m, A o d)" },
        unisonoDisminuido: "no existe el unísono disminuido: de Do a Do♭ hay un unísono aumentado descendente (escríbelo -1A)",
        reglaDeLasJustas: "el unísono, la 4ª, la 5ª y la 8ª son justas, aumentadas o disminuidas",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª y la 7ª son mayores, menores, aumentadas o disminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existe la \(numero)ª \(calidad.nombre): \(regla.espanol)" },
        alteracionNoReconocida: { signo in "«\(signo)» no es una alteración (se esperaba ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
