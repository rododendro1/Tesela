// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en ruso. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let ruso = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <аккорды> [--in <тональность>]",
        descripcionAnalizar: "римские цифры, функции, кадансы и\nмодуляции (с общим аккордом; без --in)",
        sintaxisAnalizarArchivo: "analyze --file <файл> [--window <длительность>]",
        descripcionAnalizarArchivo: "то же самое с аккордами файла MIDI\nили MusicXML (по одному на долю;\n--window 2: по одному на половинную)",
        sintaxisArmonizar: "harmonize <мелодия> [--in <тональность>] [--proposals 3]",
        descripcionArmonizar: "аккорды для мелодии, лучшие первыми; с\nоктавами (E4) — ещё и четырёхголосный\nхорал",
        sintaxisRealizar: "realize <аккорды> [--in <тональность>]",
        descripcionRealizar: "аккорды в четырёхголосии, без ошибок\nголосоведения",
        sintaxisRevisar: "check <аккорды>",
        descripcionRevisar: "ошибки голосоведения (параллельные\nквинты…); аккорды снизу вверх, через\nзапятую",
        sintaxisContrapunto: "counterpoint <cantus> / <контрапункт> [--species 1]",
        descripcionContrapunto: "ошибки в строгом контрапункте (виды\n1–5) над cantus firmus целыми; ноты\nбез длительности получают\nдлительность вида",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <обозначение>…",
        descripcionAcorde: "ноты, тип и роль каждой ноты",
        sintaxisArpegio: "arpeggio <обозначение> [--pattern <рисунок>]",
        descripcionArpegio: "ноты арпеджио и подходящие гаммы\n(--pattern ascending, descending,\nup-down, alberti)",
        sintaxisIdentificar: "identify <ноты>",
        descripcionIdentificar: "аккорды, которые образуют ноты",
        sintaxisIntervalo: "interval <нота> <нота>",
        descripcionIntervalo: "интервал между двумя нотами или\nвысотами",
        sintaxisEscala: "scale <гамма>",
        descripcionEscala: "ноты и аккорды гаммы",
        sintaxisTonalidad: "key <тональность>",
        descripcionTonalidad: "ключевые знаки, родственные\nтональности и ступени",

        // Ayuda+Dibujos.swift
        sintaxisTonnetz: "tonnetz <ноты>",
        descripcionTonnetz: "Tonnetz в SVG для нот",
        sintaxisTonnetzAcorde: "tonnetz --chord <обозначение> | --scale <гамма> | --pcs <числа>",
        descripcionTonnetzAcorde: "для аккорда, гаммы или множества\nзвуковысотных классов",
        sintaxisTonnetzRecorrido: "tonnetz --sequence <трезвучия> | --shortest <трезвучие> <трезвучие>",
        descripcionTonnetzRecorrido: "последовательность трезвучий со\nстрелками или кратчайший путь через P,\nL и R",
        sintaxisTonnetzCiclo: "tonnetz --cycle <цикл> <трезвучие>",
        descripcionTonnetzCiclo: "гексатонический, октатонический или\nLR-цикл",
        notasTonnetzCiclo: "(--margen 2: больше сетки вокруг)",
        sintaxisTabla: "tabla <ноты или высоты>",
        descripcionTabla: "гармоническая таблица в SVG\n(шестиугольники)",
        sintaxisTablaAcorde: "tabla --chord | --scale | --pcs | --sequence | --shortest | --cycle",
        descripcionTablaAcorde: "как в Tonnetz (--margen 2: больше\nтаблицы вокруг)",

        // Ayuda+Neorriemann.swift
        sintaxisVecinos: "neighbors <аккорд> [--voices 2]",
        descripcionVecinos: "аккорды на расстоянии полутона\n(септаккорды: доминантовый, малый\nминорный, полууменьшённый и\nуменьшённый; трезвучия: мажорное,\nминорное и увеличенное; maj7 — среди\nсептаккордов и maj7; --extended: и с\nmaj7)",
        sintaxisConduccionParsimoniosa: "smooth-path <аккорд> <аккорд> [--voices 2] [--extended]",
        descripcionConduccionParsimoniosa: "от одного аккорда к другому, двигая на\nкаждом шаге один голос (или два) на\nполутон",
        sintaxisConduccionMinima: "minimal-voice-leading <аккорд> <аккорд>",
        descripcionConduccionMinima: "голосоведение с наименьшим числом\nполутонов",
        sintaxisPlr: "plr <трезвучие> <P, L, R…>",
        descripcionPlr: "неоримановские преобразования",
        sintaxisPlrCamino: "plr <трезвучие> <трезвучие>",
        descripcionPlrCamino: "кратчайший путь через P, L и R",
        sintaxisPlrCiclo: "plr <трезвучие> <цикл>",
        descripcionPlrCiclo: "цикл: hexatonic (P, L), octatonic (P,\nR) или \"LR cycle\"",

        // Ayuda+Partituras.swift
        sintaxisMusicxmlMelodia: "musicxml melody <события> [параметры]",
        descripcionMusicxmlMelodia: "партитура MusicXML для мелодии",
        sintaxisMusicxmlCoral: "musicxml chorale <аккорды> [параметры]",
        descripcionMusicxmlCoral: "четырёхголосный хорал в MusicXML",
        sintaxisMusicxmlAcordes: "musicxml chords <обозначения> [параметры]",
        descripcionMusicxmlAcordes: "последовательность с обозначениями и\nанализом",
        notasMusicxmlAcordes: "параметры: --compas 6/8 (размер), --anacrusa 8 (затакт),\n--tonalidad G major (тональность), --clave fa (ключ), --tempo 90\n(или --tempo 60 4.), --titulo Мой хорал (название), --duracion 2\n(длительность каждого аккорда; по умолчанию четверть в хорале и\nполовинная в аккордах), --cifrados и --analisis (в хорале:\nобозначения сверху, ступени и функции снизу)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <обозначения> [параметры]",
        descripcionMusicxmlArpegios: "аккорды арпеджио, нота за нотой",
        notasMusicxmlArpegios: "параметры: --patron alberti (или up, down, up-down), --figura 16\n(длительность каждой ноты; по умолчанию восьмая), --duracion 1\n(длительность каждого аккорда: рисунок повторяется, пока не\nзаполнит его) и остальные параметры «chords»",
        sintaxisMusicxmlArchivo: "musicxml chords --file <файл>",
        descripcionMusicxmlArchivo: "последовательность из файла MIDI или\nMusicXML с длительностью каждого\nаккорда (также arpeggios, mei, midi)",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios <…> [параметры]",
        descripcionMeiMelodia: "то же самое в MEI 5, формате\nкритических изданий (с теми же\nпараметрами)",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios <…> [параметры]",
        descripcionMidiMelodia: "то же самое в виде файла MIDI, чтобы\nпослушать (без --clave и --cifrados; с\n--program 0…127, General MIDI)",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <обозначение>… [параметры]",
        descripcionDigitaciones: "способы сыграть аккорд, от самого удобного к наименее удобному,\nна струнном инструменте с ладами (струны снизу вверх)\nпараметры: --instrument guitar|bass|ukulele|mandolin|… (также\n\"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5,\n--fret 12 (самый высокий используемый лад), --fingers 4 (сколько\nпальцев можно использовать), --complete (со всеми нотами: по\nумолчанию квинта может отсутствовать), --diagram (одна строка на\nструну)",
        sintaxisPosiciones: "positions <гамма> [--caged]",
        descripcionPosiciones: "гамма по позициям на гитаре: три\nноты на струну (две в пентатонике)\nили CAGED",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: теория музыки в командной строке.

        Использование: armonia <команда> <аргументы> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru]

        Команды (команды и параметры пишутся по-испански или по-английски):
        """,
        pieDeLaAyuda: """
        Названия нот принимаются по-испански, по-английски, по-русски и на других языках
        (Do, C, Sib, Bb, до, си-бемоль). С --idioma ru ответ использует русскую нотацию и русские
        сообщения; с --ingles — английские.
        С --textos тексты выводятся на другом языке, чем ноты: --idioma en --textos ru.
        По-испански и по-английски --escritura palabras|ascii|unicode пишет ноты как Fa sostenido,
        Fa# или Fa♯ (по-английски F sharp, F# или F♯).
        """,
        sintaxisAyuda: "help",
        descripcionAyuda: "эта справка",

        // ErrorDeUso+Armonizacion.swift
        faltanAcordesDeLasVoces: { ejemplo in "не указаны аккорды: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "нужны два аккорда: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "не указаны ноты мелодии: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "--proposals — от 1 до 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "не указаны cantus firmus и контрапункт, через /: " + ingles },
        especieFueraDeRango: "--species — от 1 до 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "не указаны аккорды: armonia realize C F G7 C" },

        // ErrorDeUso+Consultas.swift
        faltaCifrado: "не указано обозначение аккорда: armonia chord G7",
        faltaCifradoDelArpegio: "не указано обозначение аккорда: armonia arpeggio C7",
        patronDesconocido: { patron in "неизвестный рисунок: «\(patron)» (ascending, descending, up-down или alberti)" },
        faltanNotas: "не указаны ноты: armonia identify C E G",
        dosNotas: "нужны две ноты: armonia interval C E",
        faltaEscala: "не указана гамма: armonia scale D dorian",
        faltaTonalidad: "не указана тональность: armonia key A minor",
        faltaTonalidadTrasEn: "не указана тональность после --in",
        faltanAcordesDelAnalisis: { ejemplo in "не указаны аккорды: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "не удаётся прочитать файл «\(nombre)»" },
        archivoConAcordes: "с --file аккорды не указываются",
        archivoSinAcordes: "в файле нет аккордов",

        // ErrorDeUso+Dibujos.swift
        margenFueraDeRango: "поле — число от 0 до 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "не указаны ноты: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "не указан аккорд: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "не указана гамма: armonia \(orden) --scale D dorian" },
        clasesFueraDeRango: { ejemplo, orden in "звуковысотные классы — числа от 0 до 11: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "не указаны трезвучия: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "цикл — гексатонический, октатонический или LR, от трезвучия: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "последовательность — из мажорных и минорных трезвучий: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "кратчайший путь идёт от одного мажорного или минорного трезвучия к другому: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "цикл начинается с мажорного или минорного трезвучия: armonia \(orden) --cycle hexatonic C" },

        // ErrorDeUso+Neorriemann.swift
        vocesFueraDeRango: "движутся 1 или 2 голоса: --voices 2",
        unAcordeDeVecinos: { ejemplo in "нужен один аккорд: armonia neighbors G7" },
        vecinosSinFamilia: "соседи ищутся среди доминантсептаккордов, малых минорных, малых и уменьшённых септаккордов и maj7 или среди мажорных, минорных и увеличенных трезвучий",
        dosAcordesDeCamino: { ejemplo in "нужны два аккорда: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "оба аккорда должны быть из одного семейства (септаккорды, с maj7 или без, или трезвучия) и быть связаны",
        faltanPasosDePLR: { ejemplo in "нужны трезвучие и шаги или другое трезвучие: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "P, L и R применяются к мажорным и минорным трезвучиям: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso+Partituras.swift
        faltaTipoDePartitura: { ejemplo, orden in "не указано «melody», «chorale» или «chords»: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "программа — номер General MIDI от 0 до 127: --program 52",
        marcasSoloMusicXML: "--cifrados и --analisis — только для MusicXML и MEI",
        faltaValor: { opcion in "не указано значение --\(opcion)" },
        tempoMalEscrito: "темп пишется «--tempo 90» или «--tempo 60 4.»",
        faltanNotasDeLaMelodia: { ejemplo, orden in "не указаны ноты: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        marcasSoloCoral: "--cifrados и --analisis — только для «chorale»",
        duracionSoloCoral: "--duracion — только для «chorale»",
        claveDesconocida: { clave, claves in "неизвестный ключ: «\(clave)» (treble, bass, alto, tenor, sol, fa, do1, do2, do3, do4, sol8b, sol8a, fa3)" },
        faltanAcordesDelCoral: { ejemplo, orden in "не указаны аккорды: armonia \(orden) chorale C3 E4 G4 C5, G2 D4 G4 B4" },
        soloParaMelodia: { opcion in "--\(opcion) — только для «melody»" },
        soloParaArpegios: { opcion in "--\(opcion) — только для «arpeggios»" },
        archivoSoloParaAcordes: "--file — только для «chords» и «arpeggios»",
        ventanaSinArchivo: "--window используется с --file",
        faltanAcordesDeLaProgresion: { ejemplo, orden in "не указаны аккорды: armonia \(orden) chords C Am D7 G7 C" },
        acordesConCifradosYAnalisis: "аккорды всегда выводятся с обозначениями и анализом",
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: экспортируется «melody», «chorale», «chords» или их «arpeggios»" },

        // ErrorDeUso+Trastes.swift
        faltaInstrumento: { d, digitaciones in "не указан инструмент: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "неизвестный инструмент: «\(nombre)» (\(lista(.ruso)))" },
        faltaLimite: "не указано число аппликатур: --limit 5",
        limiteFueraDeRango: "предел — число от 1 до 200: --limit 5",
        faltanDedos: "не указано число пальцев: --fingers 3",
        dedosFueraDeRango: "число пальцев — от 1 до 4: --fingers 3",
        faltaTraste: "не указан самый высокий лад: --fret 12",
        trasteFueraDeRango: "самый высокий лад — число от 0 до 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "не указано обозначение аккорда: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "не указана гамма: armonia positions G major",

        // ErrorDeUso.swift
        pruebaLaAyuda: "Попробуй «armonia help».",
        ordenDesconocida: { orden in "неизвестная команда: «\(orden)»" },
        opcionDesconocida: { opcion in "неизвестный параметр: «\(opcion)»" },
        idiomaDesconocido: { idioma in "неизвестный язык: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el или ru)" },
        escrituraNoValida: { escritura in "недопустимое написание: «\(escritura)» (palabras/words, ascii или unicode; только с es и en)" },

        // Mensaje.swift
        mensajeNotas: "ноты",
        mensajeAcordes: "аккорды",
        mensajeEscalas: "гаммы",
        mensajeArmadura: "ключевые знаки",
        mensajeRelativa: "параллельная",
        mensajeHomonima: "одноимённая",
        mensajeBajo: { nota in "бас \(nota)" },
        mensajeBajoAjeno: "бас не из аккорда",
        mensajeSinAcordes: "Известный аккорд не найден.",
        mensajeSin: { notas in "без \(notas)" },
        mensajeSemitonos: { n in Traduccion.pluralRuso(n, "полутон", "полутона", "полутонов") },
        mensajeSinAlteraciones: "без знаков",
        mensajeSostenidos: { n in Traduccion.pluralRuso(n, "диез", "диеза", "диезов") },
        mensajeBemoles: { n in Traduccion.pluralRuso(n, "бемоль", "бемоля", "бемолей") },
        mensajeACuatroVoces: "В четырёхголосии (бас, тенор, альт, сопрано):",
        mensajeSinDigitaciones: "удобных аппликатур нет",
        mensajeDedos: { n in Traduccion.pluralRuso(n, "палец", "пальца", "пальцев") },
        mensajeCejilla: { traste in "баррэ на \(traste)-м ладу" },
        mensajeNingunPaso: "ни одного шага",
        mensajeUnPaso: "1 шаг",
        mensajePasos: { n in Traduccion.pluralRuso(n, "шаг", "шага", "шагов") },
        mensajeTriadas: { n in Traduccion.pluralRuso(n, "трезвучие", "трезвучия", "трезвучий") }
    )
}
