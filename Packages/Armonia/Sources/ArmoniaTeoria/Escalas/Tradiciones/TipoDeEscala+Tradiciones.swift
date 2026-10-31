import ArmoniaNucleo

// MARK: - Escalas de la India, dromoi griegos, maqamat, dastgāh, escalas chinas, japonesas, coreanas,
// etíopes, de Indonesia, andinas, klezmer y de la Grecia antigua
//
// Escalas de otras tradiciones, en su aproximación al temperamento igual: los 72 melakarta de
// la música carnática y algunos de sus ragas janya, los 10 thaat de la indostánica y los dromoi del rebético y la música
// popular griega. En la práctica varias usan microtonos (sobre todo los dromoi, que vienen de
// los makam otomanos); aquí se escriben con los intervalos de la escala temperada.
//
// Los nombres indios siguen el AITS (Alfabeto Internacional de Transliteración Sánscrita, IAST);
// los griegos llevan el acento de la palabra griega. La búsqueda no distingue diacríticos, y la
// transliteración habitual sin ellos (Mayamalavagowla, Hijaz…) se acepta como alias.
//
// No forman parte de `TipoDeEscala.todos`, para no cambiar las búsquedas de escalas habituales,
// pero `buscar(nombre:)` y `Escala("Re hitzaz")` las encuentran.
//
// `categoria` y `tradicion` (en `CategoriaTradicional.swift`) dicen de cada una si es un raga, un melakarta, un dromos, un
// maqam…; salen de estas listas. Sus nombres en cada idioma están en `Escalas/Nombres/`.
//
// La India, que es la más larga, está en `TipoDeEscala+India.swift`; las demás, más abajo, cada una tras su
// `// MARK: - Nombre`: Andes, China, Corea, Etiopia, Grecia, Indonesia, Japon, Klezmer, MundoArabe (maqamat) y
// Persia (dastgah). `Scripts/nombres_de_escalas/tradicionales.py` las busca por esas marcas.

extension TipoDeEscala {
    /// Escalas de otras tradiciones: thaat, dromoi, melakarta, janya, chinas, japonesas, etíopes,
    /// maqamat, de Indonesia, klezmer, ragas indostánicos, dastgāh, coreanas, andinas y de la
    /// Grecia antigua.
    public static let tradicionales: [TipoDeEscala] =
        thaats + dromoi + melakartas + janyas + chinas + japonesas
        + etiopes + maqamat + indonesias + klezmer + ragasIndostanicos + dastgah + coreanas + andinas
        + griegasAntiguas
}

// MARK: - Andes

extension TipoDeEscala {
    // MARK: Escalas andinas

    /// La pentatónica menor de los Andes (huayno, yaraví).
    public static let andina = TipoDeEscala(
        nombre: "pentatónica andina", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["andina"])
    /// La tritónica de las melodías más antiguas: una tríada menor (Do Mi♭ Sol).
    public static let tritonicaAndina = TipoDeEscala(
        nombre: "tritónica andina", intervalos: [.unisono, .terceraMenor, .quintaJusta],
        alias: ["tritónica"])

    public static let andinas: [TipoDeEscala] = [.andina, .tritonicaAndina]
}

// MARK: - China

extension TipoDeEscala {
    // MARK: Escalas chinas
    //
    // Los nombres van en pinyin con sus tonos (gōng, shāng, jué, zhǐ, yǔ) y se aceptan sin ellos y
    // en caracteres chinos. Las cinco notas de la pentatónica (宫 商 角 徵 羽, do re mi sol la)
    // dan los cinco modos; las tres escalas heptatónicas son las del modo gōng con dos notas
    // añadidas.

