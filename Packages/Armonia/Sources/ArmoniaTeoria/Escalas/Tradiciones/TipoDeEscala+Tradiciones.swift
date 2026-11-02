import ArmoniaNucleo

// MARK: - Escalas de la India, dromoi griegos, maqamat, dastgāh, makamlar, mugam, escalas chinas, japonesas,
// coreanas, etíopes, de Indonesia, andinas, klezmer y de la Grecia antigua
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
// maqam, un makam, un mugam…; salen de estas listas. Sus nombres en cada idioma están en `Escalas/Nombres/`.
//
// La India, que es la más larga, está en `TipoDeEscala+India.swift`; las demás, más abajo, cada una tras su
// `// MARK: - Nombre`: Andes, Azerbaiyan (mugam), China, Corea, Etiopia, Grecia, Indonesia, Japon, Klezmer,
// MundoArabe (maqamat), Persia (dastgah) y Turquia (makamlar).
// `Scripts/generadores/nombres_de_escalas/tradicionales.py` las busca por esas marcas.

extension TipoDeEscala {
    /// Escalas de otras tradiciones: thaat, dromoi, melakarta, janya, chinas, japonesas, etíopes,
    /// maqamat, de Indonesia, klezmer, ragas indostánicos, dastgāh, coreanas, andinas, de la
    /// Grecia antigua, makamlar turcos y mugam azerbaiyanos.
    public static let tradicionales: [TipoDeEscala] =
        thaats + dromoi + melakartas + janyas + chinas + japonesas
        + etiopes + maqamat + indonesias + klezmer + ragasIndostanicos + dastgah + coreanas + andinas
        + griegasAntiguas + makamlar + mugamlar
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

// MARK: - Azerbaiyan

extension TipoDeEscala {
    // MARK: Mugam azerbaiyanos
    //
    // Los modos de Üzeyir Hacıbəyov («Principios de la música popular azerbaiyana», 1945), que ya están en doce
    // notas: cada uno es una cadena de tetracordos iguales. Rast, Şur y Segah encadenan tres (diez grados, con la
    // tónica en el cuarto), así que tienen una nota distinta por debajo de la tónica y por encima de ella: aquí
    // van las dos, y la escala tiene ocho notas. Çahargah une dos tetracordos y separa el tercero con un tono,
    // y le basta la octava. Şüştər, Bayatı-Şiraz y Hümayun, que las fuentes describen de formas que no casan,
    // no están todavía. Los nombres van en azerbaiyano, con «muğamı» detrás, como se dicen: «Rast» sola es el
    // dromos griego.

