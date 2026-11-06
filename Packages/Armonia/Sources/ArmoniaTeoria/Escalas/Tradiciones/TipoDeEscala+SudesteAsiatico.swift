import ArmoniaNucleo

// MARK: - SudesteAsiatico

extension TipoDeEscala {
    // MARK: Afinaciones equidistantes del sudeste asiático
    //
    // La música clásica de Tailandia y la de Camboya reparten la octava en siete partes casi iguales, de unos 171
    // cents: la afinación de los conjuntos piphat tailandeses y pinpeat jemeres. Como la equiheptatónica africana,
    // va en doce notas con cada grado redondeado al semitono más cercano (el dórico) y en cents en su versión
    // microtonal. Las melodías usan sobre todo cinco de las siete notas, en una de varias alturas (thang), que una
    // escala no recoge. Fuente: Wikipedia («Music of Thailand», «Music of Cambodia»).

    /// Piphat (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas.
    public static let piphat = TipoDeEscala(
        nombre: "Piphat",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["tailandesa"], variantes: ["ปี่พาทย์"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 171, 343, 514, 686, 857, 1029])])
    /// Pinpeat (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas.
    public static let pinpeat = TipoDeEscala(
        nombre: "Pinpeat",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["camboyana", "jemer"], variantes: ["ពិណពាទ្យ"],
        categoria: .afinacion, afinaciones: [.init(.razones, pasos: [0, 171, 343, 514, 686, 857, 1029])])

    // MARK: El arpa birmana
    //
    // Las afinaciones del saung gauk de Myanmar (hnyìn, myin, palè y auk) son pentatónicas con dos pasos: uno
    // pequeño, de unos 182 cents, y uno grande, de unos 327, en el orden pequeño, pequeño, grande, pequeño, grande
    // o en una de sus rotaciones. Aquí va ese orden, con los pasos medios que da Jay Rahn («Reformulating Burmese
    // Harp Tunings», York University, 2019): Do Re Mi Sol La en doce notas, con un Mi entre Mi♭ y Mi.

    /// Saung (arpa birmana): Do Re Mi Sol La en doce notas.
    public static let saung = TipoDeEscala(
        nombre: "Saung", intervalos: TipoDeEscala.pentatonicaMayor.intervalos,
        alias: ["saung gauk", "arpa birmana", "birmana"],
        categoria: .afinacion,
        afinaciones: [
            // En cents: 182, 182, 327, 182 y 327.
            .init(.razones, pasos: [0, 182, 364, 691, 873]),
        ])

    public static let sudesteAsiaticas: [TipoDeEscala] = [.piphat, .pinpeat, .saung]
}

// MARK: Ficha

extension FichaDeTradicion {
    // Las afinaciones de estas escalas, que cada una lleva en su declaración (`afinaciones:`). En cents: siete partes
    // de 171,4 (redondeados).
    static let sudesteAsiatico = FichaDeTradicion(.sudesteAsiatico, [TipoDeEscala.sudesteAsiaticas])
}
