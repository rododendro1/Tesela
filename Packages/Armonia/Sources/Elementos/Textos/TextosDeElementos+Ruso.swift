// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
// Los textos de Elementos en ruso. Los campos y lo que significa cada uno están en
// `TextosDeElementos.swift`.

extension TextosDeElementos {
    static let ruso = TextosDeElementos(
        // Intervalo.swift
        calidadJusta: "чистая",
        calidadMayor: "большая",
        calidadMenor: "малая",
        calidadAumentada: "увеличенная",
        calidadDisminuida: "уменьшённая",
        multiplicidadSimple: "",
        multiplicidadDoble: "дважды ",
        multiplicidadTriple: "трижды ",
        multiplicidad: "{1} раз ",
        plantillaDescendente: "нисходящая {1}",
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

        // ErrorDeLectura.swift (generales)
        valorNoValido: "Недопустимое значение",
        noSePuedeLeer: "Не удаётся прочитать «{1}»",
        caracter: { p in " (символ \(p + 1))" },
        textoVacio: "текст пуст",
        caracteresSobrantes: "лишнее «{1}»",

        // ErrorDeLectura.swift (notas)
        notaNoReconocida: "ожидалось название ноты (до, ре, ми… или C, D, E…)",
        faltaLaOctava: "не указана октава (например, до4)",
        octavaNoValida: "«{1}» — недопустимая октава",
        faltaElNumeroDeIntervalo: "не указан номер интервала (например, M3)",
        numeroDeIntervaloNoValido: "«{1}» — не номер интервала",
        faltaLaCalidad: "не указано качество интервала (P, M, m, A или d)",
        calidadNoValida: "«{1}» — не качество интервала (P, M, m, A или d)",
        unisonoDisminuido: "уменьшённой примы не существует: от до до до-бемоль — нисходящая увеличенная прима (пиши -A1)",
        reglaDeLasJustas: "прима, кварта, квинта и октава бывают чистыми, увеличенными или уменьшёнными",
        reglaDeLasMayores: "секунда, терция, секста и септима бывают большими, малыми, увеличенными или уменьшёнными",
        intervaloInexistente: { numero, calidad, notacion, regla in "«\(calidad.nombre(en: .conPalabras(.ruso))) \(Intervalo.ordinal(numero, en: .ruso))» не существует: \(regla.texto(en: .ruso))" },
        alteracionNoReconocida: "«{1}» — не знак альтерации (ожидалось ♯, ♭, 𝄪, 𝄫, #, b, x или ♮)",

        // ErrorDeLectura.swift (conjuntos y series)
        claseDeAlturaNoValida: "«{1}» — не звуковысотный класс (от 0 до 11, или t и e для 10 и 11) и не название ноты",
        numeroDeForteDesconocido: "«{1}» — не номер Форта (например, 3-11 или 4-Z15)",
        faltaElCierre: "не хватает закрывающего «{1}»",
        serieNoDodecafonica: "в двенадцатитоновой серии есть все двенадцать звуковысотных классов, каждый по одному разу",
        faltanEnLaSerie: "не хватает {1}",
        repetidasEnLaSerie: "повторяются {1}",
        // ErrorDeLectura.swift (idiomas)
        idiomaNoReconocido: "«{1}» — ни один из тринадцати языков: {2}",

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: "{1} {2}",
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["прима", "секунда", "терция", "кварта", "квинта", "секста", "септима", "октава", "нона", "децима", "ундецима", "дуодецима", "терцдецима", "квартдецима", "двойная октава"],
        ordinalEnCifras: { n in "\(n)-я" },
        dosPuntos: ": "
    )
}
