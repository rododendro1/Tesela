import Elementos

// MARK: - Gregoriano

extension TipoDeEscala {
    // MARK: Modos gregorianos
    //
    // Los ocho modos del canto gregoriano como escalas del catálogo, con sus nombres latinos (protus authenticus,
    // protus plagalis…) y, de alias, los españoles, el número y el griego medieval de los plagales (hipodórico…).
    // Cada uno va desde su final: el auténtico y el plagal de una maneria tienen las mismas notas y solo se distinguen
    // por el ámbito y el tenor, que están en `ModoGregoriano` (`ModoGregoriano.tipoDeEscala` lleva de uno a otro).
    // Los modos 5 y 6 se cantan muchas veces con Si♭, que aquí no figura.

    /// Modo 1, en Re: el dórico.
    public static let protusAuthenticus = TipoDeEscala(
        nombre: "protus authenticus", intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["protus auténtico", "modo gregoriano 1", "modo 3 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 2, en Re: el dórico, con el ámbito una 4ª más abajo.
    public static let protusPlagalis = TipoDeEscala(
        nombre: "protus plagalis", intervalos: TipoDeEscala.dorico.intervalos,
        alias: ["protus plagal", "modo gregoriano 2", "hipodórico", "modo 4 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 3, en Mi: el frigio.
    public static let deuterusAuthenticus = TipoDeEscala(
        nombre: "deuterus authenticus", intervalos: TipoDeEscala.frigio.intervalos,
        alias: ["deuterus auténtico", "modo gregoriano 3", "modo 5 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 4, en Mi: el frigio, con el ámbito una 4ª más abajo.
    public static let deuterusPlagalis = TipoDeEscala(
        nombre: "deuterus plagalis", intervalos: TipoDeEscala.frigio.intervalos,
        alias: ["deuterus plagal", "modo gregoriano 4", "hipofrigio", "modo 6 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 5, en Fa: el lidio.
    public static let tritusAuthenticus = TipoDeEscala(
        nombre: "tritus authenticus", intervalos: TipoDeEscala.lidio.intervalos,
        alias: ["tritus auténtico", "modo gregoriano 5", "modo 7 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 6, en Fa: el lidio, con el ámbito una 4ª más abajo.
    public static let tritusPlagalis = TipoDeEscala(
        nombre: "tritus plagalis", intervalos: TipoDeEscala.lidio.intervalos,
        alias: ["tritus plagal", "modo gregoriano 6", "hipolidio", "modo 8 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 7, en Sol: el mixolidio.
    public static let tetrardusAuthenticus = TipoDeEscala(
        nombre: "tetrardus authenticus", intervalos: TipoDeEscala.mixolidio.intervalos,
        alias: ["tetrardus auténtico", "modo gregoriano 7", "modo 9 de Zarlino"],
        categoria: .modoGregoriano)
    /// Modo 8, en Sol: el mixolidio, con el ámbito una 4ª más abajo.
    public static let tetrardusPlagalis = TipoDeEscala(
        nombre: "tetrardus plagalis", intervalos: TipoDeEscala.mixolidio.intervalos,
        alias: ["tetrardus plagal", "modo gregoriano 8", "hipomixolidio", "modo 10 de Zarlino"],
        categoria: .modoGregoriano)

    /// Los ocho, del 1 al 8.
    package static let modosGregorianos: [TipoDeEscala] = [
        .protusAuthenticus, .protusPlagalis, .deuterusAuthenticus, .deuterusPlagalis, .tritusAuthenticus,
        .tritusPlagalis, .tetrardusAuthenticus, .tetrardusPlagalis,
    ]

    // MARK: Modos de Glareano
    //
    // Los cuatro que Heinrich Glareano añadió a los ocho en el Dodecachordon (1547), con sus nombres latinos y sus
    // números: el 9 y el 10 en La (el eólico y su plagal) y el 11 y el 12 en Do (el jónico y su plagal). Como los
    // gregorianos, cada uno va desde su final, y el plagal solo cambia el ámbito.
    //
    // Zarlino los volvió a numerar en las Dimostrationi harmoniche (1571), empezando por Do: el 1 y el 2 son los de
    // Do (el jónico), el 3 y el 4 los de Re… hasta el 11 y el 12, los de La. Cada uno, de los gregorianos y de
    // estos, lleva su número de Zarlino de alias («modo 3 de Zarlino» es el protus authenticus).

    /// Modo 9, en La: el eólico.
    public static let aeolius = TipoDeEscala(
        nombre: "aeolius", intervalos: TipoDeEscala.menorNatural.intervalos,
        alias: ["modus aeolius", "modo de Glareano 9", "modo 9", "modo 11 de Zarlino"],
        categoria: .escala, fuente: .glareano)
    /// Modo 10, en La: el eólico, con el ámbito una 4ª más abajo.
    public static let hypoaeolius = TipoDeEscala(
        nombre: "hypoaeolius", intervalos: TipoDeEscala.menorNatural.intervalos,
        alias: ["modus hypoaeolius", "hipoeólico", "modo de Glareano 10", "modo 10", "modo 12 de Zarlino"],
        categoria: .escala, fuente: .glareano)
    /// Modo 11, en Do: el jónico.
    public static let ionicus = TipoDeEscala(
        nombre: "ionicus", intervalos: TipoDeEscala.mayor.intervalos,
        alias: ["modus ionicus", "modo de Glareano 11", "modo 11", "modo 1 de Zarlino"],
        categoria: .escala, fuente: .glareano)
    /// Modo 12, en Do: el jónico, con el ámbito una 4ª más abajo.
    public static let hypoionicus = TipoDeEscala(
        nombre: "hypoionicus", intervalos: TipoDeEscala.mayor.intervalos,
        alias: ["modus hypoionicus", "hipojónico", "modo de Glareano 12", "modo 12", "modo 2 de Zarlino"],
        categoria: .escala, fuente: .glareano)

    /// Los cuatro, del 9 al 12.
    package static let modosDeGlareano: [TipoDeEscala] = [.aeolius, .hypoaeolius, .ionicus, .hypoionicus]

    // MARK: Hexacordos de Guido de Arezzo
    //
    // Los tres hexacordos de la solmisación medieval (ut re mi fa sol la), con el semitono mi–fa en medio: el natural
    // en Do, el duro en Sol (con Si, el «b duro») y el blando en Fa (con Si♭, el «b blando»). Tienen los mismos
    // intervalos y se distinguen por la nota en que empiezan, la que dice cada uno; con sus nombres latinos y, de
    // alias, los españoles.

    /// Do Re Mi Fa Sol La.
    public static let hexacordoNatural = TipoDeEscala(
        nombre: "hexachordum naturale",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["hexacordo natural"],
        categoria: .hexacordo, fuente: .guido)
    /// Sol La Si Do Re Mi.
    public static let hexacordoDuro = TipoDeEscala(
        nombre: "hexachordum durum",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["hexacordo duro"],
        categoria: .hexacordo, fuente: .guido)
    /// Fa Sol La Si♭ Do Re.
    public static let hexacordoBlando = TipoDeEscala(
        nombre: "hexachordum molle",
        intervalos: [.unisono, .segundaMayor, .terceraMayor, .cuartaJusta, .quintaJusta, .sextaMayor],
        alias: ["hexacordo blando"],
        categoria: .hexacordo, fuente: .guido)

    /// Los tres hexacordos: natural, duro y blando.
    package static let hexacordos: [TipoDeEscala] = [.hexacordoNatural, .hexacordoDuro, .hexacordoBlando]
}
