// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en sueco. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let sueco = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "ren",
        calidadMayor: "stor",
        calidadMenor: "liten",
        calidadAumentada: "överstigande",
        calidadDisminuida: "förminskad",
        multiplicidadSimple: "",
        multiplicidadDoble: "dubbelt ",
        multiplicidadTriple: "trefalt ",
        multiplicidad: { n in "\(n)-faldigt " },
        plantillaDescendente: "_ nedåt",
        consonanciaPerfecta: "fullkomlig konsonans",
        consonanciaImperfecta: "ofullkomlig konsonans",
        disonancia: "dissonans",

        // Nota.swift
        palabraNatural: "återställningstecken",
        palabraSostenido: "kors",
        palabraBemol: "b",
        multiplicadores: ["dubbel", "trippel", "fyrdubbel"],
        palabraSostenidos: "kors",
        palabraBemoles: "b",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Ogiltigt värde",
        noSePuedeLeer: { texto in "”\(texto)” kan inte läsas" },
        caracter: { p in " (tecken \(p + 1))" },
        textoVacio: "texten är tom",
        caracteresSobrantes: { resto in "”\(resto)” är för mycket" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "ett tonnamn väntades (C, D, E… eller Do, Re, Mi…)",
        faltaLaOctava: "oktaven saknas (till exempel C4)",
        octavaNoValida: { resto in "”\(resto)” är ingen giltig oktav" },
        faltaElNumeroDeIntervalo: "intervallets nummer saknas (till exempel M3)",
        numeroDeIntervaloNoValido: { resto in "”\(resto)” är inget intervallnummer" },
        faltaLaCalidad: "intervallets kvalitet saknas (P, M, m, A eller d)",
        calidadNoValida: { resto in "”\(resto)” är ingen intervallkvalitet (P, M, m, A eller d)" },
        unisonoDisminuido: "det finns ingen förminskad prim: från C till Cess är det en överstigande prim nedåt (skriv -A1)",
        reglaDeLasJustas: "prim, kvart, kvint och oktav är rena, överstigande eller förminskade",
        reglaDeLasMayores: "sekund, ters, sext och septima är stora, små, överstigande eller förminskade",
        intervaloInexistente: { numero, calidad, notacion, regla in "det finns ingen \(calidad.nombre(en: .conPalabras(.sueco))) \(Intervalo.ordinal(numero, en: .sueco)): \(regla.texto(en: .sueco))" },
        alteracionNoReconocida: { signo in "”\(signo)” är inget förtecken (♯, ♭, 𝄪, 𝄫, #, b, x eller ♮ väntades)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "”\(texto)” är varken en tonhöjdsklass (0 till 11, eller t och e för 10 och 11) eller ett tonnamn" },
        numeroDeForteDesconocido: { texto in "”\(texto)” är inget Forte-nummer (till exempel 3-11 eller 4-Z15)" },
        faltaElCierre: { signo in "det avslutande ”\(signo)” saknas" },
        serieNoDodecafonica: "en tolvtonsserie innehåller alla tolv tonhöjdsklasser, var och en exakt en gång",
        faltanEnLaSerie: { clases in "det saknas \(clases)" },
        repetidasEnLaSerie: { clases in "upprepade: \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "”\(n)” är inget av de tretton språken: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["prim", "sekund", "ters", "kvart", "kvint", "sext", "septima", "oktav", "nona", "decima", "undecima", "duodecima", "tredecima", "kvartdecima", "dubbeloktav"],
        ordinalEnCifras: { n in "\(n):e" },
        dosPuntos: ": "
    )
}
