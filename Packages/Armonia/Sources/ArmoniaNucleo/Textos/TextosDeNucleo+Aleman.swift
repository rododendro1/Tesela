// Los textos de ArmoniaNucleo en alemán. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let aleman = TextosDeNucleo(
        // Intervalo+Idiomas.swift
        calidadJusta: "reine",
        calidadMayor: "große",
        calidadMenor: "kleine",
        calidadAumentada: "übermäßige",
        calidadDisminuida: "verminderte",
        multiplicidadSimple: "",
        multiplicidadDoble: "doppelt ",
        multiplicidadTriple: "dreifach ",
        multiplicidad: { n in "\(n)-fach " },
        plantillaDescendente: "_ abwärts",
        consonanciaPerfecta: "vollkommene Konsonanz",
        consonanciaImperfecta: "unvollkommene Konsonanz",
        disonancia: "Dissonanz",

        // Nota+Idiomas.swift
        palabraNatural: "Auflösungszeichen",
        palabraSostenido: "Kreuz",
        palabraBemol: "Be",
        multiplicadores: ["Doppel", "Dreifach", "Vierfach"],
        palabraSostenidos: "Kreuze",
        palabraBemoles: "Be",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "„\(simbolo)“ gehört zu keinem bekannten Akkordsymbol" },
        tensionNoValida: { tension in "„\(tension)“ ist keine gültige Tension (♭/♯ gehen mit 5, 9, 11 und 13, add mit 2, 4, 6, 9, 11 und 13)" },
        numeroDeAcordeNoValido: { numero in "„\(numero)“ ist keine Akkordzahl (5, 6, 7, 9, 11 oder 13)" },
        numeroRepetido: { numero in "„\(numero)“ steht nach einer anderen Zahl; weitere Optionen kommen in Klammern, wie in 7(9)" },
        disminuidoYSemidisminuido: "vermindert (°) und halbvermindert (ø) lassen sich nicht kombinieren",
        quintaConCalidad: "der Powerchord (5) hat keine Terz und erlaubt daher weder m noch °, ø oder +",
        fundamentalNoOmitible: "der Grundton kann nicht weggelassen werden",
        gradoNoOmitible: { grado in "„omit\(grado)“ ist ungültig (weglassen lassen sich 3, 5, 7, 9, 11 und 13)" },
        faltaLaFundamental: "der Grundton fehlt",
        intervaloSinPapel: { intervalo, notacion in "die \(intervalo.nombre(en: .aleman)) hat in einem Terzakkord keine Funktion" },
        terceraMayorYMenor: "er hat zugleich eine große und eine kleine Terz (♯9 wird als übermäßige None geschrieben, nicht als kleine Terz)",
        variasSeptimas: "er hat mehr als eine Septime",
        septimaDisminuidaFueraDelDisminuido: "die verminderte Septime kommt nur im verminderten Akkord vor (mit kleiner Terz und verminderter Quinte)",
        noEsPorTerceras: "es ist kein Terzakkord",
        bajoNoValido: { bajo in "„\(bajo)“ ist kein Notenname für den Bass" },
        idiomasMezclados: { nombre in "„\(nombre)“ ist in einer anderen Sprache geschrieben als der Grundton: entweder alles mit Silben (Sol7/Si) oder alles mit Buchstaben (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "„\(nombre)“ ist kein Tongeschlecht: eine Tonart ist Dur oder Moll (für die anderen Modi nimm Escala)" },
        faltaElTipoDeEscala: "die Skalenart fehlt (Dur, dorisch, harmonisch Moll…)",
        tipoDeEscalaNoReconocido: { nombre in "„\(nombre)“ ist keine bekannte Skalenart" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Ungültiger Wert",
        noSePuedeLeer: { texto in "„\(texto)“ kann nicht gelesen werden" },
        caracter: { p in " (Zeichen \(p + 1))" },
        textoVacio: "der Text ist leer",
        caracteresSobrantes: { resto in "„\(resto)“ ist zu viel" },

        // ErrorDeLectura+Notas.swift
        notaNoReconocida: "Notenname erwartet (C, D, E… oder Do, Re, Mi…)",
        faltaLaOctava: "die Oktave fehlt (zum Beispiel C4)",
        octavaNoValida: { resto in "„\(resto)“ ist keine gültige Oktave" },
        faltaElNumeroDeIntervalo: "die Intervallzahl fehlt (zum Beispiel M3)",
        numeroDeIntervaloNoValido: { resto in "„\(resto)“ ist keine Intervallzahl" },
        faltaLaCalidad: "die Intervallqualität fehlt (P, M, m, A oder d)",
        calidadNoValida: { resto in "„\(resto)“ ist keine Intervallqualität (P, M, m, A oder d)" },
        unisonoDisminuido: "eine verminderte Prime gibt es nicht: von C nach Ces ist es eine übermäßige Prime abwärts (schreib -A1)",
        reglaDeLasJustas: "Prime, Quarte, Quinte und Oktave sind rein, übermäßig oder vermindert",
        reglaDeLasMayores: "Sekunde, Terz, Sexte und Septime sind groß, klein, übermäßig oder vermindert",
        intervaloInexistente: { numero, calidad, notacion, regla in "es gibt keine \(calidad.nombre(en: .aleman)) \(Intervalo.ordinal(numero, en: .aleman)): \(regla.aleman)" },
        alteracionNoReconocida: { signo in "„\(signo)“ ist kein Vorzeichen (erwartet ♯, ♭, 𝄪, 𝄫, #, b, x oder ♮)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "„\(texto)“ ist keine Dauer: erwartet wurde ein Notenwert (1, 2, 4, 8, 16…, punktiert: 4.) oder ein Bruchteil der Ganzen (3/8, 1/12)" },
        compasNoValido: { texto in "„\(texto)“ ist keine Taktart: erwartet wurde Zähler/Nenner mit einer Zweierpotenz als Nenner (4/4, 6/8, 7/8), C oder ¢" },
        vocesDistintas: "alle Akkorde müssen gleich viele Stimmen haben, mindestens zwei",
        contrapuntoDeOtraDuracion: { redondas in "der Kontrapunkt muss so lange dauern wie der Cantus firmus: \(redondas) ganze Noten, eine pro Note" }
    )
}
