// swift-format-ignore-file
// Tabla de datos, una fila por línea, como la leen los scripts de Scripts/: no se formatea.
import Armonia
// Los textos de ArmoniaCLI en ruso. Los campos y lo que significa cada uno están en
// `TextosDeCLI.swift`.

extension TextosDeCLI {
    static let ruso = TextosDeCLI(
        // Ayuda+Armonizacion.swift
        sintaxisAnalizar: "analyze <аккорды> [--in <тональность>] [--scales]",
        descripcionAnalizar: "римские цифры, функции, кадансы и\nмодуляции (с общим аккордом; без --in)\n--scales: лад каждого аккорда, с\nнапряжениями и избегаемыми звуками",
        notasAnalizar: "--guide-tones: две линии направляющих нот,\nот терции и от септимы",
        sintaxisAnalizarArchivo: "analyze --file <файл> [--window <длительность>]",
        descripcionAnalizarArchivo: "то же самое с аккордами файла MIDI,\nMusicXML, MEI или ABC (по одному на\nдолю; --window 2: по одному на\nполовинную)",
        sintaxisArmonizar: "harmonize <мелодия> [--in <тональность>] [--proposals 3]",
        descripcionArmonizar: "аккорды для мелодии, лучшие первыми; с\nоктавами (E4) — ещё и четырёхголосный\nхорал",
        sintaxisRealizar: "realize <аккорды> [--in <тональность>]",
        descripcionRealizar: "аккорды в четырёхголосии, без ошибок\nголосоведения",
        sintaxisRevisar: "check <аккорды>",
        descripcionRevisar: "ошибки голосоведения (параллельные\nквинты…); аккорды снизу вверх, через\nзапятую",
        sintaxisContrapunto: "counterpoint <cantus> / <контрапункт> [--species 1]",
        descripcionContrapunto: "ошибки в строгом контрапункте (виды\n1–5) над cantus firmus целыми; ноты\nбез длительности получают\nдлительность вида",
        sintaxisTransponer: "transpose <интервал|тоника> <аккорды или ноты>",
        descripcionTransponer: "переносит аккорды, мелодию или хорал\nв другую тональность: интервал (M2,\n-m3) или новая тоника (D)",
        sintaxisRearmonizar: "reharmonize <аккорды> [--in <тональность>]",
        descripcionRearmonizar: "другие гармонии для каждого аккорда:\nтритоновая замена, побочные\nдоминанты, модальное заимствование и\nдиатонические замены",

        // Ayuda+Consultas.swift
        sintaxisAcorde: "chord <обозначение>…",
        descripcionAcorde: "ноты, тип и роль каждой ноты",
        notasAcorde: "параметры: --voicings, --names, --keys, --substitutions\n(в тональности --in C major, в конце) и --compare C\n(общие ноты и голосоведение); --bebop и --pentatonics\n(гаммы для импровизации)",
        sintaxisArpegio: "arpeggio <обозначение> [--pattern <рисунок>]",
        descripcionArpegio: "ноты арпеджио и подходящие гаммы\n(--pattern ascending, descending,\nup-down, down-up, broken, alberti)",
        notasArpegio: "параметры: --octaves 2 (от 1 до 4), --no-octave, --from E\n(или 3: начать с этой ноты), --tensions 9,13, --degrees\n1-5-3-8 (свой рисунок) и --approach below, above или\nenclosure (хроматические ноты, ведущие к каждой)",
        sintaxisIdentificar: "identify <ноты>",
        descripcionIdentificar: "аккорды, которые образуют ноты",
        notasIdentificar: "параметры: --scales (гаммы, содержащие\nэти ноты, вместо аккордов) и --file\nmelody.mid (ноты файла MIDI, MusicXML,\nMEI или ABC, с --scales)",
        sintaxisIntervalo: "interval <нота> <нота>",
        descripcionIntervalo: "интервал между двумя нотами или\nвысотами",
        sintaxisEscala: "scale <гамма> [--chords]",
        descripcionEscala: "ноты и аккорды гаммы\n--chords: все аккорды на каждой\nступени, не только терцовые",
        notasEscala: "параметры: --sequence thirds (или fourths, groups-of-3,\ngroups-of-4, triads, sevenths), --descending, --octaves 2\n(от 1 до 4), --piano (аппликатура), --modes (параллельные и относительные)\nи --compare C lydian (в конце); --symmetry (через сколько\nповторяется и её аккорды);\n--neighbors (сдвинув одну ноту) и\n--all-keys (во всех двенадцати тональностях);\n--all-keys --chords (аккорды каждой\nступени; --triads — без септимы)",
        sintaxisEscalas: "scales [<текст>] [параметры]",
        descripcionEscalas: "каталог гамм: обычные и гаммы других\nтрадиций, по категориям, с нотами\nот до",
        notasEscalas: "параметры: --tradition turkey (или india, greece, ancient-greece,\narab-world, persia, azerbaijan, china, japan, korea, ethiopia,\nindonesia, klezmer, andes,\nbyzantium, mesopotamia, africa,\nsoutheast-asia, gregorian, europe,\nvietnam, brazil) и --category maqam (или rāga, makam,\ndastgah, dromos…);\n--use jazz (или classical, blues, 20th-century, folk, synthetic)\nотбирает обычные; текст ищет в названиях",
        sintaxisTradiciones: "traditions [<традиция>]",
        descripcionTradiciones: "традиции каталога с их\nкатегориями и числом гамм\nв каждой; с одной — её гаммы",
        sintaxisTonalidad: "key <тональность>",
        descripcionTonalidad: "ключевые знаки, родственные\nтональности и ступени",
        sintaxisConjunto: "set <классы>",
        descripcionConjunto: "первичная форма, номер Форта,\nвекторы, симметрии и ноты",
        sintaxisSerie: "row <серия>",
        descripcionSerie: "матрица, формы и комбинаторность\nдвенадцатитоновой серии",

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
        sintaxisCuadricula: "cuadricula <ноты или высоты> | --chord | --scale | --pcs",
        descripcionCuadricula: "сеточная клавиатура в SVG (пэды),\nс контуром и первой нотой",
        sintaxisCuadriculaOpciones: "cuadricula --axes H,V --grid CxR --origin <высота>\ncuadricula --rotate 0-3 --mirror --in-key --scale <гамма>",
        descripcionCuadriculaOpciones: "оси (1,5: по квартам), сетка\nконтроллера (8x8), угловая нота,\nчетверти оборота, зеркало и в тональности",

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
        notasMusicxmlAcordes: "параметры: --compas 6/8 (размер), --anacrusa 8 (затакт),\n--tonalidad G major (тональность), --clave fa (ключ), --tempo 90\n(или --tempo 60 4.), --titulo Мой хорал (название), --duracion 2\n(длительность каждого аккорда; по умолчанию четверть),\n--cifrados и --analisis (в хорале: обозначения сверху, ступени и\nфункции снизу)",
        sintaxisMusicxmlArpegios: "musicxml arpeggios <обозначения> [параметры]",
        descripcionMusicxmlArpegios: "аккорды арпеджио, нота за нотой",
        notasMusicxmlArpegios: "параметры: --patron alberti (или up, down, up-down), --figura 16\n(длительность каждой ноты; по умолчанию восьмая), --duracion 1\n(длительность каждого аккорда: рисунок повторяется, пока не\nзаполнит его) и остальные параметры «chords»\n--connect: каждое арпеджио начинается с ноты, ближайшей к\nпоследней ноте предыдущего",
        sintaxisMusicxmlArchivo: "musicxml chords --file <файл>",
        descripcionMusicxmlArchivo: "последовательность из файла MIDI,\nMusicXML, MEI или ABC с длительностью\nкаждого аккорда (также arpeggios, mei,\nmidi)",
        sintaxisMusicxmlEscala: "musicxml scale <гамма> [параметры]",
        descripcionMusicxmlEscala: "гамма четвертями, с микротонами:\nполубемоль макама, корон, коммы\nмакама",
        sintaxisMeiMelodia: "mei melody|chorale|chords|arpeggios|scale <…> [параметры]",
        descripcionMeiMelodia: "то же самое в MEI 5, формате\nкритических изданий (с теми же\nпараметрами)",
        sintaxisLilypondMelodia: "lilypond melody|chorale|chords|arpeggios|scale <…> [параметры]",
        descripcionLilypondMelodia: "то же самое в LilyPond, чтобы набрать\nпартитуру в PDF",
        sintaxisGuidoMelodia: "guido melody|chorale|chords|arpeggios|scale <…> [параметры]",
        descripcionGuidoMelodia: "то же самое в GUIDO (.gmn), чтобы\nпосмотреть в GuidoLib или INScore",
        sintaxisAbcMelodia: "abc melody|chorale|chords|arpeggios|scale <…> [параметры]",
        descripcionAbcMelodia: "то же самое в ABC, текстовой нотации\nнародной музыки",
        sintaxisMidiMelodia: "midi melody|chorale|chords|arpeggios|scale <…> [параметры]",
        descripcionMidiMelodia: "то же самое в виде файла MIDI, чтобы\nпослушать (без --clave и --cifrados; с\n--program 0…127, General MIDI)",
        sintaxisGrabar: "engrave melody|chorale|chords|arpeggios|scale <…>\nengrave staff|tonnetz|harmonic-table|keyboard|clock <…> [параметры]",
        descripcionGrabar: "партитура в PDF, SVG или PNG с\nLilyPond, MuseScore, Verovio или\nGuido, или рисунок с rsvg-convert",
        notasGrabar: "--engine lilypond|musescore|verovio|guido|own,\n--format pdf|svg|png; Verovio и Guido дают SVG,\nкоторый rsvg-convert переводит в PDF или PNG;\narmonia engines показывает, какие установлены",
        sintaxisMotores: "engines",
        descripcionMotores: "движки armonia engrave: где лежит\nкаждая программа и её версия, или\nпеременная (ARMONIA_…) с её путём",

        // Ayuda+Trastes.swift
        sintaxisDigitaciones: "fingerings <обозначение>… [параметры]",
        descripcionDigitaciones: "способы сыграть аккорд, от самого удобного к наименее удобному,\nна струнном инструменте с ладами (струны снизу вверх)\nпараметры: --instrument guitar|bass|ukulele|mandolin|… (также\n\"seven-string guitar\", \"five-string bass\", \"drop D\"), --limit 5,\n--fret 12 (самый высокий используемый лад), --fingers 4 (сколько\nпальцев можно использовать), --complete (со всеми нотами: по\nумолчанию квинта может отсутствовать), --diagram (одна строка на\nструну),\n--capo 2 (лады от каподастра), --musicxml (первая аппликатура\nкаждого аккорда как табулатура MusicXML)",
        sintaxisPosiciones: "positions <гамма> [--caged]",
        descripcionPosiciones: "гамма по позициям на гитаре: три\nноты на струну (две в пентатонике)\nили CAGED",
        notasPosiciones: "параметры: --sequence thirds (или другая:\nсеквенция в каждой позиции; с\n--descending — вниз) и --shapes (пять форм\nпентатоники и их общие ноты);\n--instrument bass (или другой;\nтакже open-d, open-g, dadgad) и --capo 2",
        sintaxisTeclado: "keyboard <гамма> [--hand right]",
        descripcionTeclado: "гамма на клавиатуре фортепиано\n(SVG): ноты или, с --hand right\nили left, пальцы; --octaves 2",
        sintaxisReloj: "clock <scale> [--fifths]",
        descripcionReloj: "гамма на двенадцатичасовом циферблате\n(SVG): хроматический круг или, с\n--fifths, квинтовый круг",
        sintaxisPentagrama: "staff scale|chord|arpeggio|chords <ноты>",
        descripcionPentagrama: "гамма, аккорд, арпеджио (с ритмом:\n--figure 16, --triplets) или аккорды с\nобозначениями на нотном стане\n(SVG); --names, --intervals,\n--semitones, --tonic, --in <key>",
        sintaxisPentagramaEstudio: "staff <что> --roman|--hand|--sequence|--tab",
        descripcionPentagramaEstudio: "ступени римскими цифрами под аккордами;\nаппликатура для фортепиано (--hand right)\nили гитары (--tab --fingers); гамма\nтерциями или группами (--sequence\nthirds); табулатура внизу (--tab,\n--instrument)",
        sintaxisPentagramaRegistro: "staff <что> --octave|--clef|--grand-staff|--clef-changes|--figured-bass",
        descripcionPentagramaRegistro: "октава (--octave 2), ключ (--clef bass),\nфортепианная система, смена ключа по\nрегистру и цифрованный бас аккордов\n(6, 6/4, 6/5…)",
        sintaxisPentagramaMelodia: "staff melody <ноты> --over <аккорды>",
        descripcionPentagramaMelodia: "мелодия (C4:8 D4:8…) с аккордом на такт\nнад ней; неаккордовые звуки зелёным\n(хроматические — красным); --non-chord\nделает то же в других случаях",
        sintaxisPosicionesArpegio: "positions --arpeggio <обозначение> [--caged|--sweep]",
        descripcionPosicionesArpegio: "арпеджио аккорда в каждой позиции\nна грифе, табулатурой и с пальцами;\n--up-and-down — вверх и обратно вниз",

        // Ayuda.swift
        cabeceraDeLaAyuda: """
        armonia: теория музыки в командной строке.

        Использование: armonia <команда> <аргументы> [--ingles | --idioma es|en|ca|gl|ast|an|eu|pt|fr|oc|it|de|el|ru|hu]

        Команды (команды и параметры пишутся по-испански или по-английски):
        """,
        pieDeLaAyuda: """
        Названия нот принимаются по-испански, по-английски, по-русски и на других языках
        (Do, C, Sib, Bb, до, си-бемоль). С --idioma ru ответ использует русскую нотацию и русские
        сообщения; с --ingles — английские.
        С --textos тексты выводятся на другом языке, чем ноты: --idioma en --textos ru.
        По-испански и по-английски --escritura palabras|ascii|unicode пишет ноты как Fa sostenido,
        Fa# или Fa♯ (по-английски F sharp, F# или F♯).
        В остальных языках --escritura palabras|compacto выбирает слова или краткую форму:
        fa dièse или Fa♯, F Kreuz или Fis.
        В компактных написаниях октава пишется нижним индексом (La₄), в остальных — цифрами (La4);
        --subindices или --cifras задают её (читаются обе формы).
        С --json команды chord, identify, arpeggio, interval, scale, key, analyze, set, row,
        fingerings и traditions выводят данные в JSON.
        С --json также harmonize, realize, check, counterpoint и transpose. Если вывод идёт не в
        терминал, JSON выводится одной строкой.
        ARMONIA_IDIOMA=eu задаёт язык без --idioma; ARMONIA_IDIOMA=system берёт язык из LANG.
        Коды выхода: 0 — успех, 1 — текст не читается, 2 — команда написана неверно, 3 — найдены ошибки
        (check, counterpoint).
        Без аргументов в терминале armonia открывает сеанс: по одной команде в строке.
        """,
        sintaxisAyuda: "help [<команда>]",
        descripcionAyuda: "эта справка или справка по команде\n(также <команда> --help)",
        sintaxisCompletado: "completion bash|zsh|fish",
        descripcionCompletado: "автодополнение команд и параметров\nдля оболочки",
        sintaxisManual: "manual",
        descripcionManual: "эта справка в виде страницы man",
        manualNombre: "ИМЯ",
        manualNotas: "ПРИМЕЧАНИЯ",

        // ErrorDeUso.swift (armonización)
        faltanAcordesDeLasVoces: { ejemplo in "не указаны аккорды: armonia check C3 E4 G4 C5, G2 D4 G4 B4" },
        dosAcordesDeConduccion: { ejemplo in "нужны два аккорда: armonia minimal-voice-leading G7 C" },
        faltanNotasDeLaArmonizacion: { ejemplo in "не указаны ноты мелодии: armonia harmonize E4 D4 C4" },
        propuestasFueraDeRango: "--proposals — от 1 до 20",
        faltanVocesDelContrapunto: { ejemplo, ingles in "не указаны cantus firmus и контрапункт, через /: " + ingles },
        especieFueraDeRango: "--species — от 1 до 5",
        faltanAcordesDeLaRealizacion: { ejemplo in "не указаны аккорды: armonia realize C F G7 C" },

        // ErrorDeUso.swift (consultas)
        faltaCifrado: "не указано обозначение аккорда: armonia chord G7",
        faltaCifradoDelArpegio: "не указано обозначение аккорда: armonia arpeggio C7",
        patronDesconocido: { patron in "неизвестный рисунок: «\(patron)» (ascending, descending, up-down, down-up, broken или alberti)" },
        tradicionDesconocida: { tradicion in "«\(tradicion)»: это не традиция (india, greece, arab-world, persia, turkey…)" },
        categoriaDesconocida: { categoria in "«\(categoria)»: это не категория гамм (rāga, maqam, makam, dastgah…)" },
        usoDesconocido: { uso in "«\(uso)»: это не применение гамм (classical, jazz, blues, 20th-century, folk, synthetic)" },
        faltanNotas: "не указаны ноты: armonia identify C E G",
        dosNotas: "нужны две ноты: armonia interval C E",
        faltaEscala: "не указана гамма: armonia scale D dorian",
        faltaTonalidad: "не указана тональность: armonia key A minor",
        faltaTonalidadTrasEn: "не указана тональность после --in",
        faltaConjunto: "не указано множество: armonia set 0 4 7",
        faltaSerie: "не указана серия: armonia row 0 e 7 4 2 9 3 8 t 1 5 6",
        faltanAcordesDelAnalisis: { ejemplo in "не указаны аккорды: armonia analyze C F G7 C" },
        archivoIlegible: { nombre in "не удаётся прочитать файл «\(nombre)»" },
        archivoConAcordes: "с --file аккорды не указываются",
        archivoSinAcordes: "в файле нет аккордов",
        faltaTransporte: { ejemplo in "не указаны интервал (или новая тоника) и что транспонировать: armonia transpose M2 C Am F G7" },
        faltanAcordesDeLaRearmonizacion: { ejemplo in "не указаны аккорды: armonia reharmonize C Am Dm7 G7" },

        // ErrorDeUso.swift (dibujos)
        margenFueraDeRango: "поле — число от 0 до 6: --margen 2",
        faltanNotasDelDibujo: { ejemplo, orden in "не указаны ноты: armonia \(orden) C E G" },
        faltaAcordeDelDibujo: { ejemplo, orden in "не указан аккорд: armonia \(orden) --chord G7" },
        faltaEscalaDelDibujo: { ejemplo, orden in "не указана гамма: armonia \(orden) --scale D dorian" },
        faltanClasesDelDibujo: { ejemplo, orden in "не указаны звуковысотные классы: armonia \(orden) --pcs 0 4 7" },
        faltanTriadasDelRecorrido: { ejemplo, orden in "не указаны трезвучия: armonia \(orden) --sequence C Am F Dm" },
        cicloMalEscrito: { ejemplo, orden in "цикл — гексатонический, октатонический или LR, от трезвучия: armonia \(orden) --cycle hexatonic C" },
        recorridoSoloTriadas: { ejemplo, orden in "последовательность — из мажорных и минорных трезвучий: armonia \(orden) --sequence C Am F Dm" },
        caminoSoloTriadas: { ejemplo, orden in "кратчайший путь идёт от одного мажорного или минорного трезвучия к другому: armonia \(orden) --shortest C Ebm" },
        cicloSoloTriadas: { ejemplo, orden in "цикл начинается с мажорного или минорного трезвучия: armonia \(orden) --cycle hexatonic C" },
        opcionesDeCuadricula: "параметры сетки: --axes H,V (1,5), --grid CxR (8x8), --origin <высота> (C2), --rotate 0-3",

        // ErrorDeUso.swift (neorriemanniana)
        vocesFueraDeRango: "движутся 1 или 2 голоса: --voices 2",
        unAcordeDeVecinos: { ejemplo in "нужен один аккорд: armonia neighbors G7" },
        vecinosSinFamilia: "соседи ищутся среди доминантсептаккордов, малых минорных, малых и уменьшённых септаккордов и maj7 или среди мажорных, минорных и увеличенных трезвучий",
        dosAcordesDeCamino: { ejemplo in "нужны два аккорда: armonia smooth-path G7 Dm7" },
        caminoSinConexion: "оба аккорда должны быть из одного семейства (септаккорды, с maj7 или без, или трезвучия) и быть связаны",
        faltanPasosDePLR: { ejemplo in "нужны трезвучие и шаги или другое трезвучие: armonia plr C PLR" },
        plrSoloTriadas: { ejemplo, camino in "P, L и R применяются к мажорным и минорным трезвучиям: armonia plr " + (camino ? "C Ebm" : "C PLR") },

        // ErrorDeUso.swift (partituras)
        faltaTipoDePartitura: { ejemplo, orden in "не указано «melody», «chorale» или «chords»: armonia \(orden) melody C4:4 D4:8 E4:8 F4:2 --compas 3/4" },
        instrumentoMIDI: "программа — номер General MIDI от 0 до 127: --program 52",
        marcasSoloMusicXML: "--cifrados и --analisis — только для MusicXML, MEI, LilyPond, GUIDO и ABC",
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
        tipoDePartituraDesconocido: { tipo in "«\(tipo)»: экспортируется «melody», «chorale», «chords», их «arpeggios» или «scale»" },
        faltaLoQueSeGraba: "не указано, что набирать: armonia engrave chorale C3 E4 G4 C5 > chorale.pdf",
        motorDesconocido: { motor in "«\(motor)»: движки — lilypond, musescore, verovio, guido и own" },
        formatoDeGrabadoDesconocido: { formato in "«\(formato)»: формат — «pdf», «svg» или «png»" },
        nadaQueGrabar: { orden in "«\(orden)»: набирается партитура (melody, chorale, chords, arpeggios, scale) или рисунок (staff, tonnetz, harmonic-table, keyboard, grid, clock)" },
        motorNoEncontrado: { programa, variable in "не найдено «\(programa)»: установите его или укажите путь в \(variable)" },
        motorFallo: { programa, codigo in "«\(programa)» завершился с кодом \(codigo):" },
        motorSinTerminar: { programa in "«\(programa)» не завершился вовремя и был остановлен" },
        motorNoInstalado: { variable in "не установлен (или укажите путь в \(variable))" },
        motorPropio: "own",

        // ErrorDeUso.swift (digitaciones)
        faltaInstrumento: { d, digitaciones in "не указан инструмент: \(digitaciones.1)" },
        instrumentoDesconocido: { nombre, lista in "неизвестный инструмент: «\(nombre)» (\(lista(.rusoPalabras)))" },
        faltaLimite: "не указано число аппликатур: --limit 5",
        limiteFueraDeRango: "предел — число от 1 до 200: --limit 5",
        faltanDedos: "не указано число пальцев: --fingers 3",
        dedosFueraDeRango: "число пальцев — от 1 до 4: --fingers 3",
        faltaTraste: "не указан самый высокий лад: --fret 12",
        trasteFueraDeRango: "самый высокий лад — число от 0 до 24: --fret 12",
        faltaCifradoDeDigitaciones: { d, digitaciones in "не указано обозначение аккорда: \(digitaciones.1)" },
        faltaEscalaDePosiciones: "не указана гамма: armonia positions G major",
        faltaEscalaDelTeclado: "не указана гамма: armonia keyboard D major",
        manoDesconocida: { texto in "неизвестная рука: «\(texto)» (right или left)" },
        archivoConNotas: "с --file ноты не указываются",
        noEsPentatonica: "формы есть только у пятиступенных гамм: armonia positions A minor pentatonic --shapes",
        faltaEscalaDelReloj: "не указана гамма: armonia clock D major",
        faltaLoQueDibujaElPentagrama: "не указано, что рисовать: armonia staff scale D dorian",
        capoFueraDeRango: "каподастр — число от 0 до 12: --capo 2",
        octavasFueraDeRango: "октавы — число от 1 до 4: --octaves 2",
        octavaFueraDeRango: "октава — число от 0 до 7: --octave 3",
        desdeNoValido: { desde in "«\(desde)» — не нота и не ступень аккорда: --from E или --from 3" },
        tensionesMalEscritas: "надстройки — 9, 11 или 13: --tensions 9,13",
        gradosMalEscritos: "ступени — числа от 1 до 22: --degrees 1-5-3-8",
        aproximacionDesconocida: { aproximacion in "неизвестный подход: «\(aproximacion)» (below, above или enclosure)" },
        secuenciaDesconocida: { secuencia in "неизвестная секвенция: «\(secuencia)» (thirds, fourths, groups-of-3, groups-of-4, triads или sevenths)" },

        // ErrorDeUso.swift (comunes)
        pruebaLaAyuda: "Попробуй «armonia help».",
        ordenDesconocida: { orden in "неизвестная команда: «\(orden)»" },
        opcionDesconocida: { opcion in "неизвестный параметр: «\(opcion)»" },
        idiomaDesconocido: { idioma in "неизвестный язык: «\(idioma)» (es, en, ca, gl, ast, an, eu, pt, fr, oc, it, de, el, ru или hu)" },
        terminalDesconocida: { t in "неизвестная оболочка: «\(t)» (bash, zsh или fish)" },
        escrituraNoValida: { escritura in "недопустимое написание: «\(escritura)» (palabras/words или compacto/compact; ascii или unicode, только с es и en)" },
        sinSalidaJSON: { orden in "у «\(orden)» нет вывода в JSON" },

        // Mensaje.swift
        mensajeNotas: "ноты",
        mensajeAcordes: "аккорды",
        mensajeMicrotonos: "микротоны",
        mensajeEscalas: "гаммы",
        mensajeHabituales: "обычные",
        mensajeNingunaEscala: "таких гамм нет",
        mensajeArmadura: "ключевые знаки",
        mensajeRelativa: "параллельная",
        mensajeHomonima: "одноимённая",
        mensajeBajo: { nota in "бас \(nota)" },
        mensajeBajoAjeno: "бас не из аккорда",
        mensajeSinAcordes: "Известный аккорд не найден.",
        mensajeSin: { notas in "без \(notas)" },
        mensajeSemitonos: { n in Idioma.ruso.contar(n, "полутон", "полутона", "полутонов") },
        mensajeSinAlteraciones: "без знаков",
        mensajeSostenidos: { n in Idioma.ruso.contar(n, "диез", "диеза", "диезов") },
        mensajeBemoles: { n in Idioma.ruso.contar(n, "бемоль", "бемоля", "бемолей") },
        mensajeACuatroVoces: "В четырёхголосии (бас, тенор, альт, сопрано):",
        mensajeSinDigitaciones: "удобных аппликатур нет",
        mensajeDedos: { n in Idioma.ruso.contar(n, "палец", "пальца", "пальцев") },
        mensajeCejilla: { traste in "баррэ на \(traste)-м ладу" },
        mensajeNingunPaso: "ни одного шага",
        mensajeUnPaso: "1 шаг",
        mensajePasos: { n in Idioma.ruso.contar(n, "шаг", "шага", "шагов") },
        mensajeTriadas: { n in Idioma.ruso.contar(n, "трезвучие", "трезвучия", "трезвучий") },
        mensajeFormaNormal: "нормальная форма",
        mensajeFormaPrima: "первичная форма",
        mensajeVectorIntervalico: "интервальный вектор",
        mensajeVectorDeIndice: "индексный вектор",
        mensajeEjesDeSimetria: "оси симметрии",
        mensajeIntervalos: "интервалы",
        mensajeDeTodosLosIntervalos: "всеинтервальная",
        mensajeFormasDistintas: { n in "различных форм: \(n)" },
        mensajeHexacordos: "гексахорды",
        mensajeFormasCombinatorias: "комбинаторные формы",

        // LineaDeComandos.swift (versión, erratas y salida binaria)
        sintaxisVersion: "--version",
        descripcionVersion: "версия armonia",
        quisoDecir: { x in "Возможно, имелось в виду «\(x)»?" },
        pruebaLaAyudaDe: { o in "Попробуй «armonia help \(o)»." },
        salidaBinaria: "вывод — двоичный файл (MIDI, PDF или PNG); сохрани его с помощью > файл",
        escalasPorNotas: { e in "нет гаммы с таким названием; чтобы найти её по нотам: \(e)" },
        grabarUnaPartitura: { o, e in "«armonia \(o)» уже записывает партитуру; «engrave» набирает её в PDF, SVG или PNG: \(e)" },

        // Ayuda.swift (índice) y LineaDeComandos+Sesion.swift
        gruposDeLaAyuda: ["Справки", "Гармония и голоса", "Партитуры и нотный набор", "Рисунки (SVG)", "Неоримановская теория", "Ладовые инструменты", "Терминал и справка"],
        pieDelIndice: """
        Справка по команде: armonia help <команда> (или armonia <команда> --help).
        Вся справка, с параметрами каждой команды: armonia help --all.
        Для всех команд: --ingles, --idioma, --textos, --escritura, --subindices, --cifras и --json.
        """,
        bienvenidaDeLaSesion: { v in "armonia \(v). Вводите по одной команде в строке, без «armonia» (help — команды; exit — выход)." }
    )
}
