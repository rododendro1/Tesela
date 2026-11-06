import ArmoniaNucleo

// MARK: - Indonesia

extension TipoDeEscala {
    // MARK: Escalas de Indonesia
    //
    // Las afinaciones del gamelan no son temperadas ni iguales de un conjunto a otro. Aquí se siguen los dos modelos
    // de las medidas de Surjodiningrat (1972) en Java central: el pélog, siete notas de una octava partida en nueve
    // partes iguales (de 133 cents: 1 0, 2 133, 3 267, 4 533, 5 667, 6 800 y 7 933), y el sléndro, cinco notas
    // equidistantes (de 240 cents). Cada escala va en doce notas con cada grado redondeado al semitono más cercano
    // desde su propia tónica, y en cents en su versión microtonal. Los nombres van con la grafía javanesa (pélog,
    // sléndro).
    //
    // Los pathet (modos) se escriben sobre la nota en que acaban sus cadencias, con los números del gamelan: en Java,
    // pélog lima en 1, nem en 5 y barang en 6 (lima y nem usan 1 2 3 5 6, barang 2 3 5 6 7, y el 4 solo de adorno);
    // sléndro nem en 2, sanga en 5 y manyura en 6. En Bali, selisir (1 2 3 5 6), tembung (4 5 6 1 2) y sunaren
    // (5 6 7 2 3), los tres modos del pélog de siete notas (saih pitu); con el modelo de nueve partes los tres salen
    // con los mismos intervalos, aunque en Bali cada gamelan tiene su afinación. En el sléndro, equidistante, los
    // tres pathet tienen los mismos intervalos: Do Re Fa Sol Si♭ en doce notas.
    // Fuente: Wikipedia («Pathet», «Pelog», «Slendro»).

    /// Pélog en el modo selisir de Bali (1 2 3 5 6: Do Re♭ Mi♭ Sol La♭).
    public static let pelog = TipoDeEscala(
        nombre: "Pélog selisir", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Pélog", "Selisir", "balinesa", "Bali"],
        categoria: .laras, afinaciones: [.init(.razones, pasos: [0, 133, 267, 667, 800])])
    /// Sléndro, de cinco notas equidistantes (Do Re Fa Sol Si♭ en doce notas).
    public static let slendro = TipoDeEscala(
        nombre: "Sléndro", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Saléndro"],
        categoria: .laras, afinaciones: [.init(.razones, pasos: [0, 240, 480, 720, 960])])

    /// Pélog pathet lima (1 2 3 5 6 desde 1: Do Re♭ Mi♭ Sol La♭), con las notas de selisir.
    public static let pelogLima = TipoDeEscala(
        nombre: "Pélog pathet lima", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Pélog lima"], variantes: ["Pelog patet lima"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 133, 267, 667, 800])])
    /// Pélog pathet nem (5 6 1 2 3 desde 5: Sol La♭ Do Re Mi♭).
    public static let pelogNem = TipoDeEscala(
        nombre: "Pélog pathet nem",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["Pélog nem"], variantes: ["Pelog patet nem"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 133, 533, 667, 800])])
    /// Pélog pathet barang (6 7 2 3 5 desde 6: La♭ La Re♭ Mi♭ Sol).
    public static let pelogBarang = TipoDeEscala(
        nombre: "Pélog pathet barang",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Pélog barang"], variantes: ["Pelog patet barang"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 133, 533, 667, 1067])])
    /// Sléndro pathet nem (desde 2), con los intervalos de `slendro`.
    public static let slendroNem = TipoDeEscala(
        nombre: "Sléndro pathet nem",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Sléndro nem"], variantes: ["Slendro patet nem"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 240, 480, 720, 960])])
    /// Sléndro pathet sanga (desde 5), con los intervalos de `slendro`.
    public static let slendroSanga = TipoDeEscala(
        nombre: "Sléndro pathet sanga",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Sléndro sanga"], variantes: ["Slendro patet sanga"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 240, 480, 720, 960])])
    /// Sléndro pathet manyura (desde 6), con los intervalos de `slendro`.
    public static let slendroManyura = TipoDeEscala(
        nombre: "Sléndro pathet manyura",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Sléndro manyura"], variantes: ["Slendro patet manyura"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 240, 480, 720, 960])])
    /// Tembung, el modo de Bali sobre el 4 (4 5 6 1 2), con los intervalos de selisir en el modelo de nueve partes.
    public static let pelogTembung = TipoDeEscala(
        nombre: "Pélog tembung",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Tembung"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 133, 267, 667, 800])])
    /// Sunaren, el modo de Bali sobre el 5 (5 6 7 2 3), con los intervalos de selisir en el modelo de nueve partes.
    public static let pelogSunaren = TipoDeEscala(
        nombre: "Pélog sunaren",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Sunaren"],
        categoria: .pathet, afinaciones: [.init(.razones, pasos: [0, 133, 267, 667, 800])])

    public static let indonesias: [TipoDeEscala] = [.pelog, .slendro]
    /// Los pathet de Java y los modos de Bali.
    public static let pathets: [TipoDeEscala] = [
        .pelogLima, .pelogNem, .pelogBarang, .slendroNem, .slendroSanga, .slendroManyura, .pelogTembung,
        .pelogSunaren,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    // Las afinaciones de estas escalas, que cada una lleva en su declaración (`afinaciones:`). Pélog, en nueve partes
    // iguales de 133⅓ cents (redondeados); sléndro, en cinco de 240.
    static let indonesia = FichaDeTradicion(.indonesia, [TipoDeEscala.indonesias, TipoDeEscala.pathets])
}
