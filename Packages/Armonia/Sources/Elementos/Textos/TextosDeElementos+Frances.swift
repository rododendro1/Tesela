// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en francés. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let frances = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "juste",
        calidadMayor: "majeure",
        calidadMenor: "mineure",
        calidadAumentada: "augmentée",
        calidadDisminuida: "diminuée",
        multiplicidadSimple: "",
        multiplicidadDoble: "doublement ",
        multiplicidadTriple: "triplement ",
        multiplicidad: "{1} fois ",
        plantillaDescendente: "{1} descendante",
        consonanciaPerfecta: "consonance parfaite",
        consonanciaImperfecta: "consonance imparfaite",
        disonancia: "dissonance",

        // Nota.swift
        palabraNatural: "bécarre",
        palabraSostenido: "dièse",
        palabraBemol: "bémol",
        multiplicadores: ["double ", "triple ", "quadruple "],
        palabraSostenidos: "dièses",
        palabraBemoles: "bémols",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valeur non valide",
        noSePuedeLeer: "Impossible de lire « {1} »",
        caracter: { p in " (caractère \(p + 1))" },
        textoVacio: "le texte est vide",
        caracteresSobrantes: "« {1} » est en trop",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "un nom de note était attendu (Do, Ré, Mi… ou C, D, E…)",
        faltaLaOctava: "il manque l'octave (par exemple, Do4)",
        octavaNoValida: "« {1} » n'est pas une octave valide",
        faltaElNumeroDeIntervalo: "il manque le numéro de l'intervalle (par exemple, 3M)",
        numeroDeIntervaloNoValido: "« {1} » n'est pas un numéro d'intervalle",
        faltaLaCalidad: "il manque la qualité de l'intervalle (J, M, m, A ou d)",
        calidadNoValida: "« {1} » n'est pas une qualité d'intervalle (J, M, m, A ou d)",
        unisonoDisminuido: "l'unisson diminué n'existe pas : de do à do♭, il y a un unisson augmenté descendant (écrivez -1A)",
        reglaDeLasJustas: "l'unisson, la quarte, la quinte et l'octave sont justes, augmentées ou diminuées",
        reglaDeLasMayores: "la seconde, la tierce, la sixte et la septième sont majeures, mineures, augmentées ou diminuées",
        intervaloInexistente: { numero, calidad, notacion, regla in "il n'existe pas de \(numero)e \(calidad.nombre(en: .conPalabras(.frances))) : \(regla.texto(en: .frances))" },
        alteracionNoReconocida: "« {1} » n'est pas une altération (♯, ♭, 𝄪, 𝄫, #, b, x ou ♮ attendu)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "« {1} » n'est ni une classe de hauteur (de 0 à 11, ou t et e pour 10 et 11) ni un nom de note",
        numeroDeForteDesconocido: "« {1} » n'est pas un numéro de Forte (par exemple, 3-11 ou 4-Z15)",
        faltaElCierre: "il manque le « {1} » final",
        serieNoDodecafonica: "une série dodécaphonique contient les douze classes de hauteur, chacune une fois",
        faltanEnLaSerie: "il manque {1}",
        repetidasEnLaSerie: "{1} se répètent",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "« {1} » n'est aucune des treize langues : {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad.hasSuffix("ée") ? String(calidad.dropLast()) : calidad },
        ordinales: ["unisson", "seconde", "tierce", "quarte", "quinte", "sixte", "septième", "octave", "neuvième", "dixième", "onzième", "douzième", "treizième", "quatorzième", "double octave"],
        ordinalEnCifras: { n in "\(n)e" },
        dosPuntos: " : "
    )
}
