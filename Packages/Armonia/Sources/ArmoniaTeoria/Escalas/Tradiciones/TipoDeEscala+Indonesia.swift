import ArmoniaNucleo

// MARK: - Indonesia

extension TipoDeEscala {
    // MARK: Escalas de Indonesia (aproximadas)
    //
    // Las afinaciones del gamelan no son temperadas ni iguales de un conjunto a otro: estas son
    // las aproximaciones habituales a doce notas. Los nombres van con la grafía javanesa (pélog,
    // sléndro).
    //
    // Los pathet (modos) se escriben sobre las mismas notas que las escalas de arriba, numeradas como en el
    // gamelan: el pélog de siete, 1 Do, 2 Re♭, 3 Mi♭, 4 Fa♯, 5 Sol, 6 La♭ y 7 Si♭ (selisir es 1 2 3 5 6), y el
    // sléndro, 1 Do, 2 Re, 3 Mi, 5 Sol y 6 La. Cada pathet va sobre la nota en que acaban sus cadencias: en Java,
    // pélog lima en 1, nem en 5 y barang en 6 (lima y nem usan 1 2 3 5 6, barang 2 3 5 6 7, y el 4 solo de
    // adorno); sléndro nem en 2, sanga en 5 y manyura en 6. En Bali, tembung (4 5 6 1 2) y sunaren (5 6 7 2 3),
    // que con selisir son los tres modos del pélog de siete notas (saih pitu). En el sléndro, casi equidistante,
    // los tres pathet tienen los mismos intervalos; en doce notas, que no reparten la octava en cinco partes
    // iguales, cada uno sale con otros.
    // Fuente: Wikipedia («Pathet», «Pelog»).

    /// Pélog en el modo selisir de Bali (Do Re♭ Mi♭ Sol La♭).
    public static let pelog = TipoDeEscala(
        nombre: "Pélog selisir", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Pélog", "Selisir", "balinesa", "Bali"])
    /// Sléndro, de cinco notas casi equidistantes (Do Re Fa Sol La).
    public static let slendro = TipoDeEscala(
        nombre: "Sléndro", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Saléndro"])

    /// Pélog pathet lima (1 2 3 5 6 desde 1: Do Re♭ Mi♭ Sol La♭), con las notas de selisir.
    public static let pelogLima = TipoDeEscala(
        nombre: "Pélog pathet lima", intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaJusta, .sextaMenor],
        alias: ["Pélog lima", "Pelog patet lima"])
    /// Pélog pathet nem (1 2 3 5 6 desde 5: Sol La♭ Do Re♭ Mi♭).
    public static let pelogNem = TipoDeEscala(
        nombre: "Pélog pathet nem",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor],
        alias: ["Pélog nem", "Pelog patet nem"])
    /// Pélog pathet barang (2 3 5 6 7 desde 6: La♭ Si♭ Re♭ Mi♭ Sol).
    public static let pelogBarang = TipoDeEscala(
        nombre: "Pélog pathet barang",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Pélog barang", "Pelog patet barang"])
    /// Sléndro pathet nem (desde 2: Re Mi Sol La Do).
    public static let slendroNem = TipoDeEscala(
        nombre: "Sléndro pathet nem",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Sléndro nem", "Slendro patet nem"])
    /// Sléndro pathet sanga (desde 5: Sol La Do Re Mi), con los intervalos de `slendro`.
    public static let slendroSanga = TipoDeEscala(
        nombre: "Sléndro pathet sanga",
        intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Sléndro sanga", "Slendro patet sanga"])
    /// Sléndro pathet manyura (desde 6: La Do Re Mi Sol).
    public static let slendroManyura = TipoDeEscala(
        nombre: "Sléndro pathet manyura",
        intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Sléndro manyura", "Slendro patet manyura"])
    /// Tembung, el modo de Bali sobre el 4 (4 5 6 1 2: Sol♭ Sol La♭ Do Re♭, escrito desde Do como Do Do♯ Re Fa♯ Sol).
    public static let pelogTembung = TipoDeEscala(
        nombre: "Pélog tembung",
        intervalos: [.unisono, .unisonoAumentado, .segundaMayor, .cuartaAumentada, .quintaJusta],
        alias: ["Tembung"])
    /// Sunaren, el modo de Bali sobre el 5 (5 6 7 2 3: Sol La♭ Si♭ Re♭ Mi♭).
    public static let pelogSunaren = TipoDeEscala(
        nombre: "Pélog sunaren",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .quintaDisminuida, .sextaMenor],
        alias: ["Sunaren"])

    public static let indonesias: [TipoDeEscala] = [.pelog, .slendro]
    /// Los pathet de Java y los modos de Bali.
    public static let pathets: [TipoDeEscala] = [
        .pelogLima, .pelogNem, .pelogBarang, .slendroNem, .slendroSanga, .slendroManyura, .pelogTembung,
        .pelogSunaren,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let indonesia = FichaDeTradicion(
        .indonesia,
        [
            .init(.laras, TipoDeEscala.indonesias),
            .init(.pathet, TipoDeEscala.pathets),
        ])
}
