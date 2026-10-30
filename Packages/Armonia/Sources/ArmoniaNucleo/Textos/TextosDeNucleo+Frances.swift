// Los textos de ArmoniaNucleo en francés. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let frances = TextosDeNucleo(
        // Intervalo+Idiomas.swift
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

        // Nota+Idiomas.swift
        palabraNatural: "bécarre",
        palabraSostenido: "dièse",
        palabraBemol: "bémol",
        multiplicadores: ["double ", "triple ", "quadruple "],
        palabraSostenidos: "dièses",
        palabraBemoles: "bémols",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "« \(simbolo) » ne fait partie d'aucun chiffrage connu" },
        tensionNoValida: { tension in "« \(tension) » n'est pas une tension valide (♭/♯ s'emploient avec 5, 9, 11 et 13, et add avec 2, 4, 6, 9, 11 et 13)" },
        numeroDeAcordeNoValido: { numero in "« \(numero) » n'est pas un numéro d'accord (5, 6, 7, 9, 11 ou 13)" },
        numeroRepetido: { numero in "« \(numero) » suit un autre numéro ; les tensions supplémentaires se mettent entre parenthèses, comme dans 7(9)" },
        disminuidoYSemidisminuido: "diminué (°) et semi-diminué (ø) ne peuvent pas se combiner",
        quintaConCalidad: "l'accord de quinte (5) n'a pas de tierce, il n'admet donc ni m, ni °, ni ø, ni +",
        fundamentalNoOmitible: "on ne peut pas omettre la fondamentale",
        gradoNoOmitible: { grado in "« omit\(grado) » n'est pas valide (on peut omettre 3, 5, 7, 9, 11 et 13)" },
        faltaLaFundamental: "il manque la fondamentale",
        intervaloSinPapel: { intervalo, notacion in "l'intervalle de \(intervalo.nombre(en: .frances)) n'a aucun rôle dans un accord par tierces" },
        terceraMayorYMenor: "il a à la fois une tierce majeure et une tierce mineure (la ♯9 s'écrit comme neuvième augmentée, pas comme tierce mineure)",
        variasSeptimas: "il a plus d'une septième",
        septimaDisminuidaFueraDelDisminuido: "la septième diminuée n'apparaît que dans l'accord diminué (avec tierce mineure et quinte diminuée)",
        noEsPorTerceras: "ce n'est pas un accord par tierces",
        bajoNoValido: { bajo in "« \(bajo) » n'est pas un nom de note pour la basse" },
        idiomasMezclados: { nombre in "« \(nombre) » est écrit dans une autre langue que la fondamentale : on écrit tout en syllabes (Sol7/Si) ou tout en lettres (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "« \(nombre) » n'est pas le mode d'une tonalité : une tonalité est majeure ou mineure (pour les autres modes, utilisez Escala)" },
        faltaElTipoDeEscala: "il manque le type de gamme (majeur, dorien, mineur harmonique…)",
        tipoDeEscalaNoReconocido: { nombre in "« \(nombre) » n'est pas un type de gamme connu" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Valeur non valide",
        noSePuedeLeer: { texto in "Impossible de lire « \(texto) »" },
        caracter: { p in " (caractère \(p + 1))" },
        textoVacio: "le texte est vide",
        caracteresSobrantes: { resto in "« \(resto) » est en trop" },

        // ErrorDeLectura+Notas.swift
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
        intervaloInexistente: { numero, calidad, notacion, regla in "il n'existe pas de \(numero)e \(calidad.nombre(en: .frances)) : \(regla.frances)" },
        alteracionNoReconocida: { signo in "« \(signo) » n'est pas une altération (♯, ♭, 𝄪, 𝄫, #, b, x ou ♮ attendu)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "« \(texto) » n'est pas une durée : une figure était attendue (1, 2, 4, 8, 16…, pointée : 4.) ou une fraction de ronde (3/8, 1/12)" },
        compasNoValido: { texto in "« \(texto) » n'est pas une mesure : numérateur/dénominateur attendu, avec un dénominateur puissance de 2 (4/4, 6/8, 7/8), C ou ¢" },
        vocesDistintas: "tous les accords doivent avoir le même nombre de voix, et au moins deux",
        contrapuntoDeOtraDuracion: { redondas in "le contrepoint doit durer autant que le cantus firmus : \(redondas) rondes, une par note" }
    )
}