    /// Rast: tres tetracordos tono-tono-semitono encadenados (Sol La Si | Do Re Mi Fa | Sol La Si♭ en Do). Si
    /// por debajo de la tónica y Si♭ por encima.
    public static let rastMugami = TipoDeEscala(
        nombre: "Rast muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["mugam Rast", "Rast mugham"])
    /// Şur: tres tetracordos tono-semitono-tono encadenados (Re Mi Fa | Sol La Si♭ Do | Re Mi♭ Fa en Sol). Mi
    /// por debajo de la tónica y Mi♭ por encima; el 2.º grado (La) se baja a veces un poco.
    public static let surMugami = TipoDeEscala(
        nombre: "Şur muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor,
        ],
        alias: ["mugam Şur", "Shur mugham"])
    /// Segah: tres tetracordos semitono-tono-tono encadenados (Si Do Re | Mi Fa Sol La | Si♭ Do Re en Mi). Si
    /// por debajo de la tónica y Si♭ por encima.
    public static let segahMugami = TipoDeEscala(
        nombre: "Segah muğamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["mugam Segah", "Segah mugham"])
    /// Çahargah: tetracordos semitono-segunda aumentada-semitono, los dos de abajo encadenados y el de arriba
    /// tras un tono (Sol La♭ Si | Do Re♭ Mi Fa | Sol La♭ Si Do en Do): la doble armónica.
    public static let cahargahMugami = TipoDeEscala(
        nombre: "Çahargah muğamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["mugam Çahargah", "Chahargah mugham"])

    /// Los mugam de Hacıbəyov que se escriben en doce notas sin dudas.
    public static let mugamlar: [TipoDeEscala] = [.rastMugami, .surMugami, .segahMugami, .cahargahMugami]
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
    // Los seis primeros no tienen cuartos de tono, y el temperamento igual los escribe sin aproximar: son
    // nombres de escalas que ya había (Ḥijāz es el frigio dominante; Nahāwand, la menor armónica…). Rāst,
    // Bayātī, Ṣabā y Sūznāk sí los tienen, y van aproximados como se suelen escribir: el cuarto de tono se
    // queda en su letra y se redondea hacia el lado de la costumbre (Mi𝄳 a Mi en Rāst y Sūznāk, a Mi♭ en
    // Bayātī y Ṣabā). Sīkāh, Huzām, ʿIrāq y Rāḥat al-Arwāḥ tienen la tónica en un cuarto de tono (Mi𝄳, Si𝄳): se
    // escriben sobre la nota temperada a la que se redondea (Mi, Si), y su versión microtonal la baja.
    // Transliterados con el sistema ALA-LC (ḥ, ā, ʿ), y sin diacríticos como alias. Rāst se llama
    // «maqām Rāst» porque «Rast» sola es el dromos griego.

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

    /// راست (Do Re Mi𝄳 Fa Sol La Si𝄳, y Si♭ al bajar), aproximado: sube como la mayor y baja como el
    /// mixolidio, como el dromos Rast.
    public static let maqamRast = TipoDeEscala(
        nombre: "maqām Rāst",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["راست"])
    /// بياتي (Re Mi𝄳 Fa Sol La Si♭ Do), aproximado: como el frigio, igual que el dromos Ousák.
    public static let bayati = TipoDeEscala(
        nombre: "Bayātī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Bayyātī", "maqam Bayati", "بياتي"])
    /// صبا (Re Mi𝄳 Fa Sol♭ La Si♭ Do), aproximado: Re Mi♭ Fa Sol♭ La Si♭ Do.
    public static let saba = TipoDeEscala(
        nombre: "Ṣabā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Saba", "صبا"])
    /// سوزناك (Do Re Mi𝄳 Fa Sol La♭ Si: un jins Rāst y un jins Ḥijāz), aproximado: la mayor armónica.
    public static let suznak = TipoDeEscala(
        nombre: "Sūznāk",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["maqam Suznak", "سوزناك"])
    /// حسيني (Re Mi𝄳 Fa Sol La Si𝄳 Do: un jins Bayātī y otro en la quinta), aproximado: como Bayātī, con Si♭.
    public static let husayni = TipoDeEscala(
        nombre: "Ḥusaynī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Husseini", "maqam Husayni", "حسيني"])
    /// نيروز (Do Re Mi𝄳 Fa Sol La𝄳 Si♭: un jins Rāst y un jins Bayātī en la quinta), aproximado: la menor natural.
    public static let nayruz = TipoDeEscala(
        nombre: "Nayrūz",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Nairuz", "maqam Nairuz", "نيروز"])
    /// سيكاه (Mi𝄳 Fa Sol La Si𝄳 Do Re: un jins Sīkāh y un jins Rāst), aproximado sobre Mi: el frigio.
    public static let sikah = TipoDeEscala(
        nombre: "Sīkāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["maqam Sikah", "سيكاه"])
    /// هزام (Mi𝄳 Fa Sol La♭ Si Do Re: un jins Sīkāh y un jins Ḥijāz en Sol), aproximado sobre Mi. Se llama
    /// «maqām Huzām» porque «Huzam» es también el dromos Houzám.
    public static let huzam = TipoDeEscala(
        nombre: "maqām Huzām",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["هزام"])
    /// عراق (Si𝄳 Do Re Mi𝄳 Fa Sol La: un jins Sīkāh y un jins Bayātī en Re), aproximado sobre Si: el locrio.
    public static let iraq = TipoDeEscala(
        nombre: "ʿIrāq",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["Iraq", "maqam Iraq", "عراق"])
    /// راحة الأرواح (Si𝄳 Do Re Mi♭ Fa♯ Sol La: Huzām desde Si𝄳), aproximado sobre Si.
    public static let rahatAlArwah = TipoDeEscala(
        nombre: "Rāḥat al-Arwāḥ",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["راحة الأرواح"])
    /// بياتي شوري (Re Mi𝄳 Fa Sol La♭ Si Do: un jins Bayātī y un jins Ḥijāz en Sol), aproximado: Mi𝄳 a Mi♭.
    public static let bayatiShuri = TipoDeEscala(
        nombre: "Bayātī Shūrī",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["بياتي شوري"])
    /// جهاركاه (Fa Sol La Si♭ Do Re Mi𝄳: un jins Jiharkāh y un jins Rāst en Do), aproximado: la mayor.
    public static let jiharkah = TipoDeEscala(
        nombre: "Jiharkāh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["Jaharkah", "جهاركاه"])

    public static let maqamat: [TipoDeEscala] = [
        .hiyaz, .nahawand, .kurd, .ajam, .hiyazkar, .nawaAthar, .maqamRast, .bayati, .saba, .suznak, .husayni,
        .nayruz, .sikah, .huzam, .iraq, .rahatAlArwah, .bayatiShuri, .jiharkah,
    ]
}

// MARK: - Persia

extension TipoDeEscala {
    // MARK: Dastgāh persas (temperados)
    //
    // Casi todos los dastgāh usan koron (un cuarto de tono bajo): solo Māhur y Rāst-Panjgāh se
    // escriben sin aproximar. Los demás, y los āvāz que derivan de Šur (Bayāt-e Tork, Afšāri, Dašti,
    // Abu ʿAtā) y de Homāyun (Bayāt-e Esfahān), van con la aproximación temperada habitual, el koron
    // redondeado a semitono hacia abajo, y su versión microtonal lo devuelve a su sitio. Segāh, con la
    // tónica en un koron, se escribe sobre Mi. Las notas, como en la Wikipedia inglesa (Dastgāh) y en la
    // guía del radif de Ableton. Transliterados como en la Encyclopædia Iranica.

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

    /// شور (Re Mi𝄳 Fa Sol La Si♭ Do), aproximado: como el frigio.
    public static let sur = TipoDeEscala(
        nombre: "Šur",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Shur", "Shoor", "شور"])
    /// راست پنجگاه: el mixolidio.
    public static let rastPanjgah = TipoDeEscala(
        nombre: "Rāst-Panjgāh",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["راست پنجگاه"])
    /// سهگاه (Mi𝄳 Fa Sol La𝄳 Si♭ Do Re), con la tónica en un koron, aproximado sobre Mi. Se llama «dastgāh Segāh»
    /// porque «Segah» es también el dromos Sengáh.
    public static let segah = TipoDeEscala(
        nombre: "dastgāh Segāh",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["سه\u{200C}گاه"])
    /// نوا (Sol La Si♭ Do Re Mi𝄳 Fa), aproximado: la menor natural.
    public static let nava = TipoDeEscala(
        nombre: "Navā",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["نوا"])
    /// بیات ترک (Fa Sol La Si♭ Do Re Mi𝄳), un āvāz de Šur, aproximado: el mixolidio.
    public static let bayateTork = TipoDeEscala(
        nombre: "Bayāt-e Tork",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["Bayat-e Turk", "بیات ترک"])
    /// افشاری (Do Re Mi𝄳 Fa Sol La𝄳 Si♭), un āvāz de Šur, aproximado: la menor natural.
    public static let afshari = TipoDeEscala(
        nombre: "Afšāri",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Afshari", "افشاری"])
    /// دشتی (Re Mi𝄳 Fa Sol La Si♭ Do), un āvāz de Šur con sus mismas notas y el šāhed en La, aproximado: el frigio.
    public static let dashti = TipoDeEscala(
        nombre: "Dašti",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["Dashti", "دشتی"])
    /// ابوعطا (Re Mi𝄳 Fa Sol La𝄳 Si♭ Do), un āvāz de Šur, aproximado: el locrio.
    public static let abuAta = TipoDeEscala(
        nombre: "Abu ʿAtā",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["Abu Ata", "Abuata", "ابوعطا"])
    /// بیات اصفهان (Sol La Si♭ Do Re Mi𝄳 Fa♯), un āvāz de Homāyun, aproximado: la menor armónica.
    public static let bayateEsfahan = TipoDeEscala(
        nombre: "Bayāt-e Esfahān",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["Bayat-e Isfahan", "Isfahan", "بیات اصفهان"])

    /// Los dastgāh y, con ellos, los āvāz que derivan de Šur y de Homāyun.
    public static let dastgah: [TipoDeEscala] = [
        .mahur, .homayun, .cahargah, .sur, .rastPanjgah, .segah, .nava, .bayateTork, .afshari, .dashti, .abuAta,
        .bayateEsfahan,
    ]
}

// MARK: - Turquia

extension TipoDeEscala {
    // MARK: Makamlar turcos (temperados)
    //
    // En la teoría de Arel-Ezgi-Uzdilek (AEU) la octava tiene 53 comas, y las alteraciones son de 1 coma
    // (koma), 4 (bakiye), 5 (küçük mücennep) y 8 (büyük mücennep). Aquí cada nota se redondea a su
    // semitono más cercano: la koma desaparece y las demás se escriben como ♯ o ♭. Uşşak y Hüseynî, cuya
    // segâh (Si una koma bajo, que en la práctica suena casi un cuarto de tono bajo) se pierde al redondear,
    // tienen además su versión microtonal (`TipoDeEscala.microtonal`), como Segâh, con la tónica en la segâh,
    // que se escribe sobre Si. Saba, cuyas fuentes no coinciden en el tetracordo, sigue fuera.
    // Los nombres van en turco con «makamı» detrás, como se dicen: «Rast» sola es el dromos griego.

    /// Rast (Sol La Si Do Re Mi Fa♯, con Si y Fa♯ una koma bajos): sube como la mayor y baja con Fa, como el
    /// mixolidio.
    public static let rastMakami = TipoDeEscala(
        nombre: "Rast makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Rast"])
    /// Hicaz (La Si♭ Do♯ Re | Mi Fa♯ Sol): un tetracordo Hicaz y, al subir, un pentacordo Rast en la cuarta;
    /// al bajar, Fa, como el frigio dominante.
    public static let hicazMakami = TipoDeEscala(
        nombre: "Hicaz makamı",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hicaz"])
    /// Hicazkâr (Sol La♭ Si Do Re Mi♭ Fa♯): la doble armónica.
    public static let hicazkarMakami = TipoDeEscala(
        nombre: "Hicazkâr makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Hicazkâr"])
    /// Nihâvend (Sol La Si♭ Do Re Mi♭ Fa♯): un pentacordo Bûselik y, en la quinta, un tetracordo Hicaz al
    /// subir y uno Kürdî al bajar: la menor armónica y la natural.
    public static let nihavendMakami = TipoDeEscala(
        nombre: "Nihâvend makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Nihâvend"])
    /// Kürdî (La Si♭ Do Re Mi Fa Sol): el frigio.
    public static let kurdiMakami = TipoDeEscala(
        nombre: "Kürdî makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Kürdî"])
    /// Bûselik (La Si Do Re Mi Fa Sol): un pentacordo Bûselik y un tetracordo Kürdî, la menor natural.
    public static let buselikMakami = TipoDeEscala(
        nombre: "Bûselik makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Bûselik"])
    /// Çârgâh (Do Re Mi Fa Sol La Si): la mayor.
    public static let cargahMakami = TipoDeEscala(
        nombre: "Çârgâh makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["makam Çârgâh"])
    /// Uşşak (La Si Do Re Mi Fa Sol, con Si una koma y media bajo: la segâh): un tetracordo Uşşak y un pentacordo
    /// Bûselik en la cuarta. Aproximado: la menor natural; su segâh solo suena en la versión microtonal.
    public static let ussakMakami = TipoDeEscala(
        nombre: "Uşşak makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Uşşak"])
    /// Hüseynî (La Si Do Re Mi Fa♯ Sol, con la segâh y Fa♯ una koma bajo): un pentacordo Hüseynî y un tetracordo
    /// Uşşak en la quinta; al bajar, Fa. Aproximado: sube como el dórico y baja como la menor natural.
    public static let huseyniMakami = TipoDeEscala(
        nombre: "Hüseynî makamı",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        intervalosDescendentes: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hüseynî"])
    /// Segâh (Si Do Re Mi Fa♯ Sol La, con Si y Fa♯ una koma bajos): un pentacordo Segâh desde la segâh y un
    /// tetracordo Uşşak en la eviç. Aproximado sobre Si: el frigio.
    public static let segahMakami = TipoDeEscala(
        nombre: "Segâh makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Segâh"])
    /// Hüzzam (Si Do Re Mi♭ Fa♯ Sol La, desde la segâh, con Si y Fa♯ una koma bajos y Mi♭ una alto): un pentacordo
    /// Hüzzam y un tetracordo Hicaz en la nevâ. Aproximado sobre Si.
    public static let huzzamMakami = TipoDeEscala(
        nombre: "Hüzzam makamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Hüzzam"])
    /// Saba (La Si Do Re♭ Mi Fa Sol, con la segâh): un tetracordo Saba y uno Hicaz en la çârgâh. Aproximado: la segâh a
    /// Si, como el dromos Sabáh.
    public static let sabaMakami = TipoDeEscala(
        nombre: "Saba makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["makam Saba"])
    /// Karcığar (La Si Do Re Mi♭ Fa♯ Sol): un tetracordo Uşşak y un pentacordo Hicaz en la cuarta, como el dromos
    /// Kartzigár.
    public static let karcigarMakami = TipoDeEscala(
        nombre: "Karcığar makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Karcığar"])
    /// Suzinak (Sol La Si Do Re Mi♭ Fa♯): un pentacordo Rast y un tetracordo Hicaz, la mayor armónica.
    public static let suzinakMakami = TipoDeEscala(
        nombre: "Suzinak makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Suzinak"])
    /// Nikriz (Sol La Si♭ Do♯ Re Mi Fa): un pentacordo Nikriz y un tetracordo Bûselik, el dórico con la 4ª aumentada.
    public static let nikrizMakami = TipoDeEscala(
        nombre: "Nikriz makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["makam Nikriz"])
    /// Nev'eser (Sol La Si♭ Do♯ Re Mi♭ Fa♯): un pentacordo Nikriz y un tetracordo Hicaz, la menor húngara.
    public static let neveserMakami = TipoDeEscala(
        nombre: "Nev'eser makamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["makam Nev'eser", "Neveser makamı"])

    /// Los makamlar: los que el temperamento igual escribe sin cambiarles el carácter y los que solo se oyen bien
    /// con su versión microtonal (Uşşak, Hüseynî y Segâh).
    public static let makamlar: [TipoDeEscala] = [
        .rastMakami, .hicazMakami, .hicazkarMakami, .nihavendMakami, .kurdiMakami, .buselikMakami, .cargahMakami,
        .ussakMakami, .huseyniMakami, .segahMakami, .huzzamMakami, .sabaMakami, .karcigarMakami, .suzinakMakami,
        .nikrizMakami, .neveserMakami,
    ]
}
