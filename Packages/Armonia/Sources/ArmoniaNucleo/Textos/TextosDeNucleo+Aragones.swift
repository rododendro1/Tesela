// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let aragones = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "chusta",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "disminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegadas " },
        plantillaDescendente: "_ descendent",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "becuadro",
        palabraSostenido: "sosteniu",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sostenius",
        palabraBemoles: "bemols",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor no válido",
        noSePuedeLeer: { texto in "No se puede leyer «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "o texto ye vuedo",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "s\'asperaba un nombre de nota (Do, Re, Mi… u C, D, E…)",
        faltaLaOctava: "falta a octava (per eixemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» no ye una octava válida" },
        faltaElNumeroDeIntervalo: "falta o número de l\'intervalo (per eixemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no ye un número d\'intervalo" },
        faltaLaCalidad: "falta a calidat de l\'intervalo (J, M, m, A u d)",
        calidadNoValida: { resto in "«\(resto)» no ye una calidat d\'intervalo (J, M, m, A u d)" },
        unisonoDisminuido: "no existe l\'unísono disminuiu: de Do a Do♭ bi ha un unísono aumentau descendent (escribe-lo -1A)",
        reglaDeLasJustas: "l\'unísono, a 4ª, a 5ª y a 8ª son chustas, aumentadas u disminuidas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª y a 7ª son mayors, menors, aumentadas u disminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existe a \(numero)ª \(calidad.nombre(en: .aragonesPalabras)): \(regla.aragones)" },
        alteracionNoReconocida: { signo in "«\(signo)» no ye una alteración (s\'asperaba ♯, ♭, 𝄪, 𝄫, #, b, x u ♮)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
