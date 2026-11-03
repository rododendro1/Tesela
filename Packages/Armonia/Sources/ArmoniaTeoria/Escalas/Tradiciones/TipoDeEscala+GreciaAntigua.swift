import ArmoniaNucleo

// MARK: - GreciaAntigua

extension TipoDeEscala {
    // MARK: Grecia antigua
    //
    // Los tetracordos de Aristóxeno, de grave a agudo (semitono, tono, tono en el diatónico;
    // semitono, semitono y tercera menor en el cromático; cuarto de tono, cuarto de tono y tercera mayor en el
    // enarmónico), y las siete harmoniai, las especies de octava de Cleónides, cada una desde su nota de la escala
    // de Mi a Mi: mixolidia en Si, lidia en Do, frigia en Re, doria en Mi, hipolidia en Fa, hipofrigia en Sol e
    // hipodoria en La. El enarmónico no cabe en doce notas: su parhýpate, un cuarto de tono sobre Mi, se escribe
    // Fa♭ (Mi Fa♭ Fa La), y su versión microtonal, en cuartos de tono, la sube a Fa𝄳.

    /// Mi Fa Sol La.
    public static let tetracordoDiatonico = TipoDeEscala(
        nombre: "tetracordo diatónico", intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["tetracordo dorio"])
    /// Mi Fa Sol♭ La: la lichanós baja medio tono.
    public static let tetracordoCromatico = TipoDeEscala(
        nombre: "tetracordo cromático", intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta])
    /// Mi Fa♭ Fa La: dos cuartos de tono y un dítono (Mi Fa𝄳 Fa La en su versión microtonal).
    public static let tetracordoEnarmonico = TipoDeEscala(
        nombre: "tetracordo enarmónico", intervalos: [.unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta])
    /// De Si a Si (el locrio moderno).
    public static let harmoniaMixolidia = TipoDeEscala(
        nombre: "harmonía mixolidia",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["mixolidia antigua"])
    /// De Mi a Mi: dos tetracordos diatónicos (el frigio moderno).
    public static let harmoniaDoria = TipoDeEscala(
        nombre: "harmonía doria",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["doria antigua"])
    /// De Mi a Mi en el género cromático (Mi Fa Sol♭ La Si Do Re♭).
    public static let harmoniaDoriaCromatica = TipoDeEscala(
        nombre: "harmonía doria cromática",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaDisminuida,
        ])
    /// De Re a Re (el dórico moderno).
    public static let harmoniaFrigia = TipoDeEscala(
        nombre: "harmonía frigia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["frigia antigua"])
    /// De Do a Do (la mayor).
    public static let harmoniaLidia = TipoDeEscala(
        nombre: "harmonía lidia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidia antigua"])
    /// De Fa a Fa (el lidio moderno).
    public static let harmoniaHipolidia = TipoDeEscala(
        nombre: "harmonía hipolidia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["hipolidia antigua"])
    /// De Sol a Sol (el mixolidio moderno).
    public static let harmoniaHipofrigia = TipoDeEscala(
        nombre: "harmonía hipofrigia",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["hipofrigia antigua"])
    /// De La a La (el eolio moderno); Cleónides la llama también locria.
    public static let harmoniaHipodoria = TipoDeEscala(
        nombre: "harmonía hipodoria",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["hipodoria antigua"])

    // MARK: Géneros de Arquitas y de Ptolomeo
    //
    // Las divisiones del tetracordo en razones justas que recoge Ptolomeo en sus Harmónicas (siglo II): las tres de
    // Arquitas de Tarento (el enarmónico de Arquitas, con su parhýpate a 63 cents, no cabe en doce notas sin cambiar
    // de letra y queda fuera) y las suyas, de grave a agudo. El diatónico tónico de Ptolomeo es el de Arquitas. En
    // doce notas son el tetracordo cromático o el diatónico (el igual, con su segunda neutra de 151 cents, sube a Fa♯,
    // y el enarmónico de Ptolomeo es el de Aristóxeno); su versión microtonal, en cents, está en la ficha, abajo.

    /// El enarmónico de Ptolomeo (46/45, 24/23, 5/4): Mi Fa♭ Fa La, con la parhýpate a 38 cents.
    public static let tetracordoEnarmonicoDePtolomeo = TipoDeEscala(
        nombre: "tetracordo enarmónico de Ptolomeo",
        intervalos: [.unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta])
    /// El cromático de Arquitas (28/27, 243/224, 32/27): Mi Fa Sol♭ La.
    public static let tetracordoCromaticoDeArquitas = TipoDeEscala(
        nombre: "tetracordo cromático de Arquitas",
        intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta])
    /// El diatónico de Arquitas (28/27, 8/7, 9/8), que Ptolomeo llama tónico: Mi Fa Sol La.
    public static let tetracordoDiatonicoDeArquitas = TipoDeEscala(
        nombre: "tetracordo diatónico de Arquitas",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["tetracordo diatónico tónico"])
    /// El cromático blando de Ptolomeo (28/27, 15/14, 6/5): Mi Fa Sol♭ La.
    public static let tetracordoCromaticoBlando = TipoDeEscala(
        nombre: "tetracordo cromático blando",
        intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta],
        alias: ["cromático blando de Ptolomeo"])
    /// El cromático tenso de Ptolomeo (22/21, 12/11, 7/6): Mi Fa Sol♭ La.
    public static let tetracordoCromaticoTenso = TipoDeEscala(
        nombre: "tetracordo cromático tenso",
        intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta],
        alias: ["cromático tenso de Ptolomeo", "tetracordo cromático sintónico"])
    /// El diatónico blando de Ptolomeo (21/20, 10/9, 8/7): Mi Fa Sol La.
    public static let tetracordoDiatonicoBlando = TipoDeEscala(
        nombre: "tetracordo diatónico blando",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["diatónico blando de Ptolomeo"])
    /// El diatónico ditónico de Ptolomeo (256/243, 9/8, 9/8), el pitagórico: Mi Fa Sol La.
    public static let tetracordoDiatonicoDitonico = TipoDeEscala(
        nombre: "tetracordo diatónico ditónico",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["tetracordo pitagórico", "diatónico ditónico de Ptolomeo"])
    /// El diatónico tenso de Ptolomeo (16/15, 9/8, 10/9), el de la entonación justa: Mi Fa Sol La.
    public static let tetracordoDiatonicoTenso = TipoDeEscala(
        nombre: "tetracordo diatónico tenso",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta],
        alias: ["diatónico tenso de Ptolomeo", "tetracordo diatónico sintónico"])
    /// El diatónico igual de Ptolomeo (12/11, 11/10, 10/9): Mi Fa♯ Sol La, con la segunda neutra a 151 cents.
    public static let tetracordoDiatonicoIgual = TipoDeEscala(
        nombre: "tetracordo diatónico igual",
        intervalos: [.unisono, .segundaMayor, .terceraMenor, .cuartaJusta],
        alias: ["diatónico igual de Ptolomeo", "tetracordo diatónico homalón"])

    /// Los tres tetracordos de Aristóxeno.
    public static let tetracordosGriegos: [TipoDeEscala] = [
        .tetracordoDiatonico, .tetracordoCromatico, .tetracordoEnarmonico,
    ]
    /// Las siete harmoniai, de la más aguda a la más grave, y la doria en el género cromático.
    public static let harmoniai: [TipoDeEscala] = [
        .harmoniaMixolidia, .harmoniaLidia, .harmoniaFrigia, .harmoniaDoria, .harmoniaDoriaCromatica,
        .harmoniaHipolidia, .harmoniaHipofrigia, .harmoniaHipodoria,
    ]

    /// Los géneros de Arquitas y de Ptolomeo, en el orden de las Harmónicas: los de Arquitas y después los de
    /// Ptolomeo, del enarmónico al diatónico.
    public static let generosDeArquitasYPtolomeo: [TipoDeEscala] = [
        .tetracordoCromaticoDeArquitas, .tetracordoDiatonicoDeArquitas, .tetracordoEnarmonicoDePtolomeo,
        .tetracordoCromaticoBlando, .tetracordoCromaticoTenso, .tetracordoDiatonicoBlando,
        .tetracordoDiatonicoDitonico, .tetracordoDiatonicoTenso, .tetracordoDiatonicoIgual,
    ]

    public static let griegasAntiguas: [TipoDeEscala] = tetracordosGriegos + generosDeArquitasYPtolomeo + harmoniai
}

