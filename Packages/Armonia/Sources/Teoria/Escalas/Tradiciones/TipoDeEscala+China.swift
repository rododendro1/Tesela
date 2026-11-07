import Elementos

// MARK: - China

extension TipoDeEscala {
    // MARK: Escalas chinas
    //
    // Los nombres van en pinyin con sus tonos (gōng, shāng, jué, zhǐ, yǔ) y se aceptan sin ellos y
    // en caracteres chinos. Las cinco notas de la pentatónica (宫 商 角 徵 羽, do re mi sol la)
    // dan los cinco modos; las tres escalas heptatónicas son las del modo gōng con dos notas
    // añadidas.
    //
    // Las versiones microtonales (`afinaciones:`) son las de sanfen sunyi (三分损益, «quitar y añadir un tercio»): se
    // acorta un tubo o una cuerda un tercio (una quinta justa, 3/2, arriba) y se alarga el siguiente un tercio (una
    // cuarta, 4/3, abajo), así que cada nota está a un número de quintas pitagóricas de gōng: zhǐ a una (702 cents),
    // shāng a dos (204), yǔ a tres (906), jué a cuatro (408). Así salen las cinco notas en el capítulo «Diyuan» del
    // Guanzi (s. IV a. C.), la fuente de los cinco modos. En las heptatónicas, las notas añadidas son las de la misma
    // cadena: biàngōng, a cinco quintas (1110), biànzhǐ, a seis (612), y qīngjué y rùn, que en la cadena de los doce
    // lü (abajo) son zhònglǚ y wúyì, a once y diez quintas (522 y 1020, no la cuarta de 498 ni la séptima de 996).

    /// 宫: la pentatónica mayor (Do Re Mi Sol La).
    public static let gong = TipoDeEscala(
        nombre: "Gōng", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        variantes: ["宫", "宮"],
        categoria: .diao, fuente: .guanzi, afinaciones: [.init(.razones, pasos: [0, 204, 408, 702, 906])])
    /// 商: desde el 2.º grado (Re Mi Sol La Do).
    public static let shang = TipoDeEscala(
        nombre: "Shāng", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["商"],
        categoria: .diao, fuente: .guanzi, afinaciones: [.init(.razones, pasos: [0, 204, 498, 702, 996])])
    /// 角: desde el 3.º grado (Mi Sol La Do Re).
    public static let jue = TipoDeEscala(
        nombre: "Jué", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        variantes: ["Jiao", "角"],
        categoria: .diao, fuente: .guanzi, afinaciones: [.init(.razones, pasos: [0, 294, 498, 792, 996])])
    /// 徵: desde el 5.º grado (Sol La Do Re Mi).
    public static let zhi = TipoDeEscala(
        nombre: "Zhǐ", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["徵", "徴"],
        categoria: .diao, fuente: .guanzi, afinaciones: [.init(.razones, pasos: [0, 204, 498, 702, 906])])
    /// 羽: la pentatónica menor (La Do Re Mi Sol).
    public static let yu = TipoDeEscala(
        nombre: "Yǔ", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["羽"],
        categoria: .diao, fuente: .guanzi, afinaciones: [.init(.razones, pasos: [0, 294, 498, 702, 996])])
    /// 清乐, la escala «pura»: gōng con 4.º y 7.º grados (la escala mayor).
    public static let qingyue = TipoDeEscala(
        nombre: "Qīngyuè",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        variantes: ["清乐", "清樂"],
        categoria: .diao, afinaciones: [.init(.razones, pasos: [0, 204, 408, 522, 702, 906, 1110])])
    /// 雅乐, la escala «elegante» de la música cortesana: gōng con 4.º aumentado y 7.º (el lidio).
    public static let yayue = TipoDeEscala(
        nombre: "Yǎyuè",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["雅乐", "雅樂"],
        categoria: .diao, afinaciones: [.init(.razones, pasos: [0, 204, 408, 612, 702, 906, 1110])])
    /// 燕乐, la escala de los banquetes: gōng con 4.º y 7.º menor (el mixolidio).
    public static let yanyue = TipoDeEscala(
        nombre: "Yànyuè",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["燕乐", "燕樂"],
        categoria: .diao, afinaciones: [.init(.razones, pasos: [0, 204, 408, 522, 702, 906, 1020])])

