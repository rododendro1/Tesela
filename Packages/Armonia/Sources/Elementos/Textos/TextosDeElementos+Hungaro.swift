// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en húngaro. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let hungaro = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "tiszta",
        calidadMayor: "nagy",
        calidadMenor: "kis",
        calidadAumentada: "bővített",
        calidadDisminuida: "szűkített",
        multiplicidadSimple: "",
        multiplicidadDoble: "kétszeresen ",
        multiplicidadTriple: "háromszorosan ",
        multiplicidad: "{1}× ",
        plantillaDescendente: "lefelé {1}",
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
        noSePuedeLeer: "„{1}” nem olvasható",
        caracter: { p in " (\(p + 1). karakter)" },
        textoVacio: "a szöveg üres",
        caracteresSobrantes: "„{1}” fölösleges",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "hangnevet vártam (C, D, E… vagy Do, Re, Mi…)",
        faltaLaOctava: "hiányzik az oktáv (például C4)",
        octavaNoValida: "„{1}” nem érvényes oktáv",
        faltaElNumeroDeIntervalo: "hiányzik a hangköz száma (például M3)",
        numeroDeIntervaloNoValido: "„{1}” nem hangközszám",
        faltaLaCalidad: "hiányzik a hangköz minősége (P, M, m, A vagy d)",
        calidadNoValida: "„{1}” nem hangközminőség (P, M, m, A vagy d)",
        unisonoDisminuido: "szűkített prím nincs: C-ből Cesz-be lefelé bővített prím vezet (írd így: -A1)",
        reglaDeLasJustas: "a prím, a kvart, a kvint és az oktáv tiszta, bővített vagy szűkített",
        reglaDeLasMayores: "a szekund, a terc, a szext és a szeptim nagy, kis, bővített vagy szűkített",
        intervaloInexistente: { numero, calidad, notacion, regla in "nincs \(calidad.nombre(en: notacion)) \(Intervalo.ordinal(numero, en: .hungaro)): \(regla.texto(en: .hungaro))" },
        alteracionNoReconocida: "„{1}” nem módosítójel (♯, ♭, 𝄪, 𝄫, #, b, x vagy ♮ várható)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "„{1}” nem hangmagasság-osztály (0-tól 11-ig, vagy t és e a 10-hez és a 11-hez), és nem is hangnév",
        numeroDeForteDesconocido: "„{1}” nem Forte-szám (például 3-11 vagy 4-Z15)",
        faltaElCierre: "hiányzik a záró „{1}”",
        serieNoDodecafonica: "egy tizenkétfokú sorban mind a tizenkét hangmagasság-osztály megvan, mindegyik egyszer",
        faltanEnLaSerie: "hiányzik: {1}",
        repetidasEnLaSerie: "ismétlődik: {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "„{1}” egyik sem a tizenhárom nyelv közül: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{1} {2}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["prím", "szekund", "terc", "kvart", "kvint", "szext", "szeptim", "oktáv", "nóna", "decima", "undecima", "duodecima", "tercdecima", "kvartdecima", "kettős oktáv"],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