// MARK: Ficha

extension FichaDeTradicion {
    static let greciaAntigua = FichaDeTradicion(
        .greciaAntigua,
        [
            .init(.tetracordo, TipoDeEscala.tetracordosGriegos),
            .init(.tetracordo, TipoDeEscala.generosDeArquitasYPtolomeo),
            .init(.harmonia, TipoDeEscala.harmoniai),
        ],
        microtonales: [
            // El tetracordo enarmónico de Aristóxeno, en cuartos de tono: Mi Fa𝄳 Fa La (la parhýpate, un cuarto de tono
            // sobre Mi, se escribe Fa♭ en doce notas).
            TipoDeEscalaMicrotonal(.tetracordoEnarmonico, .cuartosDeTono, pasos: [0, 1, 2, 10]),
            // Los géneros de Arquitas y de Ptolomeo, con sus razones en cents (Mi a 0, La a 498, la cuarta justa 4/3).
            TipoDeEscalaMicrotonal(.tetracordoCromaticoDeArquitas, .razones, pasos: [0, 63, 204, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoDeArquitas, .razones, pasos: [0, 63, 294, 498]),
            TipoDeEscalaMicrotonal(.tetracordoEnarmonicoDePtolomeo, .razones, pasos: [0, 38, 112, 498]),
            TipoDeEscalaMicrotonal(.tetracordoCromaticoBlando, .razones, pasos: [0, 63, 182, 498]),
            TipoDeEscalaMicrotonal(.tetracordoCromaticoTenso, .razones, pasos: [0, 81, 231, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoBlando, .razones, pasos: [0, 84, 267, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoDitonico, .razones, pasos: [0, 90, 294, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoTenso, .razones, pasos: [0, 112, 316, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoIgual, .razones, pasos: [0, 151, 316, 498]),
        ])
}
