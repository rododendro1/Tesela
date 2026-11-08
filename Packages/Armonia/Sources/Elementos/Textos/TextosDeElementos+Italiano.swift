// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en italiano. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let italiano = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "giusta",
        calidadMayor: "maggiore",
        calidadMenor: "minore",
        calidadAumentada: "aumentata",
        calidadDisminuida: "diminuita",
        multiplicidadSimple: "",
        multiplicidadDoble: "doppiamente ",
        multiplicidadTriple: "triplamente ",
        multiplicidad: "{1} volte ",
        plantillaDescendente: "{1} discendente",
        consonanciaPerfecta: "consonanza perfetta",
        consonanciaImperfecta: "consonanza imperfetta",
        disonancia: "dissonanza",

        // Nota.swift
        palabraNatural: "bequadro",
        palabraSostenido: "diesis",
        palabraBemol: "bemolle",
        multiplicadores: ["doppio ", "triplo ", "quadruplo "],
        palabraSostenidos: "diesis",
        palabraBemoles: "bemolli",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valore non valido",
        noSePuedeLeer: "Impossibile leggere «{1}»",
        caracter: { p in " (carattere \(p + 1))" },
        textoVacio: "il testo è vuoto",
        caracteresSobrantes: "«{1}» è di troppo",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "si aspettava un nome di nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "manca l'ottava (per esempio, Do4)",
        octavaNoValida: "«{1}» non è un'ottava valida",
        faltaElNumeroDeIntervalo: "manca il numero dell'intervallo (per esempio, 3M)",
        numeroDeIntervaloNoValido: "«{1}» non è un numero di intervallo",
        faltaLaCalidad: "manca la specie dell'intervallo (J, M, m, A o d)",
        calidadNoValida: "«{1}» non è una specie di intervallo (J, M, m, A o d)",
        unisonoDisminuido: "l'unisono diminuito non esiste: da Do a Do♭ c'è un unisono aumentato discendente (scrivilo -1A)",
        reglaDeLasJustas: "l'unisono, la 4ª, la 5ª e l'8ª sono giuste, aumentate o diminuite",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª e la 7ª sono maggiori, minori, aumentate o diminuite",
        intervaloInexistente: { numero, calidad, notacion, regla in "non esiste la \(numero)ª \(calidad.nombre(en: .conPalabras(.italiano))): \(regla.texto(en: .italiano))" },
        alteracionNoReconocida: "«{1}» non è un'alterazione (si aspettava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» non è né una classe di altezza (da 0 a 11, o t ed e per 10 e 11) né un nome di nota",
        numeroDeForteDesconocido: "«{1}» non è un numero di Forte (per esempio, 3-11 o 4-Z15)",
        faltaElCierre: "manca la «{1}» finale",
        serieNoDodecafonica: "una serie dodecafonica ha tutte e dodici le classi di altezza, ciascuna una volta",
        faltanEnLaSerie: "mancano {1}",
        repetidasEnLaSerie: "si ripetono {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» non è nessuna delle tredici lingue: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad.hasSuffix("a") ? String(calidad.dropLast()) + "o" : calidad },
        ordinales: ["unisono", "seconda", "terza", "quarta", "quinta", "sesta", "settima", "ottava", "nona", "decima", "undicesima", "dodicesima", "tredicesima", "quattordicesima", "doppia ottava"],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
