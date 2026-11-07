import Elementos

// MARK: - Vietnam
//
// Las versiones microtonales (`afinaciones:` en cada escala). Las medidas en cents.

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

    // Del mismo estudio: Hò mái nhì, el canto de los remeros de Huế, con la 2ª y la 6ª bajas; Sa mạc, del norte,
    // con la 3ª menor alta; y la canción popular (dân ca), con la 3ª menor baja.
    // Los modos Nam y Xuân no están medidos en la Database of Musical Scales y no están todavía.

    /// Hò mái nhì: Do Re Fa Sol La en doce notas, con el Re y el La bajos.
    public static let hoMaiNhi = TipoDeEscala(
        nombre: "Hò mái nhì", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 166, 513, 695, 859])])
    /// Sa mạc: Do Mi♭ Fa Sol Si♭ en doce notas, con el Mi♭ alto.
    public static let saMac = TipoDeEscala(
        nombre: "Sa mạc", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 338, 504, 699, 1026])])
    /// Dân ca: Do Re Mi♭ Sol La en doce notas, con el Mi♭ bajo.
    public static let danCa = TipoDeEscala(
        nombre: "Dân ca", intervalos: [.unisono, .segundaMayor, .terceraMenor, .quintaJusta, .sextaMayor],
        categoria: .escala, afinaciones: [.init(.razones, pasos: [0, 182, 281, 702, 883])])

    package static let vietnamitas: [TipoDeEscala] = [.bac, .vongCo, .hoMaiNhi, .saMac, .danCa]
}
