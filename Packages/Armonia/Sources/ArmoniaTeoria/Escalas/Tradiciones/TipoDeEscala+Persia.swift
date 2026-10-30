import ArmoniaNucleo
extension TipoDeEscala {
    // MARK: Dastgāh persas (temperados)
    //
    // Casi todos los dastgāh usan koron (un cuarto de tono bajo): solo Māhur se escribe sin
    // aproximar. Homāyun y Čahārgāh van con la aproximación temperada habitual, el koron
    // redondeado a semitono. Transliterados como en la Encyclopædia Iranica.

    /// ماهور: la mayor.
    public static let mahur = TipoDeEscala(
        nombre: "Māhur", intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
                                       .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["Mahoor", "ماهور"])
    /// همایون, aproximado: como el frigio dominante.
    public static let homayun = TipoDeEscala(
        nombre: "Homāyun", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                                         .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["Homayoun", "همایون"])
    /// چهارگاه, aproximado: como la doble armónica.
    public static let cahargah = TipoDeEscala(
        nombre: "Čahārgāh", intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
                                          .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["Chahārgāh", "چهارگاه"])

    public static let dastgah: [TipoDeEscala] = [.mahur, .homayun, .cahargah]
}
