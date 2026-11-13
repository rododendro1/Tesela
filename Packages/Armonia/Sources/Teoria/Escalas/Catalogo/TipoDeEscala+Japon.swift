import Elementos

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
        nombresOriginales: [.init("律", .japones)],
        categoria: .escala, escuelas: [.gagaku], referencias: [.garfias1975])
    /// 呂: la otra pentatónica del gagaku (Re Mi Fa♯ La Si).
    public static let ryo = TipoDeEscala(
        nombre: "Ryo", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        nombresOriginales: [.init("呂", .japones)],
        categoria: .escala, escuelas: [.gagaku], referencias: [.garfias1975])
    /// 陽音階, la escala yō de la música popular, sin semitonos (Re Mi Sol La Si).
    public static let yo = TipoDeEscala(
        nombre: "Yō", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Yō onkai"], variantes: ["Yoo"],
        nombresOriginales: [.init("陽", .japones), .init("陽音階", .japones, lectura: "Yō onkai")],
        tradicion: .japon, categoria: .escala)
    /// 民謡音階, la escala de las canciones populares (Re Fa Sol La Do).
    public static let minyo = TipoDeEscala(
        nombre: "Min'yō", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Minyo", "Min yo"],
        nombresOriginales: [.init("民謡", .japones), .init("民謡音階", .japones, lectura: "Min'yō onkai")],
        tradicion: .japon, categoria: .escala)
    /// 都節, la escala de la música urbana de Edo, con semitonos (Mi Fa La Si Do).
    public static let miyakobushi = TipoDeEscala(
        nombre: "Miyakobushi", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        variantes: ["Miyako-bushi"],
        nombresOriginales: [.init("都節", .japones), .init("都節音階", .japones, lectura: "Miyakobushi onkai")],
        tradicion: .japon, categoria: .escala)
    /// 陰音階, la escala in: la contrapartida con semitonos de la yō (Mi Fa La Si Do).
    public static let `in` = TipoDeEscala(
        nombre: "In", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaMenor],
        alias: ["In onkai"], nombresOriginales: [.init("陰", .japones), .init("陰音階", .japones, lectura: "In onkai")],
        tradicion: .japon, categoria: .escala)
    /// 陰旋, la in con la 7ª menor (Do Re♭ Fa Sol Si♭).
    public static let insen = TipoDeEscala(
        nombre: "Insen", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["In sen"], nombresOriginales: [.init("陰旋", .japones)],
        tradicion: .japon, categoria: .escala)
    /// 岩戸 (Do Re♭ Fa Sol♭ Si♭).
    public static let iwato = TipoDeEscala(
        nombre: "Iwato", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaDisminuida, .septimaMenor],
        nombresOriginales: [.init("岩戸", .japones)],
        tradicion: .japon, categoria: .escala)
    /// 平調子, la afinación más común del koto (Do Re Mi♭ Sol La♭).
    public static let hirajoshi = TipoDeEscala(
        nombre: "Hirajōshi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMenor],
        variantes: ["Hira-jōshi"], nombresOriginales: [.init("平調子", .japones)],
        tradicion: .japon, categoria: .escala)
    /// 雲井調子, otra afinación del koto (Do Re Mi♭ Sol La).
    public static let kumoijoshi = TipoDeEscala(
        nombre: "Kumoijōshi", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        alias: ["Kumoi"], variantes: ["Kumoi-jōshi"], nombresOriginales: [.init("雲井調子", .japones)],
        tradicion: .japon, categoria: .escala)
    /// 琉球音階, la escala de Okinawa (Do Mi Fa Sol Si).
    public static let ryukyu = TipoDeEscala(
        nombre: "Ryūkyū", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .septimaMayor],
        alias: ["Okinawa"],
        nombresOriginales: [.init("琉球", .japones), .init("琉球音階", .japones, lectura: "Ryūkyū onkai")],
        categoria: .escala, regiones: [.ryukyu])

    /// 曙調子, afinación del koto (Do Re Mi♭ Sol La).
    public static let akebono = TipoDeEscala(
        nombre: "Akebono", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        alias: ["Akebono-jōshi"], variantes: ["Akebonojoshi"],
        nombresOriginales: [.init("曙", .japones), .init("曙調子", .japones, lectura: "Akebono-jōshi")],
        tradicion: .japon, categoria: .escala)
    /// 古今調子, afinación del koto (Do Re♭ Fa Sol Si♭).
    public static let kokinjoshi = TipoDeEscala(
        nombre: "Kokin-jōshi", intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        alias: ["Kokin"], variantes: ["Kokinjoshi"], nombresOriginales: [.init("古今調子", .japones)],
        tradicion: .japon, categoria: .escala)

    /// Las escalas japonesas: del gagaku, populares y afinaciones del koto.
    package static let japonesas: [TipoDeEscala] = [
        .ritsu, .ryo, .yo, .minyo, .miyakobushi, .in, .insen, .iwato, .hirajoshi, .kumoijoshi, .ryukyu,
        .akebono, .kokinjoshi,
    ]
}
