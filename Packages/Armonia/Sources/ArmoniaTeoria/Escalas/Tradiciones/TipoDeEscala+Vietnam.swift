import ArmoniaNucleo

// MARK: - Vietnam

extension TipoDeEscala {
    // MARK: Modos de la cítara đàn tranh
    //
    // Dos de las escalas pentatónicas de la música vietnamita, como las midieron Keefe, Burns y Nguyen en la đàn
    // tranh («Vietnamese Modal Scales of the Dan Tranh», Music Perception 8, 1991), de la Database of Musical
    // Scales: la del modo Bắc, del norte, vigoroso (Do Re Fa Sol La, casi temperada), y la del vọng cổ, la pieza
    // más conocida del modo Oán, del sur, triste, con la 3ª y la 6ª entre la menor y la mayor. En doce notas, cada
    // grado va a la nota más cercana.

    /// Bắc: Do Re Fa Sol La.
    public static let bac = TipoDeEscala(
        nombre: "Bắc", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["điệu Bắc", "hơi Bắc"],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 189, 501, 698, 891])])
    /// Vọng cổ, del modo Oán: Do Mi Fa Sol La en doce notas, con el Mi y el La bajos.
    public static let vongCo = TipoDeEscala(
        nombre: "Vọng cổ", intervalos: [.unisono, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["Oán", "hơi Oán", "điệu Oán"],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 375, 519, 704, 866])])

    public static let vietnamitas: [TipoDeEscala] = [.bac, .vongCo]
}

// MARK: Ficha

extension FichaDeTradicion {
    // Las afinaciones de estas escalas, que cada una lleva en su declaración (`afinaciones:`). Las medidas en cents.
    static let vietnam = FichaDeTradicion(.vietnam, [TipoDeEscala.vietnamitas])
}
