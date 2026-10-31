// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en aragonés. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let aragones = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "chusta",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "disminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) vegadas " },
        plantillaDescendente: "_ descendent",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota.swift
        palabraNatural: "becuadro",
        palabraSostenido: "sosteniu",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sostenius",
        palabraBemoles: "bemols",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» no fa parte de garra cifrau conoixiu" },
        tensionNoValida: { tension in "«\(tension)» no ye una tensión válida (s\'admiten ♭/♯ con 5, 9, 11 y 13, y add con 2, 4, 6, 9, 11 y 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» no ye un número d\'acorde (5, 6, 7, 9, 11 u 13)" },
        numeroRepetido: { numero in "«\(numero)» amaneix dimpués d\'atro número; as tensions adicionals van entre paréntesis, como en 7(9)" },
        disminuidoYSemidisminuido: "disminuiu (°) y semidisminuiu (ø) no se pueden combinar",
        quintaConCalidad: "l\'acorde de quinta (5) no leva tercera, asinas que no admite m, °, ø ni +",
        fundamentalNoOmitible: "no se puede omitir a fundamental",
        gradoNoOmitible: { grado in "«omit\(grado)» no ye válido (se pueden omitir 3, 5, 7, 9, 11 y 13)" },
        faltaLaFundamental: "falta a fundamental",
        intervaloSinPapel: { intervalo, notacion in "a \(intervalo.nombre(en: .aragones)) no tiene papel en un acorde per terceras" },
        terceraMayorYMenor: "tiene tercera mayor y menor a l\'ombre (a ♯9 s\'escribe como 9ª aumentada, no como 3ª menor)",
        variasSeptimas: "tiene más d\'una séptima",
        septimaDisminuidaFueraDelDisminuido: "a séptima disminuida nomás amaneix en l\'acorde disminuiu (con 3ª menor y 5ª disminuida)",
        noEsPorTerceras: "no ye un acorde per terceras",
        bajoNoValido: { bajo in "«\(bajo)» no ye un nombre de nota ta o baixo" },
        idiomasMezclados: { nombre in "«\(nombre)» ye escrito en atro idioma que a fundamental: s\'escribe tot en castellano (Sol7/Si) u tot con letras (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» no ye o modo d\'una tonalidat: una tonalidat ye mayor u menor (ta os atros modos, fe servir Escala)" },
        faltaElTipoDeEscala: "falta o tipo d\'escala (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» no ye un tipo d\'escala conoixiu" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor no válido",
        noSePuedeLeer: { texto in "No se puede leyer «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "o texto ye vuedo",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "s\'asperaba un nombre de nota (Do, Re, Mi… u C, D, E…)",
        faltaLaOctava: "falta a octava (per eixemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» no ye una octava válida" },
        faltaElNumeroDeIntervalo: "falta o número de l\'intervalo (per eixemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no ye un número d\'intervalo" },
        faltaLaCalidad: "falta a calidat de l\'intervalo (J, M, m, A u d)",
        calidadNoValida: { resto in "«\(resto)» no ye una calidat d\'intervalo (J, M, m, A u d)" },
        unisonoDisminuido: "no existe l\'unísono disminuiu: de Do a Do♭ bi ha un unísono aumentau descendent (escribe-lo -1A)",
        reglaDeLasJustas: "l\'unísono, a 4ª, a 5ª y a 8ª son chustas, aumentadas u disminuidas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª y a 7ª son mayors, menors, aumentadas u disminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existe a \(numero)ª \(calidad.nombre(en: .aragones)): \(regla.aragones)" },
        alteracionNoReconocida: { signo in "«\(signo)» no ye una alteración (s\'asperaba ♯, ♭, 𝄪, 𝄫, #, b, x u ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» no ye una duración: s\'asperaba una figura (1, 2, 4, 8, 16…, con puntillos: 4.) u una fracción de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» no ye un compás: s\'asperaba numerador/denominador con o denominador potencia de 2 (4/4, 6/8, 7/8), C u ¢" },
        vocesDistintas: "toz os acordes han de tener o mesmo número de voces, y a lo menos dos",
        contrapuntoDeOtraDuracion: { redondas in "o contrapunto ha de durar o mesmo que o cantus firmus: \(redondas) redondas, una por nota" },
        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(ordinal) \(calidad)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
