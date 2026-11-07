import Elementos

// MARK: - Bizancio
//
// Las versiones microtonales (`afinaciones:` en cada escala). Echoi bizantinos (moria de la Comisión Patriarcal, desde
// Ni = Do: Pa 12, Vou 22, Ga 30, Di 42, Ke 54, Zo 64). Los diatónicos, con Vou y Zo dos moria bajo Mi y Si; el segundo,
// cromático blando (8, 14, 8); el plagal del segundo, cromático duro (6, 20, 4). El varýs y el légetos empiezan en Zo y
// en Vou: su primer paso es −2.

extension TipoDeEscala {
    // MARK: Echoi bizantinos
    //
    // Los ocho modos (echoi, ἦχοι) de la salmodia bizantina, en la teoría de la Comisión Patriarcal de Constantinopla
    // (1881): la octava en 72 moria y cuatro géneros de tetracordo, el diatónico (12, 10 y 8 moria), el cromático
    // blando (8, 14 y 8), el cromático duro (6, 20 y 4) y el enarmónico (12, 12 y 6). Las notas se llaman Ni, Pa,
    // Vou, Ga, Di, Ke y Zo, de Do a Si. Cada echos va sobre su nota base más habitual (varios tienen más de una), con
    // las notas de su género en doce notas; su versión microtonal, en moria, va en su declaración. El tercero,
    // enarmónico, ya es la escala mayor. Va también el légetos, la variante del cuarto sobre Vou. Fuentes:
    // Wikipedia («Neobyzantine Octoechos») y la tabla de escalas del St Andrew's Greek Orthodox Theological College.

    /// El primero (Re Mi Fa Sol La Si Do, sobre Pa): diatónico, con Vou y Zo dos moria bajo Mi y Si.
    public static let echosProtos = TipoDeEscala(
        nombre: "échos prótos",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Ήχος πρώτος", "ichos protos"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [0, 10, 18, 30, 42, 52, 60]),
            // Los diatónicos en los 68 moria de Chrysanthos de Madytos (Θεωρητικόν μέγα, 1832), la teoría anterior: Ni
            // 0, Pa 12, Vou 21, Ga 28, Di 40, Ke 52, Zo 61 (tonos de 12, 9 y 7 moria), en cents desde Ni = Do.
            .init(.razones, pasos: [12, 171, 294, 506, 718, 876, 1000], fuente: "Chrysanthos, 1832"),
        ])
    /// El plagal del primero (La Si Do Re Mi Fa Sol, sobre Ke): diatónico.
    public static let echosPlagiosProtos = TipoDeEscala(
        nombre: "échos plágios prótos",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["plagal protos"], variantes: ["Ήχος πλάγιος του πρώτου"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [0, 10, 18, 30, 40, 48, 60]),
            .init(.razones, pasos: [18, 176, 300, 512, 671, 794, 1006], fuente: "Chrysanthos, 1832"),
        ])
    /// El segundo (Sol La♭ Si Do Re Mi♭ Fa♯, sobre Di): cromático blando, aproximado a la doble armónica.
    public static let echosDefteros = TipoDeEscala(
        nombre: "échos défteros",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        variantes: ["Ήχος δεύτερος", "echos deuteros", "ichos defteros"],
        categoria: .echos, llevaLaCategoria: true, afinaciones: [.init(.moria72, pasos: [0, 8, 22, 30, 42, 50, 64])])
    /// El plagal del segundo (Re Mi♭ Fa♯ Sol La Si♭ Do♯, sobre Pa): cromático duro, la doble armónica.
    public static let echosPlagiosDefteros = TipoDeEscala(
        nombre: "échos plágios défteros",
        intervalos: [.unisono, .segundaMenor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMayor],
        alias: ["plagal defteros"], variantes: ["Ήχος πλάγιος του δευτέρου", "echos plagios deuteros"],
        categoria: .echos, llevaLaCategoria: true, afinaciones: [.init(.moria72, pasos: [0, 6, 26, 30, 42, 48, 68])])
    /// El tercero (Fa Sol La Si♭ Do Re Mi, sobre Ga): enarmónico, que en la teoría de 1881 ya es la escala mayor.
    public static let echosTritos = TipoDeEscala(
        nombre: "échos trítos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        variantes: ["Ήχος τρίτος", "ichos tritos"],
        categoria: .echos, llevaLaCategoria: true)
    /// El grave, el plagal del tercero (Si Do Re Mi Fa Sol La, sobre Zo): diatónico, con la tónica dos moria bajo Si.
    public static let echosVarys = TipoDeEscala(
        nombre: "échos varýs",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["grave"], variantes: ["Ήχος βαρύς", "echos barys"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [-2, 6, 18, 28, 36, 48, 60]),
            .init(.razones, pasos: [-24, 100, 312, 471, 594, 806, 1018], fuente: "Chrysanthos, 1832"),
        ])
    /// El cuarto (Sol La Si Do Re Mi Fa, sobre Di): diatónico.
    public static let echosTetartos = TipoDeEscala(
        nombre: "échos tétartos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor],
        variantes: ["Ήχος τέταρτος", "ichos tetartos"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [0, 12, 22, 30, 42, 52, 60]),
            .init(.razones, pasos: [6, 218, 376, 500, 712, 871, 994], fuente: "Chrysanthos, 1832"),
        ])
    /// El plagal del cuarto (Do Re Mi Fa Sol La Si, sobre Ni): diatónico.
    public static let echosPlagiosTetartos = TipoDeEscala(
        nombre: "échos plágios tétartos",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMayor],
        alias: ["plagal tetartos"], variantes: ["Ήχος πλάγιος του τετάρτου"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [0, 12, 22, 30, 42, 54, 64]),
            .init(.razones, pasos: [0, 212, 371, 494, 706, 918, 1076], fuente: "Chrysanthos, 1832"),
        ])
    /// El légetos (Mi Fa Sol La Si Do Re, sobre Vou): el cuarto en su forma de los himnos breves, con la tónica dos
    /// moria bajo Mi.
    public static let echosLegetos = TipoDeEscala(
        nombre: "échos légetos",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta, .quintaJusta, .sextaMenor, .septimaMenor],
        alias: ["legetos"], variantes: ["Λέγετος"],
        categoria: .echos, llevaLaCategoria: true,
        afinaciones: [
            .init(.moria72, pasos: [-2, 6, 18, 30, 40, 48, 60]),
            .init(.razones, pasos: [-29, 94, 306, 518, 676, 800, 1012], fuente: "Chrysanthos, 1832"),
        ])

    package static let echoi: [TipoDeEscala] = [
        .echosProtos, .echosPlagiosProtos, .echosDefteros, .echosPlagiosDefteros, .echosTritos, .echosVarys,
        .echosTetartos, .echosPlagiosTetartos, .echosLegetos,
    ]
}
