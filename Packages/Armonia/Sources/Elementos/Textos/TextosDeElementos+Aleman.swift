// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en alemán. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let aleman = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "reine",
        calidadMayor: "große",
        calidadMenor: "kleine",
        calidadAumentada: "übermäßige",
        calidadDisminuida: "verminderte",
        multiplicidadSimple: "",
        multiplicidadDoble: "doppelt ",
        multiplicidadTriple: "dreifach ",
        multiplicidad: "{1}-fach ",
        plantillaDescendente: "{1} abwärts",
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
        noSePuedeLeer: "„{1}“ kann nicht gelesen werden",
        caracter: { p in " (Zeichen \(p + 1))" },
        textoVacio: "der Text ist leer",
        caracteresSobrantes: "„{1}“ ist zu viel",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "Notenname erwartet (C, D, E… oder Do, Re, Mi…)",
        faltaLaOctava: "die Oktave fehlt (zum Beispiel C4)",
        octavaNoValida: "„{1}“ ist keine gültige Oktave",
        faltaElNumeroDeIntervalo: "die Intervallzahl fehlt (zum Beispiel M3)",
        numeroDeIntervaloNoValido: "„{1}“ ist keine Intervallzahl",
        faltaLaCalidad: "die Intervallqualität fehlt (P, M, m, A oder d)",
        calidadNoValida: "„{1}“ ist keine Intervallqualität (P, M, m, A oder d)",
        unisonoDisminuido: "eine verminderte Prime gibt es nicht: von C nach Ces ist es eine übermäßige Prime abwärts (schreib -A1)",
        reglaDeLasJustas: "Prime, Quarte, Quinte und Oktave sind rein, übermäßig oder vermindert",
        reglaDeLasMayores: "Sekunde, Terz, Sexte und Septime sind groß, klein, übermäßig oder vermindert",
        intervaloInexistente: { numero, calidad, notacion, regla in "es gibt keine \(calidad.nombre(en: .conPalabras(.aleman))) \(Intervalo.ordinal(numero, en: .aleman)): \(regla.texto(en: .aleman))" },
        alteracionNoReconocida: "„{1}“ ist kein Vorzeichen (erwartet ♯, ♭, 𝄪, 𝄫, #, b, x oder ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "„{1}“ ist weder eine Tonhöhenklasse (0 bis 11, oder t und e für 10 und 11) noch ein Notenname",
        numeroDeForteDesconocido: "„{1}“ ist keine Forte-Nummer (zum Beispiel 3-11 oder 4-Z15)",
        faltaElCierre: "das schließende „{1}“ fehlt",
        serieNoDodecafonica: "eine Zwölftonreihe enthält alle zwölf Tonhöhenklassen, jede genau einmal",
        faltanEnLaSerie: "es fehlen {1}",
        repetidasEnLaSerie: "wiederholt: {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "„{1}“ ist keine der dreizehn Sprachen: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{1} {2}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["Prime", "Sekunde", "Terz", "Quarte", "Quinte", "Sexte", "Septime", "Oktave", "None", "Dezime", "Undezime", "Duodezime", "Tredezime", "Quartdezime", "Doppeloktave"],
        ordinalEnCifras: { n in "\(n)." },
        dosPuntos: ": "
    )
}
