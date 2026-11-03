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
        alias: ["tailandesa", "ปี่พาทย์"])
    /// Pinpeat (siete partes iguales de 171 cents): Do Re Mi♭ Fa Sol La Si♭ en doce notas.
    public static let pinpeat = TipoDeEscala(
        nombre: "Pinpeat",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["camboyana", "jemer", "ពិណពាទ្យ"])

    public static let sudesteAsiaticas: [TipoDeEscala] = [.piphat, .pinpeat]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let sudesteAsiatico = FichaDeTradicion(
        .sudesteAsiatico,
        [.init(.afinacion, TipoDeEscala.sudesteAsiaticas)],
        microtonales: [
            // En cents: siete partes de 171,4 (redondeados).
            TipoDeEscalaMicrotonal(.piphat, .razones, pasos: [0, 171, 343, 514, 686, 857, 1029]),
            TipoDeEscalaMicrotonal(.pinpeat, .razones, pasos: [0, 171, 343, 514, 686, 857, 1029]),
        ])
}
