// Los textos de ArmoniaNucleo en catalán. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let catalan = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "major",
        calidadMenor: "menor",
        calidadAumentada: "augmentada",
        calidadDisminuida: "disminuïda",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegades " },
        plantillaDescendente: "_ descendent",
        consonanciaPerfecta: "consonància perfecta",
        consonanciaImperfecta: "consonància imperfecta",
        disonancia: "dissonància",

        // Nota.swift
        palabraNatural: "becaire",
        palabraSostenido: "sostingut",
        palabraBemol: "bemoll",
        multiplicadores: ["doble ", "triple ", "quàdruple "],
        palabraSostenidos: "sostinguts",
        palabraBemoles: "bemolls",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» no forma part de cap xifrat conegut" },
        tensionNoValida: { tension in "«\(tension)» no és una tensió vàlida (s'admeten ♭/♯ amb 5, 9, 11 i 13, i add amb 2, 4, 6, 9, 11 i 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» no és un número d'acord (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» apareix després d'un altre número; les tensions addicionals van entre parèntesis, com a 7(9)" },
        disminuidoYSemidisminuido: "disminuït (°) i semidisminuït (ø) no es poden combinar",
        quintaConCalidad: "l'acord de quinta (5) no porta tercera, així que no admet m, °, ø ni +",
        fundamentalNoOmitible: "no es pot ometre la fonamental",
        gradoNoOmitible: { grado in "«omit\(grado)» no és vàlid (es poden ometre 3, 5, 7, 9, 11 i 13)" },
        faltaLaFundamental: "falta la fonamental",
        intervaloSinPapel: { intervalo, notacion in "la \(intervalo.nombre(en: .catalan)) no té cap paper en un acord per terceres" },
        terceraMayorYMenor: "té tercera major i menor alhora (la ♯9 s'escriu com a 9a augmentada, no com a 3a menor)",
        variasSeptimas: "té més d'una sèptima",
        septimaDisminuidaFueraDelDisminuido: "la sèptima disminuïda només apareix a l'acord disminuït (amb 3a menor i 5a disminuïda)",
        noEsPorTerceras: "no és un acord per terceres",
        bajoNoValido: { bajo in "«\(bajo)» no és un nom de nota per al baix" },
        idiomasMezclados: { nombre in "«\(nombre)» està escrit en un altre idioma que la fonamental: s'escriu tot amb síl·labes (Sol7/Si) o tot amb lletres (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» no és el mode d'una tonalitat: una tonalitat és major o menor (per als altres modes, fes servir Escala)" },
        faltaElTipoDeEscala: "falta el tipus d'escala (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» no és un tipus d'escala conegut" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor no vàlid",
        noSePuedeLeer: { texto in "No es pot llegir «\(texto)»" },
        caracter: { p in " (caràcter \(p + 1))" },
        textoVacio: "el text és buit",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "s'esperava un nom de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta l'octava (per exemple, Do4)",
        octavaNoValida: { resto in "«\(resto)» no és una octava vàlida" },
        faltaElNumeroDeIntervalo: "falta el número de l'interval (per exemple, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no és un número d'interval" },
        faltaLaCalidad: "falta la qualitat de l'interval (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» no és una qualitat d'interval (J, M, m, A o d)" },
        unisonoDisminuido: "no existeix l'uníson disminuït: de Do a Do♭ hi ha un uníson augmentat descendent (escriu-lo -1A)",
        reglaDeLasJustas: "l'uníson, la 4a, la 5a i la 8a són justes, augmentades o disminuïdes",
        reglaDeLasMayores: "la 2a, la 3a, la 6a i la 7a són majors, menors, augmentades o disminuïdes",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existeix la \(numero)a \(calidad.nombre(en: .catalan)): \(regla.catalan)" },
        alteracionNoReconocida: { signo in "«\(signo)» no és una alteració (s'esperava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» no és una durada: s'esperava una figura (1, 2, 4, 8, 16…, amb punts: 4.) o una fracció de rodona (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» no és un compàs: s'esperava numerador/denominador amb el denominador potència de 2 (4/4, 6/8, 7/8), C o ¢" },
        vocesDistintas: "tots els acords han de tenir el mateix nombre de veus, i almenys dues",
        contrapuntoDeOtraDuracion: { redondas in "el contrapunt ha de durar el mateix que el cantus firmus: \(redondas) rodones, una per nota" }
    )
}
