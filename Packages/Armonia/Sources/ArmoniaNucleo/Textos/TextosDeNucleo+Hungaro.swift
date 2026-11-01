// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en húngaro. Los campos y lo que significa cada uno están en
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

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "„\(simbolo)” nem ismert akkordjelzés része" },
        tensionNoValida: { tension in "„\(tension)” nem érvényes feszültséghang (a ♭ és a ♯ az 5, 9, 11 és 13 mellé, az add a 2, 4, 6, 9, 11 és 13 mellé kerülhet)" },
        numeroDeAcordeNoValido: { numero in "„\(numero)” nem akkordszám (5, 6, 7, 9, 11 vagy 13)" },
        numeroRepetido: { numero in "„\(numero)” egy másik szám után áll; a további hangok zárójelbe kerülnek, mint a 7(9)-ben" },
        disminuidoYSemidisminuido: "a szűkített (°) és a félszűkített (ø) nem kombinálható",
        quintaConCalidad: "a kvintakkordnak (5) nincs terce, ezért nem kaphat m, °, ø vagy + jelet",
        fundamentalNoOmitible: "az alaphang nem hagyható el",
        gradoNoOmitible: { grado in "„omit\(grado)” érvénytelen (a 3, 5, 7, 9, 11 és 13 hagyható el)" },
        faltaLaFundamental: "hiányzik az alaphang",
        intervaloSinPapel: { intervalo, notacion in "\(intervalo.nombre(en: notacion).conArticuloHungaro) nem tölt be szerepet egy tercépítkezésű akkordban" },
        terceraMayorYMenor: "egyszerre van benne nagy és kis terc (a ♯9 bővített nónaként íródik, nem kis tercként)",
        variasSeptimas: "egynél több szeptim van benne",
        septimaDisminuidaFueraDelDisminuido: "a szűkített szeptim csak a szűkített akkordban fordul elő (kis terccel és szűkített kvinttel)",
        noEsPorTerceras: "nem tercépítkezésű akkord",
        bajoNoValido: { bajo in "„\(bajo)” nem hangnév a basszus számára" },
        idiomasMezclados: { nombre in "„\(nombre)” más nyelven van írva, mint az alaphang: vagy minden szótagokkal (Sol7/Si), vagy minden betűkkel (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "„\(nombre)” nem hangnemi mód: a hangnem dúr vagy moll (a többi módhoz használd az Escala típust)" },
        faltaElTipoDeEscala: "hiányzik a skála típusa (dúr, dór, összhangzatos moll…)",
        tipoDeEscalaNoReconocido: { nombre in "„\(nombre)” nem ismert skálatípus" },

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

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "„\(texto)” nem időtartam: hangérték (1, 2, 4, 8, 16…, pontozva: 4.) vagy az egész hang törtrésze (3/8, 1/12) várható" },
        compasNoValido: { texto in "„\(texto)” nem ütemmutató: számláló/nevező várható, a nevező kettő hatványa (4/4, 6/8, 7/8), vagy C, illetve ¢" },
        vocesDistintas: "minden akkordnak ugyanannyi szólamból kell állnia, legalább kettőből",
        contrapuntoDeOtraDuracion: { redondas in "az ellenpontnak ugyanolyan hosszúnak kell lennie, mint a cantus firmusnak: \(redondas) egész hang, hangonként egy" },
        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["prím", "szekund", "terc", "kvart", "kvint", "szext", "szeptim", "oktáv", "nóna", "decima", "undecima", "duodecima", "tercdecima", "kvartdecima", "kettős oktáv"],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
