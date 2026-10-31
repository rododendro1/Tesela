// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de ArmoniaNucleo en ruso. Los campos y lo que significa cada uno están en
// `TextosDeNucleo.swift`.

extension TextosDeNucleo {
    static let ruso = TextosDeNucleo(
        // Intervalo.swift
        calidadJusta: "чистая",
        calidadMayor: "большая",
        calidadMenor: "малая",
        calidadAumentada: "увеличенная",
        calidadDisminuida: "уменьшённая",
        multiplicidadSimple: "",
        multiplicidadDoble: "дважды ",
        multiplicidadTriple: "трижды ",
        multiplicidad: { n in "\(n) раз " },
        plantillaDescendente: "нисходящая _",
        consonanciaPerfecta: "совершенный консонанс",
        consonanciaImperfecta: "несовершенный консонанс",
        disonancia: "диссонанс",

        // Nota.swift
        palabraNatural: "бекар",
        palabraSostenido: "диез",
        palabraBemol: "бемоль",
        multiplicadores: ["дубль-", "тройной ", "четверной "],
        palabraSostenidos: "диезов",
        palabraBemoles: "бемолей",

        // ErrorDeLectura.swift (acordes)
        simboloNoReconocido: { simbolo in "«\(simbolo)» не входит ни в одно известное буквенное обозначение" },
        tensionNoValida: { tension in "«\(tension)» — недопустимая альтерация или добавленный тон (♭/♯ — с 5, 9, 11 и 13, add — с 2, 4, 6, 9, 11 и 13)" },
        numeroDeAcordeNoValido: { numero in "«\(numero)» — не число аккорда (5, 6, 7, 9, 11 или 13)" },
        numeroRepetido: { numero in "«\(numero)» стоит после другого числа; дополнительные тоны пишутся в скобках, как в 7(9)" },
        disminuidoYSemidisminuido: "уменьшённый (°) и полууменьшённый (ø) нельзя совмещать",
        quintaConCalidad: "в квинтовом созвучии (5) нет терции, поэтому к нему нельзя добавить m, °, ø или +",
        fundamentalNoOmitible: "основной тон нельзя опустить",
        gradoNoOmitible: { grado in "«omit\(grado)» недопустимо (опустить можно 3, 5, 7, 9, 11 и 13)" },
        faltaLaFundamental: "нет основного тона",
        intervaloSinPapel: { intervalo, notacion in "\(intervalo.nombre(en: .ruso)) не играет роли в аккорде терцового строения" },
        terceraMayorYMenor: "в нём одновременно большая и малая терция (♯9 пишется как увеличенная нона, а не как малая терция)",
        variasSeptimas: "в нём больше одной септимы",
        septimaDisminuidaFueraDelDisminuido: "уменьшённая септима встречается только в уменьшённом аккорде (с малой терцией и уменьшённой квинтой)",
        noEsPorTerceras: "это не аккорд терцового строения",
        bajoNoValido: { bajo in "«\(bajo)» — не название ноты для баса" },
        idiomasMezclados: { nombre in "«\(nombre)» записано не на том языке, что основной тон: пиши всё слогами (Sol7/Si) или всё буквами (G7/B)" },

        // ErrorDeLectura.swift (escalas)
        modoNoReconocido: { nombre in "«\(nombre)» — не лад тональности: тональность бывает мажорной или минорной (для других ладов используй Escala)" },
        faltaElTipoDeEscala: "не указан тип гаммы (мажор, дорийский, гармонический минор…)",
        tipoDeEscalaNoReconocido: { nombre in "«\(nombre)» — неизвестный тип гаммы" },

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Недопустимое значение",
        noSePuedeLeer: { texto in "Не удаётся прочитать «\(texto)»" },
        caracter: { p in " (символ \(p + 1))" },
        textoVacio: "текст пуст",
        caracteresSobrantes: { resto in "лишнее «\(resto)»" },

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "ожидалось название ноты (до, ре, ми… или C, D, E…)",
        faltaLaOctava: "не указана октава (например, до4)",
        octavaNoValida: { resto in "«\(resto)» — недопустимая октава" },
        faltaElNumeroDeIntervalo: "не указан номер интервала (например, M3)",
        numeroDeIntervaloNoValido: { resto in "«\(resto)» — не номер интервала" },
        faltaLaCalidad: "не указано качество интервала (P, M, m, A или d)",
        calidadNoValida: { resto in "«\(resto)» — не качество интервала (P, M, m, A или d)" },
        unisonoDisminuido: "уменьшённой примы не существует: от до до до-бемоль — нисходящая увеличенная прима (пиши -A1)",
        reglaDeLasJustas: "прима, кварта, квинта и октава бывают чистыми, увеличенными или уменьшёнными",
        reglaDeLasMayores: "секунда, терция, секста и септима бывают большими, малыми, увеличенными или уменьшёнными",
        intervaloInexistente: { numero, calidad, notacion, regla in "«\(calidad.nombre(en: .ruso)) \(Intervalo.ordinal(numero, en: .ruso))» не существует: \(regla.ruso)" },
        alteracionNoReconocida: { signo in "«\(signo)» — не знак альтерации (ожидалось ♯, ♭, 𝄪, 𝄫, #, b, x или ♮)" },

        // ErrorDeLectura.swift (partitura)
        duracionNoValida: { texto in "«\(texto)» — не длительность: ожидалась нота (1, 2, 4, 8, 16…, с точкой: 4.) или доля целой (3/8, 1/12)" },
        compasNoValido: { texto in "«\(texto)» — не размер: ожидалось числитель/знаменатель, где знаменатель — степень двойки (4/4, 6/8, 7/8), C или ¢" },
        vocesDistintas: "во всех аккордах должно быть одинаковое число голосов, не меньше двух",
        contrapuntoDeOtraDuracion: { redondas in "контрапункт должен длиться столько же, сколько cantus firmus: \(redondas) целых, по одной на ноту" }
    )
}
