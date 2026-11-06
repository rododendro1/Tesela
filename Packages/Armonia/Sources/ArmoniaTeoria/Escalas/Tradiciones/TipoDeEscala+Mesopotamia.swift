import ArmoniaNucleo

// MARK: - Mesopotamia

extension TipoDeEscala {
    // MARK: Afinaciones babilónicas
    //
    // Las siete afinaciones de la lira y el arpa de nueve cuerdas (sammû) de los textos cuneiformes en acadio del
    // segundo milenio a. C.: la lista de Nabnītu (CBS 10996), el texto de afinación UET VII 74 y el de UET VII 126.
    // Cada una se llama como uno de los siete intervalos de quinta o cuarta entre dos cuerdas (išartu, entre la 2.ª y
    // la 6.ª), y se pasa de una a la siguiente apretando o aflojando la cuerda del único tritono de la afinación, el
    // intervalo «impuro»; en el orden de UET VII 74, aflojando, cada una baja un semitono una nota de la anterior,
    // como el círculo de los siete modos diatónicos.
    //
    // Qué notas son no está escrito en las tablillas, y la reconstrucción se discute. Aquí va la de Anne Draffkorn
    // Kilmer con las escalas descendentes que se aceptan desde Gurney (1994) y West (1994): la cuerda 1 es la más
    // aguda y la tónica es su nota, de la que la escala baja cuerda a cuerda. Así, išartu («la normal») es la mayor
    // (la harmonía lidia griega) y nīd qabli, la del himno hurrita h.6, el frigio (la harmonía doria, de Mi a Mi).
    // La primera lectura de Kilmer (1971), con las escalas ascendentes, da a cada nombre otra especie de octava
    // (išartu, la doria griega), y Richard Dumbrill propone otra; las dos quedan fuera. La afinación sería
    // pitagórica, por quintas y cuartas: cada una va en doce notas temperadas y, en su versión microtonal, en los
    // cents pitagóricos (tono de 204, semitono de 90, el tritono de 612 o 588). Los nombres van en la transliteración
    // habitual del acadio, sin la mimación (išartu, no išartum); nīš tuḫri se leía antes nīš gabarî.

    /// «La normal» (išartu), por las cuerdas 2 y 6: la mayor (Do Si La Sol Fa Mi Re, bajando desde Do).
    public static let isartu = TipoDeEscala(
        nombre: "išartu",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        variantes: ["išartum", "ishartu"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 204, 408, 498, 702, 906, 1110])])
    /// «La cerrada» (kitmu), por las cuerdas 6 y 3: el mixolidio.
    public static let kitmu = TipoDeEscala(
        nombre: "kitmu",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["kitmum"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 204, 408, 498, 702, 906, 996])])
    /// «La de la flauta» (embūbu), por las cuerdas 3 y 7: el dórico.
    public static let embubu = TipoDeEscala(
        nombre: "embūbu",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["embūbum"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 204, 294, 498, 702, 906, 996])])
    /// «La abierta» (pītu), por las cuerdas 7 y 4: la menor natural.
    public static let pitu = TipoDeEscala(
        nombre: "pītu",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["pūtu"], variantes: ["pītum"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 204, 294, 498, 702, 792, 996])])
    /// «La caída del medio» (nīd qabli), por las cuerdas 4 y 1: el frigio. Es la afinación del himno hurrita h.6.
    public static let nidQabli = TipoDeEscala(
        nombre: "nīd qabli",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        variantes: ["nīd qablim"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 90, 294, 498, 702, 792, 996])])
    /// nīš tuḫri, por las cuerdas 1 y 5: el locrio. Se leía nīš gabarî.
    public static let nisTuhri = TipoDeEscala(
        nombre: "nīš tuḫri",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["nīš gabarî"], variantes: ["nīš tuḫrim", "nīš gabarîm", "nish tuhri", "nish gabari"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 90, 294, 498, 588, 792, 996])])
    /// «La del medio» (qablītu), por las cuerdas 5 y 2: el lidio.
    public static let qablitu = TipoDeEscala(
        nombre: "qablītu",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada, .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        variantes: ["qablītum"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 204, 408, 612, 702, 906, 1110])])

    /// Las siete, en el orden de UET VII 74: cada una baja un semitono una nota de la anterior.
    package static let mesopotamicas: [TipoDeEscala] = [
        .isartu, .kitmu, .embubu, .pitu, .nidQabli, .nisTuhri, .qablitu,
    ]
}
