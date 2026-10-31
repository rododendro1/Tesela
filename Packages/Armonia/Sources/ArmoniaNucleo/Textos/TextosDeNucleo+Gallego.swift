// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en gallego. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let gallego = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "xusta",
        calidadMayor: "maior",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "diminuída",
        multiplicidadSimple: "",
        multiplicidadDoble: "dobre ",
        multiplicidadTriple: "tripla ",
        multiplicidad: { n in "\(n) veces " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "becadro",
        palabraSostenido: "sostido",
        palabraBemol: "bemol",
        multiplicadores: ["dobre ", "triplo ", "cuádruplo "],
        palabraSostenidos: "sostidos",
        palabraBemoles: "bemois",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» non forma parte de ningún cifrado coñecido" },
        tensionNoValida: { tension in "«\(tension)» non é unha tensión válida (admítense ♭/♯ con 5, 9, 11 e 13, e add con 2, 4, 6, 9, 11 e 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» non é un número de acorde (5, 6, 7, 9, 11 ou 13)" },
        numeroRepetido: { numero in "«\(numero)» aparece despois doutro número; as tensións adicionais van entre parénteses, como en 7(9)" },
        disminuidoYSemidisminuido: "diminuído (°) e semidiminuído (ø) non se poden combinar",
        quintaConCalidad: "o acorde de quinta (5) non leva terceira, así que non admite m, °, ø nin +",
        fundamentalNoOmitible: "non se pode omitir a fundamental",
        gradoNoOmitible: { grado in "«omit\(grado)» non é válido (pódense omitir 3, 5, 7, 9, 11 e 13)" },
        faltaLaFundamental: "falta a fundamental",
        intervaloSinPapel: { intervalo, notacion in "a \(intervalo.nombre(en: .gallego)) non ten papel nun acorde por terceiras" },
        terceraMayorYMenor: "ten terceira maior e menor á vez (a ♯9 escríbese como 9ª aumentada, non como 3ª menor)",
        variasSeptimas: "ten máis dunha sétima",
        septimaDisminuidaFueraDelDisminuido: "a sétima diminuída só aparece no acorde diminuído (con 3ª menor e 5ª diminuída)",
        noEsPorTerceras: "non é un acorde por terceiras",
        bajoNoValido: { bajo in "«\(bajo)» non é un nome de nota para o baixo" },
        idiomasMezclados: { nombre in "«\(nombre)» está escrito noutro idioma que a fundamental: escríbese todo con sílabas (Sol7/Si) ou todo con letras (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» non é o modo dunha tonalidade: unha tonalidade é maior ou menor (para os demais modos, usa Escala)" },
        faltaElTipoDeEscala: "falta o tipo de escala (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» non é un tipo de escala coñecido" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor non válido",
        noSePuedeLeer: { texto in "Non se pode ler «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "o texto está baleiro",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "agardábase un nome de nota (Do, Re, Mi… ou C, D, E…)",
        faltaLaOctava: "falta a oitava (por exemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» non é unha oitava válida" },
        faltaElNumeroDeIntervalo: "falta o número do intervalo (por exemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» non é un número de intervalo" },
        faltaLaCalidad: "falta a calidade do intervalo (J, M, m, A ou d)",
        calidadNoValida: { resto in "«\(resto)» non é unha calidade de intervalo (J, M, m, A ou d)" },
        unisonoDisminuido: "non existe o unísono diminuído: de Do a Do♭ hai un unísono aumentado descendente (escríbeo -1A)",
        reglaDeLasJustas: "o unísono, a 4ª, a 5ª e a 8ª son xustas, aumentadas ou diminuídas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª e a 7ª son maiores, menores, aumentadas ou diminuídas",
        intervaloInexistente: { numero, calidad, notacion, regla in "non existe a \(numero)ª \(calidad.nombre(en: .gallego)): \(regla.gallego)" },
        alteracionNoReconocida: { signo in "«\(signo)» non é unha alteración (agardábase ♯, ♭, 𝄪, 𝄫, #, b, x ou ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» non é unha duración: agardábase unha figura (1, 2, 4, 8, 16…, con puntiños: 4.) ou unha fracción de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» non é un compás: agardábase numerador/denominador co denominador potencia de 2 (4/4, 6/8, 7/8), C ou ¢" },
        vocesDistintas: "todos os acordes teñen que ter o mesmo número de voces, e polo menos dúas",
        contrapuntoDeOtraDuracion: { redondas in "o contrapunto ten que durar o mesmo que o cantus firmus: \(redondas) redondas, unha por nota" },
        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
