import ArmoniaNucleo

// MARK: - Azerbaiyan

extension TipoDeEscala {
    // MARK: Mugam azerbaiyanos
    //
    // Los modos de Üzeyir Hacıbəyov («Principios de la música popular azerbaiyana», 1945), que ya están en doce
    // notas: cada uno es una cadena de tetracordos iguales. Rast, Şur y Segah encadenan tres (diez grados, con la
    // tónica en el cuarto), así que tienen una nota distinta por debajo de la tónica y por encima de ella: aquí
    // van las dos, y la escala tiene ocho notas. Çahargah une dos tetracordos y separa el tercero con un tono,
    // y le basta la octava. Şüştər, Bayatı-Şiraz y Hümayun, que las fuentes describen de formas que no casan,
    // no están todavía. Los nombres van en azerbaiyano, con «muğamı» detrás, como se dicen: «Rast» sola es el
    // dromos griego.

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

    /// Los mugam de Hacıbəyov que se escriben en doce notas sin dudas.
    public static let mugamlar: [TipoDeEscala] = [.rastMugami, .surMugami, .segahMugami, .cahargahMugami]
}
