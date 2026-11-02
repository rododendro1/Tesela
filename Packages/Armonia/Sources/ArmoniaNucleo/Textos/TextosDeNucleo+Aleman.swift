// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en alemán. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let aleman = TextosDeNucleo(
        // Intervalo.swift
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

        // Nota.swift
        palabraNatural: "Auflösungszeichen",
        palabraSostenido: "Kreuz",
        palabraBemol: "Be",
        multiplicadores: ["Doppel", "Dreifach", "Vierfach"],
        palabraSostenidos: "Kreuze",
        palabraBemoles: "Be",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Ungültiger Wert",
        noSePuedeLeer: { texto in "„\(texto)“ kann nicht gelesen werden" },
        caracter: { p in " (Zeichen \(p + 1))" },
        textoVacio: "der Text ist leer",
        caracteresSobrantes: { resto in "„\(resto)“ ist zu viel" },

        // ErrorDeLectura.swift (notas)
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
        intervaloInexistente: { numero, calidad, notacion, regla in "es gibt keine \(calidad.nombre(en: .alemanPalabras)) \(Intervalo.ordinal(numero, en: .aleman)): \(regla.aleman)" },
        alteracionNoReconocida: { signo in "„\(signo)“ ist kein Vorzeichen (erwartet ♯, ♭, 𝄪, 𝄫, #, b, x oder ♮)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "„\(texto)“ ist weder eine Tonhöhenklasse (0 bis 11, oder t und e für 10 und 11) noch ein Notenname" },
        numeroDeForteDesconocido: { texto in "„\(texto)“ ist keine Forte-Nummer (zum Beispiel 3-11 oder 4-Z15)" },
        faltaElCierre: { signo in "das schließende „\(signo)“ fehlt" },
        serieNoDodecafonica: "eine Zwölftonreihe enthält alle zwölf Tonhöhenklassen, jede genau einmal",
        faltanEnLaSerie: { clases in "es fehlen \(clases)" },
        repetidasEnLaSerie: { clases in "wiederholt: \(clases)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["Prime", "Sekunde", "Terz", "Quarte", "Quinte", "Sexte", "Septime", "Oktave", "None", "Dezime", "Undezime", "Duodezime", "Tredezime", "Quartdezime", "Doppeloktave"],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
