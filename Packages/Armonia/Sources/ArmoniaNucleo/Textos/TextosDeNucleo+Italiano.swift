// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en italiano. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let italiano = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "giusta",
        calidadMayor: "maggiore",
        calidadMenor: "minore",
        calidadAumentada: "aumentata",
        calidadDisminuida: "diminuita",
        multiplicidadSimple: "",
        multiplicidadDoble: "doppiamente ",
        multiplicidadTriple: "triplamente ",
        multiplicidad: { n in "\(n) volte " },
        plantillaDescendente: "_ discendente",
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
        noSePuedeLeer: { texto in "Impossibile leggere «\(texto)»" },
        caracter: { p in " (carattere \(p + 1))" },
        textoVacio: "il testo è vuoto",
        caracteresSobrantes: { resto in "«\(resto)» è di troppo" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "si aspettava un nome di nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "manca l'ottava (per esempio, Do4)",
        octavaNoValida: { resto in "«\(resto)» non è un'ottava valida" },
        faltaElNumeroDeIntervalo: "manca il numero dell'intervallo (per esempio, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» non è un numero di intervallo" },
        faltaLaCalidad: "manca la specie dell'intervallo (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» non è una specie di intervallo (J, M, m, A o d)" },
        unisonoDisminuido: "l'unisono diminuito non esiste: da Do a Do♭ c'è un unisono aumentato discendente (scrivilo -1A)",
        reglaDeLasJustas: "l'unisono, la 4ª, la 5ª e l'8ª sono giuste, aumentate o diminuite",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª e la 7ª sono maggiori, minori, aumentate o diminuite",
        intervaloInexistente: { numero, calidad, notacion, regla in "non esiste la \(numero)ª \(calidad.nombre(en: .italianoPalabras)): \(regla.italiano)" },
        alteracionNoReconocida: { signo in "«\(signo)» non è un'alterazione (si aspettava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad.hasSuffix("a") ? String(calidad.dropLast()) + "o" : calidad },
        ordinales: ["unisono", "seconda", "terza", "quarta", "quinta", "sesta", "settima", "ottava", "nona", "decima", "undicesima", "dodicesima", "tredicesima", "quattordicesima", "doppia ottava"],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
