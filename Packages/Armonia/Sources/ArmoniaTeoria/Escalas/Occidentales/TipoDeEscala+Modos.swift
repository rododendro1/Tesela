import ArmoniaNucleo

// MARK: - Modos de la menor armónica, de la menor melódica y de la mayor armónica, y otros modos habituales.

extension TipoDeEscala {
    // Modos de la menor armónica (2.º a 7.º grado).
    public static let locrioSextaNatural = TipoDeEscala(
        nombre: "locrio ♮6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["locrio natural 6", "locrio ♯6"])
    public static let jonicoAumentado = TipoDeEscala(
        nombre: "jónico ♯5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["jónico aumentado"])
    public static let doricoCuartaAumentada = TipoDeEscala(
        nombre: "dórico ♯4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["dórico ucraniano", "menor rumana", "rumana"])
    public static let frigioDominante = TipoDeEscala(
        nombre: "frigio dominante",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["frigio mayor", "frigio ♯3", "española", "frigio español", "dominante ♭9 ♭13", "frigio ♮3"])
    public static let lidioSegundaAumentada = TipoDeEscala(
        nombre: "lidio ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ])
    public static let ultralocrio = TipoDeEscala(
        nombre: "ultralocrio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ],
        alias: ["superlocrio ♭♭7", "alterada disminuida"])

    // Modos de la menor melódica (2.º a 7.º grado).
    public static let doricoSegundaMenor = TipoDeEscala(
        nombre: "dórico ♭2",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["frigio ♮6"])
    public static let lidioAumentado = TipoDeEscala(
        nombre: "lidio aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidio ♯5"])
    public static let lidioDominante = TipoDeEscala(
        nombre: "lidio dominante",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: [
            "lidio ♭7", "acústica", "de Bartók", "Bartók", "de los armónicos", "armónicos", "nordestina",
            "escala nordestina", "mixolidio ♯4",
        ])
    public static let mixolidioSextaMenor = TipoDeEscala(
        nombre: "mixolidio ♭6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["hindú", "mayor melódica", "eólico dominante"])
    public static let locrioSegundaNatural = TipoDeEscala(
        nombre: "locrio ♮2",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["locrio natural 2", "semidisminuida"])
    public static let alterada = TipoDeEscala(
        nombre: "alterada",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["superlocrio", "superlocria"])

    // Otras.
    public static let mayorArmonica = TipoDeEscala(
        nombre: "mayor armónica",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMenor, .septimaMayor,
        ])
    public static let bebopDominante = TipoDeEscala(
        nombre: "bebop dominante",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor, .septimaMayor,
        ],
        alias: ["bebop"])
    public static let bebopMayor = TipoDeEscala(
        nombre: "bebop mayor",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .quintaAumentada, .sextaMayor, .septimaMayor,
        ])
    public static let bebopDorico = TipoDeEscala(
        nombre: "bebop dórico",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .terceraMayor,
            .cuartaJusta, .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["bebop menor"])

    // Modos de la mayor armónica (2.º a 7.º grado).
    public static let doricoQuintaDisminuida = TipoDeEscala(
        nombre: "dórico ♭5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["dórico b5"])
    public static let frigioCuartaDisminuida = TipoDeEscala(
        nombre: "frigio ♭4",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["superfrigio"])
    public static let lidioTerceraMenor = TipoDeEscala(
        nombre: "lidio ♭3",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ],
        alias: ["lidio disminuido"])
    public static let mixolidioSegundaMenor = TipoDeEscala(
        nombre: "mixolidio ♭2",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ])
    public static let lidioAumentadoSegundaAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ])
    public static let locrioSeptimaDisminuida = TipoDeEscala(
        nombre: "locrio ♭♭7",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ])
}

// MARK: - Modos de la doble armónica, de las napolitanas y de la mayor húngara.

extension TipoDeEscala {
    // Modos de la doble armónica (2.º, 3.º, 5.º, 6.º y 7.º grado; el 4.º es la menor húngara).

