// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en catalán. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let catalan = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "major",
        calidadMenor: "menor",
        calidadAumentada: "augmentada",
        calidadDisminuida: "disminuïda",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegades " },
        plantillaDescendente: "_ descendent",
        consonanciaPerfecta: "consonància perfecta",
        consonanciaImperfecta: "consonància imperfecta",
        disonancia: "dissonància",

        // Nota.swift
        palabraNatural: "becaire",
        palabraSostenido: "sostingut",
        palabraBemol: "bemoll",
        multiplicadores: ["doble ", "triple ", "quàdruple "],
        palabraSostenidos: "sostinguts",
        palabraBemoles: "bemolls",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor no vàlid",
        noSePuedeLeer: { texto in "No es pot llegir «\(texto)»" },
        caracter: { p in " (caràcter \(p + 1))" },
        textoVacio: "el text és buit",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "s'esperava un nom de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta l'octava (per exemple, Do4)",
        octavaNoValida: { resto in "«\(resto)» no és una octava vàlida" },
        faltaElNumeroDeIntervalo: "falta el número de l'interval (per exemple, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no és un número d'interval" },
        faltaLaCalidad: "falta la qualitat de l'interval (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» no és una qualitat d'interval (J, M, m, A o d)" },
        unisonoDisminuido: "no existeix l'uníson disminuït: de Do a Do♭ hi ha un uníson augmentat descendent (escriu-lo -1A)",
        reglaDeLasJustas: "l'uníson, la 4a, la 5a i la 8a són justes, augmentades o disminuïdes",
        reglaDeLasMayores: "la 2a, la 3a, la 6a i la 7a són majors, menors, augmentades o disminuïdes",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existeix la \(numero)a \(calidad.nombre(en: .conPalabras(.catalan))): \(regla.catalan)" },
        alteracionNoReconocida: { signo in "«\(signo)» no és una alteració (s'esperava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "«\(texto)» no és una classe d'altura (de 0 a 11, o t i e per al 10 i l'11) ni un nom de nota" },
        numeroDeForteDesconocido: { texto in "«\(texto)» no és un nombre de Forte (per exemple, 3-11 o 4-Z15)" },
        faltaElCierre: { signo in "falta el «\(signo)» del final" },
        serieNoDodecafonica: "una sèrie dodecafònica té les dotze classes d'altura, cadascuna una vegada",
        faltanEnLaSerie: { clases in "falten \(clases)" },
        repetidasEnLaSerie: { clases in "es repeteixen \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "«\(n)» no és cap dels quinze idiomes: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)a" },
        dosPuntos: ": "
    )
}
