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
        intervaloInexistente: { numero, calidad, notacion, regla in "«\(calidad.nombre(en: .rusoPalabras)) \(Intervalo.ordinal(numero, en: .ruso))» не существует: \(regla.ruso)" },
        alteracionNoReconocida: { signo in "«\(signo)» — не знак альтерации (ожидалось ♯, ♭, 𝄪, 𝄫, #, b, x или ♮)" },

        // Gramática (Intervalo.swift, ErrorDeLectura.swift)
        nombreDeIntervalo: { calidad, ordinal in "\(calidad) \(ordinal)" },
        unisonoEnMasculino: { calidad in calidad },
        ordinales: ["прима", "секунда", "терция", "кварта", "квинта", "секста", "септима", "октава", "нона", "децима", "ундецима", "дуодецима", "терцдецима", "квартдецима", "двойная октава"],
        ordinalEnCifras: { n in "\(n)-я" },
        dosPuntos: ": "
    )
}
