import Elementos

// MARK: - Azerbaiyan

extension TipoDeEscala {
    // MARK: Mugam azerbaiyanos
    //
    // Los modos de Üzeyir Hacıbəyov («Principios de la música popular azerbaiyana», 1945), que ya están en doce
    // notas: cada uno es una cadena de tetracordos iguales. Rast, Şur y Segah encadenan tres (diez grados, con la
    // tónica en el cuarto), así que tienen una nota distinta por debajo de la tónica y por encima de ella: aquí
    // van las dos, y la escala tiene ocho notas. Çahargah une dos tetracordos y separa el tercero con un tono,
    // y le basta la octava. Şüştər, Bayatı-Şiraz y Hümayun unen dos tetracordos iguales con otra cosa en medio
    // (un tono, una segunda aumentada o un grado suelto), y su tónica no es la primera nota: van como los da el
    // texto azerbaiyano de Hacıbəyov (musbook.musigi-dunya.az), desde la tónica, con las notas de debajo y de
    // encima. Los nombres van en azerbaiyano, con «muğamı» detrás, como se dicen: «Rast» sola es el dromos
    // griego.

    /// Rast: tres tetracordos tono-tono-semitono encadenados (Sol La Si | Do Re Mi Fa | Sol La Si♭ en Do). Si
    /// por debajo de la tónica y Si♭ por encima.
    public static let rastMugami = TipoDeEscala(
        nombre: "Rast muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["mugam Rast"], variantes: ["Rast mugham"],
        categoria: .mugam)
    /// Şur: tres tetracordos tono-semitono-tono encadenados (Re Mi Fa | Sol La Si♭ Do | Re Mi♭ Fa en Sol). Mi
    /// por debajo de la tónica y Mi♭ por encima; el 2.º grado (La) se baja a veces un poco.
    public static let surMugami = TipoDeEscala(
        nombre: "Şur muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .sextaMayor, .septimaMenor,
        ],
        alias: ["mugam Şur"], variantes: ["Shur mugham"],
        categoria: .mugam)
    /// Segah: tres tetracordos semitono-tono-tono encadenados (Si Do Re | Mi Fa Sol La | Si♭ Do Re en Mi). Si
    /// por debajo de la tónica y Si♭ por encima.
    public static let segahMugami = TipoDeEscala(
        nombre: "Segah muğamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["mugam Segah"], variantes: ["Segah mugham"],
        categoria: .mugam)
    /// Çahargah: tetracordos semitono-segunda aumentada-semitono, los dos de abajo encadenados y el de arriba
    /// tras un tono (Sol La♭ Si | Do Re♭ Mi Fa | Sol La♭ Si Do en Do): la doble armónica.
    public static let cahargahMugami = TipoDeEscala(
        nombre: "Çahargah muğamı",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["mugam Çahargah"], variantes: ["Chahargah mugham"],
        categoria: .mugam)

    /// Şüştər: dos tetracordos semitono-tono-semitono separados por una segunda aumentada (Mi Fa Sol La♭ | Si Do Re
    /// Mi♭ en Do), con la tónica en la segunda nota del de arriba: Mi por debajo de la tónica y Mi♭ por encima.
    public static let sustarMugami = TipoDeEscala(
        nombre: "Şüştər muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor,
            .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor,
        ],
        alias: ["mugam Şüştər"], variantes: ["Shushtar mugham"],
        categoria: .mugam)
    /// Bayatı-Şiraz: dos tetracordos tono-tono-semitono con un grado suelto en medio, a un semitono del de arriba
    /// (Sol La Si Do | Re | Mi♭ Fa Sol La♭ en Do), con la tónica en la última nota del de abajo. La y Si por
    /// debajo de la tónica; La♭ por encima.
    public static let bayatiSirazMugami = TipoDeEscala(
        nombre: "Bayatı-Şiraz muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .sextaMayor, .septimaMayor,
        ],
        alias: ["mugam Bayatı-Şiraz"], variantes: ["Bayati-Shiraz mugham"],
        categoria: .mugam)
    /// Hümayun: dos tetracordos semitono-segunda aumentada-semitono con un tono suelto en medio (Sol La♭ Si Do | Re |
    /// Mi Fa Sol♯ La en Do), con dos tónicas: la última nota de cada tetracordo, Do y La. Va desde Do, con el Sol♯
    /// de arriba; el La♭ de abajo es la misma tecla.
    public static let humayunMugami = TipoDeEscala(
        nombre: "Hümayun muğamı",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["mugam Hümayun"], variantes: ["Humayun mugham"],
        categoria: .mugam)

    /// Los siete mugam de Hacıbəyov.
    package static let mugamlar: [TipoDeEscala] = [
        .rastMugami, .surMugami, .segahMugami, .cahargahMugami, .sustarMugami, .bayatiSirazMugami, .humayunMugami,
    ]
}
