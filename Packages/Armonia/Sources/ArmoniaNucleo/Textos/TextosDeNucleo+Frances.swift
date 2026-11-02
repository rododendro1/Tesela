// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en francés. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let frances = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "juste",
        calidadMayor: "majeure",
        calidadMenor: "mineure",
        calidadAumentada: "augmentée",
        calidadDisminuida: "diminuée",
        multiplicidadSimple: "",
        multiplicidadDoble: "doublement ",
        multiplicidadTriple: "triplement ",
        multiplicidad: { n in "\(n) fois " },
        plantillaDescendente: "_ descendante",
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
        noSePuedeLeer: { texto in "Impossible de lire « \(texto) »" },
        caracter: { p in " (caractère \(p + 1))" },
        textoVacio: "le texte est vide",
        caracteresSobrantes: { resto in "« \(resto) » est en trop" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "un nom de note était attendu (Do, Ré, Mi… ou C, D, E…)",
        faltaLaOctava: "il manque l'octave (par exemple, Do4)",
        octavaNoValida: { resto in "« \(resto) » n'est pas une octave valide" },
        faltaElNumeroDeIntervalo: "il manque le numéro de l'intervalle (par exemple, 3M)",
        numeroDeIntervaloNoValido: { resto in "« \(resto) » n'est pas un numéro d'intervalle" },
        faltaLaCalidad: "il manque la qualité de l'intervalle (J, M, m, A ou d)",
        calidadNoValida: { resto in "« \(resto) » n'est pas une qualité d'intervalle (J, M, m, A ou d)" },
        unisonoDisminuido: "l'unisson diminué n'existe pas : de do à do♭, il y a un unisson augmenté descendant (écrivez -1A)",
        reglaDeLasJustas: "l'unisson, la quarte, la quinte et l'octave sont justes, augmentées ou diminuées",
        reglaDeLasMayores: "la seconde, la tierce, la sixte et la septième sont majeures, mineures, augmentées ou diminuées",
        intervaloInexistente: { numero, calidad, notacion, regla in "il n'existe pas de \(numero)e \(calidad.nombre(en: .francesPalabras)) : \(regla.frances)" },
        alteracionNoReconocida: { signo in "« \(signo) » n'est pas une altération (♯, ♭, 𝄪, 𝄫, #, b, x ou ♮ attendu)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad.hasSuffix("ée") ? String(calidad.dropLast()) : calidad },
        ordinales: ["unisson", "seconde", "tierce", "quarte", "quinte", "sixte", "septième", "octave", "neuvième", "dixième", "onzième", "douzième", "treizième", "quatorzième", "double octave"],
        ordinalEnCifras: { n in "\(n)e" },
        dosPuntos: " : "
    )
}
