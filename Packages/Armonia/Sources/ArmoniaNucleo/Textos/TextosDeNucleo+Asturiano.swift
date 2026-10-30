// Los textos de ArmoniaNucleo en asturiano. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let asturiano = TextosDeNucleo(
        // Intervalo+Idiomas.swift
        calidadJusta: "xusta",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "menguada",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegaes " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonancia perfeuta",
        consonanciaImperfecta: "consonancia imperfeuta",
        disonancia: "disonancia",

        // Nota+Idiomas.swift
        palabraNatural: "becuadru",
        palabraSostenido: "sosteníu",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sosteníos",
        palabraBemoles: "bemoles",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "«\(simbolo)» nun fai parte de nengún cifráu conocíu" },
        tensionNoValida: { tension in "«\(tension)» nun ye una tensión válida (almítense ♭/♯ con 5, 9, 11 y 13, y add con 2, 4, 6, 9, 11 y 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» nun ye un númberu d\'acorde (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» apaez tres d\'otru númberu; les tensiones adicionales van ente paréntesis, como en 7(9)" },
        disminuidoYSemidisminuido: "menguáu (°) y semimenguáu (ø) nun se puen combinar",
        quintaConCalidad: "l\'acorde de quinta (5) nun lleva tercera, asina que nun almite m, °, ø nin +",
        fundamentalNoOmitible: "nun se pue omitir la fundamental",
        gradoNoOmitible: { grado in "«omit\(grado)» nun ye válidu (puen omitise 3, 5, 7, 9, 11 y 13)" },
        faltaLaFundamental: "falta la fundamental",
        intervaloSinPapel: { intervalo, notacion in "la \(intervalo.nombre(en: .asturiano)) nun tien papel nun acorde per terceres" },
        terceraMayorYMenor: "tien tercera mayor y menor al empar (la ♯9 escríbese como 9ª aumentada, non como 3ª menor)",
        variasSeptimas: "tien más d\'una séptima",
        septimaDisminuidaFueraDelDisminuido: "la séptima menguada namás apaez nel acorde menguáu (con 3ª menor y 5ª menguada)",
        noEsPorTerceras: "nun ye un acorde per terceres",
        bajoNoValido: { bajo in "«\(bajo)» nun ye un nome de nota pal baxu" },
        idiomasMezclados: { nombre in "«\(nombre)» ta escritu n\'otra llingua que la fundamental: escríbese too en castellán (Sol7/Si) o too con lletres (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "«\(nombre)» nun ye\'l mou d\'una tonalidá: una tonalidá ye mayor o menor (pa los demás moos, usa Escala)" },
        faltaElTipoDeEscala: "falta\'l tipu d\'escala (mayor, dóricu, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» nun ye un tipu d\'escala conocíu" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Valor non válidu",
        noSePuedeLeer: { texto in "Nun se pue lleer «\(texto)»" },
        caracter: { p in " (caráuter \(p + 1))" },
        textoVacio: "el testu ta baleru",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura+Notas.swift
        notaNoReconocida: "esperábase un nome de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta la octava (por exemplu, Do4)",
        octavaNoValida: { resto in "«\(resto)» nun ye una octava válida" },
        faltaElNumeroDeIntervalo: "falta\'l númberu del intervalu (por exemplu, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» nun ye un númberu d\'intervalu" },
        faltaLaCalidad: "falta la calidá del intervalu (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» nun ye una calidá d\'intervalu (J, M, m, A o d)" },
        unisonoDisminuido: "nun esiste l\'unísonu menguáu: de Do a Do♭ hai un unísonu aumentáu descendente (escríbilu -1A)",
        reglaDeLasJustas: "l\'unísonu, la 4ª, la 5ª y la 8ª son xustes, aumentaes o menguaes",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª y la 7ª son mayores, menores, aumentaes o menguaes",
        intervaloInexistente: { numero, calidad, notacion, regla in "nun esiste la \(numero)ª \(calidad.nombre(en: .asturiano)): \(regla.asturiano)" },
        alteracionNoReconocida: { signo in "«\(signo)» nun ye una alteración (esperábase ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "«\(texto)» nun ye una duración: esperábase una figura (1, 2, 4, 8, 16…, con puntiellos: 4.) o una fraición de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» nun ye un compás: esperábase numerador/denominador col denominador potencia de 2 (4/4, 6/8, 7/8), C o ¢" },
        vocesDistintas: "tolos acordes tienen que tener el mesmu númberu de voces, y polo menos dos",
        contrapuntoDeOtraDuracion: { redondas in "el contrapuntu tien que durar lo mesmo que\'l cantus firmus: \(redondas) redondes, una por nota" }
    )
}
