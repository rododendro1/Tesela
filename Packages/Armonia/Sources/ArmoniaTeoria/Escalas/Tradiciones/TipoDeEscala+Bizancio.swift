import ArmoniaNucleo

// MARK: - Bizancio

extension TipoDeEscala {
    // MARK: Echoi bizantinos
    //
    // Los ocho modos (echoi, ἦχοι) de la salmodia bizantina, en la teoría de la Comisión Patriarcal de Constantinopla
    // (1881): la octava en 72 moria y cuatro géneros de tetracordo, el diatónico (12, 10 y 8 moria), el cromático
    // blando (8, 14 y 8), el cromático duro (6, 20 y 4) y el enarmónico (12, 12 y 6). Las notas se llaman Ni, Pa,
    // Vou, Ga, Di, Ke y Zo, de Do a Si. Cada echos va sobre su nota base más habitual (varios tienen más de una), con
    // las notas de su género en doce notas; su versión microtonal, en moria, está en la ficha, abajo. El tercero,
    // enarmónico, ya es la escala mayor. Va también el légetos, la variante del cuarto sobre Vou. Fuentes:
    // Wikipedia («Neobyzantine Octoechos») y la tabla de escalas del St Andrew's Greek Orthodox Theological College.

    /// El primero (Re Mi Fa Sol La Si Do, sobre Pa): diatónico, con Vou y Zo dos moria bajo Mi y Si.
    public static let echosProtos = TipoDeEscala(
        nombre: "échos prótos",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["Ήχος πρώτος", "ichos protos"])
    /// El plagal del primero (La Si Do Re Mi Fa Sol, sobre Ke): diatónico.
    public static let echosPlagiosProtos = TipoDeEscala(
        nombre: "échos plágios prótos",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["Ήχος πλάγιος του πρώτου", "plagal protos"])
    /// El segundo (Sol La♭ Si Do Re Mi♭ Fa♯, sobre Di): cromático blando, aproximado a la doble armónica.
    public static let echosDefteros = TipoDeEscala(
        nombre: "échos défteros",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["Ήχος δεύτερος", "echos deuteros", "ichos defteros"])
    /// El plagal del segundo (Re Mi♭ Fa♯ Sol La Si♭ Do♯, sobre Pa): cromático duro, la doble armónica.
    public static let echosPlagiosDefteros = TipoDeEscala(
        nombre: "échos plágios défteros",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["Ήχος πλάγιος του δευτέρου", "echos plagios deuteros", "plagal defteros"])
    /// El tercero (Fa Sol La Si♭ Do Re Mi, sobre Ga): enarmónico, que en la teoría de 1881 ya es la escala mayor.
    public static let echosTritos = TipoDeEscala(
        nombre: "échos trítos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["Ήχος τρίτος", "ichos tritos"])
    /// El grave, el plagal del tercero (Si Do Re Mi Fa Sol La, sobre Zo): diatónico, con la tónica dos moria bajo Si.
    public static let echosVarys = TipoDeEscala(
        nombre: "échos varýs",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["Ήχος βαρύς", "echos barys", "grave"])
    /// El cuarto (Sol La Si Do Re Mi Fa, sobre Di): diatónico.
    public static let echosTetartos = TipoDeEscala(
        nombre: "échos tétartos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        alias: ["Ήχος τέταρτος", "ichos tetartos"])
    /// El plagal del cuarto (Do Re Mi Fa Sol La Si, sobre Ni): diatónico.
    public static let echosPlagiosTetartos = TipoDeEscala(
        nombre: "échos plágios tétartos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["Ήχος πλάγιος του τετάρτου", "plagal tetartos"])
    /// El légetos (Mi Fa Sol La Si Do Re, sobre Vou): el cuarto en su forma de los himnos breves, con la tónica dos
    /// moria bajo Mi.
    public static let echosLegetos = TipoDeEscala(
        nombre: "échos légetos",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["Λέγετος", "legetos"])

    public static let echoi: [TipoDeEscala] = [
        .echosProtos, .echosPlagiosProtos, .echosDefteros, .echosPlagiosDefteros, .echosTritos, .echosVarys,
        .echosTetartos, .echosPlagiosTetartos, .echosLegetos,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let bizancio = FichaDeTradicion(
        .bizancio,
        [.init(.echos, TipoDeEscala.echoi)],
        microtonales: [
            // Echoi bizantinos (moria de la Comisión Patriarcal, desde Ni = Do: Pa 12, Vou 22, Ga 30, Di 42, Ke 54, Zo
            // 64). Los diatónicos, con Vou y Zo dos moria bajo Mi y Si; el segundo, cromático blando (8, 14, 8); el
            // plagal del segundo, cromático duro (6, 20, 4). El varýs y el légetos empiezan en Zo y en Vou: su primer
            // paso es −2.
            TipoDeEscalaMicrotonal(.echosProtos, .moria72, pasos: [0, 10, 18, 30, 42, 52, 60]),
            TipoDeEscalaMicrotonal(.echosPlagiosProtos, .moria72, pasos: [0, 10, 18, 30, 40, 48, 60]),
            TipoDeEscalaMicrotonal(.echosDefteros, .moria72, pasos: [0, 8, 22, 30, 42, 50, 64]),
            TipoDeEscalaMicrotonal(.echosPlagiosDefteros, .moria72, pasos: [0, 6, 26, 30, 42, 48, 68]),
            TipoDeEscalaMicrotonal(.echosVarys, .moria72, pasos: [-2, 6, 18, 28, 36, 48, 60]),
            TipoDeEscalaMicrotonal(.echosTetartos, .moria72, pasos: [0, 12, 22, 30, 42, 52, 60]),
            TipoDeEscalaMicrotonal(.echosPlagiosTetartos, .moria72, pasos: [0, 12, 22, 30, 42, 54, 64]),
            TipoDeEscalaMicrotonal(.echosLegetos, .moria72, pasos: [-2, 6, 18, 30, 40, 48, 60]),
        ])
}
