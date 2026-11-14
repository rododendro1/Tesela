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

    package static let coreanas: [TipoDeEscala] = [.pyongjo, .kyemyonjo, .ujo]
}