    /// Los cinco modos pentatónicos y las tres escalas heptatónicas chinas.
    package static let chinas: [TipoDeEscala] = [.gong, .shang, .jue, .zhi, .yu, .qingyue, .yayue, .yanyue]

    // MARK: Los doce lü
    //
    // Los doce lü (十二律) son las doce alturas de la teoría china, las de doce tubos: huángzhōng (黄钟, «la campana
    // amarilla»), dàlǚ, tàicù, jiāzhōng, gūxiǎn, zhònglǚ, ruíbīn, línzhōng, yízé, nánlǚ, wúyì y yìngzhōng. Son nombres
    // de alturas, no de grados: gōng puede ir en cualquiera. Aquí van como la afinación que forman desde huángzhōng
    // (en Do, como se suele transcribir hoy), y la mitad de ellos, alternos, como las dos escalas de seis.
    //
    // Se generan por sanfen sunyi, como lo cuenta el Lüshi chunqiu (吕氏春秋, 239 a. C.): de huángzhōng a línzhōng
    // (una quinta), a tàicù, a nánlǚ, a gūxiǎn, a yìngzhōng, a ruíbīn, a dàlǚ, a yízé, a jiāzhōng, a wúyì y a
    // zhònglǚ, a once quintas pitagóricas. Por eso los semitonos no son iguales (de 90 y de 114 cents) y las notas son
    // las de los sostenidos: dàlǚ es Do♯ (114), no Re♭, y zhònglǚ es Mi♯ (522), una coma pitagórica (24 cents) por
    // encima de Fa: la duodécima quinta no vuelve a huángzhōng («往而不返»). En 1584, Zhu Zaiyu (朱载堉) calculó en
    // el Lüxue xinshuo (律学新说) los doce lü iguales, de 100 cents: el temperamento igual, su segunda afinación.
    //
    // Los seis lü impares (六律, los yang) y los seis pares (六吕, los yin) suenan como la escala de tonos enteros,
    // pero no son iguales: cada mitad tiene un paso de 180 cents en lugar de uno de 204, donde la cadena se corta.

    /// 十二律: los doce lü desde huángzhōng (Do Do♯ Re Re♯ Mi Mi♯ Fa♯ Sol Sol♯ La La♯ Si).
    public static let shierLu = TipoDeEscala(
        nombre: "Shí'èr lǜ",
        intervalos: [
            .unisono, .unisonoAumentado, .segundaMayor, .segundaAumentada, .terceraMayor, .terceraAumentada,
            .cuartaAumentada, .quintaJusta, .quintaAumentada, .sextaMayor, .sextaAumentada, .septimaMayor,
        ],
        alias: ["doce lü"], variantes: ["十二律"],
        categoria: .afinacion, fuente: .lushiChunqiu,
        afinaciones: [
            .init(.razones, pasos: [0, 114, 204, 318, 408, 522, 612, 702, 816, 906, 1020, 1110]),
            .init(
                .razones, pasos: [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100],
                fuente: "Zhu Zaiyu, 1584"),
        ])
    /// 六律, los seis lü yang, de huángzhōng: huángzhōng, tàicù, gūxiǎn, ruíbīn, yízé y wúyì (Do Re Mi Fa♯ Sol♯ La♯).
    public static let yanglu = TipoDeEscala(
        nombre: "Yánglǜ",
        intervalos: TipoDeEscala.tonosEnteros.intervalos,
        variantes: ["六律", "阳律", "陽律"],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 204, 408, 612, 816, 1020])])
    /// 六吕, los seis lü yin, de dàlǚ: dàlǚ, jiāzhōng, zhònglǚ, línzhōng, nánlǚ y yìngzhōng (Do♯ Re♯ Mi♯ Sol La Si,
    /// con la quinta disminuida pitagórica de 588 cents).
    public static let yinlu = TipoDeEscala(
        nombre: "Yīnlǜ",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaDisminuida, .sextaMenor, .septimaMenor],
        alias: ["Liùtóng"], variantes: ["六吕", "六呂", "阴律", "陰律", "六同"],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 204, 408, 588, 792, 996])])

    /// Los doce lü y sus dos mitades, la yang y la yin.
    package static let lus: [TipoDeEscala] = [.shierLu, .yanglu, .yinlu]
}