    /// 宫: la pentatónica mayor (Do Re Mi Sol La).
    public static let gong = TipoDeEscala(
        nombre: "Gōng", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["宫", "宮"])
    /// 商: desde el 2.º grado (Re Mi Sol La Do).
    public static let shang = TipoDeEscala(
        nombre: "Shāng", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["商"])
    /// 角: desde el 3.º grado (Mi Sol La Do Re).
    public static let jue = TipoDeEscala(
        nombre: "Jué", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        alias: ["Jiao", "角"])
    /// 徵: desde el 5.º grado (Sol La Do Re Mi).
    public static let zhi = TipoDeEscala(
        nombre: "Zhǐ", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["徵", "徴"])
    /// 羽: la pentatónica menor (La Do Re Mi Sol).
    public static let yu = TipoDeEscala(
        nombre: "Yǔ", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["羽"])
    /// 清乐, la escala «pura»: gōng con 4.º y 7.º grados (la escala mayor).
    public static let qingyue = TipoDeEscala(
        nombre: "Qīngyuè",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["清乐", "清樂"])
    /// 雅乐, la escala «elegante» de la música cortesana: gōng con 4.º aumentado y 7.º (el lidio).
    public static let yayue = TipoDeEscala(
        nombre: "Yǎyuè",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["雅乐", "雅樂"])
    /// 燕乐, la escala de los banquetes: gōng con 4.º y 7.º menor (el mixolidio).
    public static let yanyue = TipoDeEscala(
        nombre: "Yànyuè",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["燕乐", "燕樂"])

    /// Los cinco modos pentatónicos y las tres escalas heptatónicas chinas.
    public static let chinas: [TipoDeEscala] = [.gong, .shang, .jue, .zhi, .yu, .qingyue, .yayue, .yanyue]
}

// MARK: - Corea

extension TipoDeEscala {
    // MARK: Escalas coreanas
    //
    // Las dos pentatónicas de la música tradicional, en McCune-Reischauer (con breves y
    // apóstrofo) y en la romanización oficial y en hangul como alias.

