// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en occitano. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let occitano = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "majora",
        calidadMenor: "menora",
        calidadAumentada: "aumentada",
        calidadDisminuida: "diminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doblament ",
        multiplicidadTriple: "triplament ",
        multiplicidad: { n in "\(n) còps " },
        plantillaDescendente: "_ descendenta",
        consonanciaPerfecta: "consonància perfiècha",
        consonanciaImperfecta: "consonància imperfiècha",
        disonancia: "dissonància",

        // Nota.swift
        palabraNatural: "becarre",
        palabraSostenido: "dièsi",
        palabraBemol: "bemòl",
        multiplicadores: ["doble ", "triple ", "quadruple "],
        palabraSostenidos: "dièsis",
        palabraBemoles: "bemòls",

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor invalida",
        noSePuedeLeer: { texto in "Se pòt pas legir «\(texto)»" },
        caracter: { p in " (caractèr \(p + 1))" },
        textoVacio: "lo tèxte es void",
        caracteresSobrantes: { resto in "i a de tròp «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "s'esperava un nom de nòta (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "manca l'octava (per exemple, Do4)",
        octavaNoValida: { resto in "«\(resto)» es pas una octava valida" },
        faltaElNumeroDeIntervalo: "manca lo nombre de l'interval (per exemple, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» es pas un nombre d'interval" },
        faltaLaCalidad: "manca la qualitat de l'interval (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» es pas una qualitat d'interval (J, M, m, A o d)" },
        unisonoDisminuido: "l'unisson diminuit existís pas: de Do a Do♭ i a un unisson aumentat descendent (escriu-lo -1A)",
        reglaDeLasJustas: "l'unisson, la quarta, la quinta e l'octava son justas, aumentadas o diminuidas",
        reglaDeLasMayores: "la segonda, la tèrça, la sexta e la setena son majoras, menoras, aumentadas o diminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "i a pas de \(Intervalo.ordinal(numero, en: .occitano)) \(calidad.nombre(en: .conPalabras(.occitano))): \(regla.occitano)" },
        alteracionNoReconocida: { signo in "«\(signo)» es pas una alteracion (s'esperava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: { texto in "«\(texto)» es pas ni una classa d'autor (de 0 a 11, o t e e per 10 e 11) ni un nom de nòta" },
        numeroDeForteDesconocido: { texto in "«\(texto)» es pas un numèro de Forte (per exemple, 3-11 o 4-Z15)" },
        faltaElCierre: { signo in "manca lo «\(signo)» de la fin" },
        serieNoDodecafonica: "una seria dodecafonica a las dotze classas d'autor, cadua un còp",
        faltanEnLaSerie: { clases in "mancan \(clases)" },
        repetidasEnLaSerie: { clases in "se repetisson \(clases)" },
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: { n, o in "«\(n)» es pas cap de las quinze lengas: \(o)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad.hasSuffix("ada") ? String(calidad.dropLast(3)) + "at" : calidad.hasSuffix("ida") ? String(calidad.dropLast(3)) + "it" : calidad.hasSuffix("a") ? String(calidad.dropLast()) : calidad },
        ordinales: ["unisson", "segonda", "tèrça", "quarta", "quinta", "sexta", "setena", "octava", "novena", "desena", "onzena", "dotzena", "tretzena", "catorzena", "doble octava"],
        ordinalEnCifras: { n in "\(n)a" },
        dosPuntos: ": "
    )
}
