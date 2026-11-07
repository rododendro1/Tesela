// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaElementos en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let hungaro = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "tiszta",
        calidadMayor: "nagy",
        calidadMenor: "kis",
        calidadAumentada: "bővített",
        calidadDisminuida: "szűkített",
        multiplicidadSimple: "",
        multiplicidadDoble: "kétszeresen ",
        multiplicidadTriple: "háromszorosan ",
        multiplicidad: { n in "\(n)× " },
        plantillaDescendente: "lefelé _",
        consonanciaPerfecta: "tökéletes konszonancia",
        consonanciaImperfecta: "tökéletlen konszonancia",
        disonancia: "disszonancia",

        // Nota.swift
        palabraNatural: "feloldójel",
        palabraSostenido: "kereszt",
        palabraBemol: "bé",
        multiplicadores: ["kettős ", "hármas ", "négyes "],
        palabraSostenidos: "kereszt",
        palabraBemoles: "bé",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Érvénytelen érték",
        noSePuedeLeer: { texto in "„\(texto)” nem olvasható" },
        caracter: { p in " (\(p + 1). karakter)" },
        textoVacio: "a szöveg üres",
        caracteresSobrantes: { resto in "„\(resto)” fölösleges" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "hangnevet vártam (C, D, E… vagy Do, Re, Mi…)",
        faltaLaOctava: "hiányzik az oktáv (például C4)",
        octavaNoValida: { resto in "„\(resto)” nem érvényes oktáv" },
        faltaElNumeroDeIntervalo: "hiányzik a hangköz száma (például M3)",
        numeroDeIntervaloNoValido: { resto in "„\(resto)” nem hangközszám" },
        faltaLaCalidad: "hiányzik a hangköz minősége (P, M, m, A vagy d)",
        calidadNoValida: { resto in "„\(resto)” nem hangközminőség (P, M, m, A vagy d)" },
        unisonoDisminuido: "szűkített prím nincs: C-ből Cesz-be lefelé bővített prím vezet (írd így: -A1)",
        reglaDeLasJustas: "a prím, a kvart, a kvint és az oktáv tiszta, bővített vagy szűkített",
        reglaDeLasMayores: "a szekund, a terc, a szext és a szeptim nagy, kis, bővített vagy szűkített",
        intervaloInexistente: { numero, calidad, notacion, regla in "nincs \(calidad.nombre(en: notacion)) \(Intervalo.ordinal(numero, en: .hungaro)): \(regla.hungaro)" },
        alteracionNoReconocida: { signo in "„\(signo)” nem módosítójel (♯, ♭, 𝄪, 𝄫, #, b, x vagy ♮ várható)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "„\(texto)” nem hangmagasság-osztály (0-tól 11-ig, vagy t és e a 10-hez és a 11-hez), és nem is hangnév" },
        numeroDeForteDesconocido: { texto in "„\(texto)” nem Forte-szám (például 3-11 vagy 4-Z15)" },
        faltaElCierre: { signo in "hiányzik a záró „\(signo)”" },
        serieNoDodecafonica: "egy tizenkétfokú sorban mind a tizenkét hangmagasság-osztály megvan, mindegyik egyszer",
        faltanEnLaSerie: { clases in "hiányzik: \(clases)" },
        repetidasEnLaSerie: { clases in "ismétlődik: \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "„\(n)” egyik sem a tizenöt nyelv közül: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["prím", "szekund", "terc", "kvart", "kvint", "szext", "szeptim", "oktáv", "nóna", "decima", "undecima", "duodecima", "tercdecima", "kvartdecima", "kettős oktáv"],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
