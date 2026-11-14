import Elementos

// MARK: - Corea

extension TipoDeEscala {
    // MARK: Escalas coreanas
    //
    // Las tres pentatónicas de la música tradicional, en McCune-Reischauer (con breves y
    // apóstrofo) y en la romanización oficial y en hangul como alias.

    /// 평조 (Sol La Do Re Mi).
    public static let pyongjo = TipoDeEscala(
        nombre: "P'yŏngjo", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Pyeongjo", "Pyongjo"], nombresOriginales: [.init("평조", .coreano)],
        categoria: .jo)
    /// 계면조 (La Do Re Mi Sol).
    public static let kyemyonjo = TipoDeEscala(
        nombre: "Kyemyŏnjo", intervalos: [.unisono, .terceraMenor, .cuartaJusta, .quintaJusta, .septimaMenor],
        variantes: ["Gyemyeonjo"], nombresOriginales: [.init("계면조", .coreano)],
        categoria: .jo)

    /// 우조 (Do Re Mi Sol La): las notas de P'yŏngjo con la tónica en Do. Entre la tónica (본청) y la nota aguda de
    /// referencia (상청) hay una 3ª mayor, y no una 4ª como en P'yŏngjo (Baek Daewoong, según Shin, en
    /// `Referencia.shin2024`).
    public static let ujo = TipoDeEscala(
        nombre: "Ujo", intervalos: [.unisono, .segundaMayor, .terceraMayor, .quintaJusta, .sextaMayor],
        nombresOriginales: [.init("우조", .coreano)],
        categoria: .jo)

    // MARK: Tori
    //
    // Las tori (토리) de los minyo, las canciones populares: cada región canta con sus notas, sus notas principales y
    // cómo las adorna (el vibrato, 요성, y la caída, 퇴성). Las cuatro de Son In-ae en la Encyclopedia of Korean Culture
    // (`Referencia.son2013`), con la tónica en la primera nota que da.

    /// 경토리, la de Seúl y Gyeonggi (Sol La Do Re Mi): Sol y Do son el centro; acaba en Sol o en Do.
    public static let kyongtori = TipoDeEscala(
        nombre: "Kyŏngt'ori", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        variantes: ["Gyeongtori"], nombresOriginales: [.init("경토리", .coreano)],
        tradicion: .corea, categoria: .escala, referencias: [.son2013])
    /// 메나리토리, la del este (Mi Sol La Do Re): Mi, La y Do son el centro, y Sol solo sale al bajar.
    public static let menaritori = TipoDeEscala(
        nombre: "Menarit'ori", intervalos: [.unisono, .cuartaJusta, .sextaMenor, .septimaMenor],
        intervalosDescendentes: [.unisono, .terceraMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        nombresOriginales: [.init("메나리토리", .coreano)],
        tradicion: .corea, categoria: .escala, referencias: [.son2013])
    /// 육자배기토리, la del sudoeste (Mi La Si Do): Mi con vibrato, La recto y Do que cae a Si.
    public static let yukchabaegitori = TipoDeEscala(
        nombre: "Yukchabaegit'ori", intervalos: [.unisono, .cuartaJusta, .quintaJusta, .sextaMenor],
        variantes: ["Yukjabaegitori"], nombresOriginales: [.init("육자배기토리", .coreano)],
        tradicion: .corea, categoria: .escala, referencias: [.son2013])
    /// 수심가토리, la del noroeste (Re Mi Sol La Do): Re, La y Do son el centro, La con vibrato y Do que cae; Sol a
    /// veces falta, y acaba en La o en Re.
    public static let susimgatori = TipoDeEscala(
        nombre: "Susimgat'ori", intervalos: [.unisono, .segundaMayor, .cuartaJusta, .quintaJusta, .septimaMenor],
        nombresOriginales: [.init("수심가토리", .coreano)],
        tradicion: .corea, categoria: .escala, referencias: [.son2013])

    package static let coreanas: [TipoDeEscala] = [
        .pyongjo, .kyemyonjo, .ujo, .kyongtori, .menaritori, .yukchabaegitori, .susimgatori,
    ]
}