    /// Do Re♯ Mi Fa♯ Sol La♯ Si.
    public static let lidioSegundaSextaAumentadas = TipoDeEscala(
        nombre: "lidio ♯2 ♯6",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaAumentada, .septimaMayor,
        ])
    /// Do Re♭ Mi♭ Fa♭ Sol La♭ Si♭♭.
    public static let ultrafrigio = TipoDeEscala(
        nombre: "ultrafrigio",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaJusta, .sextaMenor, .septimaDisminuida,
        ])
    /// Do Re♭ Mi Fa Sol♭ La Si♭.
    public static let oriental = TipoDeEscala(
        nombre: "oriental",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ])
    /// Do Re♯ Mi Fa Sol♯ La Si.
    public static let jonicoSegundaQuintaAumentadas = TipoDeEscala(
        nombre: "jónico ♯2 ♯5",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ])
    /// Do Re♭ Mi♭♭ Fa Sol♭ La♭ Si♭♭.
    public static let locrioTerceraSeptimaDisminuidas = TipoDeEscala(
        nombre: "locrio ♭♭3 ♭♭7",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ])

    // Modos de la napolitana mayor (2.º, 3.º, 6.º y 7.º; el 4.º es el lidio menor y el 5.º,
    // la mayor locria).

    /// Do Re Mi Fa♯ Sol♯ La♯ Si: tonos enteros con sensible.
    public static let lidioAumentadoSextaAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaAumentada, .septimaMayor,
        ],
        alias: ["tonos enteros con sensible"])
    /// Do Re Mi Fa♯ Sol♯ La Si♭.
    public static let lidioDominanteAumentado = TipoDeEscala(
        nombre: "lidio dominante aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMenor,
        ],
        alias: ["lidio dominante ♯5", "lidio aumentado ♭7"])
    /// Do Re Mi♭ Fa♭ Sol♭ La♭ Si♭.
    public static let locrioSegundaNaturalCuartaDisminuida = TipoDeEscala(
        nombre: "locrio ♮2 ♭4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["semidisminuida ♭4", "locrio natural 2 ♭4"])
    /// Do Re♭ Mi♭♭ Fa♭ Sol♭ La♭ Si♭.
    public static let superlocrioTerceraDisminuida = TipoDeEscala(
        nombre: "superlocrio ♭♭3",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["alterada ♭♭3"])

    // Modos de la napolitana menor (2.º a 7.º).

    /// Do Re Mi Fa♯ Sol La♯ Si.
    public static let lidioSextaAumentada = TipoDeEscala(
        nombre: "lidio ♯6",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaAumentada,
            .quintaJusta, .sextaAumentada, .septimaMayor,
        ])
    /// Do Re Mi Fa Sol♯ La Si♭.
    public static let mixolidioAumentado = TipoDeEscala(
        nombre: "mixolidio aumentado",
        intervalos: [
            .unisono, .segundaMayor, .terceraMayor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMenor,
        ],
        alias: ["mixolidio ♯5"])
    /// Do Re Mi♭ Fa♯ Sol La♭ Si♭: la menor natural con la 4ª aumentada.
    public static let eolicoCuartaAumentada = TipoDeEscala(
        nombre: "eólico ♯4",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMenor, .septimaMenor,
        ],
        alias: ["gitana húngara", "menor ♯4"])
    /// Do Re♭ Mi Fa Sol♭ La♭ Si♭.
    public static let locrioDominante = TipoDeEscala(
        nombre: "locrio dominante",
        intervalos: [
            .unisono, .segundaMenor, .terceraMayor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMenor,
        ],
        alias: ["locrio ♮3", "locrio mayor ♭2"])
    /// Do Re♯ Mi Fa Sol La Si.
    public static let jonicoSegundaAumentada = TipoDeEscala(
        nombre: "jónico ♯2",
        intervalos: [
            .unisono, .segundaAumentada, .terceraMayor, .cuartaJusta,
            .quintaJusta, .sextaMayor, .septimaMayor,
        ])
    /// Do Re♭ Mi♭♭ Fa♭ Sol♭ La♭ Si♭♭.
    public static let ultralocrioTerceraDisminuida = TipoDeEscala(
        nombre: "ultralocrio ♭♭3",
        intervalos: [
            .unisono, .segundaMenor, .terceraDisminuida, .cuartaDisminuida,
            .quintaDisminuida, .sextaMenor, .septimaDisminuida,
        ])

    // Modos de la mayor húngara (2.º a 7.º).

    /// Do Re♭ Mi♭ Fa♭ Sol♭ La♭♭ Si♭♭.
    public static let ultralocrioSextaDisminuida = TipoDeEscala(
        nombre: "ultralocrio ♭♭6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaDisminuida, .septimaDisminuida,
        ],
        alias: ["alterada ♭♭6 ♭♭7"])
    /// Do Re Mi♭ Fa Sol♭ La♭ Si.
    public static let menorArmonicaQuintaDisminuida = TipoDeEscala(
        nombre: "menor armónica ♭5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaDisminuida, .sextaMenor, .septimaMayor,
        ])
    /// Do Re♭ Mi♭ Fa♭ Sol♭ La Si♭: la alterada con la 6ª mayor.
    public static let superlocrioSextaNatural = TipoDeEscala(
        nombre: "superlocrio ♮6",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaDisminuida,
            .quintaDisminuida, .sextaMayor, .septimaMenor,
        ],
        alias: ["alterada ♮6"])
    /// Do Re Mi♭ Fa Sol♯ La Si.
    public static let menorMelodicaQuintaAumentada = TipoDeEscala(
        nombre: "menor melódica ♯5",
        intervalos: [
            .unisono, .segundaMayor, .terceraMenor, .cuartaJusta,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ],
        alias: ["menor de jazz ♯5"])
    /// Do Re♭ Mi♭ Fa♯ Sol La Si♭.
    public static let doricoSegundaMenorCuartaAumentada = TipoDeEscala(
        nombre: "dórico ♭2 ♯4",
        intervalos: [
            .unisono, .segundaMenor, .terceraMenor, .cuartaAumentada,
            .quintaJusta, .sextaMayor, .septimaMenor,
        ],
        alias: ["dórico ♭9 ♯11"])
    /// Do Re Mi♯ Fa♯ Sol♯ La Si.
    public static let lidioAumentadoTerceraAumentada = TipoDeEscala(
        nombre: "lidio aumentado ♯3",
        intervalos: [
            .unisono, .segundaMayor, .terceraAumentada, .cuartaAumentada,
            .quintaAumentada, .sextaMayor, .septimaMayor,
        ])
}
