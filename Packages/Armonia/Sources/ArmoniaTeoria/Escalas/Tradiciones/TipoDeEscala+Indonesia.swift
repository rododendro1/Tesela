import ArmoniaNucleo

// MARK: - Indonesia
//
// Las versiones microtonales (`afinaciones:` en cada escala). Pélog, en nueve partes iguales de 133⅓ cents
// (redondeados); sléndro, en cinco de 240.

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
        categoria: .laras, subtradicion: .bali, afinaciones: [.pelogSelisir])
    /// Sléndro, de cinco notas equidistantes (Do Re Fa Sol Si♭ en doce notas).
    public static let slendro = TipoDeEscala(
        nombre: "Sléndro", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Saléndro"],
        categoria: .laras, afinaciones: [.equipentatonica])

    /// Pélog pathet lima (1 2 3 5 6 desde 1: Do Re♭ Mi♭ Sol La♭), con las notas de selisir.
    public static let pelogLima = TipoDeEscala(
        nombre: "Pélog pathet lima", intervalos: TipoDeEscala.pelog.intervalos,
        alias: ["Pélog lima"], variantes: ["Pelog patet lima"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.pelogSelisir])
    /// Pélog pathet nem (5 6 1 2 3 desde 5: Sol La♭ Do Re Mi♭).
    public static let pelogNem = TipoDeEscala(
        nombre: "Pélog pathet nem",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["Pélog nem"], variantes: ["Pelog patet nem"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.init(.razones, pasos: [0, 133, 533, 667, 800])])
    /// Pélog pathet barang (6 7 2 3 5 desde 6: La♭ La Re♭ Mi♭ Sol).
    public static let pelogBarang = TipoDeEscala(
        nombre: "Pélog pathet barang",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Pélog barang"], variantes: ["Pelog patet barang"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.init(.razones, pasos: [0, 133, 533, 667, 1067])])
    /// Sléndro pathet nem (desde 2), con los intervalos de `slendro`.
    public static let slendroNem = TipoDeEscala(
        nombre: "Sléndro pathet nem",
        intervalos: TipoDeEscala.slendro.intervalos,
        alias: ["Sléndro nem"], variantes: ["Slendro patet nem"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.equipentatonica])
    /// Sléndro pathet sanga (desde 5), con los intervalos de `slendro`.
    public static let slendroSanga = TipoDeEscala(
        nombre: "Sléndro pathet sanga",
        intervalos: TipoDeEscala.slendro.intervalos,
        alias: ["Sléndro sanga"], variantes: ["Slendro patet sanga"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.equipentatonica])
    /// Sléndro pathet manyura (desde 6), con los intervalos de `slendro`.
    public static let slendroManyura = TipoDeEscala(
        nombre: "Sléndro pathet manyura",
        intervalos: TipoDeEscala.slendro.intervalos,
        alias: ["Sléndro manyura"], variantes: ["Slendro patet manyura"],
        categoria: .pathet, llevaLaCategoria: true, subtradicion: .java, afinaciones: [.equipentatonica])
    /// Tembung, el modo de Bali sobre el 4 (4 5 6 1 2), con los intervalos de selisir en el modelo de nueve partes.
    public static let pelogTembung = TipoDeEscala(
        nombre: "Pélog tembung",
        intervalos: TipoDeEscala.pelog.intervalos,
        alias: ["Tembung"],
        categoria: .pathet, subtradicion: .bali, afinaciones: [.pelogSelisir])
    /// Sunaren, el modo de Bali sobre el 5 (5 6 7 2 3), con los intervalos de selisir en el modelo de nueve partes.
    public static let pelogSunaren = TipoDeEscala(
        nombre: "Pélog sunaren",
        intervalos: TipoDeEscala.pelog.intervalos,
        alias: ["Sunaren"],
        categoria: .pathet, subtradicion: .bali, afinaciones: [.pelogSelisir])

    // MARK: Sunda
    //
    // El gamelan degung de Sunda, en el oeste de Java, toca un pélog de cinco notas, el laras degung. Sus notas se
    // numeran de la aguda a la grave (1 da, 2 mi, 3 na, 4 ti, 5 la), y la de referencia es da. Con el suling de 56
    // cm, en el que da es Sol, son Sol Fa♯ Re Do Si: desde da, Do Mi Fa Sol Si en doce notas, con un paso de unos 240
    // cents entre na y ti. Las fuentes no coinciden en cómo cambia el madenda (o sorog), así que no está.
    // Fuente: Wikipedia («Gamelan degung»), e Iwan Gunawan para Ableton («A Guide to the Sundanese Gamelan Tuning»).

    /// Degung, el laras del gamelan degung de Sunda (da la mi ti na desde da: Do Mi Fa Sol Si).
    public static let degung = TipoDeEscala(
        nombre: "Degung", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["laras degung", "pélog degung"],
        categoria: .laras, subtradicion: .sunda)

    public static let indonesias: [TipoDeEscala] = [.pelog, .slendro, .degung]
    /// Los pathet de Java y los modos de Bali.
    public static let pathets: [TipoDeEscala] = [
        .pelogLima, .pelogNem, .pelogBarang, .slendroNem, .slendroSanga, .slendroManyura, .pelogTembung,
        .pelogSunaren,
    ]
}
