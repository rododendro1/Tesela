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
    // Arquitas de Tarento (el enarmónico de Arquitas, con su parhýpate a 63 cents, va más abajo con los de Dídimo y
    // Eratóstenes) y las suyas, de grave a agudo. El diatónico tónico de Ptolomeo es el de Arquitas. En
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

    // MARK: Más géneros: el enarmónico de Arquitas, Dídimo y Eratóstenes
    //
    // Las demás divisiones del tetracordo que recoge Ptolomeo: el enarmónico de Arquitas, con la parhýpate a 63
    // cents, y los géneros de Dídimo (siglo I a. C.) y de Eratóstenes (siglo III a. C.). El diatónico de Eratóstenes
    // es el pitagórico (el diatónico ditónico) y no se repite. En doce notas, los enarmónicos de Arquitas y de Dídimo,
    // cuya parhýpate está más cerca de Fa que de Mi, se escriben Mi Mi♯ Fa La; su versión microtonal va en cents.

    /// El enarmónico de Arquitas (28/27, 36/35, 5/4): Mi Mi♯ Fa La, con la parhýpate a 63 cents.
    public static let tetracordoEnarmonicoDeArquitas = TipoDeEscala(
        nombre: "tetracordo enarmónico de Arquitas",
        intervalos: [.unisono, .unisonoAumentado, .segundaMenor, .cuartaJusta])
    /// El cromático de Dídimo (16/15, 25/24, 6/5): Mi Fa Sol♭ La.
    public static let tetracordoCromaticoDeDidimo = TipoDeEscala(
        nombre: "tetracordo cromático de Dídimo",
        intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta])
    /// El diatónico de Dídimo (16/15, 10/9, 9/8): Mi Fa Sol La.
    public static let tetracordoDiatonicoDeDidimo = TipoDeEscala(
        nombre: "tetracordo diatónico de Dídimo",
        intervalos: [.unisono, .segundaMenor, .terceraMenor, .cuartaJusta])
    /// El enarmónico de Dídimo (32/31, 31/30, 5/4): Mi Mi♯ Fa La.
    public static let tetracordoEnarmonicoDeDidimo = TipoDeEscala(
        nombre: "tetracordo enarmónico de Dídimo",
        intervalos: [.unisono, .unisonoAumentado, .segundaMenor, .cuartaJusta])
    /// El cromático de Eratóstenes (20/19, 19/18, 6/5): Mi Fa Sol♭ La.
    public static let tetracordoCromaticoDeEratostenes = TipoDeEscala(
        nombre: "tetracordo cromático de Eratóstenes",
        intervalos: [.unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta])
    /// El enarmónico de Eratóstenes (40/39, 39/38, 19/15): Mi Fa♭ Fa La.
    public static let tetracordoEnarmonicoDeEratostenes = TipoDeEscala(
        nombre: "tetracordo enarmónico de Eratóstenes",
        intervalos: [.unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta])

    /// El enarmónico de Arquitas y los géneros de Dídimo y de Eratóstenes.
    public static let generosDeDidimoYEratostenes: [TipoDeEscala] = [
        .tetracordoEnarmonicoDeArquitas, .tetracordoCromaticoDeDidimo, .tetracordoDiatonicoDeDidimo,
        .tetracordoEnarmonicoDeDidimo, .tetracordoCromaticoDeEratostenes, .tetracordoEnarmonicoDeEratostenes,
    ]

    // MARK: Las harmoniai en los géneros cromático y enarmónico
    //
    // Las especies de octava de Cleónides en la escala de Mi a Mi de los otros dos géneros, cada una desde su nota:
    // la cromática, Mi Fa Sol♭ La Si Do Re♭ (la doria cromática ya está arriba), y la enarmónica, Mi Fa𝄳 Fa La Si Do𝄳
    // Do. En doce notas cada grado de la enarmónica va al semitono más cercano desde su tónica (Fa𝄳 se escribe Fa♭ o
    // Fa), y su versión microtonal va en cuartos de tono. La frigia y la hipofrigia tienen un grado un cuarto de tono
    // bajo la octava, así que su tónica va un cuarto de tono bajo la nota escrita (Do𝄳 sobre Do), como Sīkāh.

    /// Si Do Re♭ Mi Fa Sol♭ La, en la escala cromática de Mi a Mi.
    public static let harmoniaMixolidiaCromatica = TipoDeEscala(
        nombre: "harmonía mixolidia cromática",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta,
            .quintaDisminuida, .sextaDisminuida, .septimaMenor,
        ])
    /// Do Re♭ Mi Fa Sol♭ La Si, en la escala cromática de Mi a Mi.
    public static let harmoniaLidiaCromatica = TipoDeEscala(
        nombre: "harmonía lidia cromática",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMayor,
        ])
    /// Re♭ Mi Fa Sol♭ La Si Do, en la escala cromática de Mi a Mi.
    public static let harmoniaFrigiaCromatica = TipoDeEscala(
        nombre: "harmonía frigia cromática",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ])
    /// Fa Sol♭ La Si Do Re♭ Mi, en la escala cromática de Mi a Mi.
    public static let harmoniaHipolidiaCromatica = TipoDeEscala(
        nombre: "harmonía hipolidia cromática",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ])
    /// Sol♭ La Si Do Re♭ Mi Fa, en la escala cromática de Mi a Mi.
    public static let harmoniaHipofrigiaCromatica = TipoDeEscala(
        nombre: "harmonía hipofrigia cromática",
        intervalos: [
            .unisono, .segundaAumentada, .terceraAumentada, .cuartaAumentada,
            .quintaJusta, .sextaAumentada, .septimaMayor,
        ])
    /// La Si Do Re♭ Mi Fa Sol♭, en la escala cromática de Mi a Mi.
    public static let harmoniaHipodoriaCromatica = TipoDeEscala(
        nombre: "harmonía hipodoria cromática",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaDisminuida,
        ])
    /// Si Do𝄳 Do Mi Fa𝄳 Fa La, en la escala enarmónica de Mi a Mi.
    public static let harmoniaMixolidiaEnarmonica = TipoDeEscala(
        nombre: "harmonía mixolidia enarmónica",
        intervalos: [
            .unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta,
            .cuartaAumentada, .quintaDisminuida, .septimaMenor,
        ])
    /// Do𝄳 Do Mi Fa𝄳 Fa La Si, en la escala enarmónica de Mi a Mi.
    public static let harmoniaLidiaEnarmonica = TipoDeEscala(
        nombre: "harmonía lidia enarmónica",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .septimaMenor, .septimaMayor,
        ])
    /// Do Mi Fa𝄳 Fa La Si Do𝄳, en la escala enarmónica de Mi a Mi.
    public static let harmoniaFrigiaEnarmonica = TipoDeEscala(
        nombre: "harmonía frigia enarmónica",
        intervalos: [.unisono, .terceraMenor, .terceraMayor, .cuartaJusta, .sextaMayor, .septimaMenor, .septimaMayor])
    /// Mi Fa𝄳 Fa La Si Do𝄳 Do, en la escala enarmónica de Mi a Mi.
    public static let harmoniaDoriaEnarmonica = TipoDeEscala(
        nombre: "harmonía doria enarmónica",
        intervalos: [
            .unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta,
            .quintaJusta, .sextaDisminuida, .sextaMenor,
        ])
    /// Fa𝄳 Fa La Si Do𝄳 Do Mi, en la escala enarmónica de Mi a Mi.
    public static let harmoniaHipolidiaEnarmonica = TipoDeEscala(
        nombre: "harmonía hipolidia enarmónica",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaDisminuida, .sextaMenor, .septimaMayor])
    /// Fa La Si Do𝄳 Do Mi Fa𝄳, en la escala enarmónica de Mi a Mi.
    public static let harmoniaHipofrigiaEnarmonica = TipoDeEscala(
        nombre: "harmonía hipofrigia enarmónica",
        intervalos: [
            .unisono, .terceraMayor, .cuartaJusta, .quintaDisminuida,
            .quintaJusta, .septimaMenor, .septimaMayor,
        ])
    /// La Si Do𝄳 Do Mi Fa𝄳 Fa, en la escala enarmónica de Mi a Mi.
    public static let harmoniaHipodoriaEnarmonica = TipoDeEscala(
        nombre: "harmonía hipodoria enarmónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraDisminuida, .terceraMenor,
            .quintaJusta, .sextaDisminuida, .sextaMenor,
        ])
    /// Las harmoniai en el género cromático, salvo la doria (`harmoniaDoriaCromatica`), de la más aguda a la más grave.
    public static let harmoniaiCromaticas: [TipoDeEscala] = [
        .harmoniaMixolidiaCromatica, .harmoniaLidiaCromatica, .harmoniaFrigiaCromatica, .harmoniaHipolidiaCromatica,
        .harmoniaHipofrigiaCromatica, .harmoniaHipodoriaCromatica,
    ]
    /// Las siete harmoniai en el género enarmónico, de la más aguda a la más grave.
    public static let harmoniaiEnarmonicas: [TipoDeEscala] = [
        .harmoniaMixolidiaEnarmonica, .harmoniaLidiaEnarmonica, .harmoniaFrigiaEnarmonica, .harmoniaDoriaEnarmonica,
        .harmoniaHipolidiaEnarmonica, .harmoniaHipofrigiaEnarmonica, .harmoniaHipodoriaEnarmonica,
    ]

    // MARK: Las harmoniai de Arístides Quintiliano
    //
    // Las seis escalas que Arístides Quintiliano (siglo III) atribuye a «los muy antiguos», las de la época de Platón:
    // lidia, doria, frigia, iastia (o jonia), mixolidia y sintonolidia. Son enarmónicas, no son especies de una misma
    // escala y no todas abarcan una octava. Van en cuartos de tono en su versión microtonal y, en doce notas, con
    // cada grado redondeado al semitono más cercano. Fuente: M. L. West, Ancient Greek Music (1992).

    /// En tonos: ¼, 2, 1, ¼, ¼, 2 y ¼ (Mi𝄲 Fa La Si Si𝄲 Do Mi, desde Mi𝄲).
    public static let harmoniaLidiaDeAristides = TipoDeEscala(
        nombre: "harmonía lidia de Arístides",
        intervalos: [.unisono, .segundaMenor, .cuartaJusta, .quintaJusta, .sextaDisminuida, .sextaMenor, .septimaMayor])
    /// En tonos: 1, ¼, ¼, 2, 1, ¼, ¼ y 2. Abarca una novena: el tono de arriba no cabe en la octava.
    public static let harmoniaDoriaDeAristides = TipoDeEscala(
        nombre: "harmonía doria de Arístides",
        intervalos: [
            .unisono, .segundaMayor, .terceraDisminuida, .terceraMenor,
            .quintaJusta, .sextaMayor, .septimaDisminuida, .septimaMenor,
        ])
    /// En tonos: 1, ¼, ¼, 2, 1, ¼, ¼ y 1: en una octava, las notas de la doria.
    public static let harmoniaFrigiaDeAristides = TipoDeEscala(
        nombre: "harmonía frigia de Arístides",
        intervalos: [
            .unisono, .segundaMayor, .terceraDisminuida, .terceraMenor,
            .quintaJusta, .sextaMayor, .septimaDisminuida, .septimaMenor,
        ])
    /// En tonos: ¼, ¼, 2, 1½ y 1. No llega a la octava.
    public static let harmoniaIastiaDeAristides = TipoDeEscala(
        nombre: "harmonía iastia de Arístides",
        intervalos: [.unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta, .sextaMenor, .septimaMenor],
        alias: ["harmonía jonia de Arístides"])
    /// En tonos: ¼, ¼, 1, 1, ¼, ¼ y 3.
    public static let harmoniaMixolidiaDeAristides = TipoDeEscala(
        nombre: "harmonía mixolidia de Arístides",
        intervalos: [
            .unisono, .segundaDisminuida, .segundaMenor, .terceraMenor,
            .cuartaJusta, .cuartaAumentada, .quintaDisminuida,
        ])
    /// En tonos: ¼, ¼, 2 y 1½: abarca una sexta menor.
    public static let harmoniaSintonolidiaDeAristides = TipoDeEscala(
        nombre: "harmonía sintonolidia de Arístides",
        intervalos: [.unisono, .segundaDisminuida, .segundaMenor, .cuartaJusta, .sextaMenor])
    /// Las seis harmoniai de Arístides Quintiliano.
    public static let harmoniaiDeAristides: [TipoDeEscala] = [
        .harmoniaLidiaDeAristides, .harmoniaDoriaDeAristides, .harmoniaFrigiaDeAristides, .harmoniaIastiaDeAristides,
        .harmoniaMixolidiaDeAristides, .harmoniaSintonolidiaDeAristides,
    ]
}

