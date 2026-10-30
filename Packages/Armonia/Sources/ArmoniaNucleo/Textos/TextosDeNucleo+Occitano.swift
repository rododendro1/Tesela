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

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» fa pas part de cap de chifratge conegut" },
        tensionNoValida: { tension in "«\(tension)» es pas una tension valida (♭/♯ van amb 5, 9, 11 e 13, e add amb 2, 4, 6, 9, 11 e 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» es pas un nombre d'acòrd (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» ven aprèp un autre nombre; las tensions suplementàrias van entre parentèsis, coma dins 7(9)" },
        disminuidoYSemidisminuido: "diminuit (°) e semidiminuit (ø) se pòdon pas combinar",
        quintaConCalidad: "l'acòrd de quinta (5) a pas de tèrça, doncas admet pas m, °, ø ni +",
        fundamentalNoOmitible: "se pòt pas ometre la fondamentala",
        gradoNoOmitible: { grado in "«omit\(grado)» es pas valid (se pòdon ometre 3, 5, 7, 9, 11 e 13)" },
        faltaLaFundamental: "manca la fondamentala",
        intervaloSinPapel: { intervalo, notacion in "la \(intervalo.nombre(en: .occitano)) a pas cap de ròtle dins un acòrd per tèrças" },
        terceraMayorYMenor: "a una tèrça majora e una tèrça menora alhora (la ♯9 s'escriu coma novena aumentada, pas coma tèrça menora)",
        variasSeptimas: "a mai d'una setena",
        septimaDisminuidaFueraDelDisminuido: "la setena diminuida apareis sonque dins l'acòrd diminuit (amb tèrça menora e quinta diminuida)",
        noEsPorTerceras: "es pas un acòrd per tèrças",
        bajoNoValido: { bajo in "«\(bajo)» es pas un nom de nòta per la bassa" },
        idiomasMezclados: { nombre in "«\(nombre)» es escrich dins una autra lenga que la fondamentala: s'escriu tot amb sillabas (Sol7/Si) o tot amb letras (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» es pas lo mòde d'una tonalitat: una tonalitat es majora o menora (pels autres mòdes, utiliza Escala)" },
        faltaElTipoDeEscala: "manca lo tipe de gama (major, dorian, menor armonica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» es pas un tipe de gama conegut" },

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
        intervaloInexistente: { numero, calidad, notacion, regla in "i a pas de \(Intervalo.ordinal(numero, en: .occitano)) \(calidad.nombre(en: .occitano)): \(regla.occitano)" },
        alteracionNoReconocida: { signo in "«\(signo)» es pas una alteracion (s'esperava ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» es pas una durada: s'esperava una figura (1, 2, 4, 8, 16…, puntada: 4.) o una fraccion de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» es pas una mesura: s'esperava numerator/denominator amb lo denominator poténcia de 2 (4/4, 6/8, 7/8), C o ¢" },
        vocesDistintas: "totes los acòrds devon aver lo meteis nombre de voses, e almens doas",
        contrapuntoDeOtraDuracion: { redondas in "lo contrapunt deu durar autant coma lo cantus firmus: \(redondas) redondas, una per nòta" }
    )
}
