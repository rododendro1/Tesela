// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en portugués. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let portugues = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "maior",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "diminuta",
        multiplicidadSimple: "",
        multiplicidadDoble: "duplamente ",
        multiplicidadTriple: "triplamente ",
        multiplicidad: { n in "\(n) vezes " },
        plantillaDescendente: "_ descendente",
        consonanciaPerfecta: "consonância perfeita",
        consonanciaImperfecta: "consonância imperfeita",
        disonancia: "dissonância",

        // Nota.swift
        palabraNatural: "bequadro",
        palabraSostenido: "sustenido",
        palabraBemol: "bemol",
        multiplicadores: ["duplo ", "triplo ", "quádruplo "],
        palabraSostenidos: "sustenidos",
        palabraBemoles: "bemóis",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» não faz parte de nenhuma cifra conhecida" },
        tensionNoValida: { tension in "«\(tension)» não é uma tensão válida (admitem-se ♭/♯ com 5, 9, 11 e 13, e add com 2, 4, 6, 9, 11 e 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» não é um número de acorde (5, 6, 7, 9, 11 ou 13)" },
        numeroRepetido: { numero in "«\(numero)» aparece depois de outro número; as tensões adicionais vão entre parênteses, como em 7(9)" },
        disminuidoYSemidisminuido: "diminuto (°) e meio-diminuto (ø) não podem ser combinados",
        quintaConCalidad: "o acorde de quinta (5) não tem terceira, por isso não admite m, °, ø nem +",
        fundamentalNoOmitible: "não se pode omitir a fundamental",
        gradoNoOmitible: { grado in "«omit\(grado)» não é válido (podem omitir-se 3, 5, 7, 9, 11 e 13)" },
        faltaLaFundamental: "falta a fundamental",
        intervaloSinPapel: { intervalo, notacion in "a \(intervalo.nombre(en: .portugues)) não tem papel num acorde por terceiras" },
        terceraMayorYMenor: "tem terceira maior e menor ao mesmo tempo (a ♯9 escreve-se como 9ª aumentada, não como 3ª menor)",
        variasSeptimas: "tem mais de uma sétima",
        septimaDisminuidaFueraDelDisminuido: "a sétima diminuta só aparece no acorde diminuto (com 3ª menor e 5ª diminuta)",
        noEsPorTerceras: "não é um acorde por terceiras",
        bajoNoValido: { bajo in "«\(bajo)» não é um nome de nota para o baixo" },
        idiomasMezclados: { nombre in "«\(nombre)» está escrito noutro idioma que a fundamental: escreve-se tudo com sílabas (Sol7/Si) ou tudo com letras (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» não é o modo de uma tonalidade: uma tonalidade é maior ou menor (para os outros modos, use Escala)" },
        faltaElTipoDeEscala: "falta o tipo de escala (maior, dórico, menor harmónica…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» não é um tipo de escala conhecido" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor inválido",
        noSePuedeLeer: { texto in "Não é possível ler «\(texto)»" },
        caracter: { p in " (caractere \(p + 1))" },
        textoVacio: "o texto está vazio",
        caracteresSobrantes: { resto in "sobra «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "esperava-se um nome de nota (Do, Re, Mi… ou C, D, E…)",
        faltaLaOctava: "falta a oitava (por exemplo, Do4)",
        octavaNoValida: { resto in "«\(resto)» não é uma oitava válida" },
        faltaElNumeroDeIntervalo: "falta o número do intervalo (por exemplo, 3M)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» não é um número de intervalo" },
        faltaLaCalidad: "falta a qualidade do intervalo (J, M, m, A ou d)",
        calidadNoValida: { resto in "«\(resto)» não é uma qualidade de intervalo (J, M, m, A ou d)" },
        unisonoDisminuido: "não existe o uníssono diminuto: de Dó a Dó♭ há um uníssono aumentado descendente (escreva -1A)",
        reglaDeLasJustas: "o uníssono, a 4ª, a 5ª e a 8ª são justas, aumentadas ou diminutas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª e a 7ª são maiores, menores, aumentadas ou diminutas",
        intervaloInexistente: { numero, calidad, notacion, regla in "não existe a \(numero)ª \(calidad.nombre(en: .portugues)): \(regla.portugues)" },
        alteracionNoReconocida: { signo in "«\(signo)» não é uma alteração (esperava-se ♯, ♭, 𝄪, 𝄫, #, b, x ou ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» não é uma duração: esperava-se uma figura (1, 2, 4, 8, 16…, pontuada: 4.) ou uma fração de semibreve (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» não é um compasso: esperava-se numerador/denominador com o denominador potência de 2 (4/4, 6/8, 7/8), C ou ¢" },
        vocesDistintas: "todos os acordes têm de ter o mesmo número de vozes, e pelo menos duas",
        contrapuntoDeOtraDuracion: { redondas in "o contraponto tem de durar o mesmo que o cantus firmus: \(redondas) semibreves, uma por nota" }
    )
}
