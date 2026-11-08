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
        multiplicidad: "{1}-faldigt ",
        plantillaDescendente: "{1} nedåt",
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
        noSePuedeLeer: "”{1}” kan inte läsas",
        caracter: { p in " (tecken \(p + 1))" },
        textoVacio: "texten är tom",
        caracteresSobrantes: "”{1}” är för mycket",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "ett tonnamn väntades (C, D, E… eller Do, Re, Mi…)",
        faltaLaOctava: "oktaven saknas (till exempel C4)",
        octavaNoValida: "”{1}” är ingen giltig oktav",
        faltaElNumeroDeIntervalo: "intervallets nummer saknas (till exempel M3)",
        numeroDeIntervaloNoValido: "”{1}” är inget intervallnummer",
        faltaLaCalidad: "intervallets kvalitet saknas (P, M, m, A eller d)",
        calidadNoValida: "”{1}” är ingen intervallkvalitet (P, M, m, A eller d)",
        unisonoDisminuido: "det finns ingen förminskad prim: från C till Cess är det en överstigande prim nedåt (skriv -A1)",
        reglaDeLasJustas: "prim, kvart, kvint och oktav är rena, överstigande eller förminskade",
        reglaDeLasMayores: "sekund, ters, sext och septima är stora, små, överstigande eller förminskade",
        intervaloInexistente: { numero, calidad, notacion, regla in "det finns ingen \(calidad.nombre(en: .conPalabras(.sueco))) \(Intervalo.ordinal(numero, en: .sueco)): \(regla.texto(en: .sueco))" },
        alteracionNoReconocida: "”{1}” är inget förtecken (♯, ♭, 𝄪, 𝄫, #, b, x eller ♮ väntades)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "”{1}” är varken en tonhöjdsklass (0 till 11, eller t och e för 10 och 11) eller ett tonnamn",
        numeroDeForteDesconocido: "”{1}” är inget Forte-nummer (till exempel 3-11 eller 4-Z15)",
        faltaElCierre: "det avslutande ”{1}” saknas",
        serieNoDodecafonica: "en tolvtonsserie innehåller alla tolv tonhöjdsklasser, var och en exakt en gång",
        faltanEnLaSerie: "det saknas {1}",
        repetidasEnLaSerie: "upprepade: {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "”{1}” är inget av de tretton språken: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{1} {2}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["prim", "sekund", "ters", "kvart", "kvint", "sext", "septima", "oktav", "nona", "decima", "undecima", "duodecima", "tredecima", "kvartdecima", "dubbeloktav"],
        ordinalEnCifras: { n in "\(n):e" },
        dosPuntos: ": "
    )
}