// MARK: Ficha

extension FichaDeTradicion {
    static let greciaAntigua = FichaDeTradicion(
        .greciaAntigua,
        [
            .init(.tetracordo, TipoDeEscala.tetracordosGriegos),
            .init(.tetracordo, TipoDeEscala.generosDeArquitasYPtolomeo),
            .init(.harmonia, TipoDeEscala.harmoniai),
            .init(.tetracordo, TipoDeEscala.generosDeDidimoYEratostenes),
            .init(.harmonia, TipoDeEscala.harmoniaiCromaticas),
            .init(.harmonia, TipoDeEscala.harmoniaiEnarmonicas),
            .init(.harmonia, TipoDeEscala.harmoniaiDeAristides),
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
            // El enarmónico de Arquitas y los géneros de Dídimo y de Eratóstenes, en cents.
            TipoDeEscalaMicrotonal(.tetracordoEnarmonicoDeArquitas, .razones, pasos: [0, 63, 112, 498]),
            TipoDeEscalaMicrotonal(.tetracordoCromaticoDeDidimo, .razones, pasos: [0, 112, 182, 498]),
            TipoDeEscalaMicrotonal(.tetracordoDiatonicoDeDidimo, .razones, pasos: [0, 112, 294, 498]),
            TipoDeEscalaMicrotonal(.tetracordoEnarmonicoDeDidimo, .razones, pasos: [0, 55, 112, 498]),
            TipoDeEscalaMicrotonal(.tetracordoCromaticoDeEratostenes, .razones, pasos: [0, 89, 182, 498]),
            TipoDeEscalaMicrotonal(.tetracordoEnarmonicoDeEratostenes, .razones, pasos: [0, 44, 89, 498]),
            // Las harmoniai enarmónicas y las de Arístides, en cuartos de tono.
            TipoDeEscalaMicrotonal(.harmoniaMixolidiaEnarmonica, .cuartosDeTono, pasos: [0, 1, 2, 10, 11, 12, 20]),
            TipoDeEscalaMicrotonal(.harmoniaLidiaEnarmonica, .cuartosDeTono, pasos: [0, 1, 9, 10, 11, 19, 23]),
            TipoDeEscalaMicrotonal(.harmoniaFrigiaEnarmonica, .cuartosDeTono, pasos: [-1, 7, 8, 9, 17, 21, 22]),
            TipoDeEscalaMicrotonal(.harmoniaDoriaEnarmonica, .cuartosDeTono, pasos: [0, 1, 2, 10, 14, 15, 16]),
            TipoDeEscalaMicrotonal(.harmoniaHipolidiaEnarmonica, .cuartosDeTono, pasos: [0, 1, 9, 13, 14, 15, 23]),
            TipoDeEscalaMicrotonal(.harmoniaHipofrigiaEnarmonica, .cuartosDeTono, pasos: [-1, 7, 11, 12, 13, 21, 22]),
            TipoDeEscalaMicrotonal(.harmoniaHipodoriaEnarmonica, .cuartosDeTono, pasos: [0, 4, 5, 6, 14, 15, 16]),
            TipoDeEscalaMicrotonal(.harmoniaLidiaDeAristides, .cuartosDeTono, pasos: [0, 1, 9, 13, 14, 15, 23]),
            TipoDeEscalaMicrotonal(.harmoniaDoriaDeAristides, .cuartosDeTono, pasos: [0, 4, 5, 6, 14, 18, 19, 20]),
            TipoDeEscalaMicrotonal(.harmoniaFrigiaDeAristides, .cuartosDeTono, pasos: [0, 4, 5, 6, 14, 18, 19, 20]),
            TipoDeEscalaMicrotonal(.harmoniaIastiaDeAristides, .cuartosDeTono, pasos: [0, 1, 2, 10, 16, 20]),
            TipoDeEscalaMicrotonal(.harmoniaMixolidiaDeAristides, .cuartosDeTono, pasos: [0, 1, 2, 6, 10, 11, 12]),
            TipoDeEscalaMicrotonal(.harmoniaSintonolidiaDeAristides, .cuartosDeTono, pasos: [0, 1, 2, 10, 16]),
        ])
}
