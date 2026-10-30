// Los textos de ArmoniaNucleo en español. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let espanol = TextosDeNucleo(
        // Intervalo+Idiomas.swift
        calidadJusta: "justa",
        calidadMayor: "mayor",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "disminuida",
        multiplicidadSimple: "",
        multiplicidadDoble: "doble ",
        multiplicidadTriple: "triple ",
        multiplicidad: { n in "\(n) veces " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonancia perfecta",
        consonanciaImperfecta: "consonancia imperfecta",
        disonancia: "disonancia",

        // Nota+Idiomas.swift
        palabraNatural: "natural",
        palabraSostenido: "sostenido",
        palabraBemol: "bemol",
        multiplicadores: ["doble ", "triple ", "cuádruple "],
        palabraSostenidos: "sostenidos",
        palabraBemoles: "bemoles",

        // ErrorDeLectura+Acordes.swift
        simboloNoReconocido: { simbolo in "«\(simbolo)» no forma parte de ningún cifrado conocido" },
        tensionNoValida: { tension in "«\(tension)» no es una tensión válida (se admiten ♭/♯ con 5, 9, 11 y 13, y add con 2, 4, 6, 9, 11 y 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» no es un número de acorde (5, 6, 7, 9, 11 o 13)" },
        numeroRepetido: { numero in "«\(numero)» aparece después de otro número; las tensiones adicionales van entre paréntesis, como en 7(9)" },
        disminuidoYSemidisminuido: "disminuido (°) y semidisminuido (ø) no pueden combinarse",
        quintaConCalidad: "el acorde de quinta (5) no lleva tercera, así que no admite m, °, ø ni +",
        fundamentalNoOmitible: "no se puede omitir la fundamental",
        gradoNoOmitible: { grado in "«omit\(grado)» no es válido (se pueden omitir 3, 5, 7, 9, 11 y 13)" },
        faltaLaFundamental: "falta la fundamental",
        intervaloSinPapel: { intervalo, notacion in "la \(intervalo.nombre) no tiene papel en un acorde por terceras" },
        terceraMayorYMenor: "tiene tercera mayor y menor a la vez (la ♯9 se escribe como 9ª aumentada, no como 3ª menor)",
        variasSeptimas: "tiene más de una séptima",
        septimaDisminuidaFueraDelDisminuido: "la séptima disminuida sólo aparece en el acorde disminuido (con 3ª menor y 5ª disminuida)",
        noEsPorTerceras: "no es un acorde por terceras",
        bajoNoValido: { bajo in "«\(bajo)» no es un nombre de nota para el bajo" },
        idiomasMezclados: { nombre in "«\(nombre)» está escrito en otro idioma que la fundamental: se escribe todo en español (Sol7/Si) o todo con letras (G7/B)" },

        // ErrorDeLectura+Escalas.swift
        modoNoReconocido: { nombre in "«\(nombre)» no es el modo de una tonalidad: una tonalidad es mayor o menor (para los demás modos, usa Escala)" },
        faltaElTipoDeEscala: "falta el tipo de escala (mayor, dórico, menor armónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» no es un tipo de escala conocido" },

        // ErrorDeLectura+Idiomas.swift
        valorNoValido: "Valor no válido",
        noSePuedeLeer: { texto in "No se puede leer «\(texto)»" },
        caracter: { p in " (carácter \(p + 1))" },
        textoVacio: "el texto está vacío",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura+Notas.swift
        notaNoReconocida: "se esperaba un nombre de nota (Do, Re, Mi… o C, D, E…)",
        faltaLaOctava: "falta la octava (por ejemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» no es una octava válida" },
        faltaElNumeroDeIntervalo: "falta el número del intervalo (por ejemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» no es un número de intervalo" },
        faltaLaCalidad: "falta la calidad del intervalo (J, M, m, A o d)",
        calidadNoValida: { resto in "«\(resto)» no es una calidad de intervalo (J, M, m, A o d)" },
        unisonoDisminuido: "no existe el unísono disminuido: de Do a Do♭ hay un unísono aumentado descendente (escríbelo -1A)",
        reglaDeLasJustas: "el unísono, la 4ª, la 5ª y la 8ª son justas, aumentadas o disminuidas",
        reglaDeLasMayores: "la 2ª, la 3ª, la 6ª y la 7ª son mayores, menores, aumentadas o disminuidas",
        intervaloInexistente: { numero, calidad, notacion, regla in "no existe la \(numero)ª \(calidad.nombre): \(regla.espanol)" },
        alteracionNoReconocida: { signo in "«\(signo)» no es una alteración (se esperaba ♯, ♭, 𝄪, 𝄫, #, b, x o ♮)" },

        // ErrorDeLectura+Partitura.swift
        duracionNoValida: { texto in "«\(texto)» no es una duración: se esperaba una figura (1, 2, 4, 8, 16…, con puntillos: 4.) o una fracción de redonda (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» no es un compás: se esperaba numerador/denominador con el denominador potencia de 2 (4/4, 6/8, 7/8), C o ¢" },
        vocesDistintas: "todos los acordes tienen que tener el mismo número de voces, y al menos dos",
        contrapuntoDeOtraDuracion: { redondas in "el contrapunto tiene que durar lo mismo que el cantus firmus: \(redondas) redondas, una por nota" }
    )
}