    /// 평조 (Sol La Do Re Mi).
    public static let pyongjo = TipoDeEscala(
        nombre: "P'yŏngjo", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Pyeongjo", "Pyongjo", "평조"])
    /// 계면조 (La Do Re Mi Sol).
    public static let kyemyonjo = TipoDeEscala(
        nombre: "Kyemyŏnjo", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Gyemyeonjo", "계면조"])

    public static let coreanas: [TipoDeEscala] = [.pyongjo, .kyemyonjo]
}

// MARK: - Etiopia

extension TipoDeEscala {
    // MARK: Escalas etíopes (qenet)
    //
    // Los cuatro qenet pentatónicos (Təzəta, Bati, Ambassäl y Ančihoye) y las variantes mayor y
    // menor de Təzəta y Bati, transliterados como en la Encyclopaedia Aethiopica (ə, ä, č) y con
    // la grafía inglesa habitual como alias. Las fuentes no coinciden del todo en sus notas (ni la afinación es
    // temperada): aquí va la versión más citada, sobre Do.

    /// ትዝታ, «nostalgia» (Do Re Mi Sol La).
    public static let tezetaMayor = TipoDeEscala(
        nombre: "Təzəta mayor", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["Tezeta mayor", "Tezeta", "Təzəta", "Tizita", "Tizita mayor", "Tezeta major", "Tizita major", "ትዝታ"])
    /// Do Re Mi♭ Sol La♭.
    public static let tezetaMenor = TipoDeEscala(
        nombre: "Təzəta menor", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Tezeta menor", "Tizita menor", "Tezeta minor", "Tizita minor"])
    /// ባቲ (Do Mi Fa Sol Si).
    public static let batiMayor = TipoDeEscala(
        nombre: "Bati mayor", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Bati", "Batti", "Bati major", "ባቲ"])
    /// Do Mi♭ Fa Sol Si♭.
    public static let batiMenor = TipoDeEscala(
        nombre: "Bati menor", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Batti menor", "Bati minor"])
    /// አምባሰል (Do Re♭ Fa Sol La♭).
    public static let ambassel = TipoDeEscala(
        nombre: "Ambassäl", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["Ambassel", "Ambasel", "Ambessel", "አምባሰል"])
    /// አንቺሆዬ (Do Re♭ Fa Sol♭ La).
    public static let anchihoye = TipoDeEscala(
        nombre: "Ančihoye", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaDisminuida, .sextaMayor],
        alias: ["Anchihoye", "Anchihoy", "Anchi hoye", "አንቺሆዬ"])

    public static let etiopes: [TipoDeEscala] = [
        .tezetaMayor, .tezetaMenor, .batiMayor, .batiMenor, .ambassel, .anchihoye,
    ]
}

// MARK: - Grecia

extension TipoDeEscala {
    // MARK: Dromoi (música popular griega)

    public static let ousak = TipoDeEscala(
        nombre: "Ousák",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Usak", "Oussak", "Ουσάκ"])
    public static let hitzaz = TipoDeEscala(
        nombre: "Hitzáz",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Hijaz", "Hicaz", "Χιτζάζ"])
    public static let hitzazkiar = TipoDeEscala(
        nombre: "Hitzazkiár",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Hijazkiar", "Hicazkar", "Χιτζαζκιάρ"])
    public static let pireotikos = TipoDeEscala(
        nombre: "Pireótikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Piraiotikos", "Pireaiotikos", "Πειραιώτικος"])
    public static let tabahaniotikos = TipoDeEscala(
        nombre: "Tabahaniótikos",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Ταμπαχανιώτικος"])
    public static let niavent = TipoDeEscala(
        nombre: "Niavént",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Nihavent", "Νιαβέντ"])
    public static let nikriz = TipoDeEscala(
        nombre: "Nikríz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ], alias: ["Souzinak", "Susinak", "Poimeniko", "Νικρίζ"])
    public static let kartzigar = TipoDeEscala(
        nombre: "Kartzigár",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ], alias: ["Kartsigar", "Karcigar", "Καρτσιγάρ"])
    public static let sabah = TipoDeEscala(
        nombre: "Sabáh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ], alias: ["Sabach", "Sampah", "Σαμπάχ"])
    public static let houzam = TipoDeEscala(
        nombre: "Houzám",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ], alias: ["Huzam", "Χουζάμ"])
    public static let sengah = TipoDeEscala(
        nombre: "Sengáh",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ], alias: ["Segah", "Sengiach", "Σεγκιάχ"])
    public static let tsinganikos = TipoDeEscala(
        nombre: "Tsingánikos",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["Τσιγγάνικος"])

    // Dromoi que suben y bajan distinto.

    /// Sube como la mayor y baja con la 7ª menor (en la práctica, la 3ª y la 7ª son microtonales).
    public static let rast = TipoDeEscala(
        nombre: "Rast",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Ραστ"])
    /// Sube como Kartzigár y baja como la menor natural.
    public static let kiourdi = TipoDeEscala(
        nombre: "Kiourdí",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Kurdi", "Kioúrdi", "Κιουρντί"])
    /// Sube como el mixolidio y baja como la menor natural.
    public static let houseini = TipoDeEscala(
        nombre: "Houseïní",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Huseyni", "Houséïni", "Χουσεϊνί"])

    /// Los dromoi más habituales, en su versión temperada.
    public static let dromoi: [TipoDeEscala] = [
        .ousak, .hitzaz, .hitzazkiar, .pireotikos, .tabahaniotikos, .niavent, .nikriz,
        .kartzigar, .sabah, .houzam, .sengah, .tsinganikos, .rast, .kiourdi, .houseini,
    ]

    // MARK: Grecia antigua
    //
    // Los tetracordos de Aristóxeno, de grave a agudo (semitono, tono, tono en el diatónico;
    // semitono, semitono y tercera menor en el cromático), y las harmoniai de dos tetracordos
    // disjuntos. El género enarmónico, con cuartos de tono, no está.

    /// Mi Fa Sol La.
    public static let tetracordoDiatonico = TipoDeEscala(
        nombre: "tetracordo diatónico", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["tetracordo dorio"])
    /// Mi Fa Sol♭ La: la lichanós baja medio tono.
    public static let tetracordoCromatico = TipoDeEscala(
        nombre: "tetracordo cromático", intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta])
    /// De Mi a Mi: dos tetracordos diatónicos (el frigio moderno).
    public static let harmoniaDoria = TipoDeEscala(
        nombre: "harmonía doria",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["doria antigua"])
    /// De Mi a Mi en el género cromático (Mi Fa Sol♭ La Si Do Re♭).
    public static let harmoniaDoriaCromatica = TipoDeEscala(
        nombre: "harmonía doria cromática",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaDisminuida,
        ])
    /// De Re a Re (el dórico moderno).
    public static let harmoniaFrigia = TipoDeEscala(
        nombre: "harmonía frigia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["frigia antigua"])
    /// De Do a Do (la mayor).
    public static let harmoniaLidia = TipoDeEscala(
        nombre: "harmonía lidia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidia antigua"])

    public static let griegasAntiguas: [TipoDeEscala] = [
        .tetracordoDiatonico, .tetracordoCromatico, .harmoniaDoria, .harmoniaDoriaCromatica, .harmoniaFrigia,
        .harmoniaLidia,
    ]
}

// MARK: - Indonesia

extension TipoDeEscala {
    // MARK: Escalas de Indonesia (aproximadas)
    //
    // Las afinaciones del gamelan no son temperadas ni iguales de un conjunto a otro: estas son
    // las aproximaciones habituales a doce notas. Los nombres van con la grafía javanesa (pélog,
    // sléndro).

    /// Pélog en el modo selisir de Bali (Do Re♭ Mi♭ Sol La♭).
    public static let pelog = TipoDeEscala(
        nombre: "Pélog selisir", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Pélog", "Selisir", "balinesa", "Bali"])
    /// Sléndro, de cinco notas casi equidistantes (Do Re Fa Sol La).
    public static let slendro = TipoDeEscala(
        nombre: "Sléndro", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Saléndro"])

    public static let indonesias: [TipoDeEscala] = [.pelog, .slendro]
}

// MARK: - Japon

extension TipoDeEscala {
    // MARK: Escalas japonesas
    //
    // Los nombres van en romanización Hepburn, con macrones en las vocales largas (Hirajōshi,
    // Min'yō, Ryūkyū), y se aceptan sin ellos y en japonés. Muchas son afinaciones del koto o
    // escalas que las fuentes occidentales describen de formas distintas: aquí va la más citada.

    /// 律: la pentatónica de la música cortesana gagaku (Re Mi Sol La Si).
    public static let ritsu = TipoDeEscala(
        nombre: "Ritsu", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["律"])
    /// 呂: la otra pentatónica del gagaku (Re Mi Fa♯ La Si).
    public static let ryo = TipoDeEscala(
        nombre: "Ryo", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        alias: ["呂"])
    /// 陽音階, la escala yō de la música popular, sin semitonos (Re Mi Sol La Si).
    public static let yo = TipoDeEscala(
        nombre: "Yō", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Yoo", "Yō onkai", "陽", "陽音階"])
    /// 民謡音階, la escala de las canciones populares (Re Fa Sol La Do).
    public static let minyo = TipoDeEscala(
        nombre: "Min'yō", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Minyo", "Min yo", "民謡", "民謡音階"])
    /// 都節, la escala de la música urbana de Edo, con semitonos (Mi Fa La Si Do).
    public static let miyakobushi = TipoDeEscala(
        nombre: "Miyakobushi", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["Miyako-bushi", "Miyako bushi", "都節", "都節音階"])
    /// 陰音階, la escala in: la contrapartida con semitonos de la yō (Mi Fa La Si Do).
    public static let `in` = TipoDeEscala(
        nombre: "In", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["In onkai", "陰", "陰音階"])
    /// 陰旋, la in con la 7ª menor (Do Re♭ Fa Sol Si♭).
    public static let insen = TipoDeEscala(
        nombre: "Insen", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["In sen", "陰旋"])
    /// 岩戸 (Do Re♭ Fa Sol♭ Si♭).
    public static let iwato = TipoDeEscala(
        nombre: "Iwato", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaDisminuida, .septimaMenor],
        alias: ["岩戸"])
    /// 平調子, la afinación más común del koto (Do Re Mi♭ Sol La♭).
    public static let hirajoshi = TipoDeEscala(
        nombre: "Hirajōshi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Hira-jōshi", "平調子"])
    /// 雲井調子, otra afinación del koto (Do Re Mi♭ Sol La).
    public static let kumoijoshi = TipoDeEscala(
        nombre: "Kumoijōshi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        alias: ["Kumoi", "Kumoi-jōshi", "雲井調子"])
    /// 琉球音階, la escala de Okinawa (Do Mi Fa Sol Si).
    public static let ryukyu = TipoDeEscala(
        nombre: "Ryūkyū", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Okinawa", "琉球", "琉球音階"])

    /// 曙調子, afinación del koto (Do Re Mi♭ Sol La).
    public static let akebono = TipoDeEscala(
        nombre: "Akebono", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        alias: ["Akebono-jōshi", "Akebonojoshi", "曙", "曙調子"])
    /// 古今調子, afinación del koto (Do Re♭ Fa Sol Si♭).
    public static let kokinjoshi = TipoDeEscala(
        nombre: "Kokin-jōshi", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Kokinjoshi", "Kokin", "古今調子"])

    /// Las escalas japonesas: del gagaku, populares y afinaciones del koto.
    public static let japonesas: [TipoDeEscala] = [
        .ritsu, .ryo, .yo, .minyo, .miyakobushi, .in, .insen, .iwato, .hirajoshi, .kumoijoshi, .ryukyu,
        .akebono, .kokinjoshi,
    ]
}

// MARK: - Klezmer

extension TipoDeEscala {
    // MARK: Modos del klezmer

    /// פֿריגיש, el frigio dominante (Ahavah Rabbah en la sinagoga).
    public static let freygish = TipoDeEscala(
        nombre: "Freygish",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Freigish", "Ahavah Rabbah", "Ahava Rabbah", "Ahava Raba"])
    /// Misheberakh, el dórico ♯4.
    public static let misheberakh = TipoDeEscala(
        nombre: "Misheberakh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Mi Sheberach", "Av Harachamim"])
    /// Adonai Malakh: un mixolidio con la 3ª menor de paso (Do Re Mi♭ Mi Fa Sol La Si♭).
    public static let adonaiMalakh = TipoDeEscala(
        nombre: "Adonai Malakh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Adonoi Moloch", "Adoshem Malakh"])
    /// Magen Avot, la menor natural.
    public static let magenAvot = TipoDeEscala(
        nombre: "Magen Avot",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Mogen Ovos"])

    public static let klezmer: [TipoDeEscala] = [.freygish, .misheberakh, .adonaiMalakh, .magenAvot]
}

// MARK: - MundoArabe

extension TipoDeEscala {
    // MARK: Maqamat árabes (temperados)
    //
    // Solo los maqamat sin cuartos de tono, que el temperamento igual escribe sin aproximar (Rast,
    // Bayati o Saba los necesitan y no están). Son nombres de escalas que ya había: Ḥijāz es el
    // frigio dominante; Nahāwand, la menor armónica… Transliterados con el sistema ALA-LC (ḥ, ā,
    // ʿ), y sin diacríticos como alias.

    /// حجاز (Re Mi♭ Fa♯ Sol La Si♭ Do).
    public static let hiyaz = TipoDeEscala(
        nombre: "Ḥijāz",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Ḥiŷāz", "Hejaz", "maqam Hijaz", "حجاز"])
    /// نهاوند, la menor armónica.
    public static let nahawand = TipoDeEscala(
        nombre: "Nahāwand",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Nihavend", "Nihavent", "نهاوند"])
    /// كرد, el frigio.
    public static let kurd = TipoDeEscala(
        nombre: "Kurd",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Kurd", "كرد"])
    /// عجم, la mayor.
    public static let ajam = TipoDeEscala(
        nombre: "ʿAjam",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["Ajam", "Acem", "عجم"])
    /// حجازكار, la doble armónica.
    public static let hiyazkar = TipoDeEscala(
        nombre: "Ḥijāzkār",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Ḥiŷāzkār", "حجازكار"])
    /// نوى أثر, la menor húngara.
    public static let nawaAthar = TipoDeEscala(
        nombre: "Nawā Athar",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Nawathar", "Neveser", "نوى أثر"])

    public static let maqamat: [TipoDeEscala] = [.hiyaz, .nahawand, .kurd, .ajam, .hiyazkar, .nawaAthar]
}

// MARK: - Persia

extension TipoDeEscala {
    // MARK: Dastgāh persas (temperados)
    //
    // Casi todos los dastgāh usan koron (un cuarto de tono bajo): solo Māhur se escribe sin
    // aproximar. Homāyun y Čahārgāh van con la aproximación temperada habitual, el koron
    // redondeado a semitono. Transliterados como en la Encyclopædia Iranica.

    /// ماهور: la mayor.
    public static let mahur = TipoDeEscala(
        nombre: "Māhur",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["Mahoor", "ماهور"])
    /// همایون, aproximado: como el frigio dominante.
    public static let homayun = TipoDeEscala(
        nombre: "Homāyun",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Homayoun", "همایون"])
    /// چهارگاه, aproximado: como la doble armónica.
    public static let cahargah = TipoDeEscala(
        nombre: "Čahārgāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Chahārgāh", "چهارگاه"])

    public static let dastgah: [TipoDeEscala] = [.mahur, .homayun, .cahargah]
}
