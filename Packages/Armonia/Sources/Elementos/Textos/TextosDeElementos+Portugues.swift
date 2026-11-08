// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en portugués. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let portugues = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "justa",
        calidadMayor: "maior",
        calidadMenor: "menor",
        calidadAumentada: "aumentada",
        calidadDisminuida: "diminuta",
        multiplicidadSimple: "",
        multiplicidadDoble: "duplamente ",
        multiplicidadTriple: "triplamente ",
        multiplicidad: "{1} vezes ",
        plantillaDescendente: "{1} descendente",
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

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Valor inválido",
        noSePuedeLeer: "Não é possível ler «{1}»",
        caracter: { p in " (caractere \(p + 1))" },
        textoVacio: "o texto está vazio",
        caracteresSobrantes: "sobra «{1}»",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "esperava-se um nome de nota (Do, Re, Mi… ou C, D, E…)",
        faltaLaOctava: "falta a oitava (por exemplo, Do4)",
        octavaNoValida: "«{1}» não é uma oitava válida",
        faltaElNumeroDeIntervalo: "falta o número do intervalo (por exemplo, 3M)",
        numeroDeIntervaloNoValido: "«{1}» não é um número de intervalo",
        faltaLaCalidad: "falta a qualidade do intervalo (J, M, m, A ou d)",
        calidadNoValida: "«{1}» não é uma qualidade de intervalo (J, M, m, A ou d)",
        unisonoDisminuido: "não existe o uníssono diminuto: de Dó a Dó♭ há um uníssono aumentado descendente (escreva -1A)",
        reglaDeLasJustas: "o uníssono, a 4ª, a 5ª e a 8ª são justas, aumentadas ou diminutas",
        reglaDeLasMayores: "a 2ª, a 3ª, a 6ª e a 7ª são maiores, menores, aumentadas ou diminutas",
        intervaloInexistente: { numero, calidad, notacion, regla in "não existe a \(numero)ª \(calidad.nombre(en: .conPalabras(.portugues))): \(regla.texto(en: .portugues))" },
        alteracionNoReconocida: "«{1}» não é uma alteração (esperava-se ♯, ♭, 𝄪, 𝄫, #, b, x ou ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» não é uma classe de altura (de 0 a 11, ou t e e para o 10 e o 11) nem um nome de nota",
        numeroDeForteDesconocido: "«{1}» não é um número de Forte (por exemplo, 3-11 ou 4-Z15)",
        faltaElCierre: "falta o «{1}» do final",
        serieNoDodecafonica: "uma série dodecafónica tem as doze classes de altura, cada uma uma vez",
        faltanEnLaSerie: "faltam {1}",
        repetidasEnLaSerie: "repetem-se {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» não é nenhuma das treze línguas: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{2} {1}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: [],
        ordinalEnCifras: { n in "\(n)ª" },
        dosPuntos: ": "
    )
}
